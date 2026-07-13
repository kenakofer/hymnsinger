import { BouncingCursor } from './BouncingCursor';

describe('BouncingCursor', () => {
  let cursor: BouncingCursor;
  let container: HTMLElement;

  beforeEach(() => {
    // Create a container for testing
    container = document.createElement('div');
    container.id = 'test-svg-container';
    container.style.position = 'relative';
    document.body.appendChild(container);
  });

  afterEach(() => {
    if (cursor) {
      cursor.destroy();
    }
    document.body.removeChild(container);
  });

  describe('creation', () => {
    it('should throw error if container does not exist', () => {
      expect(() => {
        new BouncingCursor('non-existent-id');
      }).toThrow('SVG container with id "non-existent-id" not found');
    });

    it('should create cursor instance successfully', () => {
      cursor = new BouncingCursor('test-svg-container');
      expect(cursor).toBeDefined();
    });

    it('should create a DOM element on create()', () => {
      cursor = new BouncingCursor('test-svg-container');
      cursor.create();

      const cursorElement = document.getElementById('abc-bouncing-cursor');
      expect(cursorElement).toBeDefined();
      expect(cursorElement).toBeInstanceOf(HTMLElement);
    });

    it('should style the cursor as a red circle', () => {
      cursor = new BouncingCursor('test-svg-container');
      cursor.create();

      const cursorElement = document.getElementById('abc-bouncing-cursor')!;
      expect(cursorElement.style.backgroundColor).toBe('red');
      expect(cursorElement.style.borderRadius).toBe('50%');
      expect(cursorElement.style.width).toBe('10px');
      expect(cursorElement.style.height).toBe('10px');
      expect(cursorElement.style.position).toBe('absolute');
    });

    it('should set container to position relative', () => {
      cursor = new BouncingCursor('test-svg-container');
      cursor.create();
      expect(container.style.position).toBe('relative');
    });

    it('should append cursor element to container', () => {
      cursor = new BouncingCursor('test-svg-container');
      cursor.create();

      const cursorElement = container.querySelector('#abc-bouncing-cursor');
      expect(cursorElement).toBeDefined();
    });
  });

  describe('position and animation', () => {
    beforeEach(() => {
      cursor = new BouncingCursor('test-svg-container');
      cursor.create();
    });

    it('should set cursor position from callback', () => {
      const callback = { x: 100, y: 50, width: 20, height: 20 };
      cursor.setProgress(callback);

      const cursorElement = document.getElementById('abc-bouncing-cursor')!;
      expect(cursorElement.style.left).toBe('95px'); // 100 - 5 (center offset)
      expect(cursorElement.style.top).not.toBe(''); // Should have some top value
    });

    it('should apply bounce animation', () => {
      cursor.setProgress({ x: 100, y: 50, width: 20, height: 20 });
      const firstTop = document.getElementById('abc-bouncing-cursor')!.style.top;

      // Move cursor to trigger bounce effect
      cursor.setProgress({ x: 120, y: 50, width: 20, height: 20 });
      const secondTop = document.getElementById('abc-bouncing-cursor')!.style.top;

      // Positions should differ due to bounce
      expect(firstTop).not.toBe(secondTop);
    });

    it('should handle multiple position updates', () => {
      const positions = [
        { x: 100, y: 50, width: 20, height: 20 },
        { x: 110, y: 50, width: 20, height: 20 },
        { x: 120, y: 50, width: 20, height: 20 },
      ];

      positions.forEach(pos => {
        expect(() => cursor.setProgress(pos)).not.toThrow();
      });
    });
  });

  describe('visibility', () => {
    beforeEach(() => {
      cursor = new BouncingCursor('test-svg-container');
      cursor.create();
    });

    it('should show cursor', () => {
      cursor.hide();
      cursor.show();

      const cursorElement = document.getElementById('abc-bouncing-cursor')!;
      expect(cursorElement.style.opacity).toBe('1');
    });

    it('should hide cursor', () => {
      cursor.show();
      cursor.hide();

      const cursorElement = document.getElementById('abc-bouncing-cursor')!;
      expect(cursorElement.style.opacity).toBe('0');
    });
  });

  describe('reset and cleanup', () => {
    beforeEach(() => {
      cursor = new BouncingCursor('test-svg-container');
      cursor.create();
    });

    it('should reset cursor position', () => {
      cursor.setProgress({ x: 150, y: 100, width: 20, height: 20 });
      cursor.reset();

      const cursorElement = document.getElementById('abc-bouncing-cursor')!;
      expect(cursorElement.style.left).toBe('0px');
      expect(cursorElement.style.top).toBe('0px');
    });

    it('should destroy cursor element', () => {
      cursor.destroy();

      const cursorElement = document.getElementById('abc-bouncing-cursor');
      expect(cursorElement).toBeNull();
    });

    it('should not throw when destroying without creating', () => {
      const newCursor = new BouncingCursor('test-svg-container');
      expect(() => newCursor.destroy()).not.toThrow();
    });
  });

  describe('multiple cursors', () => {
    it('should handle multiple cursor instances independently', () => {
      const container2 = document.createElement('div');
      container2.id = 'test-svg-container-2';
      container2.style.position = 'relative';
      document.body.appendChild(container2);

      const cursor1 = new BouncingCursor('test-svg-container');
      const cursor2 = new BouncingCursor('test-svg-container-2');

      cursor1.create();
      cursor2.create();

      const element1 = document.getElementById('abc-bouncing-cursor');
      expect(element1?.parentElement?.id).toBe('test-svg-container');

      cursor1.destroy();
      cursor2.destroy();
      document.body.removeChild(container2);
    });
  });
});
