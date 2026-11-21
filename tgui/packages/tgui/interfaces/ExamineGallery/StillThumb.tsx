import { useEffect, useRef } from 'react';
import { Icon } from 'tgui-core/components';

import type { Pictures } from './usePictures';

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

const drawCover = (canvas: HTMLCanvasElement, source: HTMLImageElement) => {
  const context = canvas.getContext('2d');
  if (!context || !source.naturalWidth || !source.naturalHeight) {
    return;
  }
  const density = window.devicePixelRatio || 1;
  const width = Math.max(1, Math.round(canvas.clientWidth * density));
  const height = Math.max(1, Math.round(canvas.clientHeight * density));
  canvas.width = width;
  canvas.height = height;
  const scale = Math.max(
    width / source.naturalWidth,
    height / source.naturalHeight,
  );
  const cropWidth = width / scale;
  const cropHeight = height / scale;
  context.drawImage(
    source,
    (source.naturalWidth - cropWidth) / 2,
    (source.naturalHeight - cropHeight) / 2,
    cropWidth,
    cropHeight,
    0,
    0,
    width,
    height,
  );
};

/** A thumbnail drawn once onto a canvas, so an animated picture holds its first frame and only the main picture animates. */
export const StillThumb = (props: { url: string; pictures: Pictures }) => {
  const { url, pictures } = props;
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const drawable = pictures.drawable(url);
  const source = drawable ? pictures.sourceOf(url) : undefined;

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
          drawCover(canvas, source);
        }
      });
    return () => {
      current = false;
    };
  }, [source]);

  if (pictures.tooLarge(url)) {
    return (
      <span className="ExamineGallery__thumbPlaceholder">
        <Icon name="image" />
      </span>
    );
  }
  return drawable ? <canvas ref={canvasRef} /> : null;
};
