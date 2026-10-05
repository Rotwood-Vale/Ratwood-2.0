import { useState } from 'react';
import {
  Box,
  Button,
  DmIcon,
  Icon,
  Input,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type IngredientData = {
  name: string;
  ref: string;
  runes: Record<string, number>;
  icon?: string;
  icon_state?: string;
};

type RecipeData = {
  name: string;
  skill: string;
  skill_met: boolean;
  base: 'water' | 'wine' | 'milk';
  high_tier: boolean;
  requires_rainbow: boolean;
  runes: Record<string, number>;
};

type VesselContent = {
  name: string;
  vol: number;
  color: string;
};

type VesselData = {
  name: string;
  cur: number;
  max: number;
  icon?: string;
  icon_state?: string;
  contents: VesselContent[];
};

type Data = {
  on: boolean;
  brewing: number;
  upgrade_lvl: number;
  base_type: 'water' | 'wine' | 'milk' | 'none';
  base_amount: number;
  base_need: number;
  ingredients: IngredientData[];
  total_runes: {
    red: number;
    green: number;
    blue: number;
    rainbow?: number;
  };
  matched_recipe: string | null;
  matched_base: 'water' | 'wine' | 'milk' | null;
  recipes: RecipeData[];
  user_has_ingredient_in_hand: boolean;

  synth_item: { name: string; icon: string; icon_state: string } | null;
  synth_vessel_1: VesselData | null;
  synth_vessel_2: VesselData | null;
  synth_result: { name: string; icon: string; icon_state: string } | null;
  matched_synth_recipe: string | null;
  matched_synth_desc: string | null;
};

const RUNE_COLORS: Record<string, { bg: string; border: string; text: string; label: string }> = {
  red: { bg: 'rgba(231, 76, 60, 0.25)', border: '#e74c3c', text: '#ff6b6b', label: 'Red' },
  green: { bg: 'rgba(46, 204, 113, 0.25)', border: '#2ecc71', text: '#5cd65c', label: 'Green' },
  blue: { bg: 'rgba(52, 152, 219, 0.25)', border: '#3498db', text: '#4da6ff', label: 'Blue' },
  rainbow: {
    bg: 'linear-gradient(135deg, rgba(255,0,0,0.35), rgba(0,255,0,0.35), rgba(0,0,255,0.35))',
    border: '#ff00ff',
    text: '#ffffff',
    label: 'Rainbow',
  },
};

const BASE_INFO = {
  water: { label: 'Water', color: '#3498db', icon: 'tint' },
  wine: { label: 'Wine', color: '#c0392b', icon: 'wine-glass-alt' },
  milk: { label: 'Milk', color: '#ecf0f1', icon: 'mug-hot' },
  none: { label: 'Empty', color: '#888', icon: 'flask' },
};

const LiquidBaseStatus = ({
  baseType,
  baseAmount,
  baseNeed,
  brewing,
}: {
  baseType: 'water' | 'wine' | 'milk' | 'none';
  baseAmount: number;
  baseNeed: number;
  brewing: number;
}) => {
  const currentBase = BASE_INFO[baseType] || BASE_INFO.none;
  const hasBase = baseAmount >= baseNeed && baseType !== 'none';

  return (
    <Box
      style={{
        padding: '8px 12px',
        backgroundColor: 'rgba(0, 0, 0, 0.4)',
        borderRadius: '4px',
        border: '1px solid #33261a',
      }}
    >
      <Stack align="center" justify="space-between">
        <Stack.Item>
          <Stack align="center">
            <Icon name={currentBase.icon} color={currentBase.color} mr={1} />
            <Box fontSize="0.95em" bold color={hasBase ? currentBase.color : '#e74c3c'}>
              Base: {currentBase.label} ({baseAmount} / {baseNeed} oz)
            </Box>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Box fontSize="0.85em" color="#888">
            {brewing > 0 ? (
              <span style={{ color: '#f39c12', fontWeight: 'bold' }}>Transmuting ({brewing}/3)...</span>
            ) : hasBase ? (
              <span style={{ color: '#5cd65c' }}>Ready</span>
            ) : (
              <span style={{ color: '#e74c3c' }}>Needs 60 oz base</span>
            )}
          </Box>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const WorkbenchSlot = ({
  item,
  canInsert,
  isBrewing,
  onInsert,
  onRemove,
}: {
  item?: IngredientData;
  canInsert: boolean;
  isBrewing: boolean;
  onInsert: () => void;
  onRemove: (ref: string) => void;
}) => {
  return (
    <div
      style={{
        width: '116px',
        height: '116px',
        backgroundImage: `url(${resolveAsset('alchemy_slot.png')})`,
        backgroundSize: '100% 100%',
        backgroundRepeat: 'no-repeat',
        imageRendering: 'pixelated',
        position: 'relative',
        padding: '8px',
        boxSizing: 'border-box',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'space-between',
        boxShadow: '0 4px 10px rgba(0, 0, 0, 0.7)',
      }}
    >
      {item ? (
        <>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', zIndex: 2 }}>
            <span
              style={{
                fontSize: '0.8em',
                fontWeight: 'bold',
                color: '#ffd700',
                lineHeight: '1.1em',
                maxWidth: '75px',
                wordBreak: 'break-word',
                textShadow: '0 1px 2px black',
              }}
            >
              {item.name}
            </span>
            <Button
              icon="times"
              color="danger"
              compact
              disabled={isBrewing}
              onClick={() => onRemove(item.ref)}
              style={{ padding: '1px 4px', fontSize: '9px' }}
            />
          </div>

          <div
            style={{
              position: 'absolute',
              top: '50%',
              left: '50%',
              transform: 'translate(-50%, -50%)',
              width: '64px',
              height: '64px',
              pointerEvents: 'none',
              zIndex: 1,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              filter: 'drop-shadow(0 2px 5px rgba(0,0,0,0.9))',
            }}
          >
            {item.icon && item.icon_state && (
              <div
                style={{
                  width: '32px',
                  height: '32px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  transform: 'scale(1.8)',
                  transformOrigin: 'center',
                }}
              >
                <DmIcon
                  icon={item.icon}
                  icon_state={item.icon_state}
                  style={{ width: '32px', height: '32px', imageRendering: 'pixelated' }}
                />
              </div>
            )}
          </div>

          <div style={{ display: 'flex', gap: '2px', flexWrap: 'wrap', zIndex: 2 }}>
            {['red', 'green', 'blue', 'rainbow'].map((color) => {
              const count = item.runes[color] || 0;
              if (count <= 0) return null;
              const cfg = RUNE_COLORS[color];
              const isRainbow = color === 'rainbow';
              return (
                <span
                  key={color}
                  style={{
                    padding: '1px 3px',
                    borderRadius: '2px',
                    background: cfg.bg,
                    border: `1px solid ${cfg.border}`,
                    fontSize: '0.7em',
                    color: cfg.text,
                    fontWeight: 'bold',
                    textShadow: isRainbow ? '0 0 4px #ff00ff' : 'none',
                  }}
                >
                  {isRainbow ? `★ ${count}` : `${count}${cfg.label[0]}`}
                </span>
              );
            })}
          </div>
        </>
      ) : (
        <Button
          fluid
          color="transparent"
          disabled={!canInsert || isBrewing}
          onClick={onInsert}
          style={{
            height: '100%',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            background: 'none',
          }}
        >
          <Icon name="plus" size={1.6} color="#666" style={{ filter: 'drop-shadow(0 1px 2px black)' }} />
          <Box fontSize="0.75em" color="#888" mt={0.5}>
            Add
          </Box>
        </Button>
      )}
    </div>
  );
};

const RuneFlasks = ({ totalRunes }: { totalRunes: Record<string, number> }) => {
  return (
    <Box
      style={{
        padding: '12px 10px',
        backgroundColor: 'rgba(10, 8, 7, 0.85)',
        borderRadius: '8px',
        border: '1px solid #33261a',
      }}
    >
      <Box textAlign="center" color="#8a7662" fontSize="0.85em" bold mb={1}>
        HIGH CONCENTRATION ESSENCES
      </Box>

      <div style={{ width: '210px', height: '120px', position: 'relative', margin: '0 auto' }}>
        <div
          style={{
            position: 'absolute',
            top: '50px',
            bottom: '9px',
            left: '13px',
            right: '12px',
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'flex-end',
            zIndex: 1,
            padding: '0 8px',
          }}
        >
          {(['red', 'green', 'blue'] as const).map((color) => {
            const count = totalRunes[color] || 0;
            const cfg = RUNE_COLORS[color];
            const fillPercent = Math.min(100, (count / 6) * 100);

            return (
              <div key={color} style={{ width: '38px', height: '100%', display: 'flex', alignItems: 'flex-end' }}>
                <div
                  style={{
                    width: '100%',
                    height: `${fillPercent}%`,
                    backgroundColor: cfg.border,
                    borderRadius: '0 0 10px 10px',
                    opacity: 0.85,
                    transition: 'height 0.4s ease',
                    boxShadow: `0 0 12px ${cfg.border}`,
                  }}
                />
              </div>
            );
          })}
        </div>

        <img
          src={resolveAsset('alchemy_layer.png')}
          style={{
            position: 'absolute',
            top: 0,
            left: 0,
            width: '100%',
            height: '100%',
            imageRendering: 'pixelated',
            pointerEvents: 'none',
            zIndex: 2,
            opacity: 0.5,
            mixBlendMode: 'multiply',
          }}
        />

        <img
          src={resolveAsset('alchemy_colb.png')}
          style={{
            position: 'absolute',
            top: 0,
            left: -1,
            width: '100%',
            height: '100%',
            imageRendering: 'pixelated',
            pointerEvents: 'none',
            zIndex: 3,
          }}
        />
      </div>

      <div style={{ display: 'flex', justifyContent: 'center', gap: '38px', marginTop: '6px' }}>
        {(['red', 'green', 'blue'] as const).map((color) => (
          <div key={color} style={{ textAlign: 'center', width: '40px' }}>
            <div style={{ fontWeight: 'bold', fontSize: '1.1em', color: RUNE_COLORS[color].text }}>
              {totalRunes[color] || 0}
            </div>
            <div style={{ fontSize: '0.75em', color: '#888' }}>{RUNE_COLORS[color].label}</div>
          </div>
        ))}
      </div>
    </Box>
  );
};

const VesselSlot = ({
  num,
  vessel,
  onInsert,
  onRemove,
}: {
  num: string;
  vessel: VesselData | null;
  onInsert: () => void;
  onRemove: () => void;
}) => {
  return (
    <Box
      style={{
        width: '140px',
        height: '155px',
        backgroundColor: vessel ? 'rgba(25, 20, 16, 0.9)' : 'rgba(15, 12, 10, 0.6)',
        border: vessel ? '2px solid #3498db' : '2px dashed #4a3828',
        borderRadius: '8px',
        padding: '10px',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'space-between',
        position: 'relative',
        boxSizing: 'border-box',
      }}
    >
      <Box bold color="#3498db" fontSize="0.85em" textAlign="center">
        Fluid Vessel {num}
      </Box>

      {vessel ? (
        <>
          <Button
            icon="times"
            color="danger"
            compact
            onClick={onRemove}
            style={{ position: 'absolute', top: '6px', right: '6px', padding: '1px 5px', fontSize: '10px' }}
          />
          <Box textAlign="center" my={1}>
            <Icon name="flask" size={2} color="#3498db" />
            <Box bold fontSize="0.85em" color="white" mt={0.5} style={{ overflow: 'hidden', whiteSpace: 'nowrap' }}>
              {vessel.name}
            </Box>
            <Box fontSize="0.75em" color="#aaa">
              {vessel.cur} / {vessel.max} oz
            </Box>
          </Box>

          <Box style={{ maxHeight: '40px', overflowY: 'auto', fontSize: '0.75em' }}>
            {vessel.contents.map((c, i) => (
              <Box key={i} color={c.color}>
                • {c.name}: {c.vol} oz
              </Box>
            ))}
          </Box>
        </>
      ) : (
        <Button
          fluid
          color="transparent"
          onClick={onInsert}
          style={{ height: '100%', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}
        >
          <Icon name="plus" size={2} color="#666" />
          <Box fontSize="0.75em" color="#888" mt={0.5}>
            Insert Vial
          </Box>
        </Button>
      )}
    </Box>
  );
};

const SynthesisView = () => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Alchemical Synthesis & Infusion" fill style={{ backgroundColor: '#161311', border: '1px solid #4a3828' }}>
      <Stack vertical fill justify="space-between">
        <Box textAlign="center" color="#c8a064" fontSize="0.95em" bold mb={1}>
          COMBINE MATTER AND DISTILLED ELIXIRS
        </Box>

        <Stack justify="center" align="center" my={2} style={{ gap: '12px' }}>
          <VesselSlot
            num="1"
            vessel={data.synth_vessel_1}
            onInsert={() => act('insert_synth_vessel', { slot: '1' })}
            onRemove={() => act('remove_synth_vessel', { slot: '1' })}
          />

          <Icon name="plus" size={1.5} color="#777" />

          <Box
            style={{
              width: '120px',
              height: '140px',
              backgroundColor: data.synth_item ? 'rgba(30, 24, 18, 0.9)' : 'rgba(15, 12, 10, 0.6)',
              border: data.synth_item ? '2px solid #ffd700' : '2px dashed #7a5c3d',
              borderRadius: '8px',
              padding: '8px',
              display: 'flex',
              flexDirection: 'column',
              justifyContent: 'space-between',
              alignItems: 'center',
              position: 'relative',
              boxSizing: 'border-box',
            }}
          >
            <Box bold color="#ffd700" fontSize="0.8em">
              Core Item
            </Box>

            {data.synth_item ? (
              <>
                <Button
                  icon="times"
                  color="danger"
                  compact
                  onClick={() => act('remove_synth_item')}
                  style={{ position: 'absolute', top: '5px', right: '5px', padding: '1px 5px', fontSize: '9px' }}
                />
                <div style={{ width: '40px', height: '40px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <DmIcon
                    icon={data.synth_item.icon}
                    icon_state={data.synth_item.icon_state}
                    style={{ width: '32px', height: '32px', transform: 'scale(1.8)', imageRendering: 'pixelated' }}
                  />
                </div>
                <Box bold fontSize="0.8em" color="#ffd700" textAlign="center" style={{ wordBreak: 'break-word' }}>
                  {data.synth_item.name}
                </Box>
              </>
            ) : (
              <Button
                fluid
                color="transparent"
                onClick={() => act('insert_synth_item')}
                style={{ height: '100%', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}
              >
                <Icon name="cube" size={2} color="#666" />
                <Box fontSize="0.75em" color="#888" mt={0.5}>
                  Place Item
                </Box>
              </Button>
            )}
          </Box>

          <Icon name="plus" size={1.5} color="#777" />

          <VesselSlot
            num="2"
            vessel={data.synth_vessel_2}
            onInsert={() => act('insert_synth_vessel', { slot: '2' })}
            onRemove={() => act('remove_synth_vessel', { slot: '2' })}
          />

          <Icon name="arrow-right" size={2} color="#c8a064" mx={1} style={{ filter: 'drop-shadow(0 0 4px #c8a064)' }} />

          <Box
            style={{
              width: '130px',
              height: '150px',
              backgroundColor: data.synth_result ? 'rgba(46, 204, 113, 0.15)' : 'rgba(12, 10, 8, 0.7)',
              border: data.synth_result ? '2px solid #2ecc71' : '2px dashed #444',
              borderRadius: '8px',
              padding: '8px',
              display: 'flex',
              flexDirection: 'column',
              justifyContent: 'space-between',
              alignItems: 'center',
              boxShadow: data.synth_result ? '0 0 12px rgba(46, 204, 113, 0.4)' : 'none',
              boxSizing: 'border-box',
            }}
          >
            <Box bold color={data.synth_result ? '#2ecc71' : '#888'} fontSize="0.85em">
              Result Item
            </Box>

            {data.synth_result ? (
              <>
                <div style={{ width: '40px', height: '40px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <DmIcon
                    icon={data.synth_result.icon}
                    icon_state={data.synth_result.icon_state}
                    style={{ width: '32px', height: '32px', transform: 'scale(1.8)', imageRendering: 'pixelated' }}
                  />
                </div>
                <Box bold fontSize="0.85em" color="#2ecc71" textAlign="center" style={{ wordBreak: 'break-word' }}>
                  {data.synth_result.name}
                </Box>
                <Button
                  fluid
                  color="good"
                  icon="hand-holding"
                  onClick={() => act('take_synth_result')}
                  style={{ fontSize: '0.8em', height: '24px' }}
                >
                  Take
                </Button>
              </>
            ) : (
              <Box textAlign="center" my="auto">
                <Icon name="sparkles" size={2} color="#444" />
                <Box fontSize="0.75em" color="#555" mt={0.5}>
                  Empty
                </Box>
              </Box>
            )}
          </Box>
        </Stack>

        <Box p={2} style={{ backgroundColor: 'rgba(0,0,0,0.4)', borderRadius: '6px', border: '1px solid #33261a' }}>
          {data.matched_synth_recipe ? (
            <Box textAlign="center">
              <Box bold fontSize="1.15em" color="#2ecc71" mb={0.5}>
                Synthesis Discovered: {data.matched_synth_recipe}
              </Box>
              <Box fontSize="0.85em" color="#bbb">
                {data.matched_synth_desc}
              </Box>
            </Box>
          ) : (
            <Box textAlign="center" color="#888" italic fontSize="0.9em">
              Place matching components to discover a synthesis reaction...
            </Box>
          )}

          <Button
            fluid
            mt={2}
            color={data.matched_synth_recipe && !data.synth_result ? 'good' : 'caution'}
            disabled={!data.matched_synth_recipe || !!data.synth_result}
            onClick={() => act('do_synthesis')}
            style={{ height: '42px', fontSize: '1.1em', fontWeight: 'bold' }}
          >
            {data.synth_result ? 'Take result item first!' : 'Synthesize Transmutation'}
          </Button>
        </Box>
      </Stack>
    </Section>
  );
};

const RecipeCard = ({ recipe, isMatch }: { recipe: RecipeData; isMatch: boolean }) => {
  const bInfo = BASE_INFO[recipe.base] || BASE_INFO.water;
  return (
    <div
      style={{
        width: '100%',
        boxSizing: 'border-box',
        padding: '8px 12px',
        backgroundColor: isMatch ? 'rgba(46, 204, 113, 0.15)' : 'rgba(15, 12, 10, 0.7)',
        border: isMatch ? '2px solid #2ecc71' : '1px solid #3d3023',
        borderRadius: '5px',
        marginBottom: '8px',
        flexShrink: 0,
      }}
    >
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
        <span style={{ fontWeight: 'bold', color: isMatch ? '#5cd65c' : '#ffd700', fontSize: '0.95em' }}>
          {recipe.name}
        </span>
        <div>
          {recipe.high_tier && (
            <span style={{ color: '#f39c12', fontSize: '0.75em', fontWeight: 'bold', marginRight: '6px' }}>
              ★ Lab Only
            </span>
          )}
          <span style={{ fontSize: '0.75em', color: recipe.skill_met ? '#888' : '#e74c3c' }}>
            {recipe.skill}
          </span>
        </div>
      </div>

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div style={{ display: 'flex', gap: '6px', flexWrap: 'wrap' }}>
          {['red', 'green', 'blue'].map((color) => {
            const amt = recipe.runes[color];
            if (!amt) return null;
            const cfg = RUNE_COLORS[color];
            return (
              <span
                key={color}
                style={{
                  padding: '2px 6px',
                  borderRadius: '3px',
                  backgroundColor: cfg.bg,
                  border: `1px solid ${cfg.border}`,
                  color: cfg.text,
                  fontSize: '0.8em',
                  fontWeight: 'bold',
                }}
              >
                {amt} {cfg.label}
              </span>
            );
          })}

          {recipe.requires_rainbow && (
            <span
              style={{
                padding: '2px 6px',
                borderRadius: '3px',
                background: 'linear-gradient(135deg, rgba(255,0,0,0.3), rgba(0,255,0,0.3), rgba(0,0,255,0.3))',
                border: '1px solid #ff00ff',
                color: '#ffffff',
                fontSize: '0.8em',
                fontWeight: 'bold',
                textShadow: '0 0 4px #ff00ff',
              }}
            >
              + ★ Rainbow
            </span>
          )}
        </div>

        <span
          style={{
            padding: '2px 6px',
            borderRadius: '3px',
            backgroundColor: 'rgba(0, 0, 0, 0.5)',
            border: `1px solid ${bInfo.color}`,
            color: bInfo.color,
            fontSize: '0.75em',
            fontWeight: 'bold',
            display: 'flex',
            alignItems: 'center',
            gap: '4px',
          }}
        >
          <Icon name={bInfo.icon} size={0.9} />
          {bInfo.label}
        </span>
      </div>
    </div>
  );
};

export const AlchemyWorkbench = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState<'distill' | 'synth'>('distill');
  const [recipeSearch, setRecipeSearch] = useState('');

  const ingredients = data.ingredients || [];
  const totalRunes = data.total_runes || { red: 0, green: 0, blue: 0, rainbow: 0 };
  const hasBase = (data.base_amount || 0) >= (data.base_need || 60) && data.base_type !== 'none';
  const isBaseCorrect = data.matched_recipe && data.matched_base === data.base_type;
  const isReadyToBrew = ingredients.length >= 1 && hasBase && data.on && data.brewing === 0;

  const filteredRecipes = (data.recipes || []).filter((r) =>
    r.name.toLowerCase().includes(recipeSearch.toLowerCase())
  );

  return (
    <Window title="Great Alchemical Laboratory" width={1024} height={720}>
      <Window.Content>
        <style>
          {`
            .alchemy-scroll-area {
              scrollbar-width: thin !important;
              scrollbar-color: #8c6239 #14100d !important;
            }
            .alchemy-scroll-area::-webkit-scrollbar {
              width: 9px !important;
            }
            .alchemy-scroll-area::-webkit-scrollbar-track {
              background: #14100d !important;
            }
            .alchemy-scroll-area::-webkit-scrollbar-thumb {
              background: #8c6239 !important;
              border: 1px solid #b8860b !important;
            }
          `}
        </style>

        <Stack vertical fill>
          <Stack.Item mb={1}>
            <Tabs>
              <Tabs.Tab selected={tab === 'distill'} onClick={() => setTab('distill')} icon="flask">
                Distillation
              </Tabs.Tab>
              <Tabs.Tab selected={tab === 'synth'} onClick={() => setTab('synth')} icon="atom">
                Synthesis & Infusion
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>

          <Stack.Item grow>
            {tab === 'synth' ? (
              <SynthesisView />
            ) : (
              <div style={{ display: 'flex', width: '100%', height: '100%', gap: '10px' }}>
                <div style={{ width: '530px', height: '100%', flexShrink: 0 }}>
                  <Section
                    title="Grand Distillation Workstation"
                    fill
                    style={{ backgroundColor: '#161311', border: '1px solid #4a3828' }}
                    buttons={
                      <Button
                        icon="fire"
                        color={data.on ? 'danger' : 'default'}
                        onClick={() => act('toggle_fire')}
                      >
                        {data.on ? 'Fire: On' : 'Fire: Off'}
                      </Button>
                    }
                  >
                    <Stack vertical fill justify="space-between">
                      <Stack.Item mb={1}>
                        <LiquidBaseStatus
                          baseType={data.base_type}
                          baseAmount={data.base_amount}
                          baseNeed={data.base_need}
                          brewing={data.brewing}
                        />
                      </Stack.Item>

                      <Stack.Item mb={1}>
                        <div
                          style={{
                            position: 'relative',
                            padding: '40px 10px',
                            backgroundColor: 'rgba(15, 12, 10, 0.7)',
                            borderRadius: '8px',
                            border: '1px solid #33261a',
                            overflow: 'hidden',
                            minHeight: '175px',
                          }}
                        >
                          <img
                            src={resolveAsset('alchemy_couldron.png')}
                            style={{
                              position: 'absolute',
                              top: '55%',
                              left: '50%',
                              transform: 'translate(-50%, -50%)',
                              width: '460px',
                              height: '260px',
                              objectFit: 'contain',
                              opacity: 0.35,
                              imageRendering: 'pixelated',
                              pointerEvents: 'none',
                              zIndex: 0,
                            }}
                          />

                          <Box
                            bold
                            color="#c8a064"
                            mb={1.5}
                            fontSize="0.95em"
                            textAlign="center"
                            style={{ position: 'relative', zIndex: 1, textShadow: '0 1px 3px black' }}
                          >
                            Laboratory Reaction Chamber
                          </Box>

                          <div
                            style={{
                              display: 'flex',
                              justifyContent: 'center',
                              gap: '16px',
                              position: 'relative',
                              zIndex: 1,
                            }}
                          >
                            {[0, 1, 2].map((index) => (
                              <WorkbenchSlot
                                key={index}
                                item={ingredients[index]}
                                canInsert={data.user_has_ingredient_in_hand}
                                isBrewing={data.brewing > 0}
                                onInsert={() => act('insert_item')}
                                onRemove={(ref) => act('remove_item', { ref })}
                              />
                            ))}
                          </div>
                        </div>
                      </Stack.Item>

                      <Stack.Item mb={1}>
                        <RuneFlasks totalRunes={totalRunes} />
                      </Stack.Item>

                      <Stack.Item>
                        {data.matched_recipe && isBaseCorrect && (
                          <Box textAlign="center" mb={1} bold color="#2ecc71">
                            Grand Formula Identified: {data.matched_recipe}
                          </Box>
                        )}

                        {data.matched_recipe && !isBaseCorrect && (
                          <Box textAlign="center" mb={1} bold color="#e74c3c">
                            Wrong Base. Needs {BASE_INFO[data.matched_base || 'water'].label}
                          </Box>
                        )}

                        {!data.matched_recipe && ingredients.length >= 1 && (
                          <Box textAlign="center" mb={1} color="#e67e22" fontSize="0.85em">
                            Unknown Formula (Essences might fail to meld)
                          </Box>
                        )}

                        {!hasBase && (
                          <Box textAlign="center" mb={0.5} color="#e74c3c" fontSize="0.85em" bold>
                            Needs at least {data.base_need} oz of liquid.
                          </Box>
                        )}

                        <Button
                          fluid
                          color={data.matched_recipe && isBaseCorrect ? 'good' : 'caution'}
                          disabled={!isReadyToBrew}
                          onClick={() => act('brew')}
                          style={{ height: '42px', fontSize: '1.1em', fontWeight: 'bold' }}
                        >
                          {data.brewing > 0 ? `Boiling (${data.brewing}/3)...` : 'Transmute Grand Potion'}
                        </Button>
                      </Stack.Item>
                    </Stack>
                  </Section>
                </div>

                <div style={{ flex: '1 1 auto', height: '100%', minWidth: 0 }}>
                  <Section
                    title="Alchemist Folio"
                    fill
                    style={{ backgroundColor: 'rgba(28, 24, 20, 0.8)', border: '1px solid #4a3828' }}
                  >
                    <div style={{ display: 'flex', flexDirection: 'column', width: '100%' }}>
                      <div style={{ marginBottom: '10px' }}>
                        <Input
                          fluid
                          placeholder="Search recipes..."
                          value={recipeSearch}
                          onChange={(val: string) => setRecipeSearch(val)}
                        />
                      </div>

                      <div
                        className="alchemy-scroll-area"
                        style={{
                          height: '530px',
                          overflowY: 'scroll',
                          overflowX: 'hidden',
                          display: 'flex',
                          flexDirection: 'column',
                          paddingRight: '6px',
                          boxSizing: 'border-box',
                        }}
                      >
                        {filteredRecipes.map((r, i) => (
                          <RecipeCard
                            key={i}
                            recipe={r}
                            isMatch={data.matched_recipe === r.name && data.base_type === r.base}
                          />
                        ))}
                      </div>
                    </div>
                  </Section>
                </div>
              </div>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
