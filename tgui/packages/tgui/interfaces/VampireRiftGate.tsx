import { memo, useState } from 'react';
import {
  Box,
  Button,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Amulet = {
  ref: string;
  name: string;
  area: string;
};

type Data = {
  zones: string[];
  vitaeCost: number;
  portalDuration: number;
  amulets: Amulet[];
  hasVitae: BooleanLike;
  riftZone: string | null;
  riftSecondsLeft: number;
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

const formatDuration = (seconds: number) => {
  const total = Math.max(Math.round(seconds || 0), 0);
  const minutes = Math.floor(total / 60);
  const rest = `${total % 60}`.padStart(2, '0');
  return `${minutes}:${rest}`;
};

const toTitle = (name: string) =>
  name ? name.charAt(0).toUpperCase() + name.slice(1) : '';

const ZoneList = memo(
  (props: {
    zones: string[];
    query: string;
    canOpen: boolean;
    blockedReason: string | null;
    act: ActFn;
  }) => {
    const { zones, query, canOpen, blockedReason, act } = props;
    const shown = query
      ? zones.filter((zone) => zone.toLowerCase().includes(query))
      : zones;

    if (!shown.length) {
      return <NoticeBox>No zone matches that name.</NoticeBox>;
    }

    return (
      <>
        {shown.map((zone) => (
          <Button
            key={zone}
            fluid
            icon="eye"
            disabled={!canOpen}
            tooltip={blockedReason}
            onClick={() => act('open_zone', { zone })}
          >
            {toTitle(zone)}
          </Button>
        ))}
      </>
    );
  },
);

export const VampireRiftGate = () => {
  const { act, data } = useBackend<Data>();
  const {
    zones = [],
    vitaeCost = 0,
    portalDuration = 0,
    amulets = [],
    riftZone,
    riftSecondsLeft = 0,
  } = data;
  const [search, setSearch] = useState('');
  const hasVitae = !!data.hasVitae;
  const riftOpen = !!riftZone;
  const canOpen = hasVitae && !riftOpen;

  let blockedReason: string | null = null;
  if (riftOpen) {
    blockedReason = 'A rift is already open';
  } else if (!hasVitae) {
    blockedReason = 'I lack the vitae';
  }

  return (
    <Window width={520} height={680}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Rift">
              <LabeledList>
                <LabeledList.Item label="Cost">
                  {vitaeCost} vitae
                </LabeledList.Item>
                <LabeledList.Item label="Lasts">
                  {formatDuration(portalDuration)}
                </LabeledList.Item>
                <LabeledList.Item label="Way back">
                  Gate amulet bearers, and whoever they carry on their shoulder
                </LabeledList.Item>
                <LabeledList.Item
                  label="Status"
                  color={riftOpen ? 'bad' : 'good'}
                >
                  {riftOpen
                    ? `Open to ${toTitle(riftZone || '')}, closes in ${formatDuration(riftSecondsLeft)}`
                    : 'Dormant'}
                </LabeledList.Item>
              </LabeledList>
              {riftOpen && (
                <Button
                  fluid
                  mt={1}
                  icon="times"
                  color="bad"
                  textAlign="center"
                  onClick={() => act('close_rift')}
                >
                  Close the Rift
                </Button>
              )}
              <Box mt={1} italic color="label">
                My sight enters the chosen place first, so I can pick the spot
                before the rift opens.
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <NoticeBox
              danger
              style={{ visibility: hasVitae ? 'hidden' : 'visible' }}
            >
              I lack the vitae to tear a rift.
            </NoticeBox>
          </Stack.Item>
          {amulets.length > 0 && (
            <Stack.Item>
              <Section title="Amulet Bearers">
                {amulets.map((amulet) => (
                  <Stack key={amulet.ref} align="center" mb={1}>
                    <Stack.Item grow>
                      <Box bold>{amulet.name}</Box>
                      <Box color="label">{amulet.area}</Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="eye"
                        disabled={!canOpen}
                        tooltip={
                          blockedReason || 'Open the rift near this amulet'
                        }
                        onClick={() =>
                          act('open_amulet', { amulet: amulet.ref })
                        }
                      >
                        Open Near
                      </Button>
                    </Stack.Item>
                  </Stack>
                ))}
              </Section>
            </Stack.Item>
          )}
          <Stack.Item grow>
            <Section
              title="Zones"
              fill
              scrollable
              buttons={
                <Input
                  placeholder="Search zones..."
                  value={search}
                  onChange={setSearch}
                />
              }
            >
              <ZoneList
                zones={zones}
                query={search.trim().toLowerCase()}
                canOpen={canOpen}
                blockedReason={blockedReason}
                act={act}
              />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
