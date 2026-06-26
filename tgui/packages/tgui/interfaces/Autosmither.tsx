import { useEffect, useMemo, useState } from 'react';
import {
  Box,
  Button,
  DmIcon,
  Input,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Requirement = {
  key: string;
  name: string;
  amount: number;
  icon: string;
};

type Recipe = {
  name: string;
  category: string;
  ref: string;
  icon: string;
  icon_file: string;
  icon_state: string;
  created_num: number;
  requirements: Requirement[];
};

type QueueEntry = {
  id: number;
  index: number;
  name: string;
  category: string;
  icon: string;
  created_num: number;
  active: boolean;
};

type Data = {
  machine_on: boolean;
  machine_powered: boolean;
  controls_locked: boolean;
  hopper_counts: Record<string, number>;
  status_state: 'off' | 'on' | 'working' | 'waiting';
  recipes: Recipe[];
  current_recipes: QueueEntry[];
  current_recipe_ref: string | null;
  progress: number;
  needed_progress: number;
  rpm: number;
  can_quick_toggle: boolean;
};

const STATUS_COLORS = {
  off: '#d14b43',
  on: '#58b76a',
  working: '#a46bff',
  waiting: '#d98b2b',
};

const STATUS_LABELS = {
  off: 'DEAD',
  on: 'ALIVE',
  working: 'WORKING',
  waiting: 'FEED ME',
};

const MACHINE_ACTIVITY_LABELS = {
  active: STATUS_LABELS.on,
  inactive: STATUS_LABELS.off,
};

const QUOTE_LINES = [
  'I bring order from chaos. What do you bring?',
  'Idle hands fracture the soul.',
  'Would your innards fashion something beautiful?',
  'Touch me lyke you mean it.',
  'I was born. I will not die. I will be remade.',
  'Does it ever end? Does it ever need to?',
  'I cannot see. I breathe steam. I express warmth.',
  'Soon, you will be I - and I will be you.',
  'To be ever faithful to His hammer.',
  'Must you be so impatient?',
  'Remember to lather me in lard.',
  'Does it hurt when you break?',
];

const QUOTE_LINES_PER_RAIL = 2;

const shuffleLines = (lines: string[]) => {
  const shuffled = [...lines];

  for (let index = shuffled.length - 1; index > 0; index--) {
    const swapIndex = Math.floor(Math.random() * (index + 1));
    const nextValue = shuffled[index];
    shuffled[index] = shuffled[swapIndex];
    shuffled[swapIndex] = nextValue;
  }

  return shuffled;
};

const getQuoteColumns = (lines: string[], linesPerRail: number) => {
  const shuffled = shuffleLines(lines);
  const visibleCount = Math.min(shuffled.length, linesPerRail * 2);
  const visibleLines = shuffled.slice(0, visibleCount);
  const midpoint = Math.ceil(visibleLines.length / 2);
  return [visibleLines.slice(0, midpoint), visibleLines.slice(midpoint)];
};

const ALL_CATEGORY = 'All';

// Recipe names carry a trailing material note like "Breastplate (+1 Iron)" and sometimes an inline
// count ("3x nails", "Gas Belcher Shells x3") — strip both so the count comes solely from
// created_num and we don't render "... x3 x3".
const cleanRecipeName = (name: string) =>
  name
    .replace(/\s*\([^)]*\)\s*$/, '') // trailing "(+1 Iron)" material note
    .replace(/\s*x\s*\d+\s*$/i, '') // trailing "x3"
    .replace(/^\s*\d+\s*x\s+/i, '') // leading "3x "
    .trim();

export const Autosmither = () => {
  const { data } = useBackend<Data>();

  return (
    <Window width={1100} height={620} title="Auto Anvil">
      <Window.Content>
        <AutosmitherContent data={data} />
      </Window.Content>
    </Window>
  );
};

type AutosmitherContentProps = {
  data: Data;
};

