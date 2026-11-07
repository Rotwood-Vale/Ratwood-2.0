import { type RefObject, useEffect } from 'react';

import type { FigureFace } from './figureFace';

export const useFigureBlink = (
  rootRef: RefObject<HTMLDivElement | null>,
  face: FigureFace,
  enabled: boolean,
) => {
  useEffect(() => {
    const root = rootRef.current;
    if (!enabled || !root) {
      return;
    }
    root.addEventListener('mousemove', face.onMouseMove);
    return () => root.removeEventListener('mousemove', face.onMouseMove);
  }, [enabled]);
};
