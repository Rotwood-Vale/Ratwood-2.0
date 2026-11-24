import { useRef, useState } from 'react';
import { flushSync } from 'react-dom';
import { classes } from 'tgui-core/react';

import { resolveAsset } from '../../../assets';
import {
  type ArtCrop,
  type ArtViewSettings,
  cropAspect,
  zoomLocked,
} from '../../common/artViewSettings';
import {
  type Area,
  FRAME_MARGIN,
  NO_BOX,
  PICTURE_TOO_NARROW_TEXT,
  pictureBox,
  pictureTooThin,
  TILT_MARGIN,
} from '../../common/cardLayout';
import { layoutScale } from '../../common/layoutScale';
import { artworkLimitText } from '../../common/pictureSize';
import type { Backdrop, BackdropFigure } from '../Backdrop/backdrops';
import { SceneBackdrop } from '../Backdrop/SceneBackdrop';
import type { PictureMove } from '../pictureChange';
import type { Pictures } from '../usePictures';
import { BackdropPictures, PictureCards, uncroppedBox } from './PictureCards';
import { imagePoint, readerSideLimit, readingBox } from './readingGeometry';
import { isReading, type ReaderState } from './readingState';
import { ReadingSurface } from './ReadingView';
import { useAdvanceClick } from './useAdvanceClick';
import { useDealTiming } from './useDealTiming';
import { useClientSize, useElementSize } from './useElementSize';
import { useReaderDrag } from './useReaderDrag';
import { useReaderScroll } from './useReaderScroll';
import { useTilt } from './useTilt';
import { useZoomLimits, type ZoomLimits } from './useZoomLimits';

/** The text over the main picture while it cannot be shown, or none */
const mainPictureStatus = (
  images: string[],
  pictures: Pictures,
  selectedUrl: string,
  selectedArrived: boolean,
  selectedShowable: boolean,
) => {
  let status = '';
  const selectedSize = pictures.sizeOf(selectedUrl);
  const limitText = selectedSize && artworkLimitText(...selectedSize);
  if (!images.length) {
    status = 'No images available.';
  } else if (pictures.hasFailed(selectedUrl)) {
    status = 'This picture could not be loaded.';
  } else if (limitText) {
    status = limitText;
  } else if (!selectedArrived) {
    status = pictures.isSlow(selectedUrl)
      ? 'This picture is taking a while to load.'
      : 'Loading...';
  } else if (!selectedShowable) {
    status = PICTURE_TOO_NARROW_TEXT;
  }
  return status;
};

export type PictureControls = {
  zoom: (factor: number, clientX?: number, clientY?: number) => void;
  /** A plain wheel turn, seen before the reader scrolls */
  wheel: (event: WheelEvent) => void;
};

