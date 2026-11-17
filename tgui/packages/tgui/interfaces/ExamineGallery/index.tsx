import {
  type ReactNode,
  type RefObject,
  useEffect,
  useLayoutEffect,
  useRef,
  useState,
  type WheelEvent,
} from 'react';
import { Box, Button } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useBackend } from '../../backend';
import { artSlot, type ArtViewSettings } from '../CharacterGallery/shared';
import type { ExaminePanelData } from '../ExaminePanelData';
import {
  type Backdrop,
  type BackdropFigure,
  shownBackdrop,
  shownFigures,
} from './backdrops';
import { type GalleryEffects, galleryEffects } from './effects';
import { createFigureFace, type FigureFace } from './figureFace';
import {
  dealDelays,
  dealMainDelay,
  type PictureChange,
  thumbDealDelay,
  wheelSteps,
} from './galleryWheel';
import {
  MainPicture,
  type PictureControls,
  type PictureMove,
} from './MainPicture';
import { PlainThumbs } from './PlainThumbs';
import {
  createGallerySession,
  type GallerySession,
  isReading,
  type ReaderState,
  readingEntry,
  resetReader,
  viewLocked,
} from './readingState';
import { openCanvasContext } from './StillThumb';
import { useCandleFlicker } from './useCandleFlicker';
import { useFigureBlink } from './useFigureBlink';
import { useGallerySounds } from './useGallerySounds';
import { usePictures } from './usePictures';
import { ViewControls } from './ViewControls';
import { WheelThumb } from './WheelThumb';

const SCROLL_STEP_MS = 75;
const ARROW_NAVIGATION_BUTTONS =
  '.ExamineGallery__thumb, .ExamineGallery__plainThumb, .ExamineGallery__seal, .ExamineGallery__page, .ExamineGallery__viewToggle';

