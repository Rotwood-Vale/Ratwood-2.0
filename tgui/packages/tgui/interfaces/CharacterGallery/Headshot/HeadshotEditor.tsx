import { useState } from 'react';
import { Box, Button, Icon, Section } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { DragSlider } from '../../../components';
import { HEADSHOT_PANEL_SIZE } from '../../common/HeadshotFrame';
import { pictureSizeLimitText } from '../../common/pictureSize';
import { useGalleryBackend } from '../galleryBackend';
import { LinkControls, MediaStatus } from '../LinkRow';
import { HEADSHOT_SLOT } from '../slots';
import type { ImageForm } from '../types';
import { useMediaStatus } from '../useMediaStatus';
import { ChatAppearance } from './ChatAppearance';
import { overflowsAxis, zoomCeiling, zoomLimits } from './framing';
import { FramingCanvas } from './FramingCanvas';
import { useFramingDraft } from './useFramingDraft';

/** The zoom limit in percent of even the smallest picture, however blurry that gets. */
const ZOOM_LIMIT_MIN = 300;
const BLUR_WARNING_ENLARGEMENT = 1.5;

const arrowKeys = (
  <>
    <kbd>←</kbd> <kbd>↑</kbd> <kbd>↓</kbd> <kbd>→</kbd>
  </>
);

/** The position sliders in the order they show */
const POSITION_AXES = [
  {
    axis: 0,
    field: 'x',
    label: 'Horizontal',
    hint: '0 shows the left edge of the picture, 100 its right edge.',
    direction: 'horizontally',
  },
  {
    axis: 1,
    field: 'y',
    label: 'Vertical',
    hint: '0 shows the top edge of the picture, 100 its bottom edge.',
    direction: 'vertically',
  },
] as const;

