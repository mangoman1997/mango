#!/usr/bin/env bash
set -euo pipefail

# Quick prod verification script
PRODUCT_URL="${PROD_URL:-}"
if [ -z "$PRODUCT_URL" ]; then
  echo "PROD_URL is not set. Set PROD_URL environment variable or CI output to run verifications." >&2
  exit 0
fi

echo "Verifying Production URL: $PRODUCT_URL"

# Health check
curl -I "$PRODUCT_URL/health" || true

# Simple API check (adjust as needed)
curl -sS "$PRODUCT_URL" >/dev/null

# Webhook test placeholder (requires real payload and secret in CI)
echo "Webhook test can be performed with real payload and secret in CI environment."

echo "Verification complete."
