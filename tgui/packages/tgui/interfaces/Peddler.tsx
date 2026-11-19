import { useState } from 'react';
import { Input } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
  FONT_BODY,
  FONT_LEAD,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  inkInputStyle,
  pageStyle,
  PriceTag,
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

type ProductGroup = {
  key: string;
  name: string;
  price: number;
  count: number;
  desc: string;
  // null while the machine is still drawing it
  icon: string | null;
};

type PeddlerData = ShopData & {
  stored: number;
  capacity: number;
  groups: ProductGroup[];
};

const iconStyle = {
  width: '32px',
  height: '32px',
  flexShrink: 0,
} as const;

const ProductIcon = (props: { icon: string | null }) =>
  props.icon ? (
    <img
      src={`data:image/png;base64,${props.icon}`}
      style={{ ...iconStyle, imageRendering: 'pixelated' }}
    />
  ) : (
    <div style={iconStyle} />
  );

const CountTag = (props: { count: number }) => (
  <span style={{ color: INK_SOFT, fontSize: FONT_LEAD, flexShrink: 0 }}>
    x{props.count}
  </span>
);

const ShopperRow = (props: {
  group: ProductGroup;
  budget: number;
  canRead: boolean;
  act: ActFn;
}) => {
  const { group, budget, canRead, act } = props;
  // kept as typed, so the box can be cleared while entering a new amount
  const [amount, setAmount] = useState('1');
  const qty = Math.min(Math.max(parseInt(amount, 10) || 1, 1), group.count);
  const total = group.price * qty;
  const cantAfford = total > budget;

  return (
    <div style={denseRowStyle}>
      <ProductIcon icon={group.icon} />
      <div
        style={{ ...ellipsisCellStyle, fontSize: FONT_TITLE, color: INK }}
        title={starsIfIlliterate(group.desc || '', canRead)}
      >
        {starsIfIlliterate(group.name, canRead)}
      </div>
      <CountTag count={group.count} />
      <PriceTag
        price={group.price}
        cantAfford={cantAfford}
        title={qty > 1 ? `${qty} for ${total}m` : `${group.price}m`}
      />
      {group.count > 1 && (
        <input
          type="number"
          min={1}
          max={group.count}
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
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
      <div
        style={{ flex: 1, minWidth: 0 }}
        title={starsIfIlliterate(group.desc || '', canRead)}
      >
        {canRead ? (
          <CommitField
            value={group.name}
            width="100%"
            parse={(draft) => draft.trim() || null}
            onCommit={(name) => act('set_name', { key: group.key, name })}
          />
        ) : (
          <div style={{ ...ellipsisCellStyle, fontSize: FONT_TITLE }}>
            {starsIfIlliterate(group.name, canRead)}
          </div>
        )}
      </div>
      <CountTag count={group.count} />
      <PriceField
        value={group.price}
        unit="m"
        canRead={canRead}
        width="64px"
        parse={parseWholeNumber}
        onCommit={(price) => act('set_price', { key: group.key, price })}
      />
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

export const Peddler = () => {
  const { act, data } = useBackend<PeddlerData>();
  const [search, setSearch] = useState('');
  const locked = !!data.locked;
  const canRead = !!data.can_read;
  // illiterate users get no search, since they can't read what it matches
  const needle = canRead ? search.trim().toLowerCase() : '';
  const groups = needle
    ? data.groups.filter((g) => g.name.toLowerCase().includes(needle))
    : data.groups;

  return (
    <Window width={560} height={620} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <ShopHeader title="The Peddler, Third Iteration" />
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              margin: '8px 0',
            }}
          >
            {canRead && (
              <Input
                value={search}
                onChange={setSearch}
                placeholder="Search wares..."
                width="240px"
              />
            )}
            {!!needle && (
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
                : starsIfIlliterate('Its stomach is empty.', canRead)}
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
