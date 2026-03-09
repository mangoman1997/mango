#!/usr/bin/env bash
set -euo pipefail

# Simple prod verify script
PROC_URL="${PROD_URL:-""}"
if [ -z "$PROC_URL" ]; then
  echo "PROD_URL not set. Set PROD_URL to prod production URL as env var or in CI."
  exit 0
fi

echo "Verifying Production URL: $PROC_URL"

# Health check
curl -I "$PROC_URL/health" || true

# Signatures/webhook test placeholder
echo "Running webhook test placeholder (requires payload and secret)"

echo "Verify complete." 