export const HeadshotSection = (props: { form: ImageForm }) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { form } = props;
  const busy = isBusy(form.id);
  const media = useMediaStatus(form.headshot);
  const { retry } = media;
  const size = media.tooLarge ? null : media.size;
  const unloaded =
    media.tooLarge && media.size ? pictureSizeLimitText(...media.size) : null;
  const [showSliders, setShowSliders] = useState(false);
  const draft = useFramingDraft(form);
  const { framing, committed, follow, commit, abandon, discard } = draft;

  const { sharpZoom, zoomLimit } = zoomLimits(
    size,
    HEADSHOT_PANEL_SIZE,
    ZOOM_LIMIT_MIN,
    data.zoom_max,
  );
  const blurry =
    media.ready && framing.zoom > sharpZoom * BLUR_WARNING_ENLARGEMENT;
  const sharpNote =
    sharpZoom >= data.zoom_min
      ? ` Sharp up to ${Math.min(sharpZoom, data.zoom_max)}%.`
      : '';
  // Given to FramingSlider as busy, which keeps each slider in place but inert and dimmed, never folded into enabled,
  // whose false swaps the slider for its unavailable note. Folded in, the sliders flip to the note and back while a
  // new picture loads
  const slidersLocked = busy || (!!size && !media.ready);

  const urlButton = (
    <Box mt={0.5}>
      <Button
        fluid
        textAlign="center"
        icon={form.headshot ? 'pen' : 'plus'}
        disabled={busy}
        onClick={() => act('set_headshot', { form: form.id })}
      >
        {form.headshot ? 'Change Headshot URL' : 'Add Headshot URL'}
      </Button>
    </Box>
  );

  if (!form.headshot) {
    return (
      <Section title="Headshot">
        <div className="CharacterGallery__headshot">
          <div className="CharacterGallery__headshotColumn">
            <div className="CharacterGallery__headshotEmpty">No headshot</div>
            {urlButton}
            {form.undo.includes(HEADSHOT_SLOT) && (
              <Box mt={0.5}>
                <Button
                  fluid
                  textAlign="center"
                  icon="undo"
                  disabled={busy}
                  onClick={() =>
                    act('undo_image', { form: form.id, image: HEADSHOT_SLOT })
                  }
                >
                  Undo
                </Button>
              </Box>
            )}
          </div>
        </div>
      </Section>
    );
  }

  return (
    <>
      <Section title="Frame Headshot">
        <div className="CharacterGallery__headshot">
          <div
            inert={busy}
            className={classes([
              'CharacterGallery__headshotColumn',
              busy && 'CharacterGallery__busy',
            ])}
          >
            <FramingCanvas
              form={form}
              media={media}
              draft={draft}
              zoomLimit={zoomLimit}
            />
            {urlButton}
            {!!media.size && (
              <Box color="label" mt={0.5} textAlign="center">
                {media.ready
                  ? `${media.size[0]} × ${media.size[1]}`
                  : 'Loading…'}
              </Box>
            )}
            {blurry && (
              <Box color="average" mt={0.5} textAlign="center">
                <Icon name="exclamation-triangle" mr={0.5} />
                May look blurry in Examine Closer
              </Box>
            )}
            <Box color="label" mt={1} textAlign="center">
              Examine Closer always uses this square portrait.
            </Box>
          </div>
          <div className="CharacterGallery__framing">
            <MediaStatus
              media={media}
              statusMt={0.5}
              loading="Loading headshot…"
              retrying="Retrying headshot…"
              error="Couldn't load the image. Check the link."
              retryText="Retry Headshot"
            />
            <Box mt={1}>
              <FramingSlider
                key={draft.discards}
                label="Zoom"
                busy={slidersLocked}
                hint={`Enlarges the picture around the point being framed.${sharpNote}`}
                value={framing.zoom}
                minValue={data.zoom_min}
                maxValue={zoomCeiling(committed.zoom, zoomLimit)}
                enabled={!!size}
                unavailable={unloaded ?? 'Load the image before zooming it.'}
                onDrag={(zoom) => follow({ zoom })}
                onChange={(zoom) => commit({ zoom })}
                onAbandon={abandon}
              />
            </Box>
            <div className="CharacterGallery__headshotControlRow">
              <Box color="label">Framing</Box>
              <div className="CharacterGallery__framingActions">
                <Button
                  icon={showSliders ? 'chevron-up' : 'chevron-down'}
                  selected={showSliders}
                  aria-expanded={showSliders}
                  tooltip="Shows sliders for moving the picture, instead of dragging it."
                  onClick={() => setShowSliders(!showSliders)}
                >
                  Position Controls
                </Button>
                <Button
                  icon="undo"
                  disabled={busy}
                  tooltip="Back to the default square, framed from the top of the picture."
                  onClick={() => {
                    discard();
                    act('reset_framing', { form: form.id });
                  }}
                >
                  Reset Framing
                </Button>
              </div>
            </div>
            {showSliders && (
              <Box mt={0.5}>
                {POSITION_AXES.map((slider) => (
                  <FramingSlider
                    key={`${slider.field}:${draft.discards}`}
                    label={slider.label}
                    busy={slidersLocked}
                    hint={slider.hint}
                    value={framing[slider.field]}
                    enabled={overflowsAxis(size, framing.zoom, slider.axis)}
                    unavailable={
                      !size
                        ? (unloaded ?? 'Load the image before positioning it.')
                        : `Zoom in to move ${slider.direction}.`
                    }
                    onDrag={(value) => follow({ [slider.field]: value })}
                    onChange={(value) => commit({ [slider.field]: value })}
                    onAbandon={abandon}
                  />
                ))}
              </Box>
            )}
            <div className="CharacterGallery__headshotControlRow">
              <Box color="label">Image</Box>
              <LinkControls
                label="Headshot"
                disabled={busy}
                url={form.headshot}
                onClear={() => act('clear_headshot', { form: form.id })}
                form={form}
                image={HEADSHOT_SLOT}
                keepSwapMargin
              />
            </div>
            <details className="CharacterGallery__details">
              <summary>Precise Keyboard Controls</summary>
              <div className="CharacterGallery__keyboardHelp">
                <dl>
                  <dt>Move</dt>
                  <dd>{arrowKeys}</dd>
                  <dt>Larger Steps</dt>
                  <dd>
                    <kbd>Shift</kbd> + {arrowKeys}
                  </dd>
                  <dt>Zoom</dt>
                  <dd>
                    <kbd>−</kbd> <kbd>+</kbd>
                  </dd>
                </dl>
                Focus the portrait to start. Click outside to finish.
              </div>
            </details>
          </div>
        </div>
      </Section>
      {form.id === 'character' && (
        <ChatAppearance
          key={retry}
          form={form}
          framing={framing}
          retry={retry}
          busy={busy}
        />
      )}
    </>
  );
};

type FramingSliderProps = {
  busy?: boolean;
  label: string;
  hint: string;
  value: number;
  minValue?: number;
  maxValue?: number;
  enabled: boolean;
  unavailable: string;
  onDrag: (value: number) => void;
  onChange: (value: number) => void;
  onAbandon: () => void;
};

const FramingSlider = (props: FramingSliderProps) => {
  const { enabled, unavailable, onAbandon, busy, ...slider } = props;
  if (!enabled) {
    return (
      <Box
        className="CharacterGallery__inactivePosition"
        color="label"
        mb={0.75}
      >
        <div>
          <b>{slider.label}</b> {slider.value}%
        </div>
        <div>{unavailable}</div>
      </Box>
    );
  }
  return (
    <div
      className={classes([
        'CharacterGallery__framingSlider',
        busy && 'CharacterGallery__busy',
      ])}
      inert={busy}
      onLostPointerCapture={onAbandon}
    >
      <DragSlider {...slider} />
    </div>
  );
};
