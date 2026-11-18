import { type CSSProperties, useEffect, useRef, useState } from 'react';
import { Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Card = {
  index?: number;
  label: string;
  rank?: string;
  suit?: string;
  hidden?: boolean;
};

type Player = {
  ckey: string;
  name: string;
  hand: Card[];
  hand_count: number;
  hand_value?: number | null;
  is_dealer?: boolean;
  standing: boolean;
  busted: boolean;
  ready: boolean;
  draws_used: number;
  poker_folded?: boolean;
  poker_all_in?: boolean;
  poker_bet?: number;
  poker_total_bet?: number;
  result?: string | null;
  left?: boolean;
  is_spirit?: boolean;
};

type FoolPair = {
  index: number;
  attack?: Card | null;
  defense?: Card | null;
};

type SolitaireSelection = {
  source: 'waste' | 'tableau';
  column?: number;
  cardIndex?: number;
};

type SolitaireFoundation = {
  suit: string;
  card?: Card | null;
  count: number;
};

type XylixCheat = {
  enabled: boolean;
  tier: number;
  skill: number;
  caught_chance: number;
  can_choose: boolean;
  cards: Card[];
};

type Data = {
  game_type: 'none' | 'fool' | 'blackjack' | 'poker' | 'solitaire';
  game_label: string;
  fool_variant: string;
  fool_variant_label: string;
  poker_variant: string;
  poker_variant_label: string;
  blackjack_variant: string;
  blackjack_variant_label: string;
  solitaire_variant: string;
  solitaire_variant_label: string;
  dealer_rotates: boolean;
  dealer_rotation_label: string;
  dealer_name?: string | null;
  rules: string[];
  stage: 'lobby' | 'playing' | 'finished';
  message: string;
  players: Player[];
  observers: string[];
  my_ckey?: string;
  is_player: boolean;
  is_host: boolean;
  is_observer: boolean;
  my_hand: Card[];
  deck_count: number;
  discard_count: number;
  min_players: number;
  max_players: number;
  can_start: boolean;
  can_pack: boolean;
  dealer_value?: number | null;
  community_cards: Card[];
  poker_turn?: string | null;
  poker_current_bet?: number;
  poker_pot?: number;
  poker_betting_round?: number;
  blackjack_action_seq?: number;
  blackjack_action_player_index?: number;
  blackjack_action_bust?: boolean;
  fool_action_seq?: number;
  fool_action_kind?: string | null;
  fool_action_player_index?: number;
  fool_action_target_index?: number;
  my_value?: number | null;
  solitaire_tableau?: { index: number; cards: Card[] }[];
  solitaire_stock_count?: number;
  solitaire_waste?: Card | null;
  solitaire_foundations?: SolitaireFoundation[];
  solitaire_completed_sets?: number;
  attacker?: string | null;
  defender?: string | null;
  table_attack?: string | null;
  table_defense?: string | null;
  table_pairs?: FoolPair[];
  trump?: string | null;
  xylix?: XylixCheat;
};

const stageText = {
  lobby: 'Lobby',
  playing: 'Playing',
  finished: 'Finished',
};

const resultText: Record<string, string> = {
  Bust: 'bust',
  Win: 'won',
  Lose: 'lost',
  Push: 'push',
  Winner: 'won',
  Lost: 'lost',
  Out: 'won',
  Fool: 'fool',
  Left: 'left the table',
  Dealer: 'dealer',
};

const suitMap: Record<string, string> = {
  H: '♥',
  D: '♦',
  C: '♣',
  S: '♠',
};

const tableLayoutStyle: CSSProperties = {
  display: 'grid',
  gridTemplateColumns: 'minmax(620px, 1fr) 320px',
  gap: '12px',
  alignItems: 'start',
};

const tableStyle: CSSProperties = {
  position: 'relative',
  minHeight: '690px',
  overflow: 'hidden',
  border: '1px solid rgba(255, 255, 255, 0.16)',
  background:
    'radial-gradient(circle at center, #246b45 0%, #174b34 58%, #0f3125 100%)',
  boxShadow: 'inset 0 0 0 8px rgba(92, 52, 25, 0.68)',
};

const centerStyle: CSSProperties = {
  position: 'absolute',
  left: '50%',
  top: '45%',
  width: '360px',
  minHeight: '210px',
  transform: 'translate(-50%, -50%)',
  display: 'grid',
  gridTemplateRows: 'auto 1fr auto',
  gap: '8px',
  padding: '14px',
  border: '1px solid rgba(255, 255, 255, 0.18)',
  backgroundColor: 'rgba(0, 0, 0, 0.18)',
};

const rowStyle: CSSProperties = {
  display: 'flex',
  flexWrap: 'wrap',
  gap: '6px',
  alignItems: 'center',
};

const seatBaseStyle: CSSProperties = {
  position: 'absolute',
  width: '178px',
  minHeight: '92px',
  padding: '8px',
  border: '1px solid rgba(255, 255, 255, 0.14)',
  backgroundColor: 'rgba(8, 17, 14, 0.62)',
};

const asciiCardStyle: CSSProperties = {
  margin: 0,
  fontFamily: 'Consolas, monospace',
  userSelect: 'none',
};

const cardShellStyle: CSSProperties = {
  position: 'relative',
  display: 'block',
  width: '54px',
  height: '70px',
  boxSizing: 'border-box',
  padding: '3px 4px',
  border: '2px solid rgba(0, 0, 0, 0.72)',
  backgroundColor: '#fffaf0',
  boxShadow: '0 2px 4px rgba(0, 0, 0, 0.35)',
};

const cardBackShellStyle: CSSProperties = {
  ...cardShellStyle,
  background:
    'repeating-linear-gradient(45deg, #214969 0, #214969 4px, #e8f2ff 4px, #e8f2ff 6px)',
  borderColor: 'rgba(221, 236, 255, 0.8)',
};

const tinyCardStyle: CSSProperties = {
  position: 'relative',
  width: '24px',
  height: '32px',
  boxSizing: 'border-box',
  border: '1px solid rgba(0, 0, 0, 0.76)',
  backgroundColor: '#fffaf0',
  display: 'grid',
  gridTemplateRows: '1fr 1fr',
  placeItems: 'center',
  fontFamily: 'Consolas, monospace',
  fontSize: '10px',
  fontWeight: 800,
  lineHeight: '10px',
  boxShadow: '0 1px 2px rgba(0, 0, 0, 0.32)',
};

const seatPositions: CSSProperties[] = [
  {
    left: '28px',
    right: '28px',
    bottom: '28px',
    width: 'auto',
    minHeight: '150px',
  },
  { left: '18px', top: '28px', width: '112px' },
  { left: '142px', top: '28px', width: '112px' },
  { left: '266px', top: '28px', width: '112px' },
  { right: '142px', top: '28px', width: '112px' },
  { right: '18px', top: '28px', width: '112px' },
];

const seatFlightPoints = [
  { x: 50, y: 86 },
  { x: 11, y: 18 },
  { x: 25, y: 18 },
  { x: 39, y: 18 },
  { x: 68, y: 18 },
  { x: 86, y: 18 },
];

type CardFlight = {
  id: number;
  fromX: number;
  fromY: number;
  toX: number;
  toY: number;
  label: string;
};

const solitaireBoardStyle: CSSProperties = {
  position: 'absolute',
  inset: '18px',
  display: 'grid',
  gridTemplateRows: '88px 1fr auto',
  gap: '18px',
};

const solitaireHeaderStyle: CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '1fr auto 1fr',
  gap: '16px',
  alignItems: 'start',
};

