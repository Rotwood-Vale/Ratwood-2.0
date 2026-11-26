import { useLayoutEffect, useRef } from 'react';

import type { ReaderState } from './readingState';

const CLICK_SLOP = 5;

/**
 * A left press on the artwork that goes to the next picture when released within CLICK_SLOP of where it began.
 * A press is dropped when the picture or the reader's state changes under it
 */
export const useAdvanceClick = (
  onAdvance: (() => void) | undefined,
  sourceKey: string,
  readerState: ReaderState,
) => {
  const advancePress = useRef<{ id: number; x: number; y: number } | null>(
    null,
  );
  const clear = () => {
    advancePress.current = null;
  };
  useLayoutEffect(() => clear, [sourceKey, readerState]);
  return {
    clear,
    press: (event: React.PointerEvent<HTMLDivElement>) => {
      if (onAdvance && event.buttons === 1) {
        advancePress.current = {
          id: event.pointerId,
          x: event.clientX,
          y: event.clientY,
        };
      }
    },
    handleClick: (event: React.MouseEvent<HTMLDivElement>) => {
      const press = advancePress.current;
      advancePress.current = null;
      if (
        press &&
        event.button === 0 &&
        event.buttons === 0 &&
        Math.abs(event.clientX - press.x) <= CLICK_SLOP &&
        Math.abs(event.clientY - press.y) <= CLICK_SLOP
      ) {
        onAdvance?.();
      }
    },
    handleMouseDownCapture: (event: React.MouseEvent<HTMLDivElement>) => {
      if (event.buttons !== 1) advancePress.current = null;
    },
    handlePointerMove: (event: React.PointerEvent<HTMLDivElement>) => {
      const press = advancePress.current;
      if (
        press?.id === event.pointerId &&
        (event.buttons !== 1 ||
          Math.abs(event.clientX - press.x) > CLICK_SLOP ||
          Math.abs(event.clientY - press.y) > CLICK_SLOP)
      ) {
        advancePress.current = null;
      }
    },
    handlePointerLeave: clear,
    handlePointerCancel: (event: React.PointerEvent<HTMLDivElement>) => {
      if (advancePress.current?.id === event.pointerId) {
        advancePress.current = null;
      }
    },
  };
};
