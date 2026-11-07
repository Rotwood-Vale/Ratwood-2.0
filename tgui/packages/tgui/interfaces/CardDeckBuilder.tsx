import {
  type CSSProperties,
  type ReactNode,
  useEffect,
  useMemo,
  useState,
} from 'react';
import {
  Button,
  Dropdown,
  Icon,
  Input,
  ProgressBar,
  Section,
} from 'tgui-core/components';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type CardRow = 'infantry' | 'archers' | 'siege' | 'weather' | 'special';
type CardRarity = 'base' | 'rare' | 'unique';

type Card = {
  id: string;
  name: string;
  desc: string;
  row: CardRow;
  power: number;
  rarity: CardRarity;
  faction: string;
  factionName?: string;
  factionAllowed?: boolean;
  effect: string;
  combo: string;
  art?: string;
  artAtlas?: CardAtlasPosition;
  ownedCount?: number;
  deckCount?: number;
  deckLimit?: number;
  poolLimit?: number;
  limited?: boolean;
  known: boolean;
  selected: boolean;
};

type CardAtlasPosition = {
  column: number;
  row: number;
};

type CcgFaction = {
  id: string;
  name: string;
  desc: string;
  effect: string;
  defaultLeader: string;
};

type CcgLeader = {
  id: string;
  name: string;
  desc: string;
  faction: string;
  effect: string;
  targetRow?: CardRow;
};

type Data = {
  mode?: 'pool' | 'build';
  displayMode?: 'setup' | 'deck' | 'pool';
  cards?: Card[];
  selected?: string[];
  selectedCount: number;
  deckSize: number;
  knownRareCount: number;
  faction?: string;
  leader?: string;
  factions?: CcgFaction[];
  leaders?: CcgLeader[];
  decks?: SavedDeck[];
  activeDeckIndex?: number;
  maxDecks?: number;
  readOnly?: boolean;
};

type SavedDeck = {
  index: number;
  name: string;
  count: number;
  faction: string;
  leader: string;
};

const rowLabels: Record<CardRow, string> = {
  infantry: 'Infantry',
  archers: 'Archers',
  siege: 'Siege',
  weather: 'Weather',
  special: 'Special',
};

const rarityColor: Record<CardRarity, string> = {
  base: '#f8fafc',
  rare: '#60a5fa',
  unique: '#fbbf24',
};

const cardAtlasAsset = 'ccg_cards/gwynt_cards_atlas.jpg';
const cardAtlasColumns = 16;
const cardAtlasRows = 10;

const atlasPercent = (index: number, size: number) =>
  `${(index / (size - 1)) * 100}%`;

const cardAtlasStyle = (
  atlas: CardAtlasPosition | undefined,
  filter?: string,
): CSSProperties | undefined => {
  if (!atlas) {
    return undefined;
  }
  return {
    position: 'absolute',
    inset: 0,
    backgroundImage: `url(${resolveAsset(cardAtlasAsset)})`,
    backgroundPosition: `${atlasPercent(atlas.column, cardAtlasColumns)} ${atlasPercent(atlas.row, cardAtlasRows)}`,
    backgroundRepeat: 'no-repeat',
    backgroundSize: `${cardAtlasColumns * 100}% ${cardAtlasRows * 100}%`,
    filter,
    zIndex: 0,
  };
};

const panelStyle = {
  border: '1px solid rgba(148,163,184,0.22)',
  borderRadius: '5px',
  background: 'linear-gradient(180deg, rgba(15,18,27,0.9), rgba(5,7,12,0.72))',
  boxShadow: 'inset 0 0 18px rgba(0,0,0,0.36)',
};

const Panel = ({
  children,
  style,
}: {
  children: ReactNode;
  style?: CSSProperties;
}) => <div style={{ ...panelStyle, padding: '8px', ...style }}>{children}</div>;

const PanelLabel = ({ children }: { children: ReactNode }) => (
  <div
    style={{
      color: '#94a3b8',
      fontSize: '10px',
      fontWeight: 900,
      letterSpacing: '0.04em',
      marginBottom: '6px',
      textTransform: 'uppercase',
    }}
  >
    {children}
  </div>
);

