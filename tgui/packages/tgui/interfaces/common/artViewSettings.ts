import type { ArtViewSettings } from '../CharacterGallery/shared';

export const ART_VIEW_LABELS = {
  whole: 'Card Art',
  fitted: 'Fitted Art',
  scroll: 'Scroll View',
} satisfies Record<ArtViewSettings['opening_view'], string>;

export const DEFAULT_ART_VIEW = Object.freeze({
  opening_view: 'whole',
  lock: 'zoom',
} satisfies ArtViewSettings);
