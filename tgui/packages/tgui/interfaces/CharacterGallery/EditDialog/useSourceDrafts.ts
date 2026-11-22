import { useEffect, useState } from 'react';

import {
  type ArtCrop,
  type ArtViewSettings,
  DEFAULT_ART_VIEW,
  shownArtView,
} from '../../common/artViewSettings';
import { CARD_DEFAULT } from '../../common/CardBackground';
import { opensOnlyInScrolling, usePictureSize } from '../../common/pictureSize';
import { isArtEditor, type UrlEditorData } from '../types';

/** The Edit dialog's rows by name, row 0 being whichever of main and alternate is in use */
export const ROW_NAMES = ['Current Image', 'Alternate Image'] as const;

// Only load unsaved artwork from the direct image hosts accepted by valid_headshot_link().
const artworkLink =
  /^https:\/\/(?:i\.gyazo\.com|[a-z0-9]\.l3n\.co|(?:images2|thumbs2)\.imgbox\.com|files\.catbox\.moe|i\.ibb\.co|file\.garden)\/[^\s\\?#<>"'[\]]+$/;

/** The Edit dialog's unsaved link, card backdrop and view for one source, beside its saved link */
export type SourceDraft = {
  url: string;
  setUrl: (url: string) => void;
  background: string;
  setBackground: (background: string) => void;
  /** The settings Apply saves, Scrolling for a picture that opens only in Scrolling */
  view: ArtViewSettings;
  /** The settings viewers get from view and the picture's shape, which the framing column shows */
  shown: ArtViewSettings;
  /** The loaded picture opens only in Scrolling, so its Opening View cannot change */
  scrollingOnly: boolean;
  /** Sets the opening view and lock, which belong to the row and stay when its link changes */
  setView: (view: ArtViewSettings) => void;
  /** Sets the framing box of the link the row holds now */
  setCrop: (crop: ArtCrop | undefined) => void;
  previewUrl: string | null;
};

export type SourceDrafts = { main: SourceDraft; alternate: SourceDraft };

const useSourceDraft = (
  saved: string | null,
  savedBackground: string | undefined,
  savedView: ArtViewSettings | undefined,
  extensions: string[] | undefined,
  maxLength: number,
): SourceDraft => {
  const [url, setUrl] = useState(saved ?? '');
  const [background, setBackground] = useState(savedBackground ?? CARD_DEFAULT);
  const initialView = savedView ?? DEFAULT_ART_VIEW;
  const [openingView, setOpeningView] = useState(initialView.opening_view);
  const [lock, setLock] = useState(initialView.lock);
  const link = url.replace(/^[\0- ]+|[\0- ]+$/g, '');
  // A box drawn on one picture means nothing on another, so each link keeps its own
  const [crops, setCrops] = useState(
    () => new Map<string, ArtCrop | undefined>([[link, savedView?.crop]]),
  );
  const setCrop = (crop: ArtCrop | undefined) =>
    setCrops((previous) => new Map(previous).set(link, crop));
  const candidate =
    link.length <= maxLength &&
    artworkLink.test(link) &&
    extensions?.includes(link.slice(link.lastIndexOf('.') + 1))
      ? link
      : null;
  const [loadedLink, setLoadedLink] = useState<string | null>(null);
  useEffect(() => {
    if (!candidate || candidate === saved) return;
    const timer = setTimeout(() => setLoadedLink(candidate), 250);
    return () => clearTimeout(timer);
  }, [candidate, saved]);
  const previewUrl =
    link === saved ? saved : candidate === loadedLink ? candidate : null;
  const { size } = usePictureSize(previewUrl);
  const scrollingOnly = !!size && opensOnlyInScrolling(...size);
  // The chosen view is kept underneath, so a link to a picture of another shape gets it back
  const view: ArtViewSettings = {
    opening_view: scrollingOnly ? 'scroll' : openingView,
    lock,
    crop: crops.get(link),
  };
  const setView = (next: ArtViewSettings) => {
    if (!scrollingOnly) {
      setOpeningView(next.opening_view);
    }
    setLock(next.lock);
  };
  return {
    url,
    setUrl,
    background,
    setBackground,
    view,
    shown: shownArtView(view, size),
    scrollingOnly,
    setView,
    setCrop,
    previewUrl,
  };
};

export const useSourceDrafts = (
  editor: UrlEditorData,
  maxLength: number,
): SourceDrafts => {
  const extensions = isArtEditor(editor) ? editor.extensions : undefined;
  const main = useSourceDraft(
    editor.main,
    editor.main_background,
    editor.main_view_settings,
    extensions,
    maxLength,
  );
  const alternate = useSourceDraft(
    editor.alternate,
    editor.alternate_background,
    editor.alternate_view_settings,
    extensions,
    maxLength,
  );
  return { main, alternate };
};
