import { type RefObject, useEffect, useRef, useState } from 'react';

import type { ControlsPanel } from './TrayControls';

const HIDE_DELAY_MS = 180;

/** Reveals the tray while the pointer is over its toggle or the tray, or keyboard focus is inside them */
export const useTrayReveal = (
  triggerRef: RefObject<HTMLButtonElement | null>,
  trayRef: RefObject<HTMLDivElement | null>,
  onPanel: (panel: ControlsPanel) => void,
) => {
  const [revealed, setRevealed] = useState(false);
  const pointerInside = useRef(false);
  const pointerFocused = useRef(false);
  const hideTimer = useRef<ReturnType<typeof setTimeout>>(undefined);
  const focusInControls = (target: EventTarget | null) =>
    target === triggerRef.current ||
    (target instanceof Node && trayRef.current?.contains(target));
  const keyboardFocusInControls = (target: EventTarget | null) =>
    !pointerFocused.current &&
    target instanceof HTMLElement &&
    target.matches(':focus-visible') &&
    focusInControls(target);
  const show = () => {
    clearTimeout(hideTimer.current);
    setRevealed(true);
  };
  const hideSoon = () => {
    clearTimeout(hideTimer.current);
    hideTimer.current = setTimeout(() => {
      if (
        !pointerInside.current &&
        !keyboardFocusInControls(document.activeElement)
      ) {
        setRevealed(false);
      }
    }, HIDE_DELAY_MS);
  };
  const hoverControls = {
    onPointerEnter: (event: React.PointerEvent) => {
      if (event.pointerType === 'touch') return;
      pointerInside.current = true;
      show();
    },
    onPointerLeave: (event: React.PointerEvent) => {
      if (event.pointerType === 'touch') return;
      pointerInside.current = false;
      hideSoon();
    },
  };

  useEffect(() => () => clearTimeout(hideTimer.current), []);

  const rootHandlers = {
    onPointerDownCapture: (event: React.PointerEvent<HTMLDivElement>) => {
      if (focusInControls(event.target)) pointerFocused.current = true;
    },
    onKeyDownCapture: (event: React.KeyboardEvent<HTMLDivElement>) => {
      if (!focusInControls(event.target)) return;
      pointerFocused.current = false;
      show();
    },
    onFocus: (event: React.FocusEvent<HTMLDivElement>) => {
      if (keyboardFocusInControls(event.target)) show();
    },
    onBlur: (event: React.FocusEvent<HTMLDivElement>) => {
      if (
        !focusInControls(event.target) ||
        focusInControls(event.relatedTarget)
      ) {
        return;
      }
      pointerFocused.current = false;
      if (event.relatedTarget) onPanel(null);
      hideSoon();
    },
  };

  return { revealed, show, hoverControls, rootHandlers, focusInControls };
};
