import { PlaybackControls } from './PlaybackControls';

describe('PlaybackControls', () => {
  let playbackControls: PlaybackControls;
  let container: HTMLElement;

  let onPlayCallback: jest.Mock;
  let onPauseCallback: jest.Mock;
  let onStopCallback: jest.Mock;

  beforeEach(() => {
    container = document.createElement('div');
    document.body.appendChild(container);

    onPlayCallback = jest.fn();
    onPauseCallback = jest.fn();
    onStopCallback = jest.fn();

    playbackControls = new PlaybackControls({
      onPlay: onPlayCallback,
      onPause: onPauseCallback,
      onStop: onStopCallback,
    });
  });

  afterEach(() => {
    playbackControls.destroy();
    if (container.parentElement) {
      container.parentElement.removeChild(container);
    }
  });

  describe('create()', () => {
    it('should create a container element with correct ID', () => {
      const ui = playbackControls.create();
      expect(ui.id).toBe('playback-controls-container');
    });

    it('should create three buttons', () => {
      const ui = playbackControls.create();
      container.appendChild(ui);

      const playBtn = document.getElementById('playback-play-btn');
      const pauseBtn = document.getElementById('playback-pause-btn');
      const stopBtn = document.getElementById('playback-stop-btn');

      expect(playBtn).not.toBeNull();
      expect(pauseBtn).not.toBeNull();
      expect(stopBtn).not.toBeNull();
    });

    it('should create a status indicator', () => {
      const ui = playbackControls.create();
      container.appendChild(ui);

      const statusIndicator = document.getElementById('playback-status-indicator');
      expect(statusIndicator).not.toBeNull();
      expect(statusIndicator?.textContent).toBe('Ready');
    });

    it('should initialize play button as enabled', () => {
      const ui = playbackControls.create();
      container.appendChild(ui);

      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      expect(playBtn.disabled).toBe(false);
    });

    it('should initialize pause and stop buttons as disabled', () => {
      const ui = playbackControls.create();
      container.appendChild(ui);

      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;
      const stopBtn = document.getElementById('playback-stop-btn') as HTMLButtonElement;

      expect(pauseBtn.disabled).toBe(true);
      expect(stopBtn.disabled).toBe(true);
    });

    it('should set button text labels correctly', () => {
      const ui = playbackControls.create();
      container.appendChild(ui);

      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;
      const stopBtn = document.getElementById('playback-stop-btn') as HTMLButtonElement;

      expect(playBtn.textContent).toContain('Play');
      expect(pauseBtn.textContent).toContain('Pause');
      expect(stopBtn.textContent).toContain('Stop');
    });
  });

  describe('Play button interaction', () => {
    beforeEach(() => {
      const ui = playbackControls.create();
      container.appendChild(ui);
    });

    it('should call onPlay callback when play button is clicked', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      playBtn.click();

      expect(onPlayCallback).toHaveBeenCalledTimes(1);
    });

    it('should disable play button and enable pause/stop after play', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;
      const stopBtn = document.getElementById('playback-stop-btn') as HTMLButtonElement;

      playBtn.click();

      expect(playBtn.disabled).toBe(true);
      expect(pauseBtn.disabled).toBe(false);
      expect(stopBtn.disabled).toBe(false);
    });

    it('should update status indicator to "Playing..." after play', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const indicator = document.getElementById('playback-status-indicator') as HTMLElement;

      playBtn.click();

      expect(indicator.textContent).toBe('Playing...');
    });

    it('should set isPlayingState to true after play', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      playBtn.click();

      expect(playbackControls.isPlayingState()).toBe(true);
    });
  });

  describe('Pause button interaction', () => {
    beforeEach(() => {
      const ui = playbackControls.create();
      container.appendChild(ui);
    });

    it('should not call onPause if not playing', () => {
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;
      pauseBtn.click();

      expect(onPauseCallback).not.toHaveBeenCalled();
    });

    it('should call onPause callback after playing and clicking pause', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;

      playBtn.click();
      pauseBtn.click();

      expect(onPauseCallback).toHaveBeenCalledTimes(1);
    });

    it('should enable play and disable pause/stop after pause', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;
      const stopBtn = document.getElementById('playback-stop-btn') as HTMLButtonElement;

      playBtn.click();
      pauseBtn.click();

      expect(playBtn.disabled).toBe(false);
      expect(pauseBtn.disabled).toBe(true);
      expect(stopBtn.disabled).toBe(true);
    });

    it('should update status indicator to "Paused" after pause', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;
      const indicator = document.getElementById('playback-status-indicator') as HTMLElement;

      playBtn.click();
      pauseBtn.click();

      expect(indicator.textContent).toBe('Paused');
    });

    it('should set isPlayingState to false after pause', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;

      playBtn.click();
      pauseBtn.click();

      expect(playbackControls.isPlayingState()).toBe(false);
    });
  });

  describe('Stop button interaction', () => {
    beforeEach(() => {
      const ui = playbackControls.create();
      container.appendChild(ui);
    });

    it('should not call onStop if not playing', () => {
      const stopBtn = document.getElementById('playback-stop-btn') as HTMLButtonElement;
      stopBtn.click();

      expect(onStopCallback).not.toHaveBeenCalled();
    });

    it('should call onStop callback after playing and clicking stop', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const stopBtn = document.getElementById('playback-stop-btn') as HTMLButtonElement;

      playBtn.click();
      stopBtn.click();

      expect(onStopCallback).toHaveBeenCalledTimes(1);
    });

    it('should enable play and disable pause/stop after stop', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const stopBtn = document.getElementById('playback-stop-btn') as HTMLButtonElement;
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;

      playBtn.click();
      stopBtn.click();

      expect(playBtn.disabled).toBe(false);
      expect(pauseBtn.disabled).toBe(true);
      expect(stopBtn.disabled).toBe(true);
    });

    it('should update status indicator to "Stopped" after stop', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const stopBtn = document.getElementById('playback-stop-btn') as HTMLButtonElement;
      const indicator = document.getElementById('playback-status-indicator') as HTMLElement;

      playBtn.click();
      stopBtn.click();

      expect(indicator.textContent).toBe('Stopped');
    });

    it('should set isPlayingState to false after stop', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const stopBtn = document.getElementById('playback-stop-btn') as HTMLButtonElement;

      playBtn.click();
      stopBtn.click();

      expect(playbackControls.isPlayingState()).toBe(false);
    });
  });

  describe('Play-Pause-Play workflow', () => {
    beforeEach(() => {
      const ui = playbackControls.create();
      container.appendChild(ui);
    });

    it('should allow play -> pause -> play workflow', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;

      // First play
      playBtn.click();
      expect(onPlayCallback).toHaveBeenCalledTimes(1);
      expect(playbackControls.isPlayingState()).toBe(true);

      // Pause
      pauseBtn.click();
      expect(onPauseCallback).toHaveBeenCalledTimes(1);
      expect(playbackControls.isPlayingState()).toBe(false);

      // Resume (play again)
      playBtn.click();
      expect(onPlayCallback).toHaveBeenCalledTimes(2);
      expect(playbackControls.isPlayingState()).toBe(true);
    });
  });

  describe('isPlayingState()', () => {
    beforeEach(() => {
      const ui = playbackControls.create();
      container.appendChild(ui);
    });

    it('should return false initially', () => {
      expect(playbackControls.isPlayingState()).toBe(false);
    });

    it('should return true after play', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      playBtn.click();

      expect(playbackControls.isPlayingState()).toBe(true);
    });

    it('should return false after pause', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;

      playBtn.click();
      pauseBtn.click();

      expect(playbackControls.isPlayingState()).toBe(false);
    });

    it('should return false after stop', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const stopBtn = document.getElementById('playback-stop-btn') as HTMLButtonElement;

      playBtn.click();
      stopBtn.click();

      expect(playbackControls.isPlayingState()).toBe(false);
    });
  });

  describe('setPlayingState()', () => {
    beforeEach(() => {
      const ui = playbackControls.create();
      container.appendChild(ui);
    });

    it('should set playing state to true without triggering callbacks', () => {
      playbackControls.setPlayingState(true);

      expect(playbackControls.isPlayingState()).toBe(true);
      expect(onPlayCallback).not.toHaveBeenCalled();
    });

    it('should set playing state to false without triggering callbacks', () => {
      playbackControls.setPlayingState(true);
      playbackControls.setPlayingState(false);

      expect(playbackControls.isPlayingState()).toBe(false);
      expect(onPlayCallback).not.toHaveBeenCalled();
    });

    it('should update button states when setting playing state to true', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;

      playbackControls.setPlayingState(true);

      expect(playBtn.disabled).toBe(true);
      expect(pauseBtn.disabled).toBe(false);
    });

    it('should update button states when setting playing state to false', () => {
      playbackControls.setPlayingState(true);
      playbackControls.setPlayingState(false);

      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;

      expect(playBtn.disabled).toBe(false);
      expect(pauseBtn.disabled).toBe(true);
    });

    it('should update status indicator when setting playing state', () => {
      const indicator = document.getElementById('playback-status-indicator') as HTMLElement;

      playbackControls.setPlayingState(true);
      expect(indicator.textContent).toBe('Playing...');

      playbackControls.setPlayingState(false);
      expect(indicator.textContent).toBe('Paused');
    });
  });

  describe('stop() method', () => {
    beforeEach(() => {
      const ui = playbackControls.create();
      container.appendChild(ui);
    });

    it('should reset state to not playing', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      playBtn.click();

      playbackControls.stop();

      expect(playbackControls.isPlayingState()).toBe(false);
    });

    it('should update button states', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      playBtn.click();

      playbackControls.stop();

      expect(playBtn.disabled).toBe(false);
    });

    it('should update status indicator to "Stopped"', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const indicator = document.getElementById('playback-status-indicator') as HTMLElement;

      playBtn.click();
      playbackControls.stop();

      expect(indicator.textContent).toBe('Stopped');
    });
  });

  describe('destroy()', () => {
    beforeEach(() => {
      const ui = playbackControls.create();
      container.appendChild(ui);
    });

    it('should remove all event listeners', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;
      const initialCallCount = onPlayCallback.mock.calls.length;

      playbackControls.destroy();

      playBtn.click();

      expect(onPlayCallback.mock.calls.length).toBe(initialCallCount);
    });

    it('should clean up all internal references', () => {
      playbackControls.destroy();

      expect(playbackControls.isPlayingState()).toBe(false);
    });

    it('should be safe to call destroy() multiple times', () => {
      expect(() => {
        playbackControls.destroy();
        playbackControls.destroy();
        playbackControls.destroy();
      }).not.toThrow();
    });
  });

  describe('Multiple instances isolation', () => {
    it('should support creating multiple independent instances', () => {
      const callback1 = jest.fn();
      const callback2 = jest.fn();

      const controls1 = new PlaybackControls({
        onPlay: callback1,
        onPause: jest.fn(),
        onStop: jest.fn(),
      });

      const controls2 = new PlaybackControls({
        onPlay: callback2,
        onPause: jest.fn(),
        onStop: jest.fn(),
      });

      const ui1 = controls1.create();
      const ui2 = controls2.create();

      const container1 = document.createElement('div');
      const container2 = document.createElement('div');
      document.body.appendChild(container1);
      document.body.appendChild(container2);
      container1.appendChild(ui1);
      container2.appendChild(ui2);

      const playBtn1 = container1.querySelector('button') as HTMLButtonElement;
      const playBtn2 = container2.querySelector('button') as HTMLButtonElement;

      playBtn1.click();

      expect(callback1).toHaveBeenCalledTimes(1);
      expect(callback2).not.toHaveBeenCalled();

      controls1.destroy();
      controls2.destroy();
      container1.parentElement?.removeChild(container1);
      container2.parentElement?.removeChild(container2);
    });
  });

  describe('Button styling and interactions', () => {
    beforeEach(() => {
      const ui = playbackControls.create();
      container.appendChild(ui);
    });

    it('should have flex layout for button container', () => {
      const ui = document.getElementById('playback-controls-container') as HTMLElement;
      expect(ui.style.display).toBe('flex');
    });

    it('should have status indicator element', () => {
      const indicator = document.getElementById('playback-status-indicator');
      expect(indicator).not.toBeNull();
    });

    it('should have all buttons with proper IDs', () => {
      expect(document.getElementById('playback-play-btn')).not.toBeNull();
      expect(document.getElementById('playback-pause-btn')).not.toBeNull();
      expect(document.getElementById('playback-stop-btn')).not.toBeNull();
    });
  });

  describe('Edge cases', () => {
    beforeEach(() => {
      const ui = playbackControls.create();
      container.appendChild(ui);
    });

    it('should handle rapid play button clicks', () => {
      const playBtn = document.getElementById('playback-play-btn') as HTMLButtonElement;

      playBtn.click();
      playBtn.click();
      playBtn.click();

      expect(onPlayCallback).toHaveBeenCalledTimes(1);
      expect(playbackControls.isPlayingState()).toBe(true);
    });

    it('should handle pause during initial state', () => {
      const pauseBtn = document.getElementById('playback-pause-btn') as HTMLButtonElement;

      pauseBtn.click();

      expect(onPauseCallback).not.toHaveBeenCalled();
    });

    it('should handle stop during initial state', () => {
      const stopBtn = document.getElementById('playback-stop-btn') as HTMLButtonElement;

      stopBtn.click();

      expect(onStopCallback).not.toHaveBeenCalled();
    });
  });
});
