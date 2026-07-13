# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: phase3.spec.ts >> HymnSinger E2E Tests - Phase 3 >> Music Rendering Details >> should disable cursor when needed
- Location: e2e/phase3.spec.ts:309:9

# Error details

```
Error: page.waitForFunction: Target page, context or browser has been closed
```

# Test source

```ts
  1   | import { test, expect } from '@playwright/test';
  2   | 
  3   | test.describe('HymnSinger E2E Tests - Phase 3', () => {
  4   |   test.beforeEach(async ({ page, baseURL }) => {
  5   |     // Navigate to the application
  6   |     await page.goto(baseURL + '/index.html');
  7   |     
  8   |     // Wait for app to initialize
> 9   |     await page.waitForFunction(() => {
      |                ^ Error: page.waitForFunction: Target page, context or browser has been closed
  10  |       return (window as any).app !== undefined;
  11  |     });
  12  |   });
  13  | 
  14  |   test.describe('Text Input & Music Rendering', () => {
  15  |     test('should render ABC notation as SVG when typing into textarea', async ({ page }) => {
  16  |       const textarea = page.locator('#abc-text-area');
  17  |       
  18  |       // Clear default content
  19  |       await textarea.clear();
  20  |       
  21  |       // Type simple ABC notation
  22  |       const abcNotation = 'K: C\nC D E F';
  23  |       await textarea.fill(abcNotation);
  24  |       
  25  |       // Wait for rendering
  26  |       await page.waitForTimeout(500);
  27  |       
  28  |       // Check that SVG wrapper exists and has content
  29  |       const svgWrapper = page.locator('#abc-svg-wrapper');
  30  |       await expect(svgWrapper).toBeVisible();
  31  |       
  32  |       // Check for SVG element
  33  |       const svg = page.locator('#abc-svg-wrapper svg');
  34  |       // SVG should exist (either from abcjs or fallback)
  35  |       const svgCount = await svg.count();
  36  |       expect(svgCount).toBeGreaterThanOrEqual(1);
  37  |     });
  38  | 
  39  |     test('should update SVG when ABC notation changes', async ({ page }) => {
  40  |       const textarea = page.locator('#abc-text-area');
  41  |       
  42  |       // Clear and enter first notation
  43  |       await textarea.clear();
  44  |       await textarea.fill('K: C\nC D E');
  45  |       await page.waitForTimeout(500);
  46  |       
  47  |       // Get initial SVG content
  48  |       const svgWrapper = page.locator('#abc-svg-wrapper');
  49  |       const initialContent = await svgWrapper.innerHTML();
  50  |       
  51  |       // Change notation
  52  |       await textarea.clear();
  53  |       await textarea.fill('K: G\nG A B');
  54  |       await page.waitForTimeout(500);
  55  |       
  56  |       // Verify SVG content changed
  57  |       const newContent = await svgWrapper.innerHTML();
  58  |       expect(newContent).not.toBe(initialContent);
  59  |     });
  60  | 
  61  |     test('should handle multiline ABC notation', async ({ page }) => {
  62  |       const textarea = page.locator('#abc-text-area');
  63  |       
  64  |       const complexAbc = `M: 4/4
  65  | L: 1/4
  66  | Q: 1/4=80
  67  | K: Bb
  68  | F/2 | B A/2G/2 (3G F E- | E/2 (E/2C/2) D z/2 |
  69  | w: This here is a song you can _ prac- _ tice`;
  70  | 
  71  |       await textarea.clear();
  72  |       await textarea.fill(complexAbc);
  73  |       await page.waitForTimeout(500);
  74  |       
  75  |       // Verify SVG exists
  76  |       const svg = page.locator('#abc-svg-wrapper svg');
  77  |       const svgCount = await svg.count();
  78  |       expect(svgCount).toBeGreaterThanOrEqual(1);
  79  |     });
  80  |   });
  81  | 
  82  |   test.describe('Input Visibility Toggle', () => {
  83  |     test('should show input area by default when no URL payload', async ({ page }) => {
  84  |       const inputContainer = page.locator('#input-container');
  85  |       const display = await inputContainer.evaluate(el => 
  86  |         window.getComputedStyle(el).display
  87  |       );
  88  |       
  89  |       expect(display).not.toBe('none');
  90  |     });
  91  | 
  92  |     test('should toggle input visibility on button click', async ({ page }) => {
  93  |       const inputContainer = page.locator('#input-container');
  94  |       const toggleButton = page.locator('#abc-toggle-input');
  95  |       
  96  |       // Get initial display state
  97  |       const initialDisplay = await inputContainer.evaluate(el => 
  98  |         window.getComputedStyle(el).display
  99  |       );
  100 |       
  101 |       // Click toggle button
  102 |       await toggleButton.click();
  103 |       await page.waitForTimeout(200);
  104 |       
  105 |       // Check display changed
  106 |       const afterFirstClick = await inputContainer.evaluate(el => 
  107 |         window.getComputedStyle(el).display
  108 |       );
  109 |       expect(afterFirstClick).not.toBe(initialDisplay);
```