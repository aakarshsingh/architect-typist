# Mock Session: Adding RBAC to a Spring Boot API

This document walks through a realistic session using the
Architect-Typist workflow. The feature is non-trivial: adding
role-based access control to an existing Spring Boot REST API that
currently has authentication but no authorization.

**Conventions used below:**
- `ARCHITECT:` - the human
- `AGENT:` - the AI typist
- `[action]` - what the agent does silently
- Lines in the `.memory/` blocks show the files as they'd actually
  be written

---

## Phase 0: init-workspace

The architect opens a terminal in the project root and starts a new
agent session.

> **ARCHITECT:** `/init-workspace`

```
AGENT: [scans repo structure]

Found:
- Spring Boot 3.2 / Java 21 / Gradle
- src/main/java/com/acme/api/ - 14 controllers, 9 services
- src/test/java/ - 43 test files, JUnit 5 + Mockito
- Spring Security present (SecurityConfig.java) - currently
  permits all authenticated users on all endpoints
- PostgreSQL + Flyway migrations
- CI: GitHub Actions, runs ./gradlew check

Questions:
1. Naming: I see camelCase methods, PascalCase classes,
   kebab-case REST paths. Confirm these are intentional?
2. Test style: tests use @SpringBootTest for integration,
   @ExtendWith(MockitoExtension) for unit. Continue this
   split?
3. Flyway migrations use V{n}__{description}.sql format.
   Continue numbering from V14?

ARCHITECT: Yes to all. Latest migration is V14.

AGENT: [writes .memory/style_guide.md]
```

**`.memory/style_guide.md` (created):**
```markdown
# Style Guide

## Tone
Be extremely concise. Sacrifice grammar for brevity.

## Project Topography
- Structure: standalone Spring Boot API
- Language: Java 21
- Build: Gradle 8.x (./gradlew)
- DB: PostgreSQL + Flyway (V{n}__{description}.sql, next: V15)
- Auth: Spring Security 6.x, currently authn only, no authz

## Naming Conventions
- Files/Classes: PascalCase
- Methods/Fields: camelCase
- REST paths: kebab-case (/api/v1/user-profiles)
- Constants: UPPER_SNAKE_CASE

## Patterns & Idioms
- Controller → Service → Repository layering
- DTOs for API boundaries, entities for persistence
- MapStruct for entity↔DTO mapping
- @ControllerAdvice for global exception handling (GlobalExceptionHandler.java)

## Tooling & Commands
- Build: ./gradlew build
- Test: ./gradlew test
- Lint: ./gradlew checkstyleMain
- Format: ./gradlew spotlessApply

## Learned Quirks
(none yet)
```

---

## Phase 1: scope-work

> **ARCHITECT:** `/scope-work` - I want to add role-based access
> control. Users should have roles (ADMIN, MANAGER, VIEWER), and
> endpoints should be restricted based on role. Currently every
> authenticated user can do everything.

```
AGENT: Got it. Let me resolve the scope.

1. Role storage: new DB table, or roles embedded in the User entity?
   Recommend: separate roles table with many-to-many join - more
   flexible, standard RBAC pattern.

2. Role assignment: who assigns roles? Admin-only endpoint, or
   seed data, or both?
   Recommend: Admin-only endpoint + Flyway seed for initial admin.

3. Endpoint mapping: do you have a matrix of which roles access
   which endpoints, or should I propose one?

4. Existing users: what role do current users get during migration?
   Recommend: VIEWER as safe default, one designated ADMIN via seed.

5. Token format: are roles included in the JWT, or looked up per
   request?
   Recommend: include in JWT claims to avoid DB round-trip on every
   request. Re-issue on role change.

ARCHITECT:
1. Separate table, agreed.
2. Admin endpoint + seed. Only ADMIN can assign roles.
3. Propose a matrix, I'll review.
4. VIEWER default, seed me as ADMIN (user: admin@acme.com).
5. JWT claims, agreed. But also cache lookup as fallback for
   immediate role changes without waiting for token refresh.

AGENT: Understood. One more:

6. Should MANAGER be able to do everything VIEWER can, plus write
   ops? i.e., hierarchical roles (ADMIN > MANAGER > VIEWER)?
   Recommend: yes, hierarchical. Simpler mental model.

ARCHITECT: Yes, hierarchical.

AGENT: [writes .memory/requirements.md]
```

