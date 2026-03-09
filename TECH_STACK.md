# 蝦代購 (ShopperProxy) - 技術棧與設計草案

版本：Day 3 進度草案

1) 前端技術
- 框架/語言：Next.js (React) + TypeScript
- UI/UIX：Tailwind CSS
- 靜態資源與 SEO：Next.js 提供 SSR/SSG 能力

2) 後端與資料庫
- 後端框架：Node.js/Express 或 Next.js API Routes（依需求選擇）
- 資料庫：PostgreSQL（透過 Supabase 介接或自建實例）
- RBAC 與 RLS：若使用 PostgreSQL，採用 RLS 配合角色策略

3) 金流與 Escrow
- 介面：綠界 ECPay（信用卡、虛擬帳號）
- Escrow：自建狀態機，保證支付與放款流程

4) 即時訊息與通知
- 方案：Supabase Realtime / WebSocket

5) 基礎設施與部署
- 代碼與部署：Vercel 部署前端與 API，Supabase 作為後端資料庫與認證伺服（若選擇自建也可）
- 監控日誌：Sentry + 自定義 Audit Log

6) 安全性與合規
- 金鑰管理：使用外部 KMS 載入 API 金鑰與資料庫憑證
- 敏感資料：區分公開/受限區，實施審計與存取控管

7) 模組與服務拆分
- Core Services：Project/Task、Escrow、Notification、Memory/Config、Audit
- Authentication & RBAC
- API Gateway / Router
- Data Layer：Core DB 與 Restricted DB

8) 發布與版本控管
- CHANGELOG 與 RELEASE_NOTES 的自動化管理（草案階段）

9) 風險與緩解
- 契約一致性、RBAC 邊界、監控可觀測性等風險點的緩解策略需在測試階段持續跟踪