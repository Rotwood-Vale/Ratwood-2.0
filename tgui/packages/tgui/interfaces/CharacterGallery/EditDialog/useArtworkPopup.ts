import { useEffect, useRef } from 'react';

import { useGalleryBackend } from '../galleryBackend';
import type { UrlEditorData } from '../types';
import type { SourceDraft } from './useSourceDrafts';

/** How long the draft must stay unchanged before the Pop-up gets it */
const DRAFT_UPDATE_MS = 120;

/**
 * Opens and closes the Pop-up Preview and sends it the draft. Nothing is sent while a mouse button is held,
 * so a drag reaches the server once, when it is released
 */
export const useArtworkPopup = (
  editor: UrlEditorData,
  source: SourceDraft,
  alternate: boolean,
) => {
  const { act, isBusy } = useGalleryBackend();
  const busy = isBusy(editor.form);
  const open = !!editor.popup_open;
  const editorParams = { editor_id: editor.id, form: editor.form };
  const draft = {
    ...editorParams,
    url: source.previewUrl,
    alternate,
    background: source.background,
    view: source.view,
  };
  const fingerprint = JSON.stringify(draft);
  const lastSent = useRef<string | null>(null);
  const held = useRef(false);
  const timer = useRef<ReturnType<typeof setTimeout> | undefined>(undefined);
  const sendLatest = useRef(() => {});
  sendLatest.current = () => {
    if (open && !busy && !held.current && lastSent.current !== fingerprint) {
      lastSent.current = fingerprint;
      act('update_artwork_preview', draft);
    }
  };
  const schedule = () => {
    clearTimeout(timer.current);
    timer.current = setTimeout(() => sendLatest.current(), DRAFT_UPDATE_MS);
  };
  useEffect(() => {
    const press = () => {
      held.current = true;
    };
    const release = () => {
      held.current = false;
      schedule();
    };
    window.addEventListener('pointerdown', press, true);
    window.addEventListener('pointerup', release, true);
    window.addEventListener('pointercancel', release, true);
    return () => {
      window.removeEventListener('pointerdown', press, true);
      window.removeEventListener('pointerup', release, true);
      window.removeEventListener('pointercancel', release, true);
      clearTimeout(timer.current);
    };
  }, []);
  useEffect(() => {
    if (open && lastSent.current !== fingerprint) schedule();
  }, [open, busy, fingerprint]);
  const toggle = () => {
    if (open) {
      act('close_artwork_preview', editorParams);
      return;
    }
    lastSent.current = fingerprint;
    act('open_artwork_preview', draft);
  };
  return { open, toggle };
};
