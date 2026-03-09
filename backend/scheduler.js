const fs = require('fs');

function runDailyCheck() {
  console.log('[Scheduler] Running Daily Check (Nightly Cleanup & Memory Sync) -- ' + new Date().toISOString());
  // Place holder for actual DB / Memory Cleanup Logic
}

function runE2ERunner() {
  console.log('[Scheduler] Triggering E2E Automated Tests -- ' + new Date().toISOString());
  // Place holder for actual E2E Test execution
}

// Simple interval-based loop instead of relying entirely on OS Crontab 
// This fits the mock server lifecycle
setInterval(runDailyCheck, 60 * 60 * 1000); // Hourly
setInterval(runE2ERunner, 24 * 60 * 60 * 1000); // Daily

console.log('[Scheduler] Scheduler Daemon Started. Registered DailyCheck(Hourly) and E2ERunner(Daily).');

module.exports = { runDailyCheck, runE2ERunner };
