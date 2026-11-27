import type { ReactNode, RefObject } from 'react';
import { classes } from 'tgui-core/react';

/**
 * The strip above a framing editor: how to start framing, and while the editor is active its controls. A press
 * on the strip focuses the editor
 */
export const FrameHint = (props: {
  active: boolean;
  editorRef: RefObject<HTMLDivElement | null>;
  idleText: string;
  /** The controls shown while active, each a CharacterGallery__frameShortcut */
  children: ReactNode;
}) => {
  const { active, editorRef, idleText, children } = props;
  return (
    <div
      className={classes([
        'CharacterGallery__frameHint',
        active && 'CharacterGallery__frameHint--active',
      ])}
      onMouseDown={(event) => {
        // Kept from taking focus itself, so a click here focuses the picture below
        event.preventDefault();
        editorRef.current?.focus();
      }}
    >
      {/* Both hints stay rendered in one grid cell with the aria-hidden one invisible, so the hint box keeps the height
      of the taller hint. Rendering only the current hint changes that height when framing starts and moves the portrait below */}
      <span className="CharacterGallery__frameHintText" aria-hidden={active}>
        {idleText}
      </span>
      <span
        className="CharacterGallery__frameHintText CharacterGallery__frameControls"
        aria-hidden={!active}
      >
        {children}
      </span>
    </div>
  );
};
