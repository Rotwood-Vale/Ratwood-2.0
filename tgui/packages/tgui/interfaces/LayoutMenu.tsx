import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { DragSlider } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { Button, Section, Stack } from 'tgui-core/components';

type Data = {
  map: number | null;
  stat: number | null;
  map_default: number;
  map_min: number;
  map_max: number;
  stat_default: number;
  stat_min: number;
  stat_max: number;
};

// The skin's two splitters. Each is the share the first pane gets: the map's share of the window,
// and the stat panel's share of its column. Dragging moves the real pane at once, from this
// browser; only a release goes to the server, to be remembered.
const SPLITTERS = {
  map: {
    control: 'split',
    label: 'Map width',
    hint: 'How much of the window the map takes. The rest is the chat.',
  },
  stat: {
    control: 'info',
    label: 'Stat panel height',
    hint: 'How much of the right-hand column the stat panel takes. The rest is the chat.',
  },
} as const;

type SplitterId = keyof typeof SPLITTERS;

const applyToSkin = (id: SplitterId, value: number) =>
  Byond.winset(SPLITTERS[id].control, { splitter: value });

type SplitterRowProps = {
  id: SplitterId;
  saved: number | null;
  min: number;
  max: number;
};

const SplitterRow = ({ id, saved, min, max }: SplitterRowProps) => {
  const { act } = useBackend<Data>();
  // A saved value is shown as is. Nothing saved yet means the skin's own position is the truth,
  // so it is read from there once.
  const [live, setLive] = useState<number | null>(saved);
  useEffect(() => {
    if (saved !== null) {
      setLive(saved);
      return;
    }
    Byond.winget(SPLITTERS[id].control, 'splitter').then((value: string) => {
      const read = Number(value);
      setLive(
        Number.isFinite(read)
          ? Math.max(min, Math.min(max, Math.round(read)))
          : min,
      );
    });
  }, [saved]);

  return (
    <DragSlider
      label={SPLITTERS[id].label}
      hint={SPLITTERS[id].hint}
      value={live ?? min}
      minValue={min}
      maxValue={max}
      onDrag={(value) => {
        setLive(value);
        applyToSkin(id, value);
      }}
      onChange={(value) => {
        setLive(value);
        applyToSkin(id, value);
        act('set', { id, value });
      }}
    />
  );
};

export const LayoutMenu = () => {
  const { act, data } = useBackend<Data>();
  const {
    map,
    stat,
    map_default,
    map_min,
    map_max,
    stat_default,
    stat_min,
    stat_max,
  } = data;

  return (
    <Window width={420} height={170}>
      <Window.Content>
        <Section>
          <SplitterRow
            id="map"
            saved={map ?? null}
            min={map_min ?? 50}
            max={map_max ?? 85}
          />
          <SplitterRow
            id="stat"
            saved={stat ?? null}
            min={stat_min ?? 10}
            max={stat_max ?? 50}
          />
          <Stack justify="flex-end">
            <Stack.Item>
              <Button
                icon="undo"
                onClick={() => {
                  applyToSkin('map', map_default ?? 68);
                  applyToSkin('stat', stat_default ?? 25);
                  act('default');
                }}
              >
                Default
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
