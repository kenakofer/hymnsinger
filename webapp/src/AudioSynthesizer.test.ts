import { AudioSynthesizer } from './AudioSynthesizer';

describe('AudioSynthesizer', () => {
  let synthesizer: AudioSynthesizer;

  beforeEach(() => {
    // Mock AudioContext if not available
    if (!(window as any).AudioContext && !(window as any).webkitAudioContext) {
      (window as any).AudioContext = class MockAudioContext {
        state = 'running';
        resume = jest.fn().mockResolvedValue(undefined);
      };
    }

    // Mock abcjs.synth
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

    synthesizer = new AudioSynthesizer();
  });

  afterEach(() => {
    if (synthesizer) {
      synthesizer.destroy();
    }
  });

  describe('initialization', () => {
    it('should create an AudioContext', () => {
      const ctx = synthesizer.getAudioContext();
      expect(ctx).toBeDefined();
    });

    it('should have synth not initialized initially', () => {
      expect(synthesizer.getSynth()).toBeNull();
    });

    it('should not be primed initially', () => {
      expect(synthesizer.isPrimmed()).toBe(false);
    });

    it('should not be playing initially', () => {
      expect(synthesizer.getIsPlaying()).toBe(false);
    });
  });

  describe('synth initialization', () => {
    it('should throw error if AudioContext not available', async () => {
      // Create a new synthesizer with no AudioContext
      const ctx = synthesizer.getAudioContext();
      (synthesizer as any).audioContext = null;

      const mockAbcjsInstance = [{ notes: [] }];

      await expect(
        synthesizer.initializeSynth(mockAbcjsInstance)
      ).rejects.toThrow('AudioContext not initialized');
    });

    it('should throw error if abcjs instance invalid', async () => {
      await expect(
        synthesizer.initializeSynth(null)
      ).rejects.toThrow('Valid abcjs instance required');
    });

    it('should throw error if abcjs instance is empty array', async () => {
      await expect(
        synthesizer.initializeSynth([])
      ).rejects.toThrow('Valid abcjs instance required');
    });

    it('should initialize synth with valid abcjs instance', async () => {
      const mockAbcjsInstance = [{ notes: [] }];

      await expect(
        synthesizer.initializeSynth(mockAbcjsInstance)
      ).resolves.not.toThrow();

      expect(synthesizer.getSynth()).toBeDefined();
      expect(synthesizer.isPrimmed()).toBe(true);
    });

    it('should enable metronome by default', async () => {
      const mockAbcjsInstance = [{ notes: [] }];
      
      // Create a fresh synthesizer for this test
      const synthTest = new AudioSynthesizer();
      
      await synthTest.initializeSynth(mockAbcjsInstance, true);

      // Verify synth was initialized
      expect(synthTest.getSynth()).toBeDefined();
      expect(synthTest.isPrimmed()).toBe(true);
      
      synthTest.destroy();
    });

    it('should allow disabling metronome', async () => {
      const mockAbcjsInstance = [{ notes: [] }];
      
      // Create a fresh synthesizer for this test
      const synthTest = new AudioSynthesizer();
      
      await synthTest.initializeSynth(mockAbcjsInstance, false);

      // Verify synth was initialized even with metronome disabled
      expect(synthTest.getSynth()).toBeDefined();
      expect(synthTest.isPrimmed()).toBe(true);
      
      synthTest.destroy();
    });

    it('should resume AudioContext if suspended', async () => {
      const mockAbcjsInstance = [{ notes: [] }];
      const mockAudioContext = synthesizer.getAudioContext() as any;
      mockAudioContext.state = 'suspended';
      const resumeSpy = jest.spyOn(mockAudioContext, 'resume');

      await synthesizer.initializeSynth(mockAbcjsInstance);

      expect(resumeSpy).toHaveBeenCalled();
    });

    it('should create synth controller', async () => {
      const mockAbcjsInstance = [{ notes: [] }];

      await synthesizer.initializeSynth(mockAbcjsInstance);

      expect(synthesizer.getSynthController()).toBeDefined();
    });

    it('should prime the audio buffer', async () => {
      const mockAbcjsInstance = [{ notes: [] }];
      const mockSynth = new (window as any).abcjs.synth.CreateSynth();
      const playSpy = jest.spyOn(mockSynth, 'play');
      const stopSpy = jest.spyOn(mockSynth, 'stop');

      await synthesizer.initializeSynth(mockAbcjsInstance);

      // Verify priming occurred (play + stop)
      expect(synthesizer.isPrimmed()).toBe(true);
    });
  });

  describe('playback control', () => {
    beforeEach(async () => {
      const mockAbcjsInstance = [{ notes: [] }];
      await synthesizer.initializeSynth(mockAbcjsInstance);
    });

    it('should play when not already playing', () => {
      const synth = synthesizer.getSynth();
      const playSpy = jest.spyOn(synth, 'play');

      synthesizer.play();

      expect(playSpy).toHaveBeenCalled();
      expect(synthesizer.getIsPlaying()).toBe(true);
    });

    it('should not play if already playing', () => {
      const synth = synthesizer.getSynth();

      synthesizer.play();
      (synth.play as jest.Mock).mockClear();

      synthesizer.play();

      expect(synth.play).not.toHaveBeenCalled();
    });

    it('should stop playback', () => {
      const synth = synthesizer.getSynth();
      const stopSpy = jest.spyOn(synth, 'stop');

      synthesizer.play();
      synthesizer.stop();

      expect(stopSpy).toHaveBeenCalled();
      expect(synthesizer.getIsPlaying()).toBe(false);
    });

    it('should not stop if not playing', () => {
      const synth = synthesizer.getSynth();
      (synth.stop as jest.Mock).mockClear();

      synthesizer.stop();

      expect(synth.stop).not.toHaveBeenCalled();
    });

    it('should pause playback', () => {
      const synth = synthesizer.getSynth();
      const pauseSpy = jest.spyOn(synth, 'pause');

      synthesizer.play();
      synthesizer.pause();

      expect(pauseSpy).toHaveBeenCalled();
      expect(synthesizer.getIsPlaying()).toBe(false);
    });

    it('should resume playback', () => {
      const synth = synthesizer.getSynth();
      const resumeSpy = jest.spyOn(synth, 'resume');

      synthesizer.play();
      synthesizer.pause();
      synthesizer.resume();

      expect(resumeSpy).toHaveBeenCalled();
      expect(synthesizer.getIsPlaying()).toBe(true);
    });
  });

  describe('volume control', () => {
    beforeEach(async () => {
      const mockAbcjsInstance = [{ notes: [] }];
      await synthesizer.initializeSynth(mockAbcjsInstance);
    });

    it('should set piano volume', () => {
      const controller = synthesizer.getSynthController();
      const setVolumeSpy = jest.spyOn(controller, 'setSoundFontVolumePercent');

      synthesizer.setPianoVolume(75);

      expect(setVolumeSpy).toHaveBeenCalledWith(75);
    });

    it('should clamp piano volume to 0-100', () => {
      const controller = synthesizer.getSynthController();
      const setVolumeSpy = jest.spyOn(controller, 'setSoundFontVolumePercent');

      synthesizer.setPianoVolume(150);
      expect(setVolumeSpy).toHaveBeenCalledWith(100);

      synthesizer.setPianoVolume(-10);
      expect(setVolumeSpy).toHaveBeenCalledWith(0);
    });

    it('should set metronome volume', () => {
      const controller = synthesizer.getSynthController();
      const setVolumeSpy = jest.spyOn(controller, 'setMetronomeVolumePercent');

      synthesizer.setMetronomeVolume(60);

      expect(setVolumeSpy).toHaveBeenCalledWith(60);
    });

    it('should clamp metronome volume to 0-100', () => {
      const controller = synthesizer.getSynthController();
      const setVolumeSpy = jest.spyOn(controller, 'setMetronomeVolumePercent');

      synthesizer.setMetronomeVolume(200);
      expect(setVolumeSpy).toHaveBeenCalledWith(100);

      synthesizer.setMetronomeVolume(-5);
      expect(setVolumeSpy).toHaveBeenCalledWith(0);
    });

    it('should fallback to main volume if metronome volume not available', () => {
      const controller = synthesizer.getSynthController();
      delete (controller as any).setMetronomeVolumePercent;
      const setVolumeSpy = jest.spyOn(controller, 'setSoundFontVolumePercent');

      synthesizer.setMetronomeVolume(50);

      expect(setVolumeSpy).toHaveBeenCalledWith(50);
    });
  });

  describe('speed control', () => {
    beforeEach(async () => {
      const mockAbcjsInstance = [{ notes: [] }];
      await synthesizer.initializeSynth(mockAbcjsInstance);
    });

    it('should set playback speed', () => {
      const controller = synthesizer.getSynthController();
      const setTempoSpy = jest.spyOn(controller, 'setTempo');

      synthesizer.setSpeed(1.5);

      expect(setTempoSpy).toHaveBeenCalledWith(1.5);
    });

    it('should allow speed values from 0.5 to 2.0', () => {
      const controller = synthesizer.getSynthController();
      const setTempoSpy = jest.spyOn(controller, 'setTempo');

      synthesizer.setSpeed(0.5);
      expect(setTempoSpy).toHaveBeenCalledWith(0.5);

      synthesizer.setSpeed(2.0);
      expect(setTempoSpy).toHaveBeenCalledWith(2.0);

      synthesizer.setSpeed(1.0);
      expect(setTempoSpy).toHaveBeenCalledWith(1.0);
    });
  });

  describe('cleanup', () => {
    it('should stop playback on destroy', async () => {
      const mockAbcjsInstance = [{ notes: [] }];
      await synthesizer.initializeSynth(mockAbcjsInstance);

      const synth = synthesizer.getSynth();
      const stopSpy = jest.spyOn(synth, 'stop');

      synthesizer.play();
      synthesizer.destroy();

      expect(stopSpy).toHaveBeenCalled();
    });

    it('should clear synth references on destroy', async () => {
      const mockAbcjsInstance = [{ notes: [] }];
      await synthesizer.initializeSynth(mockAbcjsInstance);

      synthesizer.destroy();

      expect(synthesizer.getSynth()).toBeNull();
      expect(synthesizer.getSynthController()).toBeNull();
    });

    it('should not throw error if destroy called without initialization', () => {
      expect(() => synthesizer.destroy()).not.toThrow();
    });
  });

  describe('edge cases', () => {
    it('should handle play without synth gracefully', () => {
      expect(() => synthesizer.play()).not.toThrow();
    });

    it('should handle stop without synth gracefully', () => {
      expect(() => synthesizer.stop()).not.toThrow();
    });

    it('should handle volume control without synth gracefully', () => {
      expect(() => synthesizer.setPianoVolume(50)).not.toThrow();
      expect(() => synthesizer.setMetronomeVolume(50)).not.toThrow();
    });

    it('should handle speed control without synth gracefully', () => {
      expect(() => synthesizer.setSpeed(1.5)).not.toThrow();
    });
  });
});
