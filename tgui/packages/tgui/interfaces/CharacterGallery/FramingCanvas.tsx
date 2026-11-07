import { type PointerEvent, useEffect, useRef, useState } from 'react';
import { classes } from 'tgui-core/react';

import { HeadshotFrame } from '../common/HeadshotFrame';
import {
  clampPosition,
  coverSize,
  type DragOrigin,
  dragPosition,
  finiteOnly,
  type Framing,
  keepUnderPointer,
  nudgeStep,
  stepZoom,
} from './framing';
import { type ImageForm, useGalleryBackend, useSettled } from './shared';
import { BrokenBadge } from './Thumbnail';
import type { useMediaStatus } from './useMediaStatus';

/** The editor's side in pixels, which must match $editor-size in CharacterGallery.scss. */
const EDITOR_SIZE = 256;
const DRAG_THRESHOLD_PX = 4;
const NUDGE_PX = 1;
const NUDGE_PX_LARGE = 10;
const ZOOM_KEY_STEP = 1;
const WHEEL_ZOOM_SHARE = 0.05;

type DragStart = DragOrigin & {
  moved: boolean;
};

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

export const FramingCanvas = (props: {
  form: ImageForm;
  media: ReturnType<typeof useMediaStatus>;
  draft: ReturnType<typeof useFramingDraft>;
  zoomLimit: number;
}) => {
  const { data } = useGalleryBackend();
  const { form, media, draft, zoomLimit } = props;
  const { framing, follow, commit, abandon } = draft;
  const { broken, retry } = media;
  // While a new picture loads, the previous picture's size would aim drags and zooms wrongly
  const size = media.ready && !media.tooLarge ? media.size : null;
  const editorRef = useRef<HTMLDivElement>(null);
  const [dragging, setDragging] = useState(false);
  const [locked, setLocked] = useState(false);
  const drag = useRef<DragStart | null>(null);
  const endDrag = () => {
    const start = drag.current;
    drag.current = null;
    setDragging(false);
    return start;
  };

  const dragTo = (start: DragStart, event: PointerEvent<HTMLDivElement>) =>
    dragPosition(start, size, framing.zoom, event.clientX, event.clientY);
  const pixelStep = (axis: 0 | 1, pixels: number) =>
    nudgeStep(size, framing.zoom, axis, pixels, EDITOR_SIZE);
  const zoomBy = (step: number) =>
    stepZoom(framing.zoom, step, data.zoom_min, zoomLimit);

  const keyChange = (
    key: string,
    large: boolean,
  ): Partial<Framing> | undefined => {
    const pixels = large ? NUDGE_PX_LARGE : NUDGE_PX;
    const changes: Record<string, Partial<Framing>> = {
      ArrowLeft: { x: clampPosition(framing.x - pixelStep(0, pixels)) },
      ArrowRight: { x: clampPosition(framing.x + pixelStep(0, pixels)) },
      ArrowUp: { y: clampPosition(framing.y - pixelStep(1, pixels)) },
      ArrowDown: { y: clampPosition(framing.y + pixelStep(1, pixels)) },
      '+': { zoom: zoomBy(ZOOM_KEY_STEP) },
      '=': { zoom: zoomBy(ZOOM_KEY_STEP) },
      '-': { zoom: zoomBy(-ZOOM_KEY_STEP) },
      _: { zoom: zoomBy(-ZOOM_KEY_STEP) },
    };
    return changes[key];
  };

  const zoomAt = (clientX: number, clientY: number, step: number) => {
    const editor = editorRef.current;
    const zoom = zoomBy(step);
    if (!editor || zoom === framing.zoom) {
      return;
    }
    if (!size) {
      commit({ zoom });
      return;
    }
    const rect = editor.getBoundingClientRect();
    const [widthBefore, heightBefore] = coverSize(
      size,
      rect.width,
      framing.zoom,
    );
    const [widthAfter, heightAfter] = coverSize(size, rect.width, zoom);
    commit({
      zoom,
      x: keepUnderPointer(
        framing.x,
        widthBefore,
        widthAfter,
        rect.width,
        clientX - rect.left,
      ),
      y: keepUnderPointer(
        framing.y,
        heightBefore,
        heightAfter,
        rect.height,
        clientY - rect.top,
      ),
    });
  };

  // React's wheel listener cannot stop the window scrolling, so a native one is used
  const onWheel = useRef<(event: WheelEvent) => void>(() => undefined);
  onWheel.current = (event) => {
    if (
      event.ctrlKey ||
      !size ||
      broken ||
      drag.current ||
      document.activeElement !== editorRef.current
    ) {
      return;
    }
    event.preventDefault();
    const step = Math.max(1, Math.round(framing.zoom * WHEEL_ZOOM_SHARE));
    zoomAt(event.clientX, event.clientY, event.deltaY < 0 ? step : -step);
  };
  useEffect(() => {
    const editor = editorRef.current;
    if (!editor) {
      return;
    }
    const listener = (event: WheelEvent) => onWheel.current(event);
    editor.addEventListener('wheel', listener, { passive: false });
    return () => editor.removeEventListener('wheel', listener);
  }, []);

  return (
    <>
      <div
        className={classes([
          'CharacterGallery__frameHint',
          locked && 'CharacterGallery__frameHint--active',
        ])}
        onMouseDown={(event) => {
          // Kept from taking focus itself, so a click here locks the picture below
          event.preventDefault();
          editorRef.current?.focus();
        }}
      >
        {/* Both hints stay rendered in one grid cell with the aria-hidden one invisible, so the hint box keeps the height
        of the taller hint. Rendering only the current hint changes that height when framing starts and moves the portrait below */}
        <span className="CharacterGallery__frameHintText" aria-hidden={locked}>
          Click to adjust framing
        </span>
        <span className="CharacterGallery__frameHintText" aria-hidden={!locked}>
          Drag to move
          <SeparatorDot />
          Scroll to zoom
          <SeparatorDot />
          Esc to finish
        </span>
      </div>
      <div
        ref={editorRef}
        tabIndex={0}
        aria-label="Headshot Framing"
        className={classes([
          'CharacterGallery__frameCanvas',
          locked && 'CharacterGallery__frameCanvas--locked',
          dragging && 'CharacterGallery__frameCanvas--dragging',
        ])}
        onFocus={() => setLocked(true)}
        onBlur={() => setLocked(false)}
        onPointerDown={(event) => {
          const editor = editorRef.current;
          if (event.button !== 0 || !size || !editor) {
            return;
          }
          event.preventDefault();
          editor.focus();
          editor.setPointerCapture(event.pointerId);
          drag.current = {
            pointerX: event.clientX,
            pointerY: event.clientY,
            side: editor.getBoundingClientRect().width,
            x: framing.x,
            y: framing.y,
            moved: false,
          };
        }}
        onPointerMove={(event) => {
          const start = drag.current;
          if (!start) {
            return;
          }
          if (!start.moved) {
            const distance = Math.hypot(
              event.clientX - start.pointerX,
              event.clientY - start.pointerY,
            );
            if (distance < DRAG_THRESHOLD_PX) {
              return;
            }
            start.moved = true;
            setDragging(true);
          }
          follow(dragTo(start, event));
        }}
        onPointerUp={(event) => {
          const start = endDrag();
          // Commits only a drag that passed DRAG_THRESHOLD_PX. Every set_framing the server receives marks the headshot
          // framed, so committing a plain click would frame an unframed headshot at its default crop
          if (start?.moved) {
            commit(dragTo(start, event));
          }
        }}
        onLostPointerCapture={() => {
          if (endDrag()?.moved) {
            abandon();
          }
        }}
        onKeyDown={(event) => {
          if (event.key === 'Escape') {
            editorRef.current?.blur();
            return;
          }
          if (!size || broken) {
            return;
          }
          const change = keyChange(event.key, event.shiftKey);
          if (!change) {
            return;
          }
          event.preventDefault();
          // Commits only a key that moves zoom, x or y. Every set_framing the server receives marks the headshot framed,
          // so an arrow key pressed at its clamp limit, which changes nothing, would still frame an unframed headshot
          const changed = (Object.keys(change) as (keyof Framing)[]).some(
            (key) => change[key] !== framing[key],
          );
          if (changed) {
            commit(change);
          }
        }}
      >
        <HeadshotFrame
          key={retry}
          src={form.headshot!}
          zoom={framing.zoom}
          x={framing.x}
          y={framing.y}
          onSize={media.handleLoad}
          onError={media.handleError}
        />
        {broken && <BrokenBadge />}
      </div>
    </>
  );
};

/** A small round separator, drawn rather than typed, since the themes' fonts lack a middle dot. */
const SeparatorDot = () => <span className="CharacterGallery__separatorDot" />;
