import { resolveAsset } from '../../assets';
import { PICTURE_TOO_LARGE_TEXT, usePictureSize } from './pictureSize';

export const HEADSHOT_PANEL_SIZE = 350;

export const PictureTooLarge = () => (
  <div
    style={{
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      width: '100%',
      height: '100%',
      padding: '0.5em',
      boxSizing: 'border-box',
      textAlign: 'center',
      color: 'var(--color-label, #a3968a)',
    }}
  >
    {PICTURE_TOO_LARGE_TEXT}
  </div>
);

type HeadshotFrameProps = {
  src: string;
  zoom: number;
  x: number;
  y: number;
  onSize?: (width: number, height: number) => void;
  onError?: () => void;
};

/**
 * A headshot shown as a square, filling the width it is given.
 *
 * The picture covers the square, keeping its proportions, then zooms about the point at X and Y
 * percent. That point sits at the same percentage of the frame and of the zoomed picture, so each axis
 * slides the picture by its percentage of whatever overflows the frame at that zoom.
 *
 * Its size is read before it is drawn, and one over the pixel cap is never drawn.
 *
 * DM's headshot_picture_style in character_gallery_images.dm writes the same style for the chat and
 * the Character tab.
 */
export const HeadshotFrame = (props: HeadshotFrameProps) => {
  const { src, zoom, x, y, onSize, onError } = props;
  const picture = usePictureSize(src, onSize, onError);
  return (
    <div style={{ width: '100%', aspectRatio: '1', overflow: 'hidden' }}>
      {picture.tooLarge && <PictureTooLarge />}
      {picture.drawable && (
        <img
          src={resolveAsset(src)}
          onError={onError}
          style={{
            display: 'block',
            width: '100%',
            height: '100%',
            objectFit: 'cover',
            objectPosition: `${x}% ${y}%`,
            transform: `scale(${zoom / 100})`,
            transformOrigin: `${x}% ${y}%`,
          }}
        />
      )}
    </div>
  );
};
