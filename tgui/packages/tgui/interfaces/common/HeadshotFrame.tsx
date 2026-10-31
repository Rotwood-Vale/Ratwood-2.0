import { type CSSProperties } from 'react';

import { resolveAsset } from '../../assets';

type HeadshotFrameProps = {
  src: string;
  /** Whether the owner framed it. Unframed, the picture stretches into the square as it always did. */
  framed: boolean;
  /** Zoom in percent, 100 being the picture just covering the frame. */
  zoom: number;
  /** Position across, in percent of the picture that overflows the frame. */
  x: number;
  /** Position down, in percent of the picture that overflows the frame. */
  y: number;
  /** Called with the picture's own size once it loads. */
  onSize?: (width: number, height: number) => void;
  /** Called when the picture fails to load. */
  onError?: () => void;
};

/**
 * A headshot shown as a square, filling the width it is given.
 *
 * Framed, the picture covers the square, then zooms about the point at X and Y percent. That point
 * sits at the same percentage of the frame and of the zoomed picture, so each axis slides the picture
 * by its percentage of whatever overflows the frame at that zoom.
 */
export const HeadshotFrame = (props: HeadshotFrameProps) => {
  const { src, framed, zoom, x, y, onSize, onError } = props;
  const pictureStyle: CSSProperties = framed
    ? {
        objectFit: 'cover',
        objectPosition: `${x}% ${y}%`,
        transform: `scale(${zoom / 100})`,
        transformOrigin: `${x}% ${y}%`,
      }
    : { objectFit: 'fill' };
  return (
    <div style={{ width: '100%', aspectRatio: '1', overflow: 'hidden' }}>
      <img
        src={resolveAsset(src)}
        onLoad={(event) =>
          onSize?.(
            event.currentTarget.naturalWidth,
            event.currentTarget.naturalHeight,
          )
        }
        onError={onError}
        style={{
          display: 'block',
          width: '100%',
          height: '100%',
          ...pictureStyle,
        }}
      />
    </div>
  );
};
