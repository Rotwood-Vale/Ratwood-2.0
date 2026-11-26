import { Box } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

/** A numbered button per picture under the artwork, a seal or in Plain Gallery a page marker */
export const SealNumbers = (props: {
  images: string[];
  selected: number;
  plain: boolean;
  onPick: (index: number) => void;
}) => {
  const { images, selected, plain } = props;
  const marker = plain ? 'ExamineGallery__page' : 'ExamineGallery__seal';
  return (
    <Box className="ExamineGallery__seals">
      {images.map((_, index) => (
        <button
          key={index}
          type="button"
          className={classes([
            marker,
            index === selected && `${marker}--current`,
          ])}
          aria-label={`Picture ${index + 1}`}
          aria-current={index === selected}
          onClick={() => props.onPick(index)}
        >
          <span className={plain ? undefined : 'ExamineGallery__sealNumber'}>
            {index + 1}
          </span>
        </button>
      ))}
    </Box>
  );
};
