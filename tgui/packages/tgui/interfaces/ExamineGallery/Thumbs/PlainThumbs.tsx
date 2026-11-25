import { useEffect, useRef } from 'react';
import { classes } from 'tgui-core/react';

import type { ArtViewSettings } from '../../common/artViewSettings';
import type { Pictures } from '../usePictures';
import { StillThumb } from './StillThumb';

export const PlainThumbs = (props: {
  images: string[];
  settings: (ArtViewSettings | undefined)[];
  selected: number;
  pictures: Pictures;
  onSelect: (index: number) => void;
}) => {
  const { images, settings, selected, pictures, onSelect } = props;
  const rowRef = useRef<HTMLDivElement>(null);

  // Scrolls the row alone, as scrollIntoView would also shift the gallery's clipped areas around it
  useEffect(() => {
    const row = rowRef.current;
    const thumb = row?.children[selected] as HTMLElement | undefined;
    if (!row || !thumb) {
      return;
    }
    if (thumb.offsetLeft < row.scrollLeft) {
      row.scrollLeft = thumb.offsetLeft;
    } else if (
      thumb.offsetLeft + thumb.offsetWidth >
      row.scrollLeft + row.clientWidth
    ) {
      row.scrollLeft = thumb.offsetLeft + thumb.offsetWidth - row.clientWidth;
    }
  }, [selected]);

  return (
    <div ref={rowRef} className="ExamineGallery__plainThumbs">
      {images.map((url, index) => (
        <button
          key={index}
          type="button"
          className={classes([
            'ExamineGallery__plainThumb',
            index === selected && 'ExamineGallery__plainThumb--selected',
          ])}
          aria-label={`Picture ${index + 1}`}
          aria-current={index === selected}
          onClick={() => onSelect(index)}
        >
          {pictures.mayLoad(index) && (
            <StillThumb
              url={url}
              settings={settings[index]}
              pictures={pictures}
            />
          )}
        </button>
      ))}
    </div>
  );
};
