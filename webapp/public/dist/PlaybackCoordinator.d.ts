import { AudioSynthesizer } from './AudioSynthesizer.js';
/**
 * PlaybackCoordinator manages playback synchronization between the synth,
 * visual cursor, and horizontal scrolling of the music renderer.
 */
export declare class PlaybackCoordinator {
    private audioSynthesizer;
    private svgWrapper;
    private isPlaying;
    private scrollAnimationId;
    private cursorObserver;
    constructor();
    /**
     * Initialize the PlaybackCoordinator with synthesizer and renderer.
     *
     * @param synthesizer - The AudioSynthesizer instance
     * @param svgWrapperElement - The horizontally scrolling SVG container
     */
    initialize(synthesizer: AudioSynthesizer, svgWrapperElement: HTMLElement): void;
    /**
     * Start playback and set up scroll synchronization.
     * Triggers synth playback which automatically runs TimingCallbacks.
     */
    play(): void;
    /**
     * Stop playback and cancel scroll synchronization.
     */
    stop(): void;
    /**
     * Pause playback (can be resumed).
     */
    pause(): void;
    /**
     * Resume paused playback.
     */
    resume(): void;
    /**
     * Start synchronizing horizontal scroll with cursor position.
     * Observes the bouncing cursor element and keeps it centered in viewport.
     */
    private startScrollSync;
    /**
     * Stop horizontal scroll synchronization.
     */
    private stopScrollSync;
    /**
     * Check if currently playing.
     */
    getIsPlaying(): boolean;
    /**
     * Get the audio synthesizer.
     */
    getSynthesizer(): AudioSynthesizer | null;
    /**
     * Get the SVG wrapper element.
     */
    getSvgWrapper(): HTMLElement | null;
    /**
     * Cleanup: stop playback and release resources.
     */
    destroy(): void;
}
//# sourceMappingURL=PlaybackCoordinator.d.ts.map