import { StateParser, type AppState } from './StateParser';
import { BouncingCursor } from './BouncingCursor';

export interface RenderingOptions {
  viewportHorizontal?: boolean;
  scrollHorizontal?: boolean;
  paddingbottom?: number;
  paddingleft?: number;
  paddingright?: number;
  paddingtop?: number;
  selectionColor?: string;
  staffwidth?: number;
}

/**
 * MusicRenderer handles ABC notation rendering via abcjs.
 * Provides horizontal scrolling, lyric alignment, and synced playback.
 */
export class MusicRenderer {
  private container: HTMLElement;
  private svgWrapper: HTMLElement;
  private abcjsInstance: any; // Type from abcjs library
  private cursorControl: BouncingCursor | null = null;

  constructor(containerId: string) {
    const container = document.getElementById(containerId);
    if (!container) {
      throw new Error(`Container with id "${containerId}" not found`);
    }
    this.container = container;

    // Create SVG wrapper with horizontal scrolling
    this.svgWrapper = document.createElement('div');
    this.svgWrapper.id = 'abc-svg-wrapper';
    this.svgWrapper.style.overflowX = 'auto';
    this.svgWrapper.style.overflowY = 'hidden';
    this.svgWrapper.style.whiteSpace = 'nowrap';
    this.svgWrapper.style.width = '100%';
    this.svgWrapper.style.position = 'relative';
    this.svgWrapper.style.backgroundColor = '#f9f9f9';
    this.container.appendChild(this.svgWrapper);
  }

  /**
   * Render ABC notation to SVG.
   * 
   * @param abcNotation - ABC notation string
   * @param options - Rendering options
   */
  public render(abcNotation: string, options: RenderingOptions = {}): void {
    const defaultOptions: RenderingOptions = {
      viewportHorizontal: true,
      scrollHorizontal: true,
      paddingbottom: 20,
      paddingleft: 20,
      paddingright: 20,
      paddingtop: 20,
      staffwidth: 800,
      ...options,
    };

    // Clear previous rendering
    this.svgWrapper.innerHTML = '';

    try {
      // Type-safe abcjs rendering
      // In a real implementation, this would use the actual abcjs library
      if (typeof (window as any).abcjs !== 'undefined') {
        const abcjs = (window as any).abcjs;
        this.abcjsInstance = abcjs.renderAbc(
          'abc-svg-container',
          abcNotation,
          defaultOptions
        );
      } else {
        // Fallback for testing without abcjs
        this.createFallbackSvg(abcNotation);
      }
    } catch (error) {
      console.error('Failed to render ABC notation:', error);
      this.svgWrapper.innerHTML = '<p style="color: red; padding: 20px;">Error rendering music notation</p>';
    }
  }

  /**
   * Create fallback SVG for testing (when abcjs is not available).
   */
  private createFallbackSvg(abcNotation: string): void {
    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.setAttribute('width', '800');
    svg.setAttribute('height', '200');
    svg.setAttribute('style', 'display: inline-block;');

    // Add staff lines
    for (let i = 0; i < 5; i++) {
      const y = 40 + i * 15;
      const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.setAttribute('x1', '0');
      line.setAttribute('y1', `${y}`);
      line.setAttribute('x2', '800');
      line.setAttribute('y2', `${y}`);
      line.setAttribute('stroke', '#ccc');
      line.setAttribute('stroke-width', '1');
      svg.appendChild(line);
    }

    // Add text label
    const text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    text.setAttribute('x', '20');
    text.setAttribute('y', '30');
    text.setAttribute('font-size', '12');
    text.textContent = 'ABC Music Notation';
    svg.appendChild(text);

    this.svgWrapper.appendChild(svg);
  }

  /**
   * Get the current abcjs rendering instance.
   */
  public getAbcjsInstance(): any {
    return this.abcjsInstance;
  }

  /**
   * Enable cursor playback tracking.
   */
  public enableCursor(): BouncingCursor {
    if (!this.cursorControl) {
      this.cursorControl = new BouncingCursor('abc-svg-wrapper');
      this.cursorControl.create();
    }
    return this.cursorControl;
  }

  /**
   * Disable cursor.
   */
  public disableCursor(): void {
    if (this.cursorControl) {
      this.cursorControl.destroy();
      this.cursorControl = null;
    }
  }

