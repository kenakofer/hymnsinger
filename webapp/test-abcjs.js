const { chromium } = require('@playwright/test');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  // Capture requests
  const requests = [];
  page.on('request', req => requests.push(req.url()));
  page.on('response', res => {
    if (res.url().includes('abcjs') || res.url().includes('jsdelivr')) {
      console.log('Response:', res.status(), res.url());
    }
  });
  
  await page.goto('http://localhost:3000/index.html');
  await page.waitForTimeout(3000);
  
  const scripts = await page.evaluate(() => {
    return Array.from(document.querySelectorAll('script')).map(s => s.src || s.textContent.substring(0, 100));
  });
  
  console.log('Scripts:', scripts);
  console.log('Has window.abcjs:', await page.evaluate(() => window.abcjs !== undefined));
  
  await browser.close();
})();
