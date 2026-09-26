import { useState } from 'react';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  fieldRowStyle,
  fieldValueStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_GREEN,
  SERIF,
  sectionHeaderStyle,
  tabBarStyle,
  tabStyle,
} from './common/parchment';
import { PacksGrid } from './Goldface/PacksGrid';
import { SearchBar } from './Goldface/SearchBar';
import { TariffHeader } from './Goldface/TariffHeader';
import type { ActFn, VendingPack } from './Goldface/types';
import { starsIfIlliterate } from './Goldface/util';

type HoardEntry = {
  kind: string;
  time: string;
  text: string;
  amount: number;
  who: string;
};

type BrassfaceData = {
  motto: string;
  budget: number;
  locked: BooleanLike;
  can_read: BooleanLike;
  is_proprietor: BooleanLike;
  dodging: BooleanLike;
  tariff_rate_pct: number;
  tariff_paid: number;
  tariff_evaded: number;
  categories: string[];
  current_category: string;
  search: string;
  search_mode: BooleanLike;
  result_cap: number;
  total_matches: number;
  packs: VendingPack[];
  hoard_log: HoardEntry[];
};

const SecretsCard = (props: {
  data: BrassfaceData;
  canRead: boolean;
  act: ActFn;
}) => {
  const { data, canRead, act } = props;
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
          display: 'flex',
          justifyContent: 'center',
          gap: '6px',
          marginTop: '8px',
          flexWrap: 'wrap',
        }}
      >
        <button
          type="button"
          style={inkButtonStyle()}
          title={
            data.dodging
              ? 'Resume paying the Crown import tariff on sales'
              : 'Stop paying the Crown import tariff on sales - dodged duty is counted as tax evaded'
          }
          onClick={() => act('toggle_tax')}
        >
          {data.dodging ? 'Enable Paying Taxes' : 'Stop Paying Taxes'}
        </button>
      </div>
    </div>
  );
};

const HoardRow = (props: { entry: HoardEntry }) => {
  const { entry } = props;
  const isPayout = entry.kind === 'payout';
  const color = isPayout ? SEAL_GREEN : SEAL_AMBER;
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: '52px minmax(0, 1fr) 72px',
        columnGap: '8px',
        padding: '3px 4px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
        color: INK,
      }}
    >
      <span style={{ color: INK_FAINT }}>{entry.time}</span>
      <span
        style={{
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          whiteSpace: 'nowrap',
        }}
      >
        {isPayout
          ? entry.text
          : `${entry.text}${entry.who ? ` - consigned by ${entry.who}` : ''}`}
      </span>
      <span style={{ textAlign: 'right', color, fontWeight: 'bold' }}>
        {isPayout ? `+${entry.amount}m` : `${entry.amount}m`}
      </span>
    </div>
  );
};

const HoardTab = (props: { entries: HoardEntry[]; canRead: boolean }) => {
  const { entries, canRead } = props;
  return (
    <div style={{ marginTop: '8px' }}>
      <div style={{ ...sectionHeaderStyle, marginTop: '4px' }}>
        {starsIfIlliterate(`Hoard Ledger (${entries.length})`, canRead)}
      </div>
      {entries.length === 0 ? (
        <div style={{ ...cardStyle, textAlign: 'center', color: INK_SOFT }}>
          {starsIfIlliterate('The hoard keeps no records yet.', canRead)}
        </div>
      ) : (
        entries.map((entry, i) => <HoardRow key={i} entry={entry} />)
      )}
    </div>
  );
};

export const Brassface = () => {
  const { act, data } = useBackend<BrassfaceData>();
  const [tab, setTab] = useState<'shop' | 'hoard'>('shop');
  const canRead = !!data.can_read;
  const isProprietor = !!data.is_proprietor;
  const inSearchMode = !!data.search_mode;
  const hasCategory = !!data.current_category;

  return (
    <Window width={840} height={760} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <TariffHeader
            motto={data.motto}
            canRead={canRead}
            tariffRatePct={data.tariff_rate_pct}
            tariffPaid={data.tariff_paid}
            tariffEvaded={data.tariff_evaded}
            isProprietor={isProprietor}
            dodging={!!data.dodging}
          />
          <div style={tabBarStyle}>
            <div
              style={tabStyle(tab === 'shop')}
              onClick={() => setTab('shop')}
            >
              Shop
            </div>
            <div
              style={tabStyle(tab === 'hoard')}
              onClick={() => setTab('hoard')}
            >
              Hoard
            </div>
          </div>
          {tab === 'shop' && (
            <>
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
              <SearchBar serverSearch={data.search} act={act} />
              {!inSearchMode && (
                <div
                  style={{
                    display: 'flex',
                    flexWrap: 'wrap',
                    gap: '6px',
                    justifyContent: 'center',
                    margin: '6px 0 10px',
                  }}
                >
                  {hasCategory ? (
                    <button
                      type="button"
                      style={inkButtonStyle()}
                      onClick={() => act('changecat', { category: '' })}
                    >
                      ← All Categories
                    </button>
                  ) : (
                    data.categories.map((cat) => (
                      <button
                        key={cat}
                        type="button"
                        style={inkButtonStyle()}
                        onClick={() => act('changecat', { category: cat })}
                      >
                        {cat}
                      </button>
                    ))
                  )}
                </div>
              )}
              {hasCategory && !inSearchMode && (
                <div
                  style={{
                    textAlign: 'center',
                    fontFamily: SERIF,
                    fontSize: FONT_BODY,
                    color: INK,
                    marginBottom: '6px',
                  }}
                >
                  {data.current_category}
                </div>
              )}
              <PacksGrid
                packs={data.packs}
                budget={data.budget}
                canRead={canRead}
                inSearchMode={inSearchMode}
                serverSearch={data.search}
                hasCategory={hasCategory}
                browseOnly={false}
                resultCap={data.result_cap}
                totalMatches={data.total_matches}
                act={act}
              />
              {isProprietor && (
                <SecretsCard data={data} canRead={canRead} act={act} />
              )}
            </>
          )}
          {tab === 'hoard' && (
            <HoardTab entries={data.hoard_log || []} canRead={canRead} />
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
