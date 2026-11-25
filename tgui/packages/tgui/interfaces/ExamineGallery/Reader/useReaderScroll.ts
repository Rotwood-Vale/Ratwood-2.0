import { useLayoutEffect, useRef } from 'react';

import type { Area } from '../../common/cardLayout';
import {
  focusScroll,
  imagePoint,
  readerMeasured,
  type ReadingBox,
  scrollToPoint,
} from './readingGeometry';
import type { ReaderState } from './readingState';

type PendingPoint = {
  key: string;
  point: { x: number; y: number };
  pointer: { x: number; y: number };
};

/** The middle of the reader's top edge, the point its scroll is remembered by */
const topMiddle = (area: Area) => ({ x: area.width / 2, y: 0 });

/** Remembers the reader's scroll in its state and restores it, with the framing copy, after each layout */
export const useReaderScroll = (props: {
  readerRef: React.RefObject<HTMLDivElement | null>;
  framingRef: React.RefObject<HTMLDivElement | null>;
  reading: boolean;
  selectedArrived: boolean;
  selectedAspect: number | undefined;
  readerArea: Area;
  box: ReadingBox;
  readerState: ReaderState;
  sourceKey: string;
  margin: number;
  onReaderPosition: (
    left: number,
    top: number,
    anchor: ReaderState['anchor'],
    framed: boolean,
  ) => void;
}) => {
  const {
    readerRef,
    framingRef,
    reading,
    selectedArrived,
    selectedAspect,
    readerArea,
    box,
    readerState,
    sourceKey,
    margin,
    onReaderPosition,
  } = props;
  const pendingPoint = useRef<PendingPoint | null>(null);
  const previousLayout = useRef<{
    box: ReadingBox;
    area: Area;
    state: ReaderState;
    key: string;
  } | null>(null);
  const rememberPosition = (left: number, top: number, keepFraming = true) => {
    if (!selectedArrived || !readerMeasured(readerRef.current, readerArea)) {
      return;
    }
    const point = imagePoint(box, { left, top }, topMiddle(readerArea));
    // Within a pixel, as the browser rounds the scroll it is given
    const framedAt = focusScroll(box, readerArea, readerState.view);
    const framed =
      keepFraming &&
      !!readerState.framed &&
      Math.abs(framedAt.left - left) <= 1 &&
      Math.abs(framedAt.top - top) <= 1;
    onReaderPosition(
      left,
      top,
      {
        ...point,
        viewportWidth: readerArea.width,
        viewportHeight: readerArea.height,
      },
      framed,
    );
  };

  useLayoutEffect(() => {
    const reader = readerRef.current;
    if (
      !reader ||
      !reading ||
      !selectedArrived ||
      !readerArea.width ||
      !readerArea.height
    ) {
      if (!reading) pendingPoint.current = null;
      previousLayout.current = null;
      return;
    }
    if (!readerMeasured(reader, readerArea)) {
      return;
    }
    const previous = previousLayout.current;
    let position = { left: readerState.left, top: readerState.top };
    if (pendingPoint.current && pendingPoint.current.key !== sourceKey) {
      pendingPoint.current = null;
    }
    if (pendingPoint.current) {
      position = scrollToPoint(
        box,
        readerArea,
        pendingPoint.current.point,
        pendingPoint.current.pointer,
      );
      pendingPoint.current = null;
    } else if (readerState.framed) {
      position = focusScroll(box, readerArea, readerState.view);
    } else if (
      previous &&
      previous.key === sourceKey &&
      previous.state === readerState &&
      (previous.area.width !== readerArea.width ||
        previous.area.height !== readerArea.height)
    ) {
      const point = imagePoint(
        previous.box,
        position,
        topMiddle(previous.area),
      );
      position = scrollToPoint(box, readerArea, point, topMiddle(readerArea));
    } else if (
      !previous &&
      readerState.anchor &&
      (readerState.anchor.viewportWidth !== readerArea.width ||
        readerState.anchor.viewportHeight !== readerArea.height)
    ) {
      position = scrollToPoint(
        box,
        readerArea,
        readerState.anchor,
        topMiddle(readerArea),
      );
    }
    reader.scrollLeft = position.left;
    reader.scrollTop = position.top;
    // The scroll the browser kept, so the framing draws the crop on the same pixels as the reader
    framingRef.current?.scrollTo(reader.scrollLeft, reader.scrollTop);
    rememberPosition(reader.scrollLeft, reader.scrollTop);
    previousLayout.current = {
      box,
      area: readerArea,
      state: readerState,
      key: sourceKey,
    };
  }, [
    reading,
    selectedAspect,
    sourceKey,
    readerState,
    readerArea.width,
    readerArea.height,
    margin,
  ]);

  return {
    rememberPosition,
    /** Keeps a point of the picture under the pointer at the next layout, as a zoom about the pointer needs */
    keepPointOnNextLayout: (pending: PendingPoint) => {
      pendingPoint.current = pending;
    },
  };
};
