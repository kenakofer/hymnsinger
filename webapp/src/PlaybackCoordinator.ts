import { AudioSynthesizer } from './AudioSynthesizer';
import { BouncingCursor } from './BouncingCursor';

/**
 * PlaybackCoordinator manages playback synchronization between the synth,
 * visual cursor, and horizontal scrolling of the music renderer.
 */
export class PlaybackCoordinator {
  private audioSynthesizer: AudioSynthesizer | null = null;
  private svgWrapper: HTMLElement | null = null;
  private isPlaying: boolean = false;
  private scrollAnimationId: number | null = null;
  private cursorObserver: MutationObserver | null = null;

  constructor() {}

  /**
   * Initialize the PlaybackCoordinator with synthesizer and renderer.
   * 
   * @param synthesizer - The AudioSynthesizer instance
   * @param svgWrapperElement - The horizontally scrolling SVG container
   */
  public initialize(
    synthesizer: AudioSynthesizer,
    svgWrapperElement: HTMLElement
  ): void {
    this.audioSynthesizer = synthesizer;
    this.svgWrapper = svgWrapperElement;
    
    console.log('PlaybackCoordinator initialized');
  }

  /**
   * Start playback and set up scroll synchronization.
   * Triggers synth playback which automatically runs TimingCallbacks.
   */
  public play(): void {
    if (!this.audioSynthesizer) {
      console.error('AudioSynthesizer not initialized');
      return;
    }

    if (this.isPlaying) {
      console.warn('Already playing');
      return;
    }

    try {
      this.audioSynthesizer.play();
      this.isPlaying = true;

      // Start scroll synchronization
      this.startScrollSync();

      console.log('Playback started with scroll sync');
    } catch (error) {
      console.error('Failed to start playback:', error);
    }
  }

  /**
   * Stop playback and cancel scroll synchronization.
   */
  public stop(): void {
    if (!this.audioSynthesizer) {
      console.error('AudioSynthesizer not initialized');
      return;
    }

    if (!this.isPlaying) {
      console.warn('Not currently playing');
      return;
    }

    try {
      this.audioSynthesizer.stop();
      this.isPlaying = false;

      // Stop scroll synchronization
      this.stopScrollSync();

      // Reset scroll position
      if (this.svgWrapper) {
        this.svgWrapper.scrollLeft = 0;
      }

      console.log('Playback stopped');
    } catch (error) {
      console.error('Failed to stop playback:', error);
    }
  }

  /**
   * Pause playback (can be resumed).
   */
  public pause(): void {
    if (!this.audioSynthesizer || !this.isPlaying) return;

    this.audioSynthesizer.pause();
    this.isPlaying = false;
    this.stopScrollSync();

    console.log('Playback paused');
  }

  /**
   * Resume paused playback.
   */
  public resume(): void {
    if (!this.audioSynthesizer) return;

    this.audioSynthesizer.resume();
    this.isPlaying = true;
    this.startScrollSync();

    console.log('Playback resumed');
  }

  /**
   * Start synchronizing horizontal scroll with cursor position.
   * Observes the bouncing cursor element and keeps it centered in viewport.
   */
  private startScrollSync(): void {
    if (!this.svgWrapper) return;

    // Use requestAnimationFrame for smooth scrolling
    const syncScroll = () => {
      const cursor = document.getElementById('abc-bouncing-cursor');
      
      if (cursor && this.svgWrapper) {
        // Get cursor position relative to the SVG wrapper
        const cursorRect = cursor.getBoundingClientRect();
        const svgRect = this.svgWrapper.getBoundingClientRect();

        // Calculate the cursor's position within the SVG
        const cursorX = cursor.offsetLeft || 0;
        const wrapperWidth = this.svgWrapper.clientWidth;
        
        // Center point where we want to keep the cursor
        const centerX = wrapperWidth / 2;

        // Calculate target scroll position
        const targetScroll = cursorX - centerX;

        // Smooth scroll using requestAnimationFrame
        if (targetScroll > 0) {
          this.svgWrapper.scrollLeft = targetScroll;
        }
      }

      // Continue scrolling if still playing
      if (this.isPlaying && !this.scrollAnimationId) {
        this.scrollAnimationId = window.requestAnimationFrame(syncScroll);
      }
    };

    // Start the scroll animation loop
    this.scrollAnimationId = window.requestAnimationFrame(syncScroll);
  }

  /**
   * Stop horizontal scroll synchronization.
   */
  private stopScrollSync(): void {
    if (this.scrollAnimationId !== null) {
      window.cancelAnimationFrame(this.scrollAnimationId);
      this.scrollAnimationId = null;
    }
  }

  /**
   * Check if currently playing.
   */
  public getIsPlaying(): boolean {
    return this.isPlaying;
  }

  /**
   * Get the audio synthesizer.
   */
  public getSynthesizer(): AudioSynthesizer | null {
    return this.audioSynthesizer;
  }

  /**
   * Get the SVG wrapper element.
   */
  public getSvgWrapper(): HTMLElement | null {
    return this.svgWrapper;
  }

  /**
   * Cleanup: stop playback and release resources.
   */
  public destroy(): void {
    if (this.isPlaying) {
      this.stop();
    }

    this.stopScrollSync();
    this.audioSynthesizer = null;
    this.svgWrapper = null;

    console.log('PlaybackCoordinator cleaned up');
  }
}
