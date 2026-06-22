import React from 'react';
import {
  Button,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Follower = {
  name: string;
  key: string;
};

type Curse = {
  name: string;
  path: string;
  cost: number;
  min_tier: number;
};

type Data = {
  followers: Follower[];
  curses: Curse[];
  hag_tier: number;
  selected_follower: string | null;
  selected_curse: string | null;
};

export const HagTransmutation = (props) => {
  const { act, data } = useBackend<Data>();
  const { followers, curses, hag_tier, selected_follower, selected_curse } = data;

  const selectedFollowerName = followers.find(f => f.key === selected_follower)?.name || "None";
  const selectedCurseName = curses.find(c => c.path === selected_curse)?.name || "None";

  return (
    <Window width={500} height={600} title="Rite of Transmutation">
      <Window.Content scrollable>
        <Section title="Available Pacts">
          <Stack vertical>
            {followers.length > 0 ? (
              followers.map(follower => (
                <Button
                  key={follower.key}
                  fluid
                  selected={selected_follower === follower.key}
                  onClick={() => act('select_follower', { key: follower.key })}
                >
                  {follower.name}
                </Button>
              ))
            ) : (
              <div>No pacts to corrupt.</div>
            )}
          </Stack>
        </Section>

        <Section title="Available Curses (Tier {hag_tier})">
          <Stack vertical>
            {curses.length > 0 ? (
              curses.map(curse => (
                <Button
                  key={curse.path}
                  fluid
                  color={curse.min_tier > hag_tier ? 'bad' : 'neutral'}
                  disabled={curse.min_tier > hag_tier}
                  selected={selected_curse === curse.path}
                  onClick={() => act('select_curse', { path: curse.path })}
                >
                  {curse.name} (Cost: {curse.cost} pts, Tier {curse.min_tier})
                </Button>
              ))
            ) : (
              <div>No curses available at this tier.</div>
            )}
          </Stack>
        </Section>

        <Section title="Selected">
          <LabeledList>
            <LabeledList.Item label="Follower">
              {selectedFollowerName}
            </LabeledList.Item>
            <LabeledList.Item label="Curse">
              {selectedCurseName}
            </LabeledList.Item>
          </LabeledList>
        </Section>

        <Section>
          <Button
            fluid
            color="bad"
            disabled={!selected_follower || !selected_curse}
            onClick={() => act('commit_transmute')}
          >
            Transmute
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
