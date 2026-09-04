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

// Editing bounds per setting, keyed by the name DM sends. Anything not listed
// falls back to a wide default rather than being locked out.
const LIMITS: Record<string, Limit> = {
  // blast. Maps run to 255x450 per z-level, so a corner to corner wave needs
  // a radius over 500 - the ceiling is well clear of that rather than snug.
  radius: { min: 1, max: 1024, step: 5 },
  power: { min: 0.1, max: 20, step: 0.1 },
  // A big radius needs a matching speed or the front takes minutes to arrive:
  // the sweep advances `speed` tiles per tick.
  speed: { min: 1, max: 64, step: 1 },
  'z reach': { min: 0, max: 8, step: 1 },
  // destruction
  'base damage': { min: 0, max: 2000, step: 10 },
  'wall damage mult': { min: 0, max: 40, step: 0.5 },
  'wall absorb scale': { min: 100, max: 40000, step: 100 },
  'wall hold': { min: 0, max: 1, step: 0.05 },
  'wall range per power': { min: 0, max: 128, step: 1 },
  'wall range cap': { min: 0, max: 255, step: 1 },
  'z cost': { min: 0, max: 64, step: 1 },
  'knockdown floor': { min: 0, max: 2, step: 0.05 },
  'knockdown time ds': { min: 0, max: 300, step: 5 },
  'body damage': { min: 0, max: 100, step: 1 },
  'ringing volume': { min: 0, max: 100, step: 5 },
  'ringing time ds': { min: 0, max: 600, step: 10 },
  'throw objects': { min: 0, max: 1, step: 1 },
  'throw range': { min: 1, max: 32, step: 1 },
  'throw speed': { min: 1, max: 10, step: 1 },
  // visuals
  'amplitude base': { min: 0, max: 128, step: 1 },
  'amplitude gain': { min: 0, max: 256, step: 1 },
  'band falloff': { min: 0.05, max: 4, step: 0.05 },
  'duration ds': { min: 1, max: 60, step: 1 },
  'end amplitude': { min: 0, max: 2, step: 0.05 },
  'travel px': { min: 32, max: 1024, step: 16 },
  'range tiles': { min: 0, max: 128, step: 1 },
  'origin x px': { min: -480, max: 480, step: 8 },
  'origin y px': { min: -480, max: 480, step: 8 },
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
