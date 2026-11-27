import {
  type KeyboardEvent,
  type PointerEvent,
  type RefObject,
  useRef,
} from 'react';

import type { ArtCrop } from '../../common/artViewSettings';
import type { Area } from '../../common/cardLayout';
import { layoutScale } from '../../common/layoutScale';
import {
  captureDrag,
  isDragButton,
  withinDragThreshold,
} from '../editorPointer';
import {
  dragCrop,
  dragScrollingCrop,
  type EditorView,
  type Layout,
  type Part,
  partOf,
  pictureLayout,
  sameCrop,
  settleView,
} from './cropGeometry';

type DragStart = {
  pointerId: number;
  pointerX: number;
  pointerY: number;
  part: Part;
  /** The crop as the owner set it, none for the default */
  original: ArtCrop | undefined;
  box: ArtCrop;
  keepShape: boolean;
  view: EditorView;
  /** Screen pixels per layout pixel, which tgui scaling can make differ from 1 */
  scale: number;
  moved: boolean;
};

/**
 * The framing box's pointer drag and pan, which keep the box and view of the press for the whole drag.
 * start reads the layout, crop, box and view of the render that took the press into the drag record,
 * so a later render never changes a drag under way
 */
export const useCropDrag = (editor: {
  stageRef: RefObject<HTMLDivElement | null>;
  size: [number, number] | null;
  stage: Area;
  layout: Layout | null;
  crop: ArtCrop | undefined;
  box: ArtCrop;
  keepShape: boolean;
  editorView: EditorView;
  setEditorView: (view: EditorView) => void;
  changeCrop: (next: ArtCrop | undefined) => void;
}) => {
  const {
    stageRef,
    size,
    stage,
    layout,
    crop,
    box,
    keepShape,
    editorView,
    setEditorView,
    changeCrop,
  } = editor;
  const drag = useRef<DragStart | null>(null);

  const endDrag = () => {
    const start = drag.current;
    drag.current = null;
    const element = stageRef.current;
    if (start && element?.hasPointerCapture(start.pointerId)) {
      element.releasePointerCapture(start.pointerId);
    }
    return start;
  };

  const start = (event: PointerEvent<HTMLDivElement>) => {
    const element = stageRef.current;
    if (!isDragButton(event) || !layout || !element || drag.current) {
      return;
    }
    captureDrag(event, element);
    const bounds = element.getBoundingClientRect();
    drag.current = {
      pointerId: event.pointerId,
      pointerX: event.clientX,
      pointerY: event.clientY,
      part: event.button === 2 ? 'pan' : partOf(event.target),
      original: crop,
      box,
      keepShape,
      view: editorView,
      scale: layoutScale(element, bounds),
      moved: false,
    };
  };

  const handlePointerMove = (event: PointerEvent<HTMLDivElement>) => {
    const start = drag.current;
    if (start?.pointerId !== event.pointerId || !size) {
      return;
    }
    if (!start.moved) {
      if (withinDragThreshold(start, event)) {
        return;
      }
      start.moved = true;
    }
    const startLayout = pictureLayout(size, stage, start.view);
    const dx = (event.clientX - start.pointerX) / start.scale;
    const dy = (event.clientY - start.pointerY) / start.scale;
    if (start.part === 'pan') {
      setEditorView(
        settleView(size, stage, {
          ...start.view,
          x: start.view.x - dx / startLayout.width,
          y: start.view.y - dy / startLayout.height,
        }),
      );
      return;
    }
    const shiftX = dx / startLayout.width;
    const shiftY = dy / startLayout.height;
    const next = start.keepShape
      ? dragScrollingCrop(
          start.box,
          start.part,
          shiftX,
          shiftY,
          size[0] / size[1],
        )
      : dragCrop(start.box, start.part, shiftX, shiftY, event.shiftKey);
    if (sameCrop(next, start.box, start.keepShape)) {
      changeCrop(start.original);
    } else {
      changeCrop(next);
    }
  };

  /** A release or a lost capture of the dragging pointer */
  const handlePointerEnd = (event: PointerEvent<HTMLDivElement>) => {
    if (drag.current?.pointerId === event.pointerId) endDrag();
  };

  const handleEscape = (event: KeyboardEvent<HTMLDivElement>) => {
    // Left to reach the dialog, which cancels, unless it ends a drag
    const start = drag.current;
    if (!start) {
      return;
    }
    event.preventDefault();
    event.stopPropagation();
    endDrag();
    if (start.part === 'pan') {
      setEditorView(start.view);
    } else if (start.moved) {
      changeCrop(start.original);
    }
  };

  return {
    isDragging: () => drag.current !== null,
    start,
    handlePointerMove,
    handlePointerEnd,
    handleEscape,
  };
};
