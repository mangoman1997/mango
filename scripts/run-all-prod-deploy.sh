#!/usr/bin/env bash
set -euo pipefail

# One-shot: load env, scrub (B-path), push to main, and guide deployment verification
WORKSPACE_DIR="/home/mangopi/.openclaw/workspace"
ENV_FILE="$WORKSPACE_DIR/secrets/.env"

# Step 0: Load secrets if available
if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
else
  echo "WARNING: $ENV_FILE not found. Will attempt to use existing environment variables." >&2
fi

# Step 1: Basic checks for tokens
if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "ERROR: GITHUB_TOKEN is not set in environment" >&2
  exit 1
fi
if [ -z "${VERCEL_TOKEN:-}" ]; then
  echo "NOTE: VERCEL_TOKEN not set. Will rely on CI/CD to deploy to production." >&2
fi

# Step 2: Run B-path scrub (optional: ensure secrets are not in history)
if [ -x "$WORKSPACE_DIR/scripts/b_scrub_run.sh" ]; then
  echo "Running B-path scrub to remove secrets from latest commits..."
  "$WORKSPACE_DIR/scripts/b_scrub_run.sh"
else
  echo "WARN: b_scrub_run.sh not found or not executable; skipping scrub."
fi

# Step 3: Push to main using token (delegate to push-prod.sh which loads env securely)
if [ -x "$WORKSPACE_DIR/scripts/push-prod.sh" ]; then
  echo "Pushing to main with token-based authentication..."
  "$WORKSPACE_DIR/scripts/push-prod.sh" || true
else
  echo "ERROR: push-prod.sh not found or not executable" >&2
  exit 1
fi

# Step 4: Guidance for deployment verification in CI/CD (no automatic actions here)
 echo "\nNext steps:"
 echo "1) Go to GitHub Actions > Prod Deploy (Vercel) to monitor the deployment."
 echo "2) Open Vercel dashboard to confirm prod deployment and Production URL." 
 echo "3) Run the quick healthcheck against the prod URL (health endpoint / if available)."
 echo "4) Test webhook at /webhook/egpay with valid/invalid signatures to verify prod behavior."
 echo "If anything fails, you can use the rollback.sh script to trigger a rollback (see scripts/rollback.sh)."

 echo "Run-all-prod-deploy.sh completed."
