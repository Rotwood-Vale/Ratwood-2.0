import { type PropsWithChildren, useEffect, useRef, useState } from 'react';
import { Box, Button, Icon } from 'tgui-core/components';

import {
  PICTURE_RATIO_TALL_MAX,
  PICTURE_RATIO_WIDE_MAX,
  PICTURE_TOO_LARGE_TEXT,
  pictureShapeTooExtreme,
} from '../common/pictureSize';
import { copyUrl, type ImageForm, useGalleryBackend } from './shared';
import { Thumbnail } from './Thumbnail';
import { useMediaStatus } from './useMediaStatus';

export const useCopyUrl = () => {
  const [message, setMessage] = useState('');
  const copy = async (
    url: string,
    copiedMessage: string,
    onFail: () => void,
  ) => {
    const copied = await copyUrl(url);
    setMessage(
      copied ? copiedMessage : 'Select the URL and press Ctrl+C to copy.',
    );
    if (!copied) {
      onFail();
    }
  };
  return { message, copy, clear: () => setMessage('') };
};

export const SourceSwitch = (props: {
  form: ImageForm;
  image: string;
  label: string;
  keepMargin?: boolean;
}) => {
  const { act, isBusy } = useGalleryBackend();
  const { form, image, label, keepMargin } = props;
  const source = form.alternates?.[image];
  if (!source) {
    return null;
  }
  return (
    <Button
      icon="exchange-alt"
      disabled={isBusy(form.id)}
      aria-label={`Swap Images for ${label}`}
      // Inline, as a class loses to the parchment theme's own Button margin
      style={keepMargin ? undefined : { margin: 0 }}
      onClick={() =>
        act('use_url', {
          form: form.id,
          image,
          alternate: !source.active_alternate,
        })
      }
    >
      Swap
    </Button>
  );
};

export const MediaStatus = (props: {
  media: ReturnType<typeof useMediaStatus>;
  loading: string;
  retrying: string;
  error: string;
  retryText: string;
  retryLabel?: string;
  statusMt?: number;
}) => {
  const { media } = props;
  return (
    <>
      {media.loading && (
        <div role="status">
          <Box color="label" mt={props.statusMt}>
            {media.retry ? props.retrying : props.loading}
          </Box>
        </div>
      )}
      {media.tooLarge && (
        <div role="status">
          <Box color="bad" mt={props.statusMt}>
            {PICTURE_TOO_LARGE_TEXT}
          </Box>
        </div>
      )}
      {media.broken && (
        <div role="status" className="CharacterGallery__error">
          <Box color="bad">{props.error}</Box>
          <Button
            icon="rotate"
            aria-label={props.retryLabel}
            onClick={media.handleRetry}
          >
            {props.retryText}
          </Button>
        </div>
      )}
    </>
  );
};

type LinkControlsProps = {
  disabled?: boolean;
  label: string;
  url: string | null;
  setText?: string;
  onSet?: () => void;
  onClear?: () => void;
  form?: ImageForm;
  image?: string;
  keepSwapMargin?: boolean;
};

type MoveControls = {
  first: boolean;
  last: boolean;
  onMove: (direction: -1 | 1) => void;
};

const SHAPE_WARNING = `This picture's shape is too extreme to show: 1:${PICTURE_RATIO_TALL_MAX} tall or ${PICTURE_RATIO_WIDE_MAX}:1 wide at most`;

type LinkRowProps = PropsWithChildren<
  LinkControlsProps & {
    background?: string;
    move?: MoveControls;
    tone?: 'light' | 'dark';
    flash?: boolean;
    checkShape?: boolean;
  }
>;

