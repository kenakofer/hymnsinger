export interface AppState {
    input: string;
    speed: number;
    metronomeVol: number;
    pianoVol: number;
    hasUrlPayload: boolean;
}
export declare const DEFAULT_STATE: AppState;
/**
 * StateParser handles serialization and deserialization of application state
 * to/from the URL using LZString compression.
 */
export declare class StateParser {
    private static readonly STATE_PARAM;
    private static readonly DEBOUNCE_DELAY;
    private debounceTimeout;
    /**
     * Extract and decompress state from URL.
     * If URL has no state param, returns default state with hasUrlPayload: false.
     *
     * @param urlSearch - The search string from window.location.search
     * @returns Parsed state object
     */
    static parseFromUrl(urlSearch: string): AppState;
    /**
     * Serialize and compress state to a URL-safe string.
     *
     * @param state - The state object to serialize
     * @returns Compressed state string suitable for URL
     */
    static serializeToUrl(state: AppState): string;
    /**
     * Generate the full practice URL with encoded state.
     *
     * @param state - The state object
     * @param baseUrl - The base URL (default: hymnsinger.com/practice/)
     * @returns Full URL with encoded state
     */
    static generateUrl(state: AppState, baseUrl?: string): string;
    /**
     * Create a debounced URL update handler.
     * Returns a function that updates the URL after a debounce delay.
     *
     * @param onUrlChange - Callback function when URL should be updated
     * @returns Function to call on state change
     */
    static createDebouncedUrlUpdater(onUrlChange: (url: string) => void, delayMs?: number): (state: AppState) => void;
}
//# sourceMappingURL=StateParser.d.ts.map