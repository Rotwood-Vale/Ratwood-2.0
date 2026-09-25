import { useState } from 'react';
import { Input } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  fieldRowStyle,
  fieldValueStyle,
  FONT_BODY,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';
import { PackRow } from './Goldface/PackRow';
import type { ActFn, VendingPack } from './Goldface/types';
import { starsIfIlliterate } from './Goldface/util';

type PurityData = {
  motto: string;
  budget: number;
  locked: BooleanLike;
  can_read: BooleanLike;
  is_proprietor: BooleanLike;
  dodging: BooleanLike;
  tariff_rate_pct: number;
  tariff_paid: number;
  tariff_evaded: number;
  recent_payments: number;
  secret_budget: number;
  cut_pct: number;
  upgrade_a_unlocked: BooleanLike;
  upgrade_b_unlocked: BooleanLike;
  upgrade_a_cost: number;
  upgrade_b_cost: number;
  withdraw_tax: number;
  withdraw_net: number;
  items: VendingPack[];
};

const SecretsCard = (props: {
  data: PurityData;
  canRead: boolean;
  act: ActFn;
}) => {
  const { data, canRead, act } = props;
  const noCut = data.secret_budget < 1;
  return (
    <div style={{ ...cardStyle, marginTop: '12px' }}>
      <div
        style={{
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          color: INK_SOFT,
          textAlign: 'center',
          marginBottom: '6px',
        }}
      >
        {starsIfIlliterate('Secrets', canRead)}
      </div>
      <div
        style={{
          textAlign: 'center',
          fontFamily: SERIF,
          fontSize: FONT_BODY,
        }}
      >
        <span style={{ color: INK_SOFT }}>
          {starsIfIlliterate('Mammon Washing:', canRead)} {data.recent_payments}
        </span>
        <span style={{ color: INK_FAINT, margin: '0 6px' }}>·</span>
        <span style={{ color: SEAL_AMBER }}>
          {starsIfIlliterate('Your cut, Master!', canRead)} {data.secret_budget}
          m ({data.cut_pct}%)
        </span>
      </div>
      <div
        style={{
          textAlign: 'center',
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          marginTop: '2px',
        }}
      >
        <span style={{ color: SEAL_GREEN }}>Paid: {data.tariff_paid}m</span>
        <span style={{ color: INK_FAINT, margin: '0 6px' }}>·</span>
        <span style={{ color: SEAL_RED }}>Evaded: {data.tariff_evaded}m</span>
      </div>
      <div
        style={{
          display: 'flex',
          justifyContent: 'center',
          gap: '6px',
          marginTop: '8px',
          flexWrap: 'wrap',
        }}
      >
        <button
          type="button"
          style={inkButtonStyle({ disabled: noCut })}
          disabled={noCut}
          title={`Deposit ${data.withdraw_net}m into your account - the Crown keeps ${data.withdraw_tax}m in duty`}
          onClick={() => act('withdraw_cut', { mode: 'bank' })}
        >
          To Bank ({data.withdraw_net}m after duty)
        </button>
        <button
          type="button"
          style={inkButtonStyle({ disabled: noCut })}
          disabled={noCut}
          title={`Withdraw the full ${data.secret_budget}m as coin - no duty paid, counted as tax evaded`}
          onClick={() => act('withdraw_cut', { mode: 'direct' })}
        >
          Direct (Untaxed)
        </button>
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() => act('toggle_tax')}
        >
          {data.dodging ? 'Enable Paying Taxes' : 'Stop Paying Taxes'}
        </button>
        {!data.upgrade_a_unlocked && (
          <button
            type="button"
            style={inkButtonStyle()}
            title="Raise your laundering cut from 10% to 25%"
            onClick={() => act('unlock_cut', { level: 'a' })}
          >
            Unlock 25% Cut ({data.upgrade_a_cost})
          </button>
        )}
        {!!data.upgrade_a_unlocked && !data.upgrade_b_unlocked && (
          <button
            type="button"
            style={inkButtonStyle()}
            title="Raise your laundering cut from 25% to 50%"
            onClick={() => act('unlock_cut', { level: 'b' })}
          >
            Unlock 50% Cut ({data.upgrade_b_cost})
          </button>
        )}
      </div>
    </div>
  );
};

export const Purity = () => {
  const { act, data } = useBackend<PurityData>();
  const canRead = !!data.can_read;
  const isProprietor = !!data.is_proprietor;
  const [search, setSearch] = useState('');
  const needle = search.trim().toLowerCase();
  const shown = needle
    ? data.items.filter((p) => p.name.toLowerCase().includes(needle))
    : data.items;

  return (
    <Window width={560} height={720} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>{starsIfIlliterate(data.motto, canRead)}</div>
          <div style={subtitleStyle}>
            Crown Import Tariff: <b>{data.tariff_rate_pct}%</b>
            {isProprietor && !!data.dodging && (
              <span style={{ color: SEAL_RED, marginLeft: '8px' }}>
                <b>(TAX DODGING)</b>
              </span>
            )}
          </div>
          <div style={rulerStyle} />
          <div style={fieldRowStyle}>
            <div
              style={{
                flex: '0 0 auto',
                fontFamily: SERIF,
                color: SEAL_AMBER,
                marginRight: '12px',
              }}
            >
              {starsIfIlliterate('Mammon Loaded', canRead)}
            </div>
            <div style={{ ...fieldValueStyle, fontWeight: 'bold' }}>
              {data.budget}m
            </div>
            <button
              type="button"
              style={inkButtonStyle({ disabled: data.budget <= 0 })}
              disabled={data.budget <= 0}
              onClick={() => act('change')}
            >
              Withdraw as Coin
            </button>
          </div>
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              margin: '8px 0',
            }}
          >
            <span
              style={{
                fontFamily: SERIF,
                fontSize: FONT_BODY,
                color: INK_SOFT,
              }}
            >
              Search:
            </span>
            <Input
              value={search}
              onChange={setSearch}
              placeholder="Type to filter the stock..."
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
          </div>
          {shown.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                color: INK_SOFT,
              }}
            >
              {needle ? `Nothing matches "${search}".` : 'Nothing stocked.'}
            </div>
          ) : (
            <div
              style={{
                columnCount: 2,
                columnGap: '12px',
              }}
            >
              {shown.map((p) => (
                <div key={p.ref} style={{ breakInside: 'avoid' }}>
                  <PackRow
                    pack={p}
                    budget={data.budget}
                    canRead={canRead}
                    showCategory={false}
                    browseOnly={false}
                    act={act}
                  />
                </div>
              ))}
            </div>
          )}
          {isProprietor && (
            <SecretsCard data={data} canRead={canRead} act={act} />
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
