import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

// ES port note (Step 9f): AP's Talkstatue.tsx is a tabbed surface across three rosters -
// Mercenaries, Adventurers, and Wretches (a bathhouse "wretch for hire" system). ES has no
// Adventurer or Wretch-for-hire framework under any name (see talkstatue_tgui.dm's header
// comment for the full explanation), so this component was simplified down to just the
// mercenary roster/registration view AP's MercTab rendered - no tab bar, no dead
// adventurer/wretch views to maintain against data the DM backend never sends.

type RosterEntry = {
  key: string;
  name: string;
  status: string;
  message: string;
  advjob: string;
};

type Data = {
  is_merc: BooleanLike;
  my_key: string;
  message_char_limit: number;
  merc_status_options: string[];
  mercenaries: RosterEntry[];
};

const STATUS_COLOR: Record<string, string> = {
  Available: SEAL_GREEN,
  Contracted: SEAL_AMBER,
  'Do not Disturb': SEAL_RED,
};

const RosterRow = (props: { entry: RosterEntry }) => {
  const { entry } = props;
  const color = STATUS_COLOR[entry.status] || INK_SOFT;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'baseline',
        gap: '8px',
        padding: '4px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
      }}
    >
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: FONT_BODY, color: INK }}>
          <b>{entry.name}</b>
          {!!entry.advjob && (
            <span style={{ color: INK_FAINT, fontSize: FONT_BODY }}>
              {' '}
              - {entry.advjob}
            </span>
          )}
        </div>
        {entry.message && (
          <div
            style={{
              fontSize: FONT_BODY,
              fontStyle: 'italic',
              color: INK_SOFT,
            }}
          >
            &ldquo;{entry.message}&rdquo;
          </div>
        )}
      </div>
      <span style={badgeStyle(color)}>{entry.status}</span>
    </div>
  );
};

export const Talkstatue = () => {
  const { act, data } = useBackend<Data>();
  const myEntry = data.mercenaries.find((e) => e.key === data.my_key);
  const sortedByStatus = [...data.mercenaries].sort(
    (a, b) => a.status.localeCompare(b.status) || a.name.localeCompare(b.name),
  );
  return (
    <Window width={520} height={560} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>The Talking Statue</div>
          <div style={subtitleStyle}>
            The stone speaks in your name to those who pass.
          </div>
          <div style={rulerStyle} />

          {!!data.is_merc && (
            <div
              style={{
                ...cardStyle,
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
                marginBottom: '8px',
                fontFamily: SERIF,
              }}
            >
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: FONT_BODY, color: SEAL_AMBER }}>
                  Mercenary registry
                </div>
                <div style={{ fontSize: FONT_BODY, color: INK }}>
                  Status:{' '}
                  <b
                    style={{
                      color: STATUS_COLOR[myEntry?.status || ''] || INK,
                    }}
                  >
                    {myEntry?.status || 'Not Registered'}
                  </b>
                </div>
                {myEntry?.message && (
                  <div
                    style={{
                      fontSize: FONT_BODY,
                      fontStyle: 'italic',
                      color: INK_SOFT,
                    }}
                  >
                    &ldquo;{myEntry.message}&rdquo;
                  </div>
                )}
              </div>
              <select
                value={myEntry?.status || data.merc_status_options[0]}
                onChange={(e) =>
                  act('set_merc_status', { status: e.target.value })
                }
                style={{ ...inkButtonStyle(), fontFamily: SERIF }}
              >
                {data.merc_status_options.map((s) => (
                  <option key={s} value={s}>
                    {s}
                  </option>
                ))}
              </select>
              <button
                type="button"
                style={inkButtonStyle()}
                onClick={() => act('edit_merc_message')}
              >
                Edit Message
              </button>
            </div>
          )}

          <div
            style={{
              display: 'flex',
              gap: '8px',
              marginBottom: '8px',
            }}
          >
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => act('contact_merc')}
            >
              Contact a Mercenary
            </button>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => act('broadcast_mercs')}
            >
              Broadcast to All
            </button>
          </div>

          <div style={sectionHeaderStyle}>
            Mercenary Roster ({data.mercenaries.length})
          </div>
          {data.mercenaries.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                color: INK_SOFT,
              }}
            >
              No mercenaries have registered.
            </div>
          ) : (
            sortedByStatus.map((entry) => (
              <RosterRow key={entry.key} entry={entry} />
            ))
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
