import { useEffect, useRef, useState } from 'react';

import { resolveAsset } from '../../assets';

/** The most pixels a picture may have and still be drawn, as decoding a bigger one can take gigabytes. */
export const PICTURE_PIXELS_MAX = 10_000_000;

export const fitsPixelCap = (width: number, height: number) =>
  width * height <= PICTURE_PIXELS_MAX;

const RATIO_SIDE_MAX = 99;

const RATIO_NAMES: Record<string, string> = {
  '8:5': '16:10',
  '5:8': '10:16',
  '7:3': '21:9',
  '3:7': '9:21',
};

const divisorOf = (a: number, b: number) => {
  while (b) {
    [a, b] = [b, a % b];
  }
  return a;
};

const nearestTwoDigitRatio = (
  shape: number,
  sideMax: number,
): [number, number] => {
  // For each height the nearest width is one of the two around it, and the smaller pair wins a tie
  let error = Infinity;
  let shown: [number, number] = [0, 0];
  for (let down = 1; down <= sideMax; down++) {
    const near = shape * down;
    for (const across of [Math.floor(near), Math.ceil(near)]) {
      const side = Math.min(sideMax, Math.max(1, across));
      const off = Math.abs(side / down - shape);
      if (off < error || (off === error && side + down < shown[0] + shown[1])) {
        error = off;
        shown = [side, down];
      }
    }
  }
  const common = divisorOf(shown[0], shown[1]);
  return [shown[0] / common, shown[1] / common];
};

const largestFittingSize = (
  width: number,
  height: number,
  x: number,
  y: number,
  exact: boolean,
): [number, number] => {
  const multiple = exact
    ? Math.floor(Math.sqrt(PICTURE_PIXELS_MAX / (x * y)))
    : 0;
  const scale = Math.sqrt(PICTURE_PIXELS_MAX / (width * height));
  const long = Math.max(width, height);
  const short = Math.min(width, height);
  const shortFit = Math.max(1, Math.floor(short * scale));
  const longFit = Math.min(
    Math.floor((shortFit * long) / short),
    Math.floor(PICTURE_PIXELS_MAX / shortFit),
  );
  let [fitWidth, fitHeight] =
    width >= height ? [longFit, shortFit] : [shortFit, longFit];
  if (multiple > 0) {
    [fitWidth, fitHeight] = [x * multiple, y * multiple];
  }
  return [fitWidth, fitHeight];
};

/**
 * Names the picture's shape in two-digit numbers and the largest size that fits the pixel cap.
 *
 * A shape whose reduced numbers are both 99 or less is shown exactly, and the size is the largest whole
 * multiple of them. Any other shape shows the nearest two-digit ratio, or N:1 past 99 to 1, marked
 * "about". Its size rounds the short side down and takes the longest long side no more extreme than the
 * picture, so the size follows the picture rather than the rounded ratio, and stays inside any shape
 * limit the picture itself meets.
 */
export const pictureSizeLimitText = (width: number, height: number) => {
  const divisor = divisorOf(width, height);
  const x = width / divisor;
  const y = height / divisor;
  const shape = width / height;
  let shown: [number, number] = [x, y];
  let exact = true;
  if (shape > RATIO_SIDE_MAX) {
    shown = [Math.round(shape), 1];
    exact = y === 1;
  } else if (shape < 1 / RATIO_SIDE_MAX) {
    shown = [1, Math.round(1 / shape)];
    exact = x === 1;
  } else if (x > RATIO_SIDE_MAX || y > RATIO_SIDE_MAX) {
    shown = nearestTwoDigitRatio(shape, RATIO_SIDE_MAX);
    exact = false;
  }
  const ratio = `${shown[0]}:${shown[1]}`;
  const named = `${exact ? '' : 'about '}${RATIO_NAMES[ratio] ?? ratio}`;
  const [fitWidth, fitHeight] = largestFittingSize(width, height, x, y, exact);
  return `The image size limit is ${PICTURE_PIXELS_MAX / 1_000_000} MP. At ${named}, the largest size you can use is ${fitWidth.toLocaleString('en-US')} × ${fitHeight.toLocaleString('en-US')} px.`;
};

export const PICTURE_RATIO_TALL_MAX = 8;
/** How tall gallery artwork may be, past PICTURE_RATIO_TALL_MAX shown in Scrolling only. OOC Extras stop at PICTURE_RATIO_TALL_MAX */
export const ARTWORK_RATIO_TALL_MAX = 20;
export const PICTURE_RATIO_WIDE_MAX = 12;

export const PICTURE_SHAPE_TEXT =
  "This picture's shape is too extreme to show.";

export const pictureShapeTooExtreme = (width: number, height: number) =>
  height > width * PICTURE_RATIO_TALL_MAX ||
  width > height * PICTURE_RATIO_WIDE_MAX;

/** pictureShapeTooExtreme for gallery artwork, which may be as tall as ARTWORK_RATIO_TALL_MAX */
export const artworkShapeTooExtreme = (width: number, height: number) =>
  height > width * ARTWORK_RATIO_TALL_MAX ||
  width > height * PICTURE_RATIO_WIDE_MAX;

/** Whether gallery artwork is shown but too tall for Card and Fitted, so it opens in Scrolling whatever was saved */
export const opensOnlyInScrolling = (width: number, height: number) =>
  height > width * PICTURE_RATIO_TALL_MAX &&
  !artworkShapeTooExtreme(width, height) &&
  fitsPixelCap(width, height);

