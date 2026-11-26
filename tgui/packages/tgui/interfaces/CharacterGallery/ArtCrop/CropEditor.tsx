import {
  type KeyboardEvent,
  type ReactNode,
  type RefObject,
  useEffect,
  useLayoutEffect,
  useRef,
  useState,
} from 'react';
import { Box, Icon } from 'tgui-core/components';
import { clamp } from 'tgui-core/math';
import { classes } from 'tgui-core/react';

import {
  type ArtCrop,
  type ArtViewSettings,
  FULL_CROP,
} from '../../common/artViewSettings';
import type { Area } from '../../common/cardLayout';
import { layoutScale } from '../../common/layoutScale';
import { usePictureSize } from '../../common/pictureSize';
import { useNativeWheel } from '../../common/useNativeWheel';
import {
  readerSideLimit,
  readingBox,
} from '../../ExamineGallery/Reader/readingGeometry';
import {
  ARROW_DIRECTIONS,
  nudgePixels,
  zoomKeyDirection,
} from '../editorPointer';
import { gallerySelectEvents } from '../nativeSelect';
import {
  clampCropZoom,
  cropZoom,
  cropZoomPoint,
  dragCrop,
  dragScrollingCrop,
  type EditorView,
  type Layout,
  pictureLayout,
  sameCrop,
  zoomCrop,
  zoomView,
} from './cropGeometry';
import { CropStage } from './CropStage';
import { framingNote, framingStatus, tooThinText } from './cropText';
import { type CropSliderStart, CropZoomSlider } from './CropZoomSlider';
import { EditorMagnifier } from './EditorMagnifier';
import { FramingHelp } from './FramingHelp';
import { useCropDrag } from './useCropDrag';

const CROP_ZOOM_STEP = 1.1;
const MAGNIFY_STEP = 1.25;
/** The editor zooms in until one picture pixel covers this many screen pixels, and always to at least ZOOM_MAX_LEAST */
const ZOOM_SCREEN_PIXELS = 2;
const ZOOM_MAX_LEAST = 4;
const ZOOM_MAX_MOST = 64;

type ZoomCropBy = (factor: number, point?: { x: number; y: number }) => void;

type Magnify = (direction: 1 | -1, point?: { x: number; y: number }) => void;

/** Ctrl+wheel magnifies the editor under the pointer. Plain wheel edits the focused framing box. */
const useCropWheel = (editor: {
  stageRef: RefObject<HTMLDivElement | null>;
  cropDrag: ReturnType<typeof useCropDrag>;
  layout: Layout | null;
  disabled: boolean;
  box: ArtCrop;
  scrolling: boolean;
  zoomCropBy: ZoomCropBy;
  magnify: Magnify;
}) => {
  const {
    stageRef,
    cropDrag,
    layout,
    disabled,
    box,
    scrolling,
    zoomCropBy,
    magnify,
  } = editor;
  useNativeWheel(stageRef, (event) => {
    const element = stageRef.current;
    if (
      !event.deltaY ||
      !element ||
      (!event.ctrlKey && document.activeElement !== element)
    ) {
      return;
    }
    event.preventDefault();
    if (!layout || disabled || cropDrag.isDragging()) {
      return;
    }
    const bounds = element.getBoundingClientRect();
    const scale = layoutScale(element, bounds);
    const x = (event.clientX - bounds.left) / scale;
    const y = (event.clientY - bounds.top) / scale;
    if (event.ctrlKey) {
      magnify(event.deltaY < 0 ? 1 : -1, { x, y });
      return;
    }
    const point = {
      x: (x - layout.left) / layout.width,
      y: (y - layout.top) / layout.height,
    };
    const inside =
      point.x >= box.x &&
      point.x <= box.x + box.w &&
      point.y >= box.y &&
      point.y <= box.y + box.h;
    zoomCropBy(
      event.deltaY < 0 ? CROP_ZOOM_STEP : 1 / CROP_ZOOM_STEP,
      inside ? point : cropZoomPoint(box, scrolling),
    );
  });
};

