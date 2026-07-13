const { test, expect } = require('@playwright/test');

test('check console logs', async ({ page }) => {
  const logs = [];
  page.on('console', msg => {
    logs.push({type: msg.type(), text: msg.text()});
  });
  
  await page.goto('http://localhost:3000/index.html');
  await page.waitForFunction(() => (window).app !== undefined);
  
  const textarea = page.locator('#abc-text-area');
  await textarea.clear();
  await textarea.fill('K: D\nD E F G');
  
  await page.waitForTimeout(2500);
  
  console.log('Browser logs:', JSON.stringify(logs, null, 2));
  console.log('Current URL:', page.url());
});
