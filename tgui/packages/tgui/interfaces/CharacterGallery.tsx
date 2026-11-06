import {
  createContext,
  type CSSProperties,
  type HTMLAttributes,
  type PointerEvent,
  type PropsWithChildren,
  type ReactNode,
  useContext,
  useEffect,
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
  Tabs,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { DragSlider } from '../components';
import { Window } from '../layouts';
import { HeadshotFrame } from './common/HeadshotFrame';

type FormId = 'character' | 'gnoll';
type GalleryPage = 'overview' | 'headshot';

// tgui-core forwards DOM attributes that its prop types do not declare.
const buttonSemantics = {
  role: 'button',
  tabIndex: 0,
} satisfies HTMLAttributes<HTMLDivElement>;

type ImageForm = {
  action_revision: number;
  source_revision: number;
  alternates: Record<
    string,
    { inactive_url: string; active_alternate: BooleanLike }
  >;
  framing_revision: number;
  id: FormId;
  name: string;
  headshot: string | null;
  headshot_zoom: number;
  headshot_x: number;
  headshot_y: number;
  headshot_framed: BooleanLike;
  ooc_extra_img: string | null;
  ooc_extra_img_size: number;
  nsfw_ooc_extra_img: string | null;
  nsfw_ooc_extra_img_size: number;
  img_gallery: string[] | null;
  nsfw_img_gallery: string[] | null;
};

type Data = {
  prompt_timeout: number;
  link_max_length: number;
  url_editor: {
    id: number;
    form: FormId;
    image: string;
    label: string;
    main: string | null;
    alternate: string | null;
    active_alternate: BooleanLike;
    error: string | null;
  } | null;
  slot: number;
  generation: number;
  settled_revision: number;
  gallery_dirty: BooleanLike;
  selected_form: FormId;
  can_save: BooleanLike;
  save_feedback: { success: BooleanLike; message: string } | null;
  headshot_frame_chat: BooleanLike;
  gallery_max: number;
  zoom_min: number;
  zoom_max: number;
  extra_size_min: number;
  extra_size_max: number;
  forms: ImageForm[];
};

type Framing = {
  zoom: number;
  x: number;
  y: number;
};

type PendingChanges = {
  flushers: Set<() => void>;
  requests: Map<object, { revision: number | null; generation: string }>;
  changed: () => void;
};

let nextFramingRevision = 0;
let nextSettledRevision = 0;
let nextImageRevision = 0;

const imageChanges = new Set([
  'save_urls',
  'use_url',
  'swap_all_urls',
  'clear_headshot',
  'clear_extra',
  'remove_art',
  'move_art',
  'clear_all',
]);
const imageControls = new Set([
  ...imageChanges,
  'set_headshot',
  'set_extra',
  'add_art',
  'set_art',
  'set_framing',
  'reset_framing',
  'set_extra_size',
  'set_frame_chat',
]);
const confirmationActions = new Set([
  'clear_headshot',
  'clear_extra',
  'remove_art',
  'clear_all',
]);
const IMAGE_UPDATE_TIMEOUT_MS = 10000;

type GalleryActions = {
  isBusy: (form?: FormId) => boolean;
  act: (action: string, params: Record<string, unknown>) => void;
};
const GalleryActionContext = createContext<GalleryActions | null>(null);

const useGalleryBackend = () => {
  const { data } = useBackend<Data>();
  const actions = useContext(GalleryActionContext);
  if (!actions) {
    throw new Error('useGalleryBackend requires GalleryActionContext.Provider');
  }
  const slot = data.slot;
  const generation = data.generation;
  return {
    data,
    isBusy: actions.isBusy,
    act: (action: string, params: Record<string, unknown> = {}) => {
      const form =
        params.form ??
        (action === 'save_urls' ? data.url_editor?.form : 'character');
      actions.act(action, {
        source_revision:
          data.forms.find((entry) => entry.id === form)?.source_revision ?? 0,
        ...params,
        form,
        slot,
        generation,
      });
    },
  };
};

const flushChanges = (pendingChanges: PendingChanges) => {
  for (const flush of pendingChanges.flushers) {
    flush();
  }
};

const copyUrl = async (url: string) => {
  try {
    await navigator.clipboard.writeText(url);
    return true;
  } catch {
    const previousFocus = document.activeElement as HTMLElement | null;
    const field = document.createElement('textarea');
    field.value = url;
    field.style.position = 'fixed';
    field.style.opacity = '0';
    document.body.appendChild(field);
    field.select();
    try {
      return document.execCommand('copy');
    } catch {
      return false;
    } finally {
      field.remove();
      previousFocus?.focus();
    }
  }
};

const SourceSwitch = (props: {
  form: ImageForm;
  image: string;
  pendingChanges: PendingChanges;
  disabled?: boolean;
}) => {
  const { act, isBusy } = useGalleryBackend();
  const { form, image, pendingChanges, disabled } = props;
  const source = form.alternates?.[image];
  if (!source) {
    return null;
  }
  return (
    <div className="CharacterGallery__sourceSwitch">
      <Button
        compact
        icon="exchange-alt"
        disabled={disabled || isBusy(form.id)}
        aria-label={`Swap images for ${image}`}
        onClick={() => {
          flushChanges(pendingChanges);
          act('use_url', {
            form: form.id,
            image,
            alternate: !source.active_alternate,
          });
        }}
      >
        Swap
      </Button>
    </div>
  );
};

const ImageGuidelines = (props: {
  scope: 'all' | 'general' | 'headshot' | 'sfw';
}) => (
  <details className="CharacterGallery__guidelines">
    <summary>Read Image Guidelines</summary>
    <Box mt={1}>
      <Box bold>General</Box>
      <ul>
        <li>
          Characters must be unquestionably adult in appearance, voice, and age.
        </li>
        <li>
          Keep characters consistent with the setting’s aesthetic. We allow
          flexibility within reason.
        </li>
        <li>
          Respect removal requests from artists and the owners of depicted
          characters.
        </li>
      </ul>
      {(props.scope === 'all' || props.scope === 'headshot') && (
        <>
          <Box bold>Headshot</Box>
          <p>
            Keep portraits non-explicit and avoid excessive sexualization.
            Cleavage and thigh-up compositions are acceptable; nipple slips or
            compositions dominated by sexual body parts are not.
          </p>
        </>
      )}
      {(props.scope === 'all' || props.scope === 'sfw') && (
        <>
          <Box bold>SFW gallery and OOC Extra</Box>
          <ul>
            <li>
              Risqué artwork, suggestive poses, mild blood/gore, and tasteful
              nudity are allowed within reason.
            </li>
            <li>
              No clearly visible genitals, arousal, anatomically explicit
              bulges, or visible nipples on breasts. Avoid excessive viscera,
              dismemberment, and overtly sexual poses.
            </li>
            <li>
              When unsure, use the NSFW gallery or ahelp.{' '}
              <b>We aim to be reasonable, not strict.</b>
            </li>
          </ul>
        </>
      )}
      <a
        href="https://wiki.ratwood.rip/index.php/Server_Rules"
        target="_blank"
        rel="noopener noreferrer"
      >
        Source: Server Rules
      </a>
    </Box>
  </details>
);

const UrlEditor = (props: { editor: NonNullable<Data['url_editor']> }) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { editor } = props;
  const [main, setMain] = useState(editor.main ?? '');
  const [alternate, setAlternate] = useState(editor.alternate ?? '');
  const [activeAlternate, setActiveAlternate] = useState(
    !!editor.active_alternate,
  );
  const [showAlternate, setShowAlternate] = useState(!!editor.alternate);
  const [copyMessage, setCopyMessage] = useState('');
  const alternateTooltip =
    'Optional second image or backup link. Swap between them without losing either URL.' +
    (editor.image === 'headshot' ? ' Each image keeps its own framing.' : '');
  const dialogRef = useRef<HTMLDivElement>(null);
  const mainRef = useRef<HTMLInputElement>(null);
  const alternateRef = useRef<HTMLInputElement>(null);
  useEffect(() => {
    const previousFocus = document.activeElement as HTMLElement | null;
    (editor.active_alternate ? alternateRef : mainRef).current?.focus();
    return () => previousFocus?.focus();
  }, []);
  useEffect(() => {
    if (showAlternate && !editor.alternate) {
      (activeAlternate ? mainRef : alternateRef).current?.focus();
    }
  }, [showAlternate]);
  const cancel = () => act('cancel_urls', { editor_id: editor.id });
  return (
    <Modal className="CharacterGallery__urlModal" onEscape={cancel}>
      <div
        ref={dialogRef}
        role="dialog"
        aria-modal="true"
        aria-label={`${editor.label} URLs`}
        onKeyDown={(event) => {
          if (event.key !== 'Tab') {
            return;
          }
          const focusable = [
            ...(dialogRef.current?.querySelectorAll<HTMLElement>(
              'input, [tabindex="0"], summary, details[open] a[href]',
            ) ?? []),
          ];
          const first = focusable[0];
          const last = focusable[focusable.length - 1];
          if (event.shiftKey && document.activeElement === first) {
            event.preventDefault();
            last?.focus();
          } else if (!event.shiftKey && document.activeElement === last) {
            event.preventDefault();
            first?.focus();
          }
        }}
      >
        <Section title={`${editor.label} URLs`}>
          <ImageGuidelines
            scope={
              editor.image === 'headshot'
                ? 'headshot'
                : editor.image.startsWith('nsfw_')
                  ? 'general'
                  : 'sfw'
            }
          />
          {[activeAlternate, !activeAlternate].map((isAlternate, index) => {
            if (index === 1 && !showAlternate) {
              return null;
            }
            const value = isAlternate ? alternate : main;
            const setValue = isAlternate ? setAlternate : setMain;
            const inputRef = isAlternate ? alternateRef : mainRef;
            const saved = isAlternate ? editor.alternate : editor.main;
            const label =
              index === 0 ? 'Current image URL' : 'Alternate image URL';
            return (
              <div
                key={String(isAlternate)}
                className="CharacterGallery__sourceRow"
              >
                <Thumbnail label={label} url={value === saved ? saved : null} />
                <div>
                  <Box bold mb={0.5}>
                    {index === 0 ? (
                      'Current image'
                    ) : (
                      <Tooltip content={alternateTooltip}>
                        <span tabIndex={0}>
                          Alternate image (optional){' '}
                          <Icon name="circle-question" />
                        </span>
                      </Tooltip>
                    )}
                  </Box>
                  <input
                    ref={inputRef}
                    className="Input CharacterGallery__urlInput"
                    aria-label={label}
                    maxLength={data.link_max_length}
                    disabled={isBusy(editor.form)}
                    value={value}
                    onChange={(event) => {
                      setValue(event.target.value);
                    }}
                  />
                  <Box mt={0.5}>
                    <Button
                      compact
                      disabled={!value.trim()}
                      onClick={async () => {
                        const copied = await copyUrl(value);
                        setCopyMessage(
                          copied
                            ? `${label} copied.`
                            : 'Select the URL and press Ctrl+C to copy.',
                        );
                        if (!copied) {
                          inputRef.current?.focus();
                          inputRef.current?.select();
                        }
                      }}
                    >
                      Copy
                    </Button>
                  </Box>
                </div>
              </div>
            );
          })}
          <Box mb={1}>
            {showAlternate ? (
              <Button
                compact
                icon="exchange-alt"
                disabled={
                  isBusy(editor.form) || !main.trim() || !alternate.trim()
                }
                onClick={() => {
                  setActiveAlternate(!activeAlternate);
                  setCopyMessage('');
                }}
              >
                Swap images
              </Button>
            ) : (
              <Button
                compact
                icon="plus"
                tooltip={alternateTooltip}
                disabled={isBusy(editor.form)}
                onClick={() => setShowAlternate(true)}
              >
                Add alternate image
              </Button>
            )}
          </Box>
          <Box color="label" mb={1}>
            Direct HTTPS links from Gyazo, Lensdump, Imgbox, Catbox, ImgBB or
            File Garden.{' '}
            {editor.image === 'extra' || editor.image === 'nsfw_extra'
              ? 'JPG, JPEG, PNG, GIF or MP4.'
              : 'JPG, JPEG or PNG.'}
          </Box>
          {editor.image === 'headshot' && (
            <Box color="label" mb={1}>
              Each URL keeps its own headshot framing.
            </Box>
          )}
          {!!editor.error && (
            <div role="alert">
              <Box color="bad" mb={1}>
                {editor.error}
              </Box>
            </div>
          )}
          <div role="status" aria-live="polite">
            {copyMessage}
            {isBusy(editor.form) && (
              <Box color="label" mb={0.5}>
                <Icon name="spinner" spin mr={0.5} />
                Updating images…
              </Box>
            )}
          </div>
          <Stack justify="flex-end">
            <Button compact onClick={cancel}>
              Cancel
            </Button>
            <Button
              compact
              disabled={
                isBusy(editor.form) ||
                !(activeAlternate ? alternate : main).trim()
              }
              onClick={() =>
                act('save_urls', {
                  editor_id: editor.id,
                  main,
                  alternate,
                  active_alternate: activeAlternate,
                })
              }
            >
              Apply
            </Button>
          </Stack>
        </Section>
      </div>
    </Modal>
  );
};

