import {
  ART_AREA,
  ART_LOCK_LABELS,
  ART_VIEW_LABELS,
  type ArtCrop,
  type ArtViewSettings,
  cropAspect,
  locksView,
  TALL_LOCK_HELP,
  tallLockChoice,
} from '../../common/artViewSettings';
import {
  PICTURE_TOO_NARROW_TEXT,
  pictureTooThin,
  TILTED_CARD_MARGIN,
} from '../../common/cardLayout';
import type { usePictureSize } from '../../common/pictureSize';

export const framingStatus = (
  view: ArtViewSettings['opening_view'],
  framed: boolean,
) => {
  switch (view) {
    case 'whole':
      return framed
        ? 'The card shows your framed area.'
        : 'The whole picture fits the card.';
    case 'fitted':
      return framed
        ? 'The framed area fits the window.'
        : 'The whole picture fits the window.';
    case 'scroll':
      return framed
        ? 'Scrolling opens at the frame’s top, fitted to the window’s width.'
        : 'Scrolling opens at the top of the picture, fitted to the window’s width.';
  }
};

export const pictureStatus = (picture: ReturnType<typeof usePictureSize>) => {
  if (picture.limitText) {
    return picture.limitText;
  }
  if (picture.failed) {
    return "Couldn't load the image. Check the link.";
  }
  return 'Loading picture…';
};

const TOO_THIN_TEXT = `This framing is too thin to show as a card. Viewers would see "${PICTURE_TOO_NARROW_TEXT}" Make the box taller or wider, or use ${ART_VIEW_LABELS.scroll}.`;

const SWITCH_TOO_THIN_TEXT = `Viewers who switch to ${ART_VIEW_LABELS.whole} would see "${PICTURE_TOO_NARROW_TEXT}" Make the box taller or wider, or lock the view.`;

const UNFRAMED_TOO_THIN_TEXT = `This picture is too thin to show as a card. Viewers would see "${PICTURE_TOO_NARROW_TEXT}" Draw a framing box with a usable shape, or use ${ART_VIEW_LABELS.scroll}.`;

const UNFRAMED_SWITCH_TOO_THIN_TEXT = `With no framing box set, ${ART_VIEW_LABELS.whole} shows the whole picture, so viewers who switch to it would see "${PICTURE_TOO_NARROW_TEXT}" Draw a framing box with a usable shape, or lock the view.`;

/** The warning for a framing Card cannot show, or null when viewers never reach Card with it */
export const tooThinText = (
  size: [number, number] | null,
  crop: ArtCrop | undefined,
  view: ArtViewSettings['opening_view'],
  lock: ArtViewSettings['lock'],
) => {
  // Card shows the owner's box, or the whole picture without one, never the default box shown here
  const thinForCard =
    !!size &&
    pictureTooThin(
      cropAspect(size[0] / size[1], crop),
      ART_AREA,
      TILTED_CARD_MARGIN,
    );
  if (thinForCard && view === 'whole') {
    return crop ? TOO_THIN_TEXT : UNFRAMED_TOO_THIN_TEXT;
  }
  if (thinForCard && !locksView(lock)) {
    return crop ? SWITCH_TOO_THIN_TEXT : UNFRAMED_SWITCH_TOO_THIN_TEXT;
  }
  return null;
};

/**
 * What each lock leaves viewers able to do. Scrolling can zoom out to the whole picture and scroll
 * past the box where the picture overflows the window.
 *
 * A picture that opens only in Scrolling gets the note for the choice its Viewer Controls show
 */
export const framingNote = (
  view: 'whole' | 'scroll',
  lock: ArtViewSettings['lock'],
  framed: boolean,
  scrollingOnly = false,
) => {
  if (scrollingOnly) {
    return TALL_LOCK_HELP[tallLockChoice(lock)];
  }
  const card = view === 'whole';
  const fit = `choose ${ART_VIEW_LABELS.fitted} to fit ${framed ? 'the framed area' : 'the whole picture'} to the window`;
  switch (lock) {
    case 'none':
      return card
        ? `Viewers can zoom in and pan, or ${fit}.`
        : 'Viewers can zoom out to see the whole picture.';
    case 'view':
      return card
        ? 'Viewers can zoom in and pan beyond the box.'
        : 'Viewers can zoom out to see the whole picture.';
    case 'zoom':
      return `With ${ART_LOCK_LABELS.zoom} only, viewers can ${fit}.`;
    case 'both':
      return card
        ? `${ART_LOCK_LABELS.both} keeps viewers in this framing.`
        : `With ${ART_LOCK_LABELS.both}, viewers can still scroll where the picture extends past the window.`;
  }
};
