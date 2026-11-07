type BackdropTable = {
  tile: string;
  tileWidth: number;
  tileHeight: number;
  /** Where the table's far edge sits, as a share of the main area's height from its top, which is where the room's image ends. */
  farEdge: number;
  perspective: number;
  /** How far below the far edge the eye's line of sight meets the table, in pixels. */
  eyeBelowEdge: number;
  angle: number;
};

export type BackdropFigure = {
  id: string;
  /** The hover region in the layer's source pixels, following the room's cover scaling */
  label?: {
    title: string;
    description: string;
    left: number;
    top: number;
    width: number;
    height: number;
    clipPath: string;
  };
  /** The figure's layer, by asset name or link, the size of the room's image and drawn exactly as the room is. */
  layer: string;
  blink?: { half: string; shut: string };
  /**
   * The face it wears while the gallery shows NSFW pictures, a layer of the pixels it redraws over the figure, with
   * its own blink frames and the mouth held level halfway through the blink that swaps the two faces. Shown only on a
   * figure that blinks, as that swap shuts the everyday eyes too.
   */
  nsfw?: { face: string; half: string; shut: string; levelMouth: string };
};

export const faceFrames = (figure: BackdropFigure): [string, string][] => {
  const { blink, nsfw } = figure;
  if (!blink) {
    return [];
  }
  const everyday: [string, string][] = [
    ['blink-half', blink.half],
    ['blink-shut', blink.shut],
  ];
  return nsfw
    ? [
        ...everyday,
        ['nsfw-face', nsfw.face],
        ['nsfw-half', nsfw.half],
        ['nsfw-shut', nsfw.shut],
        ['level-mouth', nsfw.levelMouth],
      ]
    : everyday;
};

export type Backdrop = { id: string } & (
  | { kind: 'none' }
  | { kind: 'picture' }
  | {
      kind: 'scene';
      room: string;
      roomWidth: number;
      roomHeight: number;
      table?: BackdropTable;
      figures?: BackdropFigure[];
    }
);

/** Every backdrop, with ids matching gallery_backdrop_options() on the server. */
export const BACKDROPS: Backdrop[] = [
  { id: 'none', kind: 'none' },
  { id: 'picture', kind: 'picture' },
  {
    id: 'tavern',
    kind: 'scene',
    room: 'gallery_tavern_room.jpg',
    roomWidth: 960,
    roomHeight: 303,
    // The room's image is the 303 rows above the table line of a 450 row scene
    table: {
      tile: 'gallery_tavern_table.png',
      tileWidth: 192,
      tileHeight: 60,
      farEdge: 303 / 450,
      perspective: 500,
      eyeBelowEdge: 6,
      angle: 78,
    },
    // The cat and the dog sit in the same place on the table's far edge, so the server sends one at most and their layers
    // are cut at the same row as the room's
    figures: [
      {
        id: 'cat',
        label: {
          title: 'Mammon, Lord of All He Sits Upon',
          description:
            'Mammon to those who feed him. Pazuzu in texts best left unread.',
          left: 684,
          top: 108,
          width: 190,
          height: 195,
          clipPath:
            'polygon(0% 12%, 5% 11%, 31% 33%, 55% 36%, 68% 32%, 94% 0%, 100% 0%, 96% 44%, 89% 63%, 93% 84%, 98% 100%, 10% 100%, 18% 74%, 21% 62%, 9% 39%)',
        },
        layer: 'gallery_tavern_mammon_the_cat.png',
        blink: {
          half: 'gallery_tavern_mammon_the_cat_blink_half.png',
          shut: 'gallery_tavern_mammon_the_cat_blink_shut.png',
        },
        nsfw: {
          face: 'gallery_tavern_mammon_the_cat_judging_face.png',
          half: 'gallery_tavern_mammon_the_cat_judging_blink_half.png',
          shut: 'gallery_tavern_mammon_the_cat_judging_blink_shut.png',
          levelMouth: 'gallery_tavern_mammon_the_cat_mouth_level.png',
        },
      },
      {
        id: 'dog',
        label: {
          title: 'Sir Guinefort, A Very Good Dog',
          description: 'On this, the entire tavern is agreed.',
          left: 669,
          top: 105,
          width: 237,
          height: 198,
          clipPath:
            'polygon(38% 3%, 59% 3%, 77% 13%, 96% 33%, 100% 38%, 99% 48%, 94% 58%, 94% 64%, 87% 73%, 88% 83%, 93% 94%, 93% 100%, 19% 100%, 19% 94%, 15% 78%, 8% 73%, 4% 68%, 0% 53%, 0% 48%, 12% 18%, 20% 8%)',
        },
        layer: 'gallery_tavern_guinefort_the_dog.png',
        blink: {
          half: 'gallery_tavern_guinefort_the_dog_blink_half.png',
          shut: 'gallery_tavern_guinefort_the_dog_blink_shut.png',
        },
        nsfw: {
          face: 'gallery_tavern_guinefort_the_dog_annoyed_face.png',
          half: 'gallery_tavern_guinefort_the_dog_annoyed_blink_half.png',
          shut: 'gallery_tavern_guinefort_the_dog_annoyed_blink_shut.png',
          levelMouth: 'gallery_tavern_guinefort_the_dog_mouth_level.png',
        },
      },
    ],
  },
];

export const DEFAULT_BACKDROP = 'picture';

export const findBackdrop = (choice: unknown): Backdrop =>
  BACKDROPS.find((backdrop) => backdrop.id === choice) ??
  BACKDROPS.find((backdrop) => backdrop.id === DEFAULT_BACKDROP)!;

export const shownBackdrop = (viewerOn: unknown, choice: unknown): Backdrop =>
  findBackdrop(viewerOn ? choice : 'none');

export const shownFigures = (
  backdrop: Backdrop,
  sentIds: unknown,
): BackdropFigure[] =>
  backdrop.kind === 'scene' && Array.isArray(sentIds)
    ? (backdrop.figures ?? []).filter((figure) => sentIds.includes(figure.id))
    : [];