const FORM_TABS: Record<FormId, string> = {
  character: 'Character',
  gnoll: 'Gnoll Form',
};

const THUMBNAIL_SIZE = '64px';
/** The editor's side in pixels, near the examine panel's own headshot. */
const EDITOR_SIZE = 256;
/** The chat headshot's side in pixels. */
const CHAT_SIZE = 100;
const EMPTY_BACKGROUND = 'rgba(0, 0, 0, 0.3)';
const IMAGE_OUTLINE = '1px solid rgba(255, 255, 255, 0.3)';
/** How long changes must be quiet before they are sent, so a held key sends once. */
const SETTLE_MS = 300;
/** How far the pointer must move before a press on the picture counts as a drag, not a click. */
const DRAG_THRESHOLD_PX = 4;
/** Arrow key steps in pixels on screen, the second with Shift held. */
const NUDGE_PX = 1;
const NUDGE_PX_LARGE = 10;
/** Zoom steps in percent for each press of + or -, and for each wheel notch. */
const ZOOM_KEY_STEP = 1;
const WHEEL_ZOOM_STEP = 5;
/** The border while the picture is locked for framing, in the theme's own separator colour. */
const LOCKED_OUTLINE =
  '2px solid var(--section-separator-color, rgba(255, 255, 255, 0.6))';

/** Fits inventory artwork inside its thumbnail without cropping or distorting it. */
const thumbnailStyle: CSSProperties = {
  display: 'block',
  width: '100%',
  height: '100%',
  objectFit: 'contain',
};

const clamp = (value: number, min: number, max: number) =>
  Math.min(max, Math.max(min, value));

/** Drops anything that is not a real number, which the drag maths can produce on an axis with no room. */
const finiteOnly = (changes: Partial<Framing>): Partial<Framing> =>
  Object.fromEntries(
    Object.entries(changes).filter(([, value]) => Number.isFinite(value)),
  );

