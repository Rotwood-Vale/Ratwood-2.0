import { useEffect, useLayoutEffect, useRef, useState } from 'react';
import { classes } from 'tgui-core/react';

import { resolveAsset } from '../../assets';
import type { ArtViewSettings } from '../CharacterGallery/shared';
import { CardBackground } from '../common/CardBackground';
import { PICTURE_TOO_LARGE_TEXT } from '../common/pictureSize';
import type { Backdrop, BackdropFigure } from './backdrops';
import type { PictureChange } from './galleryWheel';
import {
  NO_BOX,
  PICTURE_TOO_NARROW_TEXT,
  pictureBox,
  pictureTooThin,
} from './layout';
import {
  imagePoint,
  readerSideLimit,
  type ReadingBox,
  readingBox,
  scrollToPoint,
} from './readingGeometry';
import { isReading, type ReaderState, zoomLocked } from './readingState';
import { SceneBackdrop } from './SceneBackdrop';
import type { Pictures } from './usePictures';
import { useTilt } from './useTilt';

/** Room left around the picture for its frame, in pixels. Holds $rail-thickness of ExamineGallery.scss, and the deal keyframes there land in the 4 px left over. */
const FRAME_MARGIN = 18;

/** Extra room around the picture while the tilt is on, so a wide picture's near edge and rail stay inside the panel at the full lean, as a 936 px wide picture leaning 7 degrees grows about 4.2% at its near edge. Sized with $rail-thickness in ExamineGallery.scss */
const TILT_MARGIN = 14;

const DEAL_LANDING_MS = 540;

export type PictureMove = {
  change: PictureChange | 'cut';
  direction: number;
  from: number | null;
};

export type PictureControls = {
  zoom: (factor: number, clientX?: number, clientY?: number) => void;
};

