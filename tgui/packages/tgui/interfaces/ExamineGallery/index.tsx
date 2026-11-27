import { storage } from 'common/storage';
import {
  type ReactNode,
  type RefObject,
  useEffect,
  useLayoutEffect,
  useRef,
  useState,
} from 'react';
import { Button } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useBackend } from '../../backend';
import { type ArtViewSettings, viewLocked } from '../common/artViewSettings';
import { CARD_DEFAULT } from '../common/CardBackground';
import type { Area } from '../common/cardLayout';
import { artSlot } from '../common/gallerySlots';
import { opensOnlyInScrolling } from '../common/pictureSize';
import type { ExaminePanelData } from '../ExaminePanelData';
import { ArtworkViewport } from './ArtworkViewport';
import {
  type Backdrop,
  type BackdropFigure,
  shownBackdrop,
  shownFigures,
} from './Backdrop/backdrops';
import { createFigureFace, type FigureFace } from './Backdrop/figureFace';
import { useCandleFlicker } from './Backdrop/useCandleFlicker';
import { useFigureBlink } from './Backdrop/useFigureBlink';
import { type GalleryEffects, galleryEffects } from './effects';
import {
  createGallerySession,
  type GallerySession,
  readingEntry,
} from './gallerySession';
import {
  dealMainDelay,
  type PictureChange,
  type PictureMove,
} from './pictureChange';
import { MainPicture, type PictureControls } from './Reader/MainPicture';
import { READER_ZOOM_MAX } from './Reader/readingGeometry';
import {
  isReading,
  type ReaderState,
  resetReader,
} from './Reader/readingState';
import { SealNumbers } from './Thumbs/SealNumbers';
import { openCanvasContext } from './Thumbs/StillThumb';
import { ThumbStrip } from './Thumbs/ThumbStrip';
import { useThumbWheel } from './Thumbs/useThumbWheel';
import type { ControlsPanel } from './Tray/TrayControls';
import { ViewControls } from './Tray/ViewControls';
import { useArrowNavigation } from './useArrowNavigation';
import { useGallerySounds } from './useGallerySounds';
import { useGalleryWheel } from './useGalleryWheel';
import { useOpeningDeal } from './useOpeningDeal';
import { usePictures } from './usePictures';
import { useSettleAnimations } from './useSettleAnimations';