/** The picture's size once it covers a square of the given side at a zoom, before it is positioned. */
const coverSize = (
  natural: [number, number],
  side: number,
  zoom: number,
): [number, number] => {
  const scale = (side / Math.min(natural[0], natural[1])) * (zoom / 100);
  return [natural[0] * scale, natural[1] * scale];
};

/**
 * The position along one axis that keeps the picture point under the pointer where it is across a
 * zoom. Before and after are the picture's covered length at the old and new zoom.
 */
const keepUnderPointer = (
  position: number,
  before: number,
  after: number,
  side: number,
  pointer: number,
) => {
  const overflowAfter = after - side;
  if (overflowAfter <= 0) {
    return position;
  }
  const shownFrom = (position / 100) * Math.max(before - side, 0);
  const point = (shownFrom + pointer) / before;
  return clamp(((point * after - pointer) / overflowAfter) * 100, 0, 100);
};

/**
 * Sends the last scheduled call once calls have been quiet for SETTLE_MS. A call still waiting is
 * sent at once before saving or when the component goes away.
 */
const useSettled = (pendingChanges: PendingChanges) => {
  const { data } = useGalleryBackend();
  const generation = `${data.slot}:${data.generation}`;
  const token = useRef({}).current;
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const waiting = useRef<((revision: number) => void) | null>(null);
  const cancel = () => {
    if (timer.current !== null) {
      clearTimeout(timer.current);
      timer.current = null;
    }
    waiting.current = null;
    if (pendingChanges.requests.get(token)?.revision === null) {
      pendingChanges.requests.delete(token);
      pendingChanges.changed();
    }
  };
  const flush = () => {
    const send = waiting.current;
    cancel();
    if (send) {
      const revision =
        Math.max(nextSettledRevision, data.settled_revision ?? 0) + 1;
      nextSettledRevision = revision;
      pendingChanges.requests.set({}, { revision, generation });
      send(revision);
      pendingChanges.changed();
    }
  };
  useEffect(() => {
    pendingChanges.flushers.add(flush);
    return () => {
      pendingChanges.flushers.delete(flush);
      flush();
    };
  }, [pendingChanges]);
  const schedule = (send: (revision: number) => void) => {
    waiting.current = send;
    pendingChanges.requests.set(token, { revision: null, generation });
    pendingChanges.changed();
    if (timer.current !== null) {
      clearTimeout(timer.current);
    }
    timer.current = setTimeout(flush, SETTLE_MS);
  };
  return { schedule, cancel };
};

export const CharacterGallery = () => {
  const { act, data } = useBackend<Data>();
  const generation = `${data.slot}:${data.generation}`;
  const pending = useRef(
    new Map<
      FormId,
      {
        revision: number;
        generation: string;
        timer: ReturnType<typeof setTimeout>;
      }
    >(),
  ).current;
  const [, setVersion] = useState(0);
  const changed = () => setVersion((version) => version + 1);
  const isBusy = (form?: FormId) =>
    data.forms.some((entry) => {
      const request = pending.get(entry.id);
      return (
        (!form || entry.id === form) &&
        request?.generation === generation &&
        (entry.action_revision ?? 0) < request.revision
      );
    });
  useEffect(() => {
    for (const [form, request] of pending) {
      if (!isBusy(form)) {
        clearTimeout(request.timer);
        pending.delete(form);
      }
    }
  }, [data.forms, generation]);
  useEffect(
    () => () => {
      for (const request of pending.values()) {
        clearTimeout(request.timer);
      }
      pending.clear();
    },
    [],
  );
  const send: GalleryActions['act'] = (action, params) => {
    const form = params.form === 'gnoll' ? 'gnoll' : 'character';
    // The ref blocks a second click even before React renders the disabled controls.
    if (
      (imageControls.has(action) && isBusy(form)) ||
      (action === 'save' && isBusy())
    ) {
      return;
    }
    if (imageChanges.has(action)) {
      const revision =
        Math.max(
          nextImageRevision,
          data.forms.find((entry) => entry.id === form)?.action_revision ?? 0,
        ) + 1;
      nextImageRevision = revision;
      const previous = pending.get(form);
      if (previous) {
        clearTimeout(previous.timer);
      }
      const timer = setTimeout(
        () => {
          if (pending.get(form)?.revision === revision) {
            pending.delete(form);
            changed();
          }
        },
        confirmationActions.has(action)
          ? (data.prompt_timeout ?? 120000) + IMAGE_UPDATE_TIMEOUT_MS
          : IMAGE_UPDATE_TIMEOUT_MS,
      );
      pending.set(form, { revision, generation, timer });
      changed();
      act(action, { ...params, action_revision: revision });
      return;
    }
    act(action, params);
  };
  return (
    <GalleryActionContext.Provider value={{ act: send, isBusy }}>
      <CharacterGalleryContent />
    </GalleryActionContext.Provider>
  );
};

