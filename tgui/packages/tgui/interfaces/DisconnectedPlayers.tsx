import { useState } from 'react';
import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type DisconnectedPlayer = {
  ref: string;
  ckey: string;
  name: string;
  role: string;
  time_away: number;
  time_away_text: string;
};

type Data = {
  players: DisconnectedPlayer[];
};

export const DisconnectedPlayers = () => {
  const { act, data } = useBackend<Data>();
  const players = [...(data.players || [])].sort(
    (a, b) => b.time_away - a.time_away,
  );
  const [selected, setSelected] = useState<string[]>([]);

  // Drop selections for players who are no longer listed after a refresh.
  const selectedRefs = selected.filter((ref) =>
    players.some((player) => player.ref === ref),
  );
  const allSelected =
    players.length > 0 && selectedRefs.length === players.length;

  const toggle = (ref: string) => {
    setSelected(
      selectedRefs.includes(ref)
        ? selectedRefs.filter((r) => r !== ref)
        : [...selectedRefs, ref],
    );
  };

  return (
    <Window width={820} height={520} title="Disconnected Players">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Button icon="sync" onClick={() => act('refresh')}>
              Refresh
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable title={`Disconnected (${players.length})`}>
              {players.length === 0 ? (
                <NoticeBox>No disconnected players.</NoticeBox>
              ) : (
                <Table>
                  <Table.Row header>
                    <Table.Cell collapsing>
                      <Button.Checkbox
                        checked={allSelected}
                        tooltip="Select all"
                        onClick={() =>
                          setSelected(
                            allSelected ? [] : players.map((p) => p.ref),
                          )
                        }
                      />
                    </Table.Cell>
                    <Table.Cell>Ckey</Table.Cell>
                    <Table.Cell>Character</Table.Cell>
                    <Table.Cell>Role</Table.Cell>
                    <Table.Cell>Disconnected For</Table.Cell>
                    <Table.Cell collapsing />
                  </Table.Row>
                  {players.map((player) => (
                    <Table.Row key={player.ref} className="candystripe">
                      <Table.Cell collapsing>
                        <Button.Checkbox
                          checked={selectedRefs.includes(player.ref)}
                          onClick={() => toggle(player.ref)}
                        />
                      </Table.Cell>
                      <Table.Cell>{player.ckey}</Table.Cell>
                      <Table.Cell>{player.name}</Table.Cell>
                      <Table.Cell>{player.role}</Table.Cell>
                      <Table.Cell>{player.time_away_text}</Table.Cell>
                      <Table.Cell collapsing>
                        <Box nowrap>
                          <Button
                            color="bad"
                            icon="door-open"
                            onClick={() =>
                              act('fartravel', { ref: player.ref })
                            }
                          >
                            Fartravel
                          </Button>
                          <Button
                            icon="user"
                            tooltip="Open the player panel"
                            onClick={() =>
                              act('player_panel', { ref: player.ref })
                            }
                          >
                            PP
                          </Button>
                        </Box>
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              )}
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Button
              color="bad"
              icon="door-open"
              disabled={selectedRefs.length === 0}
              onClick={() => act('fartravel_selected', { refs: selectedRefs })}
            >
              Fartravel Highlighted ({selectedRefs.length})
            </Button>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
