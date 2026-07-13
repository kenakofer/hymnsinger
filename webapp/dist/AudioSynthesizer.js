"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AudioSynthesizer = void 0;
/**
 * AudioSynthesizer manages the Web Audio API and abcjs synth integration.
 * Handles synth initialization, buffer priming, and basic playback control.
 */
class AudioSynthesizer {
    constructor() {
        this.audioContext = null;
        this.synth = null; // abcjs.synth.CreateSynth instance
        this.synthController = null; // abcjs.synth.SynthController instance
        this.isPrimed = false;
        this.isPlaying = false;
        this.initializeAudioContext();
    }
    /**
     * Initialize the Web Audio API AudioContext.
     * Creates a single context shared across the application.
     */
    initializeAudioContext() {
        if (typeof window === 'undefined')
            return;
        const AudioContextClass = window.AudioContext || window.webkitAudioContext;
        if (!AudioContextClass) {
            console.warn('Web Audio API not supported in this browser');
            return;
        }
        try {
            this.audioContext = new AudioContextClass();
            console.log('AudioContext initialized:', this.audioContext?.state);
        }
        catch (error) {
            console.error('Failed to initialize AudioContext:', error);
        }
    }
    /**
     * Initialize the abcjs synth and prime the audio buffer.
     * Must be called after the ABC notation has been parsed.
     *
     * @param abcjsInstance - The abcjs instance (from abcjs.renderAbc)
     * @param metronomeEnabled - Whether to enable the built-in metronome
     */
    async initializeSynth(abcjsInstance, metronomeEnabled = true) {
        if (!this.audioContext) {
            throw new Error('AudioContext not initialized');
        }
        if (!abcjsInstance || !abcjsInstance[0]) {
            throw new Error('Valid abcjs instance required for synth initialization');
        }
        try {
            // Resume AudioContext if it's in suspended state (required by many browsers)
            if (this.audioContext.state === 'suspended') {
                await this.audioContext.resume();
            }
            // Create synth instance
            this.synth = new window.abcjs.synth.CreateSynth();
            // Set tempo and metronome options
            const options = {
                soundFontUrl: 'https://gleitz.github.io/midi-js-soundfonts/FluidR3_GM/',
                metronomeEnabled: metronomeEnabled,
                onEnded: () => this.onSynthEnded(),
            };
            // Initialize with the parsed ABC object
            await this.synth.init({
                audioContext: this.audioContext,
                visualObj: abcjsInstance,
                options: options,
            });
            // Create controller for volume/speed control
            this.synthController = new window.abcjs.synth.SynthController();
            this.synthController.load('#abc-svg-wrapper', null, this.synth);
            // Prime the buffer
            await this.primeSynthBuffer();
            this.isPrimed = true;
            console.log('Synth initialized and primed successfully');
        }
        catch (error) {
            console.error('Failed to initialize synth:', error);
            throw error;
        }
    }
    /**
     * Prime the audio buffer by starting and immediately stopping playback.
     * This ensures the first real playback starts immediately.
     */
    async primeSynthBuffer() {
        if (!this.synth)
            return;
        try {
            // Prime by playing a tiny bit
            await this.synth.play();
            // Stop immediately
            this.synth.stop();
            console.log('Synth buffer primed');
        }
        catch (error) {
            console.warn('Buffer priming warning:', error);
            // Non-critical error, continue anyway
        }
    }
    /**
     * Start playback of the synth.
     */
    play() {
        if (!this.synth) {
            console.error('Synth not initialized');
            return;
        }
        if (this.isPlaying) {
            console.warn('Already playing');
            return;
        }
        try {
            this.synth.play();
            this.isPlaying = true;
            console.log('Playback started');
        }
        catch (error) {
            console.error('Failed to start playback:', error);
        }
    }
    /**
     * Stop playback of the synth.
     */
    stop() {
        if (!this.synth) {
            console.error('Synth not initialized');
            return;
        }
        if (!this.isPlaying) {
            console.warn('Not currently playing');
            return;
        }
        try {
            this.synth.stop();
            this.isPlaying = false;
            console.log('Playback stopped');
        }
        catch (error) {
            console.error('Failed to stop playback:', error);
        }
    }
    /**
     * Pause playback (can be resumed later).
     */
    pause() {
        if (!this.synth || !this.isPlaying)
            return;
        try {
            this.synth.pause();
            this.isPlaying = false;
            console.log('Playback paused');
        }
        catch (error) {
            console.error('Failed to pause playback:', error);
        }
    }
    /**
     * Resume paused playback.
     */
    resume() {
        if (!this.synth)
            return;
        try {
            this.synth.resume();
            this.isPlaying = true;
            console.log('Playback resumed');
        }
        catch (error) {
            console.error('Failed to resume playback:', error);
        }
    }
    /**
     * Called when synth finishes playback.
     */
    onSynthEnded() {
        this.isPlaying = false;
        console.log('Synth playback ended');
    }
    /**
     * Set the playback speed (tempo).
     *
     * @param speed - Speed multiplier (e.g., 1.0 = normal, 1.5 = 1.5x speed)
     */
    setSpeed(speed) {
        if (!this.synthController) {
            console.warn('Synth controller not initialized');
            return;
        }
        try {
            this.synthController.setTempo(speed);
            console.log('Speed set to:', speed);
        }
        catch (error) {
            console.error('Failed to set speed:', error);
        }
    }
    /**
     * Set the piano volume.
     *
     * @param volume - Volume level (0-100)
     */
    setPianoVolume(volume) {
        if (!this.synthController) {
            console.warn('Synth controller not initialized');
            return;
        }
        // Clamp volume to 0-100
        const clampedVolume = Math.max(0, Math.min(100, volume));
        try {
            // setVolume typically expects 0-1 range, so convert from 0-100
            this.synthController.setSoundFontVolumePercent(clampedVolume);
            console.log('Piano volume set to:', clampedVolume);
        }
        catch (error) {
            console.error('Failed to set piano volume:', error);
        }
    }
    /**
     * Set the metronome volume.
     *
     * @param volume - Volume level (0-100)
     */
    setMetronomeVolume(volume) {
        if (!this.synthController) {
            console.warn('Synth controller not initialized');
            return;
        }
        // Clamp volume to 0-100
        const clampedVolume = Math.max(0, Math.min(100, volume));
        try {
            // Set metronome-specific volume if available
            if (this.synthController.setMetronomeVolumePercent) {
                this.synthController.setMetronomeVolumePercent(clampedVolume);
            }
            else {
                // Fallback: adjust main volume
                this.synthController.setSoundFontVolumePercent(clampedVolume);
            }
            console.log('Metronome volume set to:', clampedVolume);
        }
        catch (error) {
            console.error('Failed to set metronome volume:', error);
        }
    }
    /**
     * Check if synth is primed and ready to play.
     */
    isPrimmed() {
        return this.isPrimed;
    }
    /**
     * Check if currently playing.
     */
    getIsPlaying() {
        return this.isPlaying;
    }
    /**
     * Get the audio context.
     */
    getAudioContext() {
        return this.audioContext;
    }
    /**
     * Get the synth instance.
     */
    getSynth() {
        return this.synth;
    }
    /**
     * Get the synth controller.
     */
    getSynthController() {
        return this.synthController;
    }
    /**
     * Cleanup: stop playback and release resources.
     */
    destroy() {
        if (this.isPlaying) {
            this.stop();
        }
        this.synth = null;
        this.synthController = null;
        // Note: We keep audioContext alive as per Web Audio API best practices
        // It's typically a singleton for the application
        console.log('AudioSynthesizer cleaned up');
    }
}
exports.AudioSynthesizer = AudioSynthesizer;
//# sourceMappingURL=AudioSynthesizer.js.map