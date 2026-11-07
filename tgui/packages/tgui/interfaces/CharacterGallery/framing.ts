import { clamp } from 'tgui-core/math';

export type Framing = {
  zoom: number;
  x: number;
  y: number;
};

/** Where a drag began, the pointer and side in screen pixels and the position in percent */
export type DragOrigin = {
  pointerX: number;
  pointerY: number;
  /** The editor's side on screen, which tgui scaling can make differ from EDITOR_SIZE. */
  side: number;
  x: number;
  y: number;
};

/** Keeps a position between 0 and 100, which must match DM's HEADSHOT_POSITION_MAX */
export const clampPosition = (value: number) => clamp(value, 0, 100);

/** Drops anything that is not a real number, which zooming a picture that reports a zero side can produce, as can a slider dragged at no width */
export const finiteOnly = (changes: Partial<Framing>): Partial<Framing> =>
  Object.fromEntries(
    Object.entries(changes).filter(([, value]) => Number.isFinite(value)),
  );

export const coverSize = (
  natural: [number, number],
  side: number,
  zoom: number,
): [number, number] => {
  const scale = (side / Math.min(natural[0], natural[1])) * (zoom / 100);
  return [natural[0] * scale, natural[1] * scale];
};

/**
 * The position along one axis that keeps the picture point under the pointer where it is across a
 * zoom. `before` and `after` are the picture's covered length on either side of the zoom change.
 */
export const keepUnderPointer = (
  position: number,
  before: number,
  after: number,
  side: number,
  pointer: number,
) => {
  const overflowAfter = after - side;
  if (overflowAfter <= 0) {
    return position;
  }
  const shownFrom = (position / 100) * Math.max(before - side, 0);
  const point = (shownFrom + pointer) / before;
  return clampPosition(((point * after - pointer) / overflowAfter) * 100);
};

/** Whether the picture at this zoom is bigger than its square along an axis, 0 across or 1 down. */
export const overflowsAxis = (
  size: [number, number] | null,
  zoom: number,
  axis: 0 | 1,
) => !!size && (size[axis] / Math.min(size[0], size[1])) * zoom > 100;

export const dragPosition = (
  start: DragOrigin,
  size: [number, number] | null,
  zoom: number,
  clientX: number,
  clientY: number,
): Partial<Framing> => {
  if (!size) {
    return {};
  }
  const [width, height] = coverSize(size, start.side, zoom);
  const next: Partial<Framing> = {};
  if (width > start.side) {
    next.x = clampPosition(
      start.x - ((clientX - start.pointerX) / (width - start.side)) * 100,
    );
  }
  if (height > start.side) {
    next.y = clampPosition(
      start.y - ((clientY - start.pointerY) / (height - start.side)) * 100,
    );
  }
  return next;
};

export const nudgeStep = (
  size: [number, number] | null,
  zoom: number,
  axis: 0 | 1,
  pixels: number,
  side: number,
) => {
  if (!size) {
    return 0;
  }
  const overflow = coverSize(size, side, zoom)[axis] - side;
  // The server rounds to 0.1, so a smaller step would be lost and the picture would not move
  return overflow > 0 ? Math.max(0.1, (pixels / overflow) * 100) : 0;
};

export const zoomLimits = (
  size: [number, number] | null,
  panelSize: number,
  limitMin: number,
  zoomMax: number,
) => {
  // The zoom where one picture pixel fills one pixel of the examine panel, past which it blurs
  const shorterSide = size ? Math.min(size[0], size[1]) : 0;
  const sharpZoom = Math.floor((shorterSide / panelSize) * 100);
  return { sharpZoom, zoomLimit: clamp(sharpZoom, limitMin, zoomMax) };
};

/** The highest zoom the Zoom slider and the zoom keys allow, which holds a saved zoom above the limit in range until the next change */
export const zoomCeiling = (zoom: number, zoomLimit: number) =>
  Math.max(zoomLimit, zoom);

export const stepZoom = (
  zoom: number,
  step: number,
  zoomMin: number,
  zoomLimit: number,
) => clamp(zoom + step, zoomMin, zoomCeiling(zoom, zoomLimit));
