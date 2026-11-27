import { type PointerEvent, useRef, useState } from 'react';
import { classes } from 'tgui-core/react';

import { HeadshotFrame } from '../../common/HeadshotFrame';
import { MouseControlIcon } from '../../common/MouseControlIcon';
import { useNativeWheel } from '../../common/useNativeWheel';
import {
  ARROW_DIRECTIONS,
  captureDrag,
  isDragButton,
  nudgePixels,
  withinDragThreshold,
  zoomKeyDirection,
} from '../editorPointer';
import { FrameHint } from '../FrameHint';
import { useGalleryBackend } from '../galleryBackend';
import { BrokenBadge } from '../Thumbnail';
import type { ImageForm } from '../types';
import type { useMediaStatus } from '../useMediaStatus';
import {
  clampPosition,
  coverSize,
  type DragOrigin,
  dragPosition,
  type Framing,
  keepUnderPointer,
  nudgeStep,
  stepZoom,
} from './framing';
import type { useFramingDraft } from './useFramingDraft';

/** The editor's side in pixels, which must match $editor-size in CharacterGallery.scss. */
const EDITOR_SIZE = 256;
const ZOOM_KEY_STEP = 1;
const WHEEL_ZOOM_SHARE = 0.05;

type DragStart = DragOrigin & {
  pointerId: number;
  moved: boolean;
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
    const direction = ARROW_DIRECTIONS[key];
    if (direction) {
      const pixels = nudgePixels(large);
      const [dx, dy] = direction;
      return dx
        ? { x: clampPosition(framing.x + dx * pixelStep(0, pixels)) }
        : { y: clampPosition(framing.y + dy * pixelStep(1, pixels)) };
    }
    const zoom = zoomKeyDirection(key);
    return zoom ? { zoom: zoomBy(zoom * ZOOM_KEY_STEP) } : undefined;
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

  useNativeWheel(editorRef, (event) => {
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
  });

  return (
    <>
      <FrameHint
        active={locked}
        editorRef={editorRef}
        idleText="Click to adjust framing"
      >
        <span className="CharacterGallery__frameShortcut">
          <MouseControlIcon control="left" label="Hold left mouse and drag" />
          <span aria-hidden>/</span>
          <MouseControlIcon control="right" label="Hold right mouse and drag" />
          Drag
        </span>
        <span aria-hidden>|</span>
        <span className="CharacterGallery__frameShortcut">
          <MouseControlIcon control="wheel" label="Scroll to zoom" />
          Zoom
        </span>
        <span aria-hidden>|</span>
        <span className="CharacterGallery__frameShortcut">
          <kbd>Esc</kbd> Finish
        </span>
      </FrameHint>
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
        onContextMenu={(event) => {
          if (size) event.preventDefault();
        }}
        onPointerDown={(event) => {
          const editor = editorRef.current;
          if (!isDragButton(event) || !size || !editor || drag.current) {
            return;
          }
          captureDrag(event, editor);
          drag.current = {
            pointerId: event.pointerId,
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
          if (start?.pointerId !== event.pointerId) {
            return;
          }
          if (!start.moved) {
            if (withinDragThreshold(start, event)) {
              return;
            }
            start.moved = true;
            setDragging(true);
          }
          follow(dragTo(start, event));
        }}
        onPointerUp={(event) => {
          if (drag.current?.pointerId !== event.pointerId) return;
          const start = endDrag();
          // Commits only a drag that passed DRAG_THRESHOLD_PX. Every set_framing the server receives marks the headshot
          // framed, so committing a plain click would frame an unframed headshot at its default crop
          if (start?.moved) {
            commit(dragTo(start, event));
          }
        }}
        onLostPointerCapture={(event) => {
          if (drag.current?.pointerId !== event.pointerId) return;
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
