import type { PointerEvent } from 'react';

/** How far in screen pixels a press moves before it becomes a drag, so a click does not move the picture */
export const DRAG_THRESHOLD_PX = 4;
/** An arrow key's step in screen pixels */
export const NUDGE_PX = 1;
/** An arrow key's step in screen pixels with Shift held */
export const NUDGE_PX_LARGE = 10;

/** Whether the press is one a framing editor drags with, the left or the right button */
export const isDragButton = (event: PointerEvent) =>
  event.button === 0 || event.button === 2;

/** Takes a press for a drag: the page does not act on it, and the element gets focus and every pointer event until release */
export const captureDrag = (event: PointerEvent, element: HTMLElement) => {
  event.preventDefault();
  element.focus();
  element.setPointerCapture(event.pointerId);
};

/** Whether the pointer is still under DRAG_THRESHOLD_PX from where it pressed, so the press is not yet a drag */
export const withinDragThreshold = (
  start: { pointerX: number; pointerY: number },
  event: { clientX: number; clientY: number },
) =>
  Math.hypot(event.clientX - start.pointerX, event.clientY - start.pointerY) <
  DRAG_THRESHOLD_PX;

/** The arrow keys' step in screen pixels, the larger one with Shift */
export const nudgePixels = (shiftKey: boolean) =>
  shiftKey ? NUDGE_PX_LARGE : NUDGE_PX;

/** Each arrow key's direction as x and y, with right and down positive */
export const ARROW_DIRECTIONS: Record<string, [number, number]> = {
  ArrowLeft: [-1, 0],
  ArrowRight: [1, 0],
  ArrowUp: [0, -1],
  ArrowDown: [0, 1],
};

/** 1 for a key that zooms in, -1 for one that zooms out and 0 for any other. = and _ share a key with + and - */
export const zoomKeyDirection = (key: string) => {
  if (key === '+' || key === '=') {
    return 1;
  }
  if (key === '-' || key === '_') {
    return -1;
  }
  return 0;
};
