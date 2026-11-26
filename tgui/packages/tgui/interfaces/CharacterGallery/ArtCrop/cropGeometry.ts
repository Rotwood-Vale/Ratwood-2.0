import { clamp } from 'tgui-core/math';

import {
  ART_CROP_MIN,
  type ArtCrop,
  clampCrop,
} from '../../common/artViewSettings';
import type { Area } from '../../common/cardLayout';

/** The crop zoom's ceiling in percent, a box an eighth of the picture, as the linear Zoom slider gets too coarse to place past it */
const CROP_ZOOM_MAX = 800;

export const EDGES = ['n', 'e', 's', 'w'] as const;
export const HANDLES = ['nw', 'n', 'ne', 'e', 'se', 's', 'sw', 'w'] as const;
type Handle = (typeof HANDLES)[number];
export type Part = Handle | 'move' | 'pan';
const CORNERS: readonly Part[] = ['nw', 'ne', 'se', 'sw'];

/** The editor's zoom and the picture point at the middle of the stage, as shares of the picture */
export type EditorView = { zoom: number; x: number; y: number };
export type Layout = {
  left: number;
  top: number;
  width: number;
  height: number;
};

export const axisOffset = (side: number, length: number, middle: number) =>
  length <= side
    ? (side - length) / 2
    : clamp(side / 2 - middle * length, side - length, 0);

export const pictureLayout = (
  size: [number, number],
  stage: Area,
  view: EditorView,
): Layout => {
  const fit = Math.min(stage.width / size[0], stage.height / size[1]);
  const width = size[0] * fit * view.zoom;
  const height = size[1] * fit * view.zoom;
  return {
    width,
    height,
    left: axisOffset(stage.width, width, view.x),
    top: axisOffset(stage.height, height, view.y),
  };
};

/** Moves the view's middle to where the layout actually puts it, so a pan past the picture's edge does not build up */
export const settleView = (
  size: [number, number],
  stage: Area,
  view: EditorView,
): EditorView => {
  const layout = pictureLayout(size, stage, view);
  return {
    zoom: view.zoom,
    x: (stage.width / 2 - layout.left) / layout.width,
    y: (stage.height / 2 - layout.top) / layout.height,
  };
};

export const zoomView = (
  size: [number, number],
  stage: Area,
  view: EditorView,
  zoom: number,
  point: { x: number; y: number },
): EditorView => {
  const before = pictureLayout(size, stage, view);
  const after = pictureLayout(size, stage, { ...view, zoom });
  const left = point.x - ((point.x - before.left) / before.width) * after.width;
  const top = point.y - ((point.y - before.top) / before.height) * after.height;
  return settleView(size, stage, {
    zoom,
    x: (stage.width / 2 - left) / after.width,
    y: (stage.height / 2 - top) / after.height,
  });
};

/** Moves a dragged corner by dx and dy, shares of the picture, scaling the box from the opposite corner in its shape */
export const dragCorner = (
  start: ArtCrop,
  part: Part,
  dx: number,
  dy: number,
) => {
  const east = part.includes('e');
  const south = part.includes('s');
  const anchorX = east ? start.x : start.x + start.w;
  const anchorY = south ? start.y : start.y + start.h;
  const width = start.w + (east ? dx : -dx);
  const height = start.h + (south ? dy : -dy);
  const scale = clamp(
    Math.max(width / start.w, height / start.h),
    ART_CROP_MIN / Math.min(start.w, start.h),
    Math.min(
      (east ? 1 - anchorX : anchorX) / start.w,
      (south ? 1 - anchorY : anchorY) / start.h,
    ),
  );
  const w = start.w * scale;
  const h = start.h * scale;
  return clampCrop({
    x: east ? anchorX : anchorX - w,
    y: south ? anchorY : anchorY - h,
    w,
    h,
  });
};

/** Moves the dragged sides of a crop by dx and dy, shares of the picture, keeping it inside the picture */
export const dragCrop = (
  start: ArtCrop,
  part: Part,
  dx: number,
  dy: number,
  keepShape = false,
) => {
  if (keepShape && CORNERS.includes(part)) {
    return dragCorner(start, part, dx, dy);
  }
  if (part === 'move') {
    const { x, y } = clampCrop({
      ...start,
      x: clamp(start.x + dx, 0, 1 - start.w),
      y: clamp(start.y + dy, 0, 1 - start.h),
    });
    return { ...start, x, y };
  }
  let left = start.x;
  let top = start.y;
  let right = start.x + start.w;
  let bottom = start.y + start.h;
  if (part.includes('w')) left = clamp(left + dx, 0, right - ART_CROP_MIN);
  if (part.includes('e')) right = clamp(right + dx, left + ART_CROP_MIN, 1);
  if (part.includes('n')) top = clamp(top + dy, 0, bottom - ART_CROP_MIN);
  if (part.includes('s')) bottom = clamp(bottom + dy, top + ART_CROP_MIN, 1);
  return clampCrop({ x: left, y: top, w: right - left, h: bottom - top });
};

