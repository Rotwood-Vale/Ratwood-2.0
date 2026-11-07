import { useEffect, useRef, useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  compactButtonStyle,
  ellipsisCellStyle,
  FONT_BODY,
  FONT_LEAD,
  FONT_SMALL,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  inkInputStyle,
  pageStyle,
  PARCHMENT_DEEP,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
} from './common/parchment';
import {
  CommitField,
  parseWholeNumber,
  PriceField,
  type ShopData,
  ShopHeader,
} from './common/ShopControls';
import type { ActFn } from './Goldface/types';
import { starsIfIlliterate } from './Goldface/util';

type Tank = {
  label: string;
  default_label: string;
  price: number;
  volume: number;
  drawable: number;
  max: number;
  color: string | null;
};

type Container = {
  name: string;
  volume: number;
  max: number;
  color: string | null;
};

type PotionSellerData = ShopData & {
  bottle_price: number;
  bottles: number;
  max_bottles: number;
  loading_tank: number;
  tanks: Tank[];
  container: Container | null;
};

const TANK_HEIGHT = 280;
const VESSEL_HEIGHT = 160;
const EMPTY_LIQUID = '#8a7a5c';

const hexToRgb = (hex: string): [number, number, number] => {
  const h = hex.replace('#', '');
  return [
    parseInt(h.slice(0, 2), 16) || 0,
    parseInt(h.slice(2, 4), 16) || 0,
    parseInt(h.slice(4, 6), 16) || 0,
  ];
};

/** Volume-weighted blend of liquid colours. */
const blendColors = (parts: { color: string | null; amount: number }[]) => {
  let total = 0;
  const sum = [0, 0, 0];
  for (const part of parts) {
    if (!part.color || part.amount <= 0) continue;
    const rgb = hexToRgb(part.color);
    for (let i = 0; i < 3; i++) sum[i] += rgb[i] * part.amount;
    total += part.amount;
  }
  if (!total) return null;
  const hex = sum
    .map((c) =>
      Math.round(c / total)
        .toString(16)
        .padStart(2, '0'),
    )
    .join('');
  return `#${hex}`;
};

const stripes = (color: string) =>
  `repeating-linear-gradient(135deg, ${color} 0 6px, rgba(255,255,255,0.45) 6px 9px)`;

/** Price of the draws, rounded to 0.1 per dram total then up to whole mammon. */
const drawCost = (tanks: Tank[], draws: number[]) => {
  const raw = tanks.reduce((sum, t, i) => sum + t.price * (draws[i] || 0), 0);
  return Math.ceil(Math.round(raw * 10) / 10 - 1e-9);
};

/** Price >= 0 in 0.1 steps, or null if the draft isn't one. */
const parseDramPrice = (draft: string) => {
  const n = Number(draft);
  return draft.trim() !== '' && Number.isFinite(n) && n >= 0
    ? String(Math.round(n * 10) / 10)
    : null;
};

