---
name: git-workflow
version: 1.0.0
description: "Git workflow: branches, PRs, merge strategies."
tags: [git, workflow, branches, pr, merge]
platforms: [linux, macos, windows]
author: Hermes Agent
license: MIT
---

# Git Workflow

Best practices untuk git workflow, branching, dan PR management.

## When to Use
- Working with git repositories
- Creating pull requests
- Managing branches
- Code review process

## Quick Reference
```bash
# Create feature branch
git checkout -b feature/my-feature

# Stage and commit
git add .
git commit -m "feat: add new feature"

# Push and create PR
git push origin feature/my-feature
gh pr create --title "My Feature" --body "Description"

# Sync with main
git fetch origin
git rebase origin/main
```

## Branch Naming
- `feature/description` — new features
- `fix/description` — bug fixes
- `hotfix/description` — urgent fixes
- `docs/description` — documentation
- `refactor/description` — code refactoring

## Commit Messages
```
type(scope): description

[optional body]

[optional footer]
```

Types: feat, fix, docs, style, refactor, test, chore

## Merge Strategies
1. **Merge commit** — preserves history
2. **Squash** — clean history for feature branches
3. **Rebase** — linear history

## PR Best Practices
1. Keep PRs small (< 500 lines)
2. Write clear description
3. Link to issue
4. Add tests
5. Request review

## Common Commands
```bash
# Interactive rebase
git rebase -i HEAD~5

# Cherry-pick
git cherry-pick <commit>

# Stash
git stash
git stash pop

# Reset
git reset --soft HEAD~1  # undo last commit, keep changes
git reset --hard HEAD~1  # undo last commit, discard changes
```

## Pitfalls
- Don't force push shared branches
- Don't commit directly to main
- Always pull before push
- Use .gitignore for sensitive files

## Verification
```bash
git status
git log --oneline -5
```