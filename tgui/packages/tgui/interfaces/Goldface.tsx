import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { inkButtonStyle, tabBarStyle, tabStyle } from './common/parchment';
import { CulturalStockTab } from './Goldface/CulturalStock/CulturalStockTab';
import { GoodsTab } from './Goldface/GoodsTab';
import { HarborTab } from './Goldface/Harbor/HarborTab';
import { MammonRow } from './Goldface/MammonRow';
import { MarketTab } from './Goldface/Market/MarketTab';
import type { VendingData } from './Goldface/types';

// Ratwood deviation: AP's Goldface.tsx also has 'management' and 'ledger' tabs (ManagementTab/LedgerTab),
// which belong to a MeisterPanel/steward-trade ecosystem not yet scoped for this port step. They're
// omitted here rather than stubbed - the backend (_goldface.dm) still computes their data
// (build_favor_data/build_ledger_data) so a later port step can add the tabs without backend changes.
type GoldfaceTab = 'goods' | 'cultural' | 'harbor' | 'market';

export const Goldface = () => {
  const { act, data } = useBackend<VendingData>();
  const [tab, setTab] = useState<GoldfaceTab>('goods');
  const isCommand = !!data.is_command_center;
  const canRead = !!data.can_read;
  const isPublic = !!data.is_public;
  const isProprietor = !!data.is_proprietor;
  const isAgent = !!data.is_agent;

  const helpButton = (
    <button
      type="button"
      title="Open the economy guidebook"
      style={inkButtonStyle({})}
      onClick={() => act('help')}
    >
      ?
    </button>
  );

  const mammonBar = (
    <div style={{ padding: '6px 28px 0 28px' }}>
      <MammonRow
        budget={data.budget}
        canRead={canRead}
        isProprietor={isProprietor}
        isPublic={isPublic}
        act={act}
      />
    </div>
  );

  if (!isCommand) {
    return (
      <Window width={880} height={800} theme="parchment">
        <Window.Content scrollable>
          <div
            style={{
              display: 'flex',
              justifyContent: 'flex-end',
              padding: '6px 28px 0 28px',
            }}
          >
            {helpButton}
          </div>
          {mammonBar}
          <GoodsTab data={data} act={act} />
        </Window.Content>
      </Window>
    );
  }

  const canSeeHarborTabs = isProprietor || isAgent;
  const culturalStock = data.harbor?.cultural_stock ?? [];
  let activeTab = tab;
  if ((activeTab === 'harbor' || activeTab === 'cultural') && !canSeeHarborTabs) {
    activeTab = 'goods';
  } else if (activeTab === 'market' && !isProprietor) {
    activeTab = 'goods';
  }

  return (
    <Window width={880} height={800} theme="parchment">
      <Window.Content scrollable>
        <div style={{ position: 'relative' }}>
        <div style={tabBarStyle}>
          <div
            style={tabStyle(activeTab === 'goods')}
            onClick={() => setTab('goods')}
          >
            Goods
          </div>
          {canSeeHarborTabs && (
            <div
              style={tabStyle(activeTab === 'cultural')}
              onClick={() => setTab('cultural')}
            >
              Cultural Stock
            </div>
          )}
          {canSeeHarborTabs && (
            <div
              style={tabStyle(activeTab === 'harbor')}
              onClick={() => setTab('harbor')}
            >
              Harbor
            </div>
          )}
          {isProprietor && (
            <div
              style={tabStyle(activeTab === 'market')}
              onClick={() => setTab('market')}
            >
              Market
            </div>
          )}
        </div>
        <div style={{ position: 'absolute', right: 0, top: '10px' }}>
          {helpButton}
        </div>
        </div>
        {mammonBar}
        {activeTab === 'goods' && <GoodsTab data={data} act={act} />}
        {activeTab === 'cultural' && canSeeHarborTabs && (
          <CulturalStockTab
            stock={culturalStock}
            catalogs={data.harbor?.catalogs}
            kinship={data.harbor?.kinship}
            budget={data.budget}
            isAgent={isAgent}
            act={act}
          />
        )}
        {activeTab === 'harbor' && canSeeHarborTabs && (
          <HarborTab
            harbor={data.harbor}
            budget={data.budget}
            isAgent={isAgent}
            act={act}
          />
        )}
        {activeTab === 'market' && isProprietor && (
          <MarketTab harbor={data.harbor} />
        )}
      </Window.Content>
    </Window>
  );
};
