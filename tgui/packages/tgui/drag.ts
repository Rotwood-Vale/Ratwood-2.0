/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { storage } from 'common/storage';
import { vecAdd, vecMultiply, vecScale, vecSubtract } from 'common/vector';
import type { BooleanLike } from 'tgui-core/react';

import { createLogger } from './logging';
import {
  fitWindowToWorkArea,
  nativeWindowSize,
  placeBeside,
  type PopupSize,
  popupWindowSize,
  readWorkArea,
  type WindowBounds,
  type WorkArea,
} from './windowWorkArea';

const logger = createLogger('drag');
const pixelRatio = window.devicePixelRatio ?? 1;
const GEOMETRY_READ_TIMEOUT = 1000;
const WORK_AREA_POLL_MS = 250;
const MONITOR_MOVE_SETTLE_MS = 100;
const MAX_GEOMETRY_READ_ATTEMPTS = 3;
let windowKey = Byond.windowId;
let dragging = false;
let resizing = false;
let watchingPopup = false;
let screenOffset: [number, number] = [0, 0];
let screenOffsetPromise: Promise<[number, number]>;
let dragPointOffset: [number, number];
let resizeMatrix: [number, number];
let initialSize: [number, number];
let size: [number, number];

// Set the window key
export const setWindowKey = (key: string): void => {
  windowKey = key;
};

// Get window position
export const getWindowPosition = (): [number, number] => [
  window.screenLeft * pixelRatio,
  window.screenTop * pixelRatio,
];

// Get window size
export const getWindowSize = (): [number, number] => [
  window.innerWidth * pixelRatio,
  window.innerHeight * pixelRatio,
];

// Set window position
export const setWindowPosition = (vec: [number, number]) => {
  const byondPos = vecAdd(vec, screenOffset);
  return Byond.winset(Byond.windowId, {
    pos: `${byondPos[0]},${byondPos[1]}`,
  });
};

// Set window size
const setWindowSize = (vec: [number, number]) => {
  return Byond.winset(Byond.windowId, {
    size: `${vec[0]}x${vec[1]}`,
  });
};

// Get screen position
const getScreenPosition = (): [number, number] => [
  0 - screenOffset[0],
  0 - screenOffset[1],
];

// Get screen size
const getScreenSize = (): [number, number] => [
  window.screen.availWidth * pixelRatio,
  window.screen.availHeight * pixelRatio,
];

/**
 * Moves an item to the top of the recents array, and keeps its length
 * limited to the number in `limit` argument.
 *
 * Uses a strict equality check for comparisons.
 *
 * Returns new recents and an item which was trimmed.
 */
export const touchRecents = (
  recents: string[],
  touchedItem: string,
  limit = 50,
): [string[], string | undefined] => {
  const nextRecents: string[] = [touchedItem];
  let trimmedItem: string | undefined;
  for (let i = 0; i < recents.length; i++) {
    const item = recents[i];
    if (item === touchedItem) {
      continue;
    }
    if (nextRecents.length < limit) {
      nextRecents.push(item);
    } else {
      trimmedItem = item;
    }
  }
  return [nextRecents, trimmedItem];
};

// Store window geometry in local storage
const storeWindowGeometry = async (
  popupBounds?: WindowBounds,
  popupAutomaticSize?: boolean,
) => {
  const key = windowKey;
  logger.log('storing geometry');
  const geometry = {
    pos: getWindowPosition(),
    size: getWindowSize(),
    ...(popupBounds && {
      popupBounds,
      popupBoundsVersion: 1,
      popupAutomaticSize,
    }),
  };
  storage.set(key, geometry);
  // Update the list of stored geometries
  const [geometries, trimmedKey] = touchRecents(
    (await storage.get('geometries')) || [],
    key,
  );
  if (trimmedKey) {
    storage.remove(trimmedKey);
  }
  storage.set('geometries', geometries);
};

