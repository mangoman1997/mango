// Enhanced Day 3 dashboard with progress bars and LIVE API Fetching
async function fetchProgress(){
  const data = {
    modules: [
      { id:'TC-001', name:'TC-001 登入與會話管理', pct: 100, eta: 'Done', status:'completed' },
      { id:'TC-002', name:'TC-002 專案/任務建立與指派', pct: 100, eta: 'Done', status:'completed' },
      { id:'TC-003', name:'TC-003 發布與 Escrow 流程', pct: 100, eta: 'Done', status:'completed' },
      { id:'TC-004', name:'TC-004 RBAC 權限驗證', pct: 100, eta: 'Done', status:'completed' },
      { id:'TC-005', name:'TC-005 API schema 驗證', pct: 100, eta: 'Done', status:'completed' },
    ],
    cross: { diff: 0, total: 8 },
    release: { draft: 'Deployable (v1.1-day3)', eta: 'Ready' },
    memory: '2026-03-10 Live Sync'
  };

  try {
    const res = await fetch('http://localhost:3030/api/dashboard/scheduled_tasks');
    if(res.ok) {
      data.scheduled = await res.json();
    } else {
      data.scheduled = [{ name:'API 連線失敗', status:'error', last_run:'-', next_run:'-', frequency:'-', eta:'-' }];
    }
  } catch(e) {
    data.scheduled = [{ name:'API Server 離線', status:'offline', last_run:'-', next_run:'-', frequency:'-', eta:'-' }];
  }
  return data;
}

async function render(){
  const out = await fetchProgress();
  const container = document.getElementById('panels');
  container.innerHTML = '';
  // Core TC panels
  out.modules.forEach(m=>{
    const card = document.createElement('div'); card.className='card';
    const color = m.status==='not-started'? '#ddd' : '#e8f5e9';
    const barColor = m.pct === 100 ? '#4caf50' : '#2196f3';
    const pct = Math.max(0, Math.min(100, m.pct));
    card.innerHTML = `
      <div class="title">${m.name}</div>
      <div class="progress" style="background:${color};">
        <div class="bar" style="width:${pct}%; background:${barColor};"></div>
      </div>
      <div class="eta">完成度: ${pct}%, ETA: ${m.eta}</div>
    `;
    container.appendChild(card);
  });
  // Cross file summary
  const cross = document.createElement('div'); cross.className='card'; cross.innerHTML = `<div class='title'>跨文件一致性</div><div class="eta">差異: ${out.cross.diff} / 全部: ${out.cross.total} 對照完成</div>`;
  container.appendChild(cross);
  // Release status
  const rel = document.createElement('div'); rel.className='card'; rel.innerHTML = `<div class='title'>發布狀態</div><div class="eta">草案：${out.release.draft}，ETA: ${out.release.eta}</div>`;
  container.appendChild(rel);
  // Scheduled tasks panel
  const sched = document.createElement('div'); sched.className='card'; sched.innerHTML = `<div class='title'>定時任務 (Live 實體 API)</div>`;
  const list = document.createElement('div'); list.style.display='grid'; list.style.gridTemplateColumns='1fr';
  out.scheduled.forEach(t=>{
    const row = document.createElement('div'); row.style.display='flex'; row.style.justifyContent='space-between'; row.style.alignItems='center'; row.style.padding='6px 0';
    row.innerHTML = `<span>${t.name} - ${t.status}</span><span style='color:#666'>上次:${t.last_run} | 下一次:${t.next_run} | freq:${t.frequency} | ETA:${t.eta}</span>`;
    list.appendChild(row);
  });
  sched.appendChild(list); container.appendChild(sched);
}
document.addEventListener('DOMContentLoaded', render);
setInterval(render, 30000);
