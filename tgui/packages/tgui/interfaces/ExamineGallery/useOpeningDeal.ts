import { useEffect, useState } from 'react';

import type { GalleryEffects } from './effects';
import type { GallerySession } from './gallerySession';
import { dealDelays, dealMainDelay } from './pictureChange';
import type { useGallerySounds } from './useGallerySounds';

/** The thumbnails' delays in the deal played as the gallery opens, and the sounds timed to it. cancel ends the deal for good */
export const useOpeningDeal = ({
  effects,
  session,
  selected,
  count,
  reading,
  sounds,
}: {
  effects: GalleryEffects;
  session: GallerySession;
  selected: number;
  count: number;
  reading: boolean;
  sounds: ReturnType<typeof useGallerySounds>;
}) => {
  // Each thumbnail's delay in the deal played as the gallery opens, from dealDelays() in the useState initializer so
  // it is computed once. Recomputing it on a new selection or picture count would deal every thumbnail again
  const [openingDeal, setOpeningDeal] = useState(() =>
    effects.deal && !session.opened ? dealDelays(selected, count) : null,
  );

  useEffect(() => {
    if (!openingDeal || !count) {
      return;
    }
    const timers = [
      ...(count > 1 ? openingDeal : []).map((delay) =>
        setTimeout(sounds.playDealtThumbnail, delay),
      ),
      ...(!reading
        ? [setTimeout(sounds.playDealtPicture, dealMainDelay(count))]
        : []),
    ];
    return () => timers.forEach(clearTimeout);
  }, []);

  return { delays: openingDeal, cancel: () => setOpeningDeal(null) };
};
