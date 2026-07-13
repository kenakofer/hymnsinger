"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.HymnSingerApp = exports.MusicRenderer = void 0;
const StateParser_1 = require("./StateParser");
const BouncingCursor_1 = require("./BouncingCursor");
/**
 * MusicRenderer handles ABC notation rendering via abcjs.
 * Provides horizontal scrolling, lyric alignment, and synced playback.
 */
class MusicRenderer {
    constructor(containerId) {
        this.cursorControl = null;
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
    render(abcNotation, options = {}) {
        const defaultOptions = {
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
            if (typeof window.abcjs !== 'undefined') {
                const abcjs = window.abcjs;
                this.abcjsInstance = abcjs.renderAbc('abc-svg-container', abcNotation, defaultOptions);
            }
            else {
                // Fallback for testing without abcjs
                this.createFallbackSvg(abcNotation);
            }
        }
        catch (error) {
            console.error('Failed to render ABC notation:', error);
            this.svgWrapper.innerHTML = '<p style="color: red; padding: 20px;">Error rendering music notation</p>';
        }
    }
    /**
     * Create fallback SVG for testing (when abcjs is not available).
     */
    createFallbackSvg(abcNotation) {
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
    getAbcjsInstance() {
        return this.abcjsInstance;
    }
    /**
     * Enable cursor playback tracking.
     */
    enableCursor() {
        if (!this.cursorControl) {
            this.cursorControl = new BouncingCursor_1.BouncingCursor('abc-svg-wrapper');
            this.cursorControl.create();
        }
        return this.cursorControl;
    }
    /**
     * Disable cursor.
     */
    disableCursor() {
        if (this.cursorControl) {
            this.cursorControl.destroy();
            this.cursorControl = null;
        }
    }
    /**
     * Get the SVG wrapper element.
     */
    getSvgWrapper() {
        return this.svgWrapper;
    }
    /**
     * Destroy the renderer.
     */
    destroy() {
        this.disableCursor();
        this.svgWrapper.innerHTML = '';
        if (this.svgWrapper.parentElement) {
            this.svgWrapper.parentElement.removeChild(this.svgWrapper);
        }
    }
}
exports.MusicRenderer = MusicRenderer;
/**
 * HymnSingerApp is the main application controller.
 * Manages state, UI, and rendering.
 */
class HymnSingerApp {
    constructor(appContainerId, textAreaId, rendererContainerId) {
        // Parse initial state from URL
        this.state = StateParser_1.StateParser.parseFromUrl(window.location.search);
        // Get or create elements
        const appContainer = document.getElementById(appContainerId);
        if (!appContainer) {
            throw new Error(`App container with id "${appContainerId}" not found`);
        }
        const textArea = document.getElementById(textAreaId);
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
        this.debouncedUrlUpdate = StateParser_1.StateParser.createDebouncedUrlUpdater((url) => this.updateUrl(url), 2000);
        // Bind the event handler for proper removal later
        this.onTextChangeHandler = () => this.onTextChange();
        // Attach event listeners
        this.textArea.addEventListener('input', this.onTextChangeHandler);
        // Initial render
        this.render();
    }
    onTextChange() {
        this.state.input = this.textArea.value;
        this.debouncedUrlUpdate(this.state);
        this.render();
    }
    render() {
        this.renderer.render(this.state.input);
    }
    toggleInputVisibility() {
        this.isInputVisible = !this.isInputVisible;
        this.setInputVisibility(this.isInputVisible);
    }
    setInputVisibility(visible) {
        this.inputContainer.style.display = visible ? 'block' : 'none';
        this.toggleButton.textContent = visible ? 'Hide Input' : 'Show Input';
    }
    updateUrl(url) {
        window.history.replaceState(null, '', url);
    }
    /**
     * Get the current state.
     */
    getState() {
        return this.state;
    }
    /**
     * Update application state.
     */
    setState(newState) {
        this.state = { ...this.state, ...newState };
        this.textArea.value = this.state.input;
        this.debouncedUrlUpdate(this.state);
        this.render();
    }
    /**
     * Get the music renderer instance.
     */
    getRenderer() {
        return this.renderer;
    }
    /**
     * Destroy the application.
     */
    destroy() {
        this.renderer.destroy();
        this.textArea.removeEventListener('input', this.onTextChangeHandler);
        if (this.toggleButton.parentElement) {
            this.toggleButton.parentElement.removeChild(this.toggleButton);
        }
    }
}
exports.HymnSingerApp = HymnSingerApp;
//# sourceMappingURL=HymnSingerApp.js.map