const Gallery = (props: {
  images: string[];
  backgrounds: string[];
  backdrop: Backdrop;
  figures: BackdropFigure[];
  face: FigureFace;
  effects: GalleryEffects;
  modes: ReactNode;
  galleryTabRef?: RefObject<HTMLDivElement | null>;
  session: GallerySession;
  settings: (ArtViewSettings | undefined)[];
  nsfw: boolean;
}) => {
  const {
    images,
    backgrounds,
    backdrop,
    figures,
    face,
    effects,
    modes,
    galleryTabRef,
    session,
    settings,
    nsfw,
  } = props;
  const { plain } = effects;
  const count = images.length;
  const clickChange: PictureChange = effects.deal ? 'deal' : 'fade';
  const [picked, setPicked] = useState(session.selected);
  const selected = Math.min(picked, Math.max(count - 1, 0));
  session.selected = selected;
  const [, redraw] = useState(0);
  const [menuOpen, setMenuOpen] = useState(false);
  const [zoomMax, setZoomMax] = useState(5);
  const [zoomMin, setZoomMin] = useState(1);
  const controlsRef = useRef<PictureControls | null>(null);
  const entryAt = (index: number) =>
    readingEntry(
      session,
      artSlot(nsfw, index + 1),
      images[index],
      settings[index],
      backgrounds[index] ?? 'transparent',
    );
  const entry = entryAt(selected);
  const reading = isReading(entry.state);
  const changeReader = (state: ReaderState) => {
    entry.state = state;
    redraw((version) => version + 1);
  };
  const reset = () => changeReader(resetReader(entry.owner));
  const [move, setMove] = useState<PictureMove>({
    change: reading || session.opened ? 'cut' : clickChange,
    direction: 1,
    from: null,
  });
  // Each thumbnail's delay in the deal played as the gallery opens, from dealDelays() in the useState initializer so
  // it is computed once. Recomputing it on a new selection or picture count would deal every thumbnail again
  const [openingDeal, setOpeningDeal] = useState(() =>
    effects.deal && !session.opened ? dealDelays(selected, count) : null,
  );
  const pictures = usePictures(images, selected);
  const sounds = useGallerySounds(effects.sounds, effects.eggs, effects.volume);
  const rootRef = useRef<HTMLDivElement>(null);
  const glowRef = useCandleFlicker(rootRef, effects.flicker && !reading);
  useFigureBlink(
    rootRef,
    face,
    effects.flicker && !reading && figures.some((figure) => figure.blink),
  );
  useEffect(() => {
    session.opened = true;
  }, []);

  const goTo = (index: number, direction: number, change: PictureChange) => {
    if (index === selected || count < 2) {
      return;
    }
    const next = entryAt(index);
    next.state = {
      ...resetReader(next.owner),
      view: viewLocked(next.owner) ? next.owner.opening_view : next.state.view,
    };
    const cut = reading || isReading(next.state);
    setMove({ change: cut ? 'cut' : change, direction, from: selected });
    session.selected = index;
    setPicked(index);
    setMenuOpen(false);
    sounds.playChange(change);
  };
  const step = (direction: -1 | 1, change: PictureChange) =>
    goTo((selected + direction + count) % count, direction, change);
  const pick = (index: number) =>
    goTo(index, index > selected ? 1 : -1, clickChange);
  const marker = plain ? 'ExamineGallery__page' : 'ExamineGallery__seal';

  // openCanvasContext must run before the opening frame is painted
  useLayoutEffect(() => {
    if (count > 1) {
      openCanvasContext();
    }
  }, []);

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

  // Plain Gallery turns effects.deal off but leaves openingDeal and a 'deal' move in state, so they are cleared here.
  // Without this, turning Plain Gallery off again replays whatever was left of the deal
  useEffect(() => {
    if (!plain) {
      return;
    }
    setOpeningDeal(null);
    setMove((last) =>
      last.change === 'deal' ? { ...last, change: 'fade' } : last,
    );
  }, [plain]);

  useEffect(() => {
    if (count < 2) {
      return;
    }
    const onKeyDown = (event: KeyboardEvent) => {
      const { target } = event;
      if (
        event.defaultPrevented ||
        reading ||
        menuOpen ||
        !(target instanceof HTMLElement) ||
        target.isContentEditable ||
        target.closest('input, textarea, select, dialog, [role="dialog"]')
      ) {
        return;
      }
      if (!galleryTabRef?.current?.contains(target)) {
        const button = target.closest('button, .Button');
        if (
          !rootRef.current?.contains(target) ||
          (button && !button.matches(ARROW_NAVIGATION_BUTTONS))
        ) {
          return;
        }
      }
      if (event.key === 'ArrowLeft') {
        event.preventDefault();
        step(-1, clickChange);
      } else if (event.key === 'ArrowRight') {
        event.preventDefault();
        step(1, clickChange);
      }
    };
    window.addEventListener('keydown', onKeyDown);
    return () => window.removeEventListener('keydown', onKeyDown);
  }, [count, selected, clickChange, reading, menuOpen, galleryTabRef]);

  // A hidden or unfocused window can freeze an animation partway, so everything lands at once before that
  useEffect(() => {
    const settle = () => {
      for (const animation of rootRef.current?.getAnimations({
        subtree: true,
      }) ?? []) {
        if (animation.effect?.getTiming().iterations !== Infinity) {
          animation.finish();
        }
      }
    };
    window.addEventListener('blur', settle);
    window.addEventListener('focus', settle);
    document.addEventListener('visibilitychange', settle);
    return () => {
      window.removeEventListener('blur', settle);
      window.removeEventListener('focus', settle);
      document.removeEventListener('visibilitychange', settle);
    };
  }, []);

  const lastScroll = useRef(0);
  const onWheel = (event: WheelEvent<HTMLDivElement>) => {
    if (
      event.ctrlKey ||
      !(event.target as Element).closest(
        '.ExamineGallery__thumb, .ExamineGallery__plainThumb',
      )
    ) {
      return;
    }
    const now = performance.now();
    if (!event.deltaY || now - lastScroll.current < SCROLL_STEP_MS) {
      return;
    }
    lastScroll.current = now;
    step(event.deltaY > 0 ? 1 : -1, 'fade');
  };

  return (
    <div
      ref={rootRef}
      className={classes(['ExamineGallery', plain && 'ExamineGallery--plain'])}
      onWheel={onWheel}
    >
      <MainPicture
        images={images}
        backgrounds={backgrounds}
        selected={selected}
        pictures={pictures}
        move={move}
        openingDelay={openingDeal ? dealMainDelay(count) : 0}
        backdrop={backdrop}
        figures={figures}
        plain={plain}
        tiltOn={effects.tilt}
        glowRef={glowRef}
        faceRef={face.attach}
        onAdvance={
          !reading && count > 1 ? () => step(1, clickChange) : undefined
        }
        readerState={entry.state}
        owner={entry.owner}
        sourceKey={`${artSlot(nsfw, selected + 1)}:${entry.signature}`}
        controlsRef={controlsRef}
        menuOpen={menuOpen}
        onReaderChange={changeReader}
        onReaderPosition={(left, top, anchor) => {
          entry.state.left = left;
          entry.state.top = top;
          entry.state.anchor = anchor;
        }}
        onReset={reset}
        onZoomMax={setZoomMax}
        onZoomMin={setZoomMin}
      />
      <div className="ExamineGallery__strip">
        {count > 1 && (
          <>
            <Box className="ExamineGallery__seals">
              {images.map((_, index) => (
                <button
                  key={index}
                  type="button"
                  className={classes([
                    marker,
                    index === selected && `${marker}--current`,
                  ])}
                  aria-label={`Picture ${index + 1}`}
                  aria-current={index === selected}
                  onClick={() => pick(index)}
                >
                  <span
                    className={plain ? undefined : 'ExamineGallery__sealNumber'}
                  >
                    {index + 1}
                  </span>
                </button>
              ))}
            </Box>
            {plain ? (
              <PlainThumbs
                images={images}
                selected={selected}
                pictures={pictures}
                onSelect={pick}
              />
            ) : (
              images.map((url, index) => {
                const steps = wheelSteps(index, selected, count);
                return (
                  <WheelThumb
                    key={index}
                    url={url}
                    background={backgrounds[index]}
                    index={index}
                    steps={steps}
                    dealDelay={thumbDealDelay(openingDeal, index)}
                    pictures={pictures}
                    onSelect={() =>
                      goTo(index, Math.sign(steps) || 1, clickChange)
                    }
                  />
                );
              })
            )}
          </>
        )}
        <div className="ExamineGallery__modes">
          <ViewControls
            owner={entry.owner}
            state={entry.state}
            open={menuOpen}
            onOpen={setMenuOpen}
            onView={(view) => {
              if (!viewLocked(entry.owner)) {
                changeReader({ ...resetReader(entry.owner), view });
              }
            }}
            onZoom={(factor) => controlsRef.current?.zoom(factor)}
            onReset={reset}
            zoomMax={zoomMax}
            zoomMin={zoomMin}
          />
          {modes}
        </div>
      </div>
    </div>
  );
};

