import { useEffect, useState } from 'react';

import { starsIfIlliterate } from '../Goldface/util';
import {
  fieldRowStyle,
  fieldValueStyle,
  inkButtonStyle,
  inkInputStyle,
  SEAL_AMBER,
  SERIF,
} from './parchment';

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
        if (e.key === 'Enter') commit();
      }}
      style={{ ...inkInputStyle, width }}
    />
  );
};

/** Labelled mammon amount with a button to pay it out. */
export const MoneyRow = (props: {
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
