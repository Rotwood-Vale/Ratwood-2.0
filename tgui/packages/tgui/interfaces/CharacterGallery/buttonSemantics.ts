import type { HTMLAttributes } from 'react';

// tgui-core forwards DOM attributes that its prop types do not declare
/** Marks a tgui-core element that acts as a button, for one already in the Tab order */
export const buttonRole = {
  role: 'button',
} satisfies HTMLAttributes<HTMLDivElement>;
/** Marks a tgui-core element that acts as a button and puts it in the Tab order */
export const buttonSemantics = {
  ...buttonRole,
  tabIndex: 0,
} satisfies HTMLAttributes<HTMLDivElement>;