const Gallery = (props: {
  images: string[];
  backgrounds: string[];
  backdrop: Backdrop;
  figures: BackdropFigure[];
  face: FigureFace;
  effects: GalleryEffects;
  modes: ReactNode;
  galleryTabRef: RefObject<HTMLDivElement | null>;
  session: GallerySession;
  settings: (ArtViewSettings | undefined)[];
  nsfw: boolean;
  controlsPinned: boolean;
  onControlsPinned: (pinned: boolean) => void;
  showMouseControls: boolean;
  onShowMouseControls: (show: boolean) => void;
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
  const [panel, setPanel] = useState<ControlsPanel>(null);
  const menuOpen = panel !== null;
  const [zoomMax, setZoomMax] = useState(READER_ZOOM_MAX);
  const [zoomMin, setZoomMin] = useState(1);
  const controlsRef = useRef<PictureControls | null>(null);
  const pictures = usePictures(images, selected);
  const entryAt = (index: number) =>
    readingEntry(
      session,
      artSlot(nsfw, index + 1),
      images[index],
      settings[index],
      backgrounds[index] ?? CARD_DEFAULT,
      pictures.sizeOf(images[index]),
    );
  const entry = entryAt(selected);
  const selectedSize = session.sizes.get(images[selected]);
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
  const sounds = useGallerySounds(effects.sounds, effects.eggs, effects.volume);
  const rootRef = useRef<HTMLDivElement>(null);
  const lit = effects.flicker && !reading;
  const glowRef = useCandleFlicker(rootRef, lit);
  useFigureBlink(rootRef, face, lit && figures.some((figure) => figure.blink));
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
    setPanel(null);
    sounds.playChange(cut ? 'fade' : change);
  };
  const step = (direction: -1 | 1, change: PictureChange) =>
    goTo((selected + direction + count) % count, direction, change);
  const pick = (index: number) =>
    goTo(index, index > selected ? 1 : -1, clickChange);

  // openCanvasContext must run before the opening frame is painted
  useLayoutEffect(() => {
    if (count > 1) {
      openCanvasContext();
    }
  }, []);

  const { delays: openingDeal, cancel: cancelOpeningDeal } = useOpeningDeal({
    effects,
    session,
    selected,
    count,
    reading,
    sounds,
  });

  // Plain Gallery turns effects.deal off but leaves openingDeal and a 'deal' move in state, so they are cleared here.
  // Without this, turning Plain Gallery off again replays whatever was left of the deal
  useEffect(() => {
    if (!plain) {
      return;
    }
    cancelOpeningDeal();
    setMove((last) =>
      last.change === 'deal' ? { ...last, change: 'fade' } : last,
    );
  }, [plain]);

  useArrowNavigation({
    count,
    selected,
    clickChange,
    reading,
    menuOpen,
    galleryTabRef,
    rootRef,
    step,
  });
  useSettleAnimations(rootRef);
  useGalleryWheel(rootRef, controlsRef);
  const onWheel = useThumbWheel(step);

  const picture = (
    <MainPicture
      images={images}
      backgrounds={backgrounds}
      crops={settings.map((setting) => setting?.crop)}
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
      onAdvance={count > 1 ? () => step(1, clickChange) : undefined}
      readerState={entry.state}
      owner={entry.owner}
      sourceKey={`${artSlot(nsfw, selected + 1)}:${entry.signature}`}
      controlsRef={controlsRef}
      menuOpen={menuOpen}
      onReaderChange={changeReader}
      onReaderPosition={(left, top, anchor, framed) => {
        // Changed in place, as a new state ends a pan already under way
        const unframed = !!entry.state.framed && !framed;
        entry.state.left = left;
        entry.state.top = top;
        entry.state.anchor = anchor;
        entry.state.framed = framed;
        if (unframed) {
          redraw((version) => version + 1);
        }
      }}
      onReset={reset}
      onZoomLimits={({ min, max }) => {
        setZoomMax(max);
        setZoomMin(min);
      }}
    />
  );
  const controls = (
    <ViewControls
      owner={entry.owner}
      scrollingOnly={!!selectedSize && opensOnlyInScrolling(...selectedSize)}
      state={entry.state}
      panel={panel}
      onPanel={setPanel}
      onView={(view) => {
        if (!viewLocked(entry.owner)) {
          changeReader({ ...resetReader(entry.owner), view });
        }
      }}
      onZoom={(factor) => controlsRef.current?.zoom(factor)}
      onReset={reset}
      zoomMax={zoomMax}
      zoomMin={zoomMin}
      pinned={props.controlsPinned}
      onPinned={props.onControlsPinned}
      showMouseControls={props.showMouseControls}
      onShowMouseControls={props.onShowMouseControls}
      imageCount={count}
      modes={modes}
      numbers={
        count > 1 ? (
          <SealNumbers
            images={images}
            selected={selected}
            plain={plain}
            onPick={pick}
          />
        ) : null
      }
      thumbnails={
        count > 1 ? (
          <ThumbStrip
            images={images}
            settings={images.map((_, index) => entryAt(index).owner)}
            backgrounds={backgrounds}
            selected={selected}
            pictures={pictures}
            plain={plain}
            openingDeal={openingDeal}
            onPick={pick}
            onGoTo={(index, direction) => goTo(index, direction, clickChange)}
          />
        ) : null
      }
    />
  );
  return (
    <div
      ref={rootRef}
      className={classes(['ExamineGallery', plain && 'ExamineGallery--plain'])}
      onWheel={onWheel}
    >
      {picture}
      {controls}
    </div>
  );
};

const GalleryModes = (props: {
  nsfw: boolean;
  nsfwDisabled: boolean;
  onSwitch: (category: 'SFW' | 'NSFW') => void;
}) => {
  const { nsfw, onSwitch } = props;
  return (
    <>
      <Button
        selected={!nsfw}
        bold={!nsfw}
        onClick={() => onSwitch('SFW')}
        textAlign="center"
      >
        SFW
      </Button>
      <Button
        selected={nsfw}
        disabled={props.nsfwDisabled}
        bold={nsfw}
        onClick={() => onSwitch('NSFW')}
        textAlign="center"
      >
        NSFW
      </Button>
    </>
  );
};

/**
 * The viewer as viewers first see it, scaled to fit, on one draft picture among the gallery's saved ones.
 * It is drawn by the viewer itself and takes no input
 */
