# Day 3 Architecture Overview (2026-03-09)

目的
- 提供網站平台 Day 3 的高層架構與資料流，方便部署與溝通。

系統架構要點
- 使用者前端 (若有) 與後端 API 透過 API Gateway 進行通信。
- 身份與存取管理：Auth Service、RBAC Service 負責認證與授權決策。
- 核心業務服務：Project/Task、Release/Escrow、Messaging、Memory/Config、Audit。
- 資料存儲：Core DB 與 Restricted DB，並採分區與審計控管。
- 外部整合：Payment、Matchmaking、Notification 等服務，可在測試環境模擬。
- 監控與日誌：集中日誌、指標與告警。

文字版架構圖（高層）
User Interface -> API Gateway -> Auth/RBAC -> Core Services -> Databases 

ASCII 圖（簡化版）
+------------------------+        +-----------------+
|   User Interface       |        |  External UI   |
+-----------+------------+        +--------+--------+
            |                                |
            v                                |
+-----------v------------+        +---------v---------+
|   API Gateway          |        |  External APIs    |
+-----------+------------+        +---------+---------+
            |                                |
            v                                v
+-----------v------------+        +---------v---------+
| Auth Service / RBAC     |      |  Identity & Tokens  |
+-----------+------------+        +---------+---------+
            |                                |
+-----------v------------+        +---------v---------+
|  Core Services (Project/
|    Task, Release, Log)  |
+-----------+------------+        +---------+---------+
            |                                |
+-----------v------------+        +---------v---------+
|  Memory/Config & Audit  |        |  Databases (Core/Restricted) |
+------------------------+        +-------------------------+

結構說明
- Core DB: 主要資料；Restricted DB: 敏感資料，嚴格權限控管。
- 設計原則：最小權限、可觀測、可回滾、可追蹤。
