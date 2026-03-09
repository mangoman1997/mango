const express = require('express');
const bodyParser = require('body-parser');
const crypto = require('crypto');

const app = express();
const PORT = process.env.PORT || 3000;
const SIGNATURE_SECRET = process.env.ECPAY_WEBHOOK_SECRET || 'your-secret';

app.use(express.json({
  verify: (req, res, buf) => {
    req.rawBody = buf.toString();
  }
}));

function verifySignature(rawBody, signature) {
  if (!SIGNATURE_SECRET || !signature) return false;
  const hmac = crypto.createHmac('sha256', SIGNATURE_SECRET);
  hmac.update(rawBody, 'utf8');
  const digest = hmac.digest('hex');
  return digest === signature;
}

app.post('/webhook/egpay', (req, res) => {
  const signature = req.headers['x-ecpay-signature'];
  if (SIGNATURE_SECRET && !verifySignature(req.rawBody || JSON.stringify(req.body), signature)) {
    console.error('ECPay webhook sign verification failed.');
    return res.status(400).send('Invalid signature');
  }
  const payload = req.body;
  console.log('[ECPay webhook] Received payload:', JSON.stringify(payload).slice(0, 500));
  res.status(200).send('OK');
});

module.exports = app;
if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`ECPay webhook listener running on port ${PORT}`);
  });
}