export const ArtworkPreview = (props: {
  /** The whole viewer's size in the examine window */
  area: Area;
  /** The gallery's saved links, view settings and card backgrounds */
  images: string[];
  settings: Record<string, ArtViewSettings> | undefined;
  backgrounds: Record<string, string> | undefined;
  /** The draft's position counted from 0, after the saved links for a new picture */
  index: number;
  url: string;
  view: ArtViewSettings;
  background: string;
  backdrop?: string;
  gallery: ExaminePanelData['gallery'];
  nsfw: boolean;
}) => {
  const { index, nsfw } = props;
  const [session] = useState(() => ({
    ...createGallerySession(),
    selected: index,
  }));
  const [face] = useState(() => createFigureFace(nsfw));
  useEffect(() => face.stop, []);
  const tab = useRef<HTMLDivElement>(null);
  const effects = galleryEffects(props.gallery);
  const images = [...props.images];
  images[index] = props.url;
  const slots = images.map((_, position) => artSlot(nsfw, position + 1));
  return (
    <div inert>
      <ArtworkViewport area={props.area}>
        <Gallery
          images={images}
          settings={slots.map((slot, position) =>
            position === index ? props.view : props.settings?.[slot],
          )}
          backgrounds={slots.map((slot, position) =>
            position === index
              ? props.background
              : (props.backgrounds?.[slot] ?? CARD_DEFAULT),
          )}
          backdrop={shownBackdrop(effects.backdrop, props.backdrop)}
          figures={[]}
          face={face}
          effects={{ ...effects, deal: false, sounds: false, eggs: false }}
          modes={
            <GalleryModes
              nsfw={nsfw}
              nsfwDisabled={!nsfw}
              onSwitch={() => {}}
            />
          }
          galleryTabRef={tab}
          session={session}
          nsfw={nsfw}
          controlsPinned={false}
          onControlsPinned={() => {}}
          showMouseControls
          onShowMouseControls={() => {}}
        />
      </ArtworkViewport>
    </div>
  );
};

const useViewerPreference = (
  key: string | undefined,
  fallback: boolean,
  label: string,
) => {
  const [preference, setPreference] = useState<{
    key: typeof key;
    value: boolean;
  }>();
  useEffect(() => {
    if (!key) return;
    let mounted = true;
    storage.get(key).then(
      (saved) => {
        if (mounted) {
          // A click before the stored value arrives takes precedence
          setPreference((current) =>
            current?.key === key
              ? current
              : { key, value: typeof saved === 'boolean' ? saved : fallback },
          );
        }
      },
      (error) => console.warn(`Could not read gallery ${label}`, error),
    );
    return () => {
      mounted = false;
    };
  }, [key, fallback, label]);
  const change = (value: boolean) => {
    setPreference({ key, value });
    if (key) {
      storage
        .set(key, value)
        .catch((error) =>
          console.warn(`Could not save gallery ${label}`, error),
        );
    }
  };
  return [
    preference?.key === key ? (preference?.value ?? fallback) : fallback,
    change,
  ] as const;
};

const slotSettings = (data: ExaminePanelData, nsfw: boolean, index: number) =>
  data.art_view_settings?.[artSlot(nsfw, index + 1)];

const slotBackground = (data: ExaminePanelData, nsfw: boolean, index: number) =>
  data.card_backgrounds?.[artSlot(nsfw, index + 1)] ?? CARD_DEFAULT;

export const ImageGalleryPage = (props: {
  data: ExaminePanelData;
  session: GallerySession;
  galleryTabRef: RefObject<HTMLDivElement | null>;
}) => {
  const { config } = useBackend();
  const { data } = props;
  const viewer = config?.client?.ckey;
  const [controlsPinned, changeControlsPinned] = useViewerPreference(
    viewer && `gallery.controlsPinned:${viewer}`,
    false,
    'controls preference',
  );
  const [showMouseControls, changeShowMouseControls] = useViewerPreference(
    viewer && `gallery.showMouseControls:${viewer}`,
    true,
    'mouse controls preference',
  );
  const {
    img_gallery,
    nsfw_img_gallery,
    is_naked,
    nsfw_examine_always,
    gallery,
    image_backdrop,
    gallery_figures,
  } = data;
  const { session } = props;
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
      slotSettings(data, category === 'NSFW', 0),
      slotBackground(data, category === 'NSFW', 0),
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
      controlsPinned={controlsPinned}
      onControlsPinned={changeControlsPinned}
      showMouseControls={showMouseControls}
      onShowMouseControls={changeShowMouseControls}
      settings={images.map((_, index) => slotSettings(data, nsfw, index))}
      backgrounds={images.map((_, index) => slotBackground(data, nsfw, index))}
      backdrop={backdrop}
      figures={effects.eggs ? shownFigures(backdrop, gallery_figures) : []}
      face={face}
      effects={effects}
      modes={
        <GalleryModes
          nsfw={nsfw}
          nsfwDisabled={
            !nsfw_img_gallery || (!is_naked && !nsfw_examine_always)
          }
          onSwitch={switchCategory}
        />
      }
    />
  );
};
