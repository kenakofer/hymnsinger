import { test, expect } from '@playwright/test';

test.describe('HymnSinger E2E Tests - Phase 3', () => {
  test.beforeEach(async ({ page, baseURL }) => {
    // Navigate to the application
    await page.goto(baseURL + '/index.html');
    
    // Wait for app to initialize
    await page.waitForFunction(() => {
      return (window as any).app !== undefined;
    });
  });

  test.describe('Text Input & Music Rendering', () => {
    test('should render ABC notation as SVG when typing into textarea', async ({ page }) => {
      const textarea = page.locator('#abc-text-area');
      
      // Clear default content
      await textarea.clear();
      
      // Type simple ABC notation
      const abcNotation = 'K: C\nC D E F';
      await textarea.fill(abcNotation);
      
      // Wait for rendering
      await page.waitForTimeout(500);
      
      // Check that SVG wrapper exists and has content
      const svgWrapper = page.locator('#abc-svg-wrapper');
      await expect(svgWrapper).toBeVisible();
      
      // Check for SVG element
      const svg = page.locator('#abc-svg-wrapper svg');
      // SVG should exist (either from abcjs or fallback)
      const svgCount = await svg.count();
      expect(svgCount).toBeGreaterThanOrEqual(1);
    });

    test('should update SVG when ABC notation changes', async ({ page }) => {
      const textarea = page.locator('#abc-text-area');
      
      // Clear and enter first notation
      await textarea.clear();
      await textarea.fill('K: C\nC D E');
      await page.waitForTimeout(500);
      
      // Get initial SVG content
      const svgWrapper = page.locator('#abc-svg-wrapper');
      const initialContent = await svgWrapper.innerHTML();
      
      // Change notation
      await textarea.clear();
      await textarea.fill('K: G\nG A B');
      await page.waitForTimeout(500);
      
      // Verify SVG content changed
      const newContent = await svgWrapper.innerHTML();
      expect(newContent).not.toBe(initialContent);
    });

    test('should handle multiline ABC notation', async ({ page }) => {
      const textarea = page.locator('#abc-text-area');
      
      const complexAbc = `M: 4/4
L: 1/4
Q: 1/4=80
K: Bb
F/2 | B A/2G/2 (3G F E- | E/2 (E/2C/2) D z/2 |
w: This here is a song you can _ prac- _ tice`;

      await textarea.clear();
      await textarea.fill(complexAbc);
      await page.waitForTimeout(500);
      
      // Verify SVG exists
      const svg = page.locator('#abc-svg-wrapper svg');
      const svgCount = await svg.count();
      expect(svgCount).toBeGreaterThanOrEqual(1);
    });
  });

  test.describe('Input Visibility Toggle', () => {
    test('should show input area by default when no URL payload', async ({ page }) => {
      const inputContainer = page.locator('#input-container');
      const display = await inputContainer.evaluate(el => 
        window.getComputedStyle(el).display
      );
      
      expect(display).not.toBe('none');
    });

    test('should toggle input visibility on button click', async ({ page }) => {
      const inputContainer = page.locator('#input-container');
      const toggleButton = page.locator('#abc-toggle-input');
      
      // Get initial display state
      const initialDisplay = await inputContainer.evaluate(el => 
        window.getComputedStyle(el).display
      );
      
      // Click toggle button
      await toggleButton.click();
      await page.waitForTimeout(200);
      
      // Check display changed
      const afterFirstClick = await inputContainer.evaluate(el => 
        window.getComputedStyle(el).display
      );
      expect(afterFirstClick).not.toBe(initialDisplay);
      
      // Click again to verify it toggles back
      await toggleButton.click();
      await page.waitForTimeout(200);
      
      const afterSecondClick = await inputContainer.evaluate(el => 
        window.getComputedStyle(el).display
      );
      expect(afterSecondClick).toBe(initialDisplay);
    });

    test('should update button text when toggling visibility', async ({ page }) => {
      const toggleButton = page.locator('#abc-toggle-input');
      
      const initialText = await toggleButton.textContent();
      expect(initialText).toBeTruthy();
      
      // Click to hide
      await toggleButton.click();
      await page.waitForTimeout(200);
      
      const afterClick = await toggleButton.textContent();
      expect(afterClick).not.toBe(initialText);
      
      // Click to show
      await toggleButton.click();
      await page.waitForTimeout(200);
      
      const afterSecondClick = await toggleButton.textContent();
      expect(afterSecondClick).toBe(initialText);
    });
  });

  test.describe('URL State Management', () => {
    test('should preserve textarea content as URL state', async ({ page }) => {
      const textarea = page.locator('#abc-text-area');
      
      // Enter new content
      const newAbc = 'K: D\nD E F G';
      await textarea.clear();
      await textarea.fill(newAbc);
      
      // Wait for debounce
      await page.waitForTimeout(2500);
      
      // Check URL contains encoded state
      const url = page.url();
      expect(url).toContain('state=');
    });

    test('should debounce URL updates during rapid typing', async ({ page }) => {
      const textarea = page.locator('#abc-text-area');
      
      // Get initial URL
      const initialUrl = page.url();
      
      // Type rapidly
      await textarea.clear();
      await textarea.fill('K');
      await page.waitForTimeout(100);
      await textarea.fill('K: C');
      await page.waitForTimeout(100);
      await textarea.fill('K: C\nC D');
      
      // URL should still be the same (debounced)
      let currentUrl = page.url();
      expect(currentUrl).toBe(initialUrl);
      
      // Wait for debounce to complete
      await page.waitForTimeout(2000);
      
      // Now URL should have changed
      currentUrl = page.url();
      expect(currentUrl).not.toBe(initialUrl);
    });

    test('should restore state from URL on page load', async ({ page }) => {
      // Get current state
      const textarea = page.locator('#abc-text-area');
      const currentValue = await textarea.inputValue();
      
      // Modify and wait for URL update
      const newAbc = 'K: Em\nE F G';
      await textarea.clear();
      await textarea.fill(newAbc);
      await page.waitForTimeout(2500);
      
      // Get URL with state
      const urlWithState = page.url();
      expect(urlWithState).toContain('state=');
      
      // Reload page
      await page.reload();
      
      // Wait for app to reinitialize
      await page.waitForFunction(() => {
        return (window as any).app !== undefined;
      });
      
      // Verify state was restored from URL
      const restoredValue = await page.locator('#abc-text-area').inputValue();
      expect(restoredValue).toBe(newAbc);
    });
  });

  test.describe('Application State', () => {
    test('should have all required state properties', async ({ page }) => {
      const state = await page.evaluate(() => {
        return (window as any).app?.getState();
      });
      
      expect(state).toBeDefined();
      expect(state).toHaveProperty('input');
      expect(state).toHaveProperty('speed');
      expect(state).toHaveProperty('metronomeVol');
      expect(state).toHaveProperty('pianoVol');
      expect(state).toHaveProperty('hasUrlPayload');
    });

    test('should have default values for state', async ({ page }) => {
      const state = await page.evaluate(() => {
        return (window as any).app?.getState();
      });
      
      expect(state.speed).toBe(1.0);
      expect(state.metronomeVol).toBe(50);
      expect(state.pianoVol).toBe(80);
      expect(state.hasUrlPayload).toBe(false);
    });

    test('should update state when textarea changes', async ({ page }) => {
      const textarea = page.locator('#abc-text-area');
      const newAbc = 'K: A\nA B C D';
      
      await textarea.clear();
      await textarea.fill(newAbc);
      await page.waitForTimeout(200);
      
      const state = await page.evaluate(() => {
        return (window as any).app?.getState();
      });
      
      expect(state.input).toBe(newAbc);
    });
  });

  test.describe('Error Handling', () => {
    test('should handle empty textarea gracefully', async ({ page }) => {
      const textarea = page.locator('#abc-text-area');
      
      await textarea.clear();
      await page.waitForTimeout(500);
      
      // App should still be functional
      const state = await page.evaluate(() => {
        return (window as any).app?.getState();
      });
      
      expect(state).toBeDefined();
      expect(state.input).toBe('');
    });

    test('should render invalid ABC notation without crashing', async ({ page }) => {
      const textarea = page.locator('#abc-text-area');
      
      const invalidAbc = 'This is not valid ABC notation @#$%^&*()';
      await textarea.clear();
      await textarea.fill(invalidAbc);
      await page.waitForTimeout(500);
      
      // App should still be functional
      const app = await page.evaluate(() => {
        return (window as any).app !== undefined;
      });
      
      expect(app).toBe(true);
      
      // SVG wrapper should still exist
      const svgWrapper = page.locator('#abc-svg-wrapper');
      await expect(svgWrapper).toBeVisible();
    });
  });

  test.describe('Music Rendering Details', () => {
    test('should display bouncing cursor element when enabled', async ({ page }) => {
      const renderer = await page.evaluate(() => {
        const app = (window as any).app;
        const r = app?.getRenderer();
        r?.enableCursor();
        return r;
      });
      
      expect(renderer).toBeDefined();
      
      // Check for cursor element
      const cursor = page.locator('#abc-bouncing-cursor');
      await expect(cursor).toBeVisible();
    });

    test('should disable cursor when needed', async ({ page }) => {
      // Enable and then disable cursor
      await page.evaluate(() => {
        const app = (window as any).app;
        const r = app?.getRenderer();
        r?.enableCursor();
        r?.disableCursor();
      });
      
      // Cursor should not exist
      const cursor = page.locator('#abc-bouncing-cursor');
      const count = await cursor.count();
      expect(count).toBe(0);
    });

    test('should have horizontal scrolling enabled', async ({ page }) => {
      const svgWrapper = page.locator('#abc-svg-wrapper');
      
      const overflowX = await svgWrapper.evaluate(el => 
        window.getComputedStyle(el).overflowX
      );
      
      expect(overflowX).toBe('auto');
    });
  });
});
