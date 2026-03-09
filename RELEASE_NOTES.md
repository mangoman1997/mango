# 發佈筆記 (Release Notes) - v1.0.0 (Day 3 穩定版)

## 發佈日期
2026-03-10

## 發佈摘要
本次發佈將 Day 3 的 RC1 轉為正式生產版本，主要完整補齊了綠界金流 (ECPay) Webhook 的接收與簽名驗證機制，並與 CI/CD (GitHub Actions + Vercel) 正式對接。

## 新增功能與異動
1. **ECPay Webhook 接收端 (`api/webhook-egpay.js`)**
   - 支援 POST `/webhook/egpay` 路由。
   - 實作 HMAC-SHA256 簽名驗證邏輯，防護偽造的金流回傳。
   - 增加 Payload 安全擷取與摘要日誌，利於後續審計。
2. **自動化測試防護網 (`api/webhook-egpay.test.js`)**
   - 新增 TC-001 ~ TC-005 覆蓋率，測試包含無簽名、無效簽名、空本體、額外欄位等邊界條件。
   - CI 部署前會強制執行 `npm test`，確保上線品質。
3. **佈署配置更新**
   - 應用程式已封裝為模組 (`module.exports = app;`)，完全相容於 Vercel 的 Serverless Function 環境。

## 環境變數要求 (請於生產環境設定)
- `ECPAY_WEBHOOK_SECRET`: 綠界提供之 HashKey/HashIV 生成的簽名密鑰 (必須設定，否則 webhook 將無法驗證請求)。

---

# 回滾計畫 (Rollback Plan)

若生產環境發生嚴重不可控錯誤 (如：Webhook 大量漏單、金流驗證全面失敗、服務 500 等)，請依下列步驟進行快速回滾：

## 觸發回滾的條件 (Thresholds)
- ECPay Webhook 發生連續 5 次以上的 500 Internal Server Error。
- 簽名驗證發現 100% 失敗 (可能為環境變數遺失或金流端演算法異動)。

## 回滾步驟
1. **Verce 快速退版 (Instant Rollback)**
   - 登入 Vercel Dashboard。
   - 進入專案 > Deployments。
   - 找到前一個穩定的部署版本 (Day 2 或 Day 3 初期未含 webhook 的版本)，點擊右側選單的 `Promote to Production` (或 `Assign Custom Domain` 將流量切回)。
2. **GitHub 代碼回退 (避免下次部署再錯)**
   - 執行指令：`git revert HEAD` (撤銷本次 Webhook 相關的 commit)。
   - 提交並 PUSH，觸發 CI 重新發佈一個安全版本。
3. **環境變數檢驗**
   - 檢查 GitHub Secrets 與 Vercel Environment Variables 裡的 `ECPAY_WEBHOOK_SECRET` 是否遭到竄改或失效。
4. **災後復原與對帳**
   - 若有漏失的訂單狀態，可透過綠界後台手動匯出該時段的成功交易明細，以批次/手動腳本將資料回補至系統。