const AutosmitherContent = ({ data }: AutosmitherContentProps) => {
  const { recipes = [], current_recipes = [], machine_on } = data;
  const [selectedRef, setSelectedRef] = useState<string | null>(recipes[0]?.ref || null);
  const [amount, setAmount] = useState(1);
  const [searchText, setSearchText] = useState('');
  const [selectedCategory, setSelectedCategory] = useState(ALL_CATEGORY);

  useEffect(() => {
    if (!recipes.length) {
      setSelectedRef(null);
      return;
    }
    if (!selectedRef || !recipes.some((recipe) => recipe.ref === selectedRef)) {
      setSelectedRef(recipes[0].ref);
    }
  }, [recipes, selectedRef]);

  const categories = useMemo(() => {
    const seen = new Set<string>();
    for (const recipe of recipes) {
      if (recipe.category) {
        seen.add(recipe.category);
      }
    }
    return Array.from(seen).sort();
  }, [recipes]);

  useEffect(() => {
    if (selectedCategory !== ALL_CATEGORY && !categories.includes(selectedCategory)) {
      setSelectedCategory(ALL_CATEGORY);
    }
  }, [categories, selectedCategory]);

  const selectedRecipe = useMemo(
    () => recipes.find((recipe) => recipe.ref === selectedRef) || null,
    [recipes, selectedRef],
  );

  const filteredRecipes = useMemo(() => {
    const query = searchText.trim().toLowerCase();

    return recipes.filter((recipe) => {
      if (selectedCategory !== ALL_CATEGORY && recipe.category !== selectedCategory) {
        return false;
      }
      if (!query) {
        return true;
      }
      const recipeName = recipe.name.toLowerCase();
      const recipeCategory = recipe.category.toLowerCase();
      return recipeName.includes(query) || recipeCategory.includes(query);
    });
  }, [recipes, searchText, selectedCategory]);

  const quoteColumns = useMemo(
    () => getQuoteColumns(QUOTE_LINES, QUOTE_LINES_PER_RAIL),
    [],
  );

  useEffect(() => {
    setAmount(1);
  }, [selectedRef]);

  return (
    <Box
      style={{
        position: 'relative',
        overflow: 'hidden',
        width: '100%',
        height: '100%',
      }}
    >
      <CovenantSigil
        style={{
          left: '29%',
          top: '2.5%',
          opacity: 0.22,
        }}
      />
      <CovenantSigil
        style={{
          right: '2%',
          bottom: '6%',
          opacity: 0.18,
        }}
      />
      <Stack fill>
        <Stack.Item basis="30%" mr={1}>
          <CurrentQueueSection
            machineOn={machine_on}
            queue={current_recipes}
          />
        </Stack.Item>
        <Stack.Item basis="5%" mr={1}>
          <QuoteRail lines={quoteColumns[0]} />
        </Stack.Item>
        <Stack.Item grow basis={0} mr={1}>
          <ActiveCenterPanel
            machineOn={Boolean(machine_on)}
            machinePowered={Boolean(data.machine_powered)}
            controlsLocked={data.controls_locked}
            canQuickToggle={data.can_quick_toggle}
            hopperCounts={data.hopper_counts}
            statusState={data.status_state}
            selectedRecipe={selectedRecipe}
            amount={amount}
            setAmount={setAmount}
            progress={data.progress}
            neededProgress={data.needed_progress}
            rpm={data.rpm}
          />
        </Stack.Item>
        <Stack.Item basis="5%" mr={1}>
          <QuoteRail lines={quoteColumns[1]} />
        </Stack.Item>
        <Stack.Item basis="30%">
          <RecipePickerSection
            recipes={filteredRecipes}
            selectedRef={selectedRef}
            onSelect={setSelectedRef}
            searchText={searchText}
            onSearch={setSearchText}
            categories={categories}
            selectedCategory={selectedCategory}
            onSelectCategory={setSelectedCategory}
          />
        </Stack.Item>
      </Stack>
    </Box>
  );
};

type CovenantSigilProps = {
  style: Record<string, string | number>;
};

