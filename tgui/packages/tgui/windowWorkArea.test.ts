import { describe, expect, test } from 'bun:test';

import {
  fitWindowToWorkArea,
  popupWindowSize,
  readWorkArea,
  type WindowBounds,
} from './windowWorkArea';

describe('popup work area', () => {
  test('recovers stretched and fullscreen legacy popups and preserves manual sizes', () => {
    const restoredSize = (size: WindowBounds['size'], version?: number) =>
      popupWindowSize(
        {
          popupBoundsVersion: version,
          popupBounds: { pos: [12, 11], size },
          size: [900, 520],
        },
        [760, 520],
        [16, 39],
        {
          origin: [0, 0],
          size: [1540, 860],
        },
      ).size;
    expect(restoredSize([1470, 420])).toEqual([776, 559]);
    expect(restoredSize([1540, 860])).toEqual([776, 559]);
    expect(restoredSize([832, 612])).toEqual([832, 612]);
    expect(restoredSize([1470, 420], 1)).toEqual([1470, 420]);
    expect(restoredSize([1540, 860], 1)).toEqual([1540, 860]);
  });

  test('uses the next draft height until a player resizes the popup', () => {
    const oldBounds: WindowBounds = { pos: [23, 31], size: [776, 559] };
    const restore = (automatic: boolean) =>
      popupWindowSize(
        {
          popupBounds: oldBounds,
          popupBoundsVersion: 1,
          popupAutomaticSize: automatic,
          size: [760, 520],
        },
        [760, 425],
        [16, 39],
        { origin: [0, 0], size: [1540, 860] },
      );
    expect(restore(true)).toEqual({ size: [776, 464], automatic: true });
    expect(restore(false)).toEqual({ size: [776, 559], automatic: false });
  });

  test('preserves valid bounds on a secondary monitor with a negative origin', () => {
    const saved: WindowBounds = { pos: [-1450, -130], size: [800, 600] };
    expect(
      fitWindowToWorkArea(saved, { origin: [-1920, -160], size: [1920, 1040] }),
    ).toEqual(saved);
  });

  test('shrinks an oversized outer window and moves an offscreen origin', () => {
    expect(
      fitWindowToWorkArea(
        { pos: [2600, -200], size: [1500, 900] },
        { origin: [40, 24], size: [1240, 776] },
      ),
    ).toEqual({ pos: [40, 24], size: [1240, 776] });
  });

  test('moves an offscreen window without changing a size that fits', () => {
    expect(
      fitWindowToWorkArea(
        { pos: [2600, 900], size: [600, 500] },
        { origin: [0, 0], size: [1280, 800] },
      ),
    ).toEqual({ pos: [680, 300], size: [600, 500] });
  });

  test('converts browser dimensions in the current monitor scale', () => {
    const screen = {
      availLeft: -1280,
      availTop: 24,
      availWidth: 1280,
      availHeight: 696,
    };
    expect(readWorkArea(screen, 1.5, [-1000, 40], [-1500, 60])).toEqual({
      origin: [-1920, 36],
      size: [1920, 1044],
    });
  });

  test('limits size without guessing an unavailable work-area origin', () => {
    const screen = { availWidth: 900, availHeight: 800 };
    expect(
      fitWindowToWorkArea(
        { pos: [-1600, -200], size: [1200, 600] },
        readWorkArea(screen, 1, [-1600, -200], [-1600, -200]),
      ),
    ).toEqual({ pos: [-1600, -200], size: [900, 600] });
  });
});
