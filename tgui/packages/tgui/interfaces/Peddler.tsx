import { useEffect, useState } from 'react';
import { Input } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
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
  PriceTag,
  rulerStyle,
  SEAL_AMBER,
  SERIF,
  titleStyle,
} from './common/parchment';
import { starsIfIlliterate } from './Goldface/util';

type ProductGroup = {
  key: string;
  name: string;
  price: number;
  count: number;
  desc: string;
  icon: string;
};

type PeddlerData = {
  locked: BooleanLike;
  can_read: BooleanLike;
  budget: number;
  profits: number;
  stored: number;
  capacity: number;
  groups: ProductGroup[];
};

type ActFn = (action: string, payload?: Record<string, unknown>) => void;

const ProductIcon = (props: { icon: string }) => (
  <img
    src={`data:image/png;base64,${props.icon}`}
    style={{
      width: '32px',
      height: '32px',
      flexShrink: 0,
      imageRendering: 'pixelated',
    }}
  />
);

const CountTag = (props: { count: number }) => (
  <span style={{ color: INK_SOFT, fontSize: FONT_LEAD, flexShrink: 0 }}>
    x{props.count}
  </span>
);

/** Text input that keeps a local draft and only sends it on Enter or blur. */
const CommitField = (props: {
  value: string;
  numeric?: boolean;
  width: string;
  onCommit: (value: string) => void;
}) => {
  const { value, numeric, width, onCommit } = props;
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
      step={numeric ? 1 : undefined}
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

const ShopperRow = (props: {
  group: ProductGroup;
  budget: number;
  canRead: boolean;
  act: ActFn;
}) => {
  const { group, budget, canRead, act } = props;
  const [amount, setAmount] = useState(1);
  const qty = Math.min(Math.max(amount, 1), group.count);
  const total = group.price * qty;
  const cantAfford = total > budget;

  return (
    <div style={denseRowStyle}>
      <ProductIcon icon={group.icon} />
      <div
        style={{ ...ellipsisCellStyle, fontSize: FONT_TITLE, color: INK }}
        title={group.desc}
      >
        {starsIfIlliterate(group.name, canRead)}
      </div>
      <CountTag count={group.count} />
      <PriceTag
        price={group.price}
        cantAfford={group.price > budget}
        title={qty > 1 ? `${qty} for ${total}m` : `${group.price}m`}
      />
      {group.count > 1 && (
        <input
          type="number"
          min={1}
          max={group.count}
          value={amount}
          onChange={(e) => setAmount(parseInt(e.target.value, 10) || 1)}
          style={{ ...inkInputStyle, width: '48px' }}
        />
      )}
      <button
        type="button"
        style={compactButtonStyle({ disabled: cantAfford })}
        disabled={cantAfford}
        onClick={() => act('buy', { key: group.key, amount: qty })}
        title={`Buy ${qty} for ${total}m`}
      >
        {starsIfIlliterate('Buy', canRead)}
      </button>
    </div>
  );
};

const OwnerRow = (props: {
  group: ProductGroup;
  canRead: boolean;
  act: ActFn;
}) => {
  const { group, canRead, act } = props;

  return (
    <div style={denseRowStyle}>
      <ProductIcon icon={group.icon} />
      <div style={{ flex: 1, minWidth: 0 }} title={group.desc}>
        {canRead ? (
          <CommitField
            value={group.name}
            width="100%"
            onCommit={(name) => act('set_name', { key: group.key, name })}
          />
        ) : (
          <div style={{ ...ellipsisCellStyle, fontSize: FONT_TITLE }}>
            {starsIfIlliterate(group.name, canRead)}
          </div>
        )}
      </div>
      <CountTag count={group.count} />
      <CommitField
        value={String(group.price)}
        numeric
        width="64px"
        onCommit={(price) => act('set_price', { key: group.key, price })}
      />
      <span style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>m</span>
      <button
        type="button"
        style={compactButtonStyle()}
        onClick={() => act('take', { key: group.key })}
      >
        {starsIfIlliterate('Take', canRead)}
      </button>
      {group.count > 1 && (
        <button
          type="button"
          style={compactButtonStyle()}
          onClick={() => act('take', { key: group.key, all: true })}
        >
          {starsIfIlliterate('Take all', canRead)}
        </button>
      )}
    </div>
  );
};

const MoneyRow = (props: {
  label: string;
  amount: number;
  button: string;
  canRead: boolean;
  onClick: () => void;
}) => {
  const { label, amount, button, canRead, onClick } = props;
  return (
    <div style={{ ...fieldRowStyle, alignItems: 'center' }}>
      <div
        style={{
          flex: '0 0 auto',
          fontFamily: SERIF,
          color: SEAL_AMBER,
          marginRight: '12px',
        }}
      >
        {starsIfIlliterate(label, canRead)}
      </div>
      <div style={{ ...fieldValueStyle, fontWeight: 'bold' }}>{amount}m</div>
      <button
        type="button"
        style={inkButtonStyle({ disabled: amount <= 0 })}
        disabled={amount <= 0}
        onClick={onClick}
      >
        {starsIfIlliterate(button, canRead)}
      </button>
    </div>
  );
};

export const Peddler = () => {
  const { act, data } = useBackend<PeddlerData>();
  const [search, setSearch] = useState('');
  const locked = !!data.locked;
  const canRead = !!data.can_read;
  const needle = search.trim().toLowerCase();
  const groups = needle
    ? data.groups.filter((g) => g.name.toLowerCase().includes(needle))
    : data.groups;

  return (
    <Window width={560} height={620} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>
            {starsIfIlliterate('The Peddler, Third Iteration', canRead)}
          </div>
          <div style={rulerStyle} />
          {locked ? (
            <MoneyRow
              label="Stored Mammon"
              amount={data.budget}
              button="Change"
              canRead={canRead}
              onClick={() => act('change')}
            />
          ) : (
            <MoneyRow
              label="Stored Profits"
              amount={data.profits}
              button="Withdraw"
              canRead={canRead}
              onClick={() => act('withdraw_profits')}
            />
          )}
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              margin: '8px 0',
            }}
          >
            <Input
              value={search}
              onChange={setSearch}
              placeholder="Search wares..."
              width="240px"
            />
            {!!search && (
              <button
                type="button"
                style={inkButtonStyle()}
                onClick={() => setSearch('')}
              >
                Clear
              </button>
            )}
            <div
              style={{
                marginLeft: 'auto',
                color: INK_FAINT,
                fontSize: FONT_BODY,
              }}
            >
              {data.stored}/{data.capacity}
            </div>
          </div>
          {groups.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                fontStyle: 'italic',
                color: INK_SOFT,
              }}
            >
              {needle
                ? `Nothing matches "${search}".`
                : 'Its stomach is empty.'}
            </div>
          ) : (
            groups.map((group) =>
              locked ? (
                <ShopperRow
                  key={group.key}
                  group={group}
                  budget={data.budget}
                  canRead={canRead}
                  act={act}
                />
              ) : (
                <OwnerRow
                  key={group.key}
                  group={group}
                  canRead={canRead}
                  act={act}
                />
              ),
            )
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
