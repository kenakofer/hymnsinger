import * as LZ from 'lz-string';

export interface AppState {
  input: string;
  speed: number;
  metronomeVol: number;
  pianoVol: number;
  hasUrlPayload: boolean;
}

export const DEFAULT_STATE: AppState = {
  input: `M: 4/4
L: 1/4
Q: 1/4=80
K: Bb
F/2 | B A/2G/2 (3G F E- | E/2 (E/2C/2) D z/2 |
w: This is an ex- am- ple to _ prac- _ tice`,
  speed: 1.0,
  metronomeVol: 50,
  pianoVol: 80,
  hasUrlPayload: false,
};

/**
 * StateParser handles serialization and deserialization of application state
 * to/from the URL using LZString compression.
 */
export class StateParser {
  private static readonly STATE_PARAM = 'state';
  private static readonly DEBOUNCE_DELAY = 2000;
  private debounceTimeout: number | null = null;

  /**
   * Extract and decompress state from URL.
   * If URL has no state param, returns default state with hasUrlPayload: false.
   * 
   * @param urlSearch - The search string from window.location.search
   * @returns Parsed state object
   */
  public static parseFromUrl(urlSearch: string): AppState {
    if (!urlSearch) {
      return { ...DEFAULT_STATE, hasUrlPayload: false };
    }

    try {
      const params = new URLSearchParams(urlSearch);
      const compressedState = params.get(StateParser.STATE_PARAM);

      if (!compressedState) {
        return { ...DEFAULT_STATE, hasUrlPayload: false };
      }

      const lzModule = (LZ as any).default || LZ;
      const decompressed = lzModule.decompressFromEncodedURIComponent(compressedState);
      if (!decompressed) {
        return { ...DEFAULT_STATE, hasUrlPayload: false };
      }

      const parsed = JSON.parse(decompressed) as Omit<AppState, 'hasUrlPayload'>;
      return {
        ...parsed,
        hasUrlPayload: true,
      };
    } catch (error) {
      console.error('Failed to parse state from URL:', error);
      return { ...DEFAULT_STATE, hasUrlPayload: false };
    }
  }

  /**
   * Serialize and compress state to a URL-safe string.
   * 
   * @param state - The state object to serialize
   * @returns Compressed state string suitable for URL
   */
  public static serializeToUrl(state: AppState): string {
    const stateWithoutPayload = {
      input: state.input,
      speed: state.speed,
      metronomeVol: state.metronomeVol,
      pianoVol: state.pianoVol,
    };
    const json = JSON.stringify(stateWithoutPayload);
    const lzModule = (LZ as any).default || LZ;
    const compressed = lzModule.compressToEncodedURIComponent(json);
    return compressed;
  }

  /**
   * Generate the full practice URL with encoded state.
   * 
   * @param state - The state object
   * @param baseUrl - The base URL (default: hymnsinger.com/practice/)
   * @returns Full URL with encoded state
   */
  public static generateUrl(
    state: AppState,
    baseUrl?: string
  ): string {
    const encodedState = StateParser.serializeToUrl(state);
    // Use current page URL without query params as base, or use provided baseUrl
    const base = baseUrl || window.location.pathname + window.location.hash;
    const url = new URL(base, window.location.origin);
    url.searchParams.set(StateParser.STATE_PARAM, encodedState);
    return url.toString();
  }

  /**
   * Create a debounced URL update handler.
   * Returns a function that updates the URL after a debounce delay.
   * 
   * @param onUrlChange - Callback function when URL should be updated
   * @returns Function to call on state change
   */
  public static createDebouncedUrlUpdater(
    onUrlChange: (url: string) => void,
    delayMs: number = this.DEBOUNCE_DELAY
  ): (state: AppState) => void {
    let timeoutId: number | null = null;

    return (state: AppState) => {
      if (timeoutId !== null) {
        clearTimeout(timeoutId);
      }

      timeoutId = window.setTimeout(() => {
        const url = StateParser.generateUrl(state);
        onUrlChange(url);
        timeoutId = null;
      }, delayMs);
    };
  }
}
