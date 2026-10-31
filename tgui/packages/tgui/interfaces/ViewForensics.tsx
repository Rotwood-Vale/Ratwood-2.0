import {
  Box,
  Button,
  Icon,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

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

type Reagent = {
  name: string;
  volume: number;
  poison: BooleanLike;
};

type Contents = {
  reagents: Reagent[];
  total_volume: number;
  maximum_volume: number;
  // For a spiked drink, the reagent its next sip draws from first
  rim: string | null;
  items: string[];
};

type Report = {
  generated_at: string;
  type: string;
  location: string;
  is_item: BooleanLike;
  evidence: ForensicAction[];
  routine: ForensicAction[];
  touches: Touch[];
  last_toucher: string | null;
  contents: Contents | null;
};

type Data = {
  target_name: string;
  report: Report | null;
};

// About ten rows, after which the section scrolls instead of growing
const SCROLL_HEIGHT = '15em';

const PlayerButtons = (props: { ckey: string }) => {
  const { act } = useBackend();
  const { ckey } = props;
  return (
    <Box nowrap>
      <Button
        icon="eye"
        tooltip="Follow this player as a ghost"
        onClick={() => act('follow', { ckey })}
      >
        FLW
      </Button>
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

const ActionsSection = (props: {
  title: string;
  actions: ForensicAction[];
}) => {
  const { title, actions } = props;
  return (
    <Section title={`${title} (${actions.length})`}>
      {actions.length === 0 ? (
        <NoticeBox>None recorded.</NoticeBox>
      ) : (
        <Box style={{ maxHeight: SCROLL_HEIGHT, overflowY: 'auto' }}>
          <Table>
            <Table.Row header>
              <Table.Cell collapsing>Time</Table.Cell>
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
        </Box>
      )}
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
        <Box style={{ maxHeight: SCROLL_HEIGHT, overflowY: 'auto' }}>
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
        </Box>
      )}
      {lastToucher && (
        <Box color="label" mt={1}>
          Last touched by {lastToucher}.
        </Box>
      )}
    </Section>
  );
};

const ContentsSection = (props: { contents: Contents }) => {
  const { reagents, total_volume, maximum_volume, rim, items } = props.contents;
  return (
    <Section title={`Contents (${total_volume}/${maximum_volume}u)`}>
      {rim && (
        <NoticeBox danger>
          Spiked on the rim. The next sip draws {rim} first. See Suspicious
          actions for what was sprinkled.
        </NoticeBox>
      )}
      {reagents.length === 0 ? (
        <NoticeBox>Empty.</NoticeBox>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell>Reagent</Table.Cell>
            <Table.Cell collapsing>Amount</Table.Cell>
            <Table.Cell collapsing />
          </Table.Row>
          {reagents.map((reagent, i) => (
            <Table.Row key={i} className="candystripe">
              <Table.Cell>{reagent.name}</Table.Cell>
              <Table.Cell collapsing>
                <Box nowrap>{reagent.volume}u</Box>
              </Table.Cell>
              <Table.Cell collapsing>
                {!!reagent.poison && (
                  <Box nowrap bold color="bad">
                    Poison
                  </Box>
                )}
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
      {items.length > 0 && (
        <Box color="label" mt={1}>
          Items inside: {items.join(', ')}
        </Box>
      )}
    </Section>
  );
};

export const ViewForensics = () => {
  const { act, data } = useBackend<Data>();
  const { target_name, report } = data;

  return (
    <Window width={780} height={700} title={`Forensics: ${target_name}`}>
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
                  <Box>Generated at {report.generated_at}</Box>
                  <Box>{report.type}</Box>
                  <Box>{report.location}</Box>
                </Box>
              )}
            </Stack.Item>
            <Stack.Item>
              <Tooltip content="All times shown are round time, counted from the start of the round.">
                <Box color="label" nowrap>
                  <Icon name="clock" mr={0.5} />
                  Round time
                </Box>
              </Tooltip>
            </Stack.Item>
            <Stack.Item>
              <Button icon="location-arrow" onClick={() => act('jump')}>
                Jump
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
        {!report ? (
          <NoticeBox>
            Press Generate Logs to read this object&apos;s forensics.
          </NoticeBox>
        ) : (
          <>
            {report.contents && <ContentsSection contents={report.contents} />}
            <ActionsSection
              title={
                report.is_item
                  ? 'Picked up and dropped'
                  : 'Opened, closed and locked'
              }
              actions={report.routine}
            />
            <ActionsSection
              title="Suspicious actions"
              actions={report.evidence}
            />
            <TouchesSection
              touches={report.touches}
              lastToucher={report.last_toucher}
            />
          </>
        )}
        {report && (
          <Box color="label">
            Each list keeps its latest 30 entries. Repeats in a row share one
            line.
          </Box>
        )}
      </Window.Content>
    </Window>
  );
};
