# Day 3 Deployment Guide (2026-03-09)

目的
- 提供可落地執行的部署步驟，涵蓋環境、金鑰管理、資料分區、服務啟動順序、測試入口、監控與回滾機制。

部署前提
- 基礎設施：可定位的雲端或本地伺服器，HTTP/HTTPS 可達
- 金鑰與憑證：使用外部金鑰管理系統（KMS）載入 API 金鑰、資料庫憑證
- 資料分區：公開資料與敏感資料分離，敏感資料需審計與訪問控管
- 依賴服務：支付、媒合、通知服務，提供模擬版本以便測試

部署結構
- API Gateway / Router
- Auth Service、RBAC Service
- Project/Task Service
- Release/Escrow Service
- Memory/Config Service
- Log/Audit Service
- Database Core / Restricted
- External Integrations

部署步驟
1) 環境設定：env 檔、秘密管理整合
2) 資料庫遷移與初始化
3) 啟動核心微服務（按依賴順序）
4) 啟用 API Gateway 並設置路由
5) 啟動監控、日誌聚合與告警
6) 執行 E2E 測試入口（TC-001~TC-005）
7) 發布說明與 CHANGELOG 更新
8) 回滾條件與緊急計畫

驗證與收尾
- 進行端到端測試，確認核心流程順暢
- 驗證 RBAC、審計、憑證載入、日誌級別與輸出
- 若測試通過，完成發布標籤與上線

附註
- 如需，我可將此文轉成流程圖或 ASCII 架構圖。