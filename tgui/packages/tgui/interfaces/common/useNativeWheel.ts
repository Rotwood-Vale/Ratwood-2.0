import { type RefObject, useEffect, useRef } from 'react';

/**
 * Sends each wheel turn over the element to the newest handler, which may call preventDefault. React's wheel
 * listener cannot stop the window or dialog scrolling or zooming, so a native one is used
 */
export const useNativeWheel = (
  ref: RefObject<HTMLElement | null>,
  handler: (event: WheelEvent) => void,
) => {
  const newestHandler = useRef(handler);
  newestHandler.current = handler;
  useEffect(() => {
    const element = ref.current;
    if (!element) {
      return;
    }
    const listener = (event: WheelEvent) => newestHandler.current(event);
    element.addEventListener('wheel', listener, { passive: false });
    return () => element.removeEventListener('wheel', listener);
  }, []);
};
