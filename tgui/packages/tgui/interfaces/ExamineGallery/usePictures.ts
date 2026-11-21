import { type SyntheticEvent, useEffect, useRef, useState } from 'react';

import { resolveAsset } from '../../assets';
import { fitsPixelCap, readPictureSize } from '../common/pictureSize';

const SELECTED_PICTURE_WAIT_MS = 8000;

export const usePictures = (images: string[], selected: number) => {
  const [aspects, setAspects] = useState<Record<string, number>>({});
  const [sizes, setSizes] = useState<Record<string, [number, number]>>({});
  const [failed, setFailed] = useState<Record<string, boolean>>({});
  const [othersAllowed, setOthersAllowed] = useState(false);
  const [slowUrl, setSlowUrl] = useState<string | null>(null);
  const probes = useRef(new Map<string, ReturnType<typeof readPictureSize>>());

  const tooLarge = (url: string) => {
    const size = sizes[url];
    return !!size && !fitsPixelCap(size[0], size[1]);
  };
  const mayLoad = (index: number) => othersAllowed || index === selected;

  const selectedUrl = images[selected];
  const selectedSettled =
    aspects[selectedUrl] !== undefined ||
    !!failed[selectedUrl] ||
    tooLarge(selectedUrl);
  useEffect(() => {
    if (selectedSettled) {
      setOthersAllowed(true);
      return;
    }
    // A host that never answers gives no error to wait for
    const timer = setTimeout(() => {
      setOthersAllowed(true);
      setSlowUrl(selectedUrl);
    }, SELECTED_PICTURE_WAIT_MS);
    return () => clearTimeout(timer);
  }, [selectedUrl, selectedSettled]);

  useEffect(() => {
    images.forEach((url, index) => {
      if (!mayLoad(index) || probes.current.has(url)) {
        return;
      }
      probes.current.set(
        url,
        readPictureSize(
          url,
          (width, height) =>
            setSizes((previous) => ({ ...previous, [url]: [width, height] })),
          () => setFailed((previous) => ({ ...previous, [url]: true })),
        ),
      );
    });
  }, [images, selected, othersAllowed]);
  useEffect(
    () => () => probes.current.forEach((reading) => reading.stop()),
    [],
  );

  return {
    aspectOf: (url: string): number | undefined => aspects[url],
    hasFailed: (url: string) => !!failed[url],
    isSlow: (url: string) => slowUrl === url,
    tooLarge,
    mayLoad,
    drawable: (url: string) => !!sizes[url] && !tooLarge(url),
    sourceOf: (url: string) => probes.current.get(url)?.probe,
    imageProps: (url: string) => ({
      src: resolveAsset(url),
      onLoad: ({ currentTarget }: SyntheticEvent<HTMLImageElement>) => {
        const aspect = currentTarget.naturalWidth / currentTarget.naturalHeight;
        setAspects((previous) =>
          previous[url] === aspect ? previous : { ...previous, [url]: aspect },
        );
        setFailed((previous) =>
          previous[url] ? { ...previous, [url]: false } : previous,
        );
      },
      onError: () => setFailed((previous) => ({ ...previous, [url]: true })),
    }),
  };
};

export type Pictures = ReturnType<typeof usePictures>;
