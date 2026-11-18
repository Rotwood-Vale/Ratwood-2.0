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
const CLICK_SLOP = 5;
const FITTED_DRAG_LIMIT = 10;
const FITTED_DRAG_SCALE = 0.2;
const SETTLING_PICTURE = 'ExamineGallery__readingPicture--settling';

const fittedDragOffset = (distance: number) =>
  Math.max(
    -FITTED_DRAG_LIMIT,
    Math.min(FITTED_DRAG_LIMIT, distance * FITTED_DRAG_SCALE),
  );

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
  const readingPictureRef = useRef<HTMLDivElement>(null);
  const [readerArea, setReaderArea] = useState({ width: 0, height: 0 });
  const [sideLimit] = useState(readerSideLimit);
  const advancePress = useRef<{ id: number; x: number; y: number } | null>(
    null,
  );
  const drag = useRef<{
    id: number;
    x: number;
    y: number;
    left: number;
    top: number;
    scale: number;
    fittedWiggle: boolean;
  } | null>(null);
  const endDrag = (reader: HTMLDivElement, id: number) => {
    const start = drag.current;
    if (start?.id !== id) return;
    drag.current = null;
    const picture = readingPictureRef.current;
    if (start.fittedWiggle && picture) {
      picture.classList.add(SETTLING_PICTURE);
      picture.style.removeProperty('transform');
    }
    if (reader.hasPointerCapture(id)) reader.releasePointerCapture(id);
  };
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
    // Reciprocal wheel steps must return to exact 100% so Card Art can leave the reader
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

  useLayoutEffect(() => {
    const reader = readerRef.current;
    return () => {
      advancePress.current = null;
      if (reader && drag.current) endDrag(reader, drag.current.id);
      readingPictureRef.current?.classList.remove(SETTLING_PICTURE);
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
      onClick={(event) => {
        const press = advancePress.current;
        advancePress.current = null;
        if (
          press &&
          event.button === 0 &&
          event.buttons === 0 &&
          Math.abs(event.clientX - press.x) <= CLICK_SLOP &&
          Math.abs(event.clientY - press.y) <= CLICK_SLOP
        ) {
          onAdvance?.();
        }
      }}
      onContextMenu={(event) => {
        event.preventDefault();
      }}
      tabIndex={0}
      role="region"
      aria-label="Gallery artwork"
      onPointerDown={(event) => {
        advancePress.current = null;
        const reader =
          reading && readerRef.current?.contains(event.target as Node)
            ? readerRef.current
            : null;
        let scale = 1;
        if (reader) {
          const bounds = reader.getBoundingClientRect();
          scale = bounds.width / reader.offsetWidth || 1;
          if (
            (event.clientX - bounds.left) / scale >= reader.clientWidth ||
            (event.clientY - bounds.top) / scale >= reader.clientHeight
          ) {
            return;
          }
        }
        if (event.button === 0 || (reader && event.button === 2)) {
          (reader ?? event.currentTarget).focus({ preventScroll: true });
        }
        if (event.button === 0 && (!reader || event.pointerType !== 'touch')) {
          if (onAdvance && event.buttons === 1) {
            advancePress.current = {
              id: event.pointerId,
              x: event.clientX,
              y: event.clientY,
            };
          }
          return;
        }
        if (
          !reader ||
          (event.button !== 2 && event.pointerType !== 'touch') ||
          drag.current
        ) {
          return;
        }
        const canScroll =
          reader.scrollWidth > reader.clientWidth ||
          reader.scrollHeight > reader.clientHeight;
        const picture = readingPictureRef.current;
        const fittedWiggle =
          !canScroll && readerState.view === 'fitted' && !!picture;
        if (!canScroll && !fittedWiggle) return;
        if (fittedWiggle) picture.classList.remove(SETTLING_PICTURE);
        drag.current = {
          id: event.pointerId,
          x: event.clientX,
          y: event.clientY,
          left: reader.scrollLeft,
          top: reader.scrollTop,
          scale,
          fittedWiggle,
        };
        reader.setPointerCapture(event.pointerId);
        event.preventDefault();
      }}
      onMouseDownCapture={(event) => {
        if (event.buttons !== 1) advancePress.current = null;
      }}
      onPointerMove={(event) => {
        const press = advancePress.current;
        if (
          press?.id === event.pointerId &&
          (event.buttons !== 1 ||
            Math.abs(event.clientX - press.x) > CLICK_SLOP ||
            Math.abs(event.clientY - press.y) > CLICK_SLOP)
        ) {
          advancePress.current = null;
        }
      }}
      onPointerLeave={() => {
        advancePress.current = null;
      }}
      onPointerCancel={(event) => {
        if (advancePress.current?.id === event.pointerId) {
          advancePress.current = null;
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
          advancePress.current = null;
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
            ? 'Image viewer. Scroll to read or right-drag to pan. Zoom is locked by the owner.'
            : 'Image viewer. Scroll to read or right-drag to pan. Control and wheel to zoom.'
        }
        onScroll={(event) =>
          rememberPosition(
            event.currentTarget.scrollLeft,
            event.currentTarget.scrollTop,
          )
        }
        onPointerMove={(event) => {
          const start = drag.current;
          if (!start || start.id !== event.pointerId) return;
          if (event.pointerType !== 'touch' && !(event.buttons & 2)) {
            endDrag(event.currentTarget, event.pointerId);
            return;
          }
          const x = (event.clientX - start.x) / start.scale;
          const y = (event.clientY - start.y) / start.scale;
          if (start.fittedWiggle) {
            const picture = readingPictureRef.current;
            if (picture) {
              picture.style.transform = `translate(${fittedDragOffset(x)}px, ${fittedDragOffset(y)}px)`;
            }
            return;
          }
          event.currentTarget.scrollLeft = start.left - x;
          event.currentTarget.scrollTop = start.top - y;
          rememberPosition(
            event.currentTarget.scrollLeft,
            event.currentTarget.scrollTop,
          );
        }}
        onPointerUp={(event) => endDrag(event.currentTarget, event.pointerId)}
        onPointerCancel={(event) =>
          endDrag(event.currentTarget, event.pointerId)
        }
        onLostPointerCapture={(event) =>
          endDrag(event.currentTarget, event.pointerId)
        }
      >
        <div
          className={classes([
            'ExamineGallery__readingSurface',
            readerState.view === 'fitted' &&
              'ExamineGallery__readingSurface--fitted',
          ])}
          style={{ width: box.surfaceWidth, height: box.surfaceHeight }}
        >
          {pictures.drawable(selectedUrl) && (
            <div
              ref={readingPictureRef}
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
