// Slot names the owner's window and the viewer share, which must match character_gallery.dm

/** The first part of an art picture's slot name, nsfw_art for the NSFW gallery and art for the other */
export const artScope = (nsfw: boolean) => (nsfw ? 'nsfw_art' : 'art');
/** An art picture's slot name, its scope then its position counted from 1, such as art_1 */
export const artSlot = (nsfw: boolean, index: number) =>
  `${artScope(nsfw)}_${index}`;
/** An art picture's position counted from 0, read from its slot name */
export const artIndex = (nsfw: boolean, slot: string) =>
  Number(slot.slice(artScope(nsfw).length + 1)) - 1;
