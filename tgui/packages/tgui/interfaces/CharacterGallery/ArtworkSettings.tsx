import { useId, useState } from 'react';
import { Button, Tooltip } from 'tgui-core/components';

import {
  ART_LOCK_HELP,
  ART_LOCK_LABELS,
  ART_VIEW_HELP,
  ART_VIEW_LABELS,
  type ArtViewSettings,
  DEFAULT_ART_VIEW,
} from '../common/artViewSettings';
import { CARD_DEFAULT } from '../common/CardBackground';
import { ArtViewControls } from './ArtViewControls';
import {
  BulkCardBackgroundSelect,
  cardBackgroundLabel,
} from './CardBackgroundControl';
import { useGalleryBackend } from './galleryBackend';
import { GallerySelect } from './GallerySelect';
import { UNDO_ARTWORK_SETTINGS } from './slots';
import type { ImageForm } from './types';

const APPLY_TARGETS = [
  { value: 'existing', label: 'Existing Artwork' },
  { value: 'new', label: 'New Artwork Only' },
  { value: 'both', label: 'Existing and New Artwork' },
];

export const ArtworkSettings = (props: { form: ImageForm }) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { form } = props;
  const [open, setOpen] = useState(false);
  const [view, setView] = useState<Partial<ArtViewSettings>>({});
  const [background, setBackground] = useState('');
  const [target, setTarget] = useState('existing');
  const panelId = useId();
  const busy = isBusy(form.id);
  const resetSelections = () => {
    setView({});
    setBackground('');
    setTarget('existing');
  };
  const reset = () => {
    setOpen(false);
    resetSelections();
  };
  const changes = {
    ...(view.opening_view && { opening_view: view.opening_view }),
    ...(view.lock && { lock: view.lock }),
    ...(background && { card_background: background }),
  };
  const hasChanges = Object.keys(changes).length > 0;
  const hasArt = !!(form.img_gallery?.length || form.nsfw_img_gallery?.length);
  const defaults = form.artwork_defaults ?? {
    ...DEFAULT_ART_VIEW,
    card_background: CARD_DEFAULT,
  };
  const defaultBackdrop = cardBackgroundLabel(
    data.card_background_options,
    defaults.card_background,
  );
  const actionDisabled = busy || !hasChanges;
  const applyChanges = () => {
    if (!hasArt || target === 'new') {
      act('set_artwork_defaults', { form: form.id, changes });
    } else {
      act('apply_artwork_settings', {
        form: form.id,
        changes,
        ...(target === 'both' && { set_defaults: true }),
      });
      if (target === 'existing') {
        setOpen(false);
      }
    }
    resetSelections();
  };
  return (
    <div className="CharacterGallery__artworkSettings">
      <Button
        compact
        icon={open ? 'chevron-up' : 'chevron-down'}
        tooltip={`Bulk changes apply to current and alternate SFW and NSFW artwork for ${form.name}. Each image keeps its own framing box. Unchanged keeps saved artwork settings and defaults.`}
        aria-expanded={open}
        aria-controls={panelId}
        onClick={() => (open ? reset() : setOpen(true))}
      >
        Artwork Display
      </Button>
      {open && (
        <div id={panelId} className="CharacterGallery__artworkPanel">
          <ArtViewControls
            label="All Artwork"
            allowUnchanged
            value={view}
            disabled={busy}
            onChange={setView}
          >
            <BulkCardBackgroundSelect
              value={background}
              disabled={busy}
              onSelected={setBackground}
            />
          </ArtViewControls>
          <div className="CharacterGallery__artworkFooter">
            <div
              className="CharacterGallery__artworkDefaults"
              aria-live="polite"
            >
              <strong>Current Defaults for New Artwork</strong>
              <div className="CharacterGallery__defaultValues">
                <Tooltip content={ART_VIEW_HELP[defaults.opening_view]}>
                  <span>
                    View: <b>{ART_VIEW_LABELS[defaults.opening_view]}</b>
                  </span>
                </Tooltip>
                <Tooltip content={ART_LOCK_HELP[defaults.lock]}>
                  <span>
                    Controls: <b>{ART_LOCK_LABELS[defaults.lock]}</b>
                  </span>
                </Tooltip>
                <span>
                  Backdrop: <b>{defaultBackdrop ?? 'Transparent'}</b>
                </span>
              </div>
            </div>
            <div className="CharacterGallery__artworkActions">
              {hasArt && (
                <label className="CharacterGallery__applyTarget">
                  Apply To
                  <GallerySelect
                    aria-label="Apply To"
                    value={target}
                    disabled={busy}
                    options={APPLY_TARGETS}
                    onChange={setTarget}
                  />
                </label>
              )}
              <div className="CharacterGallery__artworkButtons">
                <Button
                  compact
                  disabled={actionDisabled}
                  onClick={applyChanges}
                >
                  {hasArt ? 'Apply' : 'Set Defaults for New Artwork'}
                </Button>
                <Button compact onClick={reset}>
                  Cancel
                </Button>
              </div>
            </div>
          </div>
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
            Undo Artwork Display Changes
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
