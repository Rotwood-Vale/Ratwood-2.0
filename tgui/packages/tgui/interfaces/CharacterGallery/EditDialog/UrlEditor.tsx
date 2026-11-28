import {
  type MouseEvent,
  useEffect,
  useLayoutEffect,
  useRef,
  useState,
} from 'react';
import {
  Box,
  Button,
  Icon,
  Modal,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { ART_VIEW_LABELS } from '../../common/artViewSettings';
import { artIndex } from '../../common/gallerySlots';
import { layoutScale } from '../../common/layoutScale';
import {
  ARTWORK_RATIO_TALL_MAX,
  PICTURE_PIXELS_MAX,
  PICTURE_RATIO_TALL_MAX,
  PICTURE_RATIO_WIDE_MAX,
} from '../../common/pictureSize';
import { shownBackdrop } from '../../ExamineGallery/Backdrop/backdrops';
import { galleryEffects } from '../../ExamineGallery/effects';
import {
  type ExamineArtworkArea,
  ExamineArtworkMeasure,
} from '../../ExaminePanelLayout';
import { buttonRole } from '../buttonSemantics';
import { useCopyUrl } from '../clipboard';
import { useGalleryBackend } from '../galleryBackend';
import { growableWidth } from '../GalleryEditorGeometry';
import { GallerySelect } from '../GallerySelect';
import { guidelineScope, ImageGuidelines } from '../ImageGuidelines';
import { HEADSHOT_SLOT } from '../slots';
import { isArtEditor, type UrlEditorData } from '../types';
import { CropPanel } from './CropPanel';
import { saveUrlsPayload } from './saveUrlsPayload';
import {
  SidePreview,
  type SidePreviewState,
  sidePreviewWidth,
} from './SidePreview';
import { ALTERNATE_TOOLTIP, SourceRow } from './SourceRow';
import { useArtworkPopup } from './useArtworkPopup';
import { useFocusTrap } from './useFocusTrap';
import { useSourceDrafts } from './useSourceDrafts';

const extensionList = (extensions: string[]) => {
  const names = extensions.map((extension) => extension.toUpperCase());
  const last = names.pop();
  return names.length ? `${names.join(', ')} or ${last}.` : `${last}.`;
};

const PREVIEW_LAYOUT_OPTIONS = [
  { value: 'popup', label: 'Pop-up' },
  { value: 'side', label: 'Side' },
];

export const UrlEditor = (props: {
  editor: UrlEditorData;
  awaitingWindow: boolean;
  side: SidePreviewState | null;
  onSideChange: (side: SidePreviewState) => void;
}) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { editor, awaitingWindow, side, onSideChange } = props;
  const placement = data.artwork_preview_placement;
  const sideMode = placement === 'side';
  const busy = isBusy(editor.form);
  const isHeadshot = editor.image === HEADSHOT_SLOT;
  const isArt = isArtEditor(editor);
  const drafts = useSourceDrafts(editor, data.link_max_length);
  const [activeAlternate, setActiveAlternate] = useState(
    !!editor.active_alternate,
  );
  const [showAlternate, setShowAlternate] = useState(!!editor.alternate);
  const [panelRow, setPanelRow] = useState(0);
  const panelAlternate =
    showAlternate && panelRow === 1 ? !activeAlternate : activeAlternate;
  const source = panelAlternate ? drafts.alternate : drafts.main;
  const popup = useArtworkPopup(editor, source, panelAlternate);
  const form = data.forms.find((form) => form.id === editor.form);
  const backdrop = form?.image_backdrop;
  const nsfw = editor.image.startsWith('nsfw_art_');
  const category = nsfw ? form?.nsfw_img_gallery : form?.img_gallery;
  const hasThumbnails = (category?.length ?? 0) + Number(!editor.main) > 1;
  const [openingArea, setOpeningArea] = useState<ExamineArtworkArea | null>(
    null,
  );
  const currentValue = activeAlternate ? drafts.alternate.url : drafts.main.url;
  const copier = useCopyUrl();
  const awaitingRef = useRef<HTMLDivElement>(null);
  const layerRef = useRef<HTMLDivElement>(null);
  const dialogRef = useRef<HTMLDivElement>(null);
  const trapFocus = useFocusTrap(dialogRef);
  const mainRef = useRef<HTMLInputElement>(null);
  const alternateRef = useRef<HTMLInputElement>(null);
  const closeSide = () =>
    side?.open && onSideChange({ ...side, open: false, settled: false });
  useEffect(() => {
    if (!sideMode) closeSide();
  }, [sideMode]);
  // Read while rendering, as the window behind goes inert and drops its focus before effects run
  const previousFocus = useRef(document.activeElement as HTMLElement | null);
  useEffect(() => () => previousFocus.current?.focus(), []);
  useLayoutEffect(() => {
    if (awaitingWindow) {
      awaitingRef.current?.focus({ preventScroll: true });
      return;
    }
    const input = (activeAlternate ? alternateRef : mainRef).current;
    if (input && !input.disabled) {
      input.focus();
    } else {
      dialogRef.current
        ?.querySelector<HTMLElement>(
          '.CharacterGallery__urlActions [tabindex="0"]',
        )
        ?.focus({ preventScroll: true });
    }
  }, [awaitingWindow]);
  useEffect(() => {
    if (showAlternate && !editor.alternate) {
      (activeAlternate ? mainRef : alternateRef).current?.focus();
    }
  }, [showAlternate]);
  // Apply disables the inputs and takes focus with it. Watching busy too catches the same error twice
  useEffect(() => {
    if (editor.error && !busy) {
      (activeAlternate ? alternateRef : mainRef).current?.focus();
    }
  }, [editor.error, busy]);
  const cancel = () => act('cancel_urls', { editor_id: editor.id });
  const dialogLabel = isArt ? `Edit ${editor.label}` : `${editor.label} URLs`;
  if (awaitingWindow) {
    return (
      <div
        ref={awaitingRef}
        role="dialog"
        aria-modal="true"
        aria-busy="true"
        aria-label={dialogLabel}
        tabIndex={-1}
        className="CharacterGallery__pendingUrlDialog"
        onKeyDown={(event) => {
          if (event.key === 'Escape') {
            event.preventDefault();
            cancel();
          } else if (event.key === 'Tab') {
            event.preventDefault();
          }
        }}
      />
    );
  }
  const keepEditorFocus = (event: MouseEvent) => {
    if (dialogRef.current?.contains(document.activeElement)) {
      event.preventDefault();
    }
  };
  const openSide = async () => {
    const layer = layerRef.current;
    const viewer = openingArea?.gallery;
    if (!layer || !viewer) return;
    const toScreen = layoutScale(layer, layer.getBoundingClientRect());
    const room = (await growableWidth()) / toScreen;
    const growth =
      sidePreviewWidth(viewer, room, layer.offsetHeight) * toScreen;
    if (
      shownBackdrop(galleryEffects(data.gallery).backdrop, backdrop).kind ===
      'scene'
    ) {
      act('preview_scene', { form: editor.form, editor_id: editor.id });
    }
    onSideChange({
      open: true,
      settled: false,
      held: layer.offsetWidth,
      growth,
    });
  };
  const previewOn = sideMode ? !!side?.open : popup.open;
  const togglePreview = () => {
    if (!sideMode) {
      popup.toggle();
    } else if (side?.open) {
      closeSide();
    } else {
      openSide();
    }
  };
  const actions = (
    <Stack
      className="CharacterGallery__urlActions"
      align="center"
      justify="flex-end"
      wrap="wrap"
    >
      {isArt && (
        <>
          <label className="CharacterGallery__previewLayout">
            Preview Layout
            <GallerySelect
              aria-label="Preview Layout"
              value={placement}
              options={PREVIEW_LAYOUT_OPTIONS}
              onChange={(value) =>
                act('set_artwork_preview_placement', {
                  editor_id: editor.id,
                  form: editor.form,
                  value,
                })
              }
            />
          </label>
          <Tooltip content="Show or hide the artwork as viewers see it.">
            <span>
              <Button
                {...buttonRole}
                compact
                icon="eye"
                selected={previewOn}
                aria-pressed={previewOn}
                disabled={
                  busy ||
                  (!!side && !side.open) ||
                  (!previewOn && !source.previewUrl)
                }
                onMouseDown={keepEditorFocus}
                onClick={togglePreview}
              >
                Preview
              </Button>
            </span>
          </Tooltip>
        </>
      )}
      <Button compact onClick={cancel}>
        Cancel
      </Button>
      <Button
        compact
        disabled={busy || !currentValue.trim()}
        onClick={() =>
          act(
            'save_urls',
            saveUrlsPayload(editor.id, drafts, activeAlternate, isArt),
          )
        }
      >
        Apply
      </Button>
    </Stack>
  );
  const guidelines = <ImageGuidelines scope={guidelineScope(editor.image)} />;
  const linkRequirements = (
    <Box color="label" mb={1}>
      Direct HTTPS links from {data.link_hosts}.{' '}
      {extensionList(editor.extensions)}
      {isArt &&
        ` Artwork can be up to ${PICTURE_PIXELS_MAX / 1_000_000} MP, 1:${ARTWORK_RATIO_TALL_MAX} tall or ${PICTURE_RATIO_WIDE_MAX}:1 wide. Past 1:${PICTURE_RATIO_TALL_MAX} tall it opens in ${ART_VIEW_LABELS.scroll} only.`}
    </Box>
  );
  // Sits in the alternate's row, which would otherwise take the framing column on press or focus
  const swapImages = (
    <span
      onPointerDown={(event) => event.stopPropagation()}
      onFocus={(event) => event.stopPropagation()}
    >
      <Button
        compact
        icon="exchange-alt"
        disabled={
          busy || !drafts.main.url.trim() || !drafts.alternate.url.trim()
        }
        onClick={() => {
          setActiveAlternate(!activeAlternate);
          // Rows count from the image in use, so the framing column keeps its picture
          if (showAlternate) setPanelRow(1 - panelRow);
          copier.clear();
        }}
      >
        Swap Images
      </Button>
    </span>
  );
  const footer = (
    <div className="CharacterGallery__urlFooter">
      {!!editor.error && (
        <div role="alert">
          <Box color="bad" mb={1}>
            {editor.error}
          </Box>
        </div>
      )}
      <div role="status" aria-live="polite">
        {copier.message}
        {busy && (
          <Box color="label" mb={0.5}>
            <Icon name="spinner" spin mr={0.5} />
            Updating images…
          </Box>
        )}
      </div>
      {actions}
    </div>
  );
  return (
    <>
      {/* Held at its width from before the Side Preview, so the editor never changes as the window grows */}
      <div
        ref={layerRef}
        className="CharacterGallery__urlLayer"
        style={side ? { width: side.held } : undefined}
      >
        <Modal
          className={classes([
            'CharacterGallery__urlModal',
            isArt && 'CharacterGallery__urlModal--art',
          ])}
          onEscape={cancel}
        >
          <div
            ref={dialogRef}
            className="CharacterGallery__urlDialog"
            role="dialog"
            aria-modal="true"
            aria-label={dialogLabel}
            onKeyDown={trapFocus}
          >
            <div className="CharacterGallery__urlEditor">
              <Section title={isArt ? editor.label : `${editor.label} URLs`}>
                <div className="CharacterGallery__urlBody">
                  <div className="CharacterGallery__urlColumns">
                    <div
                      className={classes([
                        'CharacterGallery__urlFields',
                        isArt &&
                          !showAlternate &&
                          'CharacterGallery__urlFields--single',
                      ])}
                    >
                      {!isArt && guidelines}
                      {/* Row 0 edits whichever image is currently in use */}
                      {[activeAlternate, !activeAlternate].map(
                        (isAlternate, index) => {
                          if (index === 1 && !showAlternate) {
                            return null;
                          }
                          return (
                            <SourceRow
                              key={String(isAlternate)}
                              index={index}
                              source={
                                isAlternate ? drafts.alternate : drafts.main
                              }
                              inputRef={isAlternate ? alternateRef : mainRef}
                              isArt={isArt}
                              busy={busy}
                              maxLength={data.link_max_length}
                              copier={copier}
                              onActivate={() => setPanelRow(index)}
                              action={index === 1 && swapImages}
                            />
                          );
                        },
                      )}
                      {isArt && linkRequirements}
                      {!showAlternate && (
                        <Box mb={isArt ? 0.25 : 1}>
                          <Button
                            compact
                            icon="plus"
                            tooltip={ALTERNATE_TOOLTIP}
                            disabled={busy}
                            onClick={() => setShowAlternate(true)}
                          >
                            Add Alternate Image
                          </Button>
                        </Box>
                      )}
                      {!isArt && linkRequirements}
                      {isHeadshot && (
                        <Box color="label" mb={1}>
                          Each link keeps its own framing.
                        </Box>
                      )}
                      {isArt && guidelines}
                    </div>
                    {/* The art dialog's actions sit in the framing column, the others' under the fields */}
                    {isArt && (
                      <CropPanel
                        source={source}
                        isAlternate={panelAlternate}
                        showAlternate={showAlternate}
                        panelRow={panelRow}
                        setPanelRow={setPanelRow}
                        busy={busy}
                        openingArea={openingArea?.reader}
                      >
                        {footer}
                      </CropPanel>
                    )}
                  </div>
                  {!isArt && footer}
                </div>
              </Section>
            </div>
            {isArt && !!source.previewUrl && (
              <ExamineArtworkMeasure
                onMeasure={setOpeningArea}
                hasThumbnails={hasThumbnails}
                plain={!!data.gallery?.plain}
              />
            )}
          </div>
        </Modal>
      </div>
      {!!side?.open && side.settled && openingArea && (
        <SidePreview
          left={side.held}
          area={openingArea.gallery}
          form={form}
          index={artIndex(nsfw, editor.image)}
          source={source}
          alternate={panelAlternate}
          gallery={data.gallery}
          nsfw={nsfw}
        />
      )}
    </>
  );
};
