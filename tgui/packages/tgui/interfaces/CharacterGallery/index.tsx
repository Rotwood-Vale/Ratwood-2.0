import { useEffect, useLayoutEffect, useRef, useState } from 'react';
import { Box, Button, Icon, Section, Stack, Tabs } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { ArtSection, BlockedLinks, ExtraRow } from './ArtSection';
import { ArtworkSettings } from './ArtworkSettings';
import { BackdropSection } from './BackdropSection';
import { buttonSemantics } from './buttonSemantics';
import type { SidePreviewState } from './EditDialog/SidePreview';
import { UrlEditor } from './EditDialog/UrlEditor';
import {
  flushChanges,
  GalleryActionContext,
  type GalleryActions,
  type PendingChanges,
  useGalleryBackend,
} from './galleryBackend';
import {
  GalleryLedger,
  GalleryLedgerDivider,
  GalleryLedgerHeader,
  GalleryLedgerPane,
} from './GalleryLedger';
import { HeadshotSection } from './Headshot/HeadshotEditor';
import { ImageGuidelines } from './ImageGuidelines';
import { SourceSwitch } from './LinkRow';
import { formHasImages, HEADSHOT_SLOT, UNDO_CLEAR } from './slots';
import { Thumbnail } from './Thumbnail';
import { type Data, type FormId, type ImageForm, isArtEditor } from './types';
import { useWindowWidening } from './useWindowWidening';

type GalleryPage = 'overview' | 'headshot';
type HeadshotLayout = 'ledger' | 'page';
/** A Side Preview request, kept only for the dialog it was made in */
type KeyedSidePreview = SidePreviewState & { key: string };

type EditorToggle = {
  editorOpen: boolean;
  sideBySide: boolean;
  onToggleView: () => void;
  onEdit: () => void;
};

const UNHELD_ACTIONS = new Set(['select_form', 'preview', 'cancel_urls']);
/** How long a form stays busy waiting on the server, in case a runtime keeps it from finishing the action */
const IMAGE_UPDATE_TIMEOUT_MS = 10000;

const FORM_TABS: Record<FormId, string> = {
  character: 'Character',
  gnoll: 'Gnoll Form',
};

export const CharacterGallery = () => {
  const { act, data } = useBackend<Data>();
  const { generation } = data;
  const pending = useRef(
    new Map<FormId, { revision: number; generation: number }>(),
  ).current;
  const [, setVersion] = useState(0);
  const pendingChanges = useRef<PendingChanges>({
    flushers: new Set(),
    waiting: new Set(),
    lastSent: 0,
    nextSeq: 0,
    changed: () => setVersion((version) => version + 1),
  }).current;
  const { changed } = pendingChanges;
  const isBusy = (form?: FormId) =>
    data.forms.some((entry) => {
      const request = pending.get(entry.id);
      return (
        (!form || entry.id === form) &&
        request?.generation === generation &&
        entry.revision === request.revision
      );
    });
  const send: GalleryActions['act'] = (action, params) => {
    const form = params.form === 'gnoll' ? 'gnoll' : 'character';
    // The ref blocks a second click even before React renders the disabled controls
    const heldBack =
      action === 'save'
        ? isBusy()
        : !UNHELD_ACTIONS.has(action) && isBusy(form);
    if (heldBack) {
      return;
    }
    // Ahead of the hold below, which would drop a queued edit, unless this is that edit being sent
    if (params.edit_seq === undefined) {
      flushChanges(pendingChanges);
    }
    if (data.image_actions.includes(action)) {
      const request = { revision: params.revision as number, generation };
      pending.set(form, request);
      setTimeout(
        () => {
          if (pending.get(form) === request) {
            pending.delete(form);
            changed();
          }
        },
        data.confirm_actions.includes(action)
          ? data.prompt_timeout + IMAGE_UPDATE_TIMEOUT_MS
          : IMAGE_UPDATE_TIMEOUT_MS,
      );
      changed();
    }
    act(action, params);
  };
  return (
    <GalleryActionContext.Provider
      value={{ act: send, isBusy, pendingChanges }}
    >
      <CharacterGalleryContent />
    </GalleryActionContext.Provider>
  );
};

