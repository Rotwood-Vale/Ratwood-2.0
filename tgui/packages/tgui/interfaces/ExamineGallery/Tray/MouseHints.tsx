import type { ReactNode } from 'react';

import { MouseControlIcon } from '../../common/MouseControlIcon';

const MOUSE_CONTROLS = {
  next: ['left', 'Left-click the artwork for the next image'],
  pan: ['right', 'Hold the right mouse button and drag to pan oversized art'],
  scroll: ['wheel', 'Scroll the mouse wheel to move up or down'],
  zoom: ['wheel', 'Hold Ctrl and scroll the mouse wheel to zoom'],
  thumbnails: ['wheel', 'Scroll over a thumbnail to change images'],
} as const;

export const GalleryMouseIcon = (props: {
  action: keyof typeof MOUSE_CONTROLS;
}) => {
  const [control, label] = MOUSE_CONTROLS[props.action];
  return (
    <MouseControlIcon
      className="ExamineGallery__mouseIcon"
      control={control}
      label={label}
    />
  );
};

type MouseHint = {
  shown: boolean;
  icon: ReactNode;
  label: string;
};

/** Two mouse hints under the artwork, with a separator when both show */
export const HintGroup = (props: {
  className: string;
  first: MouseHint;
  second: MouseHint;
}) => {
  const { first, second } = props;
  return (
    <div className={props.className}>
      {first.shown && (
        <span className="ExamineGallery__mouseAction">
          {first.icon}
          <span className="ExamineGallery__hintLabel">{first.label}</span>
        </span>
      )}
      {first.shown && second.shown && (
        <span className="ExamineGallery__hintSeparator" aria-hidden>
          |
        </span>
      )}
      {second.shown && (
        <span className="ExamineGallery__mouseAction">
          {second.icon}
          <span className="ExamineGallery__hintLabel">{second.label}</span>
        </span>
      )}
    </div>
  );
};
