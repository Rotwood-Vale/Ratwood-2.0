import type { PictureChange } from './galleryWheel';

// Asset names, as /datum/asset/simple/examine_gallery_sounds sends them
const TICK_SOUND = 'gallery_tick.ogg';
export const CARD_SOUND = 'gallery_card.ogg';
export const SLIP_SOUND = 'gallery_slip.ogg';

export const SOUND_FILES = [TICK_SOUND, CARD_SOUND, SLIP_SOUND];

const SLIP_CHANCE = 0.01;

export const changeSound = (change: PictureChange, slipRoll?: number) => {
  if (slipRoll !== undefined && slipRoll < SLIP_CHANCE) {
    return SLIP_SOUND;
  }
  return change === 'deal' ? CARD_SOUND : TICK_SOUND;
};