/** Gives the native window and its browser control the page's background, which otherwise shows white while the window grows */
const matchNativeBackground = () => {
  const rgb = window
    .getComputedStyle(document.body)
    .backgroundColor.match(/\d+/g);
  if (!rgb || rgb.length !== 3) {
    return;
  }
  const hex = rgb
    .map((part) => Number(part).toString(16).padStart(2, '0'))
    .join('');
  const color = `#${hex}`;
  Byond.winset(Byond.windowId, { 'background-color': color });
  Byond.winset(`${Byond.windowId}.browser`, { 'background-color': color });
};

const CharacterGalleryContent = () => {
  const { act, data, pendingChanges } = useGalleryBackend();
  const { config } = useBackend();
  const { forms, selected_form, generation, url_editor } = data;
  const [page, setPage] = useState<GalleryPage>('overview');
  const [editorView, setEditorView] = useState<HeadshotLayout>('ledger');
  const expanded = page === 'headshot' && editorView === 'ledger';
  const overviewHidden = page === 'headshot' && editorView === 'page';
  const dialogKey = `${generation}:${url_editor?.id}`;
  const artDialogKey = url_editor && isArtEditor(url_editor) ? dialogKey : null;
  const [readyArtDialogKey, setReadyArtDialogKey] = useState<string | null>(
    null,
  );
  const awaitingArtDialog =
    !!artDialogKey && artDialogKey !== readyArtDialogKey;
  const [sidePreview, setSidePreview] = useState<KeyedSidePreview | null>(null);
  const side = sidePreview?.key === dialogKey ? sidePreview : null;
  const scrollRef = useRef<HTMLDivElement>(null);
  const editorScrollRef = useRef<HTMLDivElement>(null);
  const getContent = () =>
    scrollRef.current?.closest<HTMLElement>('.CharacterGallery') ?? null;
  const releaseWindow = useWindowWidening(
    expanded,
    artDialogKey,
    side?.open ? side.growth : undefined,
    !!config.window.scale,
    getContent,
    () => {
      setReadyArtDialogKey(artDialogKey);
      // A closed Side Preview is dropped once the window is back, which lets the editor fill it again
      setSidePreview((current) => {
        if (!current || current !== side || current.settled) return current;
        return current.open ? { ...current, settled: true } : null;
      });
    },
  );
  useLayoutEffect(() => {
    if (awaitingArtDialog) {
      const content = getContent();
      if (content) {
        content.style.setProperty(
          '--gallery-held-overview-width',
          `${content.clientWidth}px`,
        );
        return () => {
          content.style.removeProperty('--gallery-held-overview-width');
        };
      }
    }
  }, [awaitingArtDialog, artDialogKey]);
  useEffect(() => matchNativeBackground(), []);
  // The server never answers an edit sent for the previous character, so lastSent starts over
  useEffect(() => {
    setPage('overview');
    pendingChanges.lastSent = 0;
    pendingChanges.changed();
  }, [generation]);
  const [formId, setFormId] = useState(selected_form);
  useEffect(() => setFormId(selected_form), [selected_form]);
  // Depends on overviewHidden rather than page, unlike the editor's effect below. With editorView 'ledger' the
  // headshot editor opens beside the overview, and a page dependency would jump the overview back to the top on
  // every expand or collapse
  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = 0;
    }
  }, [overviewHidden, formId]);
  useEffect(() => {
    if (editorScrollRef.current) {
      editorScrollRef.current.scrollTop = 0;
    }
  }, [page, formId]);
  const form = forms.find((entry) => entry.id === formId) ?? forms[0];
  const collapseHeadshot = () => {
    setPage('overview');
    scrollRef.current
      ?.querySelector<HTMLElement>('.CharacterGallery__headshotOpener')
      ?.focus({ preventScroll: true });
  };
  const selectForm = (id: FormId) => {
    setFormId(id);
    act('select_form', { form: id });
  };

  return (
    <Window
      title={`Character Gallery: ${form.name || FORM_TABS[form.id]}`}
      width={680}
      height={860}
      onBeforeClose={() => {
        flushChanges(pendingChanges);
        releaseWindow();
      }}
    >
      {!!url_editor && (
        <UrlEditor
          key={dialogKey}
          editor={url_editor}
          awaitingWindow={awaitingArtDialog}
          side={side}
          onSideChange={(next) => setSidePreview({ ...next, key: dialogKey })}
        />
      )}
      <Window.Content>
        <div inert={!!url_editor} className="CharacterGallery__root">
          <Stack
            key={generation}
            fill
            vertical
            className={classes([
              'CharacterGallery',
              expanded && 'CharacterGallery--expanded',
            ])}
          >
            <FormTabs form={form} onSelect={selectForm} />
            <Stack.Item grow basis={0} className="CharacterGallery__viewport">
              <GalleryLedger expanded={expanded}>
                <div
                  className="CharacterGallery__scroll"
                  ref={scrollRef}
                  hidden={overviewHidden}
                >
                  <OverviewPage
                    form={form}
                    editorOpen={page === 'headshot'}
                    sideBySide={editorView === 'ledger'}
                    onToggleView={() =>
                      setEditorView(editorView === 'ledger' ? 'page' : 'ledger')
                    }
                    onEdit={() => setPage(expanded ? 'overview' : 'headshot')}
                  />
                </div>
                {expanded && (
                  <GalleryLedgerDivider
                    label="Collapse Headshot Editor"
                    onClick={collapseHeadshot}
                  />
                )}
                <GalleryLedgerPane
                  hidden={page !== 'headshot'}
                  ref={editorScrollRef}
                >
                  <HeadshotEditorPage
                    form={form}
                    sideBySide={editorView === 'ledger'}
                    onClose={() => setPage('overview')}
                  />
                </GalleryLedgerPane>
              </GalleryLedger>
            </Stack.Item>
            <SaveFooter />
          </Stack>
        </div>
      </Window.Content>
    </Window>
  );
};