const geometryOrFallback = <T>(request: Promise<T>, fallback: T) => {
  let timeout: ReturnType<typeof setTimeout> | undefined;
  return Promise.race([
    request.catch(() => fallback),
    new Promise<T>((resolve) => {
      timeout = setTimeout(() => resolve(fallback), GEOMETRY_READ_TIMEOUT);
    }),
  ]).finally(() => clearTimeout(timeout));
};

type PopupGeometry = WindowBounds & { frame: [number, number] };

const readNativeGeometry = async (
  restorePooledWindow?: () => boolean,
): Promise<PopupGeometry | undefined> => {
  const {
    pos,
    'inner-size': inner,
    'outer-size': outer,
    'is-maximized': maximized,
    'is-minimized': minimized,
  } = (await geometryOrFallback(
    Byond.winget(Byond.windowId, [
      'pos',
      'inner-size',
      'outer-size',
      'is-maximized',
      'is-minimized',
    ]),
    undefined,
  )) ?? {};
  if (
    maximized === true ||
    maximized === 'true' ||
    minimized === true ||
    minimized === 'true'
  ) {
    if (restorePooledWindow?.()) {
      Byond.winset(Byond.windowId, {
        'is-maximized': false,
        'is-minimized': false,
      });
      await new Promise((resolve) =>
        setTimeout(resolve, MONITOR_MOVE_SETTLE_MS),
      );
      if (restorePooledWindow()) return readNativeGeometry();
    }
    return;
  }
  if (
    !Number.isFinite(pos?.x) ||
    !Number.isFinite(pos?.y) ||
    !(outer?.x > 0 && outer?.y > 0 && inner?.x > 0 && inner?.y > 0)
  ) {
    return;
  }
  return {
    pos: [pos.x, pos.y] as [number, number],
    size: [outer.x, outer.y] as [number, number],
    frame: [Math.max(0, outer.x - inner.x), Math.max(0, outer.y - inner.y)] as [
      number,
      number,
    ],
  };
};

const readWindowBounds = async (
  id: string,
): Promise<WindowBounds | undefined> => {
  const { pos, 'outer-size': outer } =
    (await geometryOrFallback(
      Byond.winget(id, ['pos', 'outer-size']),
      undefined,
    )) ?? {};
  if (
    !Number.isFinite(pos?.x) ||
    !Number.isFinite(pos?.y) ||
    !(outer?.x > 0 && outer?.y > 0)
  ) {
    return;
  }
  return { pos: [pos.x, pos.y], size: [outer.x, outer.y] };
};

/** Moves bounds off the window with this id, when it is given and can be read */
const fitBesideWindow = async (
  bounds: WindowBounds,
  area: WorkArea,
  id?: string,
) => {
  const anchor = id && (await readWindowBounds(id));
  return anchor
    ? fitWindowToWorkArea(placeBeside(bounds, anchor, area), area)
    : bounds;
};

const currentWorkArea = (nativePos: [number, number]) =>
  readWorkArea(
    window.screen,
    window.devicePixelRatio || 1,
    [window.screenLeft, window.screenTop],
    nativePos,
  );

const setPopupBounds = (bounds: WindowBounds, current: PopupGeometry) => {
  const changes: Record<string, string> = {};
  if (
    bounds.size[0] !== current.size[0] ||
    bounds.size[1] !== current.size[1]
  ) {
    changes.size = nativeWindowSize(bounds.size, current.frame);
  }
  if (bounds.pos[0] !== current.pos[0] || bounds.pos[1] !== current.pos[1]) {
    changes.pos = bounds.pos.join(',');
  }
  if (Object.keys(changes).length) {
    Byond.winset(Byond.windowId, changes);
  }
};

const popupSample = () => {
  const { innerWidth, innerHeight, screenLeft, screenTop, devicePixelRatio } =
    window;
  const { availWidth, availHeight, availLeft, availTop } =
    window.screen as Screen & { availLeft?: number; availTop?: number };
  return [
    innerWidth,
    innerHeight,
    screenLeft,
    screenTop,
    devicePixelRatio,
    availWidth,
    availHeight,
    availLeft,
    availTop,
  ].join(',');
};