export const artworkLimitText = (width: number, height: number) => {
  const shapeLimit = artworkShapeTooExtreme(width, height)
    ? `Artwork can be up to 1:${ARTWORK_RATIO_TALL_MAX} tall or ${PICTURE_RATIO_WIDE_MAX}:1 wide. Past 1:${PICTURE_RATIO_TALL_MAX} tall it opens in Scrolling only.`
    : null;
  if (!fitsPixelCap(width, height)) {
    const sizeLimit = pictureSizeLimitText(width, height);
    return shapeLimit ? `${sizeLimit} ${shapeLimit}` : sizeLimit;
  }
  return shapeLimit ? `${PICTURE_SHAPE_TEXT} ${shapeLimit}` : null;
};

/**
 * Reads a picture's size without adding it to the page, so callers can check the pixel cap before drawing it
 * Returns the probe for canvas drawing and reuse of the loaded image, plus a function that removes its
 * load and error handlers without cancelling the download
 */
export const readPictureSize = (
  url: string,
  onSize: (width: number, height: number) => void,
  onError: () => void,
) => {
  const probe = new Image();
  probe.onload = () => onSize(probe.naturalWidth, probe.naturalHeight);
  probe.onerror = onError;
  probe.src = resolveAsset(url);
  return {
    probe,
    stop: () => {
      probe.onload = null;
      probe.onerror = null;
    },
  };
};

const mediaChecked = new WeakSet<Element>();

// Each held picture keeps the image that read its size, so its own load takes it from the memory cache
const heldProbes = new WeakMap<Element, HTMLImageElement>();

const HELD_SOURCE = 'data-src';

/**
 * Takes the link out of every picture in markup from the server, so none starts loading or drawing when
 * the markup is inserted. The markup is parsed in a template, whose pictures never load, and guardPictures
 * gives each link back once its size is read.
 */
export const holdPictures = (html: string) => {
  const template = document.createElement('template');
  template.innerHTML = html;
  for (const image of Array.from(template.content.querySelectorAll('img'))) {
    const source = image.getAttribute('src');
    if (source) {
      image.setAttribute(HELD_SOURCE, source);
      image.removeAttribute('src');
    }
  }
  return template.innerHTML;
};

const replaceWithText = (media: Element, text: string) => {
  const message = document.createElement('div');
  message.textContent = text;
  message.style.color = 'var(--color-label, #a3968a)';
  message.style.textAlign = 'center';
  message.style.padding = '1em 0';
  media.replaceWith(message);
};

const guardVideo = (video: HTMLVideoElement) => {
  const check = () => {
    if (pictureShapeTooExtreme(video.videoWidth, video.videoHeight)) {
      replaceWithText(video, PICTURE_SHAPE_TEXT);
    }
  };
  if (video.readyState >= 1) {
    check();
  } else {
    video.addEventListener('loadedmetadata', check, { once: true });
  }
};

export const guardPictures = (container: HTMLElement) => {
  for (const media of Array.from(container.querySelectorAll('img, video'))) {
    if (mediaChecked.has(media)) {
      continue;
    }
    mediaChecked.add(media);
    if (media.tagName === 'VIDEO') {
      guardVideo(media as HTMLVideoElement);
      continue;
    }
    const source = media.getAttribute(HELD_SOURCE);
    if (!source) {
      continue;
    }
    const show = () => {
      media.setAttribute('src', source);
      media.removeAttribute(HELD_SOURCE);
    };
    const reading = readPictureSize(
      source,
      (width, height) => {
        if (!fitsPixelCap(width, height)) {
          const sizeLimit = pictureSizeLimitText(width, height);
          const shapeLimit = pictureShapeTooExtreme(width, height)
            ? ` OOC Extras allow up to 1:${PICTURE_RATIO_TALL_MAX} tall or ${PICTURE_RATIO_WIDE_MAX}:1 wide.`
            : '';
          replaceWithText(media, sizeLimit + shapeLimit);
        } else if (pictureShapeTooExtreme(width, height)) {
          replaceWithText(media, PICTURE_SHAPE_TEXT);
        } else {
          show();
        }
      },
      show,
    );
    heldProbes.set(media, reading.probe);
  }
};

export const usePictureSize = (
  url: string | null,
  onSize?: (width: number, height: number) => void,
  onError?: () => void,
  enforceArtworkLimits = false,
) => {
  const [read, setRead] = useState<{
    url: string;
    size: [number, number] | null;
  } | null>(null);
  const callbacks = useRef({ onSize, onError });
  callbacks.current = { onSize, onError };
  useEffect(() => {
    if (!url) {
      return;
    }
    const { stop } = readPictureSize(
      url,
      (width, height) => {
        setRead({ url, size: [width, height] });
        callbacks.current.onSize?.(width, height);
      },
      () => {
        setRead({ url, size: null });
        callbacks.current.onError?.();
      },
    );
    return stop;
  }, [url]);
  const size = read?.url === url ? read.size : null;
  const fits = !!size && fitsPixelCap(size[0], size[1]);
  const tooExtreme =
    !!size && enforceArtworkLimits && artworkShapeTooExtreme(...size);
  return {
    size,
    drawable: fits && !tooExtreme,
    tooLarge: !!size && !fits,
    tooExtreme,
    limitText: size && enforceArtworkLimits ? artworkLimitText(...size) : null,
    failed: !!url && read?.url === url && !read.size,
  };
};
