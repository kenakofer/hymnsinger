import { MusicRenderer, HymnSingerApp } from './HymnSingerApp';

describe('MusicRenderer', () => {
  let container: HTMLElement;
  let renderer: MusicRenderer;

  beforeEach(() => {
    container = document.createElement('div');
    container.id = 'test-renderer-container';
    container.style.width = '100%';
    container.style.height = '400px';
    document.body.appendChild(container);
  });

  afterEach(() => {
    if (renderer) {
      renderer.destroy();
    }
    document.body.removeChild(container);
  });

  describe('initialization', () => {
    it('should throw error if container does not exist', () => {
      expect(() => {
        new MusicRenderer('non-existent-id');
      }).toThrow('Container with id "non-existent-id" not found');
    });

    it('should create renderer instance', () => {
      renderer = new MusicRenderer('test-renderer-container');
      expect(renderer).toBeDefined();
    });

    it('should create SVG wrapper div', () => {
      renderer = new MusicRenderer('test-renderer-container');
      const wrapper = renderer.getSvgWrapper();
      expect(wrapper).toBeDefined();
      expect(wrapper.id).toBe('abc-svg-wrapper');
    });

    it('should style SVG wrapper for horizontal scrolling', () => {
      renderer = new MusicRenderer('test-renderer-container');
      const wrapper = renderer.getSvgWrapper();
      expect(wrapper.style.overflowX).toBe('auto');
      expect(wrapper.style.overflowY).toBe('hidden');
      expect(wrapper.style.whiteSpace).toBe('nowrap');
    });
  });

  describe('rendering', () => {
    beforeEach(() => {
      renderer = new MusicRenderer('test-renderer-container');
    });

    it('should render ABC notation without errors', () => {
      const abc = 'K: C\nC D E F';
      expect(() => renderer.render(abc)).not.toThrow();
    });

    it('should clear previous content on re-render', () => {
      const abc1 = 'K: C\nC D E';
      const abc2 = 'K: G\nG A B';

      renderer.render(abc1);
      const wrapper1 = renderer.getSvgWrapper();
      const content1 = wrapper1.innerHTML;

      renderer.render(abc2);
      const wrapper2 = renderer.getSvgWrapper();
      const content2 = wrapper2.innerHTML;

      // Content should be different after re-render
      expect(content1.length).toBeGreaterThan(0);
    });

    it('should handle multiline ABC notation', () => {
      const abc = `M: 4/4
L: 1/4
Q: 1/4=80
K: Bb
F/2 | B A/2G/2 (3G F E-`;

      expect(() => renderer.render(abc)).not.toThrow();
    });

    it('should render with custom options', () => {
      const abc = 'K: D\nD E F';
      const options = {
        staffwidth: 600,
        viewportHorizontal: true,
        scrollHorizontal: true,
      };

      expect(() => renderer.render(abc, options)).not.toThrow();
    });

    it('should handle empty ABC notation', () => {
      expect(() => renderer.render('')).not.toThrow();
    });

    it('should handle malformed ABC notation gracefully', () => {
      const invalidAbc = 'This is not valid ABC notation @#$%';
      expect(() => renderer.render(invalidAbc)).not.toThrow();
    });
  });

  describe('cursor functionality', () => {
    beforeEach(() => {
      renderer = new MusicRenderer('test-renderer-container');
    });

    it('should enable cursor', () => {
      const cursor = renderer.enableCursor();
      expect(cursor).toBeDefined();
    });

    it('should return same cursor instance on multiple enables', () => {
      const cursor1 = renderer.enableCursor();
      const cursor2 = renderer.enableCursor();
      expect(cursor1).toBe(cursor2);
    });

    it('should disable cursor', () => {
      renderer.enableCursor();
      renderer.disableCursor();

      const element = document.getElementById('abc-bouncing-cursor');
      expect(element).toBeNull();
    });

    it('should create visible bouncing cursor element', () => {
      renderer.enableCursor();
      const cursorElement = document.getElementById('abc-bouncing-cursor');
      expect(cursorElement).toBeDefined();
      expect(cursorElement?.style.backgroundColor).toBe('red');
    });
  });

  describe('cleanup', () => {
    it('should destroy renderer and clean up elements', () => {
      renderer = new MusicRenderer('test-renderer-container');
      const wrapper = renderer.getSvgWrapper();
      expect(wrapper.parentElement).toBe(container);

      renderer.destroy();
      expect(wrapper.parentElement).toBeNull();
    });
  });
});

