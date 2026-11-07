import {
  createContext,
  type HTMLAttributes,
  useContext,
  useEffect,
  useRef,
} from 'react';
import { Box, Button } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../../backend';

export type FormId = 'character' | 'gnoll';

// tgui-core forwards DOM attributes that its prop types do not declare
export const buttonRole = {
  role: 'button',
} satisfies HTMLAttributes<HTMLDivElement>;
export const buttonSemantics = {
  ...buttonRole,
  tabIndex: 0,
} satisfies HTMLAttributes<HTMLDivElement>;

export type ImageForm = {
  revision: number;
  alternates: Record<string, { active_alternate: BooleanLike }>;
  undo: string[];
  undo_removed: Record<string, number>;
  undo_clear: BooleanLike;
  blocked_links: { label: string; url: string }[];
  id: FormId;
  name: string;
  headshot: string | null;
  headshot_zoom: number;
  headshot_x: number;
  headshot_y: number;
  ooc_extra_img: string | null;
  ooc_extra_img_size: number;
  nsfw_ooc_extra_img: string | null;
  nsfw_ooc_extra_img_size: number;
  img_gallery: string[] | null;
  nsfw_img_gallery: string[] | null;
  image_backdrop: string;
  card_backgrounds: Record<string, string>;
};

export type Data = {
  prompt_timeout: number;
  link_max_length: number;
  image_actions: string[];
  confirm_actions: string[];
  link_hosts: string;
  url_editor: {
    id: number;
    form: FormId;
    image: string;
    label: string;
    main: string | null;
    alternate: string | null;
    active_alternate: BooleanLike;
    main_background?: string;
    alternate_background?: string;
    extensions: string[];
    error: string | null;
  } | null;
  generation: number;
  edit_seq: number;
  gallery_dirty: BooleanLike;
  selected_form: FormId;
  can_save: BooleanLike;
  save_feedback: { message: string } | null;
  headshot_frame_chat: BooleanLike;
  gallery_max: number;
  zoom_min: number;
  zoom_max: number;
  extra_size_min: number;
  extra_size_max: number;
  backdrop_options: { value: string; label: string }[];
  card_background_options: { value: string; label: string }[];
  forms: ImageForm[];
};

export type PendingChanges = {
  flushers: Set<() => void>;
  waiting: Set<object>;
  /** The last debounced edit sent, confirmed once edit_seq reaches it */
  lastSent: number;
  nextSeq: number;
  changed: () => void;
};

// Slot and Undo point names, which must match character_gallery.dm
export const HEADSHOT_SLOT = 'headshot';
export const artScope = (nsfw: boolean) => (nsfw ? 'nsfw_art' : 'art');
export const artSlot = (nsfw: boolean, index: number) =>
  `${artScope(nsfw)}_${index}`;
export const extraSlot = (nsfw: boolean) => (nsfw ? 'nsfw_extra' : 'extra');
export const removedPoint = (scope: 'art' | 'nsfw_art' | 'blocked') =>
  `${scope}_removed`;
export const UNDO_CLEAR = 'clear_all';

export const galleryLabel = (nsfw: boolean) => (nsfw ? 'NSFW Art' : 'SFW Art');
export const artLabel = (nsfw: boolean, position: number) =>
  `${galleryLabel(nsfw)} ${position}`;
export const extraLabel = (nsfw: boolean) =>
  nsfw ? 'NSFW OOC Extra' : 'OOC Extra';

/** Whether a link ends in an mp4 extension, as the server's is_video_link decides */
export const isVideoLink = (url: string) =>
  url.split('.').pop()?.toLowerCase() === 'mp4';

export const formHasImages = (form: ImageForm) =>
  !!(
    form.headshot ||
    form.ooc_extra_img ||
    form.nsfw_ooc_extra_img ||
    form.img_gallery?.length ||
    form.nsfw_img_gallery?.length ||
    form.blocked_links?.length
  );

export type GalleryActions = {
  isBusy: (form?: FormId) => boolean;
  act: (action: string, params: Record<string, unknown>) => void;
  pendingChanges: PendingChanges;
};
export const GalleryActionContext = createContext<GalleryActions | null>(null);

export const useGalleryBackend = () => {
  const { data } = useBackend<Data>();
  const actions = useContext(GalleryActionContext);
  if (!actions) {
    throw new Error('useGalleryBackend requires GalleryActionContext.Provider');
  }
  const generation = data.generation;
  return {
    data,
    isBusy: actions.isBusy,
    pendingChanges: actions.pendingChanges,
    act: (action: string, params: Record<string, unknown> = {}) => {
      const form =
        params.form ??
        (action === 'save_urls' ? data.url_editor?.form : 'character');
      actions.act(action, {
        revision: data.forms.find((entry) => entry.id === form)?.revision ?? 0,
        ...params,
        form,
        generation,
      });
    },
  };
};

export const flushChanges = (pendingChanges: PendingChanges) => {
  for (const flush of pendingChanges.flushers) {
    flush();
  }
};

export const copyUrl = async (url: string) => {
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

export const RemovedRow = (props: {
  text: string;
  busy: boolean;
  onUndo: () => void;
}) => (
  <div className="CharacterGallery__removedRow">
    <Box color="label">{props.text}</Box>
    <Button icon="undo" disabled={props.busy} onClick={props.onUndo}>
      Undo
    </Button>
  </div>
);

const SETTLE_MS = 300;

/**
 * Sends the last scheduled call once calls have been quiet for SETTLE_MS. A call still waiting is
 * sent at once before any other action or when the component goes away.
 */
export const useSettled = () => {
  const { data, pendingChanges } = useGalleryBackend();
  const token = useRef({}).current;
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const waiting = useRef<((editSeq: number) => void) | null>(null);
  const cancel = () => {
    if (timer.current !== null) {
      clearTimeout(timer.current);
      timer.current = null;
    }
    waiting.current = null;
    if (pendingChanges.waiting.delete(token)) {
      pendingChanges.changed();
    }
  };
  const flush = () => {
    const send = waiting.current;
    cancel();
    if (send) {
      pendingChanges.nextSeq =
        Math.max(pendingChanges.nextSeq, data.edit_seq ?? 0) + 1;
      pendingChanges.lastSent = pendingChanges.nextSeq;
      send(pendingChanges.nextSeq);
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
  const schedule = (send: (editSeq: number) => void) => {
    waiting.current = send;
    pendingChanges.waiting.add(token);
    pendingChanges.changed();
    if (timer.current !== null) {
      clearTimeout(timer.current);
    }
    timer.current = setTimeout(flush, SETTLE_MS);
  };
  return { schedule, cancel, isWaiting: () => timer.current !== null };
};