const CharacterGalleryContent = () => {
  const { act, data, isBusy } = useGalleryBackend();
  const { forms, selected_form } = data;
  const pendingChanges = useRef<PendingChanges>({
    flushers: new Set(),
    requests: new Map(),
    changed: () => undefined,
  }).current;
  const [pendingCount, setPendingCount] = useState(0);
  const [page, setPage] = useState<GalleryPage>('overview');
  const scrollRef = useRef<HTMLDivElement>(null);
  const generation = `${data.slot}:${data.generation}`;
  useEffect(() => setPage('overview'), [generation]);
  pendingChanges.changed = () =>
    setPendingCount(
      [...pendingChanges.requests.values()].filter(
        (request) => request.generation === generation,
      ).length,
    );
  useEffect(() => {
    for (const [token, request] of pendingChanges.requests) {
      if (
        request.generation !== generation ||
        (request.revision !== null && request.revision <= data.settled_revision)
      ) {
        pendingChanges.requests.delete(token);
      }
    }
    pendingChanges.changed();
  }, [generation, data.settled_revision]);
  const flushPending = () => {
    for (const flush of pendingChanges.flushers) {
      flush();
    }
  };
  // Follows the server, but switches at once on a click
  const [formId, setFormId] = useState(selected_form);
  useEffect(() => setFormId(selected_form), [selected_form]);
  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = 0;
    }
  }, [page, generation, formId]);
  const form = forms.find((entry) => entry.id === formId) ?? forms[0];
  const selectForm = (id: FormId) => {
    setFormId(id);
    act('select_form', { form: id });
  };
  const changePage = (next: GalleryPage) => {
    flushPending();
    setPage(next);
  };
  const switchSources = () => {
    flushPending();
    act('swap_all_urls', { form: form.id });
  };

  return (
    <Window
      title={`Character Gallery: ${form.name || FORM_TABS[form.id]}`}
      width={680}
      height={860}
      onBeforeClose={flushPending}
    >
      {!!data.url_editor && (
        <UrlEditor
          key={`${generation}:${data.url_editor.id}`}
          editor={data.url_editor}
        />
      )}
      <Window.Content>
        <Stack
          key={`${data.slot}:${data.generation}`}
          fill
          vertical
          className="CharacterGallery"
        >
          <Stack.Item shrink={0}>
            <Stack align="center" className="CharacterGallery__navigation">
              <Stack.Item grow>
                <Tabs>
                  {forms.map((entry) => (
                    <Tabs.Tab
                      key={entry.id}
                      selected={entry.id === form.id}
                      {...buttonSemantics}
                      aria-pressed={entry.id === form.id}
                      onClick={() => selectForm(entry.id)}
                      onKeyDown={(event) => {
                        if (event.key === 'Enter' || event.key === ' ') {
                          event.preventDefault();
                          selectForm(entry.id);
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
                  onClick={() => {
                    flushPending();
                    act('preview', { form: form.id });
                  }}
                >
                  Preview
                </Button>
              </Stack.Item>
            </Stack>
            {isBusy(form.id) && (
              <div role="status" aria-live="polite">
                <Box mt={0.5} color="label">
                  <Icon name="spinner" spin mr={0.5} />
                  Updating images…
                </Box>
              </div>
            )}
            {page !== 'overview' && (
              <Box mt={1}>
                <Button
                  icon="arrow-left"
                  onClick={() => changePage('overview')}
                >
                  Back to gallery
                </Button>
              </Box>
            )}
          </Stack.Item>
          <Stack.Item grow basis={0} className="CharacterGallery__viewport">
            <div className="CharacterGallery__scroll" ref={scrollRef}>
              <div
                hidden={page !== 'overview'}
                className="CharacterGallery__workspace"
                data-gallery-page="overview"
              >
                <ImageGuidelines scope="all" />
                <HeadshotSummary
                  form={form}
                  onEdit={() => changePage('headshot')}
                  pendingChanges={pendingChanges}
                />
                <Section title="OOC Extras">
                  <ExtraRow
                    key={`${form.id}-sfw:${form.source_revision}`}
                    form={form}
                    nsfw={false}
                    pendingChanges={pendingChanges}
                  />
                  <ExtraRow
                    key={`${form.id}-nsfw:${form.source_revision}`}
                    form={form}
                    nsfw
                    pendingChanges={pendingChanges}
                  />
                </Section>
                <ArtSection
                  key={`${form.id}-sfw`}
                  form={form}
                  nsfw={false}
                  pendingChanges={pendingChanges}
                />
                <ArtSection
                  key={`${form.id}-nsfw`}
                  form={form}
                  nsfw
                  pendingChanges={pendingChanges}
                />
                <Box className="CharacterGallery__clear">
                  {Object.keys(form.alternates ?? {}).length > 0 && (
                    <Box mb={1}>
                      <Button
                        compact
                        icon="exchange-alt"
                        disabled={isBusy(form.id)}
                        onClick={switchSources}
                      >
                        Swap All Images
                      </Button>
                    </Box>
                  )}
                  <Button
                    icon="trash"
                    color="bad"
                    disabled={isBusy(form.id)}
                    tooltip="Remove the headshot, both extras and both art galleries on this form, after confirmation"
                    onClick={() => {
                      flushPending();
                      act('clear_all', { form: form.id });
                    }}
                  >
                    Clear images for this form
                  </Button>
                </Box>
              </div>
              <div
                hidden={page !== 'headshot'}
                className="CharacterGallery__workspace"
                data-gallery-page="headshot"
              >
                <HeadshotSection
                  key={`${form.id}:${form.source_revision}`}
                  form={form}
                  pendingChanges={pendingChanges}
                />
              </div>
            </div>
          </Stack.Item>
          {!!data.can_save && (
            <Stack.Item shrink={0} className="CharacterGallery__footer">
              <div className="CharacterGallery__save">
                <Box color="label">Saves the entire character slot.</Box>
                <Button
                  color="good"
                  icon="save"
                  bold
                  disabled={isBusy()}
                  tooltip={
                    isBusy() ? 'Waiting for the image update.' : undefined
                  }
                  onClick={() => {
                    flushPending();
                    act('save');
                  }}
                >
                  Save character
                </Button>
              </div>
              <div role="status" aria-live="polite">
                {(pendingCount > 0 || !!data.gallery_dirty) && (
                  <Box color="average">Unsaved changes.</Box>
                )}
                {!!data.save_feedback && !data.save_feedback.success && (
                  <Box mt={0.5} color="bad">
                    {data.save_feedback.message}
                  </Box>
                )}
              </div>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const HeadshotSummary = (props: {
  form: ImageForm;
  onEdit: () => void;
  pendingChanges: PendingChanges;
}) => {
  const { form, onEdit, pendingChanges } = props;
  return (
    <Section>
      <div className="CharacterGallery__summary">
        <Thumbnail label="Headshot overview" url={form.headshot} />
        <div>
          <Box bold fontSize="1.15em">
            Headshot
          </Box>
          {!form.headshot && <Box color="label">No image added</Box>}
        </div>
        <div>
          <Button icon="pen" onClick={onEdit}>
            Edit headshot
          </Button>
          <SourceSwitch
            form={form}
            image="headshot"
            pendingChanges={pendingChanges}
          />
        </div>
      </div>
    </Section>
  );
};

type DragStart = {
  pointerX: number;
  pointerY: number;
  /** The editor's side on screen, which tgui scaling can make differ from EDITOR_SIZE. */
  side: number;
  x: number;
  y: number;
  /** Whether the pointer has passed DRAG_THRESHOLD_PX, making this a drag rather than a click. */
  moved: boolean;
};

const HeadshotSection = (props: {
  form: ImageForm;
  pendingChanges: PendingChanges;
}) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { form, pendingChanges } = props;
  const busy = isBusy(form.id);
  const saved: Framing = {
    zoom: form.headshot_zoom,
    x: form.headshot_x,
    y: form.headshot_y,
  };
  // Values the server has not confirmed yet, so the frame follows every change live
  const [pending, setPending] = useState<Partial<Framing>>({});
  const [size, setSize] = useState<[number, number] | null>(null);
  const [broken, setBroken] = useState(false);
  const [retry, setRetry] = useState(0);
  const [dragging, setDragging] = useState(false);
  // Locked from a click on the picture until focus leaves it, and only then do keys and the wheel frame it
  const [locked, setLocked] = useState(false);
  const [showSliders, setShowSliders] = useState(false);
  const editorRef = useRef<HTMLDivElement>(null);
  const drag = useRef<DragStart | null>(null);
  const sliderDrags = useRef(new Set<keyof Framing>());
  const unsent = useRef<Partial<Framing>>({});
  const revision = useRef(form.framing_revision);
  const pendingRevisions = useRef<Partial<Record<keyof Framing, number>>>({});
  const settle = useSettled(pendingChanges);
  useEffect(() => {
    const acknowledged = (
      Object.keys(pendingRevisions.current) as (keyof Framing)[]
    ).filter(
      (key) =>
        (pendingRevisions.current[key] ?? Infinity) <= form.framing_revision,
    );
    for (const key of acknowledged) {
      delete pendingRevisions.current[key];
    }
    setPending((previous) => {
      const rest = { ...previous };
      for (const key of acknowledged) {
        delete rest[key];
      }
      return rest;
    });
  }, [form.framing_revision]);
  useEffect(() => {
    settle.cancel();
    unsent.current = {};
    pendingRevisions.current = {};
    setPending({});
  }, [form.headshot]);
  useEffect(() => {
    setSize(null);
    setBroken(false);
    setRetry(0);
  }, [form.headshot]);
  const framing = { ...saved, ...pending };
  // Any change frames the headshot, so the editor crops as soon as one starts
  const framed = !!form.headshot_framed || Object.keys(pending).length > 0;

  const follow = (changes: Partial<Framing>) => {
    if (isBusy(form.id)) {
      return;
    }
    const real = finiteOnly(changes);
    for (const key of Object.keys(real) as (keyof Framing)[]) {
      pendingRevisions.current[key] = Infinity;
    }
    setPending((previous) => ({ ...previous, ...real }));
  };
  // Sends only the values that changed, so nothing unconfirmed from elsewhere rides along
  const commit = (changes: Partial<Framing>) => {
    if (isBusy(form.id)) {
      return;
    }
    const real = finiteOnly(changes);
    if (!Object.keys(real).length) {
      return;
    }
    revision.current = Math.max(nextFramingRevision, form.framing_revision) + 1;
    nextFramingRevision = revision.current;
    for (const key of Object.keys(real) as (keyof Framing)[]) {
      pendingRevisions.current[key] = revision.current;
    }
    setPending((previous) => ({ ...previous, ...real }));
    unsent.current = { ...unsent.current, ...real };
    settle.schedule((settled_revision) => {
      const sending = unsent.current;
      unsent.current = {};
      act('set_framing', {
        form: form.id,
        ...sending,
        revision: revision.current,
        settled_revision,
      });
    });
  };
  const dropPending = (keys: (keyof Framing)[]) => {
    for (const key of keys) {
      delete pendingRevisions.current[key];
    }
    setPending((previous) => {
      const rest = { ...previous };
      for (const key of keys) {
        delete rest[key];
      }
      return rest;
    });
  };

  const followSlider = (key: keyof Framing, value: number) => {
    sliderDrags.current.add(key);
    follow({ [key]: value });
  };
  const commitSlider = (key: keyof Framing, value: number) => {
    sliderDrags.current.delete(key);
    commit({ [key]: value });
  };
  // A slider drag that ends without a release saves nothing, so its value is dropped here too
  const abandonSlider = (key: keyof Framing) => {
    if (sliderDrags.current.delete(key)) {
      dropPending([key]);
    }
  };

  // Where a drag has moved the picture, along each axis with room to move
  const dragTo = (
    start: DragStart,
    event: PointerEvent<HTMLDivElement>,
  ): Partial<Framing> => {
    if (!size) {
      return {};
    }
    const [width, height] = coverSize(size, start.side, framing.zoom);
    const next: Partial<Framing> = {};
    if (width > start.side) {
      next.x = clamp(
        start.x -
          ((event.clientX - start.pointerX) / (width - start.side)) * 100,
        0,
        100,
      );
    }
    if (height > start.side) {
      next.y = clamp(
        start.y -
          ((event.clientY - start.pointerY) / (height - start.side)) * 100,
        0,
        100,
      );
    }
    return next;
  };

  // How far some pixels on screen move the picture along an axis, in percent of what overflows there
  const pixelStep = (axis: 0 | 1, pixels: number) => {
    if (!size) {
      return 0;
    }
    const overflow =
      coverSize(size, EDITOR_SIZE, framing.zoom)[axis] - EDITOR_SIZE;
    return overflow > 0 ? (pixels / overflow) * 100 : 0;
  };
  const zoomBy = (step: number) =>
    clamp(framing.zoom + step, data.zoom_min, data.zoom_max);

  // Arrow keys move the view the way the X and Y sliders do, and + and - zoom
  const keyChange = (
    key: string,
    large: boolean,
  ): Partial<Framing> | undefined => {
    const pixels = large ? NUDGE_PX_LARGE : NUDGE_PX;
    const changes: Record<string, Partial<Framing>> = {
      ArrowLeft: { x: clamp(framing.x - pixelStep(0, pixels), 0, 100) },
      ArrowRight: { x: clamp(framing.x + pixelStep(0, pixels), 0, 100) },
      ArrowUp: { y: clamp(framing.y - pixelStep(1, pixels), 0, 100) },
      ArrowDown: { y: clamp(framing.y + pixelStep(1, pixels), 0, 100) },
      '+': { zoom: zoomBy(ZOOM_KEY_STEP) },
      '=': { zoom: zoomBy(ZOOM_KEY_STEP) },
      '-': { zoom: zoomBy(-ZOOM_KEY_STEP) },
      _: { zoom: zoomBy(-ZOOM_KEY_STEP) },
    };
    return changes[key];
  };

  const zoomAt = (clientX: number, clientY: number, step: number) => {
    const editor = editorRef.current;
    const zoom = zoomBy(step);
    if (!editor || zoom === framing.zoom) {
      return;
    }
    if (!size) {
      commit({ zoom });
      return;
    }
    const rect = editor.getBoundingClientRect();
    const [widthBefore, heightBefore] = coverSize(
      size,
      rect.width,
      framing.zoom,
    );
    const [widthAfter, heightAfter] = coverSize(size, rect.width, zoom);
    commit({
      zoom,
      x: keepUnderPointer(
        framing.x,
        widthBefore,
        widthAfter,
        rect.width,
        clientX - rect.left,
      ),
      y: keepUnderPointer(
        framing.y,
        heightBefore,
        heightAfter,
        rect.height,
        clientY - rect.top,
      ),
    });
  };

  // React's wheel listener cannot stop the window scrolling, so a native one is used
  const onWheel = useRef<(event: WheelEvent) => void>(() => undefined);
  onWheel.current = (event) => {
    // Ctrl is the browser's own page zoom, and scrolling over an unlocked picture still scrolls the window
    if (
      event.ctrlKey ||
      !form.headshot ||
      !size ||
      broken ||
      document.activeElement !== editorRef.current
    ) {
      return;
    }
    event.preventDefault();
    zoomAt(
      event.clientX,
      event.clientY,
      event.deltaY < 0 ? WHEEL_ZOOM_STEP : -WHEEL_ZOOM_STEP,
    );
  };
  // Attached again once a headshot is set, since the editor is only drawn with one
  const hasHeadshot = !!form.headshot;
  useEffect(() => {
    const editor = editorRef.current;
    if (!editor) {
      return;
    }
    const listener = (event: WheelEvent) => onWheel.current(event);
    editor.addEventListener('wheel', listener, { passive: false });
    return () => editor.removeEventListener('wheel', listener);
  }, [hasHeadshot]);

  if (!form.headshot) {
    return (
      <Section title="Headshot">
        <LinkRow
          label="Headshot"
          disabled={busy}
          url={null}
          pendingChanges={pendingChanges}
          onSet={() => act('set_headshot', { form: form.id })}
        />
      </Section>
    );
  }

  return (
    <>
      <Section title="Frame headshot">
        <div className="CharacterGallery__headshot">
          <div
            inert={busy}
            style={{ width: EDITOR_SIZE, opacity: busy ? 0.5 : undefined }}
          >
            {!!form.headshot && (
              <div
                className={`CharacterGallery__frameHint${locked ? ' CharacterGallery__frameHint--active' : ''}`}
                style={{ display: 'grid' }}
                onMouseDown={(event) => {
                  // Kept from taking focus itself, so a click here locks the picture below
                  event.preventDefault();
                  editorRef.current?.focus();
                }}
              >
                {/* Both hints reserve space so activating framing does not move the portrait. */}
                <span
                  aria-hidden={locked}
                  style={{
                    gridArea: '1 / 1',
                    alignSelf: 'center',
                    visibility: locked ? 'hidden' : 'visible',
                  }}
                >
                  Click to adjust framing
                </span>
                <span
                  aria-hidden={!locked}
                  style={{
                    gridArea: '1 / 1',
                    visibility: locked ? 'visible' : 'hidden',
                  }}
                >
                  Drag to move
                  <SeparatorDot />
                  Scroll to zoom
                  <SeparatorDot />
                  Esc to finish
                </span>
              </div>
            )}
            <div
              ref={editorRef}
              tabIndex={form.headshot ? 0 : -1}
              aria-label="Headshot framing"
              style={{
                position: 'relative',
                width: EDITOR_SIZE,
                height: EDITOR_SIZE,
                backgroundColor: EMPTY_BACKGROUND,
                outline: locked ? LOCKED_OUTLINE : IMAGE_OUTLINE,
                cursor: form.headshot
                  ? dragging
                    ? 'grabbing'
                    : 'grab'
                  : 'default',
                touchAction: 'none',
              }}
              onFocus={() => setLocked(true)}
              onBlur={() => setLocked(false)}
              onPointerDown={(event) => {
                const editor = editorRef.current;
                if (event.button !== 0 || !size || !editor) {
                  return;
                }
                event.preventDefault();
                editor.focus();
                editor.setPointerCapture(event.pointerId);
                drag.current = {
                  pointerX: event.clientX,
                  pointerY: event.clientY,
                  side: editor.getBoundingClientRect().width,
                  x: framing.x,
                  y: framing.y,
                  moved: false,
                };
              }}
              onPointerMove={(event) => {
                const start = drag.current;
                if (!start) {
                  return;
                }
                if (!start.moved) {
                  const distance = Math.hypot(
                    event.clientX - start.pointerX,
                    event.clientY - start.pointerY,
                  );
                  if (distance < DRAG_THRESHOLD_PX) {
                    return;
                  }
                  start.moved = true;
                  setDragging(true);
                }
                follow(dragTo(start, event));
              }}
              onPointerUp={(event) => {
                const start = drag.current;
                if (!start) {
                  return;
                }
                drag.current = null;
                setDragging(false);
                // A plain click changes nothing, so it never frames an unframed headshot
                if (start.moved) {
                  commit(dragTo(start, event));
                }
              }}
              onLostPointerCapture={() => {
                // Lost without a release, so the drag is dropped rather than saved
                const start = drag.current;
                if (!start) {
                  return;
                }
                drag.current = null;
                setDragging(false);
                if (start.moved) {
                  dropPending(['x', 'y']);
                }
              }}
              onKeyDown={(event) => {
                if (event.key === 'Escape') {
                  editorRef.current?.blur();
                  return;
                }
                if ((!size || broken) && event.key.startsWith('Arrow')) {
                  return;
                }
                const change = keyChange(event.key, event.shiftKey);
                if (change && form.headshot) {
                  event.preventDefault();
                  commit(change);
                }
              }}
            >
              {!!form.headshot && (
                <HeadshotFrame
                  key={retry}
                  src={form.headshot}
                  framed={framed}
                  zoom={framing.zoom}
                  x={framing.x}
                  y={framing.y}
                  onSize={(width, height) => {
                    setSize([width, height]);
                    setBroken(false);
                  }}
                  onError={() => {
                    setSize(null);
                    setBroken(true);
                  }}
                />
              )}
              {broken && <BrokenBadge />}
            </div>
            {!!size && (
              <Box color="label" mt={0.5} textAlign="center">
                {size[0]} × {size[1]}
              </Box>
            )}
            <Box color="label" mt={1} textAlign="center">
              Examine Closer always uses this square portrait.
            </Box>
          </div>
          <div className="CharacterGallery__framing">
            {!broken && !size && (
              <div role="status">
                <Box color="label" mt={0.5}>
                  {retry ? 'Retrying headshot…' : 'Loading headshot…'}{' '}
                  Positioning becomes available when the image loads.
                </Box>
              </div>
            )}
            {broken && (
              <div role="status" className="CharacterGallery__error">
                <Box color="bad">
                  Image could not load. Check the link or replace it.
                </Box>
                <Button
                  icon="rotate"
                  onClick={() => {
                    setBroken(false);
                    setSize(null);
                    setRetry(retry + 1);
                  }}
                >
                  Retry headshot
                </Button>
              </div>
            )}
            <Box mt={1}>
              <FramingSlider
                label="Zoom"
                busy={busy}
                hint="Enlarges the picture around the point being framed."
                value={framing.zoom}
                minValue={data.zoom_min}
                maxValue={data.zoom_max}
                enabled
                onDrag={(value) => followSlider('zoom', value)}
                onChange={(value) => commitSlider('zoom', value)}
                onAbandon={() => abandonSlider('zoom')}
              />
            </Box>
            <Box className="CharacterGallery__framingActions">
              <Button
                icon="undo"
                disabled={busy}
                tooltip="Back to the whole picture stretched into the square, as it shows before framing."
                onClick={() => {
                  settle.cancel();
                  unsent.current = {};
                  pendingRevisions.current = {};
                  setPending({});
                  act('reset_framing', { form: form.id });
                }}
              >
                Reset framing
              </Button>
              <Button
                icon={showSliders ? 'chevron-up' : 'chevron-down'}
                selected={showSliders}
                aria-expanded={showSliders}
                tooltip="Shows sliders for moving the picture, instead of dragging it."
                onClick={() => setShowSliders(!showSliders)}
              >
                Position controls
              </Button>
            </Box>
            {showSliders && (
              <Box mt={0.5}>
                <FramingSlider
                  label="Horizontal"
                  busy={busy}
                  hint="0 shows the left edge of the picture, 100 its right edge."
                  value={framing.x}
                  enabled={overflows(size, framing.zoom, 0)}
                  unavailable={
                    !size ? 'Load the image before positioning it.' : undefined
                  }
                  onDrag={(value) => followSlider('x', value)}
                  onChange={(value) => commitSlider('x', value)}
                  onAbandon={() => abandonSlider('x')}
                />
                <FramingSlider
                  label="Vertical"
                  busy={busy}
                  hint="0 shows the top edge of the picture, 100 its bottom edge."
                  value={framing.y}
                  enabled={overflows(size, framing.zoom, 1)}
                  unavailable={
                    !size ? 'Load the image before positioning it.' : undefined
                  }
                  onDrag={(value) => followSlider('y', value)}
                  onChange={(value) => commitSlider('y', value)}
                  onAbandon={() => abandonSlider('y')}
                />
              </Box>
            )}
            <Box mt={1}>
              <LinkControls
                label="Headshot"
                disabled={busy}
                pendingChanges={pendingChanges}
                url={form.headshot}
                onSet={() => act('set_headshot', { form: form.id })}
                onClear={() => act('clear_headshot', { form: form.id })}
                sourceSwitch={
                  <SourceSwitch
                    form={form}
                    image="headshot"
                    pendingChanges={pendingChanges}
                  />
                }
              />
            </Box>
            <details className="CharacterGallery__details">
              <summary>Framing help</summary>
              <Box color="label" mt={0.5}>
                Arrow keys: move. Shift + arrows: larger steps. + / -: zoom.
                Click outside the portrait to finish.
              </Box>
            </details>
          </div>
        </div>
      </Section>
      {form.id === 'character' && (
        <Section title="Chat appearance">
          <Box color="label" mb={1}>
            Choose how your headshot appears when someone examines you in chat.
          </Box>
          <div className="CharacterGallery__chatOptions">
            {[false, true].map((useFraming) => (
              <Button
                key={String(useFraming)}
                disabled={busy}
                className={`CharacterGallery__chatOption${!!data.headshot_frame_chat === useFraming ? ' CharacterGallery__chatOption--selected' : ''}`}
                {...buttonSemantics}
                aria-label={
                  useFraming ? 'Square portrait' : 'Original proportions'
                }
                aria-pressed={!!data.headshot_frame_chat === useFraming}
                onClick={() => act('set_frame_chat', { enabled: useFraming })}
              >
                <div className="CharacterGallery__chatPreview">
                  {useFraming ? (
                    <div style={{ width: CHAT_SIZE }}>
                      <HeadshotFrame
                        key={retry}
                        src={form.headshot!}
                        framed={framed}
                        zoom={framing.zoom}
                        x={framing.x}
                        y={framing.y}
                      />
                    </div>
                  ) : (
                    <img
                      key={retry}
                      src={resolveAsset(form.headshot!)}
                      alt="Chat headshot with original proportions"
                      style={{
                        display: 'block',
                        width: 'auto',
                        height: 'auto',
                        maxWidth: CHAT_SIZE,
                        maxHeight: CHAT_SIZE,
                      }}
                    />
                  )}
                </div>
                <Box bold className="CharacterGallery__chatLabel">
                  {!!data.headshot_frame_chat === useFraming && (
                    <Icon name="check" mr={0.5} />
                  )}
                  {useFraming ? 'Square portrait' : 'Original proportions'}
                </Box>
                <Box color="label" mt={0.5}>
                  {useFraming
                    ? 'Matches the portrait above.'
                    : 'Keeps the original shape.'}
                </Box>
              </Button>
            ))}
          </div>
        </Section>
      )}
    </>
  );
};

/** Whether the picture at this zoom is bigger than its square along an axis, 0 across or 1 down. */
const overflows = (size: [number, number] | null, zoom: number, axis: 0 | 1) =>
  !!size && (size[axis] / Math.min(size[0], size[1])) * zoom > 100;

type FramingSliderProps = {
  busy?: boolean;
  label: string;
  hint: string;
  value: number;
  minValue?: number;
  maxValue?: number;
  enabled: boolean;
  unavailable?: string;
  onDrag: (value: number) => void;
  onChange: (value: number) => void;
  /** Called when a drag loses the pointer, whether or not it was released. */
  onAbandon: () => void;
};

/** A framing slider, dimmed and inert while the picture fits the frame along its side. */
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
        <div>
          {unavailable ??
            `Zoom in to move ${slider.label === 'Horizontal' ? 'horizontally' : 'vertically'}.`}
        </div>
      </Box>
    );
  }
  return (
    <div
      className="CharacterGallery__framingSlider"
      inert={busy}
      style={{ opacity: busy ? 0.5 : undefined }}
      onLostPointerCapture={onAbandon}
    >
      <DragSlider {...slider} />
    </div>
  );
};

/** A small round separator, drawn rather than typed, since the themes' fonts lack a middle dot. */
const SeparatorDot = () => (
  <span
    style={{
      display: 'inline-block',
      width: '3px',
      height: '3px',
      borderRadius: '50%',
      backgroundColor: 'currentColor',
      verticalAlign: 'middle',
      margin: '0 6px',
    }}
  />
);

/** Marks a picture whose link did not load. */
const BrokenBadge = () => (
  <Box
    position="absolute"
    bottom={0}
    left={0}
    right={0}
    backgroundColor="rgba(160, 0, 0, 0.85)"
    textAlign="center"
    fontSize="0.8em"
    bold
  >
    Couldn&apos;t load
  </Box>
);

const ExtraRow = (props: {
  form: ImageForm;
  nsfw: boolean;
  pendingChanges: PendingChanges;
}) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { form, nsfw, pendingChanges } = props;
  const settle = useSettled(pendingChanges);
  const params = { form: form.id, nsfw };
  const url = nsfw ? form.nsfw_ooc_extra_img : form.ooc_extra_img;
  return (
    <LinkRow
      label={nsfw ? 'NSFW OOC Extra' : 'OOC Extra'}
      disabled={isBusy(form.id)}
      pendingChanges={pendingChanges}
      url={url}
      onSet={() => act('set_extra', params)}
      onClear={() => act('clear_extra', params)}
      sourceSwitch={
        <SourceSwitch
          form={form}
          image={nsfw ? 'nsfw_extra' : 'extra'}
          pendingChanges={pendingChanges}
        />
      }
    >
      {!!url && (
        <div
          inert={isBusy(form.id)}
          style={{
            marginTop: '0.25rem',
            opacity: isBusy(form.id) ? 0.5 : undefined,
          }}
        >
          <DragSlider
            label="Maximum width"
            hint="Maximum width as a percentage of the text column. Smaller images keep their original size."
            value={
              nsfw ? form.nsfw_ooc_extra_img_size : form.ooc_extra_img_size
            }
            minValue={data.extra_size_min}
            maxValue={data.extra_size_max}
            onChange={(size) => {
              if (isBusy(form.id)) {
                return;
              }
              settle.schedule((settled_revision) =>
                act('set_extra_size', { ...params, size, settled_revision }),
              );
            }}
          />
        </div>
      )}
    </LinkRow>
  );
};

/** How long a moved row stays highlighted. */
const FLASH_MS = 700;
/** How long an unconfirmed move is shown before the server's order takes over again. */
const MOVE_TIMEOUT_MS = 2000;

/** Keys that follow each image as it moves, counting repeats so the same link twice stays distinct. */
const rowKeys = (gallery: string[]) => {
  const seen: Record<string, number> = {};
  return gallery.map((url) => {
    seen[url] = (seen[url] ?? 0) + 1;
    return `${url}#${seen[url]}`;
  });
};

const sameOrder = (a: string[], b: string[]) =>
  a.length === b.length && a.every((url, index) => url === b[index]);

const sameItems = (a: string[], b: string[]) =>
  sameOrder([...a].sort(), [...b].sort());

const ArtSection = (props: {
  form: ImageForm;
  nsfw: boolean;
  pendingChanges: PendingChanges;
}) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { form, nsfw, pendingChanges } = props;
  const gallery = (nsfw ? form.nsfw_img_gallery : form.img_gallery) ?? [];
  const params = { form: form.id, nsfw };
  // The order after moves the server has not confirmed yet, so a move shows the moment it is clicked
  const [order, setOrder] = useState<string[] | null>(null);
  const [flashed, setFlashed] = useState<string | null>(null);
  const flashTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const moveTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const galleryKey = gallery.join('\n');
  useEffect(() => {
    // Done once the server agrees, or dropped if the images themselves changed meanwhile
    if (order && (sameOrder(order, gallery) || !sameItems(order, gallery))) {
      setOrder(null);
    }
  }, [galleryKey, form.source_revision]);
  useEffect(
    () => () => {
      for (const timer of [flashTimer.current, moveTimer.current]) {
        if (timer !== null) {
          clearTimeout(timer);
        }
      }
    },
    [],
  );
  const shown = order ?? gallery;
  const keys = rowKeys(shown);

  const move = (index: number, direction: -1 | 1) => {
    const target = index + direction;
    if (isBusy(form.id) || order || target < 0 || target >= shown.length) {
      return;
    }
    const next = [...shown];
    [next[index], next[target]] = [next[target], next[index]];
    setOrder(next);
    setFlashed(rowKeys(next)[target]);
    if (flashTimer.current !== null) {
      clearTimeout(flashTimer.current);
    }
    flashTimer.current = setTimeout(() => setFlashed(null), FLASH_MS);
    if (moveTimer.current !== null) {
      clearTimeout(moveTimer.current);
    }
    moveTimer.current = setTimeout(() => setOrder(null), MOVE_TIMEOUT_MS);
    flushChanges(pendingChanges);
    act('move_art', { ...params, index: index + 1, direction });
  };

  return (
    <Section
      title={`${nsfw ? 'NSFW Art' : 'SFW Art'} (${shown.length} of ${data.gallery_max})`}
    >
      {shown.map((url, index) => (
        <LinkRow
          key={keys[index]}
          disabled={!!order || isBusy(form.id)}
          pendingChanges={pendingChanges}
          label={`${nsfw ? 'NSFW' : 'SFW'} Art ${index + 1}`}
          url={url}
          clearText="Remove"
          tone={index % 2 === 0 ? 'light' : 'dark'}
          flash={flashed === keys[index]}
          onSet={() => act('set_art', { ...params, index: index + 1 })}
          onClear={() => act('remove_art', { ...params, index: index + 1 })}
          sourceSwitch={
            <SourceSwitch
              form={form}
              image={`${nsfw ? 'nsfw_art' : 'art'}_${index + 1}`}
              pendingChanges={pendingChanges}
              disabled={!!order}
            />
          }
          move={{
            first: isBusy(form.id) || !!order || index === 0,
            last: isBusy(form.id) || !!order || index === shown.length - 1,
            onMove: (direction) => move(index, direction),
          }}
        />
      ))}
      {shown.length < data.gallery_max && (
        <LinkRow
          label={`${nsfw ? 'NSFW' : 'SFW'} Art ${shown.length + 1}`}
          disabled={!!order || isBusy(form.id)}
          pendingChanges={pendingChanges}
          url={null}
          tone={shown.length % 2 === 0 ? 'light' : 'dark'}
          onSet={() => act('add_art', params)}
        />
      )}
    </Section>
  );
};

type LinkControlsProps = {
  disabled?: boolean;
  sourceSwitch?: ReactNode;
  pendingChanges?: PendingChanges;
  label: string;
  url: string | null;
  clearText?: string;
  onSet: () => void;
  onClear?: () => void;
};

type MoveControls = {
  first: boolean;
  last: boolean;
  onMove: (direction: -1 | 1) => void;
};

type LinkRowProps = PropsWithChildren<
  LinkControlsProps & {
    move?: MoveControls;
    /** Gives the row its own striped card, as the art rows have. */
    tone?: 'light' | 'dark';
    /** Highlights the row, which fades back once it ends. */
    flash?: boolean;
  }
>;

const ROW_BACKGROUND = {
  light: 'rgba(255, 255, 255, 0.04)',
  dark: 'rgba(255, 255, 255, 0.1)',
  flash: 'var(--button-background-selected, rgba(255, 255, 255, 0.2))',
};

/** A thumbnail, then the label with the picture's size under it, then the link and its buttons, with anything extra below. */
const LinkRow = (props: LinkRowProps) => {
  const { label, children, move, tone, flash, ...controls } = props;
  const [size, setSize] = useState<[number, number] | null>(null);
  const [broken, setBroken] = useState(false);
  const [retry, setRetry] = useState(0);
  useEffect(() => {
    setSize(null);
    setBroken(false);
    setRetry(0);
  }, [props.url]);
  const row = (
    <div className="CharacterGallery__row">
      <div>
        <Thumbnail
          key={`${props.url}:${retry}`}
          label={label}
          url={props.url}
          onSize={(width, height) => {
            setSize([width, height]);
            setBroken(false);
          }}
          onError={() => {
            setSize(null);
            setBroken(true);
          }}
        />
      </div>
      <div className="CharacterGallery__rowBody">
        <div className="CharacterGallery__rowDetails">
          <div>
            <Box bold>{label}</Box>
            {!!size && (
              <Box color="label" fontSize="0.8em">
                {size[0]} × {size[1]}
              </Box>
            )}
          </div>
          <LinkControls {...controls} label={label} />
        </div>
        {!!props.url && !broken && !size && (
          <div role="status">
            <Box color="label">
              {retry ? 'Retrying media…' : 'Loading media…'}
            </Box>
          </div>
        )}
        {broken && (
          <div role="status" className="CharacterGallery__error">
            <Box color="bad">
              Media could not load. Check the link or replace it.
            </Box>
            <Button
              icon="rotate"
              aria-label={`Retry ${label}`}
              onClick={() => {
                setBroken(false);
                setSize(null);
                setRetry(retry + 1);
              }}
            >
              Retry
            </Button>
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
              aria-label={`Move ${label} up`}
              disabled={move.first}
              onClick={() => move.onMove(-1)}
            />
          </Box>
          <Box mt={0.5}>
            <Button
              compact
              icon="arrow-down"
              tooltip={`Move ${label} down`}
              aria-label={`Move ${label} down`}
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
      style={{
        backgroundColor: flash ? ROW_BACKGROUND.flash : ROW_BACKGROUND[tone],
        borderRadius: '3px',
        transition: 'background-color 0.6s ease',
      }}
    >
      {row}
    </Box>
  );
};

/** Keeps link, copy, replacement and removal actions directly available. */
const LinkControls = (props: LinkControlsProps) => {
  const { label, url, clearText = 'Clear', onSet, onClear } = props;
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
        <Button
          icon={url ? 'pen' : 'plus'}
          disabled={props.disabled}
          aria-label={`${url ? 'Replace' : 'Add'} ${label}`}
          onClick={() => {
            if (props.pendingChanges) {
              flushChanges(props.pendingChanges);
            }
            onSet();
          }}
        >
          {url ? 'Replace' : 'Add'}
        </Button>
        {!!url && !!onClear && (
          <Button
            icon="times"
            color="bad"
            aria-label={`${clearText} ${label}`}
            disabled={props.disabled}
            onClick={() => {
              if (props.pendingChanges) {
                flushChanges(props.pendingChanges);
              }
              onClear();
            }}
          >
            {clearText}
          </Button>
        )}
        {props.sourceSwitch}
      </div>
    </div>
  );
};

/** Keeps links hidden until requested, with automatic and manual copying available. */
const HiddenUrl = (props: { url: string; label: string }) => {
  const { url, label } = props;
  const [shown, setShown] = useState(false);
  const [copyMessage, setCopyMessage] = useState('');
  const textRef = useRef<HTMLDivElement>(null);
  useEffect(() => {
    if (shown) {
      selectContents(textRef.current);
    }
  }, [shown]);

  const copy = async () => {
    const copied = await copyUrl(url);
    setCopyMessage(
      copied ? 'URL copied.' : 'Select the URL and press Ctrl+C to copy.',
    );
    if (!copied) {
      setShown(true);
      selectContents(textRef.current);
    }
  };
  return (
    <div>
      <div className="CharacterGallery__actions">
        <Button
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
        {copyMessage}
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

/** An aspect-preserving thumbnail that reports media dimensions and loading failures. */
const Thumbnail = (props: {
  label: string;
  url: string | null;
  onSize?: (width: number, height: number) => void;
  onError?: () => void;
}) => {
  const { label, url, onSize, onError } = props;
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
  return (
    <Box
      width={THUMBNAIL_SIZE}
      height={THUMBNAIL_SIZE}
      backgroundColor={EMPTY_BACKGROUND}
      style={{
        position: 'relative',
        overflow: 'hidden',
        outline: IMAGE_OUTLINE,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
      }}
    >
      {!!url &&
        (url.toLowerCase().endsWith('.mp4') ? (
          <video
            aria-label={`${label} video thumbnail`}
            src={url}
            muted
            preload="metadata"
            style={thumbnailStyle}
            onLoadedMetadata={(event) =>
              loaded(
                event.currentTarget.videoWidth,
                event.currentTarget.videoHeight,
              )
            }
            onError={failed}
          />
        ) : (
          <img
            alt={`${label} thumbnail`}
            src={url}
            style={thumbnailStyle}
            onLoad={(event) =>
              loaded(
                event.currentTarget.naturalWidth,
                event.currentTarget.naturalHeight,
              )
            }
            onError={failed}
          />
        ))}
      {broken && <BrokenBadge />}
    </Box>
  );
};
