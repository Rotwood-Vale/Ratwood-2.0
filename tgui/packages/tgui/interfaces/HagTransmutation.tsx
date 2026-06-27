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

type VictimBoon = {
  id: string;
  victim_name: string;
  name: string;
  points: number;
  selected: boolean;
  transmutable: boolean;
};

type Victim = {
  name: string;
  boons: VictimBoon[];
};

type Data = {
  followers?: Follower[];
  curses?: Curse[];
  victims?: Victim[];
  curse_options?: Curse[];
  hag_tier: number;
  selected_follower?: string | null;
  selected_curse?: string | null;
  selected_curse_path?: string | null;
  total_points?: number;
};

export const HagTransmutation = () => {
  const { act, data } = useBackend<Data>();
  const followers = data.followers || [];
  const curses = data.curses || data.curse_options || [];
  const victims = data.victims || [];
  const hag_tier = data.hag_tier || 1;
  const selected_follower = data.selected_follower || null;
  const selected_curse = data.selected_curse || data.selected_curse_path || null;
  const summary_power = data.total_points || 0;

  const selectedFollowerName = followers.find(f => f.key === selected_follower)?.name || "None";
  const selectedCurseName = curses.find(c => c.path === selected_curse)?.name || "None";
  const hasVictimMode = victims.length > 0;

  return (
    <Window width={500} height={600} title="Rite of Transmutation">
      <Window.Content scrollable>
        {hasVictimMode ? (
          <Section title="Bound Souls & Boons">
            <Stack vertical>
              {victims.map(victim => (
                <Section key={victim.name} title={victim.name}>
                  <Stack vertical>
                    {victim.boons.length > 0 ? (
                      victim.boons.map(boon => (
                        <Button
                          key={`${victim.name}:${boon.id}`}
                          fluid
                          disabled={!boon.transmutable}
                          selected={boon.selected}
                          onClick={() => act('toggle_boon', { id: boon.id, victim_name: victim.name })}
                        >
                          {boon.name} (Boon strength: {boon.points})
                        </Button>
                      ))
                    ) : (
                      <div>No boons to transmute.</div>
                    )}
                  </Stack>
                </Section>
              ))}
            </Stack>
          </Section>
        ) : (
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
        )}

        <Section title={`Available Curses (Tier ${hag_tier})`}>
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
                  {curse.name} (Curse strength: {curse.cost}, Tier {curse.min_tier})
                </Button>
              ))
            ) : (
              <div>No curses available at this tier.</div>
            )}
          </Stack>
        </Section>

        <Section title="Selected">
          <LabeledList>
            {!hasVictimMode && (
              <LabeledList.Item label="Follower">
                {selectedFollowerName}
              </LabeledList.Item>
            )}
            <LabeledList.Item label="Curse">
              {selectedCurseName}
            </LabeledList.Item>
            {hasVictimMode && (
              <LabeledList.Item label="Summary Power">
                  {summary_power}
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>

        <Section>
          <Button
            fluid
            color="bad"
            disabled={hasVictimMode ? !selected_curse : (!selected_follower || !selected_curse)}
            onClick={() => act(hasVictimMode ? 'commit_transmutation' : 'commit_transmute')}
          >
            Transmute
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