/** Sample after a move or resize settles. CEF does not expose a portable screen-change event. */
export const watchPopupWorkArea = (
  isCurrent: () => boolean,
  opening?: PopupSize | void,
) => {
  watchingPopup = true;
  let observed = popupSample();
  let checked = '';
  let checking = false;
  let readAttempts = 0;
  let lastCorrection = '';
  let lastStored = '';
  let automatic = opening?.automatic ?? false;
  let previousSize = opening?.size;
  let previousScale = window.devicePixelRatio;
  const timer = setInterval(async () => {
    const sample = popupSample();
    if (sample !== observed) {
      observed = sample;
      readAttempts = 0;
      return;
    }
    if (
      checking ||
      sample === checked ||
      readAttempts >= MAX_GEOMETRY_READ_ATTEMPTS ||
      dragging ||
      resizing ||
      !isCurrent()
    ) {
      return;
    }
    readAttempts++;
    checking = true;
    const current = await readNativeGeometry();
    checking = false;
    if (
      !current ||
      !isCurrent() ||
      sample !== popupSample() ||
      dragging ||
      resizing
    ) {
      return;
    }
    checked = sample;
    const area = currentWorkArea(current.pos);
    const fitted = fitWindowToWorkArea(current, area);
    if (
      previousSize &&
      previousScale === window.devicePixelRatio &&
      (Math.abs(current.size[0] - previousSize[0]) > 1 ||
        Math.abs(current.size[1] - previousSize[1]) > 1)
    ) {
      automatic = false;
    }
    previousSize = fitted.size;
    previousScale = window.devicePixelRatio;
    const correction = JSON.stringify({ current, fitted });
    if (correction !== lastCorrection) {
      lastCorrection = correction;
      setPopupBounds(fitted, current);
    }
    const stored = JSON.stringify({ fitted, automatic });
    if (stored !== lastStored) {
      lastStored = stored;
      storeWindowGeometry(fitted, automatic);
    }
  }, WORK_AREA_POLL_MS);
  return () => {
    watchingPopup = false;
    clearInterval(timer);
  };
};

