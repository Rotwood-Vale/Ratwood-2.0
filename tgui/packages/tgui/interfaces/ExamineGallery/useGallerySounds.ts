import { useEffect, useRef } from 'react';

import { resolveAsset } from '../../assets';
import {
  CARD_SOUND,
  changeSound,
  SLIP_SOUND,
  SOUND_FILES,
} from './gallerySounds';
import type { PictureChange } from './galleryWheel';

/** How loud a card sounds on a click and on the thumbnails being dealt, as its file is made louder for the main picture. */
const CARD_CLICK_VOLUME = 0.83;
const CARD_THUMBNAIL_VOLUME = 0.58;

export const useGallerySounds = (enabled: boolean, eggs: boolean) => {
  const enabledNow = useRef(enabled);
  enabledNow.current = enabled;
  const eggsNow = useRef(eggs);
  eggsNow.current = eggs;
  const pools = useRef<Record<string, HTMLAudioElement[]>>({});
  useEffect(() => {
    if (!enabled) {
      return;
    }
    const preloaded: Record<string, HTMLAudioElement[]> = {};
    for (const name of SOUND_FILES) {
      if (name === SLIP_SOUND && !eggs) {
        continue;
      }
      const audio = new Audio(resolveAsset(name));
      audio.preload = 'auto';
      preloaded[name] = [audio];
    }
    pools.current = preloaded;
  }, [enabled, eggs]);

  const idleAudio = (name: string) => {
    let pool = pools.current[name];
    if (!pool) {
      pool = [new Audio(resolveAsset(name))];
      pools.current[name] = pool;
    }
    const idle = pool.find((audio) => audio.paused);
    if (idle) {
      return idle;
    }
    const copy = pool[0].cloneNode() as HTMLAudioElement;
    pool.push(copy);
    return copy;
  };

  const play = (name: string, volume = 1) => {
    if (!enabledNow.current) {
      return;
    }
    const audio = idleAudio(name);
    audio.currentTime = 0;
    audio.volume = volume;
    // A window that has not been interacted with refuses to play, which is not worth reporting
    audio.play().catch(() => {});
  };

  return {
    playChange: (change: PictureChange) => {
      const name = changeSound(
        change,
        eggsNow.current ? Math.random() : undefined,
      );
      play(name, name === CARD_SOUND ? CARD_CLICK_VOLUME : 1);
    },
    playDealtThumbnail: () => play(CARD_SOUND, CARD_THUMBNAIL_VOLUME),
    playDealtPicture: () => play(CARD_SOUND),
  };
};
