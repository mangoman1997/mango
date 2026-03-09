# CI/CD Plan for Day 3 ShopperProxy
- Goals: Night-mode frontend, Live API integration, TC-001..TC-005, publication workflow.
- Workflow: Checkout -> Setup Node -> Install -> Test -> Build -> Deploy
- Secrets: Use GitHub Secrets (GITHUB_TOKEN, VERCEL_TOKEN, API keys)
- Rollback: If deployment fails, revert to previous tag; preserve logs
- Risks: API contract drift, timezone drift, network issues
