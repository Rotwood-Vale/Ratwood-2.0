import type { BooleanLike } from 'tgui-core/react';

export type GallerySettings = {
  plain: BooleanLike;
  backdrop: BooleanLike;
  card_deal: BooleanLike;
  image_sounds: BooleanLike;
  image_tilt: BooleanLike;
  candle_flicker: BooleanLike;
  easter_eggs: BooleanLike;
  /** The viewer's Sound Effects slider scaled by Master, 0 to 100 */
  sound_volume: number;
};

export type GalleryEffects = {
  plain: boolean;
  backdrop: boolean;
  deal: boolean;
  sounds: boolean;
  tilt: boolean;
  flicker: boolean;
  eggs: boolean;
  /** Multiplier for every gallery sound, 0 to 1 */
  volume: number;
};

export const galleryEffects = (
  gallery: GallerySettings | undefined,
): GalleryEffects => {
  const plain = !!gallery?.plain;
  const fancy = (setting: BooleanLike | undefined) => !plain && !!setting;
  return {
    plain,
    backdrop: fancy(gallery?.backdrop),
    deal: fancy(gallery?.card_deal),
    sounds: fancy(gallery?.image_sounds),
    tilt: fancy(gallery?.image_tilt),
    flicker: fancy(gallery?.candle_flicker),
    eggs: fancy(gallery?.easter_eggs),
    volume: Math.min(1, Math.max(0, (gallery?.sound_volume ?? 100) / 100)),
  };
};
