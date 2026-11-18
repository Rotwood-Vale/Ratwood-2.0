import { useId, useState } from 'react';
import { Box, Button } from 'tgui-core/components';

import { ART_VIEW_LABELS, DEFAULT_ART_VIEW } from '../common/artViewSettings';
import { CardBackgroundControl } from './CardBackgroundControl';
import { gallerySelectEvents } from './nativeSelect';
import {
  type ArtViewSettings,
  type ImageForm,
  UNDO_ARTWORK_SETTINGS,
  useGalleryBackend,
} from './shared';

const LOCKS = {
  none: 'Unlocked',
  view: 'Lock View',
  zoom: 'Lock Zoom',
  both: 'Lock Both',
};
const LOCK_HELP =
  'Lock View fixes the opening view. Lock Zoom prevents magnification. Lock Both does both. Scrolling and panning remain available.';

export const artViewSummary = (value: ArtViewSettings = DEFAULT_ART_VIEW) =>
  `${ART_VIEW_LABELS[value.opening_view]} | ${LOCKS[value.lock]}`;

export const ArtViewControls = (props: {
  value: Partial<ArtViewSettings>;
  disabled?: boolean;
  allowUnchanged?: boolean;
  label: string;
  onChange: (value: Partial<ArtViewSettings>) => void;
}) => {
  const helpId = useId();
  return (
    <div className="CharacterGallery__viewFields">
      <label>
        Opening view
        <select
          aria-label={`${props.label} opening view`}
          value={props.value.opening_view ?? ''}
          disabled={props.disabled}
          {...gallerySelectEvents}
          onChange={(event) =>
            props.onChange({
              ...props.value,
              opening_view:
                (event.target.value as ArtViewSettings['opening_view']) ||
                undefined,
            })
          }
        >
          {props.allowUnchanged && <option value="">Unchanged</option>}
          {Object.entries(ART_VIEW_LABELS).map(([value, label]) => (
            <option key={value} value={value}>
              {label}
            </option>
          ))}
        </select>
      </label>
      <label>
        Viewer controls
        <select
          aria-label={`${props.label} viewer controls`}
          aria-describedby={helpId}
          title={LOCK_HELP}
          value={props.value.lock ?? ''}
          disabled={props.disabled}
          {...gallerySelectEvents}
          onChange={(event) =>
            props.onChange({
              ...props.value,
              lock:
                (event.target.value as ArtViewSettings['lock']) || undefined,
            })
          }
        >
          {props.allowUnchanged && <option value="">Unchanged</option>}
          {Object.entries(LOCKS).map(([value, label]) => (
            <option key={value} value={value}>
              {label}
            </option>
          ))}
        </select>
      </label>
      <span id={helpId} className="CharacterGallery__lockHelp">
        {LOCK_HELP}
      </span>
    </div>
  );
};

export const ArtworkSettings = (props: { form: ImageForm }) => {
  const { act, isBusy } = useGalleryBackend();
  const { form } = props;
  const [open, setOpen] = useState(false);
  const [view, setView] = useState<Partial<ArtViewSettings>>({});
  const [background, setBackground] = useState('');
  const panelId = useId();
  const busy = isBusy(form.id);
  const reset = () => {
    setOpen(false);
    setView({});
    setBackground('');
  };
  const hasChanges = !!(view.opening_view || view.lock || background);
  const hasArt = !!(form.img_gallery?.length || form.nsfw_img_gallery?.length);
  return (
    <div className="CharacterGallery__artworkSettings">
      <Button
        compact
        icon={open ? 'chevron-up' : 'chevron-down'}
        aria-expanded={open}
        aria-controls={panelId}
        onClick={() => (open ? reset() : setOpen(true))}
      >
        Artwork Settings
      </Button>
      {open && (
        <div id={panelId} className="CharacterGallery__artworkPanel">
          <Box color="label" mb={1}>
            All SFW and NSFW artwork | {form.name} | Current and alternate
            images
          </Box>
          <ArtViewControls
            label="All artwork"
            allowUnchanged
            value={view}
            disabled={busy}
            onChange={setView}
          />
          <Box mt={1}>
            <CardBackgroundControl
              allowUnchanged
              value={background}
              disabled={busy}
              onSelected={setBackground}
            />
          </Box>
          <Box mt={1}>
            <Button
              compact
              disabled={busy || !hasChanges || !hasArt}
              onClick={() => {
                act('apply_artwork_settings', {
                  form: form.id,
                  changes: {
                    ...(view.opening_view && {
                      opening_view: view.opening_view,
                    }),
                    ...(view.lock && { lock: view.lock }),
                    ...(background && { card_background: background }),
                  },
                });
                reset();
              }}
            >
              Apply to All Artwork
            </Button>
            <Button compact onClick={reset}>
              Cancel
            </Button>
          </Box>
        </div>
      )}
      {!!form.undo_artwork_settings && (
        <div className="CharacterGallery__artworkResult" role="status">
          <Button
            compact
            icon="undo"
            disabled={busy}
            onClick={() =>
              act('undo_image', { form: form.id, image: UNDO_ARTWORK_SETTINGS })
            }
          >
            Undo Artwork Settings
          </Button>
        </div>
      )}
      {!!form.artwork_feedback && (
        <div className="CharacterGallery__artworkResult">
          {form.artwork_feedback}
        </div>
      )}
    </div>
  );
};
