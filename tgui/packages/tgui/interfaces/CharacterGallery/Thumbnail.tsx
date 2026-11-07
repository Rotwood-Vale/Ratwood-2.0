import { useEffect, useState } from 'react';
import { Box } from 'tgui-core/components';

import { CardBackground } from '../common/CardBackground';
import { usePictureSize } from '../common/pictureSize';
import { isVideoLink } from './shared';

const THUMBNAIL_SIZE = '64px';

const ThumbnailBadge = (props: { text: string }) => (
  <Box
    position="absolute"
    style={{ zIndex: 2 }}
    bottom={0}
    left={0}
    right={0}
    backgroundColor="rgba(160, 0, 0, 0.85)"
    textAlign="center"
    fontSize="0.8em"
    bold
  >
    {props.text}
  </Box>
);

export const BrokenBadge = () => <ThumbnailBadge text="Couldn't load" />;

export const Thumbnail = (props: {
  label: string;
  url: string | null;
  background?: string;
  onSize?: (width: number, height: number) => void;
  onError?: () => void;
}) => {
  const { label, url, background, onSize, onError } = props;
  const [broken, setBroken] = useState(false);
  useEffect(() => setBroken(false), [url]);
  const loaded = (width: number, height: number) => {
    onSize?.(width, height);
    setBroken(false);
  };
  const failed = () => {
    setBroken(true);
    onError?.();
  };
  const video = !!url && isVideoLink(url);
  const picture = usePictureSize(url && !video ? url : null, loaded, failed);
  const shape = picture.drawable ? picture.size : null;
  return (
    <Box
      className="CharacterGallery__thumbnail"
      width={THUMBNAIL_SIZE}
      height={THUMBNAIL_SIZE}
    >
      {background !== undefined && (
        <span
          className="CharacterGallery__thumbnailCard"
          style={
            shape
              ? {
                  width: `${Math.min(1, shape[0] / shape[1]) * 100}%`,
                  height: `${Math.min(1, shape[1] / shape[0]) * 100}%`,
                }
              : undefined
          }
        >
          <CardBackground value={background} />
        </span>
      )}
      {video && (
        <video
          aria-label={`${label} Video Thumbnail`}
          className="CharacterGallery__thumbnailMedia"
          src={url}
          muted
          preload="metadata"
          onLoadedMetadata={(event) =>
            loaded(
              event.currentTarget.videoWidth,
              event.currentTarget.videoHeight,
            )
          }
          onError={failed}
        />
      )}
      {picture.drawable && (
        <img
          alt={`${label} Thumbnail`}
          className="CharacterGallery__thumbnailMedia"
          src={url!}
          onError={failed}
        />
      )}
      {picture.tooLarge && <ThumbnailBadge text="Too large" />}
      {broken && <BrokenBadge />}
    </Box>
  );
};
