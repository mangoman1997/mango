#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="/home/mangopi/.openclaw/workspace"
REPO_URL="https://github.com/mangoman1997/mango.git"  # adjust if needed

cd "$WORKSPACE_DIR"

# 1) initialize git if not a repo
if [ ! -d ".git" ]; then
  git init
  git remote add origin "$REPO_URL"
else
  echo "Already a git repo at $WORKSPACE_DIR"
fi

# 2) fetch and checkout main from origin
git fetch origin --depth=1
git checkout -B main origin/main || git checkout -B main

# 3) add all current files and commit if there are changes
if ! git diff --quiet; then
  git add -A
  git commit -m "initial commit: setup OpenClaw deployment workspace" || true
fi

# 4) push to main with force-with-lease
if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
  echo "Pushing to origin/main (force-with-lease)"
  git push origin main --force-with-lease
else
  echo "Setting upstream and pushing..."
  git push -u origin main --force-with-lease || true
fi

echo "Initialization and push complete."
