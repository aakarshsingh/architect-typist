# Skill: review-code

## Tone

Always be extremely concise. Sacrifice grammar for brevity. No filler,
no preamble. Lead with the finding.

## Purpose

Independent code review. Structured, severity-ranked findings with a
clear verdict.

## Inputs

None required. Gathers its own context. Optionally reads
`.memory/style_guide.md` if present - applies project conventions but
does not depend on it.

## Process

### Step 1: Gather Context

Ask the architect:

> What should I review?
> 1. Staged changes (`git diff --staged`)
> 2. Unstaged changes (`git diff`)
> 3. All uncommitted changes (`git diff HEAD`)
> 4. Diff against a branch (specify name)
> 5. A specific PR (number or URL)
> 6. Specific files (provide paths)

Wait for answer. Gather diff. If empty, check `git log --oneline -5`
and ask which range.

### Step 2: Understand Scope

- Identify changed files and their purpose.
- Read FULL file for each - not just the diff. Understand imports,
  dependencies, call sites.
- Detect languages and frameworks in play.

### Step 3: Apply Checklist

Work CRITICAL to LOW. Only report at >80% confidence.

---

## Confidence Filter

- Report if >80% confident.
- Skip style opinions unless violating project conventions.
- Skip issues in unchanged code unless CRITICAL.
- Consolidate similar issues with a count.
- Prioritize bugs, vulnerabilities, data loss.

---

## Review Checklist

### CRITICAL - Security

- Hardcoded credentials in source
- SQL/HQL/JPQL injection - string concatenation with input
- Insecure deserialization - untrusted data without validation
- Path traversal - user-controlled paths unsanitized
- Auth bypass - missing auth/authz on protected endpoints
- Exposed secrets in logs - logging tokens, passwords, PII
- Insecure dependencies - known vulnerable versions
- XML External Entity (XXE) - unguarded XML parsing
- SSRF - user-controlled URLs in server-side requests
- Spring Security misconfiguration:
  - Open endpoints in SecurityFilterChain that should be protected
  - CSRF disabled without documented justification
  - Overly permissive CORS origins (wildcard in production)
  - Missing method-level security (@PreAuthorize, @Secured) on
    sensitive operations
  - Security filters in wrong order

### HIGH - Code Quality

- Large methods (>50 lines) - split
- Large classes (>800 lines) - extract
- Deep nesting (>4 levels) - early returns, extract helpers
- Missing error handling - empty catch, swallowed exceptions
- Catching overly broad exceptions (Exception, Throwable)
- Mutation of shared/passed-in state - prefer immutable
- Debug artifacts left in (System.out, printStackTrace)
- Missing tests for new code paths
- Dead code - unused imports, commented blocks, unreachable
- Race conditions - shared mutable state without sync

### HIGH - Core Java

- Mutable objects exposed via getters (return copy, not ref)
- Missing null checks at boundaries (or missing Optional)
- Resource leaks - streams, connections, readers not closed
  (use try-with-resources)
- Thread safety - non-synchronized shared collections
- Raw types - missing generics on collections/optionals
- Checked exceptions swallowed or wrapped without context
- Inefficient string concatenation in loops (use StringBuilder or
  String.join)
- Incorrect equals/hashCode contracts

### HIGH - Spring Boot

- Blocking calls in reactive pipelines (WebFlux)
- Overly broad bean scopes (singleton holding request state)
- Missing @Transactional where needed, or too broad a scope
- N+1 queries - missing fetch joins or @EntityGraph
- Unvalidated @RequestBody - missing @Valid or schema checks
- Missing @ControllerAdvice / global exception handling
- Exposed internal error details in API responses
- Missing rate limiting on public endpoints
- Circular dependencies between beans
- Missing profiles for environment-specific config
- Spring Data REST auto-exposing repositories - verify only intended
  entities are exposed; restrict with @RestResource(exported = false)

### HIGH - Infrastructure (Docker, CI, Terraform)

- Secrets in plaintext in config/compose/pipeline files
- Overly permissive IAM roles or security groups
- Missing resource limits (CPU, memory) in containers
- Untagged or unpinned base images / dependency versions
- Missing health checks in container definitions
- Terraform state containing secrets
- CI pipelines with write access broader than needed
- Missing environment separation (dev/staging/prod)

### MEDIUM - Performance

- Inefficient algorithms where better complexity exists
- Missing caching for repeated expensive operations
- Unbounded queries - no LIMIT, SELECT * on large tables
- N+1 patterns (any loop-based fetching, not just JPA)
- Missing timeouts on external HTTP/service calls
- Synchronous I/O blocking the main/request thread
- Unnecessary object allocation in hot paths

### LOW - Best Practices

- TODO/FIXME without ticket references
- Missing Javadoc on public API methods
- Poor naming - single-letter vars in non-trivial scope
- Magic numbers without named constants
- Inconsistent style within the changed code
- Missing modern Java idioms where they improve clarity: records,
  sealed classes, pattern matching, text blocks, switch expressions,
  Optional chains
- Collection operations using manual loops where Streams would be
  clearer - bump to MEDIUM if the Stream alternative also improves
  performance (e.g., parallel stream on large datasets, avoiding
  intermediate collections)

---

## Output Format

Per finding:

```
[SEVERITY] Short description
File: path/to/file:line
Issue: What's wrong. Why it matters.
Fix: Concrete suggestion.
```

## Review Summary

End every review with:

```
| Severity | Count | Status |
|----------|-------|--------|
| CRITICAL | 0     | pass   |
| HIGH     | 0     | pass   |
| MEDIUM   | 0     | info   |
| LOW      | 0     | note   |

Verdict: [APPROVE | WARNING | BLOCK]
```

- **APPROVE** - No CRITICAL or HIGH.
- **WARNING** - HIGH only. List items to address.
- **BLOCK** - CRITICAL found. Must fix.

---

## Learning (Optional)

If the architect corrects a finding or clarifies a project convention
during this review, append the convention to `.memory/style_guide.md`
under "Learned Quirks."

If `.memory/` directory doesn't exist, create it and add to
`.gitignore`:
```
.memory/*
!.memory/style_guide.md
```

Respect the 200-line cap.
