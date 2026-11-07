import { Fragment, useEffect, useRef, useState } from 'react';
import { Box, Icon, Section } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { DragSlider } from '../../components';
import { LinkControls, LinkRow } from './LinkRow';
import {
  artLabel,
  artScope,
  artSlot,
  extraLabel,
  extraSlot,
  galleryLabel,
  type ImageForm,
  removedPoint,
  RemovedRow,
  useGalleryBackend,
  useSettled,
} from './shared';

export const ExtraRow = (props: { form: ImageForm; nsfw: boolean }) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { form, nsfw } = props;
  const settle = useSettled();
  const busy = isBusy(form.id);
  const params = { form: form.id, nsfw };
  const url = nsfw ? form.nsfw_ooc_extra_img : form.ooc_extra_img;
  return (
    <LinkRow
      label={extraLabel(nsfw)}
      disabled={busy}
      url={url}
      onSet={() => act('set_extra', params)}
      onClear={() => act('clear_extra', params)}
      form={form}
      image={extraSlot(nsfw)}
      checkShape
    >
      {!!url && (
        <div
          inert={busy}
          className={classes([
            'CharacterGallery__extraSize',
            busy && 'CharacterGallery__busy',
          ])}
        >
          <DragSlider
            // Its own pending value only clears when the server sends that same value, which an Undo may not
            key={form.revision}
            label="Maximum Width"
            hint="Percent of the text column. Small images keep their size."
            value={
              nsfw ? form.nsfw_ooc_extra_img_size : form.ooc_extra_img_size
            }
            minValue={data.extra_size_min}
            maxValue={data.extra_size_max}
            onChange={(size) => {
              if (isBusy(form.id)) {
                return;
              }
              settle.schedule((edit_seq) =>
                act('set_extra_size', { ...params, size, edit_seq }),
              );
            }}
          />
        </div>
      )}
    </LinkRow>
  );
};

const FLASH_MS = 700;

const rowKeys = (gallery: string[]) => {
  const seen: Record<string, number> = {};
  return gallery.map((url) => {
    seen[url] = (seen[url] ?? 0) + 1;
    return `${url}#${seen[url]}`;
  });
};

export const ArtSection = (props: { form: ImageForm; nsfw: boolean }) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { form, nsfw } = props;
  const gallery = (nsfw ? form.nsfw_img_gallery : form.img_gallery) ?? [];
  const params = { form: form.id, nsfw };
  const [moved, setMoved] = useState<{ from: string; order: number[] } | null>(
    null,
  );
  const [flashed, setFlashed] = useState<string | null>(null);
  const flashTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const busy = isBusy(form.id);
  const galleryKey = gallery.join('\n');
  const shownIndices =
    moved && busy && moved.from === galleryKey
      ? moved.order
      : gallery.map((_, index) => index);
  const shown = shownIndices.map((index) => gallery[index]);
  // A refused move leaves the gallery as it was, so its order would otherwise show again during the next update
  useEffect(() => {
    if (!busy) {
      setMoved(null);
    }
  }, [busy]);
  useEffect(
    () => () => {
      if (flashTimer.current !== null) {
        clearTimeout(flashTimer.current);
      }
    },
    [],
  );
  const sourceKeys = rowKeys(gallery);
  const keys = shownIndices.map((index) => sourceKeys[index]);

  const move = (index: number, direction: -1 | 1) => {
    const target = index + direction;
    if (isBusy(form.id) || target < 0 || target >= shown.length) {
      return;
    }
    const next = [...shownIndices];
    [next[index], next[target]] = [next[target], next[index]];
    setMoved({ from: galleryKey, order: next });
    setFlashed(sourceKeys[next[target]]);
    if (flashTimer.current !== null) {
      clearTimeout(flashTimer.current);
    }
    flashTimer.current = setTimeout(() => setFlashed(null), FLASH_MS);
    act('move_art', { ...params, index: index + 1, direction });
  };

  const scope = artScope(nsfw);
  const removedAt = form.undo_removed[scope];
  const removedRow = (position: number) =>
    removedAt === position && (
      <RemovedRow
        text={`${artLabel(nsfw, position)} removed`}
        busy={busy}
        onUndo={() =>
          act('undo_image', { form: form.id, image: removedPoint(scope) })
        }
      />
    );

  return (
    <Section
      title={`${galleryLabel(nsfw)} (${shown.length} of ${data.gallery_max})`}
    >
      {shown.map((url, index) => {
        const position = index + 1;
        return (
          <Fragment key={keys[index]}>
            {removedRow(position)}
            <LinkRow
              disabled={busy}
              label={artLabel(nsfw, position)}
              url={url}
              setText="Edit"
              tone={index % 2 === 0 ? 'light' : 'dark'}
              flash={flashed === keys[index]}
              onSet={() => act('set_art', { ...params, index: position })}
              onClear={() => act('remove_art', { ...params, index: position })}
              form={form}
              image={artSlot(nsfw, position)}
              background={
                form.card_backgrounds?.[artSlot(nsfw, shownIndices[index] + 1)]
              }
              move={{
                first: busy || index === 0,
                last: busy || index === shown.length - 1,
                onMove: (direction) => move(index, direction),
              }}
            />
          </Fragment>
        );
      })}
      {removedRow(shown.length + 1)}
      {shown.length < data.gallery_max && (
        <LinkRow
          label={artLabel(nsfw, shown.length + 1)}
          disabled={busy}
          url={null}
          tone={shown.length % 2 === 0 ? 'light' : 'dark'}
          onSet={() => act('add_art', params)}
        />
      )}
    </Section>
  );
};

/** Shown to their owner as text only, never loaded as media. */
export const BlockedLinks = (props: { form: ImageForm }) => {
  const { act, isBusy } = useGalleryBackend();
  const { form } = props;
  const blocked = form.blocked_links ?? [];
  const canUndo = form.undo_removed.blocked !== undefined;
  const busy = isBusy(form.id);
  if (!blocked.length && !canUndo) {
    return null;
  }
  return (
    <Section
      title={
        <Box inline color="average">
          <Icon name="exclamation-triangle" mr={0.5} />
          Hidden from others
        </Box>
      }
    >
      <Box color="label" mb={1}>
        Your links are hidden, as either the image hosting site is not allowed
        or the gallery is full.
      </Box>
      {blocked.map((entry, index) => (
        <Box key={`${entry.url}#${index}`} mb={0.5}>
          <Box bold mb={0.25}>
            {entry.label}
          </Box>
          <LinkControls
            label={`Hidden ${entry.label} Link ${index + 1}`}
            disabled={busy}
            url={entry.url}
            onClear={() =>
              act('remove_blocked_link', { form: form.id, index: index + 1 })
            }
          />
        </Box>
      ))}
      {canUndo && (
        <RemovedRow
          text="Hidden link removed"
          busy={busy}
          onUndo={() =>
            act('undo_image', { form: form.id, image: removedPoint('blocked') })
          }
        />
      )}
    </Section>
  );
};
