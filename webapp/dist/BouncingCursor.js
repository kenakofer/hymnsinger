"use strict";
/**
 * BouncingCursor implements the abcjs CursorControl interface to provide
 * visual feedback during music playback with a bouncing ball animation.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.BouncingCursor = void 0;
class BouncingCursor {
    constructor(svgContainerId) {
        this.cursorElement = null;
        this.animationFrameId = null;
        this.lastX = 0;
        this.lastY = 0;
        const container = document.getElementById(svgContainerId);
        if (!container) {
            throw new Error(`SVG container with id "${svgContainerId}" not found`);
        }
        this.svgContainer = container;
    }
    /**
     * Create the visual cursor element (red circle dot).
     * Called once at initialization.
     */
    create() {
        if (this.cursorElement) {
            this.cursorElement.remove();
        }
        this.cursorElement = document.createElement('div');
        this.cursorElement.id = 'abc-bouncing-cursor';
        this.cursorElement.style.position = 'absolute';
        this.cursorElement.style.width = '10px';
        this.cursorElement.style.height = '10px';
        this.cursorElement.style.borderRadius = '50%';
        this.cursorElement.style.backgroundColor = 'red';
        this.cursorElement.style.zIndex = '1000';
        this.cursorElement.style.pointerEvents = 'none';
        this.cursorElement.style.boxShadow = '0 0 8px rgba(255, 0, 0, 0.8)';
        this.cursorElement.style.transition = 'all 0.1s ease-out';
        // Ensure SVG container has position context for absolute positioning
        if (this.svgContainer.style.position === '' ||
            this.svgContainer.style.position === 'static') {
            this.svgContainer.style.position = 'relative';
        }
        this.svgContainer.appendChild(this.cursorElement);
    }
    /**
     * Show the cursor.
     */
    show() {
        if (this.cursorElement) {
            this.cursorElement.style.opacity = '1';
        }
    }
    /**
     * Hide the cursor.
     */
    hide() {
        if (this.cursorElement) {
            this.cursorElement.style.opacity = '0';
        }
    }
    /**
     * Set the cursor position with parabolic bounce animation.
     * This is called by abcjs's TimingCallbacks with exact X/Y coordinates.
     *
     * @param callback - The abcjs cursor callback containing position data
     */
    setProgress(callback) {
        if (!this.cursorElement) {
            return;
        }
        // Calculate parabolic bounce effect based on horizontal movement
        const horizontalDelta = Math.abs(callback.x - this.lastX);
        const bounceAmount = Math.sin(callback.x / 50) * 15; // More pronounced bounce
        const posX = callback.x - 5; // Center the dot (width is 10px)
        const posY = callback.y - 5 + bounceAmount; // Center vertically and add bounce
        this.cursorElement.style.left = `${posX}px`;
        this.cursorElement.style.top = `${posY}px`;
        this.lastX = callback.x;
        this.lastY = callback.y;
    }
    /**
     * Reset the cursor to initial state.
     */
    reset() {
        if (this.cursorElement) {
            this.cursorElement.style.left = '0px';
            this.cursorElement.style.top = '0px';
        }
        this.lastX = 0;
        this.lastY = 0;
    }
    /**
     * Clean up resources.
     */
    destroy() {
        if (this.animationFrameId !== null) {
            cancelAnimationFrame(this.animationFrameId);
        }
        if (this.cursorElement) {
            this.cursorElement.remove();
            this.cursorElement = null;
        }
    }
}
exports.BouncingCursor = BouncingCursor;
//# sourceMappingURL=BouncingCursor.js.map