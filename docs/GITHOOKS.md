# Git Hooks

Git hooks are scripts that are automatically run at various points in the Git cycle. You can do things such as automatically format code, send notifications, etc.

We use two, a `post-commit` and `pre-commit` which do what they sound like.

## Setup

1. From the app root, copy the contents of `githooks/` (besides `README.md`) to the `.git/hooks/` directory
2. Set them all to executable: `sudo chmod 755 .git/hooks/*`

## Descriptions

### Pre-Commit

**See:** `githooks/pre-commit`

Runs the ruby linter `rubocop` against all changed files and won't let you proceed if it can't automatically fix any violations.