const TankColumn = (props: {
  index: number;
  tank: Tank;
  draw: number;
  maxDraw: number;
  owner: boolean;
  canRead: boolean;
  canDraw: boolean;
  isLoading: boolean;
  hasSource: boolean;
  pourAmount: number;
  onDraw: (amount: number) => void;
  act: ActFn;
}) => {
  const {
    index,
    tank,
    draw,
    maxDraw,
    owner,
    canRead,
    canDraw,
    isLoading,
    hasSource,
    pourAmount,
    onDraw,
    act,
  } = props;
  const tankRef = useRef<HTMLDivElement>(null);
  const [dragging, setDragging] = useState(false);
  const [confirmFlush, setConfirmFlush] = useState(false);
  const tankNumber = index + 1;

  const drawFromPointer = (clientY: number) => {
    const rect = tankRef.current?.getBoundingClientRect();
    if (!rect) return;
    const fraction = 1 - (clientY - rect.top) / rect.height;
    const level = Math.max(0, Math.min(1, fraction)) * tank.max;
    const wanted = Math.round(tank.volume - level);
    onDraw(Math.max(0, Math.min(maxDraw, wanted)));
  };

  // no deps: rebinds each render so the handlers see the current tank and limits
  useEffect(() => {
    if (!dragging) return;
    const move = (e: MouseEvent) => drawFromPointer(e.clientY);
    const up = () => setDragging(false);
    window.addEventListener('mousemove', move);
    window.addEventListener('mouseup', up);
    return () => {
      window.removeEventListener('mousemove', move);
      window.removeEventListener('mouseup', up);
    };
  });

  const liquid = tank.color || EMPTY_LIQUID;
  const levelPct = (tank.volume / tank.max) * 100;
  const linePct = ((tank.volume - draw) / tank.max) * 100;

  return (
    <div
      style={{
        flex: '1 1 0',
        minWidth: 0,
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        gap: '4px',
      }}
    >
      {owner && canRead ? (
        <CommitField
          value={tank.label}
          width="100%"
          // a blank label resets to the default name
          parse={(draft) => draft.trim() || tank.default_label}
          onCommit={(label) => act('set_label', { tank: tankNumber, label })}
        />
      ) : (
        <div
          style={{
            ...ellipsisCellStyle,
            flex: 'none',
            maxWidth: '100%',
            fontSize: FONT_TITLE,
            fontWeight: 'bold',
            textAlign: 'center',
          }}
        >
          {starsIfIlliterate(tank.label, canRead)}
        </div>
      )}
      {owner ? (
        <PriceField
          value={tank.price}
          unit="m/dram"
          canRead={canRead}
          step={0.1}
          width="64px"
          parse={parseDramPrice}
          onCommit={(price) => act('set_price', { tank: tankNumber, price })}
        />
      ) : (
        <div style={{ color: INK_SOFT, fontSize: FONT_LEAD }}>
          {starsIfIlliterate(
            tank.price ? `${tank.price}m a dram` : 'Free',
            canRead,
          )}
        </div>
      )}
      <div
        ref={tankRef}
        onMouseDown={(e) => {
          if (!canDraw || tank.drawable <= 0) return;
          setDragging(true);
          drawFromPointer(e.clientY);
        }}
        style={{
          position: 'relative',
          width: '90px',
          height: `${TANK_HEIGHT}px`,
          border: `2px solid ${INK}`,
          borderRadius: '6px 6px 3px 3px',
          background: PARCHMENT_DEEP,
          overflow: 'hidden',
          cursor: canDraw && tank.drawable > 0 ? 'ns-resize' : 'default',
          userSelect: 'none',
        }}
        title={`${tank.volume} / ${tank.max} drams`}
      >
        <div
          style={{
            position: 'absolute',
            left: 0,
            right: 0,
            bottom: 0,
            height: `${linePct}%`,
            background: liquid,
            opacity: 0.85,
          }}
        />
        {draw > 0 && (
          <div
            style={{
              position: 'absolute',
              left: 0,
              right: 0,
              bottom: `${linePct}%`,
              height: `${levelPct - linePct}%`,
              background: stripes(liquid),
              opacity: 0.7,
            }}
          />
        )}
        {tank.volume > 0 && (
          <div
            style={{
              position: 'absolute',
              left: '-2px',
              right: '-2px',
              bottom: `calc(${linePct}% - 1px)`,
              height: '2px',
              background: INK,
            }}
          />
        )}
      </div>
      <div style={{ color: INK_FAINT, fontSize: FONT_SMALL }}>
        {Math.floor(tank.volume)} / {tank.max}
      </div>
      {canDraw && (
        <div style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
          <button
            type="button"
            style={compactButtonStyle({ disabled: draw <= 0 })}
            disabled={draw <= 0}
            onClick={() => onDraw(draw - 1)}
          >
            -
          </button>
          <span style={{ minWidth: '56px', textAlign: 'center' }}>
            {starsIfIlliterate(`${draw} dram${draw === 1 ? '' : 's'}`, canRead)}
          </span>
          <button
            type="button"
            style={compactButtonStyle({ disabled: draw >= maxDraw })}
            disabled={draw >= maxDraw}
            onClick={() => onDraw(draw + 1)}
          >
            +
          </button>
        </div>
      )}
      {owner && (
        <div
          style={{
            display: 'flex',
            flexWrap: 'wrap',
            justifyContent: 'center',
            gap: '4px',
          }}
        >
          <button
            type="button"
            style={compactButtonStyle({ disabled: !hasSource })}
            disabled={!hasSource}
            onClick={() =>
              act(
                'pour_in',
                pourAmount
                  ? { tank: tankNumber, amount: pourAmount }
                  : { tank: tankNumber },
              )
            }
            title={starsIfIlliterate(
              pourAmount
                ? `Pour ${pourAmount} drams of the container into this tank`
                : 'Pour the container into this tank',
              canRead,
            )}
          >
            {starsIfIlliterate('Pour in', canRead)}
          </button>
          <button
            type="button"
            style={compactButtonStyle({
              color: confirmFlush ? SEAL_RED : undefined,
              disabled: tank.volume <= 0,
            })}
            disabled={tank.volume <= 0}
            onClick={() => {
              if (confirmFlush) {
                act('flush', { tank: tankNumber });
                setConfirmFlush(false);
              } else {
                setConfirmFlush(true);
              }
            }}
            onMouseLeave={() => setConfirmFlush(false)}
          >
            {starsIfIlliterate(confirmFlush ? 'Sure?' : 'Flush', canRead)}
          </button>
          <button
            type="button"
            style={compactButtonStyle({
              color: isLoading ? SEAL_AMBER : undefined,
            })}
            onClick={() => act('set_loading_tank', { tank: tankNumber })}
            title={starsIfIlliterate(
              'Bags emptied into the machine pour into this tank',
              canRead,
            )}
          >
            {starsIfIlliterate(isLoading ? 'Loading' : 'Load here', canRead)}
          </button>
        </div>
      )}
    </div>
  );
};

