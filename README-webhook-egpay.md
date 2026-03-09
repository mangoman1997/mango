# Webhook EGPay (ECPay) - Production Deployment Guide

Overview:
- Production deployment via GitHub Actions Prod Deploy (Vercel)
- Secrets are injected via CI/CD (GITHUB_TOKEN, VERCEL_TOKEN)
- Verification steps post-deploy

How to verify after production deploy:
1) Retrieve Production URL from Vercel Dashboard.
2) Run health checks against /health if available.
3) Test /webhook/egpay with valid and invalid signatures.
4) Confirm dashboards and logs show latest events.

Security:
- Never expose secrets in logs.
- Rotate tokens regularly.

Release Notes:
- See RELEASE_NOTES.md for deployment details.
