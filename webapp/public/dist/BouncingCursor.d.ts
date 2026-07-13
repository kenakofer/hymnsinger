/**
 * BouncingCursor implements the abcjs CursorControl interface to provide
 * visual feedback during music playback with a bouncing ball animation.
 */
export interface AbcjsCursorCallback {
    x: number;
    y: number;
    width: number;
    height: number;
}
export declare class BouncingCursor {
    private cursorElement;
    private svgContainer;
    private animationFrameId;
    private lastX;
    private lastY;
    constructor(svgContainerId: string);
    /**
     * Create the visual cursor element (red circle dot).
     * Called once at initialization.
     */
    create(): void;
    /**
     * Show the cursor.
     */
    show(): void;
    /**
     * Hide the cursor.
     */
    hide(): void;
    /**
     * Set the cursor position with parabolic bounce animation.
     * This is called by abcjs's TimingCallbacks with exact X/Y coordinates.
     *
     * @param callback - The abcjs cursor callback containing position data
     */
    setProgress(callback: AbcjsCursorCallback): void;
    /**
     * Reset the cursor to initial state.
     */
    reset(): void;
    /**
     * Clean up resources.
     */
    destroy(): void;
}
//# sourceMappingURL=BouncingCursor.d.ts.map