**`.memory/requirements.md` (created):**
```markdown
# Requirements: Role-Based Access Control (RBAC)

## Purpose
Add authorization to the existing authenticated API. Users are
assigned roles (ADMIN > MANAGER > VIEWER, hierarchical). Endpoints
are restricted by role.

## Definition of Done
- [ ] Roles table exists with many-to-many join to users
- [ ] Migration seeds admin@acme.com as ADMIN, existing users as VIEWER
- [ ] Roles included in JWT claims on login
- [ ] Cached role lookup as fallback for immediate role changes
- [ ] All endpoints enforce role checks per the approved matrix
- [ ] Admin-only endpoint for role assignment (POST /api/v1/users/{id}/roles)
- [ ] Non-admin users cannot escalate roles
- [ ] Existing tests still pass
- [ ] New tests cover role enforcement (positive and negative cases)

## Decisions & Options
| Decision | Chosen | Alternatives | Rationale |
|----------|--------|-------------|-----------|
| Role storage | Separate table + join | Embedded in user | Flexibility, standard RBAC |
| Role hierarchy | ADMIN > MANAGER > VIEWER | Flat roles | Simpler mental model |
| Token strategy | JWT claims + cache fallback | DB lookup per request | Performance + immediacy |
| Default role | VIEWER | None / MANAGER | Least privilege |
| Role assignment | Admin-only endpoint | Self-service / seed only | Security + usability |

## Constraints
- Must NOT break existing authentication flow
- Must NOT change existing API response formats
- Must preserve backward compatibility for API consumers
- Must use Flyway for all schema changes

## References
- SecurityConfig.java - current security setup
- UserEntity.java - current user model
- GlobalExceptionHandler.java - error response pattern
```

---

## Phase 2: draft-design

> **ARCHITECT:** `/draft-design`

```
AGENT: [reads requirements.md and style_guide.md]
       [scans src/test/ - 43 test files, JUnit 5 + Mockito,
        existing SecurityConfig tests]

Architecture draft:

## Module Breakdown
| Module | Responsibility | New/Modified |
|--------|---------------|-------------|
| RoleEntity + UserRoleEntity | Domain model | New |
| RoleRepository | Data access | New |
| RoleService | Role CRUD + assignment | New |
| RoleCacheService | In-memory role cache | New |
| JwtTokenProvider | Add roles to claims | Modified |
| SecurityConfig | Method-level @PreAuthorize | Modified |
| RoleController | Admin role assignment API | New |
| V15 migration | roles + user_roles tables + seed | New |

## Data Flow
1. Login → JwtTokenProvider reads roles from DB → embeds in JWT
2. Request → SecurityFilter extracts JWT → resolves roles from
   claims (cache fallback if token stale)
3. @PreAuthorize on controller methods checks role hierarchy

## Endpoint Matrix
| Endpoint Pattern | VIEWER | MANAGER | ADMIN |
|-----------------|--------|---------|-------|
| GET /api/v1/** | yes | yes | yes |
| POST/PUT /api/v1/** | no | yes | yes |
| DELETE /api/v1/** | no | no | yes |
| ** /api/v1/users/*/roles | no | no | yes |
| GET /api/v1/admin/** | no | no | yes |

## Test Strategy
Found 43 existing test files, JUnit 5 + Mockito, good coverage
on service layer. SecurityConfig has basic auth tests.

Recommend: **Extend existing tests.**
- Unit tests for RoleService, RoleCacheService
- Integration tests for RoleController
- Security tests for endpoint matrix (parameterized: role × endpoint)
- Modify existing SecurityConfig tests for new role checks

## DoD Traceability
| DoD Item | Component |
|----------|-----------|
| Roles table | V15 migration + RoleEntity |
| Seed data | V15 migration |
| JWT claims | JwtTokenProvider (modified) |
| Cache fallback | RoleCacheService |
| Endpoint enforcement | SecurityConfig + @PreAuthorize |
| Role assignment API | RoleController + RoleService |
| No escalation | RoleService validation |
| Existing tests pass | All phases verify |
| New role tests | Phase 0 + each phase |

ARCHITECT: The endpoint matrix looks right. One change - MANAGER
should be able to DELETE their own resources, not all deletes.
Can we do resource-level ownership checks?

AGENT: That adds complexity. Two options:
1. Simple: MANAGER can DELETE on all endpoints (same as PUT/POST)
2. Ownership: MANAGER can DELETE only resources they created. Needs
   a createdBy field on entities.

Recommend option 1 for this iteration. Ownership checks can be a
follow-up feature - it's a different concern (resource-level authz
vs role-level authz).

ARCHITECT: Agreed, option 1. MANAGER gets full CRUD except admin
endpoints. Approved.

AGENT: [writes .memory/architecture_decisions.md]
```

