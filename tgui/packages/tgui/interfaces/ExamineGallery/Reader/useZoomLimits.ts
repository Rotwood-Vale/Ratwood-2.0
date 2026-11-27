import { useLayoutEffect } from 'react';

import type { Area } from '../../common/cardLayout';
import { readerMeasured, type ReadingBox } from './readingGeometry';
import type { ReaderState } from './readingState';

/** The reader's zoom range, which the view controls offer */
export type ZoomLimits = { min: number; max: number };

/** Reports the zoom limits of the reader, or of the card while not reading, and pulls the reader's zoom inside them */
export const useZoomLimits = (props: {
  readerRef: React.RefObject<HTMLDivElement | null>;
  reading: boolean;
  selectedArrived: boolean;
  box: ReadingBox;
  boxAt: (area: Area, zoom: number) => ReadingBox;
  area: Area;
  readerArea: Area;
  readerState: ReaderState;
  onReaderChange: (state: ReaderState) => void;
  onZoomLimits: (limits: ZoomLimits) => void;
}) => {
  const {
    readerRef,
    reading,
    selectedArrived,
    box,
    boxAt,
    area,
    readerArea,
    readerState,
    onReaderChange,
    onZoomLimits,
  } = props;
  const effectiveZoomLimits = reading ? box : boxAt(area, 1);
  useLayoutEffect(() => {
    if (
      !selectedArrived ||
      (reading && !readerMeasured(readerRef.current, readerArea))
    ) {
      return;
    }
    onZoomLimits({
      min: effectiveZoomLimits.zoomMin,
      max: effectiveZoomLimits.zoomMax,
    });
    const clamped = Math.max(
      effectiveZoomLimits.zoomMin,
      Math.min(effectiveZoomLimits.zoomMax, readerState.zoom),
    );
    if (reading && readerState.zoom !== clamped) {
      onReaderChange({ ...readerState, zoom: clamped });
    }
  }, [
    effectiveZoomLimits.zoomMin,
    effectiveZoomLimits.zoomMax,
    reading,
    readerState.zoom,
    selectedArrived,
    readerArea.width,
    readerArea.height,
  ]);
};
