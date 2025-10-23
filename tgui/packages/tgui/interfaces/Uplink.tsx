import { Box, Button, Flex, LabeledList, NoticeBox, Section, Stack, Tabs } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

interface Item {
  name: string;
  desc: string;
  cost: number;
}

interface Category {
  name: string;
}

interface Data {
  telecrystals: number;
  lockable: boolean;
  selectedCat?: string | null;
  categories: Category[];
  items: Item[];
  challenge?: boolean;
  challengeAccepted?: boolean;
}

const UI_VERSION = 'v-challenge-compact-5b';

export const Uplink = () => {
  const { data, act } = useBackend<Data>();
  const { telecrystals, categories = [], items = [], selectedCat, challenge, challengeAccepted } = data;
  const isChallenge = ((selectedCat || '').toLocaleLowerCase().trim() === 'challenge') || !!challenge;
  // Split out Challenge from normal categories so we can render it on the right side
  const leftCategories = categories.filter((c) => c.name.toLocaleLowerCase().trim() !== 'challenge');
  const hasChallenge = categories.some((c) => c.name.toLocaleLowerCase().trim() === 'challenge') || !!challenge;

  // Simple, solid background for reliability
  const contentStyle: React.CSSProperties = {
    backgroundColor: '#4F0909',
  };

  return (
    <Window width={900} height={640}>
      <Window.Content style={contentStyle} className="UplinkBackground">
        {/* Background insignia overlay (inline to ensure visibility and color control) */}
        <Box
          style={{
            position: 'absolute',
            inset: 0,
            backgroundImage: 'url(/insignia.png)',
            backgroundRepeat: 'no-repeat',
            backgroundPosition: 'center center',
            backgroundSize: '65% auto',
            filter: 'brightness(0) saturate(100%)',
            opacity: 0.22,
            pointerEvents: 'none',
          }}
        />
        <Box style={{ height: '100%' }}>
        <Stack vertical fill>
          <Stack.Item>
            <Section title={`Crystal Rosas: ${telecrystals}`} style={{ background: 'transparent', color: '#f8eaea' }}>
              {leftCategories.length === 0 && !hasChallenge && (
                <NoticeBox>No items available.</NoticeBox>
              )}
              {(leftCategories.length > 0 || hasChallenge) && (
                <Flex justify="space-between" align="center">
                  <Flex.Item>
                    <Tabs>
                      {leftCategories.map((cat) => (
                        <Tabs.Tab
                          key={cat.name}
                          selected={cat.name === selectedCat}
                          onClick={() => act('select', { category: cat.name })}
                        >
                          {cat.name}
                        </Tabs.Tab>
                      ))}
                    </Tabs>
                  </Flex.Item>
                  <Flex.Item>
                    <Flex align="center" justify="flex-end" gap={1}>
                      {hasChallenge && (
                        <Tabs>
                          <Tabs.Tab
                            key="challenge"
                            selected={isChallenge}
                            onClick={() => act('select', { category: 'Challenge' })}
                          >
                            Challenge
                          </Tabs.Tab>
                        </Tabs>
                      )}
                    </Flex>
                  </Flex.Item>
                </Flex>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section title={selectedCat || 'Items'} fill scrollable style={{ background: 'transparent', color: '#f8eaea' }}>
              {/* Challenge description / info area will appear only on the Challenge tab */}
              {isChallenge ? (
                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', height: '100%', gap: 12 }}>
                  <div style={{ maxWidth: 640, textAlign: 'center', fontSize: 14, opacity: 0.95 }}>
                    <strong>The Crimson Rosa Challenge Mode</strong>
                    <br />
                    <span>
                      The Crimson Rosa values the brave, and the valiant. The great, and the cunning. The bold.
                      <br /><br />
                      Do you believe you got what it takes to become truly one of us?
                      <br /><br />
                      Do you believe you got what it takes to forfeit your place among the meek?
                      <br /><br />
                      Show them true art.
                      <br /><br />
                      You musn&#39;t have used any of your crystal rosas yet.
                      <br /><br />

                      Accepting the Challenge will give you Critical Fragility, apply the Mask of the Crimson Order to your face, and remove all your crystal rosas.
                      <br /><br />
                      Completing this Challenge will reward you with 20 Triumphs, and a special title.
                    </span>
                  </div>
                  <div
                    onClick={() => {
                      if (!challengeAccepted) act('accept_challenge');
                    }}
                    style={{
                      display: 'inline-block',
                      width: 120,
                      height: 24,
                      lineHeight: '24px',
                      textAlign: 'center',
                      fontSize: 12,
                      color: '#fff',
                      background: challengeAccepted ? '#666' : '#a00',
                      border: '1px solid #000',
                      borderRadius: 2,
                      cursor: challengeAccepted ? 'default' : 'pointer',
                      userSelect: 'none',
                      minWidth: 0,
                      minHeight: 0,
                      padding: 0,
                    }}
                  >
                    {challengeAccepted ? 'Accepted' : 'I ACCEPT'}
                  </div>
                </div>
              ) : items.length === 0 ? (
                <NoticeBox>Nothing to buy here.</NoticeBox>
              ) : (
                <LabeledList>
                  {items.map((item) => {
                    const canBuy = telecrystals >= item.cost;
                    return (
                      <LabeledList.Item key={item.name} label={`${item.name} (${item.cost} CR)`}>
                        <Flex direction="row" justify="space-between" align="center">
                          <Flex.Item grow>{item.desc}</Flex.Item>
                          <Flex.Item>
                            <Button
                              onClick={() => act('buy', { name: item.name })}
                              disabled={!canBuy}
                              color={canBuy ? 'good' : 'secondary'}
                            >
                              Buy
                            </Button>
                          </Flex.Item>
                        </Flex>
                      </LabeledList.Item>
                    );
                  })}
                </LabeledList>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section>
              <Button onClick={() => act('close')} ml={1} color="average">
                Close
              </Button>
            </Section>
          </Stack.Item>
        </Stack>
        </Box>
      </Window.Content>
    </Window>
  );
};