export const MainPicture = (props: {
  images: string[];
  backgrounds: string[];
  selected: number;
  pictures: Pictures;
  move: PictureMove;
  openingDelay: number;
  backdrop: Backdrop;
  figures: BackdropFigure[];
  plain?: boolean;
  tiltOn: boolean;
  glowRef: React.RefObject<HTMLDivElement | null>;
  faceRef: (element: HTMLDivElement | null) => void;
  onAdvance?: () => void;
  readerState: ReaderState;
  owner: ArtViewSettings;
  sourceKey: string;
  controlsRef: React.RefObject<PictureControls | null>;
  menuOpen: boolean;
  onReaderChange: (state: ReaderState) => void;
  onReaderPosition: (
    left: number,
    top: number,
    anchor?: ReaderState['anchor'],
  ) => void;
  onReset: () => void;
  onZoomMax: (max: number) => void;
  onZoomMin: (min: number) => void;
}) => {
  const {
    images,
    backgrounds,
    selected,
    pictures,
    move,
    openingDelay,
    backdrop,
    figures,
    plain = false,
    tiltOn,
    glowRef,
    faceRef,
    onAdvance,
    readerState,
    owner,
    sourceKey,
    controlsRef,
    menuOpen,
    onReaderChange,
    onReaderPosition,
    onReset,
    onZoomMax,
    onZoomMin,
  } = props;
  const areaRef = useRef<HTMLDivElement>(null);
  const shownBox = useRef(NO_BOX);
  const reading = isReading(readerState);
  const tiltRef = useTilt(areaRef, !plain && tiltOn && !reading, shownBox);
  const readerRef = useRef<HTMLDivElement>(null);
  const [readerArea, setReaderArea] = useState({ width: 0, height: 0 });
  const [sideLimit] = useState(readerSideLimit);
  // Keep a reader press non-advancing until its click or a new primary press, even after Reset
  const readerPress = useRef(false);
  const drag = useRef<{
    id: number;
    x: number;
    y: number;
    left: number;
    top: number;
    scale: number;
  } | null>(null);
  const pendingPoint = useRef<{
    key: string;
    point: { x: number; y: number };
    pointer: { x: number; y: number };
  } | null>(null);
  const previousLayout = useRef<{
    box: ReadingBox;
    area: { width: number; height: number };
    state: ReaderState;
    key: string;
  } | null>(null);
  const [area, setArea] = useState({ width: 0, height: 0 });
  const [dealing, setDealing] = useState(false);
  // Once the deal lands the thrown picture loses its class so a redraw never throws it again. The shown picture keeps
  // its own, as dropping it redraws it up to a device pixel apart, and Plain Gallery ends the move before it can replay
  const [landed, setLanded] = useState<PictureMove | null>(null);

  useEffect(() => {
    const element = areaRef.current;
    if (!element) {
      return;
    }
    setArea({ width: element.clientWidth, height: element.clientHeight });
    const observer = new ResizeObserver(([entry]) =>
      setArea({
        width: entry.contentRect.width,
        height: entry.contentRect.height,
      }),
    );
    observer.observe(element);
    return () => observer.disconnect();
  }, []);

  const margin = plain ? 0 : FRAME_MARGIN + (tiltOn ? TILT_MARGIN : 0);
  const showable = (url: string) => {
    const aspect = pictures.aspectOf(url);
    return aspect !== undefined && !pictureTooThin(aspect, area, margin);
  };
  const selectedUrl = images[selected];
  const selectedAspect = pictures.aspectOf(selectedUrl);
  const selectedArrived = selectedAspect !== undefined;
  const selectedShowable = reading ? selectedArrived : showable(selectedUrl);
  const suppressedMove = useRef<PictureMove | null>(null);
  if (reading) suppressedMove.current = move;
  const cut = move.change === 'cut' || suppressedMove.current === move;
  const isDeal = !plain && !reading && !cut && move.change === 'deal';
  const box = readingBox(
    selectedAspect ?? 1,
    readerArea,
    readerState.view,
    readerState.zoom,
    margin,
    sideLimit,
  );
  const rememberPosition = (left: number, top: number) => {
    if (!selectedArrived || !readerArea.width || !readerArea.height) return;
    if (
      readerRef.current?.clientWidth !== readerArea.width ||
      readerRef.current?.clientHeight !== readerArea.height
    ) {
      return;
    }
    const point = imagePoint(
      box,
      { left, top },
      { x: readerArea.width / 2, y: 0 },
    );
    onReaderPosition(left, top, {
      ...point,
      viewportWidth: readerArea.width,
      viewportHeight: readerArea.height,
    });
  };

  useLayoutEffect(() => {
    const reader = readerRef.current;
    if (!reader || !reading) return;
    const measure = () =>
      setReaderArea((last) => {
        const next = { width: reader.clientWidth, height: reader.clientHeight };
        return last.width === next.width && last.height === next.height
          ? last
          : next;
      });
    measure();
    const observer = new ResizeObserver(measure);
    observer.observe(reader);
    return () => observer.disconnect();
  }, [reading]);

  useLayoutEffect(() => {
    const reader = readerRef.current;
    if (
      !reader ||
      !reading ||
      !selectedArrived ||
      !readerArea.width ||
      !readerArea.height
    ) {
      if (!reading) pendingPoint.current = null;
      previousLayout.current = null;
      return;
    }
    if (
      reader.clientWidth !== readerArea.width ||
      reader.clientHeight !== readerArea.height
    ) {
      return;
    }
    const previous = previousLayout.current;
    let position = { left: readerState.left, top: readerState.top };
    if (pendingPoint.current && pendingPoint.current.key !== sourceKey) {
      pendingPoint.current = null;
    }
    if (pendingPoint.current) {
      position = scrollToPoint(
        box,
        readerArea,
        pendingPoint.current.point,
        pendingPoint.current.pointer,
      );
      pendingPoint.current = null;
    } else if (
      previous &&
      previous.key === sourceKey &&
      previous.state === readerState &&
      (previous.area.width !== readerArea.width ||
        previous.area.height !== readerArea.height)
    ) {
      const point = imagePoint(previous.box, position, {
        x: previous.area.width / 2,
        y: 0,
      });
      position = scrollToPoint(box, readerArea, point, {
        x: readerArea.width / 2,
        y: 0,
      });
    } else if (
      !previous &&
      readerState.anchor &&
      (readerState.anchor.viewportWidth !== readerArea.width ||
        readerState.anchor.viewportHeight !== readerArea.height)
    ) {
      position = scrollToPoint(box, readerArea, readerState.anchor, {
        x: readerArea.width / 2,
        y: 0,
      });
    }
    reader.scrollLeft = position.left;
    reader.scrollTop = position.top;
    rememberPosition(reader.scrollLeft, reader.scrollTop);
    previousLayout.current = {
      box,
      area: readerArea,
      state: readerState,
      key: sourceKey,
    };
  }, [
    reading,
    selectedAspect,
    sourceKey,
    readerState,
    readerArea.width,
    readerArea.height,
    margin,
  ]);
  const effectiveZoomLimits = reading
    ? box
    : readingBox(
        selectedAspect ?? 1,
        area,
        readerState.view,
        1,
        margin,
        sideLimit,
      );
  useLayoutEffect(() => {
    const reader = readerRef.current;
    if (
      !selectedArrived ||
      (reading &&
        (!reader ||
          !readerArea.width ||
          !readerArea.height ||
          reader.clientWidth !== readerArea.width ||
          reader.clientHeight !== readerArea.height))
    ) {
      return;
    }
    onZoomMax(effectiveZoomLimits.zoomMax);
    onZoomMin(effectiveZoomLimits.zoomMin);
    const clamped = Math.max(
      effectiveZoomLimits.zoomMin,
      Math.min(effectiveZoomLimits.zoomMax, readerState.zoom),
    );
    if (reading && readerState.zoom !== clamped) {
      onReaderChange({ ...readerState, zoom: clamped });
    }
  }, [
    effectiveZoomLimits.zoomMin,
    effectiveZoomLimits.zoomMax,
    reading,
    readerState.zoom,
    selectedArrived,
    readerArea.width,
    readerArea.height,
  ]);

  const zoom = (factor: number, clientX?: number, clientY?: number) => {
    if (zoomLocked(owner) || !selectedArrived || !selectedShowable) return;
    const viewport = reading ? readerRef.current : areaRef.current;
    if (!viewport) return;
    const bounds = viewport.getBoundingClientRect();
    const scale = bounds.width / viewport.offsetWidth || 1;
    const pointer = {
      x:
        clientX === undefined
          ? viewport.clientWidth / 2
          : (clientX - bounds.left) / scale,
      y:
        clientY === undefined
          ? viewport.clientHeight / 2
          : (clientY - bounds.top) / scale,
    };
    const currentBox = reading ? box : pictureBox(selectedAspect, area, margin);
    const limits = readingBox(
      selectedAspect,
      { width: viewport.clientWidth, height: viewport.clientHeight },
      readerState.view,
      1,
      margin,
      sideLimit,
    );
    const requestedZoom = readerState.zoom * factor;
    // Reciprocal wheel steps must return to exact 100% so Whole Pic can leave the reader
    const normalizedZoom =
      Math.abs(requestedZoom - 1) < 1e-10 ? 1 : requestedZoom;
    const next = Math.max(
      limits.zoomMin,
      Math.min(limits.zoomMax, normalizedZoom),
    );
    if (next === readerState.zoom) return;
    pendingPoint.current = {
      key: sourceKey,
      point: imagePoint(
        currentBox,
        { left: viewport.scrollLeft, top: viewport.scrollTop },
        pointer,
      ),
      pointer,
    };
    onReaderChange({ ...readerState, zoom: next });
  };
  controlsRef.current = { zoom };
  const wheelZoom = useRef(zoom);
  wheelZoom.current = zoom;
  useEffect(() => {
    const area = areaRef.current;
    if (!area) return;
    const onWheel = (event: WheelEvent) => {
      if (!event.ctrlKey) return;
      event.preventDefault();
      event.stopPropagation();
      if (event.deltaY) {
        wheelZoom.current(
          event.deltaY < 0 ? 1.1 : 1 / 1.1,
          event.clientX,
          event.clientY,
        );
      }
    };
    area.addEventListener('wheel', onWheel, { passive: false });
    return () => area.removeEventListener('wheel', onWheel);
  }, []);

  useEffect(() => {
    const reader = readerRef.current;
    const current = drag.current;
    drag.current = null;
    if (current && reader?.hasPointerCapture(current.id)) {
      reader.releasePointerCapture(current.id);
    }
    return () => {
      drag.current = null;
    };
  }, [sourceKey, readerState]);
  // Written during render, which is safe as only the mouse handler reads it
  shownBox.current =
    selectedAspect === undefined || !selectedShowable
      ? NO_BOX
      : pictureBox(selectedAspect, area, margin);

  const openedAt = useRef(performance.now());
  const openingWait = useRef<number | null>(null);
  if (move.from === null && selectedArrived && openingWait.current === null) {
    openingWait.current = Math.max(
      0,
      openingDelay - (performance.now() - openedAt.current),
    );
  }
  const dealWait = move.from === null ? (openingWait.current ?? 0) : 0;

  useEffect(() => {
    // A step that cuts a deal short, or a deal onto a picture still loading, clears the timer that
    // would have ended it, and the area would stay over the wheel
    if (!isDeal || !selectedArrived) {
      setDealing(false);
      return;
    }
    setDealing(true);
    const timer = setTimeout(() => {
      setDealing(false);
      setLanded(move);
    }, dealWait + DEAL_LANDING_MS);
    return () => clearTimeout(timer);
  }, [move, selectedArrived, isDeal]);

  let status = '';
  if (!images.length) {
    status = 'No images available.';
  } else if (pictures.hasFailed(selectedUrl)) {
    status = 'This picture could not be loaded.';
  } else if (pictures.tooLarge(selectedUrl)) {
    status = PICTURE_TOO_LARGE_TEXT;
  } else if (!selectedArrived) {
    status = pictures.isSlow(selectedUrl)
      ? 'This picture is taking a while to load.'
      : 'Loading...';
  } else if (!selectedShowable) {
    status = PICTURE_TOO_NARROW_TEXT;
  }

  return (
    <div
      ref={areaRef}
      className={classes([
        'ExamineGallery__main',
        reading && 'ExamineGallery__main--reading',
        cut && 'ExamineGallery__main--cut',
        onAdvance && 'ExamineGallery__main--clickable',
        dealing && 'ExamineGallery__main--dealing',
      ])}
      onClick={() => {
        if (readerPress.current) {
          readerPress.current = false;
          return;
        }
        onAdvance?.();
      }}
      tabIndex={0}
      role="region"
      aria-label="Gallery artwork"
      onPointerDownCapture={(event) => {
        if (event.button === 0) {
          readerPress.current = !!readerRef.current?.contains(
            event.target as Node,
          );
        }
      }}
      onPointerDown={(event) => {
        if (event.button === 0 && !reading) {
          event.currentTarget.focus({ preventScroll: true });
        }
      }}
      onKeyDown={(event) => {
        if (
          event.key === 'Escape' &&
          !menuOpen &&
          (event.target === event.currentTarget ||
            event.target === readerRef.current)
        ) {
          event.preventDefault();
          event.stopPropagation();
          onReset();
        }
      }}
    >
      {!plain && !reading && backdrop.kind === 'scene' && (
        <SceneBackdrop
          scene={backdrop}
          figures={figures}
          area={area}
          faceRef={faceRef}
        />
      )}
      {!plain && !reading && backdrop.kind === 'picture' && (
        <div className="ExamineGallery__backdrops">
          {images.map(
            (url, index) =>
              pictures.mayLoad(index) &&
              pictures.drawable(url) && (
                <img
                  key={index}
                  className={classes([
                    'ExamineGallery__backdrop',
                    index === selected &&
                      selectedShowable &&
                      'ExamineGallery__backdrop--shown',
                  ])}
                  src={resolveAsset(url)}
                  alt=""
                />
              ),
          )}
        </div>
      )}
      {!plain && !reading && (
        <div ref={glowRef} className="ExamineGallery__glow" />
      )}
      <div
        ref={tiltRef}
        className="ExamineGallery__tilt"
        style={{ '--deal-direction': move.direction } as React.CSSProperties}
      >
        {images.map((url, index) => {
          const isShown = index === selected && selectedShowable;
          return (
            pictures.mayLoad(index) &&
            pictures.drawable(url) && (
              <div
                key={index}
                className={classes([
                  'ExamineGallery__picture',
                  isShown && 'ExamineGallery__picture--shown',
                  isShown && isDeal && 'ExamineGallery__picture--dealt',
                  index === move.from &&
                    isDeal &&
                    landed !== move &&
                    showable(url) &&
                    'ExamineGallery__picture--thrown',
                ])}
                style={
                  {
                    ...pictureBox(pictures.aspectOf(url) ?? 1, area, margin),
                    '--deal-delay': `${isShown ? dealWait : 0}ms`,
                  } as React.CSSProperties
                }
              >
                {!plain && <CardBackground value={backgrounds[index]} />}
                <img
                  {...pictures.imageProps(url)}
                  alt={`Picture ${index + 1}`}
                />
                {!plain && <span className="ExamineGallery__frame" />}
              </div>
            )
          );
        })}
      </div>
      <div
        ref={readerRef}
        className="ExamineGallery__reader"
        hidden={!reading}
        tabIndex={reading ? 0 : -1}
        role="region"
        aria-label={
          zoomLocked(owner)
            ? 'Image viewer. Scroll or drag to read. Zoom is locked by the owner.'
            : 'Image viewer. Scroll or drag to read; Control and wheel to zoom.'
        }
        onScroll={(event) =>
          rememberPosition(
            event.currentTarget.scrollLeft,
            event.currentTarget.scrollTop,
          )
        }
        onPointerDown={(event) => {
          if (event.button !== 0) return;
          const reader = event.currentTarget;
          reader.focus({ preventScroll: true });
          const bounds = reader.getBoundingClientRect();
          const scale = bounds.width / reader.offsetWidth || 1;
          if (
            (event.clientX - bounds.left) / scale >= reader.clientWidth ||
            (event.clientY - bounds.top) / scale >= reader.clientHeight
          ) {
            return;
          }
          if (
            reader.scrollWidth <= reader.clientWidth &&
            reader.scrollHeight <= reader.clientHeight
          ) {
            return;
          }
          drag.current = {
            id: event.pointerId,
            x: event.clientX,
            y: event.clientY,
            left: reader.scrollLeft,
            top: reader.scrollTop,
            scale,
          };
          reader.setPointerCapture(event.pointerId);
          event.preventDefault();
        }}
        onPointerMove={(event) => {
          const start = drag.current;
          if (!start || start.id !== event.pointerId) return;
          event.currentTarget.scrollLeft =
            start.left - (event.clientX - start.x) / start.scale;
          event.currentTarget.scrollTop =
            start.top - (event.clientY - start.y) / start.scale;
          rememberPosition(
            event.currentTarget.scrollLeft,
            event.currentTarget.scrollTop,
          );
        }}
        onPointerUp={(event) => {
          drag.current = null;
          if (event.currentTarget.hasPointerCapture(event.pointerId)) {
            event.currentTarget.releasePointerCapture(event.pointerId);
          }
        }}
        onPointerCancel={() => {
          drag.current = null;
        }}
        onLostPointerCapture={() => {
          drag.current = null;
        }}
      >
        <div
          className="ExamineGallery__readingSurface"
          style={{ width: box.surfaceWidth, height: box.surfaceHeight }}
        >
          {pictures.drawable(selectedUrl) && (
            <div
              className="ExamineGallery__readingPicture"
              style={{
                left: box.left,
                top: box.top,
                width: box.width,
                height: box.height,
              }}
            >
              <img
                {...pictures.imageProps(selectedUrl)}
                alt={`Picture ${selected + 1}`}
                draggable={false}
              />
            </div>
          )}
        </div>
      </div>
      {!!status && <div className="ExamineGallery__status">{status}</div>}
    </div>
  );
};
