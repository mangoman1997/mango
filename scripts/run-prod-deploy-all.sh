#!/usr/bin/env bash
set -euo pipefail

# Unified one-shot: load env, scrub, push, verify deployment readiness
WORKSPACE_DIR="/home/mangopi/.openclaw/workspace"
SCRIPTS_DIR="$WORKSPACE_DIR/scripts"
ENV_FILE="$WORKSPACE_DIR/secrets/.env"

# 1) Load secrets from env file if available
if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
else
  echo "WARNING: $ENV_FILE not found. Will attempt to use existing environment variables." >&2
fi

# 2) Basic checks
if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "ERROR: GITHUB_TOKEN is not set in environment" >&2
  echo "Tip: ensure secrets/.env contains GITHUB_TOKEN and is loaded" >&2
  exit 1
fi

if [ -z "${VERCEL_TOKEN:-}" ]; then
  echo "NOTE: VERCEL_TOKEN not set. CI/CD will handle production deploy if configured." >&2
fi

# 3) Run local scrub (B path) to remove sensitive from latest commits
if [ -x "$SCRIPTS_DIR/b_scrub_run.sh" ]; then
  echo "Starting B-path scrub (local, minimal history scrub)"
  "$SCRIPTS_DIR/b_scrub_run.sh"
else
  echo "ERROR: scrub script not found or not executable: $SCRIPTS_DIR/b_scrub_run.sh" >&2
  exit 1
fi

# 4) Push main if possible
echo "Attempting to push cleaned main to remote..."
if [ -n "${GITHUB_TOKEN:-}" ]; then
  git push origin main --force-with-lease || echo "Push with force-with-lease failed. You may need to push via an alternative branch strategy." 
else
  echo "GITHUB_TOKEN not set; skipping push. Please push manually when token is available." 
fi

# 5) Trigger/guide deployment
if [ -n "${VERCEL_TOKEN:-}" ]; then
  echo "CI/CD (GitHub Actions) will trigger production deploy via Vercel. Check Actions tab for status." 
else
  echo "VERCEL_TOKEN not set; if using CI/CD, ensure deploy-prod.yml is configured."
fi

echo "Run-prod-deploy-all.sh completed."
