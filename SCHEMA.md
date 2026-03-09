# SCHEMA.md (Day 3 Draft)

- 目的與影響
  - 更新資料表設計與 RBAC/RLS 權限策略，支援 Day 3 的需求與安全性。

- 主要修改點
  - 新增/修正：users、sessions/auth_tokens、projects、orders、escrow_transactions、messages 的欄位與型別
  - 加入 RLS 規則範例、索引策略
  - 將外鍵、資料型別與 ENUM 設定與 Day 3 設計保持一致
  - 更新 RBAC 與 RLS 的描述以便落地實作

- 驗證要點
  - 外鍵與 ENUM 設定符合設計
  - RBAC/RLS 描述可操作且可驗證
  - 索引策略與查詢計畫與 Day 3 一致

- 上傳/覆蓋步驟
  - 將 Day 3 的草案文本貼入 SCHEMA.md，保存
  - 提供變更摘要以便核對
