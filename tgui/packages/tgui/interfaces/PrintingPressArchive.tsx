import { useState } from 'react';
import {
  Button,
  Dropdown,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type ArchiveEntry = {
  filename: string;
  title: string;
  author: string;
  category?: string;
  date: string;
};

type Data = {
  archive_type: 'book' | 'painting';
  entries: ArchiveEntry[];
};

const ALL_CATEGORIES = 'All';

export const PrintingPressArchive = (props) => {
  const { act, data } = useBackend<Data>();
  const { archive_type, entries = [] } = data;
  const [titleSearch, setTitleSearch] = useState('');
  const [authorSearch, setAuthorSearch] = useState('');
  const [categoryFilter, setCategoryFilter] = useState(ALL_CATEGORIES);

  const isBookArchive = archive_type !== 'painting';
  const noun = isBookArchive ? 'book' : 'painting';

  const categories = [
    ALL_CATEGORIES,
    ...new Set(
      entries
        .map((entry) => entry.category)
        .filter((category): category is string => !!category)
        .sort((a, b) => a.localeCompare(b)),
    ),
  ];

  const shownEntries = entries
    .filter(
      (entry) =>
        entry.title.toLowerCase().includes(titleSearch.toLowerCase()) &&
        entry.author.toLowerCase().includes(authorSearch.toLowerCase()) &&
        (categoryFilter === ALL_CATEGORIES ||
          entry.category === categoryFilter),
    )
    .sort((a, b) => a.title.localeCompare(b.title));

  return (
    <Window width={520} height={520}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Search">
              <LabeledList>
                <LabeledList.Item label="Title">
                  <Input
                    fluid
                    value={titleSearch}
                    placeholder={`Search ${noun} titles...`}
                    onChange={setTitleSearch}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Author">
                  <Input
                    fluid
                    value={authorSearch}
                    placeholder="Search authors..."
                    onChange={setAuthorSearch}
                  />
                </LabeledList.Item>
                {isBookArchive && (
                  <LabeledList.Item label="Category">
                    <Dropdown
                      width="100%"
                      selected={categoryFilter}
                      options={categories}
                      onSelected={setCategoryFilter}
                    />
                  </LabeledList.Item>
                )}
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              title={`Archived ${noun}s (${shownEntries.length})`}
              fill
              scrollable
            >
              {shownEntries.length === 0 ? (
                <NoticeBox>No {noun}s found.</NoticeBox>
              ) : (
                <Table>
                  <Table.Row header>
                    <Table.Cell>Title</Table.Cell>
                    <Table.Cell>Author</Table.Cell>
                    {isBookArchive && (
                      <Table.Cell collapsing>Category</Table.Cell>
                    )}
                    <Table.Cell collapsing>Written</Table.Cell>
                    <Table.Cell collapsing />
                  </Table.Row>
                  {shownEntries.map((entry) => (
                    <Table.Row key={entry.filename} className="candystripe">
                      <Table.Cell>{entry.title}</Table.Cell>
                      <Table.Cell>{entry.author}</Table.Cell>
                      {isBookArchive && (
                        <Table.Cell collapsing>{entry.category}</Table.Cell>
                      )}
                      <Table.Cell collapsing>{entry.date}</Table.Cell>
                      <Table.Cell collapsing>
                        <Button
                          icon="print"
                          onClick={() =>
                            act('print', { filename: entry.filename })
                          }
                        >
                          Print
                        </Button>
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
