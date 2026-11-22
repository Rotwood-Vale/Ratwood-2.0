import { type ArtCrop, cropImageStyle } from '../../common/artViewSettings';
import { focusClip, type ReadingBox } from './readingGeometry';

/** The picture on its surface as readingBox lays it out, drawn by the reader and by the framing copy over it */
export const ReadingSurface = (props: {
  box: ReadingBox;
  className: string;
  clip: boolean;
  crop?: ArtCrop;
  pictureRef?: React.RefObject<HTMLDivElement | null>;
  image: React.ImgHTMLAttributes<HTMLImageElement> | false;
}) => {
  const { box, className, clip, crop, pictureRef, image } = props;
  return (
    <div
      className={className}
      style={{ width: box.surfaceWidth, height: box.surfaceHeight }}
    >
      {image && (
        <div
          ref={pictureRef}
          className="ExamineGallery__readingPicture"
          style={{
            left: box.left,
            top: box.top,
            width: box.width,
            height: box.height,
            clipPath: clip && box.focus ? focusClip(box.focus) : undefined,
            overflow: crop ? 'clip' : undefined,
          }}
        >
          <img {...image} style={crop ? cropImageStyle(crop) : image.style} />
        </div>
      )}
    </div>
  );
};