const StatTile = ({ label, value }: { label: string; value: ReactNode }) => (
  <div
    style={{
      padding: '7px 8px',
      border: '1px solid rgba(148,163,184,0.22)',
      background: 'rgba(2,6,12,0.55)',
    }}
  >
    <PanelLabel>{label}</PanelLabel>
    <div style={{ color: '#f8fafc', fontSize: '18px', fontWeight: 900 }}>
      {value}
    </div>
  </div>
);

const cardType = (card: Card) => rowLabels[card.row];

const rarityOrder: Record<CardRarity, number> = {
  base: 0,
  rare: 1,
  unique: 2,
};

const rowOrder: Record<CardRow, number> = {
  infantry: 0,
  archers: 1,
  siege: 2,
  weather: 3,
  special: 4,
};

const effectBadges: Record<string, string> = {
  morale: 'MOR',
  scorch: 'SC',
  scorch_infantry: 'SC',
  scorch_global: 'SC',
  spy: 'SPY',
  medic: 'MED',
  bond: 'BND',
  agile: 'AGI',
  muster: 'MUS',
  horn: 'HORN',
  decoy: 'DEC',
  berserk: 'BER',
  mardroeme: 'MAR',
  avenger: 'AVG',
};

const rowIconAssets: Record<CardRow, string> = {
  infantry: 'ccg_cards/gwent_icons/melee.webp',
  archers: 'ccg_cards/gwent_icons/ranged.webp',
  siege: 'ccg_cards/gwent_icons/siege.webp',
  weather: 'ccg_cards/gwent_icons/sun.webp',
  special: 'ccg_cards/gwent_icons/horn_special.webp',
};

const effectIconAssets: Record<string, string> = {
  morale: 'ccg_cards/gwent_icons/add_power.webp',
  scorch: 'ccg_cards/gwent_icons/kill_any_powerful_include_itself.webp',
  scorch_infantry: 'ccg_cards/gwent_icons/kill_any_if_10.webp',
  scorch_global: 'ccg_cards/gwent_icons/scorch_special.webp',
  spy: 'ccg_cards/gwent_icons/spy.webp',
  medic: 'ccg_cards/gwent_icons/medic.webp',
  bond: 'ccg_cards/gwent_icons/double.webp',
  agile: 'ccg_cards/gwent_icons/any_type_card.webp',
  muster: 'ccg_cards/gwent_icons/double.webp',
  horn: 'ccg_cards/gwent_icons/horn.webp',
  decoy: 'ccg_cards/gwent_icons/maneken.webp',
  berserk: 'ccg_cards/gwent_icons/berserk_to_bear.webp',
  mardroeme: 'ccg_cards/gwent_icons/mardrem.webp',
  avenger: 'ccg_cards/gwent_icons/berserk_mushroom.webp',
  clear_weather: 'ccg_cards/gwent_icons/sun.webp',
  frost: 'ccg_cards/gwent_icons/winter.webp',
  fog: 'ccg_cards/gwent_icons/fog.webp',
  rain: 'ccg_cards/gwent_icons/rain.webp',
};

const effectDescriptions: Record<string, string> = {
  morale: 'Morale Boost: +1 strength to all other units in this row.',
  scorch: "Scorch: destroys the opponent's strongest card.",
  scorch_infantry:
    "Scorch: destroys the enemy's strongest infantry if their infantry totals 10+ strength.",
  scorch_global: 'Scorch: destroys the strongest card or cards on the board.',
  spy: "Spy: placed on the opponent's side of the board and draws you two cards.",
  medic: 'Medic: returns your strongest discarded card to the board.',
  bond: 'Tight Bond: identical cards with this ability strengthen each other.',
  agile: 'Agile: test marker for a flexible card.',
  muster: 'Muster: plays all matching cards from your hand and deck.',
  horn: "Commander's Horn: doubles the strength of the chosen row for the round.",
  decoy: 'Decoy: returns your strongest card on the board to your hand.',
  berserk: 'Berserker: turns into a bear under Mardroeme.',
  mardroeme: 'Mardroeme: turns berserkers in the row into bears.',
  avenger:
    'Avenger: when destroyed, summons a strong card in its place.',
  clear_weather: 'Clear Weather: removes all weather effects.',
  frost: 'Frost: reduces all infantry to 1 strength.',
  fog: 'Fog: reduces all archers to 1 strength.',
  rain: 'Rain: reduces all siege to 1 strength.',
};