export const ImageGalleryPage = (
  props: {
    session?: GallerySession;
    galleryTabRef?: RefObject<HTMLDivElement | null>;
  } = {},
) => {
  const { data } = useBackend<ExaminePanelData>();
  const {
    img_gallery,
    nsfw_img_gallery,
    is_naked,
    nsfw_examine_always,
    gallery,
    image_backdrop,
    gallery_figures,
  } = data;
  const [localSession] = useState(createGallerySession);
  const session = props.session ?? localSession;
  const [galleryMode, setGalleryMode] = useState(session.category);
  const switchCategory = (category: 'SFW' | 'NSFW') => {
    if (category === galleryMode) return;
    session.category = category;
    session.selected = 0;
    session.opened = false;
    const nextImages =
      (category === 'NSFW' ? nsfw_img_gallery : img_gallery) ?? [];
    const slot = artSlot(category === 'NSFW', 1);
    const first = readingEntry(
      session,
      slot,
      nextImages[0],
      data.art_view_settings?.[slot],
      data.card_backgrounds?.[slot] ?? 'transparent',
    );
    first.state = resetReader(first.owner);
    setGalleryMode(category);
  };
  const nsfw = galleryMode === 'NSFW';
  const [face] = useState(() => createFigureFace(nsfw));
  useLayoutEffect(() => face.turn(nsfw), [nsfw]);
  useEffect(() => face.stop, []);
  const images = (nsfw ? nsfw_img_gallery : img_gallery) || [];
  const effects = galleryEffects(gallery);
  const backdrop = shownBackdrop(effects.backdrop, image_backdrop);

  return (
    <Gallery
      key={galleryMode}
      images={images}
      session={session}
      galleryTabRef={props.galleryTabRef}
      nsfw={nsfw}
      settings={images.map(
        (_, index) => data.art_view_settings?.[artSlot(nsfw, index + 1)],
      )}
      backgrounds={images.map(
        (_, index) =>
          data.card_backgrounds?.[artSlot(nsfw, index + 1)] ?? 'transparent',
      )}
      backdrop={backdrop}
      figures={effects.eggs ? shownFigures(backdrop, gallery_figures) : []}
      face={face}
      effects={effects}
      modes={
        <>
          <Button
            selected={galleryMode === 'SFW'}
            bold={galleryMode === 'SFW'}
            onClick={() => switchCategory('SFW')}
            textAlign="center"
            minWidth="60px"
          >
            SFW
          </Button>
          <Button
            selected={galleryMode === 'NSFW'}
            disabled={!nsfw_img_gallery || (!is_naked && !nsfw_examine_always)}
            bold={galleryMode === 'NSFW'}
            onClick={() => switchCategory('NSFW')}
            textAlign="center"
            minWidth="60px"
          >
            NSFW
          </Button>
        </>
      }
    />
  );
};
