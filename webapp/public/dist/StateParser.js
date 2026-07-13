import * as LZ from 'lz-string';
export const DEFAULT_STATE = {
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
    constructor() {
        Object.defineProperty(this, "debounceTimeout", {
            enumerable: true,
            configurable: true,
            writable: true,
            value: null
        });
    }
    /**
     * Extract and decompress state from URL.
     * If URL has no state param, returns default state with hasUrlPayload: false.
     *
     * @param urlSearch - The search string from window.location.search
     * @returns Parsed state object
     */
    static parseFromUrl(urlSearch) {
        if (!urlSearch) {
            return { ...DEFAULT_STATE, hasUrlPayload: false };
        }
        try {
            const params = new URLSearchParams(urlSearch);
            const compressedState = params.get(StateParser.STATE_PARAM);
            if (!compressedState) {
                return { ...DEFAULT_STATE, hasUrlPayload: false };
            }
            const lzModule = LZ.default || LZ;
            const decompressed = lzModule.decompressFromEncodedURIComponent(compressedState);
            if (!decompressed) {
                return { ...DEFAULT_STATE, hasUrlPayload: false };
            }
            const parsed = JSON.parse(decompressed);
            return {
                ...parsed,
                hasUrlPayload: true,
            };
        }
        catch (error) {
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
    static serializeToUrl(state) {
        const stateWithoutPayload = {
            input: state.input,
            speed: state.speed,
            metronomeVol: state.metronomeVol,
            pianoVol: state.pianoVol,
        };
        const json = JSON.stringify(stateWithoutPayload);
        const lzModule = LZ.default || LZ;
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
    static generateUrl(state, baseUrl) {
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
    static createDebouncedUrlUpdater(onUrlChange, delayMs = this.DEBOUNCE_DELAY) {
        let timeoutId = null;
        return (state) => {
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
Object.defineProperty(StateParser, "STATE_PARAM", {
    enumerable: true,
    configurable: true,
    writable: true,
    value: 'state'
});
Object.defineProperty(StateParser, "DEBOUNCE_DELAY", {
    enumerable: true,
    configurable: true,
    writable: true,
    value: 2000
});
//# sourceMappingURL=StateParser.js.map