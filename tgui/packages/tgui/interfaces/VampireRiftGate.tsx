import {
  Box,
  Button,
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
  uses: number;
};

type Data = {
  amulets: Amulet[];
  vitaeCost: number;
  placementRange: number;
  hasVitae: BooleanLike;
  sendingActive: BooleanLike;
};

export const VampireRiftGate = () => {
  const { act, data } = useBackend<Data>();
  const { amulets = [], vitaeCost = 0, placementRange = 0 } = data;
  const hasVitae = !!data.hasVitae;
  const sendingActive = !!data.sendingActive;

  return (
    <Window width={480} height={480}>
      <Window.Content scrollable>
        <Section title="Rift">
          <LabeledList>
            <LabeledList.Item label="Cost">{vitaeCost} vitae</LabeledList.Item>
            <LabeledList.Item label="Placement">
              Up to {placementRange} paces from the anchor
            </LabeledList.Item>
            <LabeledList.Item
              label="Status"
              color={sendingActive ? 'bad' : 'good'}
            >
              {sendingActive ? 'A sending rift is open' : 'Dormant'}
            </LabeledList.Item>
          </LabeledList>
          <Box mt={1} italic color="label">
            My sight passes through the chosen anchor first, so I can pick the
            spot before the rift opens.
          </Box>
        </Section>
        <NoticeBox
          danger
          style={{ visibility: hasVitae ? 'hidden' : 'visible' }}
        >
          I lack the vitae to tear a rift.
        </NoticeBox>
        <Section title="Anchors">
          {amulets.length ? (
            amulets.map((amulet) => (
              <Stack key={amulet.ref} align="center" mb={1}>
                <Stack.Item grow>
                  <Box bold>{amulet.name}</Box>
                  <Box color="label">
                    {amulet.area}, charges: {amulet.uses}
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="reply"
                    disabled={!hasVitae}
                    tooltip="Gaze through the amulet and choose where a rift back here opens"
                    onClick={() => act('open_return', { amulet: amulet.ref })}
                  >
                    Return
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="share"
                    disabled={!hasVitae || sendingActive}
                    tooltip="Gaze through the amulet and choose where the rift from here leads"
                    onClick={() => act('open_sending', { amulet: amulet.ref })}
                  >
                    Send
                  </Button>
                </Stack.Item>
              </Stack>
            ))
          ) : (
            <NoticeBox>No gate amulets are bound to the rift.</NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
