import { Dispatch, SetStateAction, useState } from 'react';
import {
  Box,
  Button,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type LoadoutItem = {
  name: string;
  desc: string;
  triumph_cost: string;
  nobility_check: boolean;
  donoritem: boolean;
  ref: string;
  icon: string;
};

type Data = {
  loadout_items: LoadoutItem[];
};

export const LoadoutMenu = (props) => {
  return (
    <Window width={900} height={700}>
      <Window.Content>
        <ItemDisplay />
      </Window.Content>
    </Window>
  );
};

export const SearchBar = (props: {
  search: string;
  setSearch: Dispatch<SetStateAction<string>>;
}) => {
  const { search, setSearch } = props;
  return <Input value={search} onChange={setSearch} fluid />;
};

export const ItemDisplay = (props) => {
  const [search, setSearch] = useState('');

  const { act, data } = useBackend<Data>();

  const { loadout_items } = data;

  const availableItems = loadout_items
    .filter((item) => {
      return item.nobility_check && item.donoritem;
    })
    .filter((item) => {
      if (search) {
        return item.name.toLowerCase().includes(search.toLowerCase());
      } else {
        return true;
      }
    })
    .sort((a, b) => a.name.localeCompare(b.name)); // Sort alphabetically

  return (
    <Section
      title="Items"
      fill
      scrollable
      buttons={<SearchBar search={search} setSearch={setSearch} />}
    >
      <Box
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(5, 1fr)',
          gap: '0.4rem',
        }}
      >
        {availableItems.map((item) => (
          <Button
            key={item.ref}
            onClick={() => act('choose_item', { ref: item.ref })}
            tooltip={item.desc}
            style={{
              height: '70px',
              padding: '0.3rem',
              textAlign: 'center',
            }}
          >
            <Stack vertical align="center">
              <Stack.Item>
                <Box className={item.icon} style={{ fontSize: '24px' }} />
              </Stack.Item>
              <Stack.Item>
                <Box bold fontSize="0.75rem">
                  {item.name}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box fontSize="0.7rem" color="label">
                  {item.triumph_cost}
                </Box>
              </Stack.Item>
            </Stack>
          </Button>
        ))}
      </Box>
    </Section>
  );
};

