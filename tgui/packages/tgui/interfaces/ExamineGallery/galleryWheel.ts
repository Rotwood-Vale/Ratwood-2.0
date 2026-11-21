/** A thumbnail's size and how far its centre sits from the selected one's, by steps away from it. The first size is also the plain thumbnail's in ExamineGallery.scss. */
export const WHEEL_SPOTS = [
  { size: 96, offset: 0 },
  { size: 72, offset: 92 },
  { size: 52, offset: 162 },
];

const ARC_DROP = 5;
const ARC_LEAN = 6;

/** Steps from the selected picture around the wheel, negative to its left. */
export const wheelSteps = (index: number, selected: number, count: number) => {
  const ahead = (index - selected + count) % count;
  return count > 2 && ahead === count - 1 ? -1 : ahead;
};

export const wheelScale = (steps: number) =>
  WHEEL_SPOTS[Math.abs(steps)].size / WHEEL_SPOTS[0].size;

/** Places a thumbnail by transform alone, never by left or top, as animating left or top redoes the page's layout on every frame of a wheel turn. */
export const wheelTransform = (steps: number) => {
  const away = Math.abs(steps);
  const side = Math.sign(steps);
  const across = side * WHEEL_SPOTS[away].offset;
  const down = (away * away + away) * ARC_DROP;
  return `translate(-50%, -50%) translate(${across}px, ${down}px) rotate(${side * away * ARC_LEAN}deg) scale(${wheelScale(steps)})`;
};

export type PictureChange = 'deal' | 'fade';

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

export const thumbDealDelay = (openingDeal: number[] | null, index: number) =>
  openingDeal?.[index] ?? null;

export const dealMainDelay = (count: number) =>
  count > 1 ? count * DEAL_STAGGER_MS + DEAL_MAIN_GAP_MS : 0;
