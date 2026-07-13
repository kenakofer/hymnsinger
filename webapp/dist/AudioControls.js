"use strict";
/**
 * AudioControls manages the UI sliders for playback speed and audio volume.
 * Provides range inputs for:
 * - Playback Speed (0.5x to 2.0x)
 * - Piano Volume (0 to 100)
 * - Metronome Volume (0 to 100)
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.AudioControls = void 0;
class AudioControls {
    constructor(config) {
        this.speedSlider = null;
        this.pianoVolumeSlider = null;
        this.metronomeVolumeSlider = null;
        this.speedLabel = null;
        this.pianoVolumeLabel = null;
        this.metronomeVolumeLabel = null;
        // Store bound event handlers for proper cleanup
        this.onSpeedInputHandler = null;
        this.onPianoVolumeInputHandler = null;
        this.onMetronomeVolumeInputHandler = null;
        this.onSpeedChange = config.onSpeedChange;
        this.onPianoVolumeChange = config.onPianoVolumeChange;
        this.onMetronomeVolumeChange = config.onMetronomeVolumeChange;
    }
    /**
     * Initialize the audio controls UI by creating slider elements.
     * Returns a container div with all sliders and labels.
     */
    create() {
        const container = document.createElement('div');
        container.id = 'audio-controls-container';
        container.style.cssText = `
      display: flex;
      flex-direction: column;
      gap: 12px;
      padding: 12px;
      background-color: #f5f5f5;
      border-bottom: 1px solid #ddd;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      font-size: 14px;
    `;
        // Speed control
        const speedControl = this.createSliderControl('speed-slider', 'speed-label', 'Speed', 0.5, 2.0, 1.0, 0.1);
        container.appendChild(speedControl);
        // Piano volume control
        const pianoVolumeControl = this.createSliderControl('piano-volume-slider', 'piano-volume-label', 'Piano Volume', 0, 100, 80, 1);
        container.appendChild(pianoVolumeControl);
        // Metronome volume control
        const metronomeVolumeControl = this.createSliderControl('metronome-volume-slider', 'metronome-volume-label', 'Metronome Volume', 0, 100, 50, 1);
        container.appendChild(metronomeVolumeControl);
        // Get references to sliders and labels (from within the container, not from document)
        this.speedSlider = container.querySelector('#speed-slider');
        this.pianoVolumeSlider = container.querySelector('#piano-volume-slider');
        this.metronomeVolumeSlider = container.querySelector('#metronome-volume-slider');
        this.speedLabel = container.querySelector('#speed-label');
        this.pianoVolumeLabel = container.querySelector('#piano-volume-label');
        this.metronomeVolumeLabel = container.querySelector('#metronome-volume-label');
        // Attach event handlers
        this.attachEventHandlers();
        return container;
    }
    /**
     * Create a labeled slider control.
     */
    createSliderControl(sliderId, labelId, label, min, max, value, step) {
        const wrapper = document.createElement('div');
        wrapper.style.cssText = `
      display: flex;
      align-items: center;
      gap: 8px;
    `;
        const labelEl = document.createElement('label');
        labelEl.id = labelId;
        labelEl.htmlFor = sliderId;
        labelEl.style.cssText = `
      flex: 0 0 140px;
      font-weight: 500;
      white-space: nowrap;
    `;
        labelEl.textContent = `${label}: ${this.formatValue(label, value)}`;
        const slider = document.createElement('input');
        slider.type = 'range';
        slider.id = sliderId;
        slider.min = min.toString();
        slider.max = max.toString();
        slider.value = value.toString();
        slider.step = step.toString();
        slider.style.cssText = `
      flex: 1;
      min-width: 200px;
      cursor: pointer;
    `;
        wrapper.appendChild(labelEl);
        wrapper.appendChild(slider);
        return wrapper;
    }
    /**
     * Format value display based on control type.
     */
    formatValue(label, value) {
        if (label === 'Speed') {
            return `${value.toFixed(1)}x`;
        }
        return `${Math.round(value)}`;
    }
    /**
     * Attach event listeners to all sliders.
     */
    attachEventHandlers() {
        if (this.speedSlider) {
            this.onSpeedInputHandler = (e) => {
                const target = e.target;
                const speed = parseFloat(target.value);
                this.updateLabel(this.speedLabel, 'Speed', speed);
                this.onSpeedChange(speed);
            };
            this.speedSlider.addEventListener('input', this.onSpeedInputHandler);
            this.speedSlider.addEventListener('change', this.onSpeedInputHandler);
        }
        if (this.pianoVolumeSlider) {
            this.onPianoVolumeInputHandler = (e) => {
                const target = e.target;
                const volume = parseInt(target.value, 10);
                this.updateLabel(this.pianoVolumeLabel, 'Piano Volume', volume);
                this.onPianoVolumeChange(volume);
            };
            this.pianoVolumeSlider.addEventListener('input', this.onPianoVolumeInputHandler);
            this.pianoVolumeSlider.addEventListener('change', this.onPianoVolumeInputHandler);
        }
        if (this.metronomeVolumeSlider) {
            this.onMetronomeVolumeInputHandler = (e) => {
                const target = e.target;
                const volume = parseInt(target.value, 10);
                this.updateLabel(this.metronomeVolumeLabel, 'Metronome Volume', volume);
                this.onMetronomeVolumeChange(volume);
            };
            this.metronomeVolumeSlider.addEventListener('input', this.onMetronomeVolumeInputHandler);
            this.metronomeVolumeSlider.addEventListener('change', this.onMetronomeVolumeInputHandler);
        }
    }
    /**
     * Update label text to reflect current slider value.
     */
    updateLabel(labelEl, name, value) {
        if (labelEl) {
            labelEl.textContent = `${name}: ${this.formatValue(name, value)}`;
        }
    }
    /**
     * Set the current speed value programmatically.
     */
    setSpeed(speed) {
        if (this.speedSlider) {
            this.speedSlider.value = speed.toString();
            this.updateLabel(this.speedLabel, 'Speed', speed);
        }
    }
    /**
     * Set the current piano volume value programmatically.
     */
    setPianoVolume(volume) {
        if (this.pianoVolumeSlider) {
            this.pianoVolumeSlider.value = volume.toString();
            this.updateLabel(this.pianoVolumeLabel, 'Piano Volume', volume);
        }
    }
    /**
     * Set the current metronome volume value programmatically.
     */
    setMetronomeVolume(volume) {
        if (this.metronomeVolumeSlider) {
            this.metronomeVolumeSlider.value = volume.toString();
            this.updateLabel(this.metronomeVolumeLabel, 'Metronome Volume', volume);
        }
    }
    /**
     * Get the current speed value.
     */
    getSpeed() {
        return this.speedSlider ? parseFloat(this.speedSlider.value) : 1.0;
    }
    /**
     * Get the current piano volume value.
     */
    getPianoVolume() {
        return this.pianoVolumeSlider ? parseInt(this.pianoVolumeSlider.value, 10) : 80;
    }
    /**
     * Get the current metronome volume value.
     */
    getMetronomeVolume() {
        return this.metronomeVolumeSlider ? parseInt(this.metronomeVolumeSlider.value, 10) : 50;
    }
    /**
     * Clean up event listeners and DOM elements.
     */
    destroy() {
        if (this.speedSlider && this.onSpeedInputHandler) {
            this.speedSlider.removeEventListener('input', this.onSpeedInputHandler);
            this.speedSlider.removeEventListener('change', this.onSpeedInputHandler);
        }
        if (this.pianoVolumeSlider && this.onPianoVolumeInputHandler) {
            this.pianoVolumeSlider.removeEventListener('input', this.onPianoVolumeInputHandler);
            this.pianoVolumeSlider.removeEventListener('change', this.onPianoVolumeInputHandler);
        }
        if (this.metronomeVolumeSlider && this.onMetronomeVolumeInputHandler) {
            this.metronomeVolumeSlider.removeEventListener('input', this.onMetronomeVolumeInputHandler);
            this.metronomeVolumeSlider.removeEventListener('change', this.onMetronomeVolumeInputHandler);
        }
        this.speedSlider = null;
        this.pianoVolumeSlider = null;
        this.metronomeVolumeSlider = null;
        this.speedLabel = null;
        this.pianoVolumeLabel = null;
        this.metronomeVolumeLabel = null;
        this.onSpeedInputHandler = null;
        this.onPianoVolumeInputHandler = null;
        this.onMetronomeVolumeInputHandler = null;
    }
}
exports.AudioControls = AudioControls;
//# sourceMappingURL=AudioControls.js.map