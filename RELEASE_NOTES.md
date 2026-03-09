# 發佈筆記 (Release Notes) - v1.0.0 (Day 3 穩定版) – 安全 TOKEN 推送與自動部署

## 新增/變更
- 本機推送腳本 push-prod.sh：從環境變數載入 GITHUB_TOKEN，組裝遠端 URL 從而推送 main，並合併 trial/day3-release-demo。
- 部署工作流 deploy-prod.yml：使用 GitHub Secrets 注入 TOKEN，於成功測試後執行生產部署（ placeholder 需替換成實際雲端 CLI 指令）。
- 說明文件更新：README-webhook-egpay.md 提供 TOKEN 安全使用與部署說明。

## TOKEN 安全要點
- TOKEN 不寫死在程式碼中，透過環境變數或 CI/CD Secrets 注入。
- 所有日誌中不輸出 TOKEN。

## 回滾策略
- 若生產環境出現嚴重問題，請透過 GitHub Actions 回滾到上一個穩定部署，或使用雲端服務提供的回滾機制。

---
