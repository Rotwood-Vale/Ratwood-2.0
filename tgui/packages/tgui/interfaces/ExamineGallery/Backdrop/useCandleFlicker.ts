import { type RefObject, useEffect, useRef } from 'react';

// The rise and the die-down take $candle-rise and $candle-die-down in ExamineGallery.scss
const CANDLE_QUIET_MS = 1000;

const UP = 'ExamineGallery__glow--up';
const DYING = 'ExamineGallery__glow--dying';

/**
 * Brings the candle light up while the mouse moves anywhere over the gallery.
 *
 * The first move raises it once and it stays up, steady, through further moves and short pauses. CANDLE_QUIET_MS
 * after the last move, or at once when the mouse leaves, it dies down once to rest. The stylesheet transitions
 * the opacity of a warm layer on the glow, so a move during the die-down rises from where the light is, and the
 * script only swaps two classes and keeps one timer, nothing per frame. A hidden window, the setting turned off
 * or reading puts it straight back to rest.
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
    let quietTimer: ReturnType<typeof setTimeout> | null = null;
    let up = false;

    const clearQuietTimer = () => {
      if (quietTimer !== null) {
        clearTimeout(quietTimer);
        quietTimer = null;
      }
    };

    const dieDown = () => {
      clearQuietTimer();
      if (!up) {
        return;
      }
      up = false;
      glow.classList.remove(UP);
      glow.classList.add(DYING);
    };

    // Without either class the layer has no transition, so it drops to rest at once
    const restNow = () => {
      clearQuietTimer();
      up = false;
      glow.classList.remove(UP, DYING);
    };

    const stir = () => {
      if (document.hidden) {
        return;
      }
      clearQuietTimer();
      quietTimer = setTimeout(dieDown, CANDLE_QUIET_MS);
      if (up) {
        return;
      }
      up = true;
      glow.classList.remove(DYING);
      glow.classList.add(UP);
    };

    const onVisibilityChange = () => {
      if (document.hidden) {
        restNow();
      }
    };

    root.addEventListener('mousemove', stir);
    root.addEventListener('mouseleave', dieDown);
    document.addEventListener('visibilitychange', onVisibilityChange);
    return () => {
      root.removeEventListener('mousemove', stir);
      root.removeEventListener('mouseleave', dieDown);
      document.removeEventListener('visibilitychange', onVisibilityChange);
      restNow();
    };
  }, [enabled]);

  return glowRef;
};
