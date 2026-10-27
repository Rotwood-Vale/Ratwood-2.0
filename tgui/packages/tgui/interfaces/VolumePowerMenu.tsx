import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { NumberInput, Section, Stack } from 'tgui-core/components';

type Data = {
  master: number;
  music: number;
  combat: number;
  ambience: number;
  lobby: number;
};

type VolumeRowProps = {
  label: string;
  value: number;
  id: string;
  description: string;
};

const VolumeRow = ({ label, value, id, description }: VolumeRowProps) => {
  const { act } = useBackend<Data>();

  return (
    <Stack align="center" mb={1.5}>
      <Stack.Item basis="50%">
        <b>{label}</b>
      </Stack.Item>
      <Stack.Item grow>
        <NumberInput
          minValue={0}
          maxValue={100}
          step={1}
          value={value}
          width="100%"
          onChange={(newValue: number) =>
            act('set_volume', { id, value: newValue })
          }
        />
      </Stack.Item>
      <Stack.Item basis="10%" textAlign="right">
        %
      </Stack.Item>
      <Stack.Item basis="100%">
        <span className="color-label">{description}</span>
      </Stack.Item>
    </Stack>
  );
};

export const VolumePowerMenu = () => {
  const { data } = useBackend<Data>();
  const {
    master,
    music,
    combat,
    ambience,
    lobby,
  } = data;

  const masterValue = master ?? 100;
  const musicValue = music ?? 100;
  const combatValue = combat ?? 50;
  const ambienceValue = ambience ?? 100;
  const lobbyValue = lobby ?? 100;

  return (
    <Window width={470} height={390}>
      <Window.Content>
        <Section title="Volume Levels" fill>
          <VolumeRow
            label="Master"
            value={masterValue}
            id="master"
            description="Non-music and non-ambience sounds."
          />
          <VolumeRow
            label="Music"
            value={musicValue}
            id="music"
            description="Non-combat music and admin music."
          />
          <VolumeRow
            label="Combat Music"
            value={combatValue}
            id="combat"
            description="Combat and combat-adjacent music channels."
          />
          <VolumeRow
            label="Ambience"
            value={ambienceValue}
            id="ambience"
            description="Ambient and environmental loop channels."
          />
          <VolumeRow
            label="Lobby Music"
            value={lobbyValue}
            id="lobby"
            description="Title/lobby music playback volume."
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