const Vessel = (props: {
  container: Container | null;
  previewColor: string | null;
  totalDraw: number;
  owner: boolean;
  canRead: boolean;
  pourAmount: string;
  setPourAmount: (amount: string) => void;
  act: ActFn;
}) => {
  const {
    container,
    previewColor,
    totalDraw,
    owner,
    canRead,
    pourAmount,
    setPourAmount,
    act,
  } = props;

  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        gap: '6px',
        marginTop: '10px',
      }}
    >
      {container ? (
        <>
          <div
            style={{
              ...ellipsisCellStyle,
              flex: 'none',
              maxWidth: '100%',
              fontSize: FONT_LEAD,
              textAlign: 'center',
            }}
            title={starsIfIlliterate(container.name, canRead)}
          >
            {starsIfIlliterate(container.name, canRead)}
          </div>
          <div
            style={{
              position: 'relative',
              width: '70px',
              height: `${VESSEL_HEIGHT}px`,
              border: `2px solid ${INK}`,
              borderRadius: '16px 16px 6px 6px',
              background: PARCHMENT_DEEP,
              overflow: 'hidden',
            }}
            title={`${container.volume} / ${container.max} drams`}
          >
            <div
              style={{
                position: 'absolute',
                left: 0,
                right: 0,
                bottom: 0,
                height: `${(container.volume / container.max) * 100}%`,
                background: container.color || EMPTY_LIQUID,
                opacity: 0.85,
              }}
            />
            {totalDraw > 0 && previewColor && (
              <div
                style={{
                  position: 'absolute',
                  left: 0,
                  right: 0,
                  bottom: `${(container.volume / container.max) * 100}%`,
                  height: `${(totalDraw / container.max) * 100}%`,
                  background: stripes(previewColor),
                  opacity: 0.7,
                }}
              />
            )}
          </div>
          <div style={{ color: INK_FAINT, fontSize: FONT_SMALL }}>
            {Math.floor(container.volume + totalDraw)} / {container.max}
          </div>
          <button
            type="button"
            style={compactButtonStyle()}
            onClick={() => act('eject')}
          >
            {starsIfIlliterate('Eject', canRead)}
          </button>
          {owner && (
            <div style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
              <span style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>
                {starsIfIlliterate('Pour in', canRead)}
              </span>
              <input
                type="number"
                min={1}
                step={1}
                value={pourAmount}
                placeholder={starsIfIlliterate('all', canRead)}
                onChange={(e) => setPourAmount(e.target.value)}
                style={{ ...inkInputStyle, width: '52px' }}
              />
            </div>
          )}
        </>
      ) : (
        <div
          style={{
            ...cardStyle,
            textAlign: 'center',
            fontStyle: 'italic',
            color: INK_SOFT,
            fontSize: FONT_BODY,
          }}
        >
          {starsIfIlliterate('Insert a container to fill.', canRead)}
        </div>
      )}
    </div>
  );
};