  /**
   * Get the SVG wrapper element.
   */
  public getSvgWrapper(): HTMLElement {
    return this.svgWrapper;
  }

  /**
   * Destroy the renderer.
   */
  public destroy(): void {
    this.disableCursor();
    this.svgWrapper.innerHTML = '';
    if (this.svgWrapper.parentElement) {
      this.svgWrapper.parentElement.removeChild(this.svgWrapper);
    }
  }
}

/**
 * HymnSingerApp is the main application controller.
 * Manages state, UI, and rendering.
 */
export class HymnSingerApp {
  private state: AppState;
  private textArea: HTMLTextAreaElement;
  private renderer: MusicRenderer;
  private toggleButton: HTMLButtonElement;
  private inputContainer: HTMLElement;
  private isInputVisible: boolean;
  private debouncedUrlUpdate: (state: AppState) => void;
  private onTextChangeHandler: () => void;

  constructor(
    appContainerId: string,
    textAreaId: string,
    rendererContainerId: string
  ) {
    // Parse initial state from URL
    this.state = StateParser.parseFromUrl(window.location.search);

    // Get or create elements
    const appContainer = document.getElementById(appContainerId);
    if (!appContainer) {
      throw new Error(`App container with id "${appContainerId}" not found`);
    }

    const textArea = document.getElementById(textAreaId) as HTMLTextAreaElement;
    if (!textArea) {
      throw new Error(`Text area with id "${textAreaId}" not found`);
    }
    this.textArea = textArea;

    // Create renderer
    this.renderer = new MusicRenderer(rendererContainerId);

    // Set up input container for collapsing
    const textAreaParent = textArea.parentElement;
    if (!textAreaParent) {
      throw new Error(`Text area must have a parent element`);
    }
    this.inputContainer = textAreaParent;

    // Create toggle button
    this.toggleButton = document.createElement('button');
    this.toggleButton.id = 'abc-toggle-input';
    this.toggleButton.style.marginBottom = '10px';
    this.toggleButton.onclick = () => this.toggleInputVisibility();

    // Insert toggle button before text area
    this.inputContainer.insertBefore(this.toggleButton, this.textArea);

    // Determine initial visibility based on URL payload
    this.isInputVisible = !this.state.hasUrlPayload;
    this.setInputVisibility(this.isInputVisible);

    // Set initial text area content
    this.textArea.value = this.state.input;

    // Set up debounced URL updates
    this.debouncedUrlUpdate = StateParser.createDebouncedUrlUpdater(
      (url) => this.updateUrl(url),
      2000
    );

    // Bind the event handler for proper removal later
    this.onTextChangeHandler = () => this.onTextChange();

    // Attach event listeners
    this.textArea.addEventListener('input', this.onTextChangeHandler);

    // Initial render
    this.render();
  }

  private onTextChange(): void {
    this.state.input = this.textArea.value;
    this.debouncedUrlUpdate(this.state);
    this.render();
  }

  private render(): void {
    this.renderer.render(this.state.input);
  }

  private toggleInputVisibility(): void {
    this.isInputVisible = !this.isInputVisible;
    this.setInputVisibility(this.isInputVisible);
  }

  private setInputVisibility(visible: boolean): void {
    this.inputContainer.style.display = visible ? 'block' : 'none';
    this.toggleButton.textContent = visible ? 'Hide Input' : 'Show Input';
  }

  private updateUrl(url: string): void {
    window.history.replaceState(null, '', url);
  }

  /**
   * Get the current state.
   */
  public getState(): AppState {
    return this.state;
  }

  /**
   * Update application state.
   */
  public setState(newState: Partial<AppState>): void {
    this.state = { ...this.state, ...newState };
    this.textArea.value = this.state.input;
    this.debouncedUrlUpdate(this.state);
    this.render();
  }

  /**
   * Get the music renderer instance.
   */
  public getRenderer(): MusicRenderer {
    return this.renderer;
  }

  /**
   * Destroy the application.
   */
  public destroy(): void {
    this.renderer.destroy();
    this.textArea.removeEventListener('input', this.onTextChangeHandler);
    if (this.toggleButton.parentElement) {
      this.toggleButton.parentElement.removeChild(this.toggleButton);
    }
  }
}
