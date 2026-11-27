import {
  type ArtViewSettings,
  DEFAULT_ART_VIEW,
  shownArtView,
} from '../common/artViewSettings';
import { type ReaderState, resetReader } from './Reader/readingState';

/** One picture's reader state, kept while its link, view settings and card background stay the ones in its signature */
export type ReadingEntry = {
  signature: string;
  owner: ArtViewSettings;
  state: ReaderState;
};

/** What the examine panel keeps of the gallery while it is on another page: the category, the picture, whether it has opened, each slot's reading entry and each picture's size */
export type GallerySession = {
  category: 'SFW' | 'NSFW';
  selected: number;
  opened: boolean;
  entries: Map<string, ReadingEntry>;
  /** Each picture's size once read, so a return to the page finds the view its shape allows before the size is read again */
  sizes: Map<string, [number, number]>;
};

/** A session on the first SFW picture, not yet opened */
export const createGallerySession = (): GallerySession => ({
  category: 'SFW',
  selected: 0,
  opened: false,
  entries: new Map(),
  sizes: new Map(),
});

/**
 * A slot's reading entry, made again from the owner's opening view when its link, view settings or card background changed.
 *
 * Its owner settings are the ones viewers get for the picture's shape, from shownArtView, so everything that reads
 * them follows a picture that opens only in Scrolling
 */
export const readingEntry = (
  session: GallerySession,
  slot: string,
  url: string | undefined,
  settings: ArtViewSettings | undefined,
  background: string,
  size?: [number, number],
) => {
  if (url && size) {
    session.sizes.set(url, size);
  }
  const owner = shownArtView(
    settings ?? DEFAULT_ART_VIEW,
    url ? session.sizes.get(url) : undefined,
  );
  const signature = JSON.stringify([
    url,
    owner.opening_view,
    owner.lock,
    owner.crop ?? null,
    background,
  ]);
  let entry = session.entries.get(slot);
  if (!entry || entry.signature !== signature) {
    entry = { signature, owner, state: resetReader(owner) };
    session.entries.set(slot, entry);
  }
  return entry;
};
