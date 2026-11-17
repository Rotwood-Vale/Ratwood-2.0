import type { ArtViewSettings } from '../CharacterGallery/shared';
import { DEFAULT_ART_VIEW } from '../common/artViewSettings';

export type ReaderState = {
  view: ArtViewSettings['opening_view'];
  zoom: number;
  left: number;
  top: number;
  anchor?: {
    x: number;
    y: number;
    viewportWidth: number;
    viewportHeight: number;
  };
};

export type ReadingEntry = {
  signature: string;
  owner: ArtViewSettings;
  state: ReaderState;
};

export type GallerySession = {
  category: 'SFW' | 'NSFW';
  selected: number;
  opened: boolean;
  entries: Map<string, ReadingEntry>;
};

export const createGallerySession = (): GallerySession => ({
  category: 'SFW',
  selected: 0,
  opened: false,
  entries: new Map(),
});

export const resetReader = (owner: ArtViewSettings): ReaderState => ({
  view: owner.opening_view,
  zoom: 1,
  left: 0,
  top: 0,
});

export const readingEntry = (
  session: GallerySession,
  slot: string,
  url: string | undefined,
  settings: ArtViewSettings | undefined,
  background: string,
) => {
  const owner = settings ?? DEFAULT_ART_VIEW;
  const signature = JSON.stringify([
    url,
    owner.opening_view,
    owner.lock,
    background,
  ]);
  let entry = session.entries.get(slot);
  if (!entry || entry.signature !== signature) {
    entry = { signature, owner, state: resetReader(owner) };
    session.entries.set(slot, entry);
  }
  return entry;
};

export const isReading = (state: ReaderState) =>
  state.view === 'scroll' || state.zoom > 1;

export const viewLocked = (owner: ArtViewSettings) =>
  owner.lock === 'view' || owner.lock === 'both';

export const zoomLocked = (owner: ArtViewSettings) =>
  owner.lock === 'zoom' || owner.lock === 'both';
