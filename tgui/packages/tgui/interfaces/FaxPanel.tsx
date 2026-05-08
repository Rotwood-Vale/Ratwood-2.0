import React, { useState } from 'react';
import {
  Box,
  Button,
  Divider,
  LabeledList,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type HermesEntry = {
  num: number;
  tag: string;
};

type Data = {
  hermes_list: HermesEntry[];
  player_list: string[];
  master_exists: boolean;
};

const STAMPS = [
  { key: 'none', label: 'None' },
  { key: 'royal', label: '✦ Royal Seal' },
  { key: 'inquisitor', label: '✠ Otavan Inquisition' },
  { key: 'merchant', label: '⚖ Guild Merchant' },
  { key: 'steward', label: '❧ Steward of Roguetown' },
  { key: 'kingsfield', label: '⚜ Kingsfield' },
  { key: 'kf_academy', label: '✦ Kingsfield Academy' },
  { key: 'kf_army', label: '⚔ Kingsfield Army' },
  { key: 'kf_tax', label: '⚖ Taxation Office' },
  { key: 'kf_council', label: '★ High Council' },
];

const RIMS = [
  { key: 'none', label: 'None' },
  { key: 'simple', label: 'Simple' },
  { key: 'ornate', label: 'Ornate (Gold)' },
  { key: 'royal', label: 'Royal (Purple)' },
  { key: 'inquisition', label: 'Inquisition (Crimson)' },
];

export const FaxPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { hermes_list, player_list, master_exists } = data;

  const [sendMode, setSendMode] = useState<'player' | 'hermes'>('player');
  const [sender, setSender] = useState('');
  const [body, setBody] = useState('');
  const [stamp, setStamp] = useState('none');
  const [rim, setRim] = useState('none');
  const [itemPath, setItemPath] = useState('');
  const [itemName, setItemName] = useState('');
  const [itemDesc, setItemDesc] = useState('');
  const [packageSize, setPackageSize] = useState(0); // 0 = auto
  const [playerRecipient, setPlayerRecipient] = useState(
    player_list?.[0] || '',
  );
  const [hermesNum, setHermesNum] = useState<number>(
    hermes_list?.[0]?.num ?? 1,
  );

  const canSend =
    (body.trim().length > 0 || stamp !== 'none' || itemPath.trim().length > 0) &&
    sender.trim().length > 0 &&
    (sendMode === 'hermes'
      ? hermes_list?.length > 0
      : master_exists && playerRecipient);

  const stampPreviewStyle: Record<string, React.CSSProperties> = {
    royal: {
      display: 'inline-block', width: '64px', height: '64px', borderRadius: '50%',
      border: '3px solid #4a1a6e', background: '#f9f3e3', lineHeight: '58px',
      fontSize: '8px', fontWeight: 'bold', color: '#4a1a6e', textAlign: 'center', letterSpacing: '1px',
    },
    inquisitor: {
      display: 'inline-block', width: '64px', height: '64px', borderRadius: '50%',
      border: '3px solid #6b0000', background: '#fff8f5', lineHeight: '58px',
      fontSize: '8px', fontWeight: 'bold', color: '#6b0000', textAlign: 'center',
    },
    merchant: {
      display: 'inline-block', width: '64px', height: '64px', borderRadius: '50%',
      border: '3px solid #8b6914', background: '#fdfbe8', lineHeight: '58px',
      fontSize: '8px', fontWeight: 'bold', color: '#8b6914', textAlign: 'center',
    },
    steward: {
      display: 'inline-block', width: '64px', height: '64px', borderRadius: '50%',
      border: '3px solid #1a3a1a', background: '#f5fdf5', lineHeight: '58px',
      fontSize: '8px', fontWeight: 'bold', color: '#1a3a1a', textAlign: 'center',
    },
    kingsfield: {
      display: 'inline-flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      width: '64px', height: '64px', borderRadius: '50%',
      border: '3px solid #1a2e4a', background: '#eef4ff',
      fontSize: '8px', fontWeight: 'bold', color: '#1a2e4a', textAlign: 'center',
    },
    kf_academy: {
      display: 'inline-flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      width: '64px', height: '64px', borderRadius: '50%',
      border: '3px double #2a0a6e', background: '#f4f0ff',
      fontSize: '7px', fontWeight: 'bold', color: '#2a0a6e', textAlign: 'center',
      boxShadow: 'inset 0 0 8px #8060d0',
    },
    kf_army: {
      display: 'inline-flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      width: '64px', height: '64px', borderRadius: '50%',
      border: '3px solid #1c1c1c', background: '#e8e8ec',
      fontSize: '7px', fontWeight: 'bold', color: '#1c1c1c', textAlign: 'center', letterSpacing: '1px',
    },
    kf_tax: {
      display: 'inline-flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      width: '64px', height: '64px', borderRadius: '50%',
      border: '2px solid #6b4400', background: '#fffae8',
      fontSize: '6px', fontWeight: 'bold', color: '#6b4400', textAlign: 'center', lineHeight: '1.5',
    },
    kf_council: {
      display: 'inline-flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      width: '78px', height: '78px', borderRadius: '50%',
      border: '4px double #8b6914', background: '#fffdf0',
      fontSize: '9px', fontWeight: 'bold', color: '#7a5500', textAlign: 'center',
      boxShadow: 'inset 0 0 12px #e0b840, 0 0 6px #c9a84c',
    },
  };

  const stampLabels: Record<string, React.ReactNode> = {
    royal: '✦ ROYAL ✦',
    inquisitor: '✠ OTAVAN ✠',
    merchant: '⚖ GUILD ⚖',
    steward: '❧ STEWARD ❧',
    kingsfield: <><span>CITY OF</span><span>KINGSFIELD</span></>,
    kf_academy: <><span>KINGSFIELD</span><span>ACADEMY</span></>,
    kf_army: <><span>KINGSFIELD</span><span>ARMY</span></>,
    kf_tax: <><span>KINGSFIELD</span><span>TAXATION</span><span>OFFICE</span></>,
    kf_council: <><span>HIGH</span><span>COUNCIL</span></>,
  };

  const rimPreviewStyle: Record<string, React.CSSProperties> = {
    simple: { border: '8px solid #2c1a0e' },
    ornate: { border: '12px double #8b6914', boxShadow: 'inset 0 0 14px #c9a84c' },
    royal: { border: '10px solid #4a1a6e', boxShadow: 'inset 0 0 16px #7a3db5' },
    inquisition: { border: '10px solid #6b0000', boxShadow: 'inset 0 0 14px #8b0000' },
  };

  return (
    <Window width={900} height={760} title="Admin Fax Panel">
      <Window.Content scrollable>
        <Stack vertical fill>
          {/* Sender & Mode */}
          <Stack.Item>
            <Section title="Sender">
              <LabeledList>
                <LabeledList.Item label="From">
                  <input
                    style={{ width: '100%', padding: '2px 4px' }}
                    placeholder="e.g. The Grand Duke, Anonymous..."
                    value={sender}
                    onChange={(e) => setSender((e.target as HTMLInputElement).value)}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>

          {/* Recipient */}
          <Stack.Item>
            <Section title="Recipient">
              <Stack>
                <Stack.Item>
                  <Button
                    selected={sendMode === 'player'}
                    onClick={() => setSendMode('player')}
                  >
                    By Player Name
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    selected={sendMode === 'hermes'}
                    onClick={() => setSendMode('hermes')}
                  >
                    By HERMES #
                  </Button>
                </Stack.Item>
              </Stack>
              <Box mt={1}>
                {sendMode === 'player' ? (
                  master_exists ? (
                    player_list?.length > 0 ? (
                      <select
                        style={{ width: '100%', padding: '2px' }}
                        value={playerRecipient}
                        onChange={(e) =>
                          setPlayerRecipient(
                            (e.target as HTMLSelectElement).value,
                          )
                        }
                      >
                        {player_list.map((name) => (
                          <option key={name} value={name}>
                            {name}
                          </option>
                        ))}
                      </select>
                    ) : (
                      <Box color="average">No players online.</Box>
                    )
                  ) : (
                    <Box color="bad">Master mailer is offline — cannot send by name.</Box>
                  )
                ) : hermes_list?.length > 0 ? (
                  <select
                    style={{ width: '100%', padding: '2px' }}
                    value={hermesNum}
                    onChange={(e) =>
                      setHermesNum(
                        Number((e.target as HTMLSelectElement).value),
                      )
                    }
                  >
                    {hermes_list.map((h) => (
                      <option key={h.num} value={h.num}>
                        #{h.num}
                        {h.tag ? ` — ${h.tag}` : ''}
                      </option>
                    ))}
                  </select>
                ) : (
                  <Box color="bad">No HERMES machines on this map.</Box>
                )}
              </Box>
            </Section>
          </Stack.Item>

          {/* Body */}
          <Stack.Item>
            <Section title="Letter Body">
              <TextArea
                height="200px"
                width="100%"
                style={{ display: 'block', boxSizing: 'border-box' }}
                value={body}
                onChange={(value: string) => setBody(value)}
                placeholder="Write your letter here. HTML is supported: &lt;b&gt;bold&lt;/b&gt;, &lt;i&gt;italic&lt;/i&gt;, &lt;br&gt;. Shift+Enter for new lines."
              />
            </Section>
          </Stack.Item>

          {/* Stamp & Rim */}
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <Section title="Wax Stamp">
                  <Stack vertical>
                    {STAMPS.map((s) => (
                      <Stack.Item key={s.key}>
                        <Button
                          fluid
                          selected={stamp === s.key}
                          onClick={() => setStamp(s.key)}
                        >
                          {s.label}
                        </Button>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section title="Letter Rim">
                  <Stack vertical>
                    {RIMS.map((r) => (
                      <Stack.Item key={r.key}>
                        <Button
                          fluid
                          selected={rim === r.key}
                          onClick={() => setRim(r.key)}
                        >
                          {r.label}
                        </Button>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          {/* Preview */}
          <Stack.Item>
            <Section title="Preview">
              {/* Outer box carries the rim border — mirrors the reading window frame */}
              <Box style={rim !== 'none' ? rimPreviewStyle[rim] : {}}>
                <Box
                  style={{
                    background: '#fdf6e3',
                    padding: '12px',
                    fontFamily: 'serif',
                    minHeight: '80px',
                  }}
                >
                  {/* Sender header */}
                  {sender && (
                    <Box
                      style={{
                        fontStyle: 'italic',
                        color: '#5a3e1b',
                        borderBottom: '1px solid #c8aa7a',
                        paddingBottom: '4px',
                        marginBottom: '6px',
                      }}
                    >
                      From: {sender}
                    </Box>
                  )}
                  {body && (
                    <Box
                      color="black"
                      style={{ fontFamily: 'serif' }}
                      dangerouslySetInnerHTML={{ __html: body.replace(/\n/g, '<br>') }}
                    />
                  )}
                  {stamp !== 'none' && (
                    <Box textAlign="center" mt={1}>
                      <span style={stampPreviewStyle[stamp]}>
                        {stampLabels[stamp]}
                      </span>
                    </Box>
                  )}
                  {!sender && !body && stamp === 'none' && (
                    <Box color="grey" italic>
                      Nothing to preview.
                    </Box>
                  )}
                </Box>
              </Box>
            </Section>
          </Stack.Item>

          {/* Parcel Item */}
          <Stack.Item>
            <Section title="Parcel Item (Optional)">
              <LabeledList>
                <LabeledList.Item label="Item Path">
                  <input
                    style={{ width: '100%', padding: '2px 4px', fontFamily: 'monospace' }}
                    placeholder="e.g. /obj/item/coin/gold"
                    value={itemPath}
                    onChange={(e) => setItemPath((e.target as HTMLInputElement).value)}
                  />
                </LabeledList.Item>
                {itemPath.trim() && (
                  <>
                    <LabeledList.Item label="Item Name">
                      <input
                        style={{ width: '100%', padding: '2px 4px' }}
                        placeholder="Override item name (blank = keep default)"
                        value={itemName}
                        onChange={(e) => setItemName((e.target as HTMLInputElement).value)}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Item Desc">
                      <input
                        style={{ width: '100%', padding: '2px 4px' }}
                        placeholder="Override item description (blank = keep default)"
                        value={itemDesc}
                        onChange={(e) => setItemDesc((e.target as HTMLInputElement).value)}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Package Size">
                      <select
                        style={{ padding: '2px' }}
                        value={packageSize}
                        onChange={(e) => setPackageSize(Number((e.target as HTMLSelectElement).value))}
                      >
                        <option value={0}>Auto (from item)</option>
                        <option value={1}>1 — Tiny</option>
                        <option value={2}>2 — Small</option>
                        <option value={3}>3 — Normal</option>
                        <option value={4}>4 — Bulky</option>
                        <option value={5}>5 — Huge</option>
                        <option value={6}>6 — Gigantic</option>
                      </select>
                    </LabeledList.Item>
                    <LabeledList.Item label="">
                      <Box color="average">
                        The letter (if any) will be attached as a readable note inside the package.
                      </Box>
                    </LabeledList.Item>
                  </>
                )}
              </LabeledList>
            </Section>
          </Stack.Item>

          <Divider />

          {/* Send */}
          <Stack.Item textAlign="right">
            <Button
              color="good"
              disabled={!canSend}
              onClick={() =>
                act('send', {
                  sender,
                  body,
                  stamp,
                  rim,
                  send_mode: sendMode,
                  recipient: playerRecipient,
                  hermes_num: hermesNum,
                  item_path: itemPath.trim(),
                  item_name: itemName.trim(),
                  item_desc: itemDesc.trim(),
                  package_size: packageSize,
                })
              }
            >
              {itemPath.trim() ? 'Send Parcel' : 'Send Letter'}
            </Button>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