// Recall window geometry from local storage and apply it
export const recallWindowGeometry = async (
  options: {
    fancy?: BooleanLike;
    pos?: [number, number];
    size?: [number, number];
    locked?: BooleanLike;
    scale?: BooleanLike;
  } = {},
  {
    fitWorkArea,
    besideWindow,
    isCurrent,
    useFallback,
  }: {
    fitWorkArea?: boolean;
    /** With fitWorkArea, a window this one opens beside rather than over */
    besideWindow?: string;
    isCurrent?: () => boolean;
    useFallback?: boolean;
  } = {},
) => {
  const storedGeometry =
    (options.fancy || fitWorkArea) && storage.get(windowKey);
  const geometry =
    storedGeometry &&
    (await (useFallback
      ? geometryOrFallback(storedGeometry, undefined)
      : storedGeometry));
  if (isCurrent && !isCurrent()) {
    return;
  }
  if (geometry) {
    logger.log('recalled geometry:', geometry);
  }
  // options.pos is assumed to already be in display-pixels
  let pos = geometry?.pos || options.pos;
  let size = options.size;
  // Convert size from css-pixels to display-pixels
  if (options.scale && size) {
    size = [size[0] * pixelRatio, size[1] * pixelRatio];
  }

  if (!options.scale) {
    document.body.style.zoom = `${100 / window.devicePixelRatio}%`;
    document.documentElement.style.setProperty(
      '--scaling-amount',
      window.devicePixelRatio.toString(),
    );
  } else {
    document.body.style.zoom = '';
    document.documentElement.style.setProperty('--scaling-amount', null);
  }

  // Wait until screen offset gets resolved
  await screenOffsetPromise;
  if (isCurrent && !isCurrent()) {
    return;
  }
  if (fitWorkArea && options.size) {
    let current = await readNativeGeometry(isCurrent ?? (() => true));
    if (isCurrent && !isCurrent()) {
      return;
    }
    const saved = geometry?.popupBounds;
    const savedPos = saved?.pos ?? (pos && vecAdd(pos, screenOffset));
    const fallbackPos = vecAdd(getWindowPosition(), screenOffset) as [
      number,
      number,
    ];
    let area = currentWorkArea(current?.pos ?? fallbackPos);
    let frame = current?.frame;
    if (
      current &&
      savedPos &&
      (savedPos[0] !== current.pos[0] || savedPos[1] !== current.pos[1])
    ) {
      const beforeMove = popupSample();
      // Allow CEF to report the destination monitor before using its browser coordinates.
      setPopupBounds({ ...current, pos: savedPos }, current);
      await new Promise((resolve) =>
        setTimeout(resolve, MONITOR_MOVE_SETTLE_MS),
      );
      if (isCurrent && !isCurrent()) {
        return;
      }
      current = await readNativeGeometry();
      if (isCurrent && !isCurrent()) {
        return;
      }
      if (current) {
        frame = current.frame;
        if (beforeMove !== popupSample()) {
          area = currentWorkArea(current.pos);
        }
      }
    }
    const deviceScale = window.devicePixelRatio || 1;
    const ratio = options.scale ? deviceScale : 1;
    frame ??= [
      Math.max(0, (window.outerWidth - window.innerWidth) * deviceScale),
      Math.max(0, (window.outerHeight - window.innerHeight) * deviceScale),
    ];
    const preferred: WindowBounds['size'] = [
      options.size[0] * ratio,
      options.size[1] * ratio,
    ];
    const { size: wantedSize, automatic } = popupWindowSize(
      geometry,
      preferred,
      frame,
      area,
    );
    const wantedPos: [number, number] = savedPos ?? [
      area.origin[0] === undefined || !(area.size[0] > 0)
        ? (current?.pos ?? fallbackPos)[0]
        : area.origin[0] + Math.floor((area.size[0] - wantedSize[0]) / 2),
      area.origin[1] === undefined || !(area.size[1] > 0)
        ? (current?.pos ?? fallbackPos)[1]
        : area.origin[1] + Math.floor((area.size[1] - wantedSize[1]) / 2),
    ];
    const fitted = await fitBesideWindow(
      fitWindowToWorkArea({ pos: wantedPos, size: wantedSize }, area),
      area,
      besideWindow,
    );
    if (isCurrent && !isCurrent()) {
      return;
    }
    if (current) {
      setPopupBounds(fitted, current);
    } else {
      Byond.winset(Byond.windowId, {
        size: nativeWindowSize(fitted.size, frame),
        pos: fitted.pos.join(','),
      });
    }
    return { size: fitted.size, automatic };
  }
  const areaAvailable = getScreenSize();
  // Set window size
  if (size) {
    // Constraint size to not exceed available screen area
    size = [
      Math.min(areaAvailable[0], size[0]),
      Math.min(areaAvailable[1], size[1]),
    ];
    setWindowSize(size);
  }
  // Set window position
  if (pos) {
    // Constraint window position if monitor lock was set in preferences.
    if (size && options.locked) {
      pos = constraintPosition(pos, size)[1];
    }
    setWindowPosition(pos);
    // Set window position at the center of the screen.
  } else if (size) {
    pos = vecAdd(
      vecScale(areaAvailable, 0.5),
      vecScale(size, -0.5),
      vecScale(screenOffset, -1.0),
    );
    setWindowPosition(pos);
  }
};

// Setup draggable window
export const setupDrag = async (waitForGeometry = false) => {
  // Calculate screen offset caused by the windows taskbar
  const windowPosition = getWindowPosition();

  const request: Promise<[number, number]> = Byond.winget(
    Byond.windowId,
    'pos',
  ).then((pos): [number, number] => [
    pos.x - windowPosition[0],
    pos.y - windowPosition[1],
  ]);
  const pending = waitForGeometry
    ? geometryOrFallback<[number, number]>(request, [0, 0])
    : request;
  screenOffsetPromise = pending;
  const offset = await pending;
  if (screenOffsetPromise === pending) {
    screenOffset = offset;
    logger.debug('screen offset', screenOffset);
  }
};