export const LinkRow = (props: LinkRowProps) => {
  const {
    label,
    children,
    move,
    tone,
    flash,
    background,
    checkShape,
    ...controls
  } = props;
  const media = useMediaStatus(props.url);
  const shapeTooExtreme =
    !!checkShape &&
    media.ready &&
    !!media.size &&
    pictureShapeTooExtreme(media.size[0], media.size[1]);
  const row = (
    <div className="CharacterGallery__row">
      <div>
        {/* A new element for each link, as the side-by-side layout does not repaint a changed one */}
        <Thumbnail
          key={`${props.url}:${media.retry}`}
          label={label}
          url={props.url}
          background={
            background ??
            (props.image
              ? props.form?.card_backgrounds?.[props.image]
              : undefined)
          }
          onSize={media.handleLoad}
          onError={media.handleError}
        />
      </div>
      <div className="CharacterGallery__rowBody">
        <div className="CharacterGallery__rowDetails">
          <div>
            <Box bold>{label}</Box>
            {!!media.size && (
              <Box color="label" fontSize="0.8em">
                {media.ready
                  ? `${media.size[0]} × ${media.size[1]}`
                  : 'Loading…'}
              </Box>
            )}
          </div>
          <LinkControls {...controls} label={label} />
        </div>
        <MediaStatus
          media={media}
          loading="Loading media…"
          retrying="Retrying media…"
          error="Couldn't load the media. Check the link."
          retryText="Retry"
          retryLabel={`Retry ${label}`}
        />
        {shapeTooExtreme && (
          <div role="status">
            <Box color="average">
              <Icon name="exclamation-triangle" mr={0.5} />
              {SHAPE_WARNING}
            </Box>
          </div>
        )}
        {children}
      </div>
      {!!move && (
        <div>
          <Box>
            <Button
              compact
              icon="arrow-up"
              tooltip={`Move ${label} up`}
              aria-label={`Move ${label} Up`}
              disabled={move.first}
              onClick={() => move.onMove(-1)}
            />
          </Box>
          <Box mt={0.5}>
            <Button
              compact
              icon="arrow-down"
              tooltip={`Move ${label} down`}
              aria-label={`Move ${label} Down`}
              disabled={move.last}
              onClick={() => move.onMove(1)}
            />
          </Box>
        </div>
      )}
    </div>
  );
  if (!tone) {
    return row;
  }
  return (
    <Box
      p={1}
      mb={0.5}
      className={
        flash
          ? 'CharacterGallery__row--flash'
          : `CharacterGallery__row--${tone}`
      }
    >
      {row}
    </Box>
  );
};

export const LinkControls = (props: LinkControlsProps) => {
  const { act } = useGalleryBackend();
  const {
    disabled,
    label,
    url,
    setText,
    onSet,
    onClear,
    form,
    image,
    keepSwapMargin,
  } = props;
  const changeLabel = setText ? `${setText} ${label}` : `Change ${label} URL`;
  return (
    <div className="CharacterGallery__links">
      <div className="CharacterGallery__url">
        {url ? (
          <HiddenUrl key={url} url={url} label={label} />
        ) : (
          <Box color="label">No image added</Box>
        )}
      </div>
      <div className="CharacterGallery__actions">
        {!!onSet && (
          <Button
            icon={url ? 'pen' : 'plus'}
            disabled={disabled}
            aria-label={url ? changeLabel : `Add ${label}`}
            onClick={() => onSet()}
          >
            {url ? (setText ?? 'Change') : 'Add'}
          </Button>
        )}
        {!!form && !!image && (
          <SourceSwitch
            form={form}
            image={image}
            label={label}
            keepMargin={keepSwapMargin}
          />
        )}
        {!!url && !!onClear && (
          <Button
            icon="times"
            color="bad"
            aria-label={`Remove ${label}`}
            disabled={disabled}
            onClick={() => onClear()}
          >
            Remove
          </Button>
        )}
        {!!form && !!image && form.undo.includes(image) && (
          <Button
            icon="undo"
            aria-label={`Undo ${label}`}
            disabled={disabled}
            onClick={() => act('undo_image', { form: form.id, image })}
          >
            Undo
          </Button>
        )}
      </div>
    </div>
  );
};

const HiddenUrl = (props: { url: string; label: string }) => {
  const { url, label } = props;
  const [shown, setShown] = useState(false);
  const copier = useCopyUrl();
  const textRef = useRef<HTMLDivElement>(null);
  useEffect(() => {
    if (shown) {
      selectContents(textRef.current);
    }
  }, [shown]);

  const copy = () =>
    copier.copy(url, 'URL copied.', () => {
      setShown(true);
      selectContents(textRef.current);
    });
  return (
    <div>
      <div className="CharacterGallery__actions">
        <Button
          icon={shown ? 'eye-slash' : 'eye'}
          aria-label={`${shown ? 'Hide' : 'Show'} ${label} URL`}
          onClick={() => setShown(!shown)}
        >
          {shown ? 'Hide URL' : 'Show URL'}
        </Button>
        <Button icon="copy" aria-label={`Copy ${label} URL`} onClick={copy}>
          Copy
        </Button>
      </div>
      {shown && (
        <div
          ref={textRef}
          tabIndex={0}
          aria-label={`${label} URL`}
          title="Press Ctrl+C to copy"
          className="CharacterGallery__revealedUrl"
          onFocus={() => selectContents(textRef.current)}
          onClick={() => selectContents(textRef.current)}
        >
          {url}
        </div>
      )}
      <div role="status" aria-live="polite">
        {copier.message}
      </div>
    </div>
  );
};

const selectContents = (element: HTMLElement | null) => {
  if (!element) {
    return;
  }
  const range = document.createRange();
  range.selectNodeContents(element);
  const selection = window.getSelection();
  selection?.removeAllRanges();
  selection?.addRange(range);
};
