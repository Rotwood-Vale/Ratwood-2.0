import { classes } from 'tgui-core/react';

import { resolveAsset } from '../../../assets';
import { type ArtCrop, cropImageStyle } from '../../common/artViewSettings';
import { CardBackground } from '../../common/CardBackground';
import {
  type Area,
  type PictureBox,
  pictureBox,
} from '../../common/cardLayout';
import type { PictureMove } from '../pictureChange';
import type { Pictures } from '../usePictures';

/** The whole picture's box behind a card that shows only its crop */
export const uncroppedBox = (card: PictureBox, crop: ArtCrop | undefined) =>
  crop
    ? {
        left: card.left - (crop.x / crop.w) * card.width,
        top: card.top - (crop.y / crop.h) * card.height,
        width: card.width / crop.w,
        height: card.height / crop.h,
      }
    : card;

/** A card's picture, scaled so its crop fills the card */
const CardImage = (props: {
  crop: ArtCrop | undefined;
  image: React.ImgHTMLAttributes<HTMLImageElement>;
}) => {
  const { crop, image } = props;
  if (!crop) {
    return <img {...image} />;
  }
  return (
    <span className="ExamineGallery__crop">
      <img {...image} style={cropImageStyle(crop)} />
    </span>
  );
};

/** Every loaded picture behind the cards as a backdrop, the shown one faded in */
export const BackdropPictures = (props: {
  images: string[];
  pictures: Pictures;
  selected: number;
  selectedShowable: boolean;
}) => {
  const { images, pictures, selected, selectedShowable } = props;
  return (
    <div className="ExamineGallery__backdrops">
      {images.map(
        (url, index) =>
          pictures.mayLoad(index) &&
          pictures.drawable(url) && (
            <img
              key={index}
              className={classes([
                'ExamineGallery__backdrop',
                index === selected &&
                  selectedShowable &&
                  'ExamineGallery__backdrop--shown',
              ])}
              src={resolveAsset(url)}
              alt=""
            />
          ),
      )}
    </div>
  );
};

/** One card per picture inside the tilt, with the deal's classes on the shown and thrown cards */
export const PictureCards = (props: {
  tiltRef: React.RefObject<HTMLDivElement | null>;
  images: string[];
  backgrounds: string[];
  crops: (ArtCrop | undefined)[];
  selected: number;
  selectedShowable: boolean;
  pictures: Pictures;
  move: PictureMove;
  isDeal: boolean;
  landed: PictureMove | null;
  dealWait: number;
  showable: (index: number) => boolean;
  cardAspectAt: (index: number) => number | undefined;
  area: Area;
  margin: number;
  plain: boolean;
}) => {
  const {
    tiltRef,
    images,
    backgrounds,
    crops,
    selected,
    selectedShowable,
    pictures,
    move,
    isDeal,
    landed,
    dealWait,
    showable,
    cardAspectAt,
    area,
    margin,
    plain,
  } = props;
  return (
    <div
      ref={tiltRef}
      className="ExamineGallery__tilt"
      style={{ '--deal-direction': move.direction } as React.CSSProperties}
    >
      {images.map((url, index) => {
        const isShown = index === selected && selectedShowable;
        return (
          pictures.mayLoad(index) &&
          pictures.drawable(url) && (
            <div
              key={index}
              className={classes([
                'ExamineGallery__picture',
                isShown && 'ExamineGallery__picture--shown',
                isShown && isDeal && 'ExamineGallery__picture--dealt',
                index === move.from &&
                  isDeal &&
                  landed !== move &&
                  showable(index) &&
                  'ExamineGallery__picture--thrown',
              ])}
              style={
                {
                  ...pictureBox(cardAspectAt(index) ?? 1, area, margin),
                  '--deal-delay': `${isShown ? dealWait : 0}ms`,
                } as React.CSSProperties
              }
            >
              {!plain && <CardBackground value={backgrounds[index]} />}
              <CardImage
                crop={crops[index]}
                image={{
                  ...pictures.imageProps(url),
                  alt: `Picture ${index + 1}`,
                }}
              />
              {!plain && <span className="ExamineGallery__frame" />}
            </div>
          )
        );
      })}
    </div>
  );
};