const foundationStyle: CSSProperties = {
  width: '54px',
  height: '70px',
  border: '2px dashed rgba(255, 255, 255, 0.34)',
  backgroundColor: 'rgba(255, 255, 255, 0.06)',
  boxSizing: 'border-box',
  display: 'grid',
  placeItems: 'center',
  color: 'rgba(255, 255, 255, 0.52)',
  fontWeight: 700,
};

const solitaireTableauStyle: CSSProperties = {
  display: 'grid',
  gridTemplateColumns: 'repeat(7, minmax(64px, 1fr))',
  gap: '12px',
  alignItems: 'start',
};

const solitaireColumnStyle: CSSProperties = {
  position: 'relative',
  minHeight: '310px',
  borderTop: '1px solid rgba(255, 255, 255, 0.14)',
  paddingTop: '8px',
};

const getRankSuit = (label?: string | null, card?: Card) => {
  if (card?.rank && card?.suit) {
    return { rank: card.rank, suit: card.suit };
  }
  const match = label?.match(/^([A-Z0-9]+)([HDCS])$/);
  return {
    rank: match?.[1] || '?',
    suit: match?.[2] || '?',
  };
};

const rankValue = (rank: string) => {
  if (rank === 'A') {
    return 14;
  }
  if (rank === 'K') {
    return 13;
  }
  if (rank === 'Q') {
    return 12;
  }
  if (rank === 'J') {
    return 11;
  }
  return Number(rank) || 0;
};

const suitValue = (suit: string) => {
  return ['S', 'H', 'D', 'C'].indexOf(suit);
};

const sortCardsForHand = (cards: Card[]) => {
  return [...cards].sort((left, right) => {
    const leftRankSuit = getRankSuit(left.label, left);
    const rightRankSuit = getRankSuit(right.label, right);
    const suitDelta =
      suitValue(leftRankSuit.suit) - suitValue(rightRankSuit.suit);
    if (suitDelta) {
      return suitDelta;
    }
    return rankValue(leftRankSuit.rank) - rankValue(rightRankSuit.rank);
  });
};

const suitColor = (suit: string) => {
  return suit === 'H' || suit === 'D' ? '#a31926' : '#101820';
};

const pokerComboColor = (score: number) => {
  if (score >= 7) {
    return '#d13b32';
  }
  if (score >= 6) {
    return '#e85d3d';
  }
  if (score >= 5) {
    return '#e58b2d';
  }
  if (score >= 4) {
    return '#d7b52f';
  }
  if (score >= 3) {
    return '#9bcf3b';
  }
  if (score >= 2) {
    return '#4fc36b';
  }
  return undefined;
};

const blackjackCardValue = (card: Card, variant: string) => {
  const { rank } = getRankSuit(card.label, card);
  const numeric = Number(rank);
  if (!Number.isNaN(numeric)) {
    return numeric;
  }
  if (variant === 'gron') {
    return rank === 'A' ? 1 : 11;
  }
  if (variant === 'kazengun') {
    return 1;
  }
  if (variant === 'azure' && rank === 'A') {
    return 11;
  }
  return 10;
};

const statusText = (player?: Player) => {
  if (!player) {
    return '';
  }

  const parts: string[] = [];
  if (player.standing) {
    parts.push('standing');
  }
  if (player.busted) {
    parts.push('bust');
  }
  if (player.poker_folded) {
    parts.push('folded');
  }
  if (player.poker_all_in) {
    parts.push('all in');
  }
  if (player.ready) {
    parts.push('ready');
  }
  if (player.left) {
    parts.push('left');
  }
  if (player.result) {
    parts.push(resultText[player.result] || player.result);
  }
  return parts.join(' / ');
};

const CardFace = (props: {
  card?: Card;
  label?: string;
  small?: boolean;
  selected?: boolean;
  highlightColor?: string;
  caption?: string | number | null;
  hoverLift?: boolean;
  onClick?: () => void;
}) => {
  const [hovered, setHovered] = useState(false);
  const card = props.card;
  const label = props.label || card?.label || '';
  const hidden = card?.hidden || label === '??' || !label;
  const { rank, suit } = getRankSuit(label, card);
  const faceSuit = suitMap[suit] || suit;
  const color = hidden ? '#dfe8f7' : suitColor(suit);
  const highlightColor = props.highlightColor;

  return (
    <div
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      onClick={(event) => {
        if (!props.onClick) {
          return;
        }
        event.stopPropagation();
        props.onClick();
      }}
      style={{
        ...(hidden ? cardBackShellStyle : cardShellStyle),
        width: props.small ? '48px' : cardShellStyle.width,
        height: props.small ? '62px' : cardShellStyle.height,
        borderColor: props.selected
          ? '#f4cf5c'
          : highlightColor ||
            (hidden ? 'rgba(221, 236, 255, 0.8)' : 'rgba(0, 0, 0, 0.72)'),
        backgroundColor: hidden
          ? undefined
          : highlightColor
            ? '#fffdf5'
            : '#fffaf0',
        cursor: props.onClick ? 'pointer' : 'default',
        outline: props.selected ? '2px solid #f4cf5c' : 'none',
        outlineOffset: '2px',
        transform:
          props.hoverLift && hovered
            ? 'scale(1.12) translateY(-6px)'
            : 'scale(1)',
        transformOrigin: 'center center',
        transition:
          'transform 120ms ease, box-shadow 120ms ease, border-color 120ms ease',
        zIndex: props.hoverLift && hovered ? 20 : undefined,
        boxShadow: highlightColor
          ? `0 0 0 2px ${highlightColor}, 0 0 12px ${highlightColor}, 0 2px 4px rgba(0, 0, 0, 0.35)`
          : cardShellStyle.boxShadow,
      }}
    >
      {hidden ? (
        <pre
          style={{
            ...asciiCardStyle,
            gridRow: '1 / -1',
            alignSelf: 'center',
            justifySelf: 'center',
            color,
            fontSize: props.small ? '11px' : '12px',
            lineHeight: '11px',
            whiteSpace: 'pre',
          }}
        >
          {'////\n////\n////'}
        </pre>
      ) : (
        <>
          <div
            style={{
              ...asciiCardStyle,
              position: 'absolute',
              right: '5px',
              top: '4px',
              textAlign: 'right',
              color,
              fontSize: props.small ? '12px' : '14px',
              fontWeight: 800,
              lineHeight: props.small ? '12px' : '14px',
            }}
          >
            {rank}
          </div>
          <div
            style={{
              ...asciiCardStyle,
              position: 'absolute',
              right: '6px',
              top: props.small ? '17px' : '20px',
              textAlign: 'right',
              color,
              fontSize: props.small ? '18px' : '22px',
              fontWeight: 800,
              lineHeight: props.small ? '18px' : '22px',
            }}
          >
            {faceSuit}
          </div>
          <div
            style={{
              ...asciiCardStyle,
              position: 'absolute',
              left: '5px',
              bottom: '4px',
              color,
              fontSize: props.small ? '12px' : '14px',
              fontWeight: 800,
              lineHeight: '14px',
            }}
          >
            {rank}
          </div>
          {props.caption !== undefined && props.caption !== null && (
            <div
              style={{
                ...asciiCardStyle,
                position: 'absolute',
                left: 0,
                right: 0,
                bottom: props.small ? '-14px' : '-16px',
                textAlign: 'center',
                color: '#f2f2f2',
                fontSize: props.small ? '10px' : '11px',
                lineHeight: '12px',
                textShadow: '0 1px 2px rgba(0,0,0,0.9)',
              }}
            >
              {props.caption}
            </div>
          )}
        </>
      )}
    </div>
  );
};

