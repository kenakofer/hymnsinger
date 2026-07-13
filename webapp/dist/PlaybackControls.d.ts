/**
 * PlaybackControls manages the UI buttons for audio playback control.
 * Provides play, pause, and stop buttons with visual state feedback.
 */
export interface PlaybackControlsConfig {
    onPlay: () => void;
    onPause: () => void;
    onStop: () => void;
}
export declare class PlaybackControls {
    private container;
    private playButton;
    private pauseButton;
    private stopButton;
    private isPlaying;
    private onPlay;
    private onPause;
    private onStop;
    private onPlayClickHandler;
    private onPauseClickHandler;
    private onStopClickHandler;
    constructor(config: PlaybackControlsConfig);
    /**
     * Create the playback control UI with play, pause, and stop buttons.
     * Returns a container div with all buttons.
     */
    create(): HTMLElement;
    /**
     * Create a styled button element.
     */
    private createButton;
    /**
     * Attach event listeners to buttons.
     */
    private attachEventHandlers;
    /**
     * Handle play button click.
     */
    private handlePlayClick;
    /**
     * Handle pause button click.
     */
    private handlePauseClick;
    /**
     * Handle stop button click.
     */
    private handleStopClick;
    /**
     * Update button enabled/disabled states based on playback state.
     */
    private updateButtonStates;
    /**
     * Update the status indicator text.
     */
    private updateStatusIndicator;
    /**
     * Get the playback state.
     */
    isPlayingState(): boolean;
    /**
     * Set the playback state without triggering callbacks.
     * Useful for syncing UI state after external state changes.
     */
    setPlayingState(playing: boolean): void;
    /**
     * Stop playback and reset UI.
     */
    stop(): void;
    /**
     * Clean up event listeners and DOM elements.
     */
    destroy(): void;
}
//# sourceMappingURL=PlaybackControls.d.ts.map