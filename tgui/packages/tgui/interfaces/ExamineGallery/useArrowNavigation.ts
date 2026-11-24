import { type RefObject, useEffect } from 'react';

import type { PictureChange } from './pictureChange';

const ARROW_NAVIGATION_BUTTONS =
  '.ExamineGallery__thumb, .ExamineGallery__plainThumb, .ExamineGallery__seal, .ExamineGallery__page, .ExamineGallery__viewToggle, .ExamineGallery__trayToggle';

export const useArrowNavigation = ({
  count,
  selected,
  clickChange,
  reading,
  menuOpen,
  galleryTabRef,
  rootRef,
  step,
}: {
  count: number;
  selected: number;
  clickChange: PictureChange;
  reading: boolean;
  menuOpen: boolean;
  galleryTabRef: RefObject<HTMLDivElement | null>;
  rootRef: RefObject<HTMLDivElement | null>;
  step: (direction: -1 | 1, change: PictureChange) => void;
}) => {
  useEffect(() => {
    if (count < 2) {
      return;
    }
    const onKeyDown = (event: KeyboardEvent) => {
      const { target } = event;
      if (
        event.defaultPrevented ||
        reading ||
        menuOpen ||
        !(target instanceof HTMLElement) ||
        target.isContentEditable ||
        target.closest('input, textarea, select, dialog, [role="dialog"]')
      ) {
        return;
      }
      if (!galleryTabRef.current?.contains(target)) {
        const button = target.closest('button, .Button');
        if (
          !rootRef.current?.contains(target) ||
          (button && !button.matches(ARROW_NAVIGATION_BUTTONS))
        ) {
          return;
        }
      }
      if (event.key === 'ArrowLeft') {
        event.preventDefault();
        step(-1, clickChange);
      } else if (event.key === 'ArrowRight') {
        event.preventDefault();
        step(1, clickChange);
      }
    };
    window.addEventListener('keydown', onKeyDown);
    return () => window.removeEventListener('keydown', onKeyDown);
  }, [count, selected, clickChange, reading, menuOpen, galleryTabRef]);
};
