/**
 * AudioControls manages the UI sliders for playback speed and audio volume.
 * Provides range inputs for:
 * - Playback Speed (0.5x to 2.0x)
 * - Piano Volume (0 to 100)
 * - Metronome Volume (0 to 100)
 */
export interface AudioControlsConfig {
    onSpeedChange: (speed: number) => void;
    onPianoVolumeChange: (volume: number) => void;
    onMetronomeVolumeChange: (volume: number) => void;
}
export declare class AudioControls {
    private speedSlider;
    private pianoVolumeSlider;
    private metronomeVolumeSlider;
    private speedLabel;
    private pianoVolumeLabel;
    private metronomeVolumeLabel;
    private onSpeedChange;
    private onPianoVolumeChange;
    private onMetronomeVolumeChange;
    private onSpeedInputHandler;
    private onPianoVolumeInputHandler;
    private onMetronomeVolumeInputHandler;
    constructor(config: AudioControlsConfig);
    /**
     * Initialize the audio controls UI by creating slider elements.
     * Returns a container div with all sliders and labels.
     */
    create(): HTMLElement;
    /**
     * Create a labeled slider control.
     */
    private createSliderControl;
    /**
     * Format value display based on control type.
     */
    private formatValue;
    /**
     * Attach event listeners to all sliders.
     */
    private attachEventHandlers;
    /**
     * Update label text to reflect current slider value.
     */
    private updateLabel;
    /**
     * Set the current speed value programmatically.
     */
    setSpeed(speed: number): void;
    /**
     * Set the current piano volume value programmatically.
     */
    setPianoVolume(volume: number): void;
    /**
     * Set the current metronome volume value programmatically.
     */
    setMetronomeVolume(volume: number): void;
    /**
     * Get the current speed value.
     */
    getSpeed(): number;
    /**
     * Get the current piano volume value.
     */
    getPianoVolume(): number;
    /**
     * Get the current metronome volume value.
     */
    getMetronomeVolume(): number;
    /**
     * Clean up event listeners and DOM elements.
     */
    destroy(): void;
}
//# sourceMappingURL=AudioControls.d.ts.map