const CardRow = (props: { cards: Card[]; small?: boolean }) => {
  const { cards, small } = props;
  if (!cards?.length) {
    return <span style={{ opacity: 0.65 }}>No cards</span>;
  }
  return (
    <div style={rowStyle}>
      {cards.map((card, index) => (
        <CardFace key={`${card.label}-${index}`} card={card} small={small} />
      ))}
    </div>
  );
};

const TinyCardFace = (props: {
  card: Card;
  caption?: string | number | null;
}) => {
  const { rank, suit } = getRankSuit(props.card.label, props.card);
  const color = suitColor(suit);

  return (
    <div style={{ ...tinyCardStyle, color }}>
      <div>{rank}</div>
      <div>{suitMap[suit] || suit}</div>
      {props.caption !== undefined && props.caption !== null && (
        <div
          style={{
            position: 'absolute',
            marginTop: '40px',
            color: '#f2f2f2',
            fontSize: '9px',
            textShadow: '0 1px 2px rgba(0,0,0,0.9)',
          }}
        >
          {props.caption}
        </div>
      )}
    </div>
  );
};

const Seat = (props: {
  player?: Player;
  positionIndex: number;
  seatNumber: number;
  isMe: boolean;
  gameType: Data['game_type'];
  blackjackVariant: string;
  attacker?: string | null;
  defender?: string | null;
  dealer?: string | null;
  selectedCardIndex?: number | null;
  getCardHighlight?: (card: Card) => string | undefined;
  onCardClick?: (card: Card) => void;
}) => {
  const {
    player,
    positionIndex,
    seatNumber,
    isMe,
    gameType,
    blackjackVariant,
    attacker,
    defender,
    dealer,
    selectedCardIndex,
    getCardHighlight,
    onCardClick,
  } = props;
  const label = player ? player.name : `Seat ${seatNumber}`;
  const activeRole =
    player && !player.left && player.name === attacker
      ? 'Their turn'
      : player && !player.left && player.name === defender
        ? 'Defending'
        : player && !player.left && player.name === dealer
          ? 'Dealer'
          : null;
  const hasVisibleHand = !!player?.hand?.some((card) => !card.hidden);
  const showCards = !!player?.hand?.length && (isMe || hasVisibleHand);
  const showBlackjackValues = gameType === 'blackjack' && showCards;
  const displayedHand = player?.hand ? sortCardsForHand(player.hand) : [];

  return (
    <div
      style={{
        ...seatBaseStyle,
        ...seatPositions[positionIndex],
        outline: isMe ? '2px solid rgba(244, 207, 92, 0.9)' : 'none',
        opacity: player?.left ? 0.72 : 1,
      }}
    >
      <div style={{ fontWeight: 700, marginBottom: '4px' }}>
        {label}
        {isMe ? ' (you)' : ''}
      </div>
      <div style={{ minHeight: '16px', color: '#f4cf5c', fontSize: '12px' }}>
        {activeRole || statusText(player)}
      </div>
      {gameType === 'poker' && player && (
        <div style={{ minHeight: '16px', opacity: 0.82, fontSize: '12px' }}>
          Bet: {player.poker_bet || 0} / total: {player.poker_total_bet || 0}
        </div>
      )}
      {player ? (
        <div
          style={{
            ...rowStyle,
            marginTop: '6px',
            justifyContent: isMe ? 'center' : 'flex-start',
            flexWrap: isMe ? 'nowrap' : 'wrap',
            minHeight: isMe ? '92px' : undefined,
            maxWidth: isMe ? '100%' : undefined,
            overflowX: isMe ? 'auto' : undefined,
            overflowY: isMe ? 'visible' : undefined,
            alignContent: 'flex-start',
            padding: isMe ? '8px 4px 12px' : undefined,
          }}
        >
          {player.hand.length && isMe && onCardClick ? (
            displayedHand.map((card, cardIndex) => (
              <CardFace
                key={`${card.label}-${cardIndex}`}
                card={card}
                small
                selected={selectedCardIndex === card.index}
                highlightColor={getCardHighlight?.(card)}
                hoverLift
                caption={
                  showBlackjackValues
                    ? blackjackCardValue(card, blackjackVariant)
                    : null
                }
                onClick={() => onCardClick(card)}
              />
            ))
          ) : showCards ? (
            displayedHand.map((card, cardIndex) => (
              <TinyCardFace
                key={`${card.label}-${cardIndex}`}
                card={card}
                caption={
                  showBlackjackValues
                    ? blackjackCardValue(card, blackjackVariant)
                    : null
                }
              />
            ))
          ) : (
            <span style={{ opacity: 0.65 }}>Cards: {player.hand_count}</span>
          )}
          {showBlackjackValues &&
            player.hand_value !== null &&
            player.hand_value !== undefined && (
              <span style={{ opacity: 0.82, width: '100%', marginTop: '4px' }}>
                Total: {player.hand_value}
              </span>
            )}
        </div>
      ) : (
        <div style={{ opacity: 0.55, marginTop: '16px' }}>Empty</div>
      )}
    </div>
  );
};

const RulesBlock = (props: { rules: string[] }) => {
  if (!props.rules?.length) {
    return null;
  }
  return (
    <Section title="Rules">
      <div style={{ display: 'grid', gap: '6px' }}>
        {props.rules.map((rule, index) => (
          <div key={index} style={{ opacity: 0.86 }}>
            {rule}
          </div>
        ))}
      </div>
    </Section>
  );
};

