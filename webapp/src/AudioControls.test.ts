import { AudioControls } from './AudioControls';

describe('AudioControls', () => {
  let audioControls: AudioControls;
  let container: HTMLElement;

  let speedChangeCallback: jest.Mock;
  let pianoVolumeChangeCallback: jest.Mock;
  let metronomeVolumeChangeCallback: jest.Mock;

  beforeEach(() => {
    // Create a DOM container for rendering
    container = document.createElement('div');
    document.body.appendChild(container);

    // Create mock callbacks
    speedChangeCallback = jest.fn();
    pianoVolumeChangeCallback = jest.fn();
    metronomeVolumeChangeCallback = jest.fn();

    audioControls = new AudioControls({
      onSpeedChange: speedChangeCallback,
      onPianoVolumeChange: pianoVolumeChangeCallback,
      onMetronomeVolumeChange: metronomeVolumeChangeCallback,
    });
  });

  afterEach(() => {
    audioControls.destroy();
    if (container.parentElement) {
      container.parentElement.removeChild(container);
    }
  });

  describe('create()', () => {
    it('should create a container element with correct ID', () => {
      const ui = audioControls.create();
      expect(ui.id).toBe('audio-controls-container');
    });

    it('should create three slider elements', () => {
      const ui = audioControls.create();
      container.appendChild(ui);

      const speedSlider = document.getElementById('speed-slider') as HTMLInputElement;
      const pianoVolumeSlider = document.getElementById('piano-volume-slider') as HTMLInputElement;
      const metronomeVolumeSlider = document.getElementById('metronome-volume-slider') as HTMLInputElement;

      expect(speedSlider).not.toBeNull();
      expect(pianoVolumeSlider).not.toBeNull();
      expect(metronomeVolumeSlider).not.toBeNull();
    });

    it('should create three label elements', () => {
      const ui = audioControls.create();
      container.appendChild(ui);

      const speedLabel = document.getElementById('speed-label');
      const pianoVolumeLabel = document.getElementById('piano-volume-label');
      const metronomeVolumeLabel = document.getElementById('metronome-volume-label');

      expect(speedLabel).not.toBeNull();
      expect(pianoVolumeLabel).not.toBeNull();
      expect(metronomeVolumeLabel).not.toBeNull();
    });

    it('should set speed slider to correct default value and range', () => {
      const ui = audioControls.create();
      container.appendChild(ui);

      const speedSlider = document.getElementById('speed-slider') as HTMLInputElement;
      expect(speedSlider.value).toBe('1');
      expect(speedSlider.min).toBe('0.5');
      expect(speedSlider.max).toBe('2');
      expect(speedSlider.step).toBe('0.1');
    });

    it('should set piano volume slider to correct default value and range', () => {
      const ui = audioControls.create();
      container.appendChild(ui);

      const pianoSlider = document.getElementById('piano-volume-slider') as HTMLInputElement;
      expect(pianoSlider.value).toBe('80');
      expect(pianoSlider.min).toBe('0');
      expect(pianoSlider.max).toBe('100');
      expect(pianoSlider.step).toBe('1');
    });

    it('should set metronome volume slider to correct default value and range', () => {
      const ui = audioControls.create();
      container.appendChild(ui);

      const metronomeSlider = document.getElementById('metronome-volume-slider') as HTMLInputElement;
      expect(metronomeSlider.value).toBe('50');
      expect(metronomeSlider.min).toBe('0');
      expect(metronomeSlider.max).toBe('100');
      expect(metronomeSlider.step).toBe('1');
    });

    it('should initialize labels with default values', () => {
      const ui = audioControls.create();
      container.appendChild(ui);

      const speedLabel = document.getElementById('speed-label') as HTMLElement;
      const pianoLabel = document.getElementById('piano-volume-label') as HTMLElement;
      const metronomeLabel = document.getElementById('metronome-volume-label') as HTMLElement;

      expect(speedLabel.textContent).toContain('Speed: 1.0x');
      expect(pianoLabel.textContent).toContain('Piano Volume: 80');
      expect(metronomeLabel.textContent).toContain('Metronome Volume: 50');
    });
  });

  describe('Speed slider interaction', () => {
    beforeEach(() => {
      const ui = audioControls.create();
      container.appendChild(ui);
    });

    it('should fire onSpeedChange callback when speed slider input event fires', () => {
      const speedSlider = document.getElementById('speed-slider') as HTMLInputElement;
      speedSlider.value = '1.5';
      speedSlider.dispatchEvent(new Event('input', { bubbles: true }));

      expect(speedChangeCallback).toHaveBeenCalledWith(1.5);
    });

    it('should fire onSpeedChange callback when speed slider change event fires', () => {
      const speedSlider = document.getElementById('speed-slider') as HTMLInputElement;
      speedSlider.value = '0.8';
      speedSlider.dispatchEvent(new Event('change', { bubbles: true }));

      expect(speedChangeCallback).toHaveBeenCalledWith(0.8);
    });

    it('should update speed label when slider changes', () => {
      const speedSlider = document.getElementById('speed-slider') as HTMLInputElement;
      const speedLabel = document.getElementById('speed-label') as HTMLElement;

      speedSlider.value = '2';
      speedSlider.dispatchEvent(new Event('input', { bubbles: true }));

      expect(speedLabel.textContent).toContain('Speed: 2.0x');
    });

    it('should accept speed values across full range', () => {
      const speedSlider = document.getElementById('speed-slider') as HTMLInputElement;

      const testValues = [0.5, 0.8, 1.0, 1.5, 2.0];

      testValues.forEach((value) => {
        speedSlider.value = value.toString();
        speedSlider.dispatchEvent(new Event('input', { bubbles: true }));
      });

      expect(speedChangeCallback).toHaveBeenCalledTimes(5);
      expect(speedChangeCallback).toHaveBeenLastCalledWith(2.0);
    });
  });

  describe('Piano volume slider interaction', () => {
    beforeEach(() => {
      const ui = audioControls.create();
      container.appendChild(ui);
    });

    it('should fire onPianoVolumeChange callback when input event fires', () => {
      const pianoSlider = document.getElementById('piano-volume-slider') as HTMLInputElement;
      pianoSlider.value = '60';
      pianoSlider.dispatchEvent(new Event('input', { bubbles: true }));

      expect(pianoVolumeChangeCallback).toHaveBeenCalledWith(60);
    });

    it('should fire onPianoVolumeChange callback when change event fires', () => {
      const pianoSlider = document.getElementById('piano-volume-slider') as HTMLInputElement;
      pianoSlider.value = '75';
      pianoSlider.dispatchEvent(new Event('change', { bubbles: true }));

      expect(pianoVolumeChangeCallback).toHaveBeenCalledWith(75);
    });

    it('should update piano volume label when slider changes', () => {
      const pianoSlider = document.getElementById('piano-volume-slider') as HTMLInputElement;
      const pianoLabel = document.getElementById('piano-volume-label') as HTMLElement;

      pianoSlider.value = '100';
      pianoSlider.dispatchEvent(new Event('input', { bubbles: true }));

      expect(pianoLabel.textContent).toContain('Piano Volume: 100');
    });

    it('should accept volume values from 0 to 100', () => {
      const pianoSlider = document.getElementById('piano-volume-slider') as HTMLInputElement;

      const testValues = [0, 25, 50, 75, 100];

      testValues.forEach((value) => {
        pianoSlider.value = value.toString();
        pianoSlider.dispatchEvent(new Event('input', { bubbles: true }));
      });

      expect(pianoVolumeChangeCallback).toHaveBeenCalledTimes(5);
      expect(pianoVolumeChangeCallback).toHaveBeenLastCalledWith(100);
    });
  });

  describe('Metronome volume slider interaction', () => {
    beforeEach(() => {
      const ui = audioControls.create();
      container.appendChild(ui);
    });

    it('should fire onMetronomeVolumeChange callback when input event fires', () => {
      const metronomeSlider = document.getElementById('metronome-volume-slider') as HTMLInputElement;
      metronomeSlider.value = '40';
      metronomeSlider.dispatchEvent(new Event('input', { bubbles: true }));

      expect(metronomeVolumeChangeCallback).toHaveBeenCalledWith(40);
    });

    it('should fire onMetronomeVolumeChange callback when change event fires', () => {
      const metronomeSlider = document.getElementById('metronome-volume-slider') as HTMLInputElement;
      metronomeSlider.value = '70';
      metronomeSlider.dispatchEvent(new Event('change', { bubbles: true }));

      expect(metronomeVolumeChangeCallback).toHaveBeenCalledWith(70);
    });

    it('should update metronome volume label when slider changes', () => {
      const metronomeSlider = document.getElementById('metronome-volume-slider') as HTMLInputElement;
      const metronomeLabel = document.getElementById('metronome-volume-label') as HTMLElement;

      metronomeSlider.value = '90';
      metronomeSlider.dispatchEvent(new Event('input', { bubbles: true }));

      expect(metronomeLabel.textContent).toContain('Metronome Volume: 90');
    });

    it('should accept volume values from 0 to 100', () => {
      const metronomeSlider = document.getElementById('metronome-volume-slider') as HTMLInputElement;

      const testValues = [0, 30, 50, 80, 100];

      testValues.forEach((value) => {
        metronomeSlider.value = value.toString();
        metronomeSlider.dispatchEvent(new Event('input', { bubbles: true }));
      });

      expect(metronomeVolumeChangeCallback).toHaveBeenCalledTimes(5);
      expect(metronomeVolumeChangeCallback).toHaveBeenLastCalledWith(100);
    });
  });

  describe('Getter methods', () => {
    beforeEach(() => {
      const ui = audioControls.create();
      container.appendChild(ui);
    });

    it('getSpeed() should return current speed value', () => {
      const speedSlider = document.getElementById('speed-slider') as HTMLInputElement;
      speedSlider.value = '1.7';
      expect(audioControls.getSpeed()).toBe(1.7);
    });

    it('getPianoVolume() should return current piano volume value', () => {
      const pianoSlider = document.getElementById('piano-volume-slider') as HTMLInputElement;
      pianoSlider.value = '65';
      expect(audioControls.getPianoVolume()).toBe(65);
    });

    it('getMetronomeVolume() should return current metronome volume value', () => {
      const metronomeSlider = document.getElementById('metronome-volume-slider') as HTMLInputElement;
      metronomeSlider.value = '45';
      expect(audioControls.getMetronomeVolume()).toBe(45);
    });

    it('getters should return default values when sliders do not exist', () => {
      const freshControls = new AudioControls({
        onSpeedChange: jest.fn(),
        onPianoVolumeChange: jest.fn(),
        onMetronomeVolumeChange: jest.fn(),
      });

      expect(freshControls.getSpeed()).toBe(1.0);
      expect(freshControls.getPianoVolume()).toBe(80);
      expect(freshControls.getMetronomeVolume()).toBe(50);

      freshControls.destroy();
    });
  });

  describe('Setter methods', () => {
    beforeEach(() => {
      const ui = audioControls.create();
      container.appendChild(ui);
    });

    it('setSpeed() should update slider and label', () => {
      const speedSlider = document.getElementById('speed-slider') as HTMLInputElement;
      const speedLabel = document.getElementById('speed-label') as HTMLElement;

      audioControls.setSpeed(1.3);

      expect(speedSlider.value).toBe('1.3');
      expect(speedLabel.textContent).toContain('Speed: 1.3x');
    });

    it('setPianoVolume() should update slider and label', () => {
      const pianoSlider = document.getElementById('piano-volume-slider') as HTMLInputElement;
      const pianoLabel = document.getElementById('piano-volume-label') as HTMLElement;

      audioControls.setPianoVolume(55);

      expect(pianoSlider.value).toBe('55');
      expect(pianoLabel.textContent).toContain('Piano Volume: 55');
    });

    it('setMetronomeVolume() should update slider and label', () => {
      const metronomeSlider = document.getElementById('metronome-volume-slider') as HTMLInputElement;
      const metronomeLabel = document.getElementById('metronome-volume-label') as HTMLElement;

      audioControls.setMetronomeVolume(72);

      expect(metronomeSlider.value).toBe('72');
      expect(metronomeLabel.textContent).toContain('Metronome Volume: 72');
    });

    it('setters should not error when sliders do not exist', () => {
      const freshControls = new AudioControls({
        onSpeedChange: jest.fn(),
        onPianoVolumeChange: jest.fn(),
        onMetronomeVolumeChange: jest.fn(),
      });

      expect(() => {
        freshControls.setSpeed(1.5);
        freshControls.setPianoVolume(90);
        freshControls.setMetronomeVolume(60);
      }).not.toThrow();

      freshControls.destroy();
    });
  });

  describe('destroy()', () => {
    beforeEach(() => {
      const ui = audioControls.create();
      container.appendChild(ui);
    });

    it('should remove all event listeners', () => {
      const speedSlider = document.getElementById('speed-slider') as HTMLInputElement;
      const initialCallCount = speedChangeCallback.mock.calls.length;

      audioControls.destroy();

      speedSlider.value = '1.8';
      speedSlider.dispatchEvent(new Event('input', { bubbles: true }));

      expect(speedChangeCallback.mock.calls.length).toBe(initialCallCount);
    });

    it('should clean up all internal references', () => {
      audioControls.destroy();

      expect(audioControls.getSpeed()).toBe(1.0);
      expect(audioControls.getPianoVolume()).toBe(80);
      expect(audioControls.getMetronomeVolume()).toBe(50);
    });

    it('should be safe to call destroy() multiple times', () => {
      expect(() => {
        audioControls.destroy();
        audioControls.destroy();
        audioControls.destroy();
      }).not.toThrow();
    });
  });

  describe('Multiple instances isolation', () => {
    it('should support creating multiple independent instances', () => {
      const callback1 = jest.fn();
      const callback2 = jest.fn();

      const controls1 = new AudioControls({
        onSpeedChange: callback1,
        onPianoVolumeChange: jest.fn(),
        onMetronomeVolumeChange: jest.fn(),
      });

      const controls2 = new AudioControls({
        onSpeedChange: callback2,
        onPianoVolumeChange: jest.fn(),
        onMetronomeVolumeChange: jest.fn(),
      });

      const ui1 = controls1.create();
      const ui2 = controls2.create();

      const container1 = document.createElement('div');
      const container2 = document.createElement('div');
      document.body.appendChild(container1);
      document.body.appendChild(container2);
      container1.appendChild(ui1);
      container2.appendChild(ui2);

      const slider1 = container1.querySelector('input[type="range"]') as HTMLInputElement;
      const slider2 = container2.querySelector('input[type="range"]') as HTMLInputElement;

      slider1.value = '1.2';
      slider1.dispatchEvent(new Event('input', { bubbles: true }));

      expect(callback1).toHaveBeenCalledWith(1.2);
      expect(callback2).not.toHaveBeenCalled();

      controls1.destroy();
      controls2.destroy();
      container1.parentElement?.removeChild(container1);
      container2.parentElement?.removeChild(container2);
    });
  });

  describe('Label formatting', () => {
    beforeEach(() => {
      const ui = audioControls.create();
      container.appendChild(ui);
    });

    it('should format speed with one decimal place and "x" suffix', () => {
      const speedSlider = document.getElementById('speed-slider') as HTMLInputElement;
      const speedLabel = document.getElementById('speed-label') as HTMLElement;

      speedSlider.value = '0.5';
      speedSlider.dispatchEvent(new Event('input', { bubbles: true }));
      expect(speedLabel.textContent).toContain('0.5x');

      speedSlider.value = '2.0';
      speedSlider.dispatchEvent(new Event('input', { bubbles: true }));
      expect(speedLabel.textContent).toContain('2.0x');
    });

    it('should format volume as integer with no suffix', () => {
      const pianoSlider = document.getElementById('piano-volume-slider') as HTMLInputElement;
      const pianoLabel = document.getElementById('piano-volume-label') as HTMLElement;

      pianoSlider.value = '0';
      pianoSlider.dispatchEvent(new Event('input', { bubbles: true }));
      expect(pianoLabel.textContent).toContain('0');

      pianoSlider.value = '100';
      pianoSlider.dispatchEvent(new Event('input', { bubbles: true }));
      expect(pianoLabel.textContent).toContain('100');
    });
  });

  describe('Rapid slider changes', () => {
    beforeEach(() => {
      const ui = audioControls.create();
      container.appendChild(ui);
    });

    it('should handle rapid speed changes correctly', () => {
      const speedSlider = document.getElementById('speed-slider') as HTMLInputElement;
      const testValues = [0.5, 0.8, 1.0, 1.5, 2.0];

      testValues.forEach((value) => {
        speedSlider.value = value.toString();
        speedSlider.dispatchEvent(new Event('input', { bubbles: true }));
      });

      expect(speedChangeCallback).toHaveBeenCalledTimes(5);
    });

    it('should handle rapid volume changes correctly', () => {
      const pianoSlider = document.getElementById('piano-volume-slider') as HTMLInputElement;
      const testValues = [0, 20, 40, 60, 80, 100];

      testValues.forEach((value) => {
        pianoSlider.value = value.toString();
        pianoSlider.dispatchEvent(new Event('input', { bubbles: true }));
      });

      expect(pianoVolumeChangeCallback).toHaveBeenCalledTimes(6);
    });
  });
});
