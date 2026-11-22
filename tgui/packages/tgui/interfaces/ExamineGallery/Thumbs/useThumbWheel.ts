import { useRef, type WheelEvent } from 'react';

import type { PictureChange } from '../pictureChange';

const SCROLL_STEP_MS = 75;

/** The gallery's wheel handler, which changes picture on a wheel turn over a thumbnail */
export const useThumbWheel = (
  step: (direction: -1 | 1, change: PictureChange) => void,
) => {
  const lastScroll = useRef(0);
  const onWheel = (event: WheelEvent<HTMLDivElement>) => {
    if (
      event.ctrlKey ||
      !(event.target as Element).closest(
        '.ExamineGallery__thumb, .ExamineGallery__plainThumb',
      )
    ) {
      return;
    }
    const now = performance.now();
    if (!event.deltaY || now - lastScroll.current < SCROLL_STEP_MS) {
      return;
    }
    lastScroll.current = now;
    step(event.deltaY > 0 ? 1 : -1, 'fade');
  };
  return onWheel;
};
