#!/usr/bin/env bash
set -euo pipefail

# One-file deploy launcher: load env, scrub, push, verify (A path) - simplified to single file for double-click deployment
WORKSPACE_DIR="/home/mangopi/.openclaw/workspace"
ENV_FILE="$WORKSPACE_DIR/secrets/.env"
SCRIPT_PUSH="$WORKSPACE_DIR/scripts/push-prod.sh"
SCRIPT_SCRUB="$WORKSPACE_DIR/scripts/b_scrub_run.sh"
RUN_ALL_FLAG="1" # placeholder to ensure run

# 1) Load secrets if exists
if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
fi

# 2) Basic checks for tokens
if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "ERROR: GITHUB_TOKEN is not set in environment" >&2
  echo "Please create/prepare secrets/.env with GITHUB_TOKEN" >&2
  exit 1
fi

# 3) Run scrub (best-effort; if script missing, skip gracefully)
if [ -x "$SCRIPT_SCRUB" ]; then
  "$SCRIPT_SCRUB"
else
  echo "WARNING: scrub script not found or not executable; continuing without scrub."
fi

# 4) Push to main using existing push-prod.sh (which loads env from secrets)
if [ -x "$SCRIPT_PUSH" ]; then
  "$SCRIPT_PUSH"
else
  echo "ERROR: push-prod.sh not found or not executable" >&2
  exit 1
fi

# 5) Verification guidance (no automatic external calls) - just hints
echo "Deployment trigger completed. Please check GitHub Actions Prod Deploy (Vercel) and Vercel Production URL." 

exit 0
