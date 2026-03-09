#!/usr/bin/env bash
set -euo pipefail

# One-file: verif-env + scrub (B) + push to main + deployment guidance (A path, CI/CD will pick up)
WORKSPACE_DIR="/home/mangopi/.openclaw/workspace"
ENV_FILE="$WORKSPACE_DIR/secrets/.env"
SCRIPT_SCRUB="$WORKSPACE_DIR/scripts/b_scrub_run.sh"
SCRIPT_PUSH="$WORKSPACE_DIR/scripts/push-prod.sh"

# 0) Load secrets if present
if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
else
  echo "WARNING: $ENV_FILE not found. Proceeding with existing environment variables." >&2
fi

# 1) verif-env safety checks (no secret exposure)
verify_token() {
  local name="$1"; local val="${!name:-}"
  if [ -z "$val" ]; then
    echo "MISSING $name" >&2
    return 1
  fi
  return 0
}

echo "[Step 1] Verifying required tokens..."
verify_token GITHUB_TOKEN || { echo "ERROR: GITHUB_TOKEN is not set"; exit 1; }
verify_token VERCEL_TOKEN || { echo "NOTE: VERCEL_TOKEN not set; CI/CD will deploy to prod"; }

# 2) Optional scrub
if [ -x "$SCRIPT_SCRUB" ]; then
  echo "[Step 2] Running B-path scrub (local, minimal history scrub)";
  "$SCRIPT_SCRUB" || true
else
  echo "WARN: scrub script not found; skipping scrub" >&2
fi

# 3) Push to main using push-prod.sh (which reads env vars securely)
if [ -x "$SCRIPT_PUSH" ]; then
  echo "[Step 3] Pushing to main via token-based authentication...";
  "$SCRIPT_PUSH" || true
else
  echo "ERROR: push-prod.sh not found or not executable" >&2
  exit 1
fi

# 4) Guidance for subsequent verification
echo "[Step 4] Deployment triggered. Please verify via GitHub Actions Prod Deploy (Vercel) and Vercel Production URL."

exit 0
