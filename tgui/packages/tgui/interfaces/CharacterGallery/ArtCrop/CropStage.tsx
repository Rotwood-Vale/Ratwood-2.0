import type { DOMAttributes, KeyboardEvent, RefObject } from 'react';
import { classes } from 'tgui-core/react';

import type { ArtCrop } from '../../common/artViewSettings';
import type { usePictureSize } from '../../common/pictureSize';
import { gallerySelectEvents } from '../nativeSelect';
import { EDGES, HANDLES, type Layout } from './cropGeometry';
import { pictureStatus } from './cropText';

type StagePointer = Pick<
  DOMAttributes<HTMLDivElement>,
  'onPointerDown' | 'onPointerMove' | 'onPointerUp' | 'onLostPointerCapture'
>;

/** The picture with the framing box over it, or the picture's status while it cannot be drawn */
export const CropStage = (props: {
  stageRef: RefObject<HTMLDivElement | null>;
  label: string;
  active: boolean;
  setActive: (active: boolean) => void;
  onKeyDown: (event: KeyboardEvent<HTMLDivElement>) => void;
  pointer: StagePointer;
  url: string;
  picture: ReturnType<typeof usePictureSize>;
  size: [number, number] | null;
  layout: Layout | null;
  box: ArtCrop;
}) => {
  const {
    stageRef,
    label,
    active,
    setActive,
    onKeyDown,
    pointer,
    url,
    picture,
    size,
    layout,
    box,
  } = props;

  const boxRect = layout && {
    left: layout.left + box.x * layout.width,
    top: layout.top + box.y * layout.height,
    width: box.w * layout.width,
    height: box.h * layout.height,
  };

  return (
    <div
      ref={stageRef}
      tabIndex={0}
      aria-label={`${label} Framing Box`}
      className={classes([
        'CharacterGallery__cropStage',
        active && 'CharacterGallery__cropStage--active',
      ])}
      onFocus={() => {
        gallerySelectEvents.onFocus();
        setActive(true);
      }}
      onBlur={() => setActive(false)}
      onKeyDown={onKeyDown}
      onKeyUp={(event) => gallerySelectEvents.onKeyUp(event)}
      onContextMenu={(event) => {
        if (size) event.preventDefault();
      }}
      {...pointer}
    >
      {layout && boxRect ? (
        <>
          <img
            className="CharacterGallery__cropPicture CharacterGallery__cropPicture--outside"
            src={url}
            alt=""
            draggable={false}
            style={layout}
          />
          <span className="CharacterGallery__cropWindow" style={boxRect}>
            <img
              className="CharacterGallery__cropPicture"
              src={url}
              alt=""
              draggable={false}
              style={{
                left: -box.x * layout.width,
                top: -box.y * layout.height,
                width: layout.width,
                height: layout.height,
              }}
            />
          </span>
          <div
            className="CharacterGallery__cropBox"
            data-part="move"
            style={boxRect}
          >
            {EDGES.map((edge) => (
              <span
                key={edge}
                data-part={edge}
                className={`CharacterGallery__cropEdge CharacterGallery__cropEdge--${edge}`}
              />
            ))}
            {HANDLES.map((handle) => (
              <span
                key={handle}
                data-part={handle}
                className={`CharacterGallery__cropHandle CharacterGallery__cropHandle--${handle}`}
              />
            ))}
          </div>
        </>
      ) : (
        <div className="CharacterGallery__cropStatus">
          {pictureStatus(picture)}
        </div>
      )}
    </div>
  );
};
