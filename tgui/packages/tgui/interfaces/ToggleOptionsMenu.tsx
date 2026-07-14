import { Button, Section, Stack, Table, Tooltip } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type ToggleEntry = {
  id: string;
  label: string;
  enabled: BooleanLike;
  desc: string;
  disabled?: BooleanLike;
  indent?: number;
};

type SelectOption = {
  label: string;
  value: string;
};

type SelectEntry = {
  id: string;
  label: string;
  value: string;
  desc: string;
  options: SelectOption[];
};

type ToggleCategory = {
  name: string;
  entries: ToggleEntry[];
  selects?: SelectEntry[];
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
        {(category.selects || []).map((entry) => (
          <SelectEntryRow key={entry.id} entry={entry} />
        ))}
      </Table>
    </Section>
  );
};

const ToggleEntryRow = ({ entry }: { entry: ToggleEntry }) => {
  const { act } = useBackend<Data>();
  const indent = Math.max(Number(entry.indent || 0), 0);
  const isDisabled = !!entry.disabled;
  const checkboxStyle: React.CSSProperties = {
    marginLeft: `${indent * 1.25}rem`,
    ...(isDisabled
      ? {
          opacity: 0.55,
          filter: 'grayscale(0.85)',
          backgroundColor: 'rgba(100, 100, 100, 0.18)',
          borderColor: 'rgba(170, 170, 170, 0.35)',
          color: 'rgba(225, 225, 225, 0.75)',
        }
      : null),
  };

  return (
    <Table.Row className="candystripe">
      <Table.Cell>
        <Tooltip content={entry.desc} position="bottom">
          <Button.Checkbox
            checked={entry.enabled}
            fluid
            disabled={isDisabled}
            style={checkboxStyle}
            onClick={() => {
              if (!isDisabled) {
                act('toggle', { id: entry.id });
              }
            }}
          >
            {entry.label}
          </Button.Checkbox>
        </Tooltip>
      </Table.Cell>
    </Table.Row>
  );
};

const SelectEntryRow = ({ entry }: { entry: SelectEntry }) => {
  const { act } = useBackend<Data>();
  const options = Array.isArray(entry.options) ? entry.options : [];

  return (
    <Table.Row className="candystripe">
      <Table.Cell>
        <Tooltip content={entry.desc} position="bottom">
          <Stack align="center">
            <Stack.Item grow>{entry.label}</Stack.Item>
            {options.map((option) => (
              <Stack.Item key={option.value}>
                <Button
                  selected={entry.value === option.value}
                  onClick={() =>
                    act('select', { id: entry.id, value: option.value })
                  }
                >
                  {option.label}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </Tooltip>
      </Table.Cell>
    </Table.Row>
  );
};
