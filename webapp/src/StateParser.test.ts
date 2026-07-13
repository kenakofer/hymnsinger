import { StateParser, DEFAULT_STATE, type AppState } from './StateParser';
import * as LZ from 'lz-string';

describe('StateParser', () => {
  describe('parseFromUrl', () => {
    it('should return default state when URL search is empty', () => {
      const state = StateParser.parseFromUrl('');
      expect(state).toEqual({ ...DEFAULT_STATE, hasUrlPayload: false });
    });

    it('should return default state when no state param exists', () => {
      const state = StateParser.parseFromUrl('?other=value');
      expect(state).toEqual({ ...DEFAULT_STATE, hasUrlPayload: false });
    });

    it('should decompress and parse valid state from URL', () => {
      const originalState: Omit<AppState, 'hasUrlPayload'> = {
        input: 'K: C\nC D E F',
        speed: 1.5,
        metronomeVol: 30,
        pianoVol: 70,
      };

      const compressed = LZ.compressToEncodedURIComponent(JSON.stringify(originalState));
      const urlSearch = `?state=${compressed}`;

      const state = StateParser.parseFromUrl(urlSearch);
      expect(state.input).toBe(originalState.input);
      expect(state.speed).toBe(originalState.speed);
      expect(state.metronomeVol).toBe(originalState.metronomeVol);
      expect(state.pianoVol).toBe(originalState.pianoVol);
      expect(state.hasUrlPayload).toBe(true);
    });

    it('should return default state on decompression failure', () => {
      const state = StateParser.parseFromUrl('?state=INVALID_COMPRESSION');
      expect(state).toEqual({ ...DEFAULT_STATE, hasUrlPayload: false });
    });

    it('should handle malformed JSON gracefully', () => {
      const compressed = LZ.compressToEncodedURIComponent('not json');
      const state = StateParser.parseFromUrl(`?state=${compressed}`);
      expect(state).toEqual({ ...DEFAULT_STATE, hasUrlPayload: false });
    });
  });

  describe('serializeToUrl', () => {
    it('should compress state to URL-safe string', () => {
      const state: AppState = {
        input: 'K: G\nG A B c',
        speed: 2.0,
        metronomeVol: 60,
        pianoVol: 90,
        hasUrlPayload: true,
      };

      const compressed = StateParser.serializeToUrl(state);
      expect(typeof compressed).toBe('string');
      expect(compressed).toBeTruthy();
      expect(compressed).not.toContain('hasUrlPayload');

      // Verify it decompresses correctly
      const decompressed = LZ.decompressFromEncodedURIComponent(compressed);
      const parsed = JSON.parse(decompressed);
      expect(parsed.input).toBe(state.input);
      expect(parsed.speed).toBe(state.speed);
      expect(parsed.metronomeVol).toBe(state.metronomeVol);
      expect(parsed.pianoVol).toBe(state.pianoVol);
    });

    it('should exclude hasUrlPayload from serialization', () => {
      const state: AppState = {
        input: 'test',
        speed: 1.0,
        metronomeVol: 50,
        pianoVol: 80,
        hasUrlPayload: true,
      };

      const compressed = StateParser.serializeToUrl(state);
      const decompressed = LZ.decompressFromEncodedURIComponent(compressed);
      const parsed = JSON.parse(decompressed);

      expect(parsed).not.toHaveProperty('hasUrlPayload');
    });

    it('should handle special characters in input', () => {
      const state: AppState = {
        input: 'K: C\nw: Special chars: é à ü ñ & < >',
        speed: 1.0,
        metronomeVol: 50,
        pianoVol: 80,
        hasUrlPayload: false,
      };

      const compressed = StateParser.serializeToUrl(state);
      const decompressed = LZ.decompressFromEncodedURIComponent(compressed);
      const parsed = JSON.parse(decompressed);

      expect(parsed.input).toBe(state.input);
    });

    it('should handle multiline ABC notation', () => {
      const state: AppState = {
        input: `M: 4/4
L: 1/4
Q: 1/4=80
K: Bb
F/2 | B A/2G/2 (3G F E- | E/2 (E/2C/2) D z/2 |
w: This here is a song you can _ prac- _ tice`,
        speed: 1.0,
        metronomeVol: 50,
        pianoVol: 80,
        hasUrlPayload: false,
      };

      const compressed = StateParser.serializeToUrl(state);
      const decompressed = LZ.decompressFromEncodedURIComponent(compressed);
      const parsed = JSON.parse(decompressed);

      expect(parsed.input).toBe(state.input);
    });
  });

  describe('generateUrl', () => {
    it('should generate full URL with encoded state', () => {
      const state: AppState = {
        input: 'K: D',
        speed: 1.2,
        metronomeVol: 40,
        pianoVol: 75,
        hasUrlPayload: false,
      };

      const url = StateParser.generateUrl(state);
      expect(url).toContain('state=');
      // The URL should be valid and contain the state parameter
      expect(url).toMatch(/\?state=[A-Za-z0-9%]+$/);
    });

    it('should use custom base URL', () => {
      const state: AppState = {
        input: 'K: A',
        speed: 1.0,
        metronomeVol: 50,
        pianoVol: 80,
        hasUrlPayload: false,
      };

      const customUrl = 'http://localhost:3000/practice/';
      const url = StateParser.generateUrl(state, customUrl);
      expect(url).toContain('localhost:3000');
      expect(url).toContain('state=');
    });

    it('should produce URL that can be parsed back to state', () => {
      const originalState: AppState = {
        input: 'K: F\nF G A B',
        speed: 0.8,
        metronomeVol: 25,
        pianoVol: 95,
        hasUrlPayload: false,
      };

      const url = StateParser.generateUrl(originalState);
      const urlSearch = new URL(url).search;
      const parsedState = StateParser.parseFromUrl(urlSearch);

      expect(parsedState.input).toBe(originalState.input);
      expect(parsedState.speed).toBe(originalState.speed);
      expect(parsedState.metronomeVol).toBe(originalState.metronomeVol);
      expect(parsedState.pianoVol).toBe(originalState.pianoVol);
      expect(parsedState.hasUrlPayload).toBe(true);
    });
  });

  describe('createDebouncedUrlUpdater', () => {
    beforeEach(() => {
      jest.useFakeTimers();
    });

    afterEach(() => {
      jest.runOnlyPendingTimers();
      jest.useRealTimers();
    });

    it('should call callback after debounce delay', () => {
      const callback = jest.fn();
      const updater = StateParser.createDebouncedUrlUpdater(callback, 2000);

      const state: AppState = {
        input: 'K: C',
        speed: 1.0,
        metronomeVol: 50,
        pianoVol: 80,
        hasUrlPayload: false,
      };

      updater(state);
      expect(callback).not.toHaveBeenCalled();

      jest.advanceTimersByTime(2000);
      expect(callback).toHaveBeenCalledTimes(1);
      expect(callback).toHaveBeenCalledWith(expect.stringContaining('state='));
    });

    it('should debounce rapid updates', () => {
      const callback = jest.fn();
      const updater = StateParser.createDebouncedUrlUpdater(callback, 2000);

      const state1: AppState = {
        input: 'K: C',
        speed: 1.0,
        metronomeVol: 50,
        pianoVol: 80,
        hasUrlPayload: false,
      };

      const state2: AppState = {
        ...state1,
        input: 'K: C\nC D',
      };

      // Rapid updates
      updater(state1);
      jest.advanceTimersByTime(500);
      updater(state2);
      jest.advanceTimersByTime(500);

      // Still shouldn't be called
      expect(callback).not.toHaveBeenCalled();

      // After full debounce period from last update
      jest.advanceTimersByTime(1500);
      expect(callback).toHaveBeenCalledTimes(1);
    });

    it('should use custom debounce delay', () => {
      const callback = jest.fn();
      const updater = StateParser.createDebouncedUrlUpdater(callback, 500);

      const state: AppState = {
        input: 'K: G',
        speed: 1.0,
        metronomeVol: 50,
        pianoVol: 80,
        hasUrlPayload: false,
      };

      updater(state);
      jest.advanceTimersByTime(500);
      expect(callback).toHaveBeenCalledTimes(1);
    });

    it('should pass correct URL to callback', () => {
      const callback = jest.fn();
      const updater = StateParser.createDebouncedUrlUpdater(callback, 2000);

      const state: AppState = {
        input: 'K: Em\nE F G',
        speed: 1.5,
        metronomeVol: 60,
        pianoVol: 85,
        hasUrlPayload: false,
      };

      updater(state);
      jest.advanceTimersByTime(2000);

      const callbackUrl = callback.mock.calls[0][0];
      const searchParams = new URL(callbackUrl).search;
      const parsedState = StateParser.parseFromUrl(searchParams);

      expect(parsedState.input).toBe(state.input);
      expect(parsedState.speed).toBe(state.speed);
      expect(parsedState.metronomeVol).toBe(state.metronomeVol);
      expect(parsedState.pianoVol).toBe(state.pianoVol);
    });
  });

  describe('round-trip serialization', () => {
    it('should preserve state through serialize -> deserialize cycle', () => {
      const originalState: AppState = {
        input: `M: 3/4
L: 1/8
Q: 1/4=120
K: A
A2 B2 c2 | d4 e2 | f8 |
w: La - la - la - la la la`,
        speed: 2.5,
        metronomeVol: 75,
        pianoVol: 45,
        hasUrlPayload: false,
      };

      const url = StateParser.generateUrl(originalState);
      const urlSearch = new URL(url).search;
      const restoredState = StateParser.parseFromUrl(urlSearch);

      expect(restoredState.input).toBe(originalState.input);
      expect(restoredState.speed).toBe(originalState.speed);
      expect(restoredState.metronomeVol).toBe(originalState.metronomeVol);
      expect(restoredState.pianoVol).toBe(originalState.pianoVol);
      expect(restoredState.hasUrlPayload).toBe(true);
    });
  });
});
