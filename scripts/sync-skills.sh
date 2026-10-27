#!/usr/bin/env bash
# Install skills/*.md for Claude Code as <dest>/<prefix>-<slot>-<name>/SKILL.md.
# Usage: scripts/sync-skills.sh [dest]   (default dest: ~/.claude/skills)
# Env:   SKILL_PREFIX (default: as)
set -euo pipefail

src="$(cd "$(dirname "$0")/.." && pwd)/skills"
dest="${1:-$HOME/.claude/skills}"
prefix="${SKILL_PREFIX:-as}"
installed=()

for f in "$src"/*.md; do
  name=$(basename "$f" .md)
  slot=$(sed -n 's/^  slot: *//p' "$f" | head -n 1)
  if [ -z "$slot" ]; then
    echo "skip $name: no metadata.slot" >&2
    continue
  fi
  id="$prefix-$slot-$name"
  mkdir -p "$dest/$id"
  # Rewrite only the first name: line, so the installed name matches its folder.
  awk -v id="$id" '!done && /^name: /{print "name: " id; done=1; next} {print}' \
    "$f" > "$dest/$id/SKILL.md"
  installed+=("$id")
  echo "installed $id"
done

# Report, but never delete, installed skills this repo no longer ships.
for d in "$dest/$prefix"-*/; do
  [ -d "$d" ] || continue
  id=$(basename "$d")
  case " ${installed[*]} " in
    *" $id "*) ;;
    *) echo "stale $id: not in this repo, remove it by hand" >&2 ;;
  esac
done
