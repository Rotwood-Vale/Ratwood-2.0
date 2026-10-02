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
  category: string | null;
  granted: boolean;
  locked: boolean;
  unlock: string;
  donoritem: boolean;
  ref: string;
  icon: string;
};

type Data = {
  loadout_items: LoadoutItem[];
};

export const LoadoutMenu = (props) => {
  return (
    <Window width={800} height={600}>
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
      return item.donoritem;
    })
    .filter((item) => {
      if (search) {
        return item.name.toLowerCase().includes(search.toLowerCase());
      } else {
        return true;
      }
    })
    .sort((a, b) => Number(b.granted) - Number(a.granted));

  return (
    <Section
      title="Items"
      fill
      scrollable
      buttons={<SearchBar search={search} setSearch={setSearch} />}
    >
      {availableItems.map((item) => (
        <Button
          key={item.ref}
          fluid
          style={
            item.granted
              ? {
                  background: 'rgba(201, 169, 110, 0.12)',
                  border: '1px solid rgba(201, 169, 110, 0.35)',
                }
              : undefined
          }
          disabled={!!item.locked}
          onClick={() => act('choose_item', { ref: item.ref })}
        >
          <Stack align="center">
            <Stack.Item>
             <Box className={item.icon} mr={2} inline />
            </Stack.Item>
            <Stack.Item>
             {item.name}
             {!!item.locked && (
               <Box inline ml={1} color="grey">
                 LOCKED ({item.unlock})
               </Box>
             )}
            </Stack.Item>
          </Stack>
          <Stack align="center">
            <Stack.Item>
             {item.desc}
            </Stack.Item>
          </Stack>
        </Button>
      ))}
    </Section>
  );
};