const XylixBlock = (props: {
  xylix?: XylixCheat;
  onChoose: (cardIndex: number) => void;
}) => {
  const { xylix, onChoose } = props;
  if (!xylix?.enabled || !xylix.cards?.length) {
    return null;
  }

  return (
    <Section title="Xylix">
      <div style={{ display: 'grid', gap: '8px' }}>
        <div style={{ opacity: 0.82 }}>
          Tier: T{xylix.tier}. Chance of getting caught: {xylix.caught_chance}%.
        </div>
        <div style={rowStyle}>
          {xylix.cards.map((card, index) => (
            <div
              key={`${card.label}-${index}`}
              style={{ display: 'grid', gap: '4px', justifyItems: 'center' }}
            >
              <CardFace card={card} small />
              {xylix.can_choose && (
                <Button onClick={() => onChoose(index + 1)}>Choose</Button>
              )}
            </div>
          ))}
        </div>
        {!xylix.can_choose && (
          <div style={{ opacity: 0.72 }}>You can only look.</div>
        )}
      </div>
    </Section>
  );
};

const SolitaireBoard = (props: {
  gameLabel: string;
  variantLabel: string;
  variant: string;
  stage: Data['stage'];
  message: string;
  stockCount: number;
  discardCount: number;
  waste?: Card | null;
  foundations: SolitaireFoundation[];
  completedSets: number;
  tableau: { index: number; cards: Card[] }[];
  selected?: SolitaireSelection | null;
  onDraw: () => void;
  onSelectWaste: () => void;
  onSelectTableau: (column: number, cardIndex: number) => void;
  onMoveToTableau: (column: number) => void;
  onMoveToFoundation: (suit: string) => void;
}) => {
  const {
    gameLabel,
    variantLabel,
    variant,
    stage,
    message,
    stockCount,
    discardCount,
    waste,
    foundations,
    completedSets,
    tableau,
    selected,
    onDraw,
    onSelectWaste,
    onSelectTableau,
    onMoveToTableau,
    onMoveToFoundation,
  } = props;
  const isSpider = variant === 'spider';
  const tableauStyle = isSpider
    ? {
        ...solitaireTableauStyle,
        gridTemplateColumns: 'repeat(10, minmax(48px, 1fr))',
        gap: '6px',
      }
    : solitaireTableauStyle;
  const columnStyle = isSpider
    ? {
        ...solitaireColumnStyle,
        minHeight: '455px',
      }
    : solitaireColumnStyle;
  const cardStep = isSpider ? 18 : 30;

  return (
    <div style={solitaireBoardStyle}>
      <div style={solitaireHeaderStyle}>
        <div style={{ ...rowStyle, alignItems: 'flex-start' }}>
          <div style={{ textAlign: 'center' }}>
            <CardFace label={stockCount ? '??' : ''} onClick={onDraw} />
            <div style={{ marginTop: '4px', fontSize: '12px' }}>
              Stock: {stockCount}
            </div>
          </div>
          <div style={{ textAlign: 'center' }}>
            <CardFace
              card={waste || undefined}
              label={!waste && discardCount ? '??' : ''}
              selected={selected?.source === 'waste'}
              onClick={waste ? onSelectWaste : undefined}
            />
            <div style={{ marginTop: '4px', fontSize: '12px' }}>
              Discard: {discardCount}
            </div>
          </div>
        </div>

        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: '20px', fontWeight: 800 }}>{gameLabel}</div>
          <div style={{ opacity: 0.75 }}>
            {variantLabel} · {stageText[stage]}
          </div>
        </div>

        {isSpider ? (
          <div style={{ textAlign: 'right', minWidth: '160px' }}>
            <div style={{ fontSize: '12px', opacity: 0.78 }}>Completed</div>
            <div style={{ fontSize: '20px', fontWeight: 800 }}>
              {completedSets}/8
            </div>
          </div>
        ) : (
          <div style={{ ...rowStyle, justifyContent: 'flex-end' }}>
            {foundations.map((foundation) => (
              <div
                key={foundation.suit}
                style={foundationStyle}
                onClick={() => onMoveToFoundation(foundation.suit)}
              >
                {foundation.card ? (
                  <CardFace card={foundation.card} />
                ) : (
                  suitMap[foundation.suit]
                )}
              </div>
            ))}
          </div>
        )}
      </div>

      {tableau.length ? (
        <div style={tableauStyle}>
          {tableau.map((column) => (
            <div
              key={column.index}
              style={{
                ...columnStyle,
                outline:
                  selected?.source === 'tableau' &&
                  selected.column === column.index
                    ? '2px solid rgba(244, 207, 92, 0.9)'
                    : 'none',
              }}
              onClick={() => onMoveToTableau(column.index)}
            >
              {column.cards.map((card, cardIndex) => (
                <div
                  key={`${column.index}-${cardIndex}`}
                  style={{
                    position: 'absolute',
                    top: `${cardIndex * cardStep + 8}px`,
                    left: '50%',
                    transform: 'translateX(-50%)',
                    zIndex: cardIndex + 1,
                  }}
                >
                  <CardFace
                    card={card}
                    small={isSpider}
                    selected={
                      selected?.source === 'tableau' &&
                      selected.column === column.index &&
                      !!selected.cardIndex &&
                      cardIndex + 1 >= selected.cardIndex
                    }
                    onClick={
                      !card.hidden
                        ? () => {
                            if (
                              selected &&
                              !(
                                selected.source === 'tableau' &&
                                selected.column === column.index &&
                                selected.cardIndex === cardIndex + 1
                              )
                            ) {
                              onMoveToTableau(column.index);
                              return;
                            }
                            onSelectTableau(column.index, cardIndex + 1);
                          }
                        : undefined
                    }
                  />
                </div>
              ))}
            </div>
          ))}
        </div>
      ) : (
        <div
          style={{
            display: 'grid',
            placeItems: 'center',
            minHeight: '360px',
            opacity: 0.78,
          }}
        >
          Start a round to deal the solitaire.
        </div>
      )}

      {!!message && (
        <div style={{ color: '#d5efb3', minHeight: '18px' }}>{message}</div>
      )}
    </div>
  );
};