/** The stage's keys, Escape for a drag then the arrows and the zoom keys for the box */
const cropKeyHandler =
  (editor: {
    cropDrag: ReturnType<typeof useCropDrag>;
    size: [number, number] | null;
    layout: Layout | null;
    disabled: boolean;
    box: ArtCrop;
    scrolling: boolean;
    changeCrop: (next: ArtCrop | undefined) => void;
    zoomCropBy: ZoomCropBy;
  }) =>
  (event: KeyboardEvent<HTMLDivElement>) => {
    const {
      cropDrag,
      size,
      layout,
      disabled,
      box,
      scrolling,
      changeCrop,
      zoomCropBy,
    } = editor;
    if (event.key === 'Escape') {
      cropDrag.handleEscape(event);
      return;
    }
    gallerySelectEvents.onKeyDown(event);
    if (!size || !layout || disabled || cropDrag.isDragging()) {
      return;
    }
    const direction = ARROW_DIRECTIONS[event.key];
    if (direction) {
      event.preventDefault();
      const pixels = nudgePixels(event.shiftKey);
      const stepX = (direction[0] * pixels) / layout.width;
      const stepY = (direction[1] * pixels) / layout.height;
      const next = scrolling
        ? dragScrollingCrop(box, 'move', stepX, stepY, size[0] / size[1])
        : dragCrop(box, 'move', stepX, stepY);
      if (!sameCrop(next, box, scrolling)) {
        changeCrop(next);
      }
      return;
    }
    const zoom = zoomKeyDirection(event.key);
    if (zoom) {
      event.preventDefault();
      zoomCropBy(zoom > 0 ? CROP_ZOOM_STEP : 1 / CROP_ZOOM_STEP);
    }
  };

/**
 * The owner can shape Card and Fitted freely. Scrolling locks its box to
 * the opening reader proportions. The magnifier changes only the editor's view.
 */
