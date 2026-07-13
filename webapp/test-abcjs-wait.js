const { chromium } = require('@playwright/test');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  await page.goto('http://localhost:3000/index.html');
  
  // Wait for abcjs to load
  const hasAbcjs = await page.waitForFunction(() => window.abcjs !== undefined, { timeout: 5000 }).catch(() => false);
  console.log('Has abcjs after wait:', hasAbcjs !== false);
  
  if (hasAbcjs !== false) {
    const hasRenderAbc = await page.evaluate(() => typeof window.abcjs.renderAbc === 'function');
    console.log('Has renderAbc:', hasRenderAbc);
  }
  
  await browser.close();
})();
