import { useEffect, useRef, useState } from 'react';
import { Box, Button, Section, Stack } from 'tgui-core/components';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { HeadshotFrame } from './common/HeadshotFrame';
import { ExaminePanelData } from './ExaminePanelData';

type FlavorTextPageProps = {
  collapsed?: boolean;
};

const FONT_MIN = 0.8;
const FONT_MAX = 1.5;
const FONT_STEP = 0.1;

const bumpEm = (value: number, dir: number) =>
  Math.min(FONT_MAX, Math.max(FONT_MIN, +(value + dir * FONT_STEP).toFixed(1)));

const EmButtons = (props: {
  value: number;
  onChange: (value: number) => void;
}) => {
  const atMin = props.value <= FONT_MIN;
  const atMax = props.value >= FONT_MAX;
  return (
    <>
      <Button
        color={atMin ? undefined : 'transparent'}
        compact
        icon="minus"
        disabled={atMin}
        onClick={() => props.onChange(bumpEm(props.value, -1))}
      />
      <Button
        color={atMax ? undefined : 'transparent'}
        compact
        icon="plus"
        disabled={atMax}
        onClick={() => props.onChange(bumpEm(props.value, 1))}
      />
    </>
  );
};

const chatHtml = (text: string, empty?: string) => ({
  __html: text ? `<span class="Chat">${text}</span>` : (empty ?? ''),
});

