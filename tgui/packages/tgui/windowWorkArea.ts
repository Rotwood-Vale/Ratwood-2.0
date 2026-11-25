type Point = [number, number];

export type PopupSize = { size: Point; automatic: boolean };

export type WindowBounds = {
  pos: Point;
  size: Point;
};

export type WorkArea = {
  origin: [number | undefined, number | undefined];
  size: Point;
};

/** Older popup records could contain the previous occupant's native window. */
const shouldResetPopupSize = (
  version: number | undefined,
  outer: Point,
  frame: Point,
  preferred: Point,
  area: WorkArea,
): boolean => {
  if (version) return false;
  const width = outer[0] - frame[0];
  const height = outer[1] - frame[1];
  const relativeAspect = width / height / (preferred[0] / preferred[1]);
  const fillsScreen = outer.every(
    (edge, axis) => area.size[axis] > 0 && edge >= area.size[axis] * 0.95,
  );
  return (
    relativeAspect > 2 ||
    relativeAspect < 0.5 ||
    (fillsScreen && (width > preferred[0] || height > preferred[1]))
  );
};

/** Scale a new preview uniformly on short or narrow displays. */
export const popupWindowSize = (
  geometry:
    | {
        popupBoundsVersion?: number;
        popupAutomaticSize?: boolean;
        popupBounds?: WindowBounds;
        size?: Point;
      }
    | undefined,
  preferred: Point,
  frame: Point,
  area: WorkArea,
): PopupSize => {
  const outer = geometry?.popupBounds?.size;
  if (outer && !geometry?.popupAutomaticSize) {
    if (
      !shouldResetPopupSize(
        geometry?.popupBoundsVersion,
        outer,
        frame,
        preferred,
        area,
      )
    ) {
      return { size: outer, automatic: false };
    }
  } else if (!geometry?.popupAutomaticSize && geometry?.size) {
    return {
      size: [
        Math.round(geometry.size[0] + frame[0]),
        Math.round(geometry.size[1] + frame[1]),
      ],
      automatic: false,
    };
  }
  const scale = Math.min(
    1,
    ...preferred.map((edge, axis) =>
      area.size[axis] > 0
        ? Math.max(1, area.size[axis] - frame[axis]) / edge
        : 1,
    ),
  );
  return {
    size: [
      Math.round(preferred[0] * scale + frame[0]),
      Math.round(preferred[1] * scale + frame[1]),
    ],
    automatic: true,
  };
};

/** BYOND reports outer-size, but accepts interior dimensions through size. */
export const nativeWindowSize = (outer: Point, frame: Point): string =>
  outer
    .map((edge, axis) => Math.max(1, Math.round(edge - frame[axis])))
    .join('x');

/** Fit outer window bounds. An unknown work-area origin only permits a size limit. */
export const fitWindowToWorkArea = (
  window: WindowBounds,
  area: WorkArea,
): WindowBounds => {
  const pos: Point = [...window.pos];
  const size: Point = [...window.size];
  for (const axis of [0, 1] as const) {
    const available = area.size[axis];
    if (!(available > 0)) {
      continue;
    }
    size[axis] = Math.min(size[axis], available);
    const origin = area.origin[axis];
    if (origin !== undefined) {
      pos[axis] = Math.max(
        origin,
        Math.min(pos[axis], origin + available - size[axis]),
      );
    }
  }
  return { pos, size };
};

/** Moves a window off another it overlaps, to that one's right or else its left, where the work area has room */
export const placeBeside = (
  window: WindowBounds,
  anchor: WindowBounds,
  area: WorkArea,
): WindowBounds => {
  const overlaps = ([0, 1] as const).every(
    (axis) =>
      window.pos[axis] < anchor.pos[axis] + anchor.size[axis] &&
      anchor.pos[axis] < window.pos[axis] + window.size[axis],
  );
  const origin = area.origin[0];
  if (!overlaps || origin === undefined) {
    return window;
  }
  const right = anchor.pos[0] + anchor.size[0];
  const left = anchor.pos[0] - window.size[0];
  if (right + window.size[0] <= origin + area.size[0]) {
    return { pos: [right, anchor.pos[1]], size: window.size };
  }
  if (left >= origin) {
    return { pos: [left, anchor.pos[1]], size: window.size };
  }
  return window;
};

export const readWorkArea = (
  screen: Pick<Screen, 'availWidth' | 'availHeight'> & {
    availLeft?: number;
    availTop?: number;
  },
  ratio: number,
  browserPos: Point,
  nativePos: Point,
): WorkArea => ({
  origin: [
    typeof screen.availLeft === 'number'
      ? nativePos[0] + Math.ceil((screen.availLeft - browserPos[0]) * ratio)
      : undefined,
    typeof screen.availTop === 'number'
      ? nativePos[1] + Math.ceil((screen.availTop - browserPos[1]) * ratio)
      : undefined,
  ],
  size: [
    Math.floor(screen.availWidth * ratio),
    Math.floor(screen.availHeight * ratio),
  ],
});
