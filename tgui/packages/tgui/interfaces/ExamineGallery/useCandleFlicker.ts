import { type RefObject, useEffect, useRef } from 'react';

const CANDLE_HOLD_MS = 400;
const CANDLE_SETTLE_MS = 2500;

const STIRRING = 'ExamineGallery__glow--stirring';

/**
 * Flickers the candle glow while the mouse moves anywhere over the gallery. A short rest pauses the flicker
 * where it is and the next move plays on from there, so a hand that moves in bursts never restarts it. A long
 * rest or leaving eases it back to steady, and a move during that ease waits for it to finish, as the
 * flicker starts from full brightness. The stylesheet's animation plays the flicker, so the script only
 * writes a class and a play state and nothing per frame.
 */
export const useCandleFlicker = (
  rootRef: RefObject<HTMLDivElement | null>,
  enabled: boolean,
) => {
  const glowRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const root = rootRef.current;
    const glow = glowRef.current;
    if (!enabled || !root || !glow) {
      return;
    }
    let holdTimer: ReturnType<typeof setTimeout> | null = null;
    let settleTimer: ReturnType<typeof setTimeout> | null = null;
    let settleFrame: number | null = null;
    let flickering = false;
    let held = false;
    let settling = false;

    const clearTimers = () => {
      if (holdTimer !== null) {
        clearTimeout(holdTimer);
        holdTimer = null;
      }
      if (settleTimer !== null) {
        clearTimeout(settleTimer);
        settleTimer = null;
      }
    };

    const finishSettle = () => {
      if (settleFrame !== null) {
        cancelAnimationFrame(settleFrame);
        settleFrame = null;
      }
      settling = false;
      glow.style.opacity = '';
      glow.style.transition = '';
    };

    const settle = () => {
      clearTimers();
      if (!flickering) {
        return;
      }
      const level = window.getComputedStyle(glow).opacity;
      glow.classList.remove(STIRRING);
      glow.style.animationPlayState = '';
      flickering = false;
      held = false;
      if (Number(level) >= 1) {
        return;
      }
      settling = true;
      glow.style.opacity = level;
      glow.style.transition = 'opacity 0.8s ease-in-out';
      // The style read makes the browser take the held level before the next frame clears it
      void window.getComputedStyle(glow).opacity;
      settleFrame = requestAnimationFrame(() => {
        settleFrame = null;
        glow.style.opacity = '';
      });
    };

    const hold = () => {
      holdTimer = null;
      held = true;
      glow.style.animationPlayState = 'paused';
      settleTimer = setTimeout(settle, CANDLE_SETTLE_MS - CANDLE_HOLD_MS);
    };

    const stir = () => {
      if (settling || document.hidden) {
        return;
      }
      clearTimers();
      holdTimer = setTimeout(hold, CANDLE_HOLD_MS);
      if (held) {
        held = false;
        glow.style.animationPlayState = '';
        return;
      }
      if (!flickering) {
        flickering = true;
        glow.classList.add(STIRRING);
      }
    };

    // A cancelled ease ends the settle too, or a move would wait on it forever
    const onTransitionDone = (event: TransitionEvent) => {
      if (
        event.propertyName !== 'opacity' ||
        !settling ||
        settleFrame !== null
      ) {
        return;
      }
      finishSettle();
    };

    const onVisibilityChange = () => {
      if (document.hidden) {
        settle();
      }
    };

    root.addEventListener('mousemove', stir);
    root.addEventListener('mouseleave', settle);
    glow.addEventListener('transitionend', onTransitionDone);
    glow.addEventListener('transitioncancel', onTransitionDone);
    document.addEventListener('visibilitychange', onVisibilityChange);
    return () => {
      root.removeEventListener('mousemove', stir);
      root.removeEventListener('mouseleave', settle);
      glow.removeEventListener('transitionend', onTransitionDone);
      glow.removeEventListener('transitioncancel', onTransitionDone);
      document.removeEventListener('visibilitychange', onVisibilityChange);
      clearTimers();
      finishSettle();
      glow.classList.remove(STIRRING);
      glow.style.animationPlayState = '';
    };
  }, [enabled]);

  return glowRef;
};
