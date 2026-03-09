const http = require('http');

const server = http.createServer((req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Content-Type', 'application/json');

  if (req.url === '/api/dashboard/scheduled_tasks') {
    res.writeHead(200);
    res.end(JSON.stringify([
      { name: '日常清檢計畫 (實體後端 API)', status: 'in-progress', last_run: '2026-03-10 00:00', next_run: '2026-03-10 01:00', frequency: 'hourly', eta: '20m' },
      { name: 'E2E 自動化腳本執行', status: 'ready', last_run: '-', next_run: '2026-03-10 02:00', frequency: 'daily', eta: '1h 20m' }
    ]));
    return;
  }
  
  if (req.url.startsWith('/api/')) {
    res.writeHead(200);
    res.end(JSON.stringify({ success: true, message: 'Mock endpoint hit: ' + req.url }));
    return;
  }

  res.writeHead(404);
  res.end(JSON.stringify({ error: 'Not found' }));
});

server.listen(3030, () => console.log('ShopperProxy Mock Server running on port 3030'));
