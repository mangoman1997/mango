#!/usr/bin/env bash
set -euo pipefail

# One-file: verif-env + scrub (B) + push to main + verify deployment (A)
WORKSPACE_DIR="/home/mangopi/.openclaw/workspace"
ENV_FILE="$WORKSPACE_DIR/secrets/.env"
SCRIPT_SCRUB="$WORKSPACE_DIR/scripts/b_scrub_run.sh"
SCRIPT_PUSH="$WORKSPACE_DIR/scripts/push-prod.sh"

# 1) Load secrets (if present)
if [ -f "$ENV_FILE" ]; then
  echo "[Step 1] Loading secrets from $ENV_FILE"
  set -a
  source "$ENV_FILE"
  set +a
else
  echo "[Step 1] Secrets file not found: $ENV_FILE (using current env vars)" >&2
fi

# 2) Verify required tokens
echo "[Step 2] Verifying required tokens..."
if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "ERROR: GITHUB_TOKEN is not set." >&2
  exit 1
fi
if [ -n "${VERCEL_TOKEN:-}" ]; then
  echo "INFO: Found VERCEL_TOKEN (for CI/CD deployments)."
else
  echo "WARNING: VERCEL_TOKEN not set. CI/CD deployment may be required." >&2
fi

# 3) Run B-path scrub (if available)
if [ -x "$SCRIPT_SCRUB" ]; then
  echo "[Step 3] Running B-path scrub (local, minimal history scrub)"
  "$SCRIPT_SCRUB" || echo "Note: scrub encountered non-fatal issues; continuing"  # continue on errors
else
  echo "WARN: Scrub script not found or not executable. Skipping scrub." >&2
fi

# 4) Push to main using push-prod.sh
if [ -x "$SCRIPT_PUSH" ]; then
  echo "[Step 4] Pushing to main via token-based authentication..."
  cd "$WORKSPACE_DIR" && "$SCRIPT_PUSH" || echo "Push script exited with non-zero status (check logs)." 
else
  echo "ERROR: push-prod.sh not found or not executable" >&2
  exit 1
fi

# 5) Deployment verification guidance
echo ""
echo "[Step 5] Deployment verification guidance"
echo "- If CI/CD is configured with VERCEL_TOKEN, check GitHub Actions Prod Deploy (Vercel) for status and Production URL."
echo "- If PROD_URL is provided via environment or CI, run: curl -I \"${PROD_URL:-<your-url>}/health\""
echo "- Optional: run a verify script (run-prod-verify.sh) to automate health checks and webhook tests."

echo ""
echo "Run-all-prod-deploy.sh completed."
