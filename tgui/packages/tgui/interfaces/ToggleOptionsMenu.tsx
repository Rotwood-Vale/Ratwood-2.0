import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Button, Section, Stack, Table, Tooltip } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type ToggleEntry = {
  id: string;
  label: string;
  enabled: BooleanLike;
  desc: string;
};

type ToggleCategory = {
  name: string;
  entries: ToggleEntry[];
};

type Data = {
  categories: ToggleCategory[];
};

export const ToggleOptionsMenu = () => {
  const { data } = useBackend<Data>();
  const { categories = [] } = data;

  return (
    <Window width={560} height={840}>
      <Window.Content scrollable>
        <Stack vertical>
          {categories.map((category) => (
            <Stack.Item key={category.name}>
              <ToggleCategorySection category={category} />
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const ToggleCategorySection = ({ category }: { category: ToggleCategory }) => {
  return (
    <Section title={category.name}>
      <Table>
        {category.entries.map((entry) => (
          <ToggleEntryRow key={entry.id} entry={entry} />
        ))}
      </Table>
    </Section>
  );
};

const ToggleEntryRow = ({ entry }: { entry: ToggleEntry }) => {
  const { act } = useBackend<Data>();

  return (
    <Table.Row className="candystripe">
      <Table.Cell>
        <Tooltip content={entry.desc} position="bottom">
          <Button.Checkbox
            checked={entry.enabled}
            fluid
            onClick={() => act('toggle', { id: entry.id })}
          >
            {entry.label}
          </Button.Checkbox>
        </Tooltip>
      </Table.Cell>
    </Table.Row>
  );
};
