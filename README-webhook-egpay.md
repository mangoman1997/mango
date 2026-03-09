# Webhook EGPay (ECPay) lokal

설명:
- Node.js + Express 기반의 수신 엔드포인트 예제
- 시그니처 검증 로직 포함(필요시 활성화)
- 배포 및 로컬 테스트 방법 제공

설정
- ECPAY_WEBHOOK_SECRET 환경변수 설정

실행:
- npm init -y
- npm install express
- node api/webhook-egpay.js

테스트
- curl 예제 포함
