import { useEffect, useRef, useState } from 'react';

import { resolveAsset } from '../../assets';

/** The most pixels a picture may have and still be drawn, as decoding a bigger one can take gigabytes. */
export const PICTURE_PIXELS_MAX = 20_000_000;

export const PICTURE_TOO_LARGE_TEXT = 'This picture is too large to show.';

export const fitsPixelCap = (width: number, height: number) =>
  width * height <= PICTURE_PIXELS_MAX;

export const PICTURE_RATIO_TALL_MAX = 8;
export const PICTURE_RATIO_WIDE_MAX = 12;

export const PICTURE_SHAPE_TEXT =
  "This picture's shape is too extreme to show.";

export const pictureShapeTooExtreme = (width: number, height: number) =>
  height > width * PICTURE_RATIO_TALL_MAX ||
  width > height * PICTURE_RATIO_WIDE_MAX;

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
          replaceWithText(media, PICTURE_TOO_LARGE_TEXT);
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
  return {
    size,
    drawable: fits,
    tooLarge: !!size && !fits,
  };
};
