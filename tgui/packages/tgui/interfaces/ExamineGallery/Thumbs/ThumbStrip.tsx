import type { ArtViewSettings } from '../../common/artViewSettings';
import { thumbDealDelay } from '../pictureChange';
import type { Pictures } from '../usePictures';
import { wheelSteps } from './galleryWheel';
import { PlainThumbs } from './PlainThumbs';
import { WheelThumb } from './WheelThumb';

export const ThumbStrip = (props: {
  images: string[];
  settings: (ArtViewSettings | undefined)[];
  backgrounds: string[];
  selected: number;
  pictures: Pictures;
  plain: boolean;
  openingDeal: number[] | null;
  onPick: (index: number) => void;
  onGoTo: (index: number, direction: number) => void;
}) => {
  const {
    images,
    settings,
    backgrounds,
    selected,
    pictures,
    plain,
    openingDeal,
  } = props;
  const count = images.length;
  return (
    <div className="ExamineGallery__strip">
      {plain ? (
        <PlainThumbs
          images={images}
          settings={settings}
          selected={selected}
          pictures={pictures}
          onSelect={props.onPick}
        />
      ) : (
        images.map((url, index) => {
          const steps = wheelSteps(index, selected, count);
          return (
            <WheelThumb
              key={index}
              url={url}
              settings={settings[index]}
              background={backgrounds[index]}
              index={index}
              steps={steps}
              dealDelay={thumbDealDelay(openingDeal, index)}
              pictures={pictures}
              onSelect={() => props.onGoTo(index, Math.sign(steps) || 1)}
            />
          );
        })
      )}
    </div>
  );
};
