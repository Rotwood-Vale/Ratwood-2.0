import { useEffect, useLayoutEffect, useState } from 'react';

/** The element's size in fractional pixels from its ResizeObserver content box, measured after paint */
export const useElementSize = (ref: React.RefObject<HTMLElement | null>) => {
  const [size, setSize] = useState({ width: 0, height: 0 });

  useEffect(() => {
    const element = ref.current;
    if (!element) {
      return;
    }
    setSize({ width: element.clientWidth, height: element.clientHeight });
    const observer = new ResizeObserver(([entry]) =>
      setSize({
        width: entry.contentRect.width,
        height: entry.contentRect.height,
      }),
    );
    observer.observe(element);
    return () => observer.disconnect();
  }, []);

  return size;
};

/** The element's client size in whole pixels, measured before paint while enabled and kept as the same object while unchanged */
export const useClientSize = (
  ref: React.RefObject<HTMLElement | null>,
  enabled: boolean,
) => {
  const [size, setSize] = useState({ width: 0, height: 0 });

  useLayoutEffect(() => {
    const element = ref.current;
    if (!element || !enabled) return;
    const measure = () =>
      setSize((last) => {
        const next = {
          width: element.clientWidth,
          height: element.clientHeight,
        };
        return last.width === next.width && last.height === next.height
          ? last
          : next;
      });
    measure();
    const observer = new ResizeObserver(measure);
    observer.observe(element);
    return () => observer.disconnect();
  }, [enabled]);

  return size;
};
