/**
 * PlaybackControls manages the UI buttons for audio playback control.
 * Provides play, pause, and stop buttons with visual state feedback.
 */

export interface PlaybackControlsConfig {
  onPlay: () => void;
  onPause: () => void;
  onStop: () => void;
}

export class PlaybackControls {
  private container: HTMLElement | null = null;
  private playButton: HTMLButtonElement | null = null;
  private pauseButton: HTMLButtonElement | null = null;
  private stopButton: HTMLButtonElement | null = null;

  private isPlaying: boolean = false;

  private onPlay: () => void;
  private onPause: () => void;
  private onStop: () => void;

  // Store bound event handlers for proper cleanup
  private onPlayClickHandler: (() => void) | null = null;
  private onPauseClickHandler: (() => void) | null = null;
  private onStopClickHandler: (() => void) | null = null;

  constructor(config: PlaybackControlsConfig) {
    this.onPlay = config.onPlay;
    this.onPause = config.onPause;
    this.onStop = config.onStop;
  }

  /**
   * Create the playback control UI with play, pause, and stop buttons.
   * Returns a container div with all buttons.
   */
  public create(): HTMLElement {
    this.container = document.createElement('div');
    this.container.id = 'playback-controls-container';
    this.container.style.cssText = `
      display: flex;
      gap: 8px;
      align-items: center;
      margin-bottom: 12px;
    `;

    // Play button
    this.playButton = this.createButton('▶ Play', 'playback-play-btn', '#27ae60');
    this.container.appendChild(this.playButton);

    // Pause button
    this.pauseButton = this.createButton('⏸ Pause', 'playback-pause-btn', '#f39c12');
    this.pauseButton.disabled = true;
    this.container.appendChild(this.pauseButton);

    // Stop button
    this.stopButton = this.createButton('⏹ Stop', 'playback-stop-btn', '#e74c3c');
    this.stopButton.disabled = true;
    this.container.appendChild(this.stopButton);

    // Status indicator
    const statusIndicator = document.createElement('span');
    statusIndicator.id = 'playback-status-indicator';
    statusIndicator.style.cssText = `
      margin-left: 16px;
      font-size: 13px;
      color: #7f8c8d;
      font-weight: 500;
    `;
    statusIndicator.textContent = 'Ready';
    this.container.appendChild(statusIndicator);

    // Attach event handlers
    this.attachEventHandlers();

    return this.container;
  }

  /**
   * Create a styled button element.
   */
  private createButton(
    label: string,
    id: string,
    backgroundColor: string
  ): HTMLButtonElement {
    const button = document.createElement('button');
    button.id = id;
    button.textContent = label;
    button.style.cssText = `
      padding: 8px 16px;
      background-color: ${backgroundColor};
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 13px;
      font-weight: 500;
      transition: opacity 0.2s, transform 0.1s;
    `;

    button.addEventListener('mouseenter', () => {
      if (!button.disabled) {
        button.style.opacity = '0.9';
      }
    });

    button.addEventListener('mouseleave', () => {
      button.style.opacity = '1';
    });

    button.addEventListener('mousedown', () => {
      if (!button.disabled) {
        button.style.transform = 'scale(0.98)';
      }
    });

    button.addEventListener('mouseup', () => {
      button.style.transform = 'scale(1)';
    });

    return button;
  }

  /**
   * Attach event listeners to buttons.
   */
  private attachEventHandlers(): void {
    if (this.playButton) {
      this.onPlayClickHandler = () => this.handlePlayClick();
      this.playButton.addEventListener('click', this.onPlayClickHandler);
    }

    if (this.pauseButton) {
      this.onPauseClickHandler = () => this.handlePauseClick();
      this.pauseButton.addEventListener('click', this.onPauseClickHandler);
    }

    if (this.stopButton) {
      this.onStopClickHandler = () => this.handleStopClick();
      this.stopButton.addEventListener('click', this.onStopClickHandler);
    }
  }

  /**
   * Handle play button click.
   */
  private handlePlayClick(): void {
    this.isPlaying = true;
    this.updateButtonStates();
    this.updateStatusIndicator('Playing...');
    this.onPlay();
  }

  /**
   * Handle pause button click.
   */
  private handlePauseClick(): void {
    this.isPlaying = false;
    this.updateButtonStates();
    this.updateStatusIndicator('Paused');
    this.onPause();
  }

  /**
   * Handle stop button click.
   */
  private handleStopClick(): void {
    this.isPlaying = false;
    this.updateButtonStates();
    this.updateStatusIndicator('Stopped');
    this.onStop();
  }

  /**
   * Update button enabled/disabled states based on playback state.
   */
  private updateButtonStates(): void {
    if (this.playButton && this.pauseButton && this.stopButton) {
      if (this.isPlaying) {
        this.playButton.disabled = true;
        this.pauseButton.disabled = false;
        this.stopButton.disabled = false;
      } else {
        this.playButton.disabled = false;
        this.pauseButton.disabled = true;
        this.stopButton.disabled = true;
      }
    }
  }

  /**
   * Update the status indicator text.
   */
  private updateStatusIndicator(status: string): void {
    const indicator = document.getElementById('playback-status-indicator');
    if (indicator) {
      indicator.textContent = status;
    }
  }

  /**
   * Get the playback state.
   */
  public isPlayingState(): boolean {
    return this.isPlaying;
  }

  /**
   * Set the playback state without triggering callbacks.
   * Useful for syncing UI state after external state changes.
   */
  public setPlayingState(playing: boolean): void {
    this.isPlaying = playing;
    this.updateButtonStates();
    this.updateStatusIndicator(playing ? 'Playing...' : 'Paused');
  }

  /**
   * Stop playback and reset UI.
   */
  public stop(): void {
    this.isPlaying = false;
    this.updateButtonStates();
    this.updateStatusIndicator('Stopped');
  }

  /**
   * Clean up event listeners and DOM elements.
   */
  public destroy(): void {
    if (this.playButton && this.onPlayClickHandler) {
      this.playButton.removeEventListener('click', this.onPlayClickHandler);
    }

    if (this.pauseButton && this.onPauseClickHandler) {
      this.pauseButton.removeEventListener('click', this.onPauseClickHandler);
    }

    if (this.stopButton && this.onStopClickHandler) {
      this.stopButton.removeEventListener('click', this.onStopClickHandler);
    }

    this.playButton = null;
    this.pauseButton = null;
    this.stopButton = null;
    this.container = null;
    this.onPlayClickHandler = null;
    this.onPauseClickHandler = null;
    this.onStopClickHandler = null;
  }
}