// eslint-disable-next-line complexity
export const CardTable = () => {
  const { act, data } = useBackend<Data>();
  const [selectedPokerCard, setSelectedPokerCard] = useState<number | null>(
    null,
  );
  const [pokerBetAmount, setPokerBetAmount] = useState(10);
  const lastBlackjackActionSeq = useRef(0);
  const lastFoolActionSeq = useRef(0);
  const [cardFlight, setCardFlight] = useState<CardFlight | null>(null);
  const [tableShaking, setTableShaking] = useState(false);
  const [selectedSolitaireCard, setSelectedSolitaireCard] =
    useState<SolitaireSelection | null>(null);
  const {
    game_type,
    game_label,
    fool_variant,
    fool_variant_label,
    poker_variant,
    poker_variant_label,
    blackjack_variant,
    blackjack_variant_label,
    solitaire_variant,
    solitaire_variant_label,
    dealer_rotates,
    dealer_rotation_label,
    dealer_name,
    rules = [],
    stage,
    message,
    players = [],
    observers = [],
    my_ckey,
    is_player,
    is_host,
    is_observer,
    my_hand = [],
    deck_count,
    discard_count,
    min_players,
    max_players,
    can_start,
    dealer_value,
    community_cards = [],
    poker_turn,
    poker_current_bet = 10,
    poker_pot = 0,
    poker_betting_round = 0,
    blackjack_action_seq = 0,
    blackjack_action_player_index = 0,
    blackjack_action_bust = false,
    fool_action_seq = 0,
    fool_action_kind,
    fool_action_player_index = 0,
    fool_action_target_index = 0,
    my_value,
    solitaire_tableau = [],
    solitaire_stock_count = 0,
    solitaire_waste,
    solitaire_foundations = [],
    solitaire_completed_sets = 0,
    attacker,
    defender,
    table_attack,
    table_defense,
    table_pairs = [],
    trump,
    xylix,
  } = data;

  const myPlayerIndex = players.findIndex((player) => player.ckey === my_ckey);
  const myPlayer = myPlayerIndex >= 0 ? players[myPlayerIndex] : undefined;
  const isLobby = stage === 'lobby';
  const isPlaying = stage === 'playing';
  const isFinished = stage === 'finished';
  useEffect(() => {
    setPokerBetAmount(poker_current_bet);
  }, [poker_current_bet]);
  const seatCount = Math.max(max_players || 6, 6);
  const visibleSeatCount = Math.min(seatCount, 6);
  const occupiedSeatEntries = players.map((player, index) => ({
    player,
    seatNumber: index + 1,
  }));
  const perspectiveSeatEntries =
    myPlayerIndex >= 0
      ? [
          occupiedSeatEntries[myPlayerIndex],
          ...occupiedSeatEntries.filter((_, index) => index !== myPlayerIndex),
        ]
      : occupiedSeatEntries;
  const occupiedSeatNumbers = new Set(
    occupiedSeatEntries.map((entry) => entry.seatNumber),
  );
  const freeSeatNumbers = Array.from({ length: visibleSeatCount })
    .map((_, index) => index + 1)
    .filter((seatNumber) => !occupiedSeatNumbers.has(seatNumber));
  let freeSeatIndex = 0;
  const screenSeatEntries = Array.from({ length: visibleSeatCount }).map(
    (_, positionIndex) => {
      const occupied = perspectiveSeatEntries[positionIndex];
      return {
        player: occupied?.player,
        seatNumber:
          occupied?.seatNumber ||
          freeSeatNumbers[freeSeatIndex++] ||
          positionIndex + 1,
        positionIndex,
      };
    },
  );
  const pointForPlayerIndex = (playerIndex: number) => {
    const player = players[playerIndex - 1];
    const screenEntry = screenSeatEntries.find(
      (entry) => entry.player?.ckey === player?.ckey,
    );
    return (
      seatFlightPoints[screenEntry?.positionIndex || 0] || seatFlightPoints[0]
    );
  };
  const startCardFlight = (
    from: { x: number; y: number },
    to: { x: number; y: number },
    label: string,
  ) => {
    const id = Date.now();
    setCardFlight({
      id,
      fromX: from.x,
      fromY: from.y,
      toX: to.x,
      toY: to.y,
      label,
    });
    window.setTimeout(() => {
      setCardFlight((current) => (current?.id === id ? null : current));
    }, 520);
  };
  const shakeTable = () => {
    setTableShaking(true);
    window.setTimeout(() => setTableShaking(false), 380);
  };
  useEffect(() => {
    if (
      blackjack_action_seq <= lastBlackjackActionSeq.current ||
      !blackjack_action_player_index
    ) {
      return;
    }
    lastBlackjackActionSeq.current = blackjack_action_seq;
    startCardFlight(
      { x: 70, y: 28 },
      pointForPlayerIndex(blackjack_action_player_index),
      '??',
    );
    if (blackjack_action_bust) {
      shakeTable();
    }
  }, [
    blackjack_action_seq,
    blackjack_action_player_index,
    blackjack_action_bust,
  ]);
  useEffect(() => {
    if (
      fool_action_seq <= lastFoolActionSeq.current ||
      !fool_action_player_index
    ) {
      return;
    }
    lastFoolActionSeq.current = fool_action_seq;
    const from = pointForPlayerIndex(fool_action_player_index);
    const to = fool_action_target_index
      ? pointForPlayerIndex(fool_action_target_index)
      : { x: 50, y: 45 };
    startCardFlight(
      from,
      to,
      fool_action_kind === 'defend'
        ? table_defense || '??'
        : table_attack || '??',
    );
    if (fool_action_kind === 'defend') {
      shakeTable();
    }
  }, [
    fool_action_seq,
    fool_action_kind,
    fool_action_player_index,
    fool_action_target_index,
    table_attack,
    table_defense,
  ]);
  const canUseDealerRotation =
    game_type === 'blackjack' || game_type === 'poker';
  const canTransfer =
    game_type === 'fool' &&
    (fool_variant === 'transfer' || fool_variant === 'throw_transfer');
  const canActInPoker =
    game_type === 'poker' &&
    isPlaying &&
    !!myPlayer &&
    myPlayer.name === poker_turn;
  const playerResultText = players
    .filter((player) => !!player.result)
    .map(
      (player) =>
        `${player.name} - ${resultText[player.result || ''] || player.result}`,
    )
    .join(', ');
  const finalText =
    isFinished && playerResultText
      ? playerResultText
      : isFinished && game_type === 'blackjack'
        ? `Dealer: ${dealer_name || '-'}`
        : '';
  const attackRank = getRankSuit(table_attack || '').rank;
  const attackSuit = getRankSuit(table_attack || '').suit;
  const tableRanks = new Set<string>();
  table_pairs.forEach((pair) => {
    if (pair.attack) {
      tableRanks.add(getRankSuit(pair.attack.label, pair.attack).rank);
    }
    if (pair.defense) {
      tableRanks.add(getRankSuit(pair.defense.label, pair.defense).rank);
    }
  });
  const cardBeatsAttack = (card: Card) => {
    if (!table_attack) {
      return false;
    }
    const { rank, suit } = getRankSuit(card.label, card);
    if (suit === attackSuit && rankValue(rank) > rankValue(attackRank)) {
      return true;
    }
    return !!trump && suit === trump && attackSuit !== trump;
  };
  const pokerHighlightForCard = (card: Card) => {
    if (game_type !== 'poker') {
      return undefined;
    }
    const allCards = [...my_hand, ...community_cards].filter(
      (entry) => !entry.hidden,
    );
    const rankCounts: Record<string, number> = {};
    const suitCounts: Record<string, number> = {};
    allCards.forEach((entry) => {
      const { rank, suit } = getRankSuit(entry.label, entry);
      rankCounts[rank] = (rankCounts[rank] || 0) + 1;
      suitCounts[suit] = (suitCounts[suit] || 0) + 1;
    });
    const { rank, suit } = getRankSuit(card.label, card);
    const groups = Object.values(rankCounts).sort((a, b) => b - a);
    const pairs = Object.entries(rankCounts)
      .filter(([, count]) => count === 2)
      .map(([pairRank]) => pairRank);
    const tripRank = Object.entries(rankCounts).find(
      ([, count]) => count === 3,
    )?.[0];
    const quadRank = Object.entries(rankCounts).find(
      ([, count]) => count === 4,
    )?.[0];
    const uniqueRanks = Array.from(
      new Set(
        allCards.map((entry) =>
          rankValue(getRankSuit(entry.label, entry).rank),
        ),
      ),
    ).sort((a, b) => a - b);
    if (uniqueRanks.includes(14)) {
      uniqueRanks.unshift(1);
    }
    let straightRanks: number[] = [];
    for (let i = 0; i <= uniqueRanks.length - 5; i++) {
      const slice = uniqueRanks.slice(i, i + 5);
      if (slice[4] - slice[0] === 4 && new Set(slice).size === 5) {
        straightRanks = slice;
      }
    }
    const cardRankValue = rankValue(rank);
    const normalizedCardRank =
      cardRankValue === 14 && straightRanks.includes(1) ? 1 : cardRankValue;
    if (quadRank && rank === quadRank) {
      return pokerComboColor(7);
    }
    if (groups[0] === 3 && groups[1] >= 2 && rankCounts[rank] >= 2) {
      return pokerComboColor(6);
    }
    if (suitCounts[suit] >= 5) {
      return pokerComboColor(5);
    }
    if (straightRanks.includes(normalizedCardRank)) {
      return pokerComboColor(4);
    }
    if (tripRank && rank === tripRank) {
      return pokerComboColor(3);
    }
    if (pairs.length >= 2 && pairs.includes(rank)) {
      return pokerComboColor(2.5);
    }
    if (pairs.length === 1 && pairs.includes(rank)) {
      return pokerComboColor(2);
    }
    return undefined;
  };
  const getOwnCardHighlight = (card: Card) => {
    if (!isPlaying || !myPlayer) {
      return undefined;
    }
    if (game_type === 'poker') {
      return pokerHighlightForCard(card);
    }
    if (game_type !== 'fool') {
      return undefined;
    }
    const { rank } = getRankSuit(card.label, card);
    if (myPlayer.name === attacker && !table_attack) {
      return '#4fc36b';
    }
    if (
      myPlayer.name === attacker &&
      table_attack &&
      table_defense &&
      tableRanks.has(rank) &&
      (fool_variant === 'throw_in' || fool_variant === 'throw_transfer')
    ) {
      return '#4fc36b';
    }
    if (myPlayer.name !== defender || !table_attack || table_defense) {
      return undefined;
    }
    if (canTransfer && rank === attackRank) {
      return '#4fc36b';
    }
    if (cardBeatsAttack(card)) {
      return '#4fc36b';
    }
    return undefined;
  };
  const clickOwnCard = (card: Card) => {
    if (!isPlaying || !myPlayer || !card.index) {
      return;
    }
    if (game_type === 'poker' && poker_variant === 'draw') {
      if (!myPlayer.ready && myPlayer.draws_used < 1) {
        setSelectedPokerCard(
          selectedPokerCard === card.index ? null : card.index,
        );
      }
      return;
    }
    if (game_type !== 'fool') {
      return;
    }
    if (myPlayer.name === attacker && !table_attack) {
      act('fool_attack', { card_index: card.index });
      return;
    }
    if (
      myPlayer.name === attacker &&
      table_attack &&
      table_defense &&
      tableRanks.has(getRankSuit(card.label, card).rank) &&
      (fool_variant === 'throw_in' || fool_variant === 'throw_transfer')
    ) {
      act('fool_attack', { card_index: card.index });
      return;
    }
    if (myPlayer.name === defender && table_attack && !table_defense) {
      const cardRank = getRankSuit(card.label, card).rank;
      if (
        canTransfer &&
        table_attack &&
        !table_defense &&
        cardRank === attackRank
      ) {
        act('fool_transfer', { card_index: card.index });
      } else if (cardBeatsAttack(card)) {
        act('fool_defend', { card_index: card.index });
      }
    }
  };
  const drawSolitaire = () => {
    setSelectedSolitaireCard(null);
    act('solitaire_draw');
  };
  const selectSolitaireWaste = () => {
    setSelectedSolitaireCard(
      selectedSolitaireCard?.source === 'waste' ? null : { source: 'waste' },
    );
  };
  const selectSolitaireTableau = (column: number, cardIndex: number) => {
    if (
      selectedSolitaireCard?.source === 'tableau' &&
      selectedSolitaireCard.column === column &&
      selectedSolitaireCard.cardIndex === cardIndex
    ) {
      setSelectedSolitaireCard(null);
      return;
    }
    setSelectedSolitaireCard({ source: 'tableau', column, cardIndex });
  };
  const moveSolitaire = (
    targetType: 'tableau' | 'foundation',
    targetColumn?: number,
    targetSuit?: string,
  ) => {
    if (!selectedSolitaireCard) {
      return;
    }
    act('solitaire_move', {
      source_type: selectedSolitaireCard.source,
      source_column: selectedSolitaireCard.column || 0,
      source_index: selectedSolitaireCard.cardIndex || 0,
      target_type: targetType,
      target_column: targetColumn || 0,
      target_suit: targetSuit || '',
    });
    setSelectedSolitaireCard(null);
  };
  const chooseXylixCard = (cardIndex: number) => {
    act('xylix_choose_card', { card_index: cardIndex });
  };

  return (
    <Window width={1020} height={840} title="Card Table">
      <Window.Content scrollable>
        <style>
          {`
            @keyframes card-table-flight {
              0% {
                left: calc(var(--from-x) * 1%);
                top: calc(var(--from-y) * 1%);
                opacity: 0;
                transform: translate(-50%, -50%) scale(0.78) rotate(-7deg);
              }
              12% {
                opacity: 1;
              }
              100% {
                left: calc(var(--to-x) * 1%);
                top: calc(var(--to-y) * 1%);
                opacity: 0;
                transform: translate(-50%, -50%) scale(1.03) rotate(7deg);
              }
            }
            @keyframes card-table-shake {
              0%, 100% { transform: translate(0, 0); }
              20% { transform: translate(-2px, 1px); }
              40% { transform: translate(2px, -1px); }
              60% { transform: translate(-1px, -1px); }
              80% { transform: translate(1px, 1px); }
            }
          `}
        </style>
        <div style={tableLayoutStyle}>
          <div
            style={{
              ...tableStyle,
              animation: tableShaking
                ? 'card-table-shake 360ms ease-in-out'
                : undefined,
            }}
          >
            {cardFlight && (
              <div
                key={cardFlight.id}
                style={
                  {
                    position: 'absolute',
                    '--from-x': cardFlight.fromX,
                    '--from-y': cardFlight.fromY,
                    '--to-x': cardFlight.toX,
                    '--to-y': cardFlight.toY,
                    zIndex: 50,
                    pointerEvents: 'none',
                    animation: 'card-table-flight 520ms ease-out forwards',
                  } as CSSProperties
                }
              >
                <CardFace label={cardFlight.label} small />
              </div>
            )}
            {game_type === 'solitaire' ? (
              <SolitaireBoard
                gameLabel={game_label}
                variantLabel={solitaire_variant_label}
                variant={solitaire_variant}
                stage={stage}
                message={message}
                stockCount={solitaire_stock_count}
                discardCount={discard_count}
                waste={solitaire_waste}
                foundations={solitaire_foundations}
                completedSets={solitaire_completed_sets}
                tableau={solitaire_tableau}
                selected={selectedSolitaireCard}
                onDraw={drawSolitaire}
                onSelectWaste={selectSolitaireWaste}
                onSelectTableau={selectSolitaireTableau}
                onMoveToTableau={(column) => moveSolitaire('tableau', column)}
                onMoveToFoundation={(suit) =>
                  moveSolitaire('foundation', undefined, suit)
                }
              />
            ) : (
              <>
                {screenSeatEntries.map(
                  ({ player, positionIndex, seatNumber }) => {
                    const displayPlayer =
                      player && player.ckey === my_ckey
                        ? {
                            ...player,
                            hand: my_hand,
                          }
                        : player;
                    return (
                      <Seat
                        key={`${positionIndex}-${seatNumber}`}
                        player={displayPlayer}
                        positionIndex={positionIndex}
                        seatNumber={seatNumber}
                        isMe={!!player && player.ckey === my_ckey}
                        gameType={game_type}
                        blackjackVariant={blackjack_variant}
                        attacker={attacker}
                        defender={defender}
                        dealer={dealer_name}
                        selectedCardIndex={selectedPokerCard}
                        getCardHighlight={getOwnCardHighlight}
                        onCardClick={clickOwnCard}
                      />
                    );
                  },
                )}

                <div style={centerStyle}>
                  <div style={{ ...rowStyle, justifyContent: 'space-between' }}>
                    <div>
                      <div style={{ fontSize: '18px', fontWeight: 800 }}>
                        {game_label}
                      </div>
                      <div style={{ opacity: 0.75 }}>
                        {stageText[stage]} ·{' '}
                        {game_type === 'fool'
                          ? fool_variant_label
                          : game_type === 'poker'
                            ? poker_variant_label
                            : game_type === 'blackjack'
                              ? blackjack_variant_label
                              : stageText[stage]}
                      </div>
                    </div>
                    <div style={rowStyle}>
                      <div style={{ textAlign: 'center' }}>
                        <CardFace label="??" />
                        <div style={{ fontSize: '11px' }}>{deck_count}</div>
                      </div>
                      <div style={{ textAlign: 'center' }}>
                        <CardFace label={discard_count ? '??' : ''} />
                        <div style={{ fontSize: '11px' }}>{discard_count}</div>
                      </div>
                    </div>
                  </div>

                  {game_type === 'blackjack' && (
                    <div>
                      <div style={{ marginBottom: '6px', fontWeight: 700 }}>
                        Dealer: {dealer_name || '-'}{' '}
                        {isFinished && dealer_value ? `(${dealer_value})` : ''}
                      </div>
                      <div style={{ opacity: 0.76 }}>
                        The dealer's hand is shown at their seat.{' '}
                        {dealer_rotation_label}.
                      </div>
                    </div>
                  )}

                  {game_type === 'fool' && (
                    <div>
                      <div style={{ ...rowStyle, marginBottom: '8px' }}>
                        <b>Trump:</b> {suitMap[trump || ''] || trump || '-'}
                        <b>Attack:</b> {table_attack || '-'}
                        <b>Defense:</b> {table_defense || '-'}
                      </div>
                      <div style={{ ...rowStyle, justifyContent: 'center' }}>
                        {table_pairs.length ? (
                          table_pairs.map((pair) => (
                            <div
                              key={pair.index}
                              style={{
                                position: 'relative',
                                width: '70px',
                                height: '106px',
                              }}
                            >
                              <div
                                style={{
                                  position: 'absolute',
                                  left: 0,
                                  top: 0,
                                }}
                              >
                                <CardFace card={pair.attack || undefined} />
                              </div>
                              {pair.defense && (
                                <div
                                  style={{
                                    position: 'absolute',
                                    left: '12px',
                                    top: '34px',
                                  }}
                                >
                                  <CardFace card={pair.defense} />
                                </div>
                              )}
                            </div>
                          ))
                        ) : (
                          <>
                            <CardFace />
                            <CardFace />
                          </>
                        )}
                      </div>
                    </div>
                  )}

                  {game_type === 'poker' && (
                    <div>
                      <div
                        style={{
                          marginBottom: '8px',
                          fontWeight: 700,
                          display:
                            poker_variant === 'draw' ? 'none' : undefined,
                        }}
                      >
                        Community cards
                      </div>
                      <div style={{ marginBottom: '4px', opacity: 0.82 }}>
                        Round: {poker_betting_round || 1}
                      </div>
                      <div style={{ marginBottom: '6px', opacity: 0.82 }}>
                        Turn: {poker_turn || '-'} | Pot: {poker_pot} | Current
                        bet: {poker_current_bet}
                      </div>
                      {poker_variant !== 'draw' &&
                        (community_cards.length ? (
                          <CardRow cards={community_cards} />
                        ) : null)}
                    </div>
                  )}

                  {game_type === 'none' && (
                    <div style={{ textAlign: 'center', opacity: 0.82 }}>
                      Take a seat. The first player picks the game.
                    </div>
                  )}

                  {!!message && (
                    <div style={{ color: '#d5efb3', minHeight: '18px' }}>
                      {message}
                    </div>
                  )}
                  {!!finalText && (
                    <div style={{ color: '#f4cf5c', fontWeight: 700 }}>
                      Result: {finalText}
                    </div>
                  )}

                  {isPlaying && is_player && game_type === 'blackjack' && (
                    <div style={rowStyle}>
                      <Button
                        disabled={!!myPlayer?.standing}
                        onClick={() => act('blackjack_hit')}
                      >
                        Hit
                      </Button>
                      <Button
                        disabled={!!myPlayer?.standing}
                        onClick={() => act('blackjack_stand')}
                      >
                        Stand
                      </Button>
                    </div>
                  )}

                  {isPlaying && is_player && game_type === 'poker' && (
                    <div style={rowStyle}>
                      <input
                        type="number"
                        min={10}
                        value={pokerBetAmount}
                        disabled={!canActInPoker}
                        onChange={(event) =>
                          setPokerBetAmount(
                            Math.max(
                              10,
                              Number(event.currentTarget.value) || 10,
                            ),
                          )
                        }
                        style={{
                          width: '54px',
                          height: '22px',
                          boxSizing: 'border-box',
                          background: 'rgba(255,255,255,0.08)',
                          border: '1px solid rgba(255,255,255,0.26)',
                          color: '#f2f2f2',
                        }}
                      />
                      <Button
                        disabled={!canActInPoker}
                        onClick={() =>
                          pokerBetAmount > poker_current_bet
                            ? act('poker_bet', { amount: pokerBetAmount })
                            : act('poker_check')
                        }
                      >
                        Bet
                      </Button>
                      <Button
                        disabled={!canActInPoker}
                        onClick={() => act('poker_all_in')}
                      >
                        All In
                      </Button>
                      <Button
                        disabled={!canActInPoker}
                        onClick={() => act('poker_fold')}
                      >
                        Fold
                      </Button>
                    </div>
                  )}

                  {isPlaying && is_player && game_type === 'fool' && (
                    <div style={rowStyle}>
                      <Button
                        disabled={!table_attack}
                        onClick={() => act('fool_take')}
                      >
                        Take
                      </Button>
                      <Button
                        disabled={!table_attack || !table_defense}
                        onClick={() => act('fool_end_attack')}
                      >
                        Done
                      </Button>
                    </div>
                  )}
                </div>
              </>
            )}
          </div>

          <Stack vertical>
            <Stack.Item>
              <Section title="Game">
                <div style={rowStyle}>
                  <Button
                    selected={game_type === 'blackjack'}
                    disabled={!isLobby || !is_host}
                    onClick={() => act('set_game', { game: 'blackjack' })}
                  >
                    Blackjack
                  </Button>
                  <Button
                    selected={game_type === 'poker'}
                    disabled={!isLobby || !is_host}
                    onClick={() => act('set_game', { game: 'poker' })}
                  >
                    Poker
                  </Button>
                </div>

                {isLobby && game_type === 'blackjack' && (
                  <div style={{ ...rowStyle, marginTop: '8px' }}>
                    <Button
                      selected={blackjack_variant === 'gron'}
                      disabled={!is_host}
                      onClick={() =>
                        act('set_blackjack_variant', { variant: 'gron' })
                      }
                    >
                      Gronnic
                    </Button>
                    <Button
                      selected={blackjack_variant === 'valoria'}
                      disabled={!is_host}
                      onClick={() =>
                        act('set_blackjack_variant', { variant: 'valoria' })
                      }
                    >
                      Valorian
                    </Button>
                    <Button
                      selected={blackjack_variant === 'azure'}
                      disabled={!is_host}
                      onClick={() =>
                        act('set_blackjack_variant', { variant: 'azure' })
                      }
                    >
                      Rockhillian
                    </Button>
                    <Button
                      selected={blackjack_variant === 'grenzel'}
                      disabled={!is_host}
                      onClick={() =>
                        act('set_blackjack_variant', { variant: 'grenzel' })
                      }
                    >
                      Grenzelhoftian
                    </Button>
                    <Button
                      selected={blackjack_variant === 'kazengun'}
                      disabled={!is_host}
                      onClick={() =>
                        act('set_blackjack_variant', { variant: 'kazengun' })
                      }
                    >
                      Kazengunite
                    </Button>
                  </div>
                )}

                {isLobby && game_type === 'poker' && (
                  <div style={{ ...rowStyle, marginTop: '8px' }}>
                    <Button
                      selected={poker_variant === 'draw'}
                      disabled={!is_host}
                      onClick={() =>
                        act('set_poker_variant', { variant: 'draw' })
                      }
                    >
                      Rockhillian
                    </Button>
                    <Button
                      selected={poker_variant === 'texas'}
                      disabled={!is_host}
                      onClick={() =>
                        act('set_poker_variant', { variant: 'texas' })
                      }
                    >
                      Raneshi
                    </Button>
                    <Button
                      selected={poker_variant === 'omaha'}
                      disabled={!is_host}
                      onClick={() =>
                        act('set_poker_variant', { variant: 'omaha' })
                      }
                    >
                      Valorian
                    </Button>
                    <Button
                      selected={poker_variant === 'stud'}
                      disabled={!is_host}
                      onClick={() =>
                        act('set_poker_variant', { variant: 'stud' })
                      }
                    >
                      Giza
                    </Button>
                  </div>
                )}

                {isLobby && canUseDealerRotation && (
                  <div style={{ ...rowStyle, marginTop: '8px' }}>
                    <Button
                      selected={!!dealer_rotates}
                      disabled={!is_host}
                      onClick={() => act('set_dealer_rotation', { rotates: 1 })}
                    >
                      Rotating dealer
                    </Button>
                    <Button
                      selected={!dealer_rotates}
                      disabled={!is_host}
                      onClick={() => act('set_dealer_rotation', { rotates: 0 })}
                    >
                      Fixed dealer
                    </Button>
                  </div>
                )}

                <div style={{ marginTop: '8px', opacity: 0.78 }}>
                  {game_type === 'none' ? (
                    <>Seats: {players.length}/6. The first player picks the game.</>
                  ) : (
                    <>
                      Seats: {players.length}/{max_players}. Needed:{' '}
                      {min_players}-{max_players}.
                      {dealer_name ? ` Dealer: ${dealer_name}.` : ''}
                    </>
                  )}
                </div>
                {game_type !== 'none' && !is_host && (
                  <div style={{ marginTop: '8px', opacity: 0.78 }}>
                    Only the first player to sit down can change the settings.
                  </div>
                )}
              </Section>
            </Stack.Item>

            <Stack.Item>
              <Section title="Seat">
                <div style={rowStyle}>
                  <Button
                    disabled={!isLobby}
                    onClick={() => act('join_player')}
                  >
                    Sit
                  </Button>
                  <Button onClick={() => act('join_observer')}>Watch</Button>
                  <Button
                    disabled={!is_player && !is_observer}
                    onClick={() => act('leave')}
                  >
                    Leave
                  </Button>
                </div>
              </Section>
            </Stack.Item>

            <Stack.Item>
              <Section title="Round">
                <div style={rowStyle}>
                  <Button disabled={!can_start} onClick={() => act('start')}>
                    Start
                  </Button>
                  <Button
                    disabled={!isFinished && players.length > 0}
                    onClick={() => act('reset_lobby')}
                  >
                    Reset
                  </Button>
                </div>
              </Section>
            </Stack.Item>

            <Stack.Item>
              <XylixBlock xylix={xylix} onChoose={chooseXylixCard} />
            </Stack.Item>

            <Stack.Item>
              <RulesBlock rules={rules} />
            </Stack.Item>

            {!!observers.length && (
              <Stack.Item>
                <Section title={`Watching (${observers.length})`}>
                  {observers.join(', ')}
                </Section>
              </Stack.Item>
            )}

            {isFinished && (
              <Stack.Item>
                <Section title="Game over">
                  <Button onClick={() => act('reset_lobby')}>
                    Back to lobby
                  </Button>
                </Section>
              </Stack.Item>
            )}
          </Stack>
        </div>
      </Window.Content>
    </Window>
  );
};