const CardIconBadge = ({
  asset,
  label,
  compact,
  title,
}: {
  asset?: string;
  label?: string;
  compact: boolean;
  title: string;
}) => {
  const size = compact ? 17 : 23;
  return (
    <div
      title={title}
      style={{
        width: `${size}px`,
        height: `${size}px`,
        borderRadius: '50%',
        backgroundColor: 'rgba(5,7,11,0.82)',
        border: '1px solid rgba(248,250,252,0.72)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        overflow: 'hidden',
        boxShadow: '0 1px 4px rgba(0,0,0,0.65)',
      }}
    >
      {asset ? (
        <img
          src={resolveAsset(asset)}
          style={{
            width: compact ? '13px' : '18px',
            height: compact ? '13px' : '18px',
            objectFit: 'contain',
          }}
        />
      ) : (
        <span
          style={{
            color: '#f8fafc',
            fontSize: compact ? '5px' : '7px',
            fontWeight: 900,
            lineHeight: 1,
          }}
        >
          {label}
        </span>
      )}
    </div>
  );
};

const cardTooltip = (card: Card) => {
  if (!card.known) {
    return ['Unknown'];
  }
  const lines = [
    card.name,
    `Type: ${cardType(card)}`,
    `Group: ${card.factionName || card.faction}`,
    `Power: ${card.power}`,
  ];
  if (effectDescriptions[card.effect]) {
    lines.push(`Effect: ${effectDescriptions[card.effect]}`);
  } else if (card.desc) {
    lines.push(card.desc);
  }
  if (card.known) {
    lines.push(`Collection: ${card.ownedCount || 0}/${card.poolLimit || 0}`);
    lines.push(`This deck: ${card.deckCount || 0}/${card.deckLimit || 0}`);
  }
  return lines;
};

const cardIconDisplay = (card: Card) => {
  const effectIcon = card.known ? effectIconAssets[card.effect] : undefined;
  const effectBadge = card.known ? effectBadges[card.effect] : undefined;
  const singleTypeIcon = card.row === 'weather' || card.row === 'special';
  return {
    effectBadge,
    effectIcon,
    singleTypeIcon,
    typeIcon: singleTypeIcon
      ? effectIcon || rowIconAssets[card.row]
      : rowIconAssets[card.row],
    typeTitle:
      singleTypeIcon && card.known
        ? effectDescriptions[card.effect] || card.effect || cardType(card)
        : cardType(card),
  };
};

const CardTooltip = ({
  card,
  compact,
  tooltip,
  tooltipGap,
  tooltipPlacement,
  tooltipWidth,
}: {
  card: Card;
  compact: boolean;
  tooltip: string[];
  tooltipGap: number;
  tooltipPlacement: {
    side: 'left' | 'center' | 'right';
    vertical: 'above' | 'below';
  };
  tooltipWidth: number;
}) => (
  <div
    style={{
      position: 'absolute',
      left:
        tooltipPlacement.side === 'right'
          ? undefined
          : tooltipPlacement.side === 'left'
            ? 0
            : '50%',
      right: tooltipPlacement.side === 'right' ? 0 : undefined,
      top:
        tooltipPlacement.vertical === 'below'
          ? `calc(100% + ${tooltipGap}px)`
          : undefined,
      bottom:
        tooltipPlacement.vertical === 'above'
          ? `calc(100% + ${tooltipGap}px)`
          : undefined,
      width: `${tooltipWidth}px`,
      maxWidth: '70vw',
      padding: compact ? '12px' : '16px',
      border: '2px solid rgba(248,250,252,0.85)',
      borderRadius: '6px',
      backgroundColor: 'rgba(5,7,11,0.96)',
      color: '#f8fafc',
      fontSize: compact ? '14px' : '18px',
      lineHeight: 1.25,
      zIndex: 1000,
      boxShadow: '0 8px 24px rgba(0,0,0,0.85)',
      pointerEvents: 'none',
      transform:
        tooltipPlacement.side === 'center' ? 'translateX(-50%)' : undefined,
      whiteSpace: 'normal',
      overflowWrap: 'break-word',
    }}
  >
    <div
      style={{
        color: rarityColor[card.rarity],
        fontWeight: 900,
        marginBottom: compact ? '8px' : '10px',
      }}
    >
      {tooltip[0]}
    </div>
    {tooltip.slice(1).map((line) => (
      <div key={line}>{line}</div>
    ))}
  </div>
);

