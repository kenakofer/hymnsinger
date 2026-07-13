const { chromium } = require('@playwright/test');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  const logs = [];
  page.on('console', msg => {
    console.log('LOG:', msg.type(), msg.text());
    logs.push({ type: msg.type(), text: msg.text() });
  });
  page.on('pageerror', err => {
    console.log('ERROR:', err.message);
    logs.push({ type: 'error', text: err.message });
  });
  
  await page.goto('http://localhost:3000/index.html');
  await page.waitForTimeout(2000);
  
  console.log('\n=== Final Logs ===');
  logs.forEach(l => console.log(`${l.type}: ${l.text}`));
  
  await browser.close();
})();
