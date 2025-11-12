/* eslint-disable unused-imports/no-unused-imports */
// Disabled unused-vars rule reference removed (rule not present in config)
import {
  Button,
  LabeledList,
  Section,
  TimeDisplay,
  Box,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

// Use simple maps instead of enums to avoid parser issues
type Priority = 'null' | 'low' | 'medium' | 'high';

const PrefToColor: Record<Priority, string> = {
  null: 'red',
  low: 'orange',
  medium: 'green',
  high: 'red',
};

const PrefToText: Record<Priority, string> = {
  null: 'NEVER',
  low: '+',
  medium: '++',
  high: '+++',
};

interface Clan {
  clanName: string;
  description: string;
  type: string;
  priority: Priority;
  icon: string;
}

interface Data {
  clans: Clan[];
  timeLeft: number;
}

export const VampireVote = (props: any, context: any) => {
  const { data, act } = useBackend<Data>();

  return (
    <Window width={690} height={590}>
      <Window.Content>
        <Section
          fill
          scrollable
          title={'Clan vote'}
          buttons={<TimeDisplay value={data.timeLeft} />}
        >
          <LabeledList>
            {data.clans.map((clan, index) => (
              <LabeledList.Item
                textAlign="Left"
                key={index}
                label={
                  <Stack fill vertical justify="space-around">
                    <Stack.Item grow>
                      <b>{clan.clanName} </b>
                    </Stack.Item>
                    <Stack.Item grow>
                      <Box className={clan.icon} mr={2} inline />
                    </Stack.Item>
                  </Stack>
                }
                buttons={
                  <Button
                    fluid
                    minWidth="6em"
                    maxWidth="6em"
                    textAlign="Center"
                    color={PrefToColor[clan.priority]}
                    onClick={() => {
                      act('select_priority', { selected_clan: clan.type });
                    }}
                  >
                    {PrefToText[clan.priority]}
                  </Button>
                }
              >
                {clan.description}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
