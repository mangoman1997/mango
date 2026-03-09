const http = require('http');

function getDynamicData() {
  const now = new Date();
  
  // Custom simple GMT+8 Logic overriding system constraints
  const getPad = (n) => n.toString().padStart(2, '0');
  
  const tzOffsetMs = 8 * 60 * 60 * 1000;
  const localNow = new Date(now.getTime() + tzOffsetMs);
  
  let h = localNow.getUTCHours();
  let m = localNow.getUTCMinutes();
  
  // Daily check logic (hourly)
  let lastHr = h;
  let nextHr = (h + 1) % 24;
  
  const dailyMin = 60 - m;
  
  // E2E logic (Daily) at 03:00 AM
  let e2eHrs = 3 - h;
  if(e2eHrs <= 0) e2eHrs += 24;
  if(m > 0) {
     e2eHrs -= 1;
  }
  const e2eMin = 60 - m;
  const e2eEtaStr = e2eHrs > 0 ? e2eHrs + 'h ' + e2eMin + 'm' : e2eMin + 'm';

  const fmtTime = (hr) => {
    let yr = localNow.getUTCFullYear();
    let mo = getPad(localNow.getUTCMonth() + 1);
    let dt = getPad(localNow.getUTCDate());
    return yr + '-' + mo + '-' + dt + ' ' + getPad(hr) + ':00';
  };

  const fmtTimeNextDay = (hr) => {
    let t = new Date(localNow.getTime() + 24*60*60*1000);
    let yr = t.getUTCFullYear();
    let mo = getPad(t.getUTCMonth() + 1);
    let dt = getPad(t.getUTCDate());
    return yr + '-' + mo + '-' + dt + ' ' + getPad(hr) + ':00';
  };

  return [
    { 
      name: '日常清檢計畫 (實體後端 API)', 
      status: dailyMin > 55 ? 'in-progress' : 'completed', 
      last_run: fmtTime(lastHr), 
      next_run: fmtTime(nextHr), 
      frequency: 'hourly', 
      eta: dailyMin + 'm' 
    },
    { 
      name: 'E2E 自動化腳本執行', 
      status: 'ready', 
      last_run: '-', 
      next_run: (h >= 3) ? fmtTimeNextDay(3) : fmtTime(3), 
      frequency: 'daily', 
      eta: e2eEtaStr 
    }
  ];
}

const server = http.createServer((req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Content-Type', 'application/json');

  if (req.url === '/api/dashboard/scheduled_tasks') {
    res.writeHead(200);
    res.end(JSON.stringify(getDynamicData()));
    return;
  }
  
  res.writeHead(404);
  res.end(JSON.stringify({ error: 'Not found' }));
});

server.listen(3030, () => console.log('ShopperProxy Mock Server running on port 3030 (Timezone Fixed V4)'));
