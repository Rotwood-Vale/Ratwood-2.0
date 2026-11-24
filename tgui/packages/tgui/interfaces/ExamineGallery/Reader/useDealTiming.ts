import { useEffect, useRef, useState } from 'react';

import type { PictureMove } from '../pictureChange';

const DEAL_LANDING_MS = 540;

/** Whether the main picture is still being dealt, the move whose deal has landed, and the shown card's deal delay */
export const useDealTiming = (
  move: PictureMove,
  openingDelay: number,
  selectedArrived: boolean,
  isDeal: boolean,
) => {
  const [dealing, setDealing] = useState(false);
  // Once the deal lands the thrown picture loses its class so a redraw never throws it again. The shown picture keeps
  // its own, as dropping it redraws it up to a device pixel apart, and Plain Gallery ends the move before it can replay
  const [landed, setLanded] = useState<PictureMove | null>(null);

  const openedAt = useRef(performance.now());
  const openingWait = useRef<number | null>(null);
  if (move.from === null && selectedArrived && openingWait.current === null) {
    openingWait.current = Math.max(
      0,
      openingDelay - (performance.now() - openedAt.current),
    );
  }
  const dealWait = move.from === null ? (openingWait.current ?? 0) : 0;

  useEffect(() => {
    // A step that cuts a deal short, or a deal onto a picture still loading, clears the timer that
    // would have ended it, and the area would stay over the wheel
    if (!isDeal || !selectedArrived) {
      setDealing(false);
      return;
    }
    setDealing(true);
    const timer = setTimeout(() => {
      setDealing(false);
      setLanded(move);
    }, dealWait + DEAL_LANDING_MS);
    return () => clearTimeout(timer);
  }, [move, selectedArrived, isDeal]);

  return { dealing, landed, dealWait };
};