const CardFace = ({
  card,
  disabled = false,
  unavailable = false,
  compact = false,
  count = 0,
  onClick,
  onRightClick,
}: {
  card: Card;
  disabled?: boolean;
  unavailable?: boolean;
  compact?: boolean;
  count?: number;
  onClick?: () => void;
  onRightClick?: () => void;
}) => {
  const [hovered, setHovered] = useState(false);
  const [tooltipPlacement, setTooltipPlacement] = useState<{
    side: 'left' | 'center' | 'right';
    vertical: 'above' | 'below';
  }>({ side: 'center', vertical: 'below' });
  const tooltip = cardTooltip(card);
  const tooltipWidth = compact ? 136 : 188;
  const tooltipGap = compact ? 8 : 10;
  const iconDisplay = cardIconDisplay(card);
  const dimmed = disabled && !unavailable;
  const updateTooltipPlacement = (cardElement: HTMLElement) => {
    const rect = cardElement.getBoundingClientRect();
    const centerX = rect.left + rect.width / 2;
    const tooltipHeight = compact
      ? Math.min(220, 48 + tooltip.length * 18)
      : Math.min(280, 58 + tooltip.length * 24);
    let side: 'left' | 'center' | 'right' = 'center';
    if (centerX - tooltipWidth / 2 < 12) {
      side = 'left';
    } else if (centerX + tooltipWidth / 2 > window.innerWidth - 12) {
      side = 'right';
    }
    setTooltipPlacement({
      side,
      vertical:
        rect.bottom + tooltipHeight + tooltipGap <= window.innerHeight
          ? 'below'
          : 'above',
    });
  };
  return (
    <div
      style={{
        position: 'relative',
        aspectRatio: '1 / 1.6',
        width: compact ? '88px' : '118px',
        padding: compact ? '4px' : '6px',
        border: `2px solid ${rarityColor[card.rarity]}`,
        borderRadius: '4px',
        background:
          'linear-gradient(180deg, rgba(35,39,48,0.98), rgba(14,16,22,0.98))',
        boxShadow: `0 0 0 1px rgba(0,0,0,0.7), 0 0 10px ${rarityColor[card.rarity]}33`,
        cursor: onClick && !disabled ? 'pointer' : 'default',
        transform: hovered ? 'scale(1.15)' : 'scale(1)',
        transformOrigin: 'center center',
        transition: 'transform 140ms ease, z-index 140ms ease',
        zIndex: hovered ? 50 : 1,
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'space-between',
        overflow: 'visible',
      }}
      onClick={!disabled ? onClick : undefined}
      onContextMenu={(event) => {
        if (!onRightClick) {
          return;
        }
        event.preventDefault();
        onRightClick();
      }}
      onMouseEnter={(event) => {
        updateTooltipPlacement(event.currentTarget);
        setHovered(true);
      }}
      onMouseMove={(event) => updateTooltipPlacement(event.currentTarget)}
      onMouseLeave={() => setHovered(false)}
    >
      <div
        style={{
          position: 'absolute',
          inset: 0,
          opacity: dimmed ? 0.62 : 1,
          pointerEvents: 'none',
          zIndex: 0,
        }}
      >
        {!!card.artAtlas && (
          <div
            style={cardAtlasStyle(
              card.artAtlas,
              unavailable
                ? 'grayscale(1) brightness(0.16) contrast(0.85)'
                : undefined,
            )}
          />
        )}
        <div
          style={{
            position: 'absolute',
            inset: 0,
            background: unavailable
              ? 'linear-gradient(180deg, rgba(0,0,0,0.84), rgba(0,0,0,0.78) 32%, rgba(0,0,0,0.94))'
              : 'linear-gradient(180deg, rgba(0,0,0,0.34), rgba(0,0,0,0.04) 32%, rgba(0,0,0,0.62))',
            zIndex: 1,
          }}
        />
      </div>
      <div
        style={{
          position: 'relative',
          zIndex: 2,
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          width: '100%',
          opacity: dimmed ? 0.62 : 1,
        }}
      >
        <CardIconBadge
          asset={iconDisplay.typeIcon}
          compact={compact}
          title={iconDisplay.typeTitle}
        />
        {!iconDisplay.singleTypeIcon &&
          (!!iconDisplay.effectIcon || !!iconDisplay.effectBadge) && (
            <CardIconBadge
              asset={iconDisplay.effectIcon}
              label={iconDisplay.effectBadge}
              compact={compact}
              title={effectDescriptions[card.effect] || card.effect}
            />
          )}
      </div>
      {!!count && (
        <div
          style={{
            position: 'absolute',
            left: '5px',
            top: compact ? '24px' : '34px',
            minWidth: compact ? '18px' : '20px',
            height: compact ? '16px' : '20px',
            borderRadius: '10px',
            backgroundColor: '#05070b',
            border: `1px solid ${rarityColor[card.rarity]}`,
            color: '#f8fafc',
            fontSize: compact ? '9px' : '11px',
            fontWeight: 700,
            textAlign: 'center',
            lineHeight: compact ? '14px' : '18px',
            zIndex: 2,
            opacity: dimmed ? 0.62 : 1,
          }}
        >
          x{count}
        </div>
      )}
      {hovered && (
        <CardTooltip
          card={card}
          compact={compact}
          tooltip={tooltip}
          tooltipGap={tooltipGap}
          tooltipPlacement={tooltipPlacement}
          tooltipWidth={tooltipWidth}
        />
      )}

      <div
        style={{
          position: 'relative',
          zIndex: 1,
          display: 'grid',
          gridTemplateColumns: compact ? '22px 1fr' : '30px 1fr',
          alignItems: 'center',
          width: '100%',
          minHeight: compact ? '22px' : '28px',
          opacity: dimmed ? 0.62 : 1,
        }}
      >
        <div
          style={{
            width: compact ? '22px' : '30px',
            height: compact ? '22px' : '30px',
            borderRadius: '50%',
            backgroundColor: '#05070b',
            border: `2px solid ${rarityColor[card.rarity]}`,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: unavailable ? '#64748b' : '#f8fafc',
            fontSize: compact ? '10px' : '15px',
            fontWeight: 700,
            zIndex: 1,
          }}
        >
          {card.power}
        </div>
        <div
          style={{
            marginLeft: compact ? '-4px' : '-5px',
            padding: compact ? '2px 4px 2px 7px' : '3px 5px 3px 9px',
            border: `1px solid ${rarityColor[card.rarity]}`,
            backgroundColor: unavailable
              ? 'rgba(5,7,11,0.98)'
              : 'rgba(5,7,11,0.92)',
            color: unavailable ? '#64748b' : '#f8fafc',
            fontWeight: 700,
            lineHeight: 1.1,
            overflow: 'hidden',
          }}
        >
          <div
            style={{
              fontSize: compact ? '7px' : '10px',
              whiteSpace: 'nowrap',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
            }}
          >
            {card.known ? card.name : 'Unknown'}
          </div>
          <div
            style={{
              color: rarityColor[card.rarity],
              fontSize: compact ? '5px' : '7px',
              fontWeight: 900,
              lineHeight: 1,
              textTransform: 'uppercase',
              whiteSpace: 'nowrap',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
            }}
          >
            {cardType(card)}
          </div>
        </div>
      </div>
    </div>
  );
};

