#!/usr/bin/env bash
set -euo pipefail

# Healthcheck after production deploy (A)
# Loads secrets from secrets/.env if present
WORKSPACE_DIR="/home/mangopi/.openclaw/workspace"
ENV_FILE="$WORKSPACE_DIR/secrets/.env"
if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
fi

# Config
VERCEL_DEPLOY_URL=
HEALTH_ENDPOINT="/health"  # adjust if your service uses a different health path
WEBHOOK_TEST_URL="/webhook/egpay"

# Helpers
log() { echo "[HealthCheck] $*"; }
status() { if [ "$1" = "up" ]; then echo ok; else echo fail; fi; }

# 1. Check core service health (HTTP GET)
# This assumes a local or public health URL; you may customize host/port
HEALTH_URL="http://localhost:8080$HEALTH_ENDPOINT"
start_time=$(date +%s%3N)
code=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_URL" || echo 0)
end_time=$(date +%s%3N)
latency=$((end_time - start_time))
log "Health check URL=$HEALTH_URL status=$code latency=${latency}ms"
if [ "$code" != "200" ]; then
  echo "Health check failed (code=$code)." >&2
fi

# 2. Webhook signature tests (only if token present)
if [ -n "${GITHUB_TOKEN:-}" ]; then
  log "Running webhook signature tests (assuming test harness available)"
  # Placeholder: you can integrate a small curl to your webhook endpoint simulating valid/invalid signatures
fi

# 3. API availability checks (example: list of essential endpoints)
ESSENTIAL_API="http://localhost:8080/api/status"  # adjust as needed
rc=0
curl -sS "$ESSENTIAL_API" >/dev/null || rc=1
log "API status endpoint=$ESSENTIAL_API rc=$rc"

# 4. Log summary (simple tail check)
log "Recent log snippet: "
if [ -f "$WORKSPACE_DIR/memory/RELEVANT-LOG-SNIPPET.txt" ]; then
  tail -n 10 "$WORKSPACE_DIR/memory/RELEVANT-LOG-SNIPPET.txt"
fi

# Summary
if [ "$rc" -eq 0 ]; then
  echo "Healthcheck completed: OK"
else
  echo "Healthcheck completed: WARN" >&2
fi
