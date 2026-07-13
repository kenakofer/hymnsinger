"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.StateParser = exports.DEFAULT_STATE = void 0;
const LZ = __importStar(require("lz-string"));
exports.DEFAULT_STATE = {
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
/**
 * StateParser handles serialization and deserialization of application state
 * to/from the URL using LZString compression.
 */
class StateParser {
    constructor() {
        this.debounceTimeout = null;
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
            return { ...exports.DEFAULT_STATE, hasUrlPayload: false };
        }
        try {
            const params = new URLSearchParams(urlSearch);
            const compressedState = params.get(StateParser.STATE_PARAM);
            if (!compressedState) {
                return { ...exports.DEFAULT_STATE, hasUrlPayload: false };
            }
            const decompressed = LZ.decompressFromEncodedURIComponent(compressedState);
            if (!decompressed) {
                return { ...exports.DEFAULT_STATE, hasUrlPayload: false };
            }
            const parsed = JSON.parse(decompressed);
            return {
                ...parsed,
                hasUrlPayload: true,
            };
        }
        catch (error) {
            console.error('Failed to parse state from URL:', error);
            return { ...exports.DEFAULT_STATE, hasUrlPayload: false };
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
        const compressed = LZ.compressToEncodedURIComponent(json);
        return compressed;
    }
    /**
     * Generate the full practice URL with encoded state.
     *
     * @param state - The state object
     * @param baseUrl - The base URL (default: hymnsinger.com/practice/)
     * @returns Full URL with encoded state
     */
    static generateUrl(state, baseUrl = 'https://hymnsinger.com/practice/') {
        const encodedState = StateParser.serializeToUrl(state);
        const url = new URL(baseUrl);
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
exports.StateParser = StateParser;
StateParser.STATE_PARAM = 'state';
StateParser.DEBOUNCE_DELAY = 2000;
//# sourceMappingURL=StateParser.js.map