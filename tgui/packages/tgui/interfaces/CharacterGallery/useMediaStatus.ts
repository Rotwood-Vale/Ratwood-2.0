import { useEffect, useState } from 'react';

import { fitsPixelCap } from '../common/pictureSize';
import { isVideoLink } from './shared';

export const useMediaStatus = (url: string | null) => {
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
  return {
    size,
    broken,
    retry,
    loading: !!url && !broken && !size,
    /** Whether size belongs to the current link, as framing arithmetic needs. */
    ready,
    /** Whether the current link is a picture over the pixel cap, so nothing draws it. Videos are not capped. */
    tooLarge:
      ready &&
      !!size &&
      !!url &&
      !isVideoLink(url) &&
      !fitsPixelCap(size[0], size[1]),
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
