# Webhook EGPay (ECPay) Local Deployment Guide

Overview:
- Local webhook receiver (Node.js + Express) with optional signature verification.
- How to securely inject token for production deployment via CI/CD Secrets or local env files.

Local setup:
- Ensure Node.js 18+
- Create secrets/.env with GITHUB_TOKEN if using local push script

Deployment:
- For local push: run push-prod.sh (it reads GITHUB_TOKEN from env/.env)
- In CI/CD: configure Secrets and rely on deploy-prod.yml to perform prod deploy (replace placeholder with real cloud CLI steps)

Security:
- Do not commit secrets; use environment variables and GitHub Secrets
- Ensure only approved individuals can access secrets
