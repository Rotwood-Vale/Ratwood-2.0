import { expect, test } from 'bun:test';

import { GalleryEditorGeometry } from './interfaces/CharacterGallery/GalleryEditorGeometry';

test('the Side Preview grows the window right, moving it left only as far as the screen needs, then restores it', async () => {
  const previousWindow = Object.getOwnPropertyDescriptor(globalThis, 'window');
  const previousByond = Object.getOwnPropertyDescriptor(globalThis, 'Byond');
  const browser = Object.assign(new EventTarget(), {
    innerWidth: 1000,
    innerHeight: 700,
    screenLeft: 600,
    screenTop: 100,
    screen: { availLeft: 0, availTop: 0, availWidth: 1920, availHeight: 1080 },
    setTimeout,
    clearTimeout,
  });
  const writes: Record<string, string>[] = [];
  Object.defineProperty(globalThis, 'window', {
    configurable: true,
    value: browser,
  });
  Object.defineProperty(globalThis, 'Byond', {
    configurable: true,
    value: {
      winget: async () => ({
        pos: { x: browser.screenLeft, y: browser.screenTop },
        'inner-size': { x: browser.innerWidth, y: browser.innerHeight },
        'outer-size': { x: browser.innerWidth, y: browser.innerHeight },
      }),
      winset: (_: unknown, changes: Record<string, string>) => {
        writes.push(changes);
        if (changes.pos) {
          browser.screenLeft = Number(changes.pos.split(',')[0]);
        }
        const [width, height] = changes.size.split('x').map(Number);
        browser.innerWidth = width;
        browser.innerHeight = height;
        browser.dispatchEvent(new Event('resize'));
      },
    },
  });
  const geometry = new GalleryEditorGeometry();
  const settled = (growth?: number) =>
    new Promise<void>((done) => {
      void geometry.setExpanded(true, 'dialog', growth, done);
    });
  try {
    await settled();
    await settled(500);
    await settled();
    expect(writes).toEqual([
      { pos: '420,100', size: '1500x700' },
      { pos: '600,100', size: '1000x700' },
    ]);
  } finally {
    geometry.dispose();
    if (previousWindow) {
      Object.defineProperty(globalThis, 'window', previousWindow);
    } else {
      Reflect.deleteProperty(globalThis, 'window');
    }
    if (previousByond) {
      Object.defineProperty(globalThis, 'Byond', previousByond);
    } else {
      Reflect.deleteProperty(globalThis, 'Byond');
    }
  }
});
