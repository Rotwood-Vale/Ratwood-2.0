import type { KeyboardEvent } from 'react';
import { releaseHeldKeys } from 'tgui-core/hotkeys';

const stopGameKeys = (event: KeyboardEvent<HTMLElement>) => {
  if (event.key !== 'Tab' && event.key !== 'Escape') {
    event.stopPropagation();
  }
};

export const gallerySelectEvents = {
  onFocus: releaseHeldKeys,
  onKeyDown: stopGameKeys,
  onKeyUp: stopGameKeys,
};