const FormTabs = (props: {
  form: ImageForm;
  onSelect: (id: FormId) => void;
}) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { form, onSelect } = props;
  return (
    <Stack.Item shrink={0} position="relative">
      <Stack align="center" className="CharacterGallery__navigation">
        <Stack.Item grow>
          <Tabs>
            {data.forms.map((entry) => (
              <Tabs.Tab
                key={entry.id}
                selected={entry.id === form.id}
                {...buttonSemantics}
                aria-pressed={entry.id === form.id}
                onClick={() => onSelect(entry.id)}
                onKeyDown={(event) => {
                  if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    onSelect(entry.id);
                  }
                }}
              >
                {FORM_TABS[entry.id]}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="eye"
            tooltip="Open your examine panel as others see it"
            onClick={() => act('preview', { form: form.id })}
          >
            Preview
          </Button>
        </Stack.Item>
      </Stack>
      {isBusy(form.id) && (
        <div
          role="status"
          aria-live="polite"
          className="CharacterGallery__busyStatus"
        >
          <Icon name="spinner" spin mr={0.5} />
          Updating images…
        </div>
      )}
    </Stack.Item>
  );
};

const OverviewPage = (props: { form: ImageForm } & EditorToggle) => {
  const { form } = props;
  return (
    <div className="CharacterGallery__workspace">
      <ImageGuidelines scope="all" />
      <HeadshotSummary {...props} />
      <Section title="OOC Extras">
        {[false, true].map((nsfw) => (
          <ExtraRow
            key={`${form.id}-${nsfw ? 'nsfw' : 'sfw'}`}
            form={form}
            nsfw={nsfw}
          />
        ))}
      </Section>
      <ArtworkSettings key={form.id} form={form} />
      {[false, true].map((nsfw) => (
        <ArtSection
          key={`${form.id}-${nsfw ? 'nsfw' : 'sfw'}`}
          form={form}
          nsfw={nsfw}
        />
      ))}
      <BackdropSection form={form} />
      <BlockedLinks form={form} />
      <ClearFormControls form={form} />
    </div>
  );
};

const HeadshotSummary = (props: { form: ImageForm } & EditorToggle) => {
  const { form, editorOpen, sideBySide, onToggleView, onEdit } = props;
  let editIcon = 'pen';
  if (sideBySide) {
    editIcon = editorOpen ? 'chevron-left' : 'chevron-right';
  }
  return (
    <Section>
      <div className="CharacterGallery__summary">
        <Thumbnail label="Headshot Overview" url={form.headshot} />
        <div>
          <Box bold fontSize="1.15em">
            Headshot
          </Box>
          {!form.headshot && <Box color="label">No image added</Box>}
        </div>
        <div>
          <Button
            className="CharacterGallery__headshotOpener"
            icon={editIcon}
            onClick={onEdit}
          >
            {sideBySide ? (
              // Both labels stay rendered, stacked by CharacterGallery__stableLabel with the aria-hidden one invisible, so the
              // button is always as wide as the longer label. Rendering only the current label changes the button's width on
              // each expand or collapse and shifts the controls below it
              <span className="CharacterGallery__stableLabel">
                <span aria-hidden={editorOpen}>Expand Headshot Editor</span>
                <span aria-hidden={!editorOpen}>Collapse Headshot Editor</span>
              </span>
            ) : (
              'Edit Headshot'
            )}
          </Button>
          <Box mt={0.5}>
            <Button.Checkbox
              className="CharacterGallery__editorToggle"
              checked={sideBySide}
              disabled={sideBySide && editorOpen}
              aria-disabled={sideBySide && editorOpen}
              onClick={onToggleView}
            >
              Side-by-Side Editor
            </Button.Checkbox>
          </Box>
          <SourceSwitch form={form} image={HEADSHOT_SLOT} label="Headshot" />
        </div>
      </div>
    </Section>
  );
};

const ClearFormControls = (props: { form: ImageForm }) => {
  const { act, isBusy } = useGalleryBackend();
  const { form } = props;
  const busy = isBusy(form.id);
  return (
    <Box className="CharacterGallery__clear">
      {Object.keys(form.alternates ?? {}).length > 0 && (
        <Box mb={1}>
          <Button
            icon="exchange-alt"
            disabled={busy}
            onClick={() => act('swap_all_urls', { form: form.id })}
          >
            Swap All Images
          </Button>
        </Box>
      )}
      <Button
        icon="trash"
        color="bad"
        disabled={busy || !formHasImages(form)}
        tooltip={`Remove every image of your ${form.id === 'gnoll' ? 'gnoll form' : 'character'}`}
        onClick={() => act('clear_all', { form: form.id })}
      >
        Clear All Images
      </Button>
      {!!form.undo_clear && (
        <Button
          icon="undo"
          disabled={busy}
          tooltip="Bring back the images the last Clear removed"
          onClick={() =>
            act('undo_image', {
              form: form.id,
              image: UNDO_CLEAR,
            })
          }
        >
          Undo Clear
        </Button>
      )}
    </Box>
  );
};

const HeadshotEditorPage = (props: {
  form: ImageForm;
  sideBySide: boolean;
  onClose: () => void;
}) => {
  const { form, sideBySide, onClose } = props;
  return (
    <>
      <GalleryLedgerHeader
        title="Headshot Editor"
        sideBySide={sideBySide}
        onClose={sideBySide ? undefined : onClose}
      />
      <HeadshotSection key={form.id} form={form} />
    </>
  );
};

const SaveFooter = () => {
  const { act, data, isBusy, pendingChanges } = useGalleryBackend();
  if (!data.can_save) {
    return null;
  }
  const busy = isBusy();
  const sendingEdits =
    pendingChanges.waiting.size > 0 || pendingChanges.lastSent > data.edit_seq;
  return (
    <Stack.Item shrink={0} className="CharacterGallery__footer">
      <div className="CharacterGallery__save">
        <Box color="label">
          Saves the entire character slot.{' '}
          <span role="status" aria-live="polite">
            {(sendingEdits || !!data.gallery_dirty) && (
              <Box inline color="average">
                Unsaved changes.
              </Box>
            )}
          </span>
        </Box>
        <Button
          color="good"
          icon="save"
          bold
          disabled={busy}
          tooltip={busy ? 'Waiting for the image update.' : undefined}
          onClick={() => act('save')}
        >
          Save Character
        </Button>
      </div>
      <div role="status" aria-live="polite">
        {!!data.save_feedback && (
          <Box mt={0.5} color="bad">
            {data.save_feedback.message}
          </Box>
        )}
      </div>
    </Stack.Item>
  );
};