const BottleRow = (props: {
  owner: boolean;
  canRead: boolean;
  bottles: number;
  maxBottles: number;
  bottlePrice: number;
  budget: number;
  slotFull: boolean;
  act: ActFn;
}) => {
  const {
    owner,
    canRead,
    bottles,
    maxBottles,
    bottlePrice,
    budget,
    slotFull,
    act,
  } = props;
  const cantAffordBottle = !owner && bottlePrice > budget;
  // a bought bottle goes into the slot
  const blocked = !owner && slotFull;
  const disabled = !bottles || cantAffordBottle || blocked;

  return (
    <div
      style={{
        ...cardStyle,
        display: 'flex',
        alignItems: 'center',
        gap: '10px',
        marginTop: '8px',
      }}
    >
      <span style={{ color: SEAL_AMBER, fontFamily: SERIF }}>
        {starsIfIlliterate('Bottles', canRead)}
      </span>
      <span style={{ flex: 1, fontSize: FONT_TITLE, fontWeight: 'bold' }}>
        {bottles} / {maxBottles}
      </span>
      {owner && (
        <PriceField
          value={bottlePrice}
          unit="m/bottle"
          canRead={canRead}
          width="52px"
          parse={parseWholeNumber}
          onCommit={(price) => act('set_bottle_price', { price })}
        />
      )}
      <button
        type="button"
        style={inkButtonStyle({ disabled })}
        disabled={disabled}
        onClick={() => act('buy_bottle')}
        title={
          blocked
            ? starsIfIlliterate('Take your container out first', canRead)
            : undefined
        }
      >
        {starsIfIlliterate(
          owner
            ? 'Take a bottle'
            : bottlePrice
              ? `Buy bottle (${bottlePrice}m)`
              : 'Take a free bottle',
          canRead,
        )}
      </button>
    </div>
  );
};

