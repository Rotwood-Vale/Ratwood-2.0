import { useEffect, useRef } from 'react';
import { Icon } from 'tgui-core/components';

import { type ArtViewSettings, viewCrop } from '../../common/artViewSettings';
import type { Pictures } from '../usePictures';

let canvasContextOpened = false;

/**
 * Draws on a one pixel canvas once per window, which opens the GPU context every canvas here shares.
 *
 * The first draw on any canvas waits for that context. Called before the opening deal's first frame is
 * painted the wait is a fraction of a millisecond, while the first thumbnail would otherwise stall the
 * page for as long as the GPU takes to raster that frame.
 */
export const openCanvasContext = () => {
  if (canvasContextOpened) {
    return;
  }
  canvasContextOpened = true;
  const canvas = document.createElement('canvas');
  canvas.width = 1;
  canvas.height = 1;
  canvas.getContext('2d')?.fillRect(0, 0, 1, 1);
};

const drawCover = (
  canvas: HTMLCanvasElement,
  source: HTMLImageElement,
  settings: ArtViewSettings | undefined,
) => {
  const context = canvas.getContext('2d');
  const { naturalWidth, naturalHeight } = source;
  if (!context || !naturalWidth || !naturalHeight) {
    return;
  }
  const crop = viewCrop(
    settings?.opening_view ?? 'whole',
    settings,
    naturalWidth / naturalHeight,
  );
  const density = window.devicePixelRatio || 1;
  const width = Math.max(1, Math.round(canvas.clientWidth * density));
  const height = Math.max(1, Math.round(canvas.clientHeight * density));
  canvas.width = width;
  canvas.height = height;
  const shownWidth = crop.w * naturalWidth;
  const shownHeight = crop.h * naturalHeight;
  const scale = Math.max(width / shownWidth, height / shownHeight);
  const cropWidth = width / scale;
  const cropHeight = height / scale;
  context.drawImage(
    source,
    crop.x * naturalWidth + (shownWidth - cropWidth) / 2,
    crop.y * naturalHeight + (shownHeight - cropHeight) / 2,
    cropWidth,
    cropHeight,
    0,
    0,
    width,
    height,
  );
};

/** A thumbnail drawn once onto a canvas, so an animated picture holds its first frame and only the main picture animates. */
export const StillThumb = (props: {
  url: string;
  settings: ArtViewSettings | undefined;
  pictures: Pictures;
}) => {
  const { url, settings, pictures } = props;
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const drawable = pictures.drawable(url);
  const source = drawable ? pictures.sourceOf(url) : undefined;
  const latestSettings = useRef(settings);
  latestSettings.current = settings;
  const framing = JSON.stringify([
    settings?.opening_view,
    settings?.crop ?? null,
  ]);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas || !source) {
      return;
    }
    let current = true;
    // Decoded off the main thread first, as drawImage would decode it in place
    source
      .decode()
      .catch(() => undefined)
      .then(() => {
        if (current) {
          drawCover(canvas, source, latestSettings.current);
        }
      });
    return () => {
      current = false;
    };
  }, [source, framing]);

  if (pictures.exceedsLimits(url)) {
    return (
      <span className="ExamineGallery__thumbPlaceholder">
        <Icon name="image" />
      </span>
    );
  }
  return drawable ? <canvas ref={canvasRef} /> : null;
};
