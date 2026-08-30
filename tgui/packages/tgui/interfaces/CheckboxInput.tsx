import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import { createSearch, decodeHtmlEntities } from 'tgui-core/string';

import { InputButtons } from './common/InputButtons';
import { Loader } from './common/Loader';

type Data = {
  items: string[];
  descriptions: Record<string, string> | null;
  default_checked: string[];
  message: string;
  title: string;
  timeout: number;
  min_checked: number;
  max_checked: number;
  window_width: number;
  window_height: number;
};

/** Renders a list of checkboxes per items for input. */
export const CheckboxInput = (props) => {
  const { data } = useBackend<Data>();
  const {
    items = [],
    descriptions,
    default_checked = [],
    min_checked,
    max_checked,
    message,
    timeout,
    title,
    window_width = 425,
    window_height = 300,
  } = data;

  const [selections, setSelections] = useState<string[]>(
    default_checked.filter((item) => items.includes(item)),
  );

  const [searchQuery, setSearchQuery] = useState('');
  // descriptions are searchable too, they hold the trait defines
  const search = createSearch(
    searchQuery,
    (item: string) => `${item} ${descriptions?.[item] || ''}`,
  );
  const toDisplay = items.filter(search);

  const selectItem = (name: string) => {
    const newSelections = selections.includes(name)
      ? selections.filter((item) => item !== name)
      : [...selections, name];

    setSelections(newSelections);
  };

  return (
    <Window title={title} width={window_width} height={window_height}>
      {!!timeout && <Loader value={timeout} />}
      <Window.Content>
        <Stack fill vertical g={0}>
          <Stack.Item>
            <NoticeBox info textAlign="center">
              {decodeHtmlEntities(message)}{' '}
              {min_checked > 0 && ` (Min: ${min_checked})`}
              {max_checked < 50 && ` (Max: ${max_checked})`}
            </NoticeBox>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              <Table>
                {toDisplay.map((item, index) => (
                  <Table.Row className="candystripe" key={index}>
                    <Table.Cell>
                      <Button.Checkbox
                        checked={selections.includes(item)}
                        disabled={
                          selections.length >= max_checked &&
                          !selections.includes(item)
                        }
                        fluid
                        onClick={() => selectItem(item)}
                      >
                        {item}
                      </Button.Checkbox>
                      {!!descriptions?.[item] && (
                        <Box
                          color="label"
                          fontSize="0.9em"
                          mb={0.5}
                          ml={2}
                          style={{ whiteSpace: 'normal' }}
                        >
                          {decodeHtmlEntities(descriptions[item])}
                        </Box>
                      )}
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </Stack.Item>
          <Stack m={1}>
            <Stack.Item>
              <Tooltip content="Search" position="bottom">
                <Icon name="search" mt={0.5} />
              </Tooltip>
            </Stack.Item>
            <Stack.Item grow>
              <Input fluid value={searchQuery} onChange={setSearchQuery} />
            </Stack.Item>
          </Stack>
          <Stack.Item>
            <Section>
              <InputButtons input={selections} />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