export const CardDeckBuilder = () => {
  const { act, data } = useBackend<Data>();
  const [query, setQuery] = useState('');
  const [row, setRow] = useState<CardRow | 'all'>('all');
  const [factionFilter, setFactionFilter] = useState('all');
  const [filtersOpen, setFiltersOpen] = useState(false);
  const activeDeck = (data.decks || []).find(
    (deck) => deck.index === data.activeDeckIndex,
  );
  const [deckName, setDeckName] = useState(activeDeck?.name || '');

  useEffect(() => {
    setDeckName(activeDeck?.name || '');
  }, [activeDeck?.name, data.activeDeckIndex]);

  const cards = data.cards || [];
  const selected = data.selected || [];
  const displayMode = data.displayMode || 'setup';
  const collectionMode = displayMode === 'pool';
  const selectedCounts = useMemo(() => {
    const counts: Record<string, number> = {};
    for (const id of selected) {
      counts[id] = (counts[id] || 0) + 1;
    }
    return counts;
  }, [selected]);

  const factionOrder = useMemo(() => {
    const order: Record<string, number> = { neutral: 0 };
    (data.factions || []).forEach((faction, index) => {
      order[faction.id] = index + 1;
    });
    return order;
  }, [data.factions]);

  const filteredCards = cards
    .filter((card) => {
      if (!card.known) {
        return false;
      }
      if (row !== 'all' && card.row !== row) {
        return false;
      }
      let factionMatches = true;
      if (factionFilter === 'neutral') {
        factionMatches = card.faction === 'neutral';
      } else if (factionFilter !== 'all') {
        factionMatches = card.faction === factionFilter;
      }
      if (!factionMatches) {
        return false;
      }
      const terms = query.toLowerCase().trim().split(/\s+/).filter(Boolean);
      const haystack = (
        card.known
          ? [
              card.name,
              card.desc,
              card.effect,
              card.combo,
              card.faction,
              card.factionName || '',
              rowLabels[card.row],
            ]
          : ['Unknown']
      )
        .join(' ')
        .toLowerCase();
      return !terms.length || terms.every((term) => haystack.includes(term));
    })
    .sort((a, b) => {
      if (row === 'all') {
        const knownDiff = Number(b.known) - Number(a.known);
        if (knownDiff) {
          return knownDiff;
        }
      }
      const factionDiff =
        (factionOrder[a.faction] ?? Number.MAX_SAFE_INTEGER) -
        (factionOrder[b.faction] ?? Number.MAX_SAFE_INTEGER);
      if (factionDiff) {
        return factionDiff;
      }
      const rarityDiff = rarityOrder[a.rarity] - rarityOrder[b.rarity];
      if (rarityDiff) {
        return rarityDiff;
      }
      const rowDiff = rowOrder[a.row] - rowOrder[b.row];
      if (rowDiff) {
        return rowDiff;
      }
      return a.name.localeCompare(b.name);
    });
  const selectedCards = selected
    .map((id) => cards.find((card) => card.id === id))
    .filter(Boolean) as Card[];
  selectedCards.sort((a, b) => {
    const factionDiff =
      (factionOrder[a.faction] ?? Number.MAX_SAFE_INTEGER) -
      (factionOrder[b.faction] ?? Number.MAX_SAFE_INTEGER);
    if (factionDiff) {
      return factionDiff;
    }
    const rarityDiff = rarityOrder[a.rarity] - rarityOrder[b.rarity];
    if (rarityDiff) {
      return rarityDiff;
    }
    const rowDiff = rowOrder[a.row] - rowOrder[b.row];
    if (rowDiff) {
      return rowDiff;
    }
    return a.name.localeCompare(b.name);
  });

  const deckRatio = data.deckSize > 0 ? data.selectedCount / data.deckSize : 0;
  const isPhysicalDeck = data.mode === 'build';
  const readOnly = !!data.readOnly;
  const showPool = displayMode !== 'deck';
  const showDeck = displayMode !== 'pool';
  const currentFaction = data.factions?.find(
    (faction) => faction.id === data.faction,
  );
  const currentLeader = data.leaders?.find(
    (leader) => leader.id === data.leader,
  );
  const factionLeaders = (data.leaders || []).filter(
    (leader) => leader.faction === data.faction,
  );
  const maxDecks = data.maxDecks || 10;
  const deckSlots = Array.from({ length: maxDecks }, (_, index) => {
    const slot = index + 1;
    const deck = (data.decks || []).find((entry) => entry.index === slot);
    return {
      value: String(slot),
      displayText: deck
        ? `${slot}. ${deck.name} (${deck.count})`
        : `${slot}. Empty slot`,
    };
  });
  const activeDeckLabel =
    deckSlots.find((slot) => slot.value === String(data.activeDeckIndex))
      ?.displayText || 'Select deck';
  return (
    <Window
      title={
        readOnly
          ? 'Arlette Deck Preview'
          : isPhysicalDeck
            ? 'Arlette Deck Builder'
            : 'Arlette Decks'
      }
      width={1100}
      height={760}
    >
      <Window.Content>
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            gap: '10px',
            height: '100%',
          }}
        >
          {!readOnly && (
            <Panel>
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: '220px minmax(180px, 1fr) auto',
                gap: '10px',
                alignItems: 'center',
                marginBottom: '8px',
              }}
            >
              <Dropdown
                selected={String(data.activeDeckIndex)}
                displayText={activeDeckLabel}
                options={deckSlots}
                onSelected={(index) => {
                  const deckIndex = Number(index);
                  if (
                    (data.decks || []).some((deck) => deck.index === deckIndex)
                  ) {
                    act('select_deck', { index: deckIndex });
                  } else {
                    act('create_deck');
                  }
                }}
              />
              <Input value={deckName} onChange={setDeckName} width="160px" />
              <Button
                disabled={(data.decks || []).length >= maxDecks}
                onClick={() => act('create_deck')}
              >
                <Icon name="plus" /> New
              </Button>
            </div>
            <div
              style={{
                display: 'flex',
                gap: '8px',
                flexWrap: 'wrap',
                marginBottom: '8px',
              }}
            >
              <Button onClick={() => act('rename_deck', { name: deckName })}>
                <Icon name="tag" /> Save Name
              </Button>
              {isPhysicalDeck && (
                <Button color="good" onClick={() => act('save_physical_deck')}>
                  <Icon name="floppy-disk" /> Save This Deck
                </Button>
              )}
              <Button onClick={() => act('export_deck')}>
                <Icon name="upload" /> Export
              </Button>
              <Button onClick={() => act('import_deck')}>
                <Icon name="download" /> Import
              </Button>
            </div>
            <div style={{ display: 'flex', gap: '8px' }}>
              {(
                [
                  ['setup', 'Setup'],
                  ['deck', 'Deck Only'],
                  ['pool', 'Collection'],
                ] as const
              ).map(([key, label]) => (
                <Button
                  key={key}
                  selected={displayMode === key}
                  onClick={() => act('set_view', { view: key })}
                >
                  {label}
                </Button>
              ))}
            </div>
            </Panel>
          )}

          <div
            style={{
              display: 'grid',
              gridTemplateColumns: showPool && showDeck ? '2fr 1fr' : '1fr',
              gap: '12px',
              minHeight: 0,
              flex: 1,
            }}
          >
            {showPool && (
              <Section title={collectionMode ? 'Collection' : 'Pool'} fill scrollable>
                <Panel style={{ marginBottom: '10px' }}>
                  <div
                    style={{
                      display: 'grid',
                      gridTemplateColumns: 'minmax(260px, 1fr) auto',
                      gap: '10px',
                      marginBottom: '8px',
                    }}
                  >
                    <Input
                      value={query}
                      onChange={setQuery}
                      placeholder="Search cards"
                    />
                    <Button
                      selected={filtersOpen}
                      onClick={() => setFiltersOpen(!filtersOpen)}
                    >
                      <Icon name="filter" /> Filters
                    </Button>
                  </div>
                  {filtersOpen && (
                    <>
                      <PanelLabel>Type</PanelLabel>
                      <div
                        style={{
                          display: 'flex',
                          gap: '8px',
                          flexWrap: 'wrap',
                          marginBottom: '8px',
                        }}
                      >
                        {(
                          [
                            'all',
                            'infantry',
                            'archers',
                            'siege',
                            'weather',
                            'special',
                          ] as const
                        ).map((key) => (
                          <Button
                            key={key}
                            selected={row === key}
                            onClick={() => setRow(key)}
                          >
                            {key === 'all' ? 'All' : rowLabels[key]}
                          </Button>
                        ))}
                      </div>
                      <PanelLabel>Faction</PanelLabel>
                      <div
                        style={{
                          display: 'flex',
                          gap: '8px',
                          flexWrap: 'wrap',
                          marginBottom: '8px',
                        }}
                      >
                        {(
                          [
                            ['all', 'Any'],
                            ['neutral', 'Common'],
                          ] as const
                        ).map(([key, label]) => (
                          <Button
                            key={key}
                            selected={factionFilter === key}
                            onClick={() => setFactionFilter(key)}
                          >
                            {label}
                          </Button>
                        ))}
                        {(data.factions || []).map((faction) => (
                          <Button
                            key={faction.id}
                            selected={factionFilter === faction.id}
                            onClick={() => setFactionFilter(faction.id)}
                          >
                            {faction.name}
                          </Button>
                        ))}
                      </div>
                    </>
                  )}
                  <div style={{ color: '#cbd5e1', fontSize: '12px' }}>
                    Cards in collection: {data.knownRareCount}
                  </div>
                </Panel>
                <div style={{ display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
                  {filteredCards.map((card) => {
                    const selectedCount = selectedCounts[card.id] || 0;
                    const ownedCount = card.ownedCount || 0;
                    const deckLimit = card.deckLimit || 0;
                    const factionLocked = !collectionMode && !card.factionAllowed;
                    const unavailable = !card.known || factionLocked;
                    return (
                      <CardFace
                        key={card.id}
                        card={card}
                        count={
                          ownedCount
                        }
                        unavailable={unavailable}
                        disabled={
                          !collectionMode &&
                            (unavailable ||
                              data.selectedCount >= data.deckSize ||
                              selectedCount >= deckLimit)
                        }
                        onClick={
                          collectionMode
                            ? undefined
                            : () => act('add', { card: card.id })
                        }
                      />
                    );
                  })}
                </div>
              </Section>
            )}

            {showDeck && (
              <Section title="Deck" fill scrollable>
                <Panel style={{ marginBottom: '10px' }}>
                  <PanelLabel>Faction</PanelLabel>
                  <div
                    style={{
                      display: 'flex',
                      gap: '6px',
                      flexWrap: 'wrap',
                      marginBottom: '8px',
                    }}
                  >
                    {(data.factions || []).map((faction) => (
                      <Button
                        key={faction.id}
                        selected={faction.id === data.faction}
                        disabled={readOnly}
                        onClick={
                          readOnly
                            ? undefined
                            : () => act('set_faction', { faction: faction.id })
                        }
                      >
                        {faction.name}
                      </Button>
                    ))}
                  </div>
                  {currentFaction && (
                    <div
                      style={{
                        color: '#94a3b8',
                        fontSize: '11px',
                        lineHeight: 1.35,
                        marginBottom: '8px',
                      }}
                    >
                      {currentFaction.desc}
                    </div>
                  )}
                  <PanelLabel>Leader</PanelLabel>
                  <div
                    style={{
                      display: 'flex',
                      gap: '6px',
                      flexWrap: 'wrap',
                      marginBottom: '8px',
                    }}
                  >
                    {factionLeaders.map((leader) => (
                      <Button
                        key={leader.id}
                        selected={leader.id === data.leader}
                        disabled={readOnly}
                        onClick={
                          readOnly
                            ? undefined
                            : () => act('set_leader', { leader: leader.id })
                        }
                      >
                        {leader.name}
                      </Button>
                    ))}
                  </div>
                  {currentLeader && (
                    <div
                      style={{
                        color: '#cbd5e1',
                        fontSize: '11px',
                        lineHeight: 1.35,
                      }}
                    >
                      {currentLeader.desc}
                    </div>
                  )}
                </Panel>
                <Panel style={{ marginBottom: '10px' }}>
                  <PanelLabel>Deck Fill</PanelLabel>
                  <div style={{ marginBottom: '8px' }}>
                    <StatTile
                      label="Cards"
                      value={`${data.selectedCount} / ${data.deckSize}`}
                    />
                  </div>
                  <ProgressBar value={deckRatio} ranges={{ good: [0, 1] }}>
                    {data.selectedCount} / {data.deckSize}
                  </ProgressBar>
                </Panel>
                <div
                  style={{ display: 'flex', gap: '6px', marginBottom: '10px' }}
                >
                  <Button
                    color="bad"
                    disabled={readOnly}
                    onClick={() => act('clear')}
                  >
                    Clear
                  </Button>
                </div>
                {!selectedCards.length && (
                  <div style={{ color: '#94a3b8' }}>No cards selected.</div>
                )}
                <div
                  style={
                    showPool
                      ? {
                          display: 'grid',
                          gridTemplateColumns: 'repeat(3, 88px)',
                          gap: '10px',
                        }
                      : {
                          display: 'flex',
                          gap: '10px',
                          flexWrap: 'wrap',
                        }
                  }
                >
                  {selectedCards.map((card, index) => (
                    <CardFace
                      key={`${card.id}-${index}`}
                      card={card}
                      compact={showPool}
                      disabled={readOnly}
                      onClick={
                        readOnly
                          ? undefined
                          : () => act('remove_one', { card: card.id })
                      }
                      onRightClick={
                        isPhysicalDeck && !readOnly
                          ? () => act('take_card', { card: card.id })
                          : undefined
                      }
                    />
                  ))}
                </div>
              </Section>
            )}
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
