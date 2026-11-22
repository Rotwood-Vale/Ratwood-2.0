import { useEffect, useState } from 'react';
import { Box } from 'tgui-core/components';

import {
  type ArtViewSettings,
  cropAspect,
  cropImageStyle,
  DEFAULT_ART_VIEW,
  shownArtView,
  viewCrop,
} from '../common/artViewSettings';
import { CardBackground } from '../common/CardBackground';
import { usePictureSize } from '../common/pictureSize';
import { isVideoLink } from './useMediaStatus';

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

export const BrokenBadge = () => <ThumbnailBadge text="Couldn't Load" />;

/** The shares of a box's width and height a shape takes when fitted inside it */
const fittedShape = (aspect: number) => ({
  width: `${Math.min(1, aspect) * 100}%`,
  height: `${Math.min(1, 1 / aspect) * 100}%`,
});

/** Shows a picture as viewers first see it when given its view settings, cut to the crop of Card and Set by Owner */
export const Thumbnail = (props: {
  label: string;
  url: string | null;
  size?: string;
  background?: string;
  view?: ArtViewSettings;
  artworkLimits?: boolean;
  onSize?: (width: number, height: number) => void;
  onError?: () => void;
}) => {
  const { label, url, background, view, artworkLimits, onSize, onError } =
    props;
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
  const video = !!url && !artworkLimits && isVideoLink(url);
  const picture = usePictureSize(
    url && !video ? url : null,
    loaded,
    failed,
    artworkLimits,
  );
  const shape = picture.drawable ? picture.size : null;
  const aspect = shape ? shape[0] / shape[1] : 1;
  const opening = artworkLimits
    ? shownArtView(view ?? DEFAULT_ART_VIEW, shape)
    : view;
  const crop = viewCrop(opening?.opening_view ?? 'whole', opening, aspect);
  const shown = fittedShape(cropAspect(aspect, crop));
  return (
    <Box
      className="CharacterGallery__thumbnail"
      width={props.size ?? THUMBNAIL_SIZE}
      height={props.size ?? THUMBNAIL_SIZE}
    >
      {background !== undefined && (
        <span
          className="CharacterGallery__thumbnailCard"
          style={shape ? shown : undefined}
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
        <span className="CharacterGallery__thumbnailCrop" style={shown}>
          <img
            alt={`${label} Thumbnail`}
            className="CharacterGallery__thumbnailPicture"
            src={url!}
            style={cropImageStyle(crop)}
            onError={failed}
          />
        </span>
      )}
      {picture.tooLarge && <ThumbnailBadge text="Too Large" />}
      {picture.tooExtreme && !picture.tooLarge && (
        <ThumbnailBadge text="Extreme Shape" />
      )}
      {broken && <BrokenBadge />}
    </Box>
  );
};