---

## Phase 3: plan-phases

> **ARCHITECT:** `/plan-phases`

```
AGENT: [reads all .memory/ files]

Execution plan - 6 phases:

| Phase | Name | Target Files | Status |
|-------|------|-------------|--------|
| 0 | Test infrastructure for RBAC | 2 files | Pending |
| 1 | DB migration + domain model | 4 files | Pending |
| 2 | Role service + cache | 3 files | Pending |
| 3 | JWT integration | 2 files | Pending |
| 4 | Security config + endpoint enforcement | 2 files | Pending |
| 5 | Role assignment API | 3 files | Pending |

Phase 0 is test infra (extend existing) per approved strategy.
Each phase: 2-4 target files, independently verifiable.

ARCHITECT: Looks good. Go.
```

**`.memory/execution_plan.md`** is written with full phase details,
self-audit checklists, and empty completion records.

---

## Phase 4: exec-phase (repeated per phase)

The architect starts a **new session** for each phase.

### Executing Phase 0 (Test Infrastructure)

> **ARCHITECT:** `/exec-phase`

```
AGENT: [silently reads all .memory/ files]
       [identifies Phase 0 as next pending]
       [marks Phase 0 as Active]

Phase 0: Test Infrastructure for RBAC

Target files:
- src/test/java/.../security/RbacTestBase.java (create)
- src/test/java/.../security/EndpointSecurityTest.java (create)

Implementing...

[creates RbacTestBase.java - base class with test users per role,
 MockMvc setup, JWT helper methods]
[creates EndpointSecurityTest.java - parameterized test skeleton
 that will verify role × endpoint matrix. Currently all tests
 marked @Disabled until endpoints are enforced]

Verification:
✓ ./gradlew test - 43 existing tests pass, 2 new files compile,
  @Disabled tests skipped as expected
✓ ./gradlew checkstyleMain - clean

Self-audit: all items checked.

Phase 0: Test Infrastructure - COMPLETED
Files staged: RbacTestBase.java, EndpointSecurityTest.java
Tests: 43 pass / 0 fail / 12 skipped (new parameterized, expected)
Quirks learned: none
Next phase: Phase 1 - DB migration + domain model
```

> **ARCHITECT:** [reviews diff, commits] `/exec-phase`

### Executing Phase 1 (DB Migration + Domain)

New session started.

```
AGENT: [reads .memory/, finds Phase 1 pending]

Phase 1: DB migration + domain model

Target files:
- src/main/resources/db/migration/V15__add_roles_and_user_roles.sql (create)
- src/main/java/.../entity/RoleEntity.java (create)
- src/main/java/.../entity/UserRoleEntity.java (create)
- src/main/java/.../entity/UserEntity.java (modify - add roles relation)

Implementing...
[writes V15 migration: roles table, user_roles join table,
 seed ADMIN for admin@acme.com, VIEWER for all existing users]
[creates RoleEntity, UserRoleEntity]
[modifies UserEntity - adds @ManyToMany roles field]

Verification:
✓ ./gradlew test - 43 + 2 pass (migration applies in test context)
✓ Checkstyle clean

Phase 1 - COMPLETED
Files staged: V15 migration, RoleEntity, UserRoleEntity, UserEntity
Tests: 45 pass / 0 fail / 12 skipped
Next: Phase 2
```

