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

export class AudioControls {
  private speedSlider: HTMLInputElement | null = null;
  private pianoVolumeSlider: HTMLInputElement | null = null;
  private metronomeVolumeSlider: HTMLInputElement | null = null;

  private speedLabel: HTMLElement | null = null;
  private pianoVolumeLabel: HTMLElement | null = null;
  private metronomeVolumeLabel: HTMLElement | null = null;

  private onSpeedChange: (speed: number) => void;
  private onPianoVolumeChange: (volume: number) => void;
  private onMetronomeVolumeChange: (volume: number) => void;

  // Store bound event handlers for proper cleanup
  private onSpeedInputHandler: ((e: Event) => void) | null = null;
  private onPianoVolumeInputHandler: ((e: Event) => void) | null = null;
  private onMetronomeVolumeInputHandler: ((e: Event) => void) | null = null;

  constructor(config: AudioControlsConfig) {
    this.onSpeedChange = config.onSpeedChange;
    this.onPianoVolumeChange = config.onPianoVolumeChange;
    this.onMetronomeVolumeChange = config.onMetronomeVolumeChange;
  }

  /**
   * Initialize the audio controls UI by creating slider elements.
   * Returns a container div with all sliders and labels.
   */
  public create(): HTMLElement {
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
    const speedControl = this.createSliderControl(
      'speed-slider',
      'speed-label',
      'Speed',
      0.5,
      2.0,
      1.0,
      0.1
    );
    container.appendChild(speedControl);

    // Piano volume control
    const pianoVolumeControl = this.createSliderControl(
      'piano-volume-slider',
      'piano-volume-label',
      'Piano Volume',
      0,
      100,
      80,
      1
    );
    container.appendChild(pianoVolumeControl);

    // Metronome volume control
    const metronomeVolumeControl = this.createSliderControl(
      'metronome-volume-slider',
      'metronome-volume-label',
      'Metronome Volume',
      0,
      100,
      50,
      1
    );
    container.appendChild(metronomeVolumeControl);

    // Get references to sliders and labels (from within the container, not from document)
    this.speedSlider = container.querySelector('#speed-slider') as HTMLInputElement;
    this.pianoVolumeSlider = container.querySelector('#piano-volume-slider') as HTMLInputElement;
    this.metronomeVolumeSlider = container.querySelector('#metronome-volume-slider') as HTMLInputElement;

    this.speedLabel = container.querySelector('#speed-label') as HTMLElement;
    this.pianoVolumeLabel = container.querySelector('#piano-volume-label') as HTMLElement;
    this.metronomeVolumeLabel = container.querySelector('#metronome-volume-label') as HTMLElement;

    // Attach event handlers
    this.attachEventHandlers();

    return container;
  }

  /**
   * Create a labeled slider control.
   */
  private createSliderControl(
    sliderId: string,
    labelId: string,
    label: string,
    min: number,
    max: number,
    value: number,
    step: number
  ): HTMLElement {
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
  private formatValue(label: string, value: number): string {
    if (label === 'Speed') {
      return `${value.toFixed(1)}x`;
    }
    return `${Math.round(value)}`;
  }

  /**
   * Attach event listeners to all sliders.
   */
  private attachEventHandlers(): void {
    if (this.speedSlider) {
      this.onSpeedInputHandler = (e: Event) => {
        const target = e.target as HTMLInputElement;
        const speed = parseFloat(target.value);
        this.updateLabel(this.speedLabel, 'Speed', speed);
        this.onSpeedChange(speed);
      };
      this.speedSlider.addEventListener('input', this.onSpeedInputHandler);
      this.speedSlider.addEventListener('change', this.onSpeedInputHandler);
    }

    if (this.pianoVolumeSlider) {
      this.onPianoVolumeInputHandler = (e: Event) => {
        const target = e.target as HTMLInputElement;
        const volume = parseInt(target.value, 10);
        this.updateLabel(this.pianoVolumeLabel, 'Piano Volume', volume);
        this.onPianoVolumeChange(volume);
      };
      this.pianoVolumeSlider.addEventListener('input', this.onPianoVolumeInputHandler);
      this.pianoVolumeSlider.addEventListener('change', this.onPianoVolumeInputHandler);
    }

    if (this.metronomeVolumeSlider) {
      this.onMetronomeVolumeInputHandler = (e: Event) => {
        const target = e.target as HTMLInputElement;
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
  private updateLabel(labelEl: HTMLElement | null, name: string, value: number): void {
    if (labelEl) {
      labelEl.textContent = `${name}: ${this.formatValue(name, value)}`;
    }
  }

  /**
   * Set the current speed value programmatically.
   */
  public setSpeed(speed: number): void {
    if (this.speedSlider) {
      this.speedSlider.value = speed.toString();
      this.updateLabel(this.speedLabel, 'Speed', speed);
    }
  }

  /**
   * Set the current piano volume value programmatically.
   */
  public setPianoVolume(volume: number): void {
    if (this.pianoVolumeSlider) {
      this.pianoVolumeSlider.value = volume.toString();
      this.updateLabel(this.pianoVolumeLabel, 'Piano Volume', volume);
    }
  }

  /**
   * Set the current metronome volume value programmatically.
   */
  public setMetronomeVolume(volume: number): void {
    if (this.metronomeVolumeSlider) {
      this.metronomeVolumeSlider.value = volume.toString();
      this.updateLabel(this.metronomeVolumeLabel, 'Metronome Volume', volume);
    }
  }

  /**
   * Get the current speed value.
   */
  public getSpeed(): number {
    return this.speedSlider ? parseFloat(this.speedSlider.value) : 1.0;
  }

  /**
   * Get the current piano volume value.
   */
  public getPianoVolume(): number {
    return this.pianoVolumeSlider ? parseInt(this.pianoVolumeSlider.value, 10) : 80;
  }

  /**
   * Get the current metronome volume value.
   */
  public getMetronomeVolume(): number {
    return this.metronomeVolumeSlider ? parseInt(this.metronomeVolumeSlider.value, 10) : 50;
  }

  /**
   * Clean up event listeners and DOM elements.
   */
  public destroy(): void {
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
