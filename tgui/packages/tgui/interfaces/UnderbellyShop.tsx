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
  shipments: ShopItem[];
  demand_items: string[];
  job: string;
};

type TabName = 'shared' | 'exclusive' | 'flinger' | 'shipments' | 'help';

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
    shipments,
    demand_items,
    job,
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
      <Window.Content scrollable>
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
          {demand_items && demand_items.length > 0 && (
            <NoticeBox mb={1}>
              <b>Paying top coin for:</b> {demand_items.join(', ')}
            </NoticeBox>
          )}
          <Tabs>
            <Tabs.Tab
              selected={tab === 'shared'}
              onClick={() => {
                setTab('shared');
                act('tab_changed', { tab: 'main' });
              }}
            >
              Wot I got right now.
            </Tabs.Tab>
            <Tabs.Tab
              selected={tab === 'exclusive'}
              onClick={() => {
                setTab('exclusive');
                act('tab_changed', { tab: 'exclusive' });
              }}
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
            {!!is_flinger && (
              <Tabs.Tab
                selected={tab === 'shipments'}
                onClick={() => setTab('shipments')}
              >
                Shipments.
              </Tabs.Tab>
            )}
            <Tabs.Tab
              selected={tab === 'help'}
              onClick={() => setTab('help')}
            >
              Need help?
            </Tabs.Tab>
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
          {tab === 'shipments' && !!is_flinger && (
            <ItemList
              items={shipments}
              act_name="buy_shipment"
              budget={budget}
            />
          )}
          {tab === 'help' && <HelpTab job={job} />}
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

type HelpEntry = { header: string; body: string };

const JOB_HINTS: Record<string, HelpEntry[]> = {
  Scum: [
    {
      header: 'Your role',
      body: "You're an enforcer and protector of the Underbelly. Keep the faction's turf secure, deal with threats, and make sure the operation keeps running.",
    },
    {
      header: 'Funding your arsenal',
      body: 'Deposit mammon into the chute near the Taxman. That coin goes into your personal budget to buy from this shop.',
    },
    {
      header: 'Faction debt',
      body: "The Syndicate is owed a debt each week. Everyone pitches in - check the Taxman to see how much is left. Paying it off unlocks rebate drops at 25%, 50%, and 75%.",
    },
    {
      header: 'Smuggler train',
      body: 'A train drops contraband crates at landmarks on a timer. Some have weapons or coin - worth keeping an eye on.',
    },
  ],
  Flinger: [
    {
      header: 'Dead drop contracts',
      body: 'Buy contracts from the Flinger tab. Hand one to a non-Scum outsider. They read it to memorize the route, hand it back to you, then go retrieve the parcel. Once delivered to the Trader, you cash the contract for 450-750 mammon.',
    },
    {
      header: 'Memorizing the route',
      body: "The runner - not you - uses the contract on themselves to lock the route into their memory. After that they don't need to carry it. Hand it back once they've read it.",
    },
    {
      header: 'Streak bonus',
      body: 'Cash 3 contracts within 35 minutes of each other for a streak bonus on each. If 35 minutes pass between any two, the streak resets.',
    },
    {
      header: 'Selling to the Trader',
      body: 'Hand valuable items (50+ mammon base value) directly to the Trader for a 2.5x payout. Check "Paying top coin for" at the top - demanded items get an extra boost on top of that.',
    },
    {
      header: 'Sale cap',
      body: 'The Trader cuts you off at 2200 mammon per 10-minute window. Flood the market and you wait.',
    },
  ],
  Consigliere: [
    {
      header: 'Dead drop income',
      body: 'You can cash dead drop contracts and sell high-value items (2.2x multiplier) to the Trader - same as a Flinger but slightly lower cut. Buy contracts from the Flinger tab.',
    },
    {
      header: 'Shop access',
      body: 'You have access to the Flinger tab. Exclusives and role-specific items are open to you.',
    },
    {
      header: 'Debt management',
      body: 'Help the Gutter King keep an eye on faction debt. Rebate drops at 25/50/75% paid land at the Taxman - first one there gets it.',
    },
  ],
  'Gutter King': [
    {
      header: 'Full shop access',
      body: 'You have access to every tab including Flinger exclusives. You can also cash dead drop contracts at a 1.9x resale rate.',
    },
    {
      header: 'Managing debt',
      body: 'Faction debt is calculated from peak Scum count this week - it does not drop when Scum leave. Use the Taxman to track total owed vs paid.',
    },
    {
      header: 'Rebate drops',
      body: 'At 25%, 50%, and 75% of debt paid, a coin pile drops at the Taxman: 250, 500, and 900 mammon respectively. Each tier triggers once per week.',
    },
  ],
  Ripper: [
    {
      header: 'Lux trade',
      body: 'Hand lux or impure lux containers directly to the Trader for mammon. Only Rippers can sell lux.',
    },
    {
      header: 'Medical supply sales',
      body: 'Hand crafted potions and bandages to the Trader for coin - healthpots, manapots, antitoxin, Blood Red, Voss Serum, and bandage bundles all have a buy price. Capped at 300 mammon per 10 minutes.',
    },
    {
      header: 'Supply board',
      body: 'Check the supply board near your area. It posts 3 rotating requests every 25 minutes - hand matching items to the board for per-unit coin. New requests are announced when the board refreshes.',
    },
    {
      header: 'Sick patients',
      body: "When word comes through that someone's bleeding out, find them fast. Apply bandages, healthpots, or surgical tools to treat their wounds. Once they're stable they pay you and leave. You have 15 minutes before they go cold.",
    },
    {
      header: 'Faction debt',
      body: 'Same as any Scum - pitch in at the chute and keep an eye on the Taxman.',
    },
  ],
  Proletarius: [
    {
      header: 'Suffer',
      body: 'Suffer.',
    },
  ],
};

const HelpTab = ({ job }: { job: string }) => {
  const hints = JOB_HINTS[job];
  if (!hints) {
    return (
      <NoticeBox>No hints available for your role.</NoticeBox>
    );
  }
  return (
    <Stack vertical>
      {hints.map((hint) => (
        <Stack.Item key={hint.header}>
          <Box bold mb={0.5}>
            {hint.header}
          </Box>
          <Box color="label" mb={1}>
            {hint.body}
          </Box>
          <Divider />
        </Stack.Item>
      ))}
    </Stack>
  );
};
