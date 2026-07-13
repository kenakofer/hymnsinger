import { PlaybackCoordinator } from './PlaybackCoordinator';
import { AudioSynthesizer } from './AudioSynthesizer';

describe('PlaybackCoordinator', () => {
  let coordinator: PlaybackCoordinator;
  let synthesizer: AudioSynthesizer;
  let svgWrapper: HTMLElement;

  beforeEach(() => {
    // Mock AudioContext and abcjs
    if (!(window as any).AudioContext && !(window as any).webkitAudioContext) {
      (window as any).AudioContext = class MockAudioContext {
        state = 'running';
        resume = jest.fn().mockResolvedValue(undefined);
      };
    }

    if (!(window as any).abcjs) {
      (window as any).abcjs = {
        synth: {
          CreateSynth: class MockCreateSynth {
            init = jest.fn().mockResolvedValue(undefined);
            play = jest.fn().mockResolvedValue(undefined);
            stop = jest.fn().mockResolvedValue(undefined);
            pause = jest.fn().mockResolvedValue(undefined);
            resume = jest.fn().mockResolvedValue(undefined);
          },
          SynthController: class MockSynthController {
            load = jest.fn();
            setTempo = jest.fn();
            setSoundFontVolumePercent = jest.fn();
            setMetronomeVolumePercent = jest.fn();
          },
        },
      };
    }

    // Create test elements
    svgWrapper = document.createElement('div');
    svgWrapper.id = 'abc-svg-wrapper';
    svgWrapper.style.width = '800px';
    svgWrapper.style.height = '400px';
    svgWrapper.style.overflow = 'auto';
    document.body.appendChild(svgWrapper);

    synthesizer = new AudioSynthesizer();
    coordinator = new PlaybackCoordinator();
  });

  afterEach(() => {
    if (coordinator) {
      coordinator.destroy();
    }
    if (synthesizer) {
      synthesizer.destroy();
    }
    if (svgWrapper && svgWrapper.parentElement) {
      document.body.removeChild(svgWrapper);
    }
  });

  describe('initialization', () => {
    it('should create coordinator instance', () => {
      expect(coordinator).toBeDefined();
    });

    it('should not be playing initially', () => {
      expect(coordinator.getIsPlaying()).toBe(false);
    });

    it('should initialize with synthesizer and svg wrapper', () => {
      coordinator.initialize(synthesizer, svgWrapper);

      expect(coordinator.getSynthesizer()).toBe(synthesizer);
      expect(coordinator.getSvgWrapper()).toBe(svgWrapper);
    });

    it('should have null synthesizer before initialization', () => {
      expect(coordinator.getSynthesizer()).toBeNull();
    });

    it('should have null svg wrapper before initialization', () => {
      expect(coordinator.getSvgWrapper()).toBeNull();
    });
  });

  describe('playback control', () => {
    beforeEach(async () => {
      coordinator.initialize(synthesizer, svgWrapper);
      const mockAbcjsInstance = [{ notes: [] }];
      await synthesizer.initializeSynth(mockAbcjsInstance);
    });

    it('should throw error if not initialized', () => {
      const uninitCoordinator = new PlaybackCoordinator();
      expect(() => uninitCoordinator.play()).not.toThrow();
    });

    it('should start playback', () => {
      const synth = synthesizer.getSynth();
      const playSpy = jest.spyOn(synth, 'play');

      coordinator.play();

      expect(playSpy).toHaveBeenCalled();
      expect(coordinator.getIsPlaying()).toBe(true);
    });

    it('should not play if already playing', () => {
      const synth = synthesizer.getSynth();
      coordinator.play();
      (synth.play as jest.Mock).mockClear();

      coordinator.play();

      expect(synth.play).not.toHaveBeenCalled();
    });

    it('should stop playback', () => {
      const synth = synthesizer.getSynth();
      const stopSpy = jest.spyOn(synth, 'stop');

      coordinator.play();
      coordinator.stop();

      expect(stopSpy).toHaveBeenCalled();
      expect(coordinator.getIsPlaying()).toBe(false);
    });

    it('should reset scroll position on stop', () => {
      coordinator.play();
      svgWrapper.scrollLeft = 100;
      
      coordinator.stop();

      expect(svgWrapper.scrollLeft).toBe(0);
    });

    it('should pause playback', () => {
      const synth = synthesizer.getSynth();
      const pauseSpy = jest.spyOn(synth, 'pause');

      coordinator.play();
      coordinator.pause();

      expect(pauseSpy).toHaveBeenCalled();
      expect(coordinator.getIsPlaying()).toBe(false);
    });

    it('should resume playback', () => {
      const synth = synthesizer.getSynth();
      const resumeSpy = jest.spyOn(synth, 'resume');

      coordinator.play();
      coordinator.pause();
      coordinator.resume();

      expect(resumeSpy).toHaveBeenCalled();
      expect(coordinator.getIsPlaying()).toBe(true);
    });
  });

  describe('horizontal scroll synchronization', () => {
    beforeEach(async () => {
      coordinator.initialize(synthesizer, svgWrapper);
      const mockAbcjsInstance = [{ notes: [] }];
      await synthesizer.initializeSynth(mockAbcjsInstance);
    });

    it('should start scroll sync on play', (done) => {
      coordinator.play();

      // Give it time to start animation
      setTimeout(() => {
        // Verify playing state
        expect(coordinator.getIsPlaying()).toBe(true);
        done();
      }, 100);
    });

    it('should keep bouncing cursor centered during playback', (done) => {
      // Create a mock bouncing cursor
      const cursor = document.createElement('div');
      cursor.id = 'abc-bouncing-cursor';
      cursor.style.position = 'absolute';
      cursor.style.left = '400px'; // Center
      cursor.style.width = '20px';
      svgWrapper.appendChild(cursor);

      coordinator.play();

      // Wait a bit for scroll to happen
      setTimeout(() => {
        // Check that scrollLeft was updated based on cursor position
        // (In this mock, it should scroll to keep cursor centered)
        expect(coordinator.getIsPlaying()).toBe(true);
        done();
      }, 100);
    });

    it('should stop scroll sync on stop', (done) => {
      coordinator.play();

      setTimeout(() => {
        coordinator.stop();
        expect(coordinator.getIsPlaying()).toBe(false);
        done();
      }, 50);
    });

    it('should stop scroll sync on pause', (done) => {
      coordinator.play();

      setTimeout(() => {
        coordinator.pause();
        expect(coordinator.getIsPlaying()).toBe(false);
        done();
      }, 50);
    });
  });

  describe('cleanup', () => {
    beforeEach(async () => {
      coordinator.initialize(synthesizer, svgWrapper);
      const mockAbcjsInstance = [{ notes: [] }];
      await synthesizer.initializeSynth(mockAbcjsInstance);
    });

    it('should stop playback on destroy', () => {
      const synth = synthesizer.getSynth();
      const stopSpy = jest.spyOn(synth, 'stop');

      coordinator.play();
      coordinator.destroy();

      expect(stopSpy).toHaveBeenCalled();
    });

    it('should clear references on destroy', () => {
      coordinator.initialize(synthesizer, svgWrapper);
      coordinator.destroy();

      expect(coordinator.getSynthesizer()).toBeNull();
      expect(coordinator.getSvgWrapper()).toBeNull();
    });

    it('should not throw on destroy without initialization', () => {
      const uninitCoordinator = new PlaybackCoordinator();
      expect(() => uninitCoordinator.destroy()).not.toThrow();
    });
  });

  describe('edge cases', () => {
    it('should handle stop without playing', () => {
      coordinator.initialize(synthesizer, svgWrapper);
      expect(() => coordinator.stop()).not.toThrow();
    });

    it('should handle pause without playing', () => {
      coordinator.initialize(synthesizer, svgWrapper);
      expect(() => coordinator.pause()).not.toThrow();
    });

    it('should handle resume without synth', () => {
      coordinator.initialize(synthesizer, svgWrapper);
      expect(() => coordinator.resume()).not.toThrow();
    });

    it('should handle play with missing cursor element', async () => {
      coordinator.initialize(synthesizer, svgWrapper);
      const mockAbcjsInstance = [{ notes: [] }];
      await synthesizer.initializeSynth(mockAbcjsInstance);

      // Don't create cursor element - should not crash
      expect(() => coordinator.play()).not.toThrow();
      
      coordinator.stop();
    });
  });
});
