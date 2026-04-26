import { useState } from 'react';
import {
  Box,
  Button,
  Divider,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type ShopItem = {
  name: string;
  desc: string;
  cost: number;
  stock: number;
  bought: number;
  buy_limit?: number;
};

type Data = {
  budget: number;
  is_flinger: BooleanLike;
  trader_name: string;
  ticks_to_restock: number;
  shared: ShopItem[];
  exclusive: ShopItem[];
  flinger: ShopItem[];
};

type TabName = 'shared' | 'exclusive' | 'flinger';

export const UnderbellyShop = () => {
  const { act, data } = useBackend<Data>();
  const {
    budget,
    is_flinger,
    trader_name,
    ticks_to_restock,
    shared,
    exclusive,
    flinger,
  } = data;

  const [tab, setTab] = useState<TabName>('shared');

  const secondsLeft = Math.floor(ticks_to_restock / 10);
  const minutesLeft = Math.floor(secondsLeft / 60);
  const secondsPart = secondsLeft % 60;
  const restockLabel =
    ticks_to_restock > 0
      ? `Restock in ${minutesLeft}m ${secondsPart}s`
      : 'Restocking soon...';

  return (
    <Window title={trader_name} width={480} height={560}>
      <Window.Content>
        <Section
          title={trader_name}
          buttons={
            <Box color="good" bold>
              {budget} mammon
            </Box>
          }
        >
          <Box color="average" mb={1}>
            {restockLabel}
          </Box>
          <Tabs>
            <Tabs.Tab selected={tab === 'shared'} onClick={() => setTab('shared')}>
              Wot I got right now.
            </Tabs.Tab>
            <Tabs.Tab
              selected={tab === 'exclusive'}
              onClick={() => setTab('exclusive')}
            >
              EXCLUSIVES, Just for YOU.
            </Tabs.Tab>
            {!!is_flinger && (
              <Tabs.Tab
                selected={tab === 'flinger'}
                onClick={() => setTab('flinger')}
              >
                A Flinger, ey?
              </Tabs.Tab>
            )}
          </Tabs>
          <Divider />
          {tab === 'shared' && (
            <ItemList items={shared} act_name="buy_shared" budget={budget} />
          )}
          {tab === 'exclusive' && (
            <ItemList
              items={exclusive}
              act_name="buy_exclusive"
              budget={budget}
            />
          )}
          {tab === 'flinger' && !!is_flinger && (
            <ItemList items={flinger} act_name="buy_flinger" budget={budget} />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

type ItemListProps = {
  items: ShopItem[];
  act_name: string;
  budget: number;
};

const ItemList = ({ items, act_name, budget }: ItemListProps) => {
  const { act } = useBackend<Data>();

  if (!items || items.length === 0) {
    return <NoticeBox>Nothing here right now.</NoticeBox>;
  }

  return (
    <Stack vertical>
      {items.map((item) => {
        const limit = item.buy_limit ?? 1;
        const exhausted = item.stock <= 0 || item.bought >= limit;
        const cantAfford = budget < item.cost;
        return (
          <Stack.Item key={item.name}>
            <Stack align="center">
              <Stack.Item grow>
                <Box bold={!exhausted} color={exhausted ? 'bad' : 'white'}>
                  {item.name}
                </Box>
                <Box color="label" fontSize="0.85em">
                  {item.desc}
                </Box>
                <Box color="average" fontSize="0.85em">
                  {item.cost} mammon &mdash; {item.stock} left
                  {limit > 1 ? ` (limit ${limit})` : ''}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Button
                  disabled={exhausted || cantAfford}
                  color={exhausted ? 'bad' : cantAfford ? 'average' : 'good'}
                  onClick={() => act(act_name, { name: item.name })}
                >
                  {exhausted ? 'Out' : cantAfford ? 'No coin' : 'Buy'}
                </Button>
              </Stack.Item>
            </Stack>
            <Divider />
          </Stack.Item>
        );
      })}
    </Stack>
  );
};
