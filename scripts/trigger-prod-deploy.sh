#!/usr/bin/env bash
set -euo pipefail

# Trigger Prod Deploy (GitHub Actions) via GitHub API (workflow_dispatch)
# This script uses a GitHub token loaded from environment or from secrets/.env

WORKSPACE_DIR="/home/mangopi/.openclaw/workspace"
ENV_FILE="$WORKSPACE_DIR/secrets/.env"

# Load secrets if available
if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
fi

# Token selection
TOKEN="${GITHUB_TOKEN:-${ITHUB_TOKEN:-}}"
if [ -z "$TOKEN" ]; then
  echo "ERROR: GitHub token not found (GITHUB_TOKEN or ITHUB_TOKEN)" >&2
  exit 1
fi

# Required repo info
OWNER="your-org"          # TODO: set your GitHub org or user
REPO="your-repo"           # TODO: set your repository
WORKFLOW_ID=""               # TODO: provide workflow_id or set WORKFLOW_ID env var
REF="main"                    # default branch to dispatch

# If you provided workflow filename, try to map to id is not supported directly; require WORKFLOW_ID
if [ -z "$WORKFLOW_ID" ]; then
  echo "ERROR: WORKFLOW_ID not set. Please export WORKFLOW_ID or set environment variable. The workflow file name is not sufficient for dispatch."
  echo "Suggestion: export WORKFLOW_ID=<your-workflow-id> and re-run."
  exit 1
fi

URL="https://api.github.com/repos/$OWNER/$REPO/actions/workflows/$WORKFLOW_ID/dispatches"
DATA=$(cat <<JSON
{ "ref": "$REF" }
JSON
)

echo "[Trigger] Dispatching workflow $WORKFLOW_ID for ref $REF in $OWNER/$REPO"
curl -sS -X POST -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" \
  -d "$DATA" "$URL" | tee /tmp/gh_dispatch_response.json

echo "Dispatch response:"; cat /tmp/gh_dispatch_response.json

echo "Done. If needed, check GitHub Actions UI for the dispatched run."