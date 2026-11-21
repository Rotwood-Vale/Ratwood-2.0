import { type RefObject, useEffect, useRef } from 'react';
import { clamp } from 'tgui-core/math';

import type { PictureBox } from './layout';

/** How far the picture leans at its edge, in degrees. TILT_MARGIN in MainPicture.tsx is sized for this lean. */
const TILT_DEGREES = 7;

/** A mouse move smaller than this share of the picture's width or height picks no new target. */
const TILT_DEAD_ZONE = 1 / 6;

const TILT_REST_MS = 100;

export const useTilt = (
  areaRef: RefObject<HTMLDivElement | null>,
  enabled: boolean,
  shownBox: RefObject<PictureBox>,
) => {
  const tiltRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const area = areaRef.current;
    const tilt = tiltRef.current;
    if (!enabled || !area || !tilt) {
      return;
    }
    let mouse: { x: number; y: number } | null = null;
    let restTimer: ReturnType<typeof setTimeout> | null = null;
    let exact = false;
    // In picture units, from -0.5 at the left or top edge to 0.5 at the right or bottom
    const target = { x: 0, y: 0 };
    // An unchanged target writes nothing, so the running transition is left alone
    let written = '';
    const span = TILT_DEGREES * 2;

    const aim = () => {
      const box = shownBox.current;
      if (!mouse || box.width <= 0 || box.height <= 0) {
        target.x = 0;
        target.y = 0;
        return;
      }
      const bounds = area.getBoundingClientRect();
      const x = clamp(
        (mouse.x - bounds.left - box.left) / box.width - 0.5,
        -0.5,
        0.5,
      );
      const y = clamp(
        (mouse.y - bounds.top - box.top) / box.height - 0.5,
        -0.5,
        0.5,
      );
      if (
        exact ||
        Math.abs(x - target.x) >= TILT_DEAD_ZONE ||
        Math.abs(y - target.y) >= TILT_DEAD_ZONE
      ) {
        target.x = x;
        target.y = y;
      }
    };

    const apply = () => {
      aim();
      const next = `rotateY(${target.x * span}deg) rotateX(${-target.y * span}deg)`;
      if (next !== written) {
        written = next;
        tilt.style.transform = next;
      }
    };

    const clearRest = () => {
      if (restTimer !== null) {
        clearTimeout(restTimer);
        restTimer = null;
      }
    };

    const onMove = (event: MouseEvent) => {
      mouse = { x: event.clientX, y: event.clientY };
      clearRest();
      // The dead zone can stop the lean short of where the mouse points,
      // so once the mouse rests one more aim goes there exactly
      restTimer = setTimeout(() => {
        restTimer = null;
        exact = true;
        apply();
        exact = false;
      }, TILT_REST_MS);
      apply();
    };

    const onLeave = () => {
      mouse = null;
      clearRest();
      apply();
    };

    area.addEventListener('mousemove', onMove);
    area.addEventListener('mouseleave', onLeave);
    return () => {
      area.removeEventListener('mousemove', onMove);
      area.removeEventListener('mouseleave', onLeave);
      clearRest();
      tilt.style.transform = '';
    };
  }, [enabled]);

  return tiltRef;
};
