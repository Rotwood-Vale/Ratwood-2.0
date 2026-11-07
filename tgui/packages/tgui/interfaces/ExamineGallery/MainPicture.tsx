import { useEffect, useRef, useState } from 'react';
import { classes } from 'tgui-core/react';

import { resolveAsset } from '../../assets';
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
import { SceneBackdrop } from './SceneBackdrop';
import type { Pictures } from './usePictures';
import { useTilt } from './useTilt';

/** Room left around the picture for its frame, in pixels. Holds $rail-thickness of ExamineGallery.scss, and the deal keyframes there land in the 4 px left over. */
const FRAME_MARGIN = 18;

/** Extra room around the picture while the tilt is on, so a wide picture's near edge and rail stay inside the panel at the full lean, as a 936 px wide picture leaning 7 degrees grows about 4.2% at its near edge. Sized with $rail-thickness in ExamineGallery.scss */
const TILT_MARGIN = 14;

const DEAL_LANDING_MS = 540;

export type PictureMove = {
  change: PictureChange;
  direction: number;
  from: number | null;
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
  } = props;
  const areaRef = useRef<HTMLDivElement>(null);
  const shownBox = useRef(NO_BOX);
  const tiltRef = useTilt(areaRef, !plain && tiltOn, shownBox);
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
  const selectedShowable = showable(selectedUrl);
  const isDeal = !plain && move.change === 'deal';
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
        onAdvance && 'ExamineGallery__main--clickable',
        dealing && 'ExamineGallery__main--dealing',
      ])}
      onClick={onAdvance}
    >
      {!plain && backdrop.kind === 'scene' && (
        <SceneBackdrop
          scene={backdrop}
          figures={figures}
          area={area}
          faceRef={faceRef}
        />
      )}
      {!plain && backdrop.kind === 'picture' && (
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
      {!plain && <div ref={glowRef} className="ExamineGallery__glow" />}
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
      {!!status && <div className="ExamineGallery__status">{status}</div>}
    </div>
  );
};
