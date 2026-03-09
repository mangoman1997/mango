#!/usr/bin/env bash
set -euo pipefail

# B-方案：快速 scrub 最近提交中的敏感檔案，保留歷史其餘內容
WORKDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$WORKDIR"
cd "$REPO_ROOT"

# 確認 secrets 已被清理，若還在的話就移除
if [ -f "secrets/.env" ]; then
  git rm --cached secrets/.env || true
fi
if [ -f "secrets/.env.template" ]; then
  git rm --cached secrets/.env.template || true
fi

# 確保 .gitignore 仍然存在
if [ ! -f .gitignore ]; then
  echo "secrets/" > .gitignore
  git add .gitignore
  git commit -m "chore: add secrets/ to .gitignore after scrub" || true
fi

# 提交清理工作
git add -A
git commit -m "cleanup: remove sensitive secrets from index (B-方案 quick scrub)" || true

# 推送到遠端 main，使用 --force-with-lease 以降低風險
git push origin main --force-with-lease || true

 echo "B-scrub completed: secrets removed from latest commits and pushed (if possible)." 
