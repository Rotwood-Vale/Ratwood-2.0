import type { CSSProperties } from 'react';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  bannerStyle,
  cardStyle,
  FONT_SMALL,
  FONT_TITLE,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  SEAL_RED,
  sectionHeaderStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type Amulet = {
  ref: string;
  name: string;
  area: string;
  uses: number;
};

type Data = {
  amulets: Amulet[];
  vitaeCost: number;
  hasVitae: BooleanLike;
  sendingActive: BooleanLike;
};

const hintStyle: CSSProperties = {
  color: INK_SOFT,
  fontStyle: 'italic',
  fontSize: FONT_SMALL,
};

export const VampireRiftGate = () => {
  const { act, data } = useBackend<Data>();
  const { amulets = [], vitaeCost = 0 } = data;
  const hasVitae = !!data.hasVitae;
  const sendingActive = !!data.sendingActive;

  return (
    <Window width={480} height={480} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>Rift Gate</div>
          <div style={subtitleStyle}>Each rift costs {vitaeCost} vitae.</div>
          {sendingActive ? (
            <div style={bannerStyle(SEAL_RED)}>
              A sending rift is already open.
            </div>
          ) : (
            <div style={bannerStyle(INK_SOFT, true)}>The gate is dormant.</div>
          )}
          <div
            style={{
              ...hintStyle,
              textAlign: 'center',
              visibility: hasVitae ? 'hidden' : 'visible',
            }}
          >
            I lack the vitae to tear a rift.
          </div>

          <div style={sectionHeaderStyle}>Anchors</div>
          {amulets.length ? (
            amulets.map((amulet) => (
              <div
                key={amulet.ref}
                style={{
                  ...cardStyle,
                  display: 'flex',
                  alignItems: 'center',
                  gap: '10px',
                }}
              >
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontWeight: 'bold', fontSize: FONT_TITLE }}>
                    {amulet.name}
                  </div>
                  <div style={{ color: INK_SOFT }}>{amulet.area}</div>
                  <div style={hintStyle}>Charges: {amulet.uses}</div>
                </div>
                <div
                  style={{
                    display: 'flex',
                    flexDirection: 'column',
                    gap: '4px',
                  }}
                >
                  <button
                    type="button"
                    disabled={!hasVitae}
                    title="Tear a rift beside the amulet that leads back here"
                    style={inkButtonStyle({
                      color: SEAL_RED,
                      disabled: !hasVitae,
                    })}
                    onClick={() => act('open_return', { amulet: amulet.ref })}
                  >
                    Return
                  </button>
                  <button
                    type="button"
                    disabled={!hasVitae || sendingActive}
                    title="Open rifts here that lead to the amulet"
                    style={inkButtonStyle({
                      color: SEAL_RED,
                      disabled: !hasVitae || sendingActive,
                    })}
                    onClick={() => act('open_sending', { amulet: amulet.ref })}
                  >
                    Send
                  </button>
                </div>
              </div>
            ))
          ) : (
            <div
              style={{
                ...cardStyle,
                color: INK_FAINT,
                fontStyle: 'italic',
                textAlign: 'center',
              }}
            >
              No gate amulets are bound to the rift.
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
