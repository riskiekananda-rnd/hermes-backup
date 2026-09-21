#!/usr/bin/env bash
# Git status overview - quick dashboard for any git repo
# Usage: git_status.sh [directory]
set -euo pipefail

DIR="${1:-.}"

if [[ ! -d "$DIR/.git" ]]; then
    echo "ERROR: Not a git repository: $DIR"
    exit 1
fi

cd "$DIR"

echo "=== Git Status Overview ==="
echo "Repo: $(basename "$(pwd)")"
echo "Dir:  $(pwd)"
echo ""

# Branch info
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
REMOTE=$(git remote get-url origin 2>/dev/null || echo "no remote")
echo "Branch:  $BRANCH"
echo "Remote:  $REMOTE"
echo ""

# Ahead/behind
AHEAD=$(git rev-list --left-right --count "@{upstream}...HEAD" 2>/dev/null | cut -f1 || echo "?")
BEHIND=$(git rev-list --left-right --count "@{upstream}...HEAD" 2>/dev/null | cut -f2 || echo "?")
echo "Ahead:   ${AHEAD} commits"
echo "Behind:  ${BEHIND} commits"
echo ""

# Status summary
echo "=== Working Tree ==="
STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l)
MODIFIED=$(git diff --numstat 2>/dev/null | wc -l)
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)
STASH_COUNT=$(git stash list 2>/dev/null | wc -l)

printf "  Staged:    %3d\n" "$STAGED"
printf "  Modified:  %3d\n" "$MODIFIED"
printf "  Untracked: %3d\n" "$UNTRACKED"
printf "  Stashed:   %3d\n" "$STASH_COUNT"
echo ""

# Show untracked files (if any)
if (( UNTRACKED > 0 )); then
    echo "=== Untracked Files ==="
    git ls-files --others --exclude-standard | head -20
    echo ""
fi

# Show modified files (if any)
if (( MODIFIED > 0 )); then
    echo "=== Modified Files ==="
    git diff --name-only | head -20
    echo ""
fi

# Show staged files (if any)
if (( STAGED > 0 )); then
    echo "=== Staged Files ==="
    git diff --cached --name-only | head -20
    echo ""
fi

# Last commit
echo "=== Last Commit ==="
git log -1 --format="  %h %s (%ar)" 2>/dev/null || echo "  (no commits)"
echo ""

# Commit activity summary
echo "=== Recent Activity (7 days) ==="
COMMIT_COUNT=$(git log --oneline --since="7 days ago" 2>/dev/null | wc -l)
echo "  Commits in last 7 days: $COMMIT_COUNT"

# Show branches
echo ""
echo "=== Branches ==="
git branch -a 2>/dev/null | head -20
