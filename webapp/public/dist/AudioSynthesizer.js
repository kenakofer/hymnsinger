/**
 * AudioSynthesizer manages the Web Audio API and abcjs synth integration.
 * Handles synth initialization, buffer priming, and basic playback control.
 */
export class AudioSynthesizer {
    constructor() {
        Object.defineProperty(this, "audioContext", {
            enumerable: true,
            configurable: true,
            writable: true,
            value: null
        });
        Object.defineProperty(this, "synth", {
            enumerable: true,
            configurable: true,
            writable: true,
            value: null
        }); // abcjs.synth.CreateSynth instance
        Object.defineProperty(this, "synthController", {
            enumerable: true,
            configurable: true,
            writable: true,
            value: null
        }); // abcjs.synth.SynthController instance
        Object.defineProperty(this, "isPrimed", {
            enumerable: true,
            configurable: true,
            writable: true,
            value: false
        });
        Object.defineProperty(this, "isPlaying", {
            enumerable: true,
            configurable: true,
            writable: true,
            value: false
        });
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
            // Resolve ABCJS global and ensure synth API exists before use
            const abcjsGlobal = window.ABCJS || window.abcjs;
            if (!abcjsGlobal || !abcjsGlobal.synth) {
                throw new Error('ABCJS synth API not available (ABCJS/abcjs.synth missing)');
            }
            // Create synth instance
            this.synth = new abcjsGlobal.synth.CreateSynth();
            // Set tempo and metronome options
            const options = {
                soundFontUrl: 'https://gleitz.github.io/midi-js-soundfonts/FluidR3_GM/',
                metronomeEnabled: metronomeEnabled,
                onEnded: () => this.onSynthEnded(),
            };
            // Prepare audio data by calling setUpAudio if available
            if (typeof abcjsInstance[0].setUpAudio === 'function') {
                try {
                    abcjsInstance[0].setUpAudio();
                    console.log('Called visualObj.setUpAudio()');
                }
                catch (err) {
                    console.warn('setUpAudio() call failed:', err);
                }
            }
            // Initialize with the parsed ABC visual object (first element of renderAbc result)
            console.log('Calling synth.init with visualObj:', abcjsInstance[0]);
            await this.synth.init({
                audioContext: this.audioContext,
                visualObj: abcjsInstance[0],
                options: options,
            });
            // If init didn't populate tunes, log a warning but continue
            // (abcjs-basic.min.js has limited synth support; directSource will be empty but SynthController.play() still works)
            if (!this.synth.tunes || this.synth.tunes.length === 0) {
                console.warn('Synth.tunes empty after init - this is a limitation of abcjs-basic.min.js. Audio may be limited but playback via SynthController should still work.');
            }
            // Verify synth state after init
            const synthState = {
                hasTunes: !!this.synth.tunes,
                tuneCount: this.synth.tunes?.length || 0,
                hasDirectSource: !!this.synth.directSource,
                directSourceLength: this.synth.directSource?.length || 0,
                hasSequence: !!this.synth.sequenceArray,
            };
            console.log('Synth state after init:', synthState);
            if (!this.synth.directSource || this.synth.directSource.length === 0) {
                console.warn('Warning: synth.directSource not populated after init. Audio may not work.');
            }
            // Create controller for volume/speed control
            this.synthController = new abcjsGlobal.synth.SynthController();
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
            // Conservative guard: check for internal audio/source fields that abcjs expects
            const synthKeys = Object.keys(this.synth || {});
            const hasInternalSource = synthKeys.includes('directSource') || synthKeys.includes('directSources') || synthKeys.some(k => /direct|source|audio/i.test(k));
            if (!hasInternalSource) {
                console.info('Synth priming skipped: synth lacks internal source fields', synthKeys);
            }
            else {
                // Prime by playing a tiny bit using a flexible API guard
                if (typeof this.synth.play === 'function') {
                    await this.synth.play();
                    this.synth.stop?.();
                }
                else if (typeof this.synth.start === 'function') {
                    await this.synth.start();
                    this.synth.stop?.();
                }
                else if (typeof this.synth.resume === 'function') {
                    await this.synth.resume();
                    this.synth.pause?.();
                }
                else {
                    console.warn('Synth priming skipped: no playable method found', synthKeys);
                }
                console.log('Synth buffer primed');
            }
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
            // Prefer synthController which wraps synth and handles audio state correctly
            if (this.synthController && typeof this.synthController.play === 'function') {
                this.synthController.play();
            }
            else if (typeof this.synth.play === 'function') {
                this.synth.play();
            }
            else if (typeof this.synth.start === 'function') {
                this.synth.start();
            }
            else {
                console.error('Failed to start playback: no playable method on synth or controller');
                return;
            }
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
            if (typeof this.synth.stop === 'function') {
                this.synth.stop();
            }
            else if (typeof this.synth.pause === 'function') {
                // Some APIs expose pause instead of stop
                this.synth.pause();
            }
            else {
                console.warn('No stop/pause method on synth', Object.keys(this.synth || {}));
            }
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
            if (typeof this.synth.pause === 'function') {
                this.synth.pause();
            }
            else if (typeof this.synth.stop === 'function') {
                this.synth.stop();
            }
            else {
                console.warn('No pause/stop method on synth', Object.keys(this.synth || {}));
            }
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
            if (typeof this.synth.resume === 'function') {
                this.synth.resume();
            }
            else if (typeof this.synth.start === 'function') {
                this.synth.start();
            }
            else {
                console.warn('No resume/start method on synth', Object.keys(this.synth || {}));
            }
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
//# sourceMappingURL=AudioSynthesizer.js.map