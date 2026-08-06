// ES addition: AP's VendingPanel.tsx belongs to a MeisterPanel/steward-trade ecosystem that hasn't
// been scoped for this port step. This is a minimal from-scratch "Goods" tab built from the same
// primitives AP's version would have used (TariffHeader, SearchBar, PacksGrid) - it covers exactly
// what legacy goldface.dm's category-grid + pack-list Topic() flow did: pick a category (or search
// across all of them) and buy.
import {
  FONT_BODY,
  INK,
  inkButtonStyle,
  pageStyle,
  SERIF,
} from '../common/parchment';
import { PacksGrid } from './PacksGrid';
import { SearchBar } from './SearchBar';
import { TariffHeader } from './TariffHeader';
import type { ActFn, VendingData } from './types';

export const GoodsTab = (props: { data: VendingData; act: ActFn }) => {
  const { data, act } = props;
  const inSearchMode = !!data.search_mode;
  const hasCategory = !!data.current_category;

  return (
    <div style={pageStyle}>
      <TariffHeader
        motto={data.motto}
        canRead={!!data.can_read}
        tariffRatePct={data.tariff_rate_pct}
        tariffPaid={data.tariff_paid}
        tariffEvaded={data.tariff_evaded}
        isProprietor={!!data.is_proprietor}
        dodging={!!data.dodging}
        publicMarginPct={data.public_margin_pct}
        publicMarginLabel={data.public_margin_label}
      />
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
        canRead={!!data.can_read}
        inSearchMode={inSearchMode}
        serverSearch={data.search}
        hasCategory={hasCategory}
        browseOnly={!!data.is_public && !!data.locked}
        resultCap={data.result_cap}
        totalMatches={data.total_matches}
        act={act}
      />
    </div>
  );
};
