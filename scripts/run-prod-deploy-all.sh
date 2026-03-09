#!/usr/bin/env bash
set -euo pipefail

# Resolve workspace path
WORKSPACE_DIR="/home/mangopi/.openclaw/workspace"
SCRIPTS_DIR="$WORKSPACE_DIR/scripts"
ENV_FILE="$WORKSPACE_DIR/secrets/.env"

# Step 0: Load secrets from env file if present
if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
else
  echo "WARNING: $ENV_FILE not found. Will try to use existing environment variables." >&2
fi

# Step 1: Validate required tokens
if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "ERROR: GITHUB_TOKEN is not set in environment. Please set via secrets/.env or export." >&2
  exit 1
fi
if [ -z "${VERCEL_TOKEN:-}" ]; then
  echo "WARNING: VERCEL_TOKEN is not set. If you rely on CI/CD, this can be provided by secrets." >&2
fi

# Step 2: Run local push to merge and push main using token
bash "$SCRIPTS_DIR/push-prod.sh"

# Step 3: Inform about CI/CD deployment status
if [ -n "${VERCEL_TOKEN:-}" ]; then
  echo "Next: GitHub Actions will deploy to production via Vercel when main is updated. Check Actions tab for deployment status."
else
  echo "Note: VERCEL_TOKEN not set; CI/CD deployment will be required to deploy to production."
fi

echo "Run-prod-deploy-all completed."
