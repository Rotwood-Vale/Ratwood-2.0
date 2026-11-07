const BLINK_GAP_MS = 2500;
const BLINK_GAP_SPREAD_MS = 3500;

/** The chance that each mouse move after the wait starts a blink. */
const BLINK_CHANCE = 0.35;

const DOUBLE_BLINK_CHANCE = 0.15;

type Eyes = 'half' | 'shut' | null;

/** What a figure's face layer shows: the NSFW face or the everyday one, its eyes where null is open, and whether the level mouth covers the face's own. */
type FaceFrame = { nsfw: boolean; eyes: Eyes; level: boolean };

export type FaceStep = [FaceFrame, number];

const BLINK: [Eyes, number][] = [
  ['half', 40],
  ['shut', 90],
  ['half', 40],
];

const DOUBLE_GAP: [Eyes, number] = [null, 110];

export const blinkSteps = (nsfw: boolean, double: boolean): FaceStep[] =>
  (double ? [...BLINK, DOUBLE_GAP, ...BLINK] : BLINK).map(([eyes, ms]) => [
    { nsfw, eyes, level: false },
    ms,
  ]);

export const swapSteps = (from: boolean, to: boolean): FaceStep[] => [
  [{ nsfw: from, eyes: 'half', level: false }, 40],
  [{ nsfw: from, eyes: 'shut', level: true }, 45],
  [{ nsfw: to, eyes: 'shut', level: false }, 45],
  [{ nsfw: to, eyes: 'half', level: false }, 40],
];

const FACE = 'ExamineGallery__sceneFace';

/**
 * A scene figure's face, kept by the Image Gallery page so it outlives each gallery, which is swapped for the other
 * on every switch between SFW and NSFW. `attach` is the ref of the figure's face layer and puts on it the frame shown
 * now, so a layer drawn anew partway through a blink or a swap carries on from that frame. Every frame is a class on
 * the layer, without a React state update
 */
export const createFigureFace = (nsfw: boolean) => {
  let layer: HTMLElement | null = null;
  let shown: FaceFrame = { nsfw, eyes: null, level: false };
  let wanted = nsfw;
  let timer: ReturnType<typeof setTimeout> | null = null;
  let swapping = false;
  let swapWaits = false;
  let blinkReady = 0;
  // Held so the frames stay loaded, as none of them is drawn at rest
  let frames: HTMLImageElement[] = [];

  const hasNsfwFace = () => layer?.dataset.nsfwFace !== undefined;

  const show = (frame: FaceFrame) => {
    shown = frame;
    if (!layer) {
      return;
    }
    layer.classList.toggle(`${FACE}--nsfw`, frame.nsfw && hasNsfwFace());
    layer.classList.toggle(`${FACE}--half`, frame.eyes === 'half');
    layer.classList.toggle(`${FACE}--shut`, frame.eyes === 'shut');
    layer.classList.toggle(`${FACE}--level`, frame.level);
  };

  const play = (steps: FaceStep[], index = 0) => {
    if (index === steps.length) {
      timer = null;
      swapping = false;
      show({ nsfw: shown.nsfw, eyes: null, level: false });
      if (swapWaits) {
        swapWaits = false;
        swap();
      }
      return;
    }
    const [frame, ms] = steps[index];
    show(frame);
    timer = setTimeout(() => play(steps, index + 1), ms);
  };

  const swap = () => {
    if (!hasNsfwFace() || document.hidden) {
      show({ nsfw: wanted, eyes: null, level: false });
      return;
    }
    swapping = true;
    play(swapSteps(shown.nsfw, wanted));
  };

  const stop = () => {
    if (timer !== null) {
      clearTimeout(timer);
    }
    timer = null;
    swapping = false;
    swapWaits = false;
  };

  return {
    attach: (element: HTMLElement | null) => {
      layer = element;
      if (!element) {
        return;
      }
      frames = Object.values(element.dataset).map((url) => {
        const image = new Image();
        image.src = url ?? '';
        return image;
      });
      show(shown);
    },

    turn: (nsfw: boolean) => {
      if (nsfw === wanted) {
        return;
      }
      wanted = nsfw;
      if (timer !== null && !swapping) {
        swapWaits = true;
        return;
      }
      stop();
      swap();
    },

    onMouseMove: () => {
      if (timer !== null || document.hidden) {
        return;
      }
      const now = performance.now();
      if (now < blinkReady || Math.random() > BLINK_CHANCE) {
        return;
      }
      blinkReady = now + BLINK_GAP_MS + Math.random() * BLINK_GAP_SPREAD_MS;
      play(blinkSteps(shown.nsfw, Math.random() < DOUBLE_BLINK_CHANCE));
    },

    stop: () => {
      stop();
      frames = [];
    },
  };
};

export type FigureFace = ReturnType<typeof createFigureFace>;
