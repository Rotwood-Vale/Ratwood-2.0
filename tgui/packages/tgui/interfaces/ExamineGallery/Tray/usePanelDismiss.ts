import { type RefObject, useEffect } from 'react';

import type { ControlsPanel } from './TrayControls';

/** Closes the open view menu or help on a press outside the controls, or on Escape, which focuses its toggle again */
export const usePanelDismiss = (
  panel: ControlsPanel,
  onPanel: (panel: ControlsPanel) => void,
  refs: {
    viewRef: RefObject<HTMLButtonElement | null>;
    helpRef: RefObject<HTMLButtonElement | null>;
  },
  focusInControls: (target: EventTarget | null) => boolean | undefined,
) => {
  const { viewRef, helpRef } = refs;
  useEffect(() => {
    if (!panel) return;
    const dismissOutside = (event: PointerEvent) => {
      if (!focusInControls(event.target)) onPanel(null);
    };
    const dismissOnEscape = (event: KeyboardEvent) => {
      if (event.key !== 'Escape') {
        return;
      }
      event.preventDefault();
      event.stopPropagation();
      onPanel(null);
      (panel === 'view' ? viewRef : helpRef).current?.focus({
        preventScroll: true,
      });
    };
    document.addEventListener('pointerdown', dismissOutside);
    document.addEventListener('keydown', dismissOnEscape, true);
    return () => {
      document.removeEventListener('pointerdown', dismissOutside);
      document.removeEventListener('keydown', dismissOnEscape, true);
    };
  }, [panel, onPanel]);
};
