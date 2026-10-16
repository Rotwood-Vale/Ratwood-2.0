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

type ForensicAction = {
  time: string;
  ckey: string;
  name: string;
  action: string;
  count: number;
};

type Touch = {
  ckey: string;
  first: string;
  last: string | null;
};

type Report = {
  generated_at: string;
  type: string;
  location: string;
  actions: ForensicAction[];
  touches: Touch[];
  last_toucher: string | null;
};

type Data = {
  target_name: string;
  report: Report | null;
};

const PlayerButtons = (props: { ckey: string }) => {
  const { act } = useBackend();
  const { ckey } = props;
  return (
    <Box nowrap>
      <Button
        icon="user"
        tooltip="Open the player panel"
        onClick={() => act('pp', { ckey })}
      >
        PP
      </Button>
      <Button
        icon="envelope"
        tooltip="Send a direct message"
        onClick={() => act('pm', { ckey })}
      >
        PM
      </Button>
    </Box>
  );
};

const ActionsSection = (props: { actions: ForensicAction[] }) => {
  const { actions } = props;
  return (
    <Section title={`Actions (${actions.length})`}>
      {actions.length === 0 ? (
        <NoticeBox>None recorded.</NoticeBox>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell collapsing>Round time</Table.Cell>
            <Table.Cell>Ckey</Table.Cell>
            <Table.Cell>Action</Table.Cell>
            <Table.Cell collapsing />
          </Table.Row>
          {actions.map((entry, i) => (
            <Table.Row key={i} className="candystripe">
              <Table.Cell collapsing>
                <Box nowrap>{entry.time}</Box>
              </Table.Cell>
              <Table.Cell>
                <Box nowrap>
                  {entry.ckey} ({entry.name})
                </Box>
              </Table.Cell>
              <Table.Cell>
                <Box nowrap>
                  {entry.action}
                  {entry.count > 1 && ` (x${entry.count})`}
                </Box>
              </Table.Cell>
              <Table.Cell collapsing>
                <PlayerButtons ckey={entry.ckey} />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
      <Box color="label" mt={1}>
        Latest 30 opens and closes, and latest 30 other actions. Repeats in a
        row share one line.
      </Box>
    </Section>
  );
};

const TouchesSection = (props: {
  touches: Touch[];
  lastToucher: string | null;
}) => {
  const { touches, lastToucher } = props;
  return (
    <Section title={`Touched by hand (${touches.length})`}>
      {touches.length === 0 ? (
        <NoticeBox>None recorded.</NoticeBox>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell collapsing>Ckey</Table.Cell>
            <Table.Cell>Touch</Table.Cell>
            <Table.Cell collapsing />
          </Table.Row>
          {touches.map((touch) => (
            <Table.Row key={touch.ckey} className="candystripe">
              <Table.Cell collapsing>
                <Box nowrap>{touch.ckey}</Box>
              </Table.Cell>
              <Table.Cell>
                <Box nowrap>First: {touch.first}</Box>
                {touch.last && <Box nowrap>Last: {touch.last}</Box>}
              </Table.Cell>
              <Table.Cell collapsing>
                <PlayerButtons ckey={touch.ckey} />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
      <Box color="label" mt={1}>
        Touch times are server clock time.
        {lastToucher && ` Last touched by ${lastToucher}.`}
      </Box>
    </Section>
  );
};

export const ViewForensics = () => {
  const { act, data } = useBackend<Data>();
  const { target_name, report } = data;

  return (
    <Window width={760} height={520} title={`Forensics: ${target_name}`}>
      <Window.Content scrollable>
        <Section>
          <Stack align="center">
            <Stack.Item>
              <Button icon="file" onClick={() => act('generate')}>
                {report ? 'Regenerate Logs' : 'Generate Logs'}
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              {report && (
                <Box color="label">
                  Generated at round time {report.generated_at} ·{' '}
                  {report.type} · {report.location}
                </Box>
              )}
            </Stack.Item>
            <Stack.Item>
              <Button icon="location-arrow" onClick={() => act('jump')}>
                Jump
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
        {report ? (
          <>
            <ActionsSection actions={report.actions} />
            <TouchesSection
              touches={report.touches}
              lastToucher={report.last_toucher}
            />
          </>
        ) : (
          <NoticeBox>
            Press Generate Logs to read this object&apos;s forensics.
          </NoticeBox>
        )}
      </Window.Content>
    </Window>
  );
};
