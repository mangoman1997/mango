const panels = [
  { id: 'Phase', title: '專案階段', value: '發布候選階段 (RC)' },
  { id: 'E2E_Test', title: 'E2E 測試 (TC-001~005)', value: '撰寫完成 (100%)' },
  { id: 'CrossSync', title: '跨文件檢查', value: '查驗通過 (無衝突)' },
  { id: 'Config', title: '架構與部署', value: '穩固可執行' },
  { id: 'Release', title: '發布狀態', value: 'v1.1-day3 就緒' },
  { id: 'Memory', title: '即時日誌', value: '更新至 22:00' }
];
function render(){
  const c = document.getElementById('panels'); c.innerHTML='';
  panels.forEach(p=>{
    const d = document.createElement('div'); d.className='item card';
    d.innerHTML = `<div class="title">${p.title}</div><div class="value">${p.value}</div>`;
    c.appendChild(d);
  });
}
document.addEventListener('DOMContentLoaded', render);
