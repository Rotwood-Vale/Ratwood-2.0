import type { PictureBox } from './layout';
import type { ReaderState } from './readingState';

type Area = { width: number; height: number };
export type ReadingBox = PictureBox & {
  surfaceWidth: number;
  surfaceHeight: number;
  zoomMax: number;
  zoomMin: number;
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

export const readingBox = (
  aspect: number,
  area: Area,
  view: ReaderState['view'],
  zoom: number,
  margin: number,
  sideMax = Number.MAX_SAFE_INTEGER,
): ReadingBox => {
  const ratio = Number.isFinite(aspect) && aspect > 0 ? aspect : 1;
  const width = Math.max(0, area.width);
  const height = Math.max(0, area.height);
  const fitMargin = view === 'whole' ? margin : 0;
  const fitted =
    view === 'scroll'
      ? width
      : Math.max(
          0,
          Math.min(width - fitMargin * 2, (height - fitMargin * 2) * ratio),
        );
  const base = Math.min(fitted, sideMax, sideMax * ratio);
  const zoomMax =
    base > 0
      ? Math.max(1, Math.min(5, sideMax / base, sideMax / (base / ratio)))
      : 5;
  const zoomMin =
    view === 'scroll' && base > 0 && height > 0
      ? Math.min(1, height / (base / ratio))
      : 1;
  const renderedWidth = base * Math.max(zoomMin, Math.min(zoomMax, zoom));
  const renderedHeight = renderedWidth / ratio;
  return {
    width: renderedWidth,
    height: renderedHeight,
    left: Math.max(0, (width - renderedWidth) / 2),
    top: view === 'scroll' ? 0 : Math.max(0, (height - renderedHeight) / 2),
    surfaceWidth: Math.max(width, renderedWidth),
    surfaceHeight: Math.max(height, renderedHeight),
    zoomMax,
    zoomMin,
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