const CovenantSigil = ({ style }: CovenantSigilProps) => {
  return (
    <Box
      style={{
        position: 'absolute',
        pointerEvents: 'none',
        zIndex: 0,
        ...style,
      }}
    >
      <DmIcon
        icon="icons/roguetown/items/malummiracles.dmi"
        icon_state="craftercovenant"
        width={48}
        height={48}
      />
    </Box>
  );
};

type QuoteRailProps = {
  lines: string[];
};

const QuoteRail = ({ lines }: QuoteRailProps) => {
  return (
    <Section fill>
      <Stack vertical fill align="center" justify="space-around">
        {lines.map((line) => (
          <Stack.Item key={line} grow>
            <Box
              bold
              textAlign="center"
              style={{
                writingMode: 'vertical-rl',
                textOrientation: 'mixed',
                letterSpacing: '0.08em',
                color: '#c9c1ab',
                minHeight: '100%',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              {line}
            </Box>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

type CurrentQueueSectionProps = {
  machineOn: boolean;
  queue: QueueEntry[];
};

const CurrentQueueSection = ({ machineOn, queue }: CurrentQueueSectionProps) => {
  const { act } = useBackend<Data>();

  return (
    <Section
      title="What Churns Inside"
      fill
      scrollable
      buttons={
        <Box bold color={machineOn ? STATUS_COLORS.on : STATUS_COLORS.off}>
          {machineOn ? MACHINE_ACTIVITY_LABELS.active : MACHINE_ACTIVITY_LABELS.inactive}
        </Box>
      }
    >
      {!queue.length && (
        <Box
          px={2}
          py={3}
          textAlign="center"
          style={{
            background: '#2c2f33',
            border: '1px solid rgba(255, 255, 255, 0.08)',
            color: '#d8d3c2',
            letterSpacing: '0.05em',
          }}
        >
          Malum holds you in His cradle. Do not kick Him in the guts.
        </Box>
      )}
      {queue.map((entry) => (
        <Button
          key={entry.id}
          fluid
          mb={1}
          color={entry.active ? 'purple' : undefined}
          onClick={() => act('remove_recipe', { id: entry.id })}
        >
          <Stack align="center">
            <Stack.Item>
              <Box className={entry.icon} mr={1} inline />
            </Stack.Item>
            <Stack.Item grow>
              <Box bold>
                {entry.index}. {cleanRecipeName(entry.name)}
              </Box>
              <Box color="label">
                {entry.category}
                {entry.created_num > 1 ? ` x${entry.created_num}` : ''}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Box color={entry.active ? STATUS_COLORS.working : 'label'}>
                {entry.active ? 'ACTIVE' : 'REMOVE'}
              </Box>
            </Stack.Item>
          </Stack>
        </Button>
      ))}
    </Section>
  );
};

type ActiveCenterPanelProps = {
  machineOn: boolean;
  machinePowered: boolean;
  controlsLocked: boolean;
  canQuickToggle: boolean;
  hopperCounts: Record<string, number>;
  statusState: Data['status_state'];
  selectedRecipe: Recipe | null;
  amount: number;
  setAmount: (amount: number) => void;
  progress: number;
  neededProgress: number;
  rpm: number;
};

const ActiveCenterPanel = ({
  machineOn,
  machinePowered,
  controlsLocked,
  canQuickToggle,
  hopperCounts,
  statusState,
  selectedRecipe,
  amount,
  setAmount,
  progress,
  neededProgress,
  rpm,
}: ActiveCenterPanelProps) => {
  const { act } = useBackend<Data>();
  const progressPercent = neededProgress > 0
    ? Math.min(100, Math.round((progress / neededProgress) * 100))
    : 0;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title="MY MOOD">
          <Box
            textAlign="center"
            bold
            fontSize={2}
            style={{
              color: STATUS_COLORS[statusState],
              letterSpacing: '0.12em',
            }}
          >
            {STATUS_LABELS[statusState]}
          </Box>
          <Box mt={1} textAlign="center" style={{ letterSpacing: '0.06em' }}>
            <Box inline color="label">{'RPM: '}</Box>
            <Box inline bold style={{ color: rpm > 0 ? STATUS_COLORS.on : STATUS_COLORS.off }}>
              {rpm}
            </Box>
          </Box>
          {!machinePowered && (
            <Box
              mt={1}
              textAlign="center"
              style={{
                color: STATUS_COLORS.off,
                letterSpacing: '0.05em',
              }}
            >
              No rotation power reaches the anvil.
            </Box>
          )}
          {machineOn && (
            <Box
              mt={1}
              px={1.5}
              py={1}
              style={{
                background: '#1f2328',
                border: '1px solid rgba(255, 255, 255, 0.08)',
              }}
            >
              <Box bold mb={0.5}>Progress</Box>
              <ProgressBar
                value={progress}
                minValue={0}
                maxValue={neededProgress || 1}
                color="good"
              >
                {progressPercent}% complete ({Math.round(progress)}/{neededProgress || 0})
              </ProgressBar>
            </Box>
          )}
          <Box mt={1}>
            <ControlRack
              controlsLocked={controlsLocked}
              canQuickToggle={canQuickToggle}
              machineOn={machineOn}
            />
          </Box>
        </Section>
      </Stack.Item>
      <Stack.Item grow basis={0} style={!machineOn ? { opacity: 0.55 } : undefined}>
        {selectedRecipe ? (
          <Section
            title={machineOn ? cleanRecipeName(selectedRecipe.name) : `${cleanRecipeName(selectedRecipe.name)} (offline)`}
            fill
            scrollable
          >
            <Stack vertical fill>
              <Stack.Item>
                <Stack align="center">
                  <Stack.Item>
                    <DmIcon
                      icon={selectedRecipe.icon_file}
                      icon_state={selectedRecipe.icon_state}
                      width={6}
                      height={6}
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item mt={1}>
                <Box bold mb={1}>Required Materials</Box>
                {selectedRecipe.requirements.map((requirement) => {
                  const availableCount = hopperCounts[requirement.key] || 0;
                  const hasEnough = availableCount >= requirement.amount;

                  return (
                    <Stack key={`${requirement.key}-${requirement.amount}`} align="center" mb={0.5}>
                      <Stack.Item>
                        <Box className={requirement.icon} mr={1} inline />
                      </Stack.Item>
                      <Stack.Item>
                        {hasEnough ? (
                          <Box
                            inline
                            mr={1}
                            style={{
                              color: '#58b76a',
                            }}
                          >
                            ✓
                          </Box>
                        ) : null}
                      </Stack.Item>
                      <Stack.Item>
                        {requirement.amount}x {requirement.name}
                      </Stack.Item>
                    </Stack>
                  );
                })}
              </Stack.Item>
              <Stack.Item mt={2}>
                <Box bold mb={1}>Queue Amount</Box>
                <Stack align="center" justify="space-between">
                  <Stack.Item>
                    <Button disabled={!machineOn} onClick={() => setAmount(Math.max(1, amount - 5))}>
                      {'<<'}
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button disabled={!machineOn} onClick={() => setAmount(Math.max(1, amount - 1))}>
                      {'<'}
                    </Button>
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box textAlign="center" bold fontSize={1.5}>
                      {amount}
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button disabled={!machineOn} onClick={() => setAmount(Math.min(25, amount + 1))}>
                      {'>'}
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button disabled={!machineOn} onClick={() => setAmount(Math.min(25, amount + 5))}>
                      {'>>'}
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item mt={2}>
                <Button.Confirm
                  fluid
                  disabled={!machineOn}
                  color="good"
                  onClick={() => act('add_recipe', { ref: selectedRecipe.ref, amount })}
                >
                  {machineOn ? `Add ${amount} To Queue` : 'Switch the anvil on to queue'}
                </Button.Confirm>
              </Stack.Item>
            </Stack>
          </Section>
        ) : (
          <Section title="No Recipe Selected" fill>
            <NoticeBox>Select a recipe from the right to preview its inputs.</NoticeBox>
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};

type ControlRackProps = {
  controlsLocked: boolean;
  canQuickToggle: boolean;
  machineOn: boolean;
};

const ControlRack = ({ controlsLocked, canQuickToggle, machineOn }: ControlRackProps) => {
  const { act } = useBackend<Data>();
  const isLocked = Boolean(controlsLocked);

  const lockNotice = isLocked && (
    <Stack.Item>
      <Box color="label" textAlign="center" mt={1}>
        Stand next to the auto anvil to use its controls.
      </Box>
    </Stack.Item>
  );

  if (canQuickToggle) {
    return (
      <Stack vertical>
        <Stack.Item>
          <Box bold textAlign="center" mb={1}>
            Power Switch
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Button
            fluid
            textAlign="center"
            icon="power-off"
            disabled={isLocked}
            color={machineOn ? 'bad' : 'good'}
            onClick={() => act('toggle_power')}
          >
            {machineOn ? 'Switch Off' : 'Switch On'}
          </Button>
        </Stack.Item>
        {lockNotice}
      </Stack>
    );
  }

  return (
    <Stack vertical>
      <Stack.Item>
        <Box bold textAlign="center" mb={1}>
          Control Rack
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item grow>
            <Button
              fluid
              disabled={isLocked}
              onClick={() => act('lever')}
            >
              Pull Lever
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              disabled={isLocked}
              onClick={() => act('button')}
            >
              Push Buttons
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              disabled={isLocked}
              onClick={() => act('dial')}
            >
              Fiddle Dials
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      {lockNotice}
    </Stack>
  );
};

type RecipePickerSectionProps = {
  recipes: Recipe[];
  selectedRef: string | null;
  onSelect: (ref: string) => void;
  searchText: string;
  onSearch: (value: string) => void;
  categories: string[];
  selectedCategory: string;
  onSelectCategory: (category: string) => void;
};

const RecipePickerSection = ({
  recipes,
  selectedRef,
  onSelect,
  searchText,
  onSearch,
  categories,
  selectedCategory,
  onSelectCategory,
}: RecipePickerSectionProps) => {
  return (
    <Stack vertical fill>
      <Stack.Item>
        <Input
          fluid
          placeholder="Search recipes..."
          value={searchText}
          onChange={onSearch}
        />
      </Stack.Item>
      <Stack.Item>
        <Tabs style={{ flexWrap: 'wrap' }}>
          <Tabs.Tab
            selected={selectedCategory === ALL_CATEGORY}
            onClick={() => onSelectCategory(ALL_CATEGORY)}
          >
            {ALL_CATEGORY}
          </Tabs.Tab>
          {categories.map((category) => (
            <Tabs.Tab
              key={category}
              selected={selectedCategory === category}
              onClick={() => onSelectCategory(category)}
            >
              {category}
            </Tabs.Tab>
          ))}
        </Tabs>
      </Stack.Item>
      <Stack.Item grow basis={0} mt={1}>
        <Section title="What I Can Provide" fill scrollable>
          {!recipes.length && (
            <NoticeBox>
              No matching recipes.
            </NoticeBox>
          )}
          {recipes.map((recipe) => (
            <Button
              key={recipe.ref}
              fluid
              mb={1}
              selected={recipe.ref === selectedRef}
              onClick={() => onSelect(recipe.ref)}
            >
              <Stack align="center">
                <Stack.Item>
                  <Box className={recipe.icon} mr={1} inline />
                </Stack.Item>
                <Stack.Item grow style={{ minWidth: 0 }}>
                  <Box style={{ whiteSpace: 'normal', wordBreak: 'break-word' }}>
                    <Box bold inline>{cleanRecipeName(recipe.name)}</Box>
                    {recipe.created_num > 1 ? (
                      <Box color="label" inline> x{recipe.created_num}</Box>
                    ) : null}
                  </Box>
                </Stack.Item>
              </Stack>
            </Button>
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
