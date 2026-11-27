import { useLayoutEffect, useRef } from 'react';

import type { ReaderState } from './readingState';

const FITTED_DRAG_LIMIT = 10;
const FITTED_DRAG_SCALE = 0.2;
const SETTLING_PICTURE = 'ExamineGallery__readingPicture--settling';

const fittedDragOffset = (distance: number) =>
  Math.max(
    -FITTED_DRAG_LIMIT,
    Math.min(FITTED_DRAG_LIMIT, distance * FITTED_DRAG_SCALE),
  );

/** The reader's right-drag pan, or the Fitted nudge when there is nothing to scroll */
export const useReaderDrag = (props: {
  readerRef: React.RefObject<HTMLDivElement | null>;
  readingPictureRef: React.RefObject<HTMLDivElement | null>;
  readerState: ReaderState;
  sourceKey: string;
  leaveOpening: () => void;
  rememberPosition: (left: number, top: number) => void;
}) => {
  const {
    readerRef,
    readingPictureRef,
    readerState,
    sourceKey,
    leaveOpening,
    rememberPosition,
  } = props;
  const drag = useRef<{
    id: number;
    x: number;
    y: number;
    left: number;
    top: number;
    scale: number;
    fittedWiggle: boolean;
  } | null>(null);
  const endDrag = (reader: HTMLDivElement, id: number) => {
    const start = drag.current;
    if (start?.id !== id) return;
    drag.current = null;
    const picture = readingPictureRef.current;
    if (start.fittedWiggle && picture) {
      picture.classList.add(SETTLING_PICTURE);
      picture.style.removeProperty('transform');
    }
    if (reader.hasPointerCapture(id)) reader.releasePointerCapture(id);
  };

  useLayoutEffect(() => {
    const reader = readerRef.current;
    return () => {
      if (reader && drag.current) endDrag(reader, drag.current.id);
      readingPictureRef.current?.classList.remove(SETTLING_PICTURE);
    };
  }, [sourceKey, readerState]);

  return {
    start: (
      event: React.PointerEvent<HTMLDivElement>,
      reader: HTMLDivElement | null,
      scale: number,
    ) => {
      if (
        !reader ||
        (event.button !== 2 && event.pointerType !== 'touch') ||
        drag.current
      ) {
        return;
      }
      const canScroll =
        reader.scrollWidth > reader.clientWidth ||
        reader.scrollHeight > reader.clientHeight;
      const picture = readingPictureRef.current;
      const fittedWiggle =
        !canScroll && readerState.view === 'fitted' && !!picture;
      if (!canScroll && !fittedWiggle) return;
      if (fittedWiggle) picture.classList.remove(SETTLING_PICTURE);
      drag.current = {
        id: event.pointerId,
        x: event.clientX,
        y: event.clientY,
        left: reader.scrollLeft,
        top: reader.scrollTop,
        scale,
        fittedWiggle,
      };
      reader.setPointerCapture(event.pointerId);
      event.preventDefault();
    },
    handlePointerMove: (event: React.PointerEvent<HTMLDivElement>) => {
      const start = drag.current;
      if (!start || start.id !== event.pointerId) return;
      if (event.pointerType !== 'touch' && !(event.buttons & 2)) {
        endDrag(event.currentTarget, event.pointerId);
        return;
      }
      const x = (event.clientX - start.x) / start.scale;
      const y = (event.clientY - start.y) / start.scale;
      if (start.fittedWiggle) {
        const picture = readingPictureRef.current;
        if (picture) {
          picture.style.transform = `translate(${fittedDragOffset(x)}px, ${fittedDragOffset(y)}px)`;
        }
        return;
      }
      leaveOpening();
      event.currentTarget.scrollLeft = start.left - x;
      event.currentTarget.scrollTop = start.top - y;
      rememberPosition(
        event.currentTarget.scrollLeft,
        event.currentTarget.scrollTop,
      );
    },
    /** A release, a cancel or a lost capture of the dragging pointer */
    handlePointerEnd: (event: React.PointerEvent<HTMLDivElement>) =>
      endDrag(event.currentTarget, event.pointerId),
  };
};
