import { test, expect } from '@playwright/test';

// Reproducer: click Play and verify synth was initialized
// Fails if synth not initialized (reproduces "Synth not initialized" observed in console)

test('synth initialization on play', async ({ page }) => {
  const consoleMessages: {type:string,text:string}[] = [];
  page.on('console', (msg) => {
    consoleMessages.push({ type: msg.type(), text: msg.text() });
    if (msg.type() === 'error') console.error('[browser error]', msg.text());
    else console.log('[browser]', msg.type(), msg.text());
  });

  await page.goto('http://localhost:3000/index.html');

  // Wait for app and playbackCoordinator to be available
  await page.waitForFunction(() => {
    return (window as any).app !== undefined && (window as any).playbackCoordinator !== undefined;
  });

  // Click the Play button
  const playButton = page.getByRole('button', { name: '▶ Play' });
  await playButton.click();

  // Give it a moment to initialize and start playback
  await page.waitForTimeout(800);

  // Check for synth presence
  const synthExists = await page.evaluate(() => {
    const pc = (window as any).playbackCoordinator;
    try {
      const synth = pc?.getSynthesizer?.()?.getSynth?.();
      return !!synth;
    } catch (e) {
      return false;
    }
  });

  // If synth not present, surface console errors for debugging
  if (!synthExists) {
    console.log('Console errors:', consoleErrors);
  }

  expect(synthExists).toBe(true);
});