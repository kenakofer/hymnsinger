import { type AppState } from './StateParser';
import { BouncingCursor } from './BouncingCursor';
import { AudioControls } from './AudioControls';
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
export declare class MusicRenderer {
    private container;
    private svgWrapper;
    private abcjsInstance;
    private cursorControl;
    constructor(containerId: string);
    /**
     * Render ABC notation to SVG.
     *
     * @param abcNotation - ABC notation string
     * @param options - Rendering options
     */
    render(abcNotation: string, options?: RenderingOptions): void;
    /**
     * Create fallback SVG for testing (when abcjs is not available).
     */
    private createFallbackSvg;
    /**
     * Get the current abcjs rendering instance.
     */
    getAbcjsInstance(): any;
    /**
     * Enable cursor playback tracking.
     */
    enableCursor(): BouncingCursor;
    /**
     * Disable cursor.
     */
    disableCursor(): void;
    /**
     * Get the SVG wrapper element.
     */
    getSvgWrapper(): HTMLElement;
    /**
     * Destroy the renderer.
     */
    destroy(): void;
}
/**
 * HymnSingerApp is the main application controller.
 * Manages state, UI, and rendering.
 */
export declare class HymnSingerApp {
    private state;
    private textArea;
    private renderer;
    private toggleButton;
    private inputContainer;
    private isInputVisible;
    private debouncedUrlUpdate;
    private onTextChangeHandler;
    private audioControls;
    private audioControlsContainer;
    private onSpeedChange;
    private onPianoVolumeChange;
    private onMetronomeVolumeChange;
    constructor(appContainerId: string, textAreaId: string, rendererContainerId: string, onSpeedChange?: (speed: number) => void, onPianoVolumeChange?: (volume: number) => void, onMetronomeVolumeChange?: (volume: number) => void);
    private onTextChange;
    private render;
    private toggleInputVisibility;
    private setInputVisibility;
    private updateUrl;
    /**
     * Get the current state.
     */
    getState(): AppState;
    /**
     * Update application state.
     */
    setState(newState: Partial<AppState>): void;
    /**
     * Get the music renderer instance.
     */
    getRenderer(): MusicRenderer;
    /**
     * Get the audio controls instance.
     */
    getAudioControls(): AudioControls | null;
    /**
     * Set audio control values programmatically.
     */
    setAudioControlValues(speed?: number, pianoVolume?: number, metronomeVolume?: number): void;
    /**
     * Destroy the application.
     */
    destroy(): void;
}
//# sourceMappingURL=HymnSingerApp.d.ts.map