/**
 * Constraints window position to safe screen area, accounting for safe
 * margins which could be a system taskbar.
 */
const constraintPosition = (
  pos: [number, number],
  size: [number, number],
): [boolean, [number, number]] => {
  const screenPos = getScreenPosition();
  const screenSize = getScreenSize();
  const nextPos: [number, number] = [pos[0], pos[1]];
  let relocated = false;
  for (let i = 0; i < 2; i++) {
    const leftBoundary = screenPos[i];
    const rightBoundary = screenPos[i] + screenSize[i];
    if (pos[i] < leftBoundary) {
      nextPos[i] = leftBoundary;
      relocated = true;
    } else if (pos[i] + size[i] > rightBoundary) {
      nextPos[i] = rightBoundary - size[i];
      relocated = true;
    }
  }
  return [relocated, nextPos];
};

// Start dragging the window
export const dragStartHandler = (event) => {
  logger.log('drag start');
  dragging = true;
  dragPointOffset = vecSubtract(
    [event.screenX * pixelRatio, event.screenY * pixelRatio],
    getWindowPosition(),
  ) as [number, number];
  // Focus click target
  (event.target as HTMLElement)?.focus();
  document.addEventListener('mousemove', dragMoveHandler);
  document.addEventListener('mouseup', dragEndHandler);
  dragMoveHandler(event);
};

// End dragging the window
const dragEndHandler = (event) => {
  logger.log('drag end');
  dragMoveHandler(event);
  document.removeEventListener('mousemove', dragMoveHandler);
  document.removeEventListener('mouseup', dragEndHandler);
  dragging = false;
  if (!watchingPopup) {
    storeWindowGeometry();
  }
};

// Move the window while dragging
const dragMoveHandler = (event: MouseEvent) => {
  if (!dragging) {
    return;
  }
  event.preventDefault();
  setWindowPosition(
    vecSubtract(
      [event.screenX * pixelRatio, event.screenY * pixelRatio],
      dragPointOffset,
    ) as [number, number],
  );
};

// Start resizing the window
export const resizeStartHandler =
  (x: number, y: number) => (event: MouseEvent) => {
    resizeMatrix = [x, y];
    logger.log('resize start', resizeMatrix);
    resizing = true;
    dragPointOffset = vecSubtract(
      [event.screenX * pixelRatio, event.screenY * pixelRatio],
      getWindowPosition(),
    ) as [number, number];
    initialSize = getWindowSize();
    // Focus click target
    (event.target as HTMLElement)?.focus();
    document.addEventListener('mousemove', resizeMoveHandler);
    document.addEventListener('mouseup', resizeEndHandler);
    resizeMoveHandler(event);
  };

// End resizing the window
const resizeEndHandler = (event: MouseEvent) => {
  logger.log('resize end', size);
  resizeMoveHandler(event);
  document.removeEventListener('mousemove', resizeMoveHandler);
  document.removeEventListener('mouseup', resizeEndHandler);
  resizing = false;
  if (!watchingPopup) {
    storeWindowGeometry();
  }
};

// Move the window while resizing
const resizeMoveHandler = (event: MouseEvent) => {
  if (!resizing) {
    return;
  }
  event.preventDefault();
  const currentOffset = vecSubtract(
    [event.screenX * pixelRatio, event.screenY * pixelRatio],
    getWindowPosition(),
  );
  const delta = vecSubtract(currentOffset, dragPointOffset);
  // Extra 1x1 area is added to ensure the browser can see the cursor
  size = vecAdd(initialSize, vecMultiply(resizeMatrix, delta), [1, 1]) as [
    number,
    number,
  ];
  // Sane window size values
  size[0] = Math.max(size[0], 150 * pixelRatio);
  size[1] = Math.max(size[1], 50 * pixelRatio);
  setWindowSize(size);
};
