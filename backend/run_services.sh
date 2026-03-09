#!/bin/bash
echo 'Starting ShopperProxy Backend Services...'
node /home/mangopi/.openclaw/workspace/backend/scheduler.js >> /home/mangopi/.openclaw/workspace/backend/scheduler.log 2>&1 &
echo 'Scheduler started.'
# Assuming mock_server is already running via the persistent tool call, otherwise we'd start it here.
