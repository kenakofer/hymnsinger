# HymnSinger E2E Testing Guide

## Setup

The E2E tests for Phase 3 are located in `e2e/phase3.spec.ts` and test the following functionality:

1. **Text Input & Music Rendering** - ABC notation input and SVG rendering
2. **Input Visibility Toggle** - Collapsible input area functionality
3. **URL State Management** - State serialization and debouncing
4. **Application State** - State properties and updates
5. **Error Handling** - Graceful error handling for invalid input
6. **Music Rendering Details** - Cursor and scrolling functionality

## Prerequisites

Before running E2E tests, ensure:

1. TypeScript is compiled to JavaScript:
   ```bash
   npm run build
   ```

2. Playwright browsers are installed:
   ```bash
   npx playwright install
   ```

## Running Tests

### Option 1: Using a Local HTTP Server (Recommended)

1. Start a simple HTTP server to serve the public directory:
   ```bash
   cd public
   npx http-server .
   # Server will run at http://localhost:8080
   ```

2. Update `playwright.config.ts` to use the correct base URL:
   ```typescript
   use: {
     baseURL: 'http://localhost:8080',
     trace: 'on-first-retry',
   },
   ```

3. Run the E2E tests:
   ```bash
   npm run test:e2e
   ```

### Option 2: Using VS Code Playwright Extension

1. Install the Playwright Test for VS Code extension
2. Open the E2E test file (`e2e/phase3.spec.ts`)
3. Click "Run test" next to each test

### Option 3: Manual Testing

1. Build the project:
   ```bash
   npm run build
   ```

2. Open `public/index.html` in a web browser using a local server:
   ```bash
   cd public
   python3 -m http.server 8000
   # or
   npx http-server .
   ```

3. Open `http://localhost:8000/` in your browser and manually test the features

## Test Coverage

The E2E tests cover all Phase 3 requirements:

- ✅ Typing ABC notation and seeing SVG render
- ✅ Input visibility toggle (show/hide input area)
- ✅ Button text updates when toggling
- ✅ URL state preservation after debounce
- ✅ Debounced URL updates (no update on every keystroke)
- ✅ State restoration from URL on page reload
- ✅ Default state properties (speed, volumes, etc.)
- ✅ State updates when textarea changes
- ✅ Error handling for empty/invalid input
- ✅ Bouncing cursor functionality
- ✅ Horizontal scrolling enabled on music renderer

## HTML Test Fixture

The application is tested using `public/index.html` which includes:

- All required HTML structure (textarea, renderer container)
- External library loading (abcjs, lz-string via CDN)
- Compiled JavaScript from TypeScript build
- Basic styling for the application
- Error handling and initialization

## Debugging Tests

To debug a specific test:

1. Run with headed mode:
   ```bash
   npx playwright test --headed --debug
   ```

2. Use `page.pause()` in tests to pause execution and inspect state

3. Check generated reports:
   ```bash
   npx playwright show-report
   ```

## Known Issues

- File:// protocol URLs in Playwright may have security restrictions
- CDN resources (abcjs, lz-string) require internet connectivity
- Some timing-dependent tests may need adjustment based on system performance
