import type { ReactNode, RefObject } from 'react';
import { Box, Button, Icon, Tooltip } from 'tgui-core/components';

import { ART_VIEW_LABELS } from '../../common/artViewSettings';
import { PICTURE_RATIO_TALL_MAX } from '../../common/pictureSize';
import { ArtViewControls } from '../ArtViewControls';
import { CardBackgroundDropdown } from '../CardBackgroundControl';
import type { useCopyUrl } from '../clipboard';
import { Thumbnail } from '../Thumbnail';
import { useMediaStatus } from '../useMediaStatus';
import { ROW_NAMES, type SourceDraft } from './useSourceDrafts';

export const ALTERNATE_TOOLTIP = 'A backup link you can swap to.';

const SCROLLING_ONLY_TEXT = `This picture is taller than 1:${PICTURE_RATIO_TALL_MAX}, so it always opens in ${ART_VIEW_LABELS.scroll}.`;

/** One link of the Edit dialog, row 0 being whichever of main and alternate is in use */
export const SourceRow = (props: {
  index: number;
  source: SourceDraft;
  inputRef: RefObject<HTMLInputElement | null>;
  isArt: boolean;
  busy: boolean;
  maxLength: number;
  copier: ReturnType<typeof useCopyUrl>;
  /** The row was focused, pressed or had its view changed, so the framing column shows it */
  onActivate: () => void;
  /** A control at the end of the heading row, where it stays in sight */
  action?: ReactNode;
}) => {
  const { index, inputRef, isArt, busy, copier, onActivate, action } = props;
  const {
    url: value,
    setUrl: setValue,
    previewUrl,
    background,
    setBackground,
    view,
    setView,
    scrollingOnly,
  } = props.source;
  const media = useMediaStatus(isArt ? previewUrl : null, true);
  const label = index === 0 ? 'Current Image URL' : 'Alternate Image URL';
  const heading = (
    <div className="CharacterGallery__sourceHeading">
      {index === 0 ? (
        ROW_NAMES[index]
      ) : (
        <Tooltip content={ALTERNATE_TOOLTIP}>
          <span tabIndex={0}>
            {'Alternate Image (Optional)'} <Icon name="circle-question" />
          </span>
        </Tooltip>
      )}
      {action}
    </div>
  );
  const input = (
    <input
      ref={inputRef}
      className="Input CharacterGallery__urlInput"
      aria-label={label}
      maxLength={props.maxLength}
      disabled={busy}
      value={value}
      onChange={(event) => setValue(event.target.value)}
    />
  );
  const copy = (
    <Button
      compact
      icon="copy"
      disabled={!value.trim()}
      onClick={() =>
        copier.copy(value, `${label} copied.`, () => {
          inputRef.current?.focus();
          inputRef.current?.select();
        })
      }
    >
      Copy
    </Button>
  );

  if (isArt) {
    return (
      <div
        className="CharacterGallery__artSource"
        onFocus={onActivate}
        onPointerDown={onActivate}
      >
        {heading}
        <Thumbnail
          label={label}
          url={previewUrl}
          size="var(--art-thumbnail-size)"
          background={background}
          view={view}
          artworkLimits
          onSize={media.handleLoad}
        />
        <div className="CharacterGallery__artUrl">
          <label>
            Image URL
            {input}
          </label>
          {copy}
        </div>
        {!!media.limitText && (
          <div role="status">
            <Box color="bad">{media.limitText}</Box>
          </div>
        )}
        <ArtViewControls
          label={ROW_NAMES[index]}
          value={view}
          disabled={busy}
          scrollingOnly={scrollingOnly}
          onChange={(changes) => {
            setView({ ...view, ...changes });
            onActivate();
          }}
        />
        {scrollingOnly && <Box color="label">{SCROLLING_ONLY_TEXT}</Box>}
        {view.opening_view === 'whole' && (
          <CardBackgroundDropdown
            value={background}
            disabled={busy}
            onSelected={(material) => {
              setBackground(material);
              // A menu pick leaves focus on the page body, out of reach of the modal's Escape
              inputRef.current?.focus();
            }}
          />
        )}
      </div>
    );
  }

  return (
    <div
      className="CharacterGallery__sourceRow"
      onFocus={onActivate}
      onPointerDown={onActivate}
    >
      <Thumbnail label={label} url={previewUrl} />
      <div>
        <Box mb={0.5}>{heading}</Box>
        {input}
        <Box mt={0.5}>{copy}</Box>
      </div>
    </div>
  );
};