/** Moves or resizes the opening viewport. Its width and origin define the Scrolling frame. */
export const dragScrollingCrop = (
  start: ArtCrop,
  part: Handle | 'move',
  dx: number,
  dy: number,
  sourceAspect: number,
) => {
  if (part === 'move') {
    return clampCrop({
      ...start,
      x: clamp(start.x + dx, 0, 1 - start.w),
      y: start.y + dy,
    });
  }
  const east = part.includes('e');
  const west = part.includes('w');
  const north = part.includes('n');
  const south = part.includes('s');
  const anchorShareX = east ? 0 : west ? 1 : 0.5;
  const anchorShareY = north ? 1 : 0;
  const anchorX = start.x + anchorShareX * start.w;
  const anchorY = start.y + anchorShareY * start.h;
  // Project the pointer onto the allowed resize direction in source pixels.
  const weightX = east || west ? (start.w * sourceAspect) ** 2 : 0;
  const weightY = north || south ? start.h ** 2 : 0;
  const scale = clamp(
    1 +
      (weightX * ((east ? dx : -dx) / start.w) +
        weightY * ((south ? dy : -dy) / start.h)) /
        (weightX + weightY),
    ART_CROP_MIN / start.w,
    Math.min(
      (east
        ? 1 - anchorX
        : west
          ? anchorX
          : 2 * Math.min(anchorX, 1 - anchorX)) / start.w,
      north ? anchorY / start.h : Infinity,
    ),
  );
  const w = start.w * scale;
  const h = start.h * scale;
  return clampCrop({
    x: anchorX - anchorShareX * w,
    y: anchorY - anchorShareY * h,
    w,
    h,
  });
};

/** Scrolling zoom follows the box width. Other modes use the crop's longer side. */
export const cropZoom = (crop: ArtCrop, scrolling = false) =>
  100 / (scrolling ? crop.w : Math.max(crop.w, crop.h));

/** The highest zoom the box's shape allows before its shorter side would go under ART_CROP_MIN, up to CROP_ZOOM_MAX */
export const cropZoomLimit = (crop: ArtCrop, scrolling = false) =>
  scrolling
    ? CROP_ZOOM_MAX
    : Math.min(
        CROP_ZOOM_MAX,
        (100 * Math.min(crop.w, crop.h)) /
          (ART_CROP_MIN * Math.max(crop.w, crop.h)),
      );

/** The zoom a step can reach, which holds a box drawn past the limit by hand where it is until it zooms out */
export const clampCropZoom = (crop: ArtCrop, zoom: number, scrolling = false) =>
  clamp(
    zoom,
    100,
    Math.max(cropZoomLimit(crop, scrolling), cropZoom(crop, scrolling)),
  );

export const cropZoomPoint = (crop: ArtCrop, scrolling: boolean) => ({
  x: crop.x + crop.w / 2,
  y: scrolling ? crop.y : crop.y + crop.h / 2,
});

export const sameCrop = (
  a: ArtCrop | undefined,
  b: ArtCrop | undefined,
  scrolling = false,
) =>
  a === b ||
  (!!a &&
    !!b &&
    a.x === b.x &&
    a.y === b.y &&
    a.w === b.w &&
    (scrolling || a.h === b.h));

/** Scales a crop to a zoom in its own shape, keeping the point, shares of the picture, in place as far as the picture's edges allow */
export const zoomCrop = (
  crop: ArtCrop,
  zoom: number,
  point: { x: number; y: number },
  scrolling = false,
) => {
  const scale = cropZoom(crop, scrolling) / zoom;
  const w = crop.w * scale;
  const h = crop.h * scale;
  return clampCrop({
    x: clamp(point.x - (point.x - crop.x) * scale, 0, 1 - w),
    y: clamp(
      point.y - (point.y - crop.y) * scale,
      0,
      1 - (scrolling ? ART_CROP_MIN : h),
    ),
    w,
    h,
  });
};

export const partOf = (target: EventTarget): Part =>
  (target instanceof HTMLElement && (target.dataset.part as Part)) || 'pan';
