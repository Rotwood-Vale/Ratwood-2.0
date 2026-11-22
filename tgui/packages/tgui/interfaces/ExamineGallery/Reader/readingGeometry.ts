import {
  type ArtCrop,
  cropAspect,
  FULL_CROP,
} from '../../common/artViewSettings';
import type { Area, PictureBox } from '../../common/cardLayout';
import type { ReaderState } from './readingState';

/** The reader's largest zoom, which the layout lowers when the picture would pass the browser's side limit */
export const READER_ZOOM_MAX = 5;

export type ReadingBox = PictureBox & {
  surfaceWidth: number;
  surfaceHeight: number;
  zoomMax: number;
  zoomMin: number;
  focus?: ArtCrop;
};

const sideLimits = new WeakMap<Document, number>();

/** Measures layout capacity without allocating an image, canvas or material at that size. */
export const readerSideLimit = () => {
  const cached = sideLimits.get(document);
  if (cached) return cached;
  const probe = document.createElement('div');
  probe.style.cssText =
    'position:fixed;visibility:hidden;pointer-events:none;left:0;top:0;width:100000000px;height:0;';
  document.body.append(probe);
  const width = probe.getBoundingClientRect().width;
  probe.remove();
  const limit =
    width > 0 && Number.isFinite(width) ? width : Number.MAX_SAFE_INTEGER;
  sideLimits.set(document, limit);
  return limit;
};

/**
 * Fitted treats the framing as the picture at every zoom. Scrolling matches the framing
 * width to the reader at zoom 1 and starts at its top, showing as much image as the reader can hold.
 *
 * The surface leaves room for a frame near the edge of the image to open at its intended
 * position. As Scrolling zooms out, those margins move toward centring the whole image.
 */
export const readingBox = (
  aspect: number,
  area: Area,
  view: ReaderState['view'],
  zoom: number,
  margin: number,
  sideMax = Number.MAX_SAFE_INTEGER,
  openingCrop?: ArtCrop,
): ReadingBox => {
  const sourceAspect = Number.isFinite(aspect) && aspect > 0 ? aspect : 1;
  const fittedCrop = view === 'fitted' ? openingCrop : undefined;
  const ratio = cropAspect(sourceAspect, fittedCrop);
  const width = Math.max(0, area.width);
  const height = Math.max(0, area.height);
  const focus = view === 'fitted' ? undefined : openingCrop;
  const framing = focus ?? FULL_CROP;
  const scrolling = view === 'scroll';
  const fitMargin = view === 'whole' ? margin : 0;
  const focusFit = Math.max(
    0,
    Math.min(
      width - fitMargin * 2,
      (height - fitMargin * 2) * cropAspect(ratio, framing),
    ),
  );
  const openingWidth = (scrolling ? width : focusFit) / framing.w;
  // The image inside the Fitted frame still occupies its uncropped size in layout.
  const widthMax = sideMax * (fittedCrop?.w ?? 1);
  const heightMax = sideMax * (fittedCrop?.h ?? 1);
  const base = Math.min(openingWidth, widthMax, heightMax * ratio);
  const zoomMax =
    base > 0
      ? Math.max(
          1,
          Math.min(
            READER_ZOOM_MAX,
            widthMax / base,
            heightMax / (base / ratio),
          ),
        )
      : READER_ZOOM_MAX;
  const zoomMin =
    scrolling && base > 0
      ? Math.min(1, Math.min(width, height * ratio) / base)
      : 1;
  const shownZoom = Math.max(zoomMin, Math.min(zoomMax, zoom));
  const renderedWidth = base * shownZoom;
  const renderedHeight = renderedWidth / ratio;
  const toFocus =
    zoomMin < 1 ? Math.min(1, (shownZoom - zoomMin) / (1 - zoomMin)) : 1;
  const middleX = framing.x + framing.w / 2;
  const middleY = framing.y + framing.h / 2;
  const centreX = Math.max(0, (width - renderedWidth) / 2);
  const centreY = Math.max(0, (height - renderedHeight) / 2);
  const room = (centred: number, focused: number) =>
    focused * toFocus + centred * (1 - toFocus);
  const left = room(centreX, Math.max(0, width / 2 - middleX * renderedWidth));
  const right = room(
    centreX,
    Math.max(0, width / 2 - (1 - middleX) * renderedWidth),
  );
  const top = room(
    centreY,
    scrolling ? 0 : Math.max(0, height / 2 - middleY * renderedHeight),
  );
  const bottom = room(
    centreY,
    scrolling
      ? Math.max(0, height - (1 - framing.y) * renderedHeight)
      : Math.max(0, height / 2 - (1 - middleY) * renderedHeight),
  );
  const openingFocus =
    scrolling && focus && renderedHeight > 0
      ? { ...focus, h: Math.min(1 - focus.y, height / renderedHeight) }
      : focus;
  return {
    width: renderedWidth,
    height: renderedHeight,
    left,
    top,
    surfaceWidth: Math.max(width, left + renderedWidth + right),
    surfaceHeight: Math.max(height, top + renderedHeight + bottom),
    zoomMax,
    zoomMin,
    focus: openingFocus,
  };
};

export const zoomPercent = (zoom: number) => {
  const percent = zoom * 100;
  return `${percent >= 100 ? Math.round(percent) : percent.toLocaleString('en-US', { maximumSignificantDigits: 4, useGrouping: false })}%`;
};

export const imagePoint = (
  box: PictureBox,
  scroll: { left: number; top: number },
  pointer: { x: number; y: number },
) => ({
  x: box.width > 0 ? (scroll.left + pointer.x - box.left) / box.width : 0.5,
  y: box.height > 0 ? (scroll.top + pointer.y - box.top) / box.height : 0,
});

export const scrollToPoint = (
  box: ReadingBox,
  area: Area,
  point: { x: number; y: number },
  pointer: { x: number; y: number },
) => ({
  left: Math.max(
    0,
    Math.min(
      box.surfaceWidth - area.width,
      box.left + point.x * box.width - pointer.x,
    ),
  ),
  top: Math.max(
    0,
    Math.min(
      box.surfaceHeight - area.height,
      box.top + point.y * box.height - pointer.y,
    ),
  ),
});

/** The scroll that places the opening framing, or starts at the top without one */
export const focusScroll = (
  box: ReadingBox,
  area: Area,
  view: ReaderState['view'],
) => {
  const { focus } = box;
  if (!focus) return { left: 0, top: 0 };
  const scrolling = view === 'scroll';
  return scrollToPoint(
    box,
    area,
    {
      x: focus.x + focus.w / 2,
      y: scrolling ? focus.y : focus.y + focus.h / 2,
    },
    { x: area.width / 2, y: scrolling ? 0 : area.height / 2 },
  );
};

/** Whether the reader has been measured at the size it has now, as a layout from an older size would scroll to the wrong place */
export const readerMeasured = (
  reader: HTMLElement | null | undefined,
  area: Area,
) =>
  !!reader &&
  !!area.width &&
  !!area.height &&
  reader.clientWidth === area.width &&
  reader.clientHeight === area.height;

/** The CSS clip that shows only the focus of a picture laid out by readingBox */
export const focusClip = (focus: ArtCrop) =>
  `inset(${focus.y * 100}% ${(1 - focus.x - focus.w) * 100}% ${(1 - focus.y - focus.h) * 100}% ${focus.x * 100}%)`;
