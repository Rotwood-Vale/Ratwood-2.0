import {
  Button,
  LabeledList,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Setting = {
  name: string;
  value: number;
};

type Group = {
  key: string;
  settings: Setting[];
};

type Data = {
  groups: Group[];
  strength: number;
};

type Limit = { min: number; max: number; step: number };

// Editing bounds per setting, keyed by the name DM sends. This is an admin
// tool, so these are deliberately generous - they exist to give sane step sizes
// and to stop typos, not to hold anyone back. The two exceptions are called out
// below, and they are the only ones that can actually hurt the server.
const LIMITS: Record<string, Limit> = {
  // blast. Maps run to 255x450 per z-level, so corner to corner is ~520 tiles.
  // Radius itself is cheap - it only allocates one bucket list per ring - but
  // it is not free, hence a high ceiling rather than none at all.
  radius: { min: 1, max: 10000, step: 5 },
  power: { min: 0.1, max: 1000, step: 0.1 },
  // The sweep advances `speed` tiles per tick, and now drives the ripple too.
  speed: { min: 1, max: 512, step: 1 },
  'z reach': { min: 0, max: 32, step: 1 },

  // destruction
  'base damage': { min: 0, max: 100000, step: 10 },
  'wall damage mult': { min: 0, max: 1000, step: 0.5 },
  'wall absorb scale': { min: 1, max: 1000000, step: 100 },
  // Above 1 a wall that holds *adds* energy to its sector instead of taking it,
  // so the wave feeds itself. Allowed, because it is a fun thing to try, but
  // that is why it is not open ended.
  'wall hold': { min: 0, max: 5, step: 0.05 },
  // DANGEROUS - these two are the only real footgun here. Wall scanning costs
  // (2*range+1)^2 turfs per z-level, so it grows quadratically: 64 is ~17k
  // turfs, 255 is ~261k, and past that it will visibly hitch the server no
  // matter how the work is spread. Capped on purpose.
  'wall range per power': { min: 0, max: 255, step: 1 },
  'wall range cap': { min: 0, max: 255, step: 1 },
  'z cost': { min: 0, max: 1000, step: 1 },
  'knockdown floor': { min: 0, max: 100, step: 0.05 },
  'knockdown time ds': { min: 0, max: 6000, step: 5 },
  'body damage': { min: 0, max: 10000, step: 1 },
  // BYOND treats sound volume as 0-100, so higher would simply do nothing.
  'ringing volume': { min: 0, max: 100, step: 5 },
  'ringing time ds': { min: 0, max: 6000, step: 10 },
  'throw objects': { min: 0, max: 1, step: 1 },
  // Off means the wave never touches the map: no registry pass, no wall scan,
  // and only the player effects below it are left.
  destroy: { min: 0, max: 1, step: 1 },
  'reach all players': { min: 0, max: 1, step: 1 },
  'strength floor': { min: 0, max: 1, step: 0.05 },
  'throw range': { min: 1, max: 255, step: 1 },
  'throw speed': { min: 1, max: 50, step: 1 },

  // visuals. All client side, so none of it can hurt the server.
  'amplitude base': { min: 0, max: 1000, step: 1 },
  'amplitude gain': { min: 0, max: 1000, step: 1 },
  'band falloff': { min: 0.01, max: 100, step: 0.05 },
  // Only used by Preview now; a real blast derives both from radius and speed.
  'duration ds': { min: 1, max: 600, step: 1 },
  'min duration ds': { min: 0, max: 100, step: 1 },
  'travel px': { min: 8, max: 20000, step: 16 },
  'end amplitude': { min: 0, max: 10, step: 0.05 },
  'range tiles': { min: 0, max: 1000, step: 1 },
  'origin x px': { min: -4000, max: 4000, step: 8 },
  'origin y px': { min: -4000, max: 4000, step: 8 },
};

const FALLBACK: Limit = { min: 0, max: 512, step: 1 };

const TITLES: Record<string, string> = {
  blast: 'Blast',
  damage: 'Destruction',
  visuals: 'Visuals',
};

export const ShockwaveTuner = (props) => {
  const { act, data } = useBackend<Data>();
  const { groups = [], strength = 1 } = data;

  return (
    <Window width={380} height={620} title="Shockwave">
      <Window.Content scrollable>
        <Stack vertical>
          <Stack.Item>
            <Section title="Set off">
              <Stack>
                <Stack.Item grow>
                  <Button
                    fluid
                    icon="bomb"
                    color="bad"
                    textAlign="center"
                    onClick={() => act('fire')}
                  >
                    Fire at me
                  </Button>
                </Stack.Item>
                <Stack.Item grow>
                  <Button
                    fluid
                    icon="eye"
                    textAlign="center"
                    onClick={() => act('preview')}
                  >
                    Preview visual
                  </Button>
                </Stack.Item>
              </Stack>
              <LabeledList>
                <LabeledList.Item label="preview strength">
                  <NumberInput
                    value={strength}
                    minValue={0.1}
                    maxValue={5}
                    step={0.1}
                    onChange={(value: number) => act('strength', { value })}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>

          {groups.map((group) => (
            <Stack.Item key={group.key}>
              <Section title={TITLES[group.key] || group.key}>
                <LabeledList>
                  {group.settings.map((setting) => {
                    const limit = LIMITS[setting.name] || FALLBACK;
                    return (
                      <LabeledList.Item
                        key={setting.name}
                        label={setting.name}
                      >
                        <NumberInput
                          value={setting.value}
                          minValue={limit.min}
                          maxValue={limit.max}
                          step={limit.step}
                          onChange={(value: number) =>
                            act('set', {
                              group: group.key,
                              name: setting.name,
                              value,
                            })
                          }
                        />
                      </LabeledList.Item>
                    );
                  })}
                </LabeledList>
              </Section>
            </Stack.Item>
          ))}

          <Stack.Item>
            <Button.Confirm
              fluid
              icon="undo"
              textAlign="center"
              onClick={() => act('reset')}
            >
              Reset all to defaults
            </Button.Confirm>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