export const CropEditor = (props: {
  url: string;
  view: ArtViewSettings['opening_view'];
  crop: ArtCrop | undefined;
  openingArea?: Area;
  lock: ArtViewSettings['lock'];
  /** The picture opens only in Scrolling, so the note speaks of the two Viewer Controls it offers */
  scrollingOnly?: boolean;
  label: string;
  disabled: boolean;
  onChange: (crop: ArtCrop | undefined) => void;
  /** Shown under the Magnify Editor row, above the warning and the note */
  actions?: ReactNode;
}) => {
  const {
    url,
    view,
    crop,
    openingArea,
    lock,
    label,
    disabled,
    onChange,
    actions,
  } = props;
  const picture = usePictureSize(url, undefined, undefined, true);
  const size = picture.drawable ? picture.size : null;
  const stageRef = useRef<HTMLDivElement>(null);
  const [stage, setStage] = useState<Area>({ width: 0, height: 0 });
  const [editorView, setEditorView] = useState<EditorView>({
    zoom: 1,
    x: 0.5,
    y: 0.5,
  });
  const [active, setActive] = useState(false);
  // The crop when a slider drag began, so dragging back returns the box to where it was
  const sliderBase = useRef<CropSliderStart | null>(null);
  // Warning: DragSlider holds a released value until the same value comes back, so the slider remounts on the next box change to drop it. Dropping it inside DragSlider instead makes quick presses on server sliders repeat a step
  const sliderReleased = useRef(false);
  const [sliderKey, setSliderKey] = useState(0);

  useEffect(() => {
    const element = stageRef.current;
    if (!element) {
      return;
    }
    const measure = () =>
      setStage({ width: element.clientWidth, height: element.clientHeight });
    measure();
    const observer = new ResizeObserver(measure);
    observer.observe(element);
    return () => observer.disconnect();
  }, []);

  const scrolling = view === 'scroll';
  const [sideLimit, setSideLimit] = useState<number>();
  useLayoutEffect(() => {
    if (scrolling) setSideLimit(readerSideLimit());
  }, [scrolling]);
  const openingHeight =
    scrolling && size && openingArea && sideLimit
      ? readingBox(
          size[0] / size[1],
          openingArea,
          'scroll',
          1,
          0,
          sideLimit,
          crop,
        ).height
      : 0;
  const savedBox = crop ?? FULL_CROP;
  // An existing Scrolling frame keeps its saved origin and width when shown. Its
  // opening viewport can extend past the image and its height is independent of the saved height.
  const box =
    openingHeight && openingArea
      ? { ...savedBox, h: openingArea.height / openingHeight }
      : savedBox;
  const framingReady = !scrolling || openingHeight > 0;
  const thinWarning = tooThinText(size, crop, view, lock);
  const layout =
    framingReady && size && stage.width > 0 && stage.height > 0
      ? pictureLayout(size, stage, editorView)
      : null;
  const fit = size
    ? Math.min(stage.width / size[0], stage.height / size[1])
    : 0;
  const zoomMax =
    fit > 0
      ? clamp(ZOOM_SCREEN_PIXELS / fit, ZOOM_MAX_LEAST, ZOOM_MAX_MOST)
      : ZOOM_MAX_LEAST;

  const magnify: Magnify = (
    direction,
    point = { x: stage.width / 2, y: stage.height / 2 },
  ) => {
    const zoom =
      direction > 0
        ? editorView.zoom * MAGNIFY_STEP
        : editorView.zoom / MAGNIFY_STEP;
    // A resize can lower the limit. Keep the current zoom until the user steps back down.
    const next = clamp(zoom, 1, Math.max(editorView.zoom, zoomMax));
    if (!size || !layout || next === editorView.zoom) {
      return;
    }
    setEditorView(zoomView(size, stage, editorView, next, point));
  };

  const changeCrop = (next: ArtCrop | undefined) => {
    if (sameCrop(next, crop)) {
      return;
    }
    if (sliderReleased.current) {
      sliderReleased.current = false;
      setSliderKey((key) => key + 1);
    }
    onChange(next);
  };

  const zoomCropBy = (
    factor: number,
    point = cropZoomPoint(box, scrolling),
  ) => {
    const zoom = cropZoom(box, scrolling);
    const next = clampCropZoom(box, zoom * factor, scrolling);
    if (next !== zoom) {
      changeCrop(zoomCrop(box, next, point, scrolling));
    }
  };

  const cropDrag = useCropDrag({
    stageRef,
    size,
    stage,
    layout,
    crop,
    box,
    keepShape: scrolling,
    editorView,
    setEditorView,
    changeCrop,
  });
  useCropWheel({
    stageRef,
    cropDrag,
    layout,
    disabled,
    box,
    scrolling,
    zoomCropBy,
    magnify,
  });
  const onKeyDown = cropKeyHandler({
    cropDrag,
    size,
    layout,
    disabled,
    box,
    scrolling,
    changeCrop,
    zoomCropBy,
  });

  return (
    <>
      <div
        className={classes([
          'CharacterGallery__cropEditor',
          disabled && 'CharacterGallery__busy',
        ])}
        inert={disabled}
      >
        <div className="CharacterGallery__framingHeader">
          <div className="CharacterGallery__framingTitle">
            <strong>Framing</strong>
            <FramingHelp view={view} />
          </div>
          <span>{framingStatus(view, !!crop)}</span>
        </div>
        <CropStage
          stageRef={stageRef}
          label={label}
          active={active}
          setActive={setActive}
          onKeyDown={onKeyDown}
          pointer={{
            onPointerDown: cropDrag.start,
            onPointerMove: cropDrag.handlePointerMove,
            onPointerUp: cropDrag.handlePointerEnd,
            onLostPointerCapture: cropDrag.handlePointerEnd,
          }}
          url={url}
          picture={picture}
          size={size}
          layout={layout}
          box={box}
        />
        <div className="CharacterGallery__framingAdjustments">
          <CropZoomSlider
            ready={!!layout}
            shown={box}
            crop={crop}
            scrolling={scrolling}
            sliderBase={sliderBase}
            sliderReleased={sliderReleased}
            sliderKey={sliderKey}
            onChange={(next) => {
              if (!sameCrop(next, scrolling ? crop : box)) onChange(next);
            }}
          />
        </div>
        <EditorMagnifier
          ready={!!layout}
          zoom={editorView.zoom}
          zoomMax={zoomMax}
          onZoom={magnify}
          size={framingReady ? size : null}
          box={box}
          crop={crop}
          view={view}
          onReset={() => {
            // Reset disables itself, which would drop focus where Escape no longer reaches the dialog
            stageRef.current?.focus({ preventScroll: true });
            changeCrop(undefined);
          }}
        />
      </div>
      {/* Outside the editor, which goes inert while busy, and above the notes, so the notes never move it */}
      {actions}
      {(!!thinWarning || view !== 'fitted') && (
        <div
          className={classes([
            'CharacterGallery__framingNotes',
            disabled && 'CharacterGallery__busy',
          ])}
        >
          {!!thinWarning && (
            <Box color="average">
              <Icon name="exclamation-triangle" mr={0.5} />
              {thinWarning}
            </Box>
          )}
          {view !== 'fitted' && (
            <p className="CharacterGallery__framingNote">
              {framingNote(view, lock, !!crop, props.scrollingOnly)}
            </p>
          )}
        </div>
      )}
    </>
  );
};
