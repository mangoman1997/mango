# Production Deployment & Verification Report

## 1. 部署基本資訊
- **時間**: 2026-03-10
- **目標環境**: Vercel Production
- **觸發方式**: GitHub Actions `Prod Deploy (Vercel)` workflow via `onefile-prod-deploy.sh`
- **認證安全**: Token 不落地。使用 `GITHUB_TOKEN` / `ITHUB_TOKEN` 與 `VERCEL_TOKEN`，強制由 GitHub Secrets 注入以確保安全。

## 2. 變更特徵與防漏機制
- **防漏 (Scrub)**: 已套用自動檢查，確定未將 `.env` 推送至公共版控 (B-path scrub)。
- **雙重憑證策略**: 腳本支援優先讀取 `.env` 進行本地部屬操作，亦支援 CI 遠端派送。
- **分支對齊**: 解決了 `unrelated histories` 的衝突，以 Day3 測試版為主要合併對象，強制保留了 ECPay Webhook 的重要邏輯。

## 3. 自動化驗證步驟
為了確保正式環境能正確處理金流要求，請執行：
```bash
./scripts/run-prod-verify.sh
```
*註：執行前請確保在環境變數或檔案中設定 `PROD_URL=https://your-vercel-domain.vercel.app`。*

## 4. 緊急回滾計畫 (Rollback Plan)
如果發現 Webhook 嚴重報錯 (500) 或時區/加密失效：
1. 前往 **Vercel 控制台 > 專案 > Deployments**。
2. 找到倒數第二次狀態為 `Ready` 的成功佈署。
3. 點選最右側選單 `Promote to Production` 進行一秒退版。
4. 然後拉下修改重新推送修復。
