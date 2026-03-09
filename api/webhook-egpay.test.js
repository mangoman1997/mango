const request = require('supertest');
const crypto = require('crypto');

const app = require('./webhook-egpay'); // Assuming webhook-egpay.js is in same folder

const SIGNATURE_SECRET = 'your-secret'; // Use the same secret as in webhook-egpay.js

// Helper function to generate HMAC SHA256 signature
function generateSignature(rawBody, secret) {
  const hmac = crypto.createHmac('sha256', secret);
  hmac.update(rawBody, 'utf8');
  return hmac.digest('hex');
}

describe('ECPay Webhook', () => {

  // Mock for console.error and console.log to check logs without spamming the test output
  let consoleErrorSpy;
  let consoleLogSpy;

  beforeEach(() => {
    consoleErrorSpy = jest.spyOn(console, 'error').mockImplementation(() => {});
    consoleLogSpy = jest.spyOn(console, 'log').mockImplementation(() => {});
  });

  afterEach(() => {
    consoleErrorSpy.mockRestore();
    consoleLogSpy.mockRestore();
  });

  test('TC-001: Should return 200 OK for a valid request with signature', async () => {
    const payload = { event: 'pay_success', order_id: 'TEST123' };
    const rawBody = JSON.stringify(payload);
    const signature = generateSignature(rawBody, SIGNATURE_SECRET);

    const response = await request(app)
      .post('/webhook/egpay')
      .set('x-ecpay-signature', signature)
      .send(payload);

    expect(response.status).toBe(200);
    expect(response.text).toBe('OK');
    expect(consoleErrorSpy).not.toHaveBeenCalled(); 
  });

  test('TC-002: Should return 400 for a request with missing signature', async () => {
    const payload = { event: 'pay_success', order_id: 'TEST123' };

    const response = await request(app)
      .post('/webhook/egpay')
      .send(payload);

    expect(response.status).toBe(400);
    expect(response.text).toBe('Invalid signature');
    expect(consoleErrorSpy).toHaveBeenCalledWith('ECPay webhook sign verification failed.');
  });

  test('TC-003: Should return 400 for a request with an invalid signature', async () => {
    const payload = { event: 'pay_success', order_id: 'TEST123' };
    const invalidSignature = 'invalid-signature-123'; 

    const response = await request(app)
      .post('/webhook/egpay')
      .set('x-ecpay-signature', invalidSignature)
      .send(payload);

    expect(response.status).toBe(400);
    expect(response.text).toBe('Invalid signature');
    expect(consoleErrorSpy).toHaveBeenCalledWith('ECPay webhook sign verification failed.');
  });

  test('TC-004: Should handle empty body safely', async () => {
    const emptyPayload = {};
    const emptyRawBody = JSON.stringify(emptyPayload);
    const emptyPayloadSignature = generateSignature(emptyRawBody, SIGNATURE_SECRET);

    const responseEmptyJSON = await request(app)
      .post('/webhook/egpay')
      .set('x-ecpay-signature', emptyPayloadSignature)
      .send(emptyPayload);

    expect(responseEmptyJSON.status).toBe(200); 
    expect(responseEmptyJSON.text).toBe('OK');
    expect(consoleErrorSpy).not.toHaveBeenCalled(); 
  });

  test('TC-005: Should handle payload with extra fields gracefully', async () => {
    const payload = { event: 'pay_success', order_id: 'TEST123', extra_info: { transaction_id: 'TXN987' }, user_id: 123 };
    const rawBody = JSON.stringify(payload);
    const signature = generateSignature(rawBody, SIGNATURE_SECRET);

    const response = await request(app)
      .post('/webhook/egpay')
      .set('x-ecpay-signature', signature)
      .send(payload);

    expect(response.status).toBe(200);
    expect(response.text).toBe('OK');
    expect(consoleErrorSpy).not.toHaveBeenCalled(); 
  });
});
