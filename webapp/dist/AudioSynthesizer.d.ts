/**
 * AudioSynthesizer manages the Web Audio API and abcjs synth integration.
 * Handles synth initialization, buffer priming, and basic playback control.
 */
export declare class AudioSynthesizer {
    private audioContext;
    private synth;
    private synthController;
    private isPrimed;
    private isPlaying;
    constructor();
    /**
     * Initialize the Web Audio API AudioContext.
     * Creates a single context shared across the application.
     */
    private initializeAudioContext;
    /**
     * Initialize the abcjs synth and prime the audio buffer.
     * Must be called after the ABC notation has been parsed.
     *
     * @param abcjsInstance - The abcjs instance (from abcjs.renderAbc)
     * @param metronomeEnabled - Whether to enable the built-in metronome
     */
    initializeSynth(abcjsInstance: any, metronomeEnabled?: boolean): Promise<void>;
    /**
     * Prime the audio buffer by starting and immediately stopping playback.
     * This ensures the first real playback starts immediately.
     */
    private primeSynthBuffer;
    /**
     * Start playback of the synth.
     */
    play(): void;
    /**
     * Stop playback of the synth.
     */
    stop(): void;
    /**
     * Pause playback (can be resumed later).
     */
    pause(): void;
    /**
     * Resume paused playback.
     */
    resume(): void;
    /**
     * Called when synth finishes playback.
     */
    private onSynthEnded;
    /**
     * Set the playback speed (tempo).
     *
     * @param speed - Speed multiplier (e.g., 1.0 = normal, 1.5 = 1.5x speed)
     */
    setSpeed(speed: number): void;
    /**
     * Set the piano volume.
     *
     * @param volume - Volume level (0-100)
     */
    setPianoVolume(volume: number): void;
    /**
     * Set the metronome volume.
     *
     * @param volume - Volume level (0-100)
     */
    setMetronomeVolume(volume: number): void;
    /**
     * Check if synth is primed and ready to play.
     */
    isPrimmed(): boolean;
    /**
     * Check if currently playing.
     */
    getIsPlaying(): boolean;
    /**
     * Get the audio context.
     */
    getAudioContext(): AudioContext | null;
    /**
     * Get the synth instance.
     */
    getSynth(): any;
    /**
     * Get the synth controller.
     */
    getSynthController(): any;
    /**
     * Cleanup: stop playback and release resources.
     */
    destroy(): void;
}
//# sourceMappingURL=AudioSynthesizer.d.ts.map