import { useEffect, useState } from 'react';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../../backend';
import { starsIfIlliterate } from '../Goldface/util';
import {
  fieldRowStyle,
  fieldValueStyle,
  inkButtonStyle,
  inkInputStyle,
  rulerStyle,
  SEAL_AMBER,
  SERIF,
  titleStyle,
} from './parchment';

/** Data every shop machine sends. */
export type ShopData = {
  locked: BooleanLike;
  can_read: BooleanLike;
  budget: number;
  profits: number;
  is_cart: BooleanLike;
  wheels_secured: BooleanLike;
};

/** Whole number >= 0, or null if the draft isn't one. */
export const parseWholeNumber = (draft: string) => {
  const n = Number(draft);
  return draft.trim() !== '' && Number.isInteger(n) && n >= 0
    ? String(n)
    : null;
};

/**
 * Text input that keeps a local draft and only sends it on Enter or blur.
 * `parse` turns the draft into the value to send, or null to reject it;
 * a rejected or unchanged draft snaps back to the current value.
 */
export const CommitField = (props: {
  value: string;
  numeric?: boolean;
  step?: number;
  width: string;
  parse?: (draft: string) => string | null;
  onCommit: (value: string) => void;
}) => {
  const { value, numeric, step, width, parse, onCommit } = props;
  const [draft, setDraft] = useState(value);

  useEffect(() => {
    setDraft(value);
  }, [value]);

  const commit = () => {
    const parsed = parse ? parse(draft) : draft;
    if (parsed === null || parsed === value) {
      setDraft(value);
      return;
    }
    onCommit(parsed);
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
        // blurring commits, so Enter doesn't send the value twice
        if (e.key === 'Enter') e.currentTarget.blur();
      }}
      style={{ ...inkInputStyle, width }}
    />
  );
};

/** Labelled mammon amount with a button to pay it out. */
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

/** Owner toggle for a shop cart's wheels. */
const WheelsButton = (props: {
  secured: boolean;
  canRead: boolean;
  onClick: () => void;
}) => {
  const { secured, canRead, onClick } = props;
  return (
    <button
      type="button"
      style={inkButtonStyle()}
      onClick={onClick}
      title={starsIfIlliterate(
        secured
          ? 'The cart can be pulled once its wheels are free'
          : 'Secured wheels keep the cart from being moved',
        canRead,
      )}
    >
      {starsIfIlliterate(secured ? 'Free wheels' : 'Secure wheels', canRead)}
    </button>
  );
};

/**
 * Shop title, then the shopper's coin or the owner's profits,
 * with the wheels toggle beside the profits on carts.
 */
export const ShopHeader = (props: { title: string }) => {
  const { act, data } = useBackend<ShopData>();
  const canRead = !!data.can_read;

  return (
    <>
      <div style={titleStyle}>{starsIfIlliterate(props.title, canRead)}</div>
      <div style={rulerStyle} />
      {data.locked ? (
        <MoneyRow
          label="Stored Mammon"
          amount={data.budget}
          button="Change"
          canRead={canRead}
          onClick={() => act('change')}
        />
      ) : (
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <div style={{ flex: 1, minWidth: 0 }}>
            <MoneyRow
              label="Stored Profits"
              amount={data.profits}
              button="Withdraw"
              canRead={canRead}
              onClick={() => act('withdraw_profits')}
            />
          </div>
          {!!data.is_cart && (
            <WheelsButton
              secured={!!data.wheels_secured}
              canRead={canRead}
              onClick={() => act('toggle_wheels')}
            />
          )}
        </div>
      )}
    </>
  );
};