export const FlavorTextPage = (props: FlavorTextPageProps) => {
  const { collapsed = false } = props;
  const { data } = useBackend<ExaminePanelData>();
  const {
    flavor_text,
    flavor_text_nsfw,
    ooc_notes,
    ooc_notes_nsfw,
    headshot,
    headshot_zoom,
    headshot_x,
    headshot_y,
    headshot_framed,
    is_admin,
    is_naked,
    ooc_extra_image,
    nsfw_ooc_extra_image,
    nsfw_examine_always,
  } = data;
  const [oocNotesIndex, setOocNotesIndex] = useState<'SFW' | 'NSFW'>('SFW');
  const [flavorTextIndex, setFlavorTextIndex] = useState<'SFW' | 'NSFW'>('SFW');
  const [showHeadshot, setShowHeadshot] = useState(true);
  const [showOriginal, setShowOriginal] = useState(false);
  const canShowOriginal = !!is_admin && !!headshot_framed;
  const [hideLeft, setHideLeft] = useState(false);
  const [oocEm, setOocEm] = useState({ SFW: 1, NSFW: 1 });
  const [flavorEm, setFlavorEm] = useState({ SFW: 1, NSFW: 1 });

  useEffect(() => {
    if (collapsed) {
      setHideLeft(false);
    }
  }, [collapsed]);

  const showLeft = collapsed || !hideLeft;

  return (
    <Stack fill>
      {showLeft && (
        <Stack.Item
          grow={collapsed}
          width={collapsed ? undefined : '300px'}
          minWidth={collapsed ? 0 : undefined}
        >
          <Stack fill vertical>
            {showHeadshot && (
              <Stack.Item>
                <Box mx="auto" maxWidth="350px" position="relative">
                  {canShowOriginal && showOriginal ? (
                    <img
                      src={resolveAsset(headshot)}
                      style={{
                        display: 'block',
                        width: '100%',
                        height: 'auto',
                      }}
                    />
                  ) : (
                    <HeadshotFrame
                      src={headshot}
                      framed={!!headshot_framed}
                      zoom={headshot_zoom}
                      x={headshot_x}
                      y={headshot_y}
                    />
                  )}
                  {canShowOriginal && (
                    <Box position="absolute" top={0.25} right={0.25}>
                      <Button
                        compact
                        icon={showOriginal ? 'crop' : 'image'}
                        tooltip="Admins only. Switches between the framed headshot players see and the whole picture it crops."
                        onClick={() => setShowOriginal(!showOriginal)}
                      >
                        {showOriginal ? 'Framed' : 'Original'}
                      </Button>
                    </Box>
                  )}
                </Box>
              </Stack.Item>
            )}
            <Stack.Item grow>
              <Section
                scrollable
                fill
                title="OOC Notes"
                preserveWhitespace
                buttons={
                  <>
                    <EmButtons
                      value={oocEm[oocNotesIndex]}
                      onChange={(value) =>
                        setOocEm({ ...oocEm, [oocNotesIndex]: value })
                      }
                    />
                    <Button
                      icon={showHeadshot ? 'chevron-up' : 'chevron-down'}
                      tooltip={showHeadshot ? 'Hide headshot' : 'Show headshot'}
                      selected={!showHeadshot}
                      onClick={() => setShowHeadshot(!showHeadshot)}
                    />
                    <Button
                      selected={oocNotesIndex === 'SFW'}
                      bold={oocNotesIndex === 'SFW'}
                      onClick={() => setOocNotesIndex('SFW')}
                      textAlign="center"
                      minWidth="60px"
                    >
                      SFW
                    </Button>
                    <Button
                      selected={oocNotesIndex === 'NSFW'}
                      disabled={!ooc_notes_nsfw}
                      bold={oocNotesIndex === 'NSFW'}
                      onClick={() => setOocNotesIndex('NSFW')}
                      textAlign="center"
                      minWidth="60px"
                    >
                      NSFW
                    </Button>
                  </>
                }
              >
                {oocNotesIndex === 'SFW' && (
                  <Box
                    style={{ zoom: oocEm.SFW }}
                    dangerouslySetInnerHTML={chatHtml(
                      ooc_notes,
                      '<i>No OOC notes provided.</i>',
                    )}
                  />
                )}
                {oocNotesIndex === 'NSFW' && (
                  <Box
                    style={{ zoom: oocEm.NSFW }}
                    dangerouslySetInnerHTML={chatHtml(ooc_notes_nsfw)}
                  />
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      )}
      {!collapsed && (
        <Stack.Item grow>
          <Section
            scrollable
            fill
            preserveWhitespace
            title="Flavor Text"
            buttons={
              <>
                <EmButtons
                  value={flavorEm[flavorTextIndex]}
                  onChange={(value) =>
                    setFlavorEm({ ...flavorEm, [flavorTextIndex]: value })
                  }
                />
                <Button
                  icon={hideLeft ? 'chevron-right' : 'chevron-left'}
                  tooltip={hideLeft ? 'Show left section' : 'Hide left section'}
                  selected={hideLeft}
                  onClick={() => setHideLeft(!hideLeft)}
                />
                <Button
                  selected={flavorTextIndex === 'SFW'}
                  bold={flavorTextIndex === 'SFW'}
                  onClick={() => setFlavorTextIndex('SFW')}
                  textAlign="center"
                  width="60px"
                >
                  SFW
                </Button>
                <Button
                  selected={flavorTextIndex === 'NSFW'}
                  disabled={
                    !flavor_text_nsfw || (!is_naked && !nsfw_examine_always)
                  }
                  bold={flavorTextIndex === 'NSFW'}
                  onClick={() => setFlavorTextIndex('NSFW')}
                  textAlign="center"
                  width="60px"
                >
                  NSFW
                </Button>
              </>
            }
          >
            {flavorTextIndex === 'SFW' && (
              <Box style={{ zoom: flavorEm.SFW }}>
                <Box
                  dangerouslySetInnerHTML={chatHtml(
                    flavor_text,
                    '<i>No flavor text provided.</i>',
                  )}
                />
                {ooc_extra_image && (
                  <Box
                    mt={1}
                    dangerouslySetInnerHTML={{ __html: ooc_extra_image }}
                  />
                )}
              </Box>
            )}
            {flavorTextIndex === 'NSFW' && (
              <Box style={{ zoom: flavorEm.NSFW }}>
                <Box dangerouslySetInnerHTML={chatHtml(flavor_text_nsfw)} />
                {nsfw_ooc_extra_image && (
                  <Box
                    mt={1}
                    dangerouslySetInnerHTML={{
                      __html: nsfw_ooc_extra_image,
                    }}
                  />
                )}
              </Box>
            )}
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};

/** Space between gallery pictures, in pixels. */
const GALLERY_GAP = 8;

/** Some pictures in order: one picture, or two groups side by side or one stacked over the other. */
type Grouping =
  | { picture: number }
  | { join: 'beside' | 'stacked'; first: Grouping; second: Grouping };

/** Every recursive grouping of consecutive pictures, whose visual reading order is checked after placement. */
const groupings = (first: number, last: number): Grouping[] => {
  if (first === last) {
    return [{ picture: first }];
  }
  const found: Grouping[] = [];
  for (let split = first; split < last; split++) {
    for (const before of groupings(first, split)) {
      for (const after of groupings(split + 1, last)) {
        found.push({ join: 'beside', first: before, second: after });
        found.push({ join: 'stacked', first: before, second: after });
      }
    }
  }
  return found;
};

/** A grouping's width for a given height, as slope * height + offset, gaps included. */
type Shape = {
  slope: number;
  offset: number;
};

const shapeOf = (grouping: Grouping, aspects: number[]): Shape => {
  if ('picture' in grouping) {
    return { slope: aspects[grouping.picture], offset: 0 };
  }
  const first = shapeOf(grouping.first, aspects);
  const second = shapeOf(grouping.second, aspects);
  if (grouping.join === 'beside') {
    return {
      slope: first.slope + second.slope,
      offset: first.offset + second.offset + GALLERY_GAP,
    };
  }
  // Stacked groups share one width, and their heights and the gap between them add up
  const slope = 1 / (1 / first.slope + 1 / second.slope);
  return {
    slope,
    offset:
      slope *
      (first.offset / first.slope + second.offset / second.slope - GALLERY_GAP),
  };
};

type Spot = {
  left: number;
  top: number;
  width: number;
  height: number;
};

const placeGrouping = (
  grouping: Grouping,
  aspects: number[],
  spot: Spot,
  spots: Spot[],
) => {
  if ('picture' in grouping) {
    spots[grouping.picture] = spot;
    return;
  }
  const first = shapeOf(grouping.first, aspects);
  const second = shapeOf(grouping.second, aspects);
  if (grouping.join === 'beside') {
    const firstWidth = first.slope * spot.height + first.offset;
    placeGrouping(
      grouping.first,
      aspects,
      { ...spot, width: firstWidth },
      spots,
    );
    placeGrouping(
      grouping.second,
      aspects,
      {
        ...spot,
        left: spot.left + firstWidth + GALLERY_GAP,
        width: second.slope * spot.height + second.offset,
      },
      spots,
    );
    return;
  }
  const firstHeight = (spot.width - first.offset) / first.slope;
  placeGrouping(
    grouping.first,
    aspects,
    { ...spot, height: firstHeight },
    spots,
  );
  placeGrouping(
    grouping.second,
    aspects,
    {
      ...spot,
      top: spot.top + firstHeight + GALLERY_GAP,
      height: (spot.width - second.offset) / second.slope,
    },
    spots,
  );
};

type Collage = {
  spots: Spot[];
  width: number;
  height: number;
};

/** Image origins must read left to right and down, allowing for subpixel placement differences. */
const inReadingOrder = (spots: Spot[]) =>
  spots.every((spot, index) => {
    if (index === 0) {
      return true;
    }
    const previous = spots[index - 1];
    if (Math.abs(spot.top - previous.top) <= 0.01) {
      return spot.left > previous.left;
    }
    return spot.top > previous.top;
  });

/** How far apart two pictures may be, in shape or in height, and still count as alike. */
const ALIKE_RATIO = 1.15;

const alike = (a: number, b: number) =>
  Math.max(a, b) / Math.min(a, b) <= ALIKE_RATIO;

/** Whether every pair of pictures with the same shape came out the same size. */
const evenlySized = (aspects: number[], spots: Spot[]) =>
  aspects.every((aspect, first) =>
    aspects.every(
      (other, second) =>
        second <= first ||
        !alike(aspect, other) ||
        alike(spots[first].height, spots[second].height),
    ),
  );

/** A grouping fitted to the area exactly, every row and stack spanning its whole group. */
const fitGrouping = (
  grouping: Grouping,
  aspects: number[],
  width: number,
  height: number,
): Collage | null => {
  const shape = shapeOf(grouping, aspects);
  const fitHeight = Math.min(height, (width - shape.offset) / shape.slope);
  if (fitHeight <= 0) {
    return null;
  }
  const fitWidth = shape.slope * fitHeight + shape.offset;
  const spots: Spot[] = [];
  placeGrouping(
    grouping,
    aspects,
    { left: 0, top: 0, width: fitWidth, height: fitHeight },
    spots,
  );
  return { spots, width: fitWidth, height: fitHeight };
};

/** Every way to split pictures into rows without changing their order, such as [[0, 1], [2]]. */
const rowSplits = (count: number) => {
  const splits: number[][][] = [];
  for (let breaks = 0; breaks < 1 << Math.max(count - 1, 0); breaks++) {
    const rows: number[][] = [[0]];
    for (let index = 1; index < count; index++) {
      if (breaks & (1 << (index - 1))) {
        rows.push([index]);
      } else {
        rows[rows.length - 1].push(index);
      }
    }
    splits.push(rows);
  }
  return splits;
};

/**
 * Rows that all share one height, each centred, so a short row can sit under a full one at the same
 * size rather than stretching to the full width.
 */
const fitGrid = (
  rows: number[][],
  aspects: number[],
  width: number,
  height: number,
): Collage | null => {
  const rowWidthPerHeight = rows.map((row) =>
    row.reduce((sum, index) => sum + aspects[index], 0),
  );
  const rowHeight = Math.min(
    ...rows.map(
      (row, rowIndex) =>
        (width - GALLERY_GAP * (row.length - 1)) / rowWidthPerHeight[rowIndex],
    ),
    (height - GALLERY_GAP * (rows.length - 1)) / rows.length,
  );
  if (rowHeight <= 0) {
    return null;
  }
  const rowWidths = rows.map(
    (row, rowIndex) =>
      rowWidthPerHeight[rowIndex] * rowHeight + GALLERY_GAP * (row.length - 1),
  );
  const gridWidth = Math.max(...rowWidths);
  const spots: Spot[] = [];
  rows.forEach((row, rowIndex) => {
    let left = (gridWidth - rowWidths[rowIndex]) / 2;
    const top = rowIndex * (rowHeight + GALLERY_GAP);
    for (const index of row) {
      const pictureWidth = aspects[index] * rowHeight;
      spots[index] = { left, top, width: pictureWidth, height: rowHeight };
      left += pictureWidth + GALLERY_GAP;
    }
  });
  return {
    spots,
    width: gridWidth,
    height: rows.length * rowHeight + GALLERY_GAP * (rows.length - 1),
  };
};

/**
 * The arrangement whose smallest picture is biggest, given each picture's width over height.
 *
 * Two families compete: groupings fitted exactly, and grids of equal height rows that may leave a
 * short row centred. Nothing is cropped or letterboxed. Arrangements that show pictures of the same
 * shape at the same size come first, so three portraits under a landscape beat one portrait blown up
 * beside the others. Judging by the smallest picture keeps one wide picture from shrinking the rest,
 * and the total area breaks ties. Grids that still tie keep alike shapes in the same row, then keep
 * rows even, then put fuller rows first, so a landscape sits over three portraits, four squares make a
 * square and a pair sits over one.
 */
const bestCollage = (
  aspects: number[],
  width: number,
  height: number,
): Collage | null => {
  const candidates: Candidate[] = [
    ...groupings(0, aspects.length - 1).map((grouping) => ({
      collage: fitGrouping(grouping, aspects, width, height),
      mixedRows: 0,
      spread: 0,
      fullness: 0,
    })),
    ...rowSplits(aspects.length).map((rows) => ({
      collage: fitGrid(rows, aspects, width, height),
      mixedRows: rows.filter((row) =>
        row.some((index) => !alike(aspects[index], aspects[row[0]])),
      ).length,
      spread:
        Math.max(...rows.map((row) => row.length)) -
        Math.min(...rows.map((row) => row.length)),
      fullness: rows.reduce(
        (sum, row, rowIndex) => sum + row.length * (rows.length - rowIndex),
        0,
      ),
    })),
  ];
  let best: Scored | null = null;
  for (const { collage, mixedRows, spread, fullness } of candidates) {
    if (
      !collage ||
      !inReadingOrder(collage.spots) ||
      collage.spots.some((spot) => spot.width <= 0 || spot.height <= 0)
    ) {
      continue;
    }
    const areas = collage.spots.map((spot) => spot.width * spot.height);
    const scored: Scored = {
      collage,
      even: evenlySized(aspects, collage.spots),
      smallest: Math.min(...areas),
      area: areas.reduce((sum, pictureArea) => sum + pictureArea, 0),
      mixedRows,
      spread,
      fullness,
    };
    if (!best || beats(scored, best)) {
      best = scored;
    }
  }
  return best?.collage ?? null;
};

type Candidate = {
  collage: Collage | null;
  /** Rows holding pictures of different shapes, which grids in a tie should avoid. */
  mixedRows: number;
  /** How many more pictures the longest row holds than the shortest. */
  spread: number;
  /** Higher when longer rows come first. */
  fullness: number;
};

type Scored = {
  collage: Collage;
  even: boolean;
  smallest: number;
  area: number;
  mixedRows: number;
  spread: number;
  fullness: number;
};

/** Sizes this close count as equal, so the tie-breaks decide. */
const SAME_SIZE = 1.001;

const sameSize = (a: number, b: number) =>
  Math.max(a, b) / Math.min(a, b) <= SAME_SIZE;

const beats = (scored: Scored, best: Scored) => {
  if (scored.even !== best.even) {
    return scored.even;
  }
  if (!sameSize(scored.smallest, best.smallest)) {
    return scored.smallest > best.smallest;
  }
  if (!sameSize(scored.area, best.area)) {
    return scored.area > best.area;
  }
  if (scored.mixedRows !== best.mixedRows) {
    return scored.mixedRows < best.mixedRows;
  }
  if (scored.spread !== best.spread) {
    return scored.spread < best.spread;
  }
  return scored.fullness > best.fullness;
};

export const ImageGalleryPage = () => {
  const { data } = useBackend<ExaminePanelData>();
  const { img_gallery, nsfw_img_gallery, is_naked, nsfw_examine_always } = data;

  const [galleryMode, setGalleryMode] = useState<'SFW' | 'NSFW'>('SFW');

  const images =
    galleryMode === 'NSFW' ? nsfw_img_gallery || [] : img_gallery || [];

  const areaRef = useRef<HTMLDivElement>(null);
  const [area, setArea] = useState<[number, number]>([0, 0]);
  // Width over height for each link, learned as each picture loads and taken as square until then
  const [aspects, setAspects] = useState<Record<string, number>>({});
  const hasImages = images.length > 0;
  useEffect(() => {
    const element = areaRef.current;
    if (!element) {
      return;
    }
    const measure = () => setArea([element.clientWidth, element.clientHeight]);
    measure();
    const observer = new ResizeObserver(measure);
    observer.observe(element);
    return () => observer.disconnect();
  }, [hasImages]);
  // A height that has not resolved yet falls back to a landscape area, so pictures still show
  const areaHeight = area[1] > 0 ? area[1] : area[0] * 0.6;
  const collage =
    area[0] > 0
      ? bestCollage(
          images.map((url) => aspects[url] ?? 1),
          area[0],
          areaHeight,
        )
      : null;

  return (
    <Section
      title="Image Gallery"
      fill
      buttons={
        <>
          <Button
            selected={galleryMode === 'SFW'}
            bold={galleryMode === 'SFW'}
            onClick={() => setGalleryMode('SFW')}
            textAlign="center"
            minWidth="60px"
          >
            SFW
          </Button>
          <Button
            selected={galleryMode === 'NSFW'}
            disabled={!nsfw_img_gallery || (!is_naked && !nsfw_examine_always)}
            bold={galleryMode === 'NSFW'}
            onClick={() => setGalleryMode('NSFW')}
            textAlign="center"
            minWidth="60px"
          >
            NSFW
          </Button>
        </>
      }
    >
      {images.length === 0 ? (
        <Box align="center" color="gray">
          No images available.
        </Box>
      ) : (
        <div
          ref={areaRef}
          style={{
            width: '100%',
            height: '100%',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            overflow: 'hidden',
          }}
        >
          {!!collage && (
            <div
              style={{
                position: 'relative',
                width: collage.width,
                height: collage.height,
              }}
            >
              {images.map((url, index) => {
                const spot = collage.spots[index];
                return (
                  <img
                    key={`${index}-${url}`}
                    src={resolveAsset(url)}
                    style={{
                      position: 'absolute',
                      left: spot.left,
                      top: spot.top,
                      width: spot.width,
                      height: spot.height,
                      objectFit: 'cover',
                    }}
                    onLoad={(event) => {
                      const { naturalWidth, naturalHeight } =
                        event.currentTarget;
                      if (!naturalWidth || !naturalHeight) {
                        return;
                      }
                      const aspect = naturalWidth / naturalHeight;
                      setAspects((previous) =>
                        previous[url] === aspect
                          ? previous
                          : { ...previous, [url]: aspect },
                      );
                    }}
                  />
                );
              })}
            </div>
          )}
        </div>
      )}
    </Section>
  );
};
