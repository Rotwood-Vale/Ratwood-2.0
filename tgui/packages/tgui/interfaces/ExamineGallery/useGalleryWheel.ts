import type { RefObject } from 'react';

import { useNativeWheel } from '../common/useNativeWheel';
import type { PictureControls } from './Reader/MainPicture';

/** The zoom factor of one Ctrl and wheel step in, whose reciprocal a step out takes */
const ZOOM_WHEEL_STEP = 1.1;

/** Ctrl and the wheel zoom the main picture and never the window, and a plain wheel turn reaches the picture before the reader scrolls */
export const useGalleryWheel = (
  rootRef: RefObject<HTMLDivElement | null>,
  controlsRef: RefObject<PictureControls | null>,
) => {
  useNativeWheel(rootRef, (event) => {
    if (!event.ctrlKey) {
      // Here and not in React, as a scroll waits only for a listener that is not passive
      controlsRef.current?.wheel(event);
      return;
    }
    event.preventDefault();
    if (
      !event.deltaY ||
      !(event.target as Element).closest('.ExamineGallery__main')
    ) {
      return;
    }
    controlsRef.current?.zoom(
      event.deltaY < 0 ? ZOOM_WHEEL_STEP : 1 / ZOOM_WHEEL_STEP,
      event.clientX,
      event.clientY,
    );
  });
};
