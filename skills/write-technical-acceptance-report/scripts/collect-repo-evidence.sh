#!/usr/bin/env bash
set -euo pipefail

repo_path="${1:-.}"

if ! git -C "$repo_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "not a Git worktree: $repo_path" >&2
  exit 2
fi

echo "# Repository acceptance inventory"
echo
echo "## Identity"
git -C "$repo_path" status --short --branch
git -C "$repo_path" log -1 --format='commit=%H%ncommitted_at=%cI%nsubject=%s'

echo
echo "## Unstaged change summary"
git -C "$repo_path" diff --stat
git -C "$repo_path" diff --name-status

echo
echo "## Staged change summary"
git -C "$repo_path" diff --cached --stat
git -C "$repo_path" diff --cached --name-status

echo
echo "## Whitespace integrity"
if git -C "$repo_path" diff --check; then
  echo "diff_check=pass"
else
  echo "diff_check=fail"
fi

echo
echo "## Instruction and test entrypoint candidates"
if command -v rg >/dev/null 2>&1; then
  rg --files -uu "$repo_path" \
    -g 'AGENTS.md' -g 'CLAUDE.md' -g 'CONTRIBUTING.md' \
    -g 'Makefile' -g 'package.json' -g 'pyproject.toml' \
    -g 'Cargo.toml' -g 'go.mod' -g '*spec*.md' -g '*plan*.md' \
    -g '!node_modules' -g '!vendor' -g '!.git' | sort
else
  find "$repo_path" -type f \
    \( -name AGENTS.md -o -name CLAUDE.md -o -name CONTRIBUTING.md \
    -o -name Makefile -o -name package.json -o -name pyproject.toml \
    -o -name Cargo.toml -o -name go.mod \) -print | sort
fi
