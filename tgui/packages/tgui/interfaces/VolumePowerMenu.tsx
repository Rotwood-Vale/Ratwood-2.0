import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, NumberInput, Section, Stack } from 'tgui-core/components';

type Data = {
  master: number;
  music: number;
  combat: number;
  ambience: number;
  lobby: number;
  point_ambience_volume: number;
  point_ambience: boolean;
  point_ambience_torch: boolean;
};

type ToggleRowProps = {
  label: string;
  enabled: boolean;
  id: string;
  description: string;
};

const ToggleRow = ({ label, enabled, id, description }: ToggleRowProps) => {
  const { act } = useBackend<Data>();

  return (
    <Stack align="center" mb={1.5}>
      <Stack.Item basis="50%">
        <b>{label}</b>
      </Stack.Item>
      <Stack.Item grow>
        <Button
          fluid
          textAlign="center"
          icon={enabled ? 'volume-up' : 'volume-mute'}
          color={enabled ? 'good' : 'bad'}
          onClick={() => act('toggle', { id })}
        >
          {enabled ? 'On' : 'Off'}
        </Button>
      </Stack.Item>
      <Stack.Item basis="10%" />
      <Stack.Item basis="100%">
        <span className="color-label">{description}</span>
      </Stack.Item>
    </Stack>
  );
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
    point_ambience_volume,
    point_ambience,
    point_ambience_torch,
  } = data;

  const masterValue = master ?? 100;
  const musicValue = music ?? 100;
  const combatValue = combat ?? 50;
  const ambienceValue = ambience ?? 100;
  const lobbyValue = lobby ?? 100;
  const pointAmbienceValue = point_ambience_volume ?? 50;
  const pointAmbienceOn = point_ambience ?? true;
  const torchAmbienceOn = point_ambience_torch ?? true;

  return (
    <Window width={470} height={640}>
      <Window.Content>
        <Section title="Volume Levels">
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
            label="Area Ambience"
            value={ambienceValue}
            id="ambience"
            description="The background loop for the area you are in, and rain."
          />
          <VolumeRow
            label="Lobby Music"
            value={lobbyValue}
            id="lobby"
            description="Title/lobby music playback volume."
          />
        </Section>
        <Section title="Point Ambience">
          <VolumeRow
            label="Volume"
            value={pointAmbienceValue}
            id="point_ambience_volume"
            description="How loud hearths, fountains, rivers and sconces are. Master does not affect it. Zero turns it off."
          />
          <ToggleRow
            label="Point Ambience"
            enabled={pointAmbienceOn}
            id="point_ambience"
            description="Sounds from things you can walk up to: hearths, fountains, rivers, sconces."
          />
          <ToggleRow
            label="Torchlight Ambience"
            enabled={torchAmbienceOn}
            id="point_ambience_torch"
            description="Wall sconces, standing firebowls and a torch in your own hand. Hearths, campfires and floor firebowls are not this and keep crackling."
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
