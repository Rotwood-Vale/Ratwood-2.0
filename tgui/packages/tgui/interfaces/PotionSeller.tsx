import { useEffect, useRef, useState } from 'react';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  compactButtonStyle,
  fieldRowStyle,
  fieldValueStyle,
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
  SEAL_RED,
  SERIF,
  titleStyle,
} from './common/parchment';
import { starsIfIlliterate } from './Goldface/util';

type Tank = {
  label: string;
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

type PotionSellerData = {
  locked: BooleanLike;
  can_read: BooleanLike;
  budget: number;
  profits: number;
  bottle_price: number;
  bottles: number;
  max_bottles: number;
  loading_tank: number;
  tanks: Tank[];
  container: Container | null;
};

type ActFn = (action: string, payload?: Record<string, unknown>) => void;

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

/** Text input that keeps a local draft and only sends it on Enter or blur. */
const CommitField = (props: {
  value: string;
  numeric?: boolean;
  step?: number;
  width: string;
  onCommit: (value: string) => void;
}) => {
  const { value, numeric, step, width, onCommit } = props;
  const [draft, setDraft] = useState(value);

  useEffect(() => {
    setDraft(value);
  }, [value]);

  const commit = () => {
    if (draft !== value) onCommit(draft);
  };

  return (
    <input
      type={numeric ? 'number' : 'text'}
      min={numeric ? 0 : undefined}
      step={numeric ? (step ?? 1) : undefined}
      value={draft}
      onChange={(e) => setDraft(e.target.value)}
      onBlur={commit}
      onKeyDown={(e) => {
        if (e.key === 'Enter') commit();
      }}
      style={{ ...inkInputStyle, width }}
    />
  );
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
          onCommit={(label) => act('set_label', { tank: tankNumber, label })}
        />
      ) : (
        <div
          style={{
            fontSize: FONT_TITLE,
            fontWeight: 'bold',
            textAlign: 'center',
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            maxWidth: '100%',
          }}
        >
          {starsIfIlliterate(tank.label, canRead)}
        </div>
      )}
      {owner ? (
        <div style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
          <CommitField
            value={String(tank.price)}
            numeric
            step={0.1}
            width="64px"
            onCommit={(price) => act('set_price', { tank: tankNumber, price })}
          />
          <span style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>m/dram</span>
        </div>
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
            {draw} dram{draw === 1 ? '' : 's'}
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
            onClick={() => act('pour_in', { tank: tankNumber })}
            title="Pour the container into this tank"
          >
            Pour in
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
            {confirmFlush ? 'Sure?' : 'Flush'}
          </button>
          <button
            type="button"
            style={compactButtonStyle({
              color: isLoading ? SEAL_AMBER : undefined,
            })}
            onClick={() => act('set_loading_tank', { tank: tankNumber })}
            title="Bags emptied into the machine pour into this tank"
          >
            {isLoading ? 'Loading' : 'Load here'}
          </button>
        </div>
      )}
    </div>
  );
};

const VesselColumn = (props: {
  container: Container | null;
  previewColor: string | null;
  totalDraw: number;
  owner: boolean;
  canRead: boolean;
  bottles: number;
  maxBottles: number;
  bottlePrice: number;
  budget: number;
  act: ActFn;
}) => {
  const {
    container,
    previewColor,
    totalDraw,
    owner,
    canRead,
    bottles,
    maxBottles,
    bottlePrice,
    budget,
    act,
  } = props;
  const cantAffordBottle = !owner && bottlePrice > budget;

  return (
    <div
      style={{
        flex: '0 0 150px',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        gap: '6px',
        alignSelf: 'flex-end',
      }}
    >
      {container ? (
        <>
          <div
            style={{
              fontSize: FONT_LEAD,
              textAlign: 'center',
              maxWidth: '100%',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap',
            }}
            title={container.name}
          >
            {container.name}
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
      <div style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>
        {starsIfIlliterate(`Bottles: ${bottles}/${maxBottles}`, canRead)}
      </div>
      {owner && (
        <div style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
          <CommitField
            value={String(bottlePrice)}
            numeric
            width="52px"
            onCommit={(price) => act('set_bottle_price', { price })}
          />
          <span style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>
            m/bottle
          </span>
        </div>
      )}
      <button
        type="button"
        style={compactButtonStyle({ disabled: !bottles || cantAffordBottle })}
        disabled={!bottles || cantAffordBottle}
        onClick={() => act('buy_bottle')}
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

  // Clamp every draw against the tank, the container's space and the purse
  const space = container ? Math.floor(container.max - container.volume) : 0;
  const clamped: number[] = [];
  const maxDraws: number[] = [];
  tanks.forEach((tank, i) => {
    const others = clamped.reduce((sum, d) => sum + d, 0);
    let max = Math.min(tank.drawable, Math.max(0, space - others));
    if (locked && tank.price > 0) {
      const othersRaw = clamped.reduce(
        (sum, d, j) => sum + tanks[j].price * d,
        0,
      );
      max = Math.min(
        max,
        Math.max(0, Math.floor((data.budget - othersRaw) / tank.price + 1e-6)),
      );
    }
    maxDraws.push(max);
    clamped.push(Math.min(draws[i] || 0, max));
  });
  const totalDraw = clamped.reduce((sum, d) => sum + d, 0);
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
    <Window width={680} height={660} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>
            {starsIfIlliterate('Potion Seller', canRead)}
          </div>
          <div style={rulerStyle} />
          <div style={{ ...fieldRowStyle, alignItems: 'center' }}>
            <div
              style={{
                flex: '0 0 auto',
                fontFamily: SERIF,
                color: SEAL_AMBER,
                marginRight: '12px',
              }}
            >
              {starsIfIlliterate(
                locked ? 'Stored Mammon' : 'Stored Profits',
                canRead,
              )}
            </div>
            <div style={{ ...fieldValueStyle, fontWeight: 'bold' }}>
              {locked ? data.budget : data.profits}m
            </div>
            <button
              type="button"
              style={inkButtonStyle({
                disabled: (locked ? data.budget : data.profits) <= 0,
              })}
              disabled={(locked ? data.budget : data.profits) <= 0}
              onClick={() => act(locked ? 'change' : 'withdraw_profits')}
            >
              {starsIfIlliterate(locked ? 'Change' : 'Withdraw', canRead)}
            </button>
          </div>
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
                onDraw={(amount) => setDraw(i, amount)}
                act={act}
              />
            ))}
            <VesselColumn
              container={container}
              previewColor={previewColor}
              totalDraw={totalDraw}
              owner={owner}
              canRead={canRead}
              bottles={data.bottles}
              maxBottles={data.max_bottles}
              bottlePrice={data.bottle_price}
              budget={data.budget}
              act={act}
            />
          </div>
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'flex-end',
              gap: '10px',
              marginTop: '16px',
            }}
          >
            <span style={{ fontSize: FONT_LEAD }}>
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
              style={inkButtonStyle({ disabled: !totalDraw })}
              disabled={!totalDraw}
              onClick={() => {
                act('pour', { draws: clamped });
                setDraws(tanks.map(() => 0));
              }}
            >
              {starsIfIlliterate('Pour', canRead)}
            </button>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