export const PotionSeller = () => {
  const { act, data } = useBackend<PotionSellerData>();
  const locked = !!data.locked;
  const owner = !locked;
  const canRead = !!data.can_read;
  const { tanks, container } = data;
  const [draws, setDraws] = useState<number[]>(tanks.map(() => 0));
  const [pourAmount, setPourAmount] = useState('');
  const pourDrams = Math.max(0, Math.floor(Number(pourAmount)) || 0);

  // Most a tank can give, given the space and mammon left after other draws
  const space = container ? Math.floor(container.max - container.volume) : 0;
  const drawLimit = (tank: Tank, room: number, purse: number) => {
    let max = Math.min(tank.drawable, room);
    if (locked && tank.price > 0) {
      max = Math.min(max, Math.floor(purse / tank.price + 1e-6));
    }
    return Math.max(0, max);
  };

  // Clamp the draws in order, so they stay valid if the tanks or purse shrink
  const clamped: number[] = [];
  let totalDraw = 0;
  let rawCost = 0;
  tanks.forEach((tank, i) => {
    const max = drawLimit(tank, space - totalDraw, data.budget - rawCost);
    const draw = Math.min(draws[i] || 0, max);
    clamped.push(draw);
    totalDraw += draw;
    rawCost += tank.price * draw;
  });
  // Each tank can then take whatever the other draws leave free
  const maxDraws = tanks.map((tank, i) =>
    drawLimit(
      tank,
      space - (totalDraw - clamped[i]),
      data.budget - (rawCost - tank.price * clamped[i]),
    ),
  );
  const cost = locked ? drawCost(tanks, clamped) : 0;
  const previewColor = blendColors(
    tanks.map((tank, i) => ({ color: tank.color, amount: clamped[i] })),
  );
  const canDraw = !!container && space > 0;

  const setDraw = (index: number, amount: number) => {
    const next = tanks.map((_, i) => clamped[i]);
    next[index] = Math.max(0, Math.min(maxDraws[index], amount));
    setDraws(next);
  };

  return (
    <Window width={560} height={900} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <ShopHeader title="Potion Seller" />
          <div
            style={{
              display: 'flex',
              alignItems: 'flex-start',
              gap: '12px',
              marginTop: '14px',
            }}
          >
            {tanks.map((tank, i) => (
              <TankColumn
                key={i}
                index={i}
                tank={tank}
                draw={clamped[i]}
                maxDraw={maxDraws[i]}
                owner={owner}
                canRead={canRead}
                canDraw={canDraw}
                isLoading={data.loading_tank === i + 1}
                hasSource={!!container && container.volume > 0}
                pourAmount={pourDrams}
                onDraw={(amount) => setDraw(i, amount)}
                act={act}
              />
            ))}
          </div>
          <div style={{ ...rulerStyle, marginTop: '16px' }} />
          <Vessel
            container={container}
            previewColor={previewColor}
            totalDraw={totalDraw}
            owner={owner}
            canRead={canRead}
            pourAmount={pourAmount}
            setPourAmount={setPourAmount}
            act={act}
          />
          <div style={{ ...rulerStyle, marginTop: '16px' }} />
          <div
            style={{
              ...cardStyle,
              display: 'flex',
              alignItems: 'center',
              gap: '10px',
            }}
          >
            <span style={{ color: SEAL_AMBER, fontFamily: SERIF }}>
              {starsIfIlliterate('Your draw', canRead)}
            </span>
            <span style={{ flex: 1, fontSize: FONT_TITLE, fontWeight: 'bold' }}>
              {starsIfIlliterate(
                `${totalDraw} dram${totalDraw === 1 ? '' : 's'}${
                  locked ? ` for ${cost}m` : ''
                }`,
                canRead,
              )}
            </span>
            <button
              type="button"
              style={inkButtonStyle({ disabled: !totalDraw })}
              disabled={!totalDraw}
              onClick={() => setDraws(tanks.map(() => 0))}
            >
              {starsIfIlliterate('Clear', canRead)}
            </button>
            <button
              type="button"
              style={inkButtonStyle({
                color: SEAL_GREEN,
                disabled: !totalDraw,
              })}
              disabled={!totalDraw}
              onClick={() => {
                act('pour', { draws: clamped });
                setDraws(tanks.map(() => 0));
              }}
            >
              {starsIfIlliterate('Pour', canRead)}
            </button>
          </div>
          <BottleRow
            owner={owner}
            canRead={canRead}
            bottles={data.bottles}
            maxBottles={data.max_bottles}
            bottlePrice={data.bottle_price}
            budget={data.budget}
            slotFull={!!container}
            act={act}
          />
        </div>
      </Window.Content>
    </Window>
  );
};
