#!/usr/bin/env bash
set -euo pipefail

# Load environment variables from secrets if available
# Construct the absolute path to the .env file
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$WORKSPACE_DIR/secrets/.env"

if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
else
  echo "WARNING: $ENV_FILE not found. Relying on existing environment variables." >&2
fi

# TOKEN must come from environment, not hard-coded
if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "ERROR: GITHUB_TOKEN is not set in environment" >&2
  exit 1
fi

REPO_URL="https://github.com/mangoman1997/mango.git"
REMOTE="origin"

# Configure remote to use token securely (do not print token)
REMOTE_URL="https://${GITHUB_TOKEN}@${REPO_URL#https://}"
git remote set-url "$REMOTE" "$REMOTE_URL"

# Ensure we are on main and up-to-date
git fetch "$REMOTE" --prune
git checkout main

# Merge the release branch into main (adjust as needed)
git merge --no-ff trial/day3-release-demo -m "Merge day3 release demo into main for production deployment"

# Push to production (force if necessary by policy)
git push "$REMOTE" main --force

echo "Deployment push completed to main using token-based authentication."
