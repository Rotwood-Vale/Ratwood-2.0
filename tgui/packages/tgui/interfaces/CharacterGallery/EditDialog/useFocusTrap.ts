import type { KeyboardEvent, RefObject } from 'react';

/** Keeps Tab and Shift+Tab cycling through the dialog's controls */
export const useFocusTrap =
  (dialogRef: RefObject<HTMLDivElement | null>) =>
  (event: KeyboardEvent<HTMLDivElement>) => {
    if (event.key !== 'Tab') {
      return;
    }
    const focusable = [
      ...(dialogRef.current?.querySelectorAll<HTMLElement>(
        'input:not(:disabled), select:not(:disabled), button:not(:disabled), [tabindex="0"]:not([disabled]), summary, details[open] a[href]',
      ) ?? []),
    ].filter(
      (element) =>
        element.getClientRects().length && !element.closest('[inert]'),
    );
    const first = focusable[0];
    const last = focusable[focusable.length - 1];
    if (event.shiftKey && document.activeElement === first) {
      event.preventDefault();
      last?.focus();
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault();
      first?.focus();
    }
  };
