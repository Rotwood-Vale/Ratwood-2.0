import { createContext, useContext, useEffect, useRef } from 'react';

import { useBackend } from '../../backend';
import type { Data, FormId } from './types';

export type PendingChanges = {
  flushers: Set<() => void>;
  waiting: Set<object>;
  /** The last debounced edit sent, confirmed once edit_seq reaches it */
  lastSent: number;
  nextSeq: number;
  changed: () => void;
};

export type GalleryActions = {
  isBusy: (form?: FormId) => boolean;
  act: (action: string, params: Record<string, unknown>) => void;
  pendingChanges: PendingChanges;
};
/** The window's act, busy test and edits waiting to be sent, which the Character Gallery window provides to every part */
export const GalleryActionContext = createContext<GalleryActions | null>(null);

/** The window's data and its actions. Each action carries the form's revision and the data's generation for the server to check */
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

/** Sends at once every edit useSettled is still waiting to send */
export const flushChanges = (pendingChanges: PendingChanges) => {
  for (const flush of pendingChanges.flushers) {
    flush();
  }
};

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
