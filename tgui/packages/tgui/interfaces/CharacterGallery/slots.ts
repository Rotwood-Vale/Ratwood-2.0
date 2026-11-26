import type { ImageForm } from './types';

// Slot and Undo point names, which must match character_gallery.dm
/** The headshot's slot name, which also names its Undo point */
export const HEADSHOT_SLOT = 'headshot';
/** The OOC extra picture's slot name, nsfw_extra for the NSFW one and extra for the other */
export const extraSlot = (nsfw: boolean) => (nsfw ? 'nsfw_extra' : 'extra');
/** The Undo point for a picture removed from an art gallery or a link removed from the hidden links */
export const removedPoint = (scope: 'art' | 'nsfw_art' | 'blocked') =>
  `${scope}_removed`;
/** The Undo point Clear All Images leaves */
export const UNDO_CLEAR = 'clear_all';
/** The Undo point Apply to All Artwork leaves */
export const UNDO_ARTWORK_SETTINGS = 'artwork_settings';

/** An art gallery's name as the window shows it */
export const galleryLabel = (nsfw: boolean) => (nsfw ? 'NSFW Art' : 'SFW Art');
/** An art picture's name as the window shows it, its gallery's name then its position counted from 1 */
export const artLabel = (nsfw: boolean, position: number) =>
  `${galleryLabel(nsfw)} ${position}`;
/** An OOC extra picture's name as the window shows it */
export const extraLabel = (nsfw: boolean) =>
  nsfw ? 'NSFW OOC Extra' : 'OOC Extra';

/** Whether any slot of the form holds a picture or a hidden link, so Clear All Images has something to remove */
export const formHasImages = (form: ImageForm) =>
  !!(
    form.headshot ||
    form.ooc_extra_img ||
    form.nsfw_ooc_extra_img ||
    form.img_gallery?.length ||
    form.nsfw_img_gallery?.length ||
    form.blocked_links?.length
  );
