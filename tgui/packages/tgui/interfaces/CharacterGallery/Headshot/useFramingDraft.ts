import { useEffect, useRef, useState } from 'react';

import { useGalleryBackend, useSettled } from '../galleryBackend';
import type { ImageForm } from '../types';
import { finiteOnly, type Framing } from './framing';

/** The headshot's framing as its editor shows it, the saved framing under edits sent and not yet answered and under a drag still going, which the editor and its sliders share */
export const useFramingDraft = (form: ImageForm) => {
  const { act, data, isBusy, pendingChanges } = useGalleryBackend();
  const saved: Framing = {
    zoom: form.headshot_zoom,
    x: form.headshot_x,
    y: form.headshot_y,
  };
  const [draft, setDraft] = useState<Partial<Framing>>({});
  const newestDraft = useRef(draft);
  const [live, setLive] = useState<Partial<Framing>>({});
  const settle = useSettled();
  // Keys the sliders, whose own pending value only clears when the server sends that same value
  const [discards, setDiscards] = useState(0);
  const replaceDraft = (next: Partial<Framing>) => {
    newestDraft.current = next;
    setDraft(next);
  };
  const discard = () => {
    settle.cancel();
    replaceDraft({});
    setLive({});
    setDiscards((count) => count + 1);
  };
  // Match edit_seq rather than framing values, since the server rounds positions to 0.1
  useEffect(() => {
    if (data.edit_seq >= pendingChanges.lastSent && !settle.isWaiting()) {
      replaceDraft({});
    }
  }, [data.edit_seq]);
  useEffect(() => discard(), [form.headshot, form.revision]);

  const follow = (changes: Partial<Framing>) => {
    if (!isBusy(form.id)) {
      setLive((previous) => ({ ...previous, ...finiteOnly(changes) }));
    }
  };
  const commit = (changes: Partial<Framing>) => {
    setLive({});
    const real = finiteOnly(changes);
    if (isBusy(form.id) || !Object.keys(real).length) {
      return;
    }
    replaceDraft({ ...newestDraft.current, ...real });
    settle.schedule((edit_seq) =>
      act('set_framing', {
        form: form.id,
        ...newestDraft.current,
        edit_seq,
      }),
    );
  };

  // Without the drag not yet released, so a range built on it holds still during the drag
  const committed: Framing = { ...saved, ...draft };
  return {
    framing: { ...committed, ...live },
    committed,
    follow,
    commit,
    abandon: () => setLive({}),
    discard,
    discards,
  };
};
