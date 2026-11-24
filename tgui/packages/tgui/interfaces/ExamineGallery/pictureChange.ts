import { wheelSteps } from './Thumbs/galleryWheel';

/** How a change of picture plays, dealt as a card or faded in when the deal is off */
export type PictureChange = 'deal' | 'fade';

/** The last change of picture, played as given or as a cut with no animation, which way it went, and the picture it left, null at the opening */
export type PictureMove = {
  change: PictureChange | 'cut';
  direction: number;
  from: number | null;
};

const DEAL_STAGGER_MS = 90;
const DEAL_MAIN_GAP_MS = 120;

/** Each thumbnail's deal delay, furthest from the selected first, so the selected thumbnail is dealt last and lands on top. Dealing in index order would bury it under thumbnails dealt after it. */
export const dealDelays = (selected: number, count: number) => {
  const order = Array.from({ length: count }, (_, index) => index).sort(
    (a, b) =>
      Math.abs(wheelSteps(b, selected, count)) -
      Math.abs(wheelSteps(a, selected, count)),
  );
  const delays: number[] = [];
  order.forEach((index, position) => {
    delays[index] = position * DEAL_STAGGER_MS;
  });
  return delays;
};

/** A thumbnail's delay in the deal played as the gallery opens, null when there is no opening deal */
export const thumbDealDelay = (openingDeal: number[] | null, index: number) =>
  openingDeal?.[index] ?? null;

/** How long the main picture waits in the opening deal, until every thumbnail is dealt and a gap after, none for a single picture */
export const dealMainDelay = (count: number) =>
  count > 1 ? count * DEAL_STAGGER_MS + DEAL_MAIN_GAP_MS : 0;
