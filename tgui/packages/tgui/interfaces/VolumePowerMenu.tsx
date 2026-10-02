import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { DragSlider } from 'tgui/components';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Section,
  Stack,
  Tabs,
  Tooltip,
} from 'tgui-core/components';

type Data = {
  master: number;
  effects: number;
  instruments: number;
  replace_uploaded_songs: boolean;
  music: number;
  adminmusic: number;
  streamedmusic: number;
  combat: number;
  ambience: number;
  lobby: number;
  point_ambience_volume: number;
  point_ambience_independent: boolean;
  point_ambience: boolean;
  point_ambience_torch: boolean;
};

type VolumeRowProps = {
  label: string;
  value: number;
  id: string;
  hint: string;
};

const VolumeRow = ({ label, value, id, hint }: VolumeRowProps) => {
  const { act } = useBackend<Data>();

  return (
    <DragSlider
      label={label}
      hint={hint}
      value={value}
      minValue={0}
      maxValue={100}
      unit="%"
      onChange={(volume) => act('set_volume', { id, value: volume })}
    />
  );
};

type ToggleRowProps = {
  label: string;
  enabled: boolean;
  id: string;
  hint: string;
};

const ToggleRow = ({ label, enabled, id, hint }: ToggleRowProps) => {
  const { act } = useBackend<Data>();

  return (
    <Stack align="center" mb={0.75}>
      <Stack.Item basis="36%" shrink={0}>
        <Tooltip content={hint} position="right">
          <b>{label}</b>
        </Tooltip>
      </Stack.Item>
      <Stack.Item grow>
        <Button
          width={5}
          textAlign="center"
          icon={enabled ? 'volume-up' : 'volume-mute'}
          selected={enabled}
          onClick={() => act('toggle', { id })}
        >
          {enabled ? 'On' : 'Off'}
        </Button>
      </Stack.Item>
    </Stack>
  );
};

