import { useId, useState } from 'react';
import { Floating, Icon } from 'tgui-core/components';

import type { ArtViewSettings } from '../../common/artViewSettings';
import { MouseControlIcon } from '../../common/MouseControlIcon';

const FRAMING_HELP = {
  whole: 'Your card shows the part of the picture inside the box.',
  fitted:
    'Fitted fits your framing to the window. Reset the box to fit the whole picture.',
  scroll:
    'The box keeps the viewer’s proportions. Reset the box to open at the top of the picture.',
} satisfies Record<ArtViewSettings['opening_view'], string>;

export const FramingHelp = (props: {
  view: ArtViewSettings['opening_view'];
}) => {
  const [open, setOpen] = useState(false);
  const id = useId();

  return (
    <Floating
      placement="bottom-start"
      handleOpen={open}
      contentClasses="Tooltip CharacterGallery__framingTooltip"
      content={
        <div id={id} role="tooltip">
          <p>{FRAMING_HELP[props.view]}</p>
          <ul>
            <li>
              Use the left mouse button to drag the box. Drag an edge or corner
              to resize it.
            </li>
            {props.view !== 'scroll' && (
              <li>
                <MouseControlIcon control="left" label="Left mouse button" />{' '}
                Hold <kbd>Shift</kbd> while dragging a corner to keep the same
                aspect ratio.
              </li>
            )}
            <li>
              <MouseControlIcon control="wheel" label="Mouse wheel" /> Click the
              picture, then scroll to make the box smaller or larger.
            </li>
            <li>
              <MouseControlIcon control="wheel" label="Mouse wheel" /> Hold{' '}
              <kbd>Ctrl</kbd> and scroll over the picture to magnify the editor.
            </li>
            <li>
              <MouseControlIcon control="right" label="Right mouse button" />{' '}
              Hold the right mouse button and drag to pan.
            </li>
          </ul>
        </div>
      }
    >
      <button
        type="button"
        className="CharacterGallery__framingHelp"
        aria-label="Framing Help"
        aria-describedby={open ? id : undefined}
        onMouseEnter={() => setOpen(true)}
        onMouseLeave={() => setOpen(false)}
        onFocus={() => setOpen(true)}
        onBlur={() => setOpen(false)}
        onClick={() => setOpen(true)}
        onKeyDown={(event) => {
          if (open && event.key === 'Escape') {
            event.preventDefault();
            event.stopPropagation();
            setOpen(false);
          }
        }}
      >
        <Icon name="circle-question" />
      </button>
    </Floating>
  );
};