export const MainPicture = (props: {
  images: string[];
  backgrounds: string[];
  /** Each picture's crop as its card shows it */
  crops: (ArtCrop | undefined)[];
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
    anchor: ReaderState['anchor'],
    framed: boolean,
  ) => void;
  onReset: () => void;
  onZoomLimits: (limits: ZoomLimits) => void;
}) => {
  const {
    images,
    backgrounds,
    crops,
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
    onZoomLimits,
  } = props;
  const areaRef = useRef<HTMLDivElement>(null);
  const shownBox = useRef(NO_BOX);
  const reading = isReading(readerState);
  const fittedCrop = readerState.view === 'fitted' ? owner.crop : undefined;
  const clipped =
    readerState.view === 'scroll' && !!owner.crop && !!readerState.framed;
  const tiltRef = useTilt(areaRef, !plain && tiltOn && !reading, shownBox);
  const readerRef = useRef<HTMLDivElement>(null);
  const readingPictureRef = useRef<HTMLDivElement>(null);
  const framingRef = useRef<HTMLDivElement>(null);
  const [sideLimit] = useState(readerSideLimit);
  const advance = useAdvanceClick(onAdvance, sourceKey, readerState);
  const area = useElementSize(areaRef);

  const margin = plain ? 0 : FRAME_MARGIN + (tiltOn ? TILT_MARGIN : 0);
  const cardAspectAt = (index: number) => {
    const aspect = pictures.aspectOf(images[index]);
    return aspect === undefined ? undefined : cropAspect(aspect, crops[index]);
  };
  const showable = (index: number) => {
    const aspect = cardAspectAt(index);
    return aspect !== undefined && !pictureTooThin(aspect, area, margin);
  };
  const selectedUrl = images[selected];
  // The probe knows the aspect before the mounted image can paint or fire its load event.
  const selectedSize = reading ? pictures.sizeOf(selectedUrl) : undefined;
  const selectedAspect =
    selectedSize && pictures.drawable(selectedUrl)
      ? selectedSize[0] / selectedSize[1]
      : pictures.aspectOf(selectedUrl);
  const selectedArrived = selectedAspect !== undefined;
  const selectedShowable = reading ? selectedArrived : showable(selected);
  const suppressedMove = useRef<PictureMove | null>(null);
  if (reading) suppressedMove.current = move;
  const cut = move.change === 'cut' || suppressedMove.current === move;
  const isDeal = !plain && !reading && !cut && move.change === 'deal';
  const readerArea = useClientSize(readerRef, reading);
  // The selected picture laid out in the current view over an area at a zoom
  const boxAt = (layoutArea: Area, zoom: number) =>
    readingBox(
      selectedAspect ?? 1,
      layoutArea,
      readerState.view,
      zoom,
      margin,
      sideLimit,
      owner.crop,
    );
  const box = boxAt(readerArea, readerState.zoom);
  const { rememberPosition, keepPointOnNextLayout } = useReaderScroll({
    readerRef,
    framingRef,
    reading,
    selectedArrived,
    selectedAspect,
    readerArea,
    box,
    readerState,
    sourceKey,
    margin,
    onReaderPosition,
  });
  useZoomLimits({
    readerRef,
    reading,
    selectedArrived,
    box,
    boxAt,
    area,
    readerArea,
    readerState,
    onReaderChange,
    onZoomLimits,
  });

  const zoom = (factor: number, clientX?: number, clientY?: number) => {
    if (zoomLocked(owner) || !selectedArrived || !selectedShowable) return;
    const viewport = reading ? readerRef.current : areaRef.current;
    if (!viewport) return;
    const bounds = viewport.getBoundingClientRect();
    const scale = layoutScale(viewport, bounds);
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
    const currentBox = reading
      ? box
      : uncroppedBox(
          pictureBox(cropAspect(selectedAspect, crops[selected]), area, margin),
          crops[selected],
        );
    const limits = boxAt(
      { width: viewport.clientWidth, height: viewport.clientHeight },
      1,
    );
    const requestedZoom = readerState.zoom * factor;
    // Reciprocal wheel steps must return to exact 100% so Card can leave the reader
    const normalizedZoom =
      Math.abs(requestedZoom - 1) < 1e-10 ? 1 : requestedZoom;
    const next = Math.max(
      limits.zoomMin,
      Math.min(limits.zoomMax, normalizedZoom),
    );
    if (next === readerState.zoom) return;
    keepPointOnNextLayout({
      key: sourceKey,
      point: imagePoint(
        currentBox,
        { left: viewport.scrollLeft, top: viewport.scrollTop },
        pointer,
      ),
      pointer,
    });
    onReaderChange({ ...readerState, zoom: next, framed: false });
  };
  // Committed at once so the first move is not hidden behind the framing
  const leaveOpening = () => {
    const reader = readerRef.current;
    if (!clipped || !reader) return;
    flushSync(() =>
      rememberPosition(reader.scrollLeft, reader.scrollTop, false),
    );
  };
  const wheel = (event: WheelEvent) => {
    const reader = readerRef.current;
    if (!event.deltaY || !reader?.contains(event.target as Node)) return;
    const room =
      event.deltaY > 0
        ? reader.scrollHeight - reader.clientHeight - reader.scrollTop
        : reader.scrollTop;
    if (room >= 1) leaveOpening();
  };
  controlsRef.current = { zoom, wheel };

  const readerDrag = useReaderDrag({
    readerRef,
    readingPictureRef,
    readerState,
    sourceKey,
    leaveOpening,
    rememberPosition,
  });
  // Written during render, which is safe as only the mouse handler reads it
  shownBox.current =
    selectedAspect === undefined || !selectedShowable
      ? NO_BOX
      : pictureBox(cropAspect(selectedAspect, crops[selected]), area, margin);

  const { dealing, landed, dealWait } = useDealTiming(
    move,
    openingDelay,
    selectedArrived,
    isDeal,
  );

  const status = mainPictureStatus(
    images,
    pictures,
    selectedUrl,
    selectedArrived,
    selectedShowable,
  );

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
      onClick={advance.handleClick}
      onContextMenu={(event) => {
        event.preventDefault();
      }}
      tabIndex={0}
      role="region"
      aria-label="Gallery artwork"
      onPointerDown={(event) => {
        advance.clear();
        const reader =
          reading && readerRef.current?.contains(event.target as Node)
            ? readerRef.current
            : null;
        let scale = 1;
        if (reader) {
          const bounds = reader.getBoundingClientRect();
          scale = layoutScale(reader, bounds);
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
          advance.press(event);
          return;
        }
        readerDrag.start(event, reader, scale);
      }}
      onMouseDownCapture={advance.handleMouseDownCapture}
      onPointerMove={advance.handlePointerMove}
      onPointerLeave={advance.handlePointerLeave}
      onPointerCancel={advance.handlePointerCancel}
      onKeyDown={(event) => {
        if (
          event.key === 'Escape' &&
          !menuOpen &&
          (event.target === event.currentTarget ||
            event.target === readerRef.current)
        ) {
          event.preventDefault();
          event.stopPropagation();
          advance.clear();
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
        <BackdropPictures
          images={images}
          pictures={pictures}
          selected={selected}
          selectedShowable={selectedShowable}
        />
      )}
      {!plain && !reading && (
        <div ref={glowRef} className="ExamineGallery__glow" />
      )}
      <PictureCards
        tiltRef={tiltRef}
        images={images}
        backgrounds={backgrounds}
        crops={crops}
        selected={selected}
        selectedShowable={selectedShowable}
        pictures={pictures}
        move={move}
        isDeal={isDeal}
        landed={landed}
        dealWait={dealWait}
        showable={showable}
        cardAspectAt={cardAspectAt}
        area={area}
        margin={margin}
        plain={plain}
      />
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
        onPointerMove={readerDrag.handlePointerMove}
        onPointerUp={readerDrag.handlePointerEnd}
        onPointerCancel={readerDrag.handlePointerEnd}
        onLostPointerCapture={readerDrag.handlePointerEnd}
      >
        <ReadingSurface
          box={box}
          className={classes([
            'ExamineGallery__readingSurface',
            readerState.view === 'fitted' &&
              'ExamineGallery__readingSurface--fitted',
          ])}
          clip={clipped}
          crop={fittedCrop}
          pictureRef={readingPictureRef}
          image={
            pictures.drawable(selectedUrl) && {
              ...pictures.imageProps(selectedUrl),
              alt: `Picture ${selected + 1}`,
              draggable: false,
            }
          }
        />
      </div>
      {clipped && pictures.drawable(selectedUrl) && (
        // Outside the scroller, so a scroll that starts before the framing ends never shifts the crop
        <div
          ref={framingRef}
          className="ExamineGallery__framing"
          style={{ width: readerArea.width, height: readerArea.height }}
        >
          <ReadingSurface
            box={box}
            className="ExamineGallery__readingSurface"
            clip
            image={{ src: resolveAsset(selectedUrl), alt: '' }}
          />
        </div>
      )}
      {!!status && <div className="ExamineGallery__status">{status}</div>}
    </div>
  );
};