export const VolumePowerMenu = () => {
  const { act, data, config } = useBackend<Data>();
  const [tab, setTab] = useState(0);
  const [content, setContent] = useState<HTMLDivElement | null>(null);
  const [height, setHeight] = useState(420);
  const muted = data.master === 0;
  const pointAmbienceIndependent = data.point_ambience_independent ?? true;
  const effectivePointVolume =
    (pointAmbienceIndependent ? 1 : (data.master ?? 100) / 100) *
    (data.point_ambience_volume ?? 100);
  const lowPointVolume =
    (data.point_ambience ?? true) && effectivePointVolume < 50;
  const volumeNotice = muted
    ? pointAmbienceIndependent &&
      (data.point_ambience ?? true) &&
      (data.point_ambience_volume ?? 100) > 0
      ? 'Master Volume is muted, but independent Point Ambience remains active. Use Stop Sounds for any other continuing loops.'
      : 'You have muted your game. Some loops may continue; use Stop Sounds or wait for them to end.'
    : lowPointVolume
      ? 'Effective Point Ambience volume is below 50%. Point ambience may not work as intended at this level.'
      : null;
  useEffect(() => {
    if (!content) return;
    let cancelled = false;
    const fitHeight = () => {
      if (cancelled) return;
      const scale = config.window.scale ? 1 : window.devicePixelRatio;
      const padding = parseFloat(
        getComputedStyle(document.documentElement).fontSize,
      );
      const bounds = content.getBoundingClientRect();
      const zoom = content.offsetHeight
        ? bounds.height / content.offsetHeight
        : 1;
      const titleHeight =
        content.closest('.Window__rest')?.getBoundingClientRect().top ?? 0;
      setHeight(
        Math.ceil((titleHeight + bounds.height + padding * 2 * zoom) * scale),
      );
    };
    const frame = requestAnimationFrame(fitHeight);
    document.fonts.ready.then(fitHeight);
    return () => {
      cancelled = true;
      cancelAnimationFrame(frame);
    };
  }, [content, config.window.scale, config.window.theme, tab, volumeNotice]);
  const {
    master,
    effects,
    instruments,
    replace_uploaded_songs,
    music,
    adminmusic,
    streamedmusic,
    combat,
    ambience,
    lobby,
    point_ambience_volume,
    point_ambience_independent,
    point_ambience,
    point_ambience_torch,
  } = data;

  return (
    <Window width={440} height={height}>
      <Window.Content scrollable>
        <div ref={setContent} className="AudioSettings">
          <Section title="Master Volume" className="AudioSettings__panel">
            <VolumeRow
              label="Master"
              value={master ?? 100}
              id="master"
              hint="Scales all sounds except independent Point Ambience."
            />
            <Box fontSize="0.85em">
              Adminhelp and admin PM alerts still play at 0%.
            </Box>
          </Section>
          <Section className="AudioSettings__panel">
            <Tabs fluid className="AudioSettings__tabs">
              <Tabs.Tab
                icon="volume-up"
                selected={tab === 0}
                onClick={() => setTab(0)}
              >
                Gameplay Audio
              </Tabs.Tab>
              <Tabs.Tab
                icon="music"
                selected={tab === 1}
                onClick={() => setTab(1)}
              >
                Other Audio
              </Tabs.Tab>
              <Tabs.Tab
                icon="fire"
                selected={tab === 2}
                onClick={() => setTab(2)}
              >
                Point Ambience
              </Tabs.Tab>
            </Tabs>
            {tab === 0 && (
              <Box mt={1}>
                <VolumeRow
                  label="Sound Effects"
                  value={effects ?? 50}
                  id="effects"
                  hint="Sounds in the world: combat, footsteps, items, doors."
                />
                <VolumeRow
                  label="Area Ambience"
                  value={ambience ?? 100}
                  id="ambience"
                  hint="The loop for the area you are in, and rain."
                />
                <VolumeRow
                  label="Instruments"
                  value={instruments ?? 50}
                  id="instruments"
                  hint="Bards, music boxes, and wax music devices."
                />
                <Box ml={1} mt={-0.5} mb={0.5}>
                  <Button.Checkbox
                    checked={replace_uploaded_songs ?? false}
                    color="transparent"
                    compact
                    fontSize="0.85em"
                    tooltip="For lower bandwidth: replaces player-uploaded instrument and music-box songs with built-in songs. The uploaded file is not sent to you."
                    tooltipPosition="right"
                    onClick={() =>
                      act('toggle', { id: 'replace_uploaded_songs' })
                    }
                  >
                    Use In-Game Songs Instead
                  </Button.Checkbox>
                </Box>
                <VolumeRow
                  label="World Music"
                  value={music ?? 100}
                  id="music"
                  hint="The world's own music."
                />
                <VolumeRow
                  label="Combat Music"
                  value={combat ?? 50}
                  id="combat"
                  hint="Music while in combat mode."
                />
              </Box>
            )}
            {tab === 1 && (
              <Box mt={1}>
                <VolumeRow
                  label="Streamed Music"
                  value={streamedmusic ?? 50}
                  id="streamedmusic"
                  hint="Music streamed into your chat panel."
                />
                <VolumeRow
                  label="Admin-Played Sounds"
                  value={adminmusic ?? 50}
                  id="adminmusic"
                  hint="Sounds played by admins. Does not affect adminhelp alerts."
                />
                <VolumeRow
                  label="Lobby Music"
                  value={lobby ?? 100}
                  id="lobby"
                  hint="The title screen."
                />
              </Box>
            )}
            {tab === 2 && (
              <Box mt={1}>
                <Box mb={1}>
                  Nearby fires, fountains, rivers, and other ambient sounds.
                </Box>
                <VolumeRow
                  label="Volume"
                  value={point_ambience_volume ?? 100}
                  id="point_ambience_volume"
                  hint="Nearby ambient sounds."
                />
                <ToggleRow
                  label="Independent Volume"
                  enabled={point_ambience_independent ?? true}
                  id="point_ambience_independent"
                  hint="Keeps Point Ambience at its chosen volume when Master Volume changes. Recommended for the intended ambience balance."
                />
                <ToggleRow
                  label="Point Ambience"
                  enabled={point_ambience ?? true}
                  id="point_ambience"
                  hint="All of it, on or off."
                />
                <ToggleRow
                  label="Torchlight"
                  enabled={point_ambience_torch ?? true}
                  id="point_ambience_torch"
                  hint="Wall sconces, standing firebowls and a torch in your own hand."
                />
              </Box>
            )}
          </Section>
          {volumeNotice && (
            <Box textAlign="center">
              <Box className="AudioSettings__muteNote">{volumeNotice}</Box>
            </Box>
          )}
          <Box
            mt={0.5}
            fontSize="0.75em"
            textAlign="center"
            style={{ opacity: 0.7 }}
          >
            Hover over a setting to see its tooltip.
          </Box>
        </div>
      </Window.Content>
    </Window>
  );
};