### Phases 2-4 proceed similarly...

---

## Mid-Flight Pivot (during Phase 4)

During Phase 4 (Security Config), the agent detects a problem:

```
AGENT: **Divergence detected in Phase 4.**

What happened: SecurityConfig uses antMatchers for path-based
rules, but the app has migrated to Spring Security 6.2 which
uses requestMatchers. The architecture doc assumed antMatchers.

What I expected: antMatchers API available.
What I found: antMatchers removed in Spring Security 6.2.

Root cause: Architecture decisions were based on Spring Security
6.0 patterns. The actual version is 6.2.

Recommendation: Invoke pivot-plan. The change is contained to
Phase 4 (SecurityConfig only), but the implementation approach
needs revision.
```

> **ARCHITECT:** Good catch. This is just a Phase 4 rewrite, not a
> full pivot. Update Phase 4 to use requestMatchers and continue.

```
AGENT: Understood. Updating Phase 4 target implementation to use
requestMatchers + AuthorizationManager pattern.

[continues Phase 4 with corrected approach]
[updates style_guide.md Learned Quirks:
 "2024-01-15: Spring Security 6.2 - use requestMatchers, not
  antMatchers. AuthorizationManager replaces AccessDecisionManager."]

Phase 4 - COMPLETED
```

This is an example of a divergence that didn't require a full pivot
- the architect made a judgment call to adjust in-place rather than
invoking `pivot-plan`.

---

## Phase 5: wrap-up

After all 6 phases are complete:

> **ARCHITECT:** `/wrap-up`

```
AGENT: [reads all .memory/ files]

Step 1 - Phase completion: All 6 phases Completed. ✓
Step 2 - Requirements DoD:
  ✓ Roles table exists
  ✓ Migration seeds admin + VIEWER defaults
  ✓ JWT claims include roles
  ✓ Cache fallback implemented
  ✓ All endpoints enforce roles per matrix
  ✓ Admin-only role assignment endpoint
  ✓ Escalation prevention in RoleService
  ✓ Original 43 tests pass
  ✓ 18 new tests cover role enforcement
  All DoD items verified. ✓

Step 3 - Integration check:
  ./gradlew check - BUILD SUCCESSFUL
  61 tests pass, 0 fail. ✓

Step 4 - Diff review:
  Files created: 8
  Files modified: 3
  Lines: +847 / -12
  All files within phase target lists. ✓

Step 5 - Archived to .memory/archive/feature/rbac/
Step 6 - Style guide: 34 lines, under cap. No pruning needed.
Step 7 - Files staged. Draft commit message:

  feat: add role-based access control (RBAC)

  Adds ADMIN/MANAGER/VIEWER role hierarchy with JWT claims,
  cache fallback, endpoint enforcement, and admin role
  assignment API. Includes Flyway migration and 18 new tests.

## Wrap-Up Complete

Feature: RBAC
Phases completed: 6
Files changed: 11
Tests: 61 pass / 0 fail
Requirements DoD: all met
Archive: .memory/archive/feature/rbac/
Style guide: 34 lines, unchanged

### Suggested PR Summary (draft)
Adds hierarchical RBAC (ADMIN > MANAGER > VIEWER) to the API.
Roles stored in DB, embedded in JWT claims with cache fallback
for immediate updates. All existing endpoints enforce role checks.
Admin-only role assignment endpoint included.

Ready for commit. Waiting for architect instruction.
```

> **ARCHITECT:** Commit and push.
> **AGENT:** [commits, pushes]
> **ARCHITECT:** [creates PR]

---

## Key Observations

1. **The agent never committed autonomously.** Every commit was
   explicitly authorized by the architect.
2. **The divergence in Phase 4 was caught by self-audit**, not by the
   human. The agent stopped and reported rather than silently working
   around the API change.
3. **Context was never lost.** Each phase started fresh but the
   `.memory/` files provided complete continuity.
4. **The style guide grew organically.** The Spring Security quirk
   discovered in Phase 4 is now captured for future work.
5. **The full feature took 6 phases, each independently verifiable.**
   If any phase had failed, the damage was contained to that slice.
