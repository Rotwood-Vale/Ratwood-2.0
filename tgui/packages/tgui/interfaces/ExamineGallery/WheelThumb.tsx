import { useEffect, useRef, useState } from 'react';
import { classes } from 'tgui-core/react';

import { CardBackground } from '../common/CardBackground';
import { WHEEL_SPOTS, wheelScale, wheelTransform } from './galleryWheel';
import { StillThumb } from './StillThumb';
import type { Pictures } from './usePictures';

export const WheelThumb = (props: {
  url: string;
  background: string;
  index: number;
  steps: number;
  dealDelay: number | null;
  pictures: Pictures;
  onSelect: () => void;
}) => {
  const { url, background, index, steps, dealDelay, pictures, onSelect } =
    props;
  const [lift, setLift] = useState<'deal' | 'up' | 'down' | 'picked' | null>(
    dealDelay === null ? null : 'deal',
  );
  const isSelected = steps === 0;
  const wasSelected = useRef(isSelected);
  useEffect(() => {
    if (isSelected && !wasSelected.current) {
      setLift('picked');
    }
    wasSelected.current = isSelected;
  }, [isSelected]);
  // The hop plays out even though the thumbnail slides from under the mouse as it starts
  const hover = (next: 'up' | 'down') =>
    setLift((current) => (current === 'picked' ? current : next));

  return (
    <button
      type="button"
      className="ExamineGallery__thumb"
      aria-label={`Picture ${index + 1}`}
      aria-current={isSelected}
      onClick={onSelect}
      onMouseEnter={() => hover('up')}
      onMouseLeave={() => hover('down')}
      style={
        {
          width: WHEEL_SPOTS[0].size,
          height: WHEEL_SPOTS[0].size,
          zIndex:
            lift === 'up'
              ? WHEEL_SPOTS.length + 1
              : WHEEL_SPOTS.length - Math.abs(steps),
          transform: wheelTransform(steps),
          '--thumb-scale': wheelScale(steps),
          '--deal-delay': `${dealDelay ?? 0}ms`,
        } as React.CSSProperties
      }
    >
      <span
        className={classes([
          'ExamineGallery__lift',
          isSelected && 'ExamineGallery__lift--selected',
          lift && `ExamineGallery__lift--${lift}`,
        ])}
        onAnimationEnd={() => {
          if (lift !== 'up') {
            setLift(null);
          }
        }}
      >
        <CardBackground value={background} />
        {pictures.mayLoad(index) && (
          <StillThumb url={url} pictures={pictures} />
        )}
      </span>
    </button>
  );
};