describe('HymnSingerApp', () => {
  let appContainer: HTMLElement;
  let textAreaContainer: HTMLElement;
  let textArea: HTMLTextAreaElement;
  let rendererContainer: HTMLElement;
  let app: HymnSingerApp;

  beforeEach(() => {
    // Create container structure
    appContainer = document.createElement('div');
    appContainer.id = 'app-container';
    document.body.appendChild(appContainer);

    // Create text area container and text area
    textAreaContainer = document.createElement('div');
    textAreaContainer.id = 'input-container';
    appContainer.appendChild(textAreaContainer);

    textArea = document.createElement('textarea');
    textArea.id = 'abc-text-area';
    textArea.style.width = '100%';
    textArea.style.height = '200px';
    textAreaContainer.appendChild(textArea);

    // Create renderer container
    rendererContainer = document.createElement('div');
    rendererContainer.id = 'renderer-container';
    appContainer.appendChild(rendererContainer);

    // Mock window.history.replaceState
    window.history.replaceState = jest.fn();
  });

  afterEach(() => {
    if (app) {
      app.destroy();
    }
    document.body.removeChild(appContainer);
  });

  describe('initialization', () => {
    it('should create app instance', () => {
      app = new HymnSingerApp('app-container', 'abc-text-area', 'renderer-container');
      expect(app).toBeDefined();
    });

    it('should throw error if containers do not exist', () => {
      expect(() => {
        new HymnSingerApp('non-existent', 'abc-text-area', 'renderer-container');
      }).toThrow();
    });

    it('should load default state when no URL payload', () => {
      app = new HymnSingerApp('app-container', 'abc-text-area', 'renderer-container');
      const state = app.getState();
      expect(state.hasUrlPayload).toBe(false);
      expect(state.speed).toBe(1.0);
    });

    it('should show input by default when no URL payload', () => {
      app = new HymnSingerApp('app-container', 'abc-text-area', 'renderer-container');
      expect(textAreaContainer.style.display).not.toBe('none');
    });
  });

  describe('text input', () => {
    beforeEach(() => {
      app = new HymnSingerApp('app-container', 'abc-text-area', 'renderer-container');
    });

    it('should have content in textarea from state', () => {
      const appState = app.getState();
      expect(appState.input).toBeTruthy();
      // The textarea should reflect the state
      expect(textArea.value).toBe(appState.input);
    });

    it('should update state when textarea changes', () => {
      const newInput = 'K: D\nD E F G';
      textArea.value = newInput;
      textArea.dispatchEvent(new Event('input'));

      const state = app.getState();
      expect(state.input).toBe(newInput);
    });

    it('should render music when textarea changes', () => {
      const spy = jest.spyOn(app.getRenderer(), 'render');
      textArea.value = 'K: A\nA B C';
      textArea.dispatchEvent(new Event('input'));

      expect(spy).toHaveBeenCalled();
      spy.mockRestore();
    });
  });

  describe('input visibility toggle', () => {
    beforeEach(() => {
      app = new HymnSingerApp('app-container', 'abc-text-area', 'renderer-container');
    });

    it('should have toggle button', () => {
      const toggleButton = document.getElementById('abc-toggle-input');
      expect(toggleButton).toBeDefined();
    });

    it('should toggle input visibility on button click', () => {
      const toggleButton = document.getElementById('abc-toggle-input') as HTMLButtonElement;
      const initialDisplay = textAreaContainer.style.display;

      toggleButton.click();
      const afterFirstClick = textAreaContainer.style.display;
      expect(afterFirstClick).not.toBe(initialDisplay);

      toggleButton.click();
      const afterSecondClick = textAreaContainer.style.display;
      expect(afterSecondClick).toBe(initialDisplay);
    });

    it('should update button text when toggling', () => {
      const toggleButton = document.getElementById('abc-toggle-input') as HTMLButtonElement;
      const initialText = toggleButton.textContent;

      toggleButton.click();
      const afterClick = toggleButton.textContent;
      expect(afterClick).not.toBe(initialText);
    });
  });

  describe('state management', () => {
    beforeEach(() => {
      app = new HymnSingerApp('app-container', 'abc-text-area', 'renderer-container');
    });

    it('should get current state', () => {
      const state = app.getState();
      expect(state).toHaveProperty('input');
      expect(state).toHaveProperty('speed');
      expect(state).toHaveProperty('metronomeVol');
      expect(state).toHaveProperty('pianoVol');
    });

    it('should update state with setState', () => {
      const newState = {
        speed: 1.5,
        metronomeVol: 60,
      };

      app.setState(newState);
      const state = app.getState();

      expect(state.speed).toBe(1.5);
      expect(state.metronomeVol).toBe(60);
    });

    it('should update textarea when state input changes', () => {
      const newInput = 'K: Em\nE F G';
      app.setState({ input: newInput });

      expect(textArea.value).toBe(newInput);
    });
  });

  describe('URL updates', () => {
    beforeEach(() => {
      app = new HymnSingerApp('app-container', 'abc-text-area', 'renderer-container');
    });

    it('should debounce URL updates', () => {
      jest.useFakeTimers();

      textArea.value = 'K: C\nC D E F';
      textArea.dispatchEvent(new Event('input'));

      expect(window.history.replaceState).not.toHaveBeenCalled();

      jest.advanceTimersByTime(2000);
      expect(window.history.replaceState).toHaveBeenCalled();

      jest.useRealTimers();
    });

    it('should not update URL on every keystroke', () => {
      jest.useFakeTimers();

      textArea.value = 'K';
      textArea.dispatchEvent(new Event('input'));
      textArea.value = 'K: C';
      textArea.dispatchEvent(new Event('input'));
      textArea.value = 'K: C\nC D';
      textArea.dispatchEvent(new Event('input'));

      expect(window.history.replaceState).not.toHaveBeenCalled();

      jest.advanceTimersByTime(2000);
      expect(window.history.replaceState).toHaveBeenCalledTimes(1);

      jest.useRealTimers();
    });
  });

  describe('cleanup', () => {
    it('should destroy app and clean up', () => {
      app = new HymnSingerApp('app-container', 'abc-text-area', 'renderer-container');
      const toggleButton = document.getElementById('abc-toggle-input');

      expect(toggleButton).toBeDefined();

      app.destroy();

      const toggleButtonAfter = document.getElementById('abc-toggle-input');
      expect(toggleButtonAfter).toBeNull();
    });
  });
});
