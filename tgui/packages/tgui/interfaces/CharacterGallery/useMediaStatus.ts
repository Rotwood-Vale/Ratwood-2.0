import { useEffect, useState } from 'react';

import {
  artworkLimitText,
  fitsPixelCap,
  pictureSizeLimitText,
} from '../common/pictureSize';

/** Whether a link ends in an mp4 extension, as the server's is_video_link decides */
export const isVideoLink = (url: string) =>
  url.split('.').pop()?.toLowerCase() === 'mp4';

export const useMediaStatus = (url: string | null, artworkLimits = false) => {
  const [loaded, setLoaded] = useState<{
    url: string | null;
    size: [number, number];
  } | null>(null);
  const [broken, setBroken] = useState(false);
  const [retry, setRetry] = useState(0);
  useEffect(() => {
    if (!url) {
      setLoaded(null);
    }
    setBroken(false);
    setRetry(0);
  }, [url]);
  const size = loaded?.size ?? null;
  const ready = loaded?.url === url && !!size;
  const tooLarge =
    ready && !!size && !!url && !isVideoLink(url) && !fitsPixelCap(...size);
  return {
    size,
    broken,
    retry,
    loading: !!url && !broken && !size,
    /** Whether size belongs to the current link, as framing arithmetic needs. */
    ready,
    /** Whether the current link is a picture over the pixel cap, so nothing draws it. Videos are not capped. */
    tooLarge,
    limitText:
      ready && size && artworkLimits
        ? artworkLimitText(...size)
        : tooLarge && size
          ? pictureSizeLimitText(...size)
          : null,
    handleLoad: (width: number, height: number) => {
      setLoaded({ url, size: [width, height] });
      setBroken(false);
    },
    handleError: () => {
      setLoaded(null);
      setBroken(true);
    },
    handleRetry: () => {
      setBroken(false);
      setLoaded(null);
      setRetry(retry + 1);
    },
  };
};
