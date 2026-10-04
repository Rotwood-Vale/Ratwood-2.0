import { useState } from 'react';
import {
  Box,
  Button,
  DmIcon,
  Icon,
  Input,
  Section,
  Stack,
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

type Data = {
  on: boolean;
  brewing: number;
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
};

const RUNE_COLORS: Record<string, { bg: string; border: string; text: string; label: string }> = {
  red: {
    bg: 'rgba(231, 76, 60, 0.25)',
    border: '#e74c3c',
    text: '#ff6b6b',
    label: 'Red',
  },
  green: {
    bg: 'rgba(46, 204, 113, 0.25)',
    border: '#2ecc71',
    text: '#5cd65c',
    label: 'Green',
  },
  blue: {
    bg: 'rgba(52, 152, 219, 0.25)',
    border: '#3498db',
    text: '#4da6ff',
    label: 'Blue',
  },
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
  const hasEnough = baseAmount >= baseNeed;

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
            <Box fontSize="0.95em" bold color={hasEnough ? currentBase.color : '#e74c3c'}>
              Base: {currentBase.label} ({baseAmount} / {baseNeed} oz)
            </Box>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Box fontSize="0.85em" color="#888">
            {brewing > 0 ? (
              <span style={{ color: '#f39c12', fontWeight: 'bold' }}>Boiling ({brewing}/3)...</span>
            ) : hasEnough ? (
              <span style={{ color: '#5cd65c' }}>Ready</span>
            ) : (
              <span style={{ color: '#e74c3c' }}>Needs 60 oz base.</span>
            )}
          </Box>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const IngredientSlot = ({
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
        width: '124px',
        height: '124px',
        backgroundImage: `url(${resolveAsset('alchemy_slot.png')})`,
        backgroundSize: '100% 100%',
        backgroundRepeat: 'no-repeat',
        imageRendering: 'pixelated',
        position: 'relative',
        padding: '10px',
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
                fontSize: '0.85em',
                fontWeight: 'bold',
                color: '#ffd700',
                lineHeight: '1.1em',
                maxWidth: '80px',
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
              style={{ padding: '1px 5px', fontSize: '10px' }}
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
                  transform: 'scale(1.8)',
                  transformOrigin: 'center',
                }}
              >
                <DmIcon
                  icon={item.icon}
                  icon_state={item.icon_state}
                  style={{
                    width: '32px',
                    height: '32px',
                    imageRendering: 'pixelated',
                  }}
                />
              </div>
            )}
          </div>

          <div style={{ display: 'flex', gap: '3px', flexWrap: 'wrap', zIndex: 2 }}>
            {['red', 'green', 'blue', 'rainbow'].map((color) => {
              const count = item.runes[color] || 0;
              if (count <= 0) return null;
              const cfg = RUNE_COLORS[color];
              const isRainbow = color === 'rainbow';
              return (
                <span
                  key={color}
                  style={{
                    padding: '1px 4px',
                    borderRadius: '3px',
                    background: cfg.bg,
                    border: `1px solid ${cfg.border}`,
                    fontSize: '0.75em',
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
          <Icon name="plus" size={1.8} color="#666" style={{ filter: 'drop-shadow(0 1px 2px black)' }} />
          <Box fontSize="0.75em" color="#888" mt={0.5} style={{ textShadow: '0 1px 2px black' }}>
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
        padding: '14px 10px',
        backgroundColor: 'rgba(10, 8, 7, 0.85)',
        borderRadius: '8px',
        border: '1px solid #33261a',
      }}
    >
      <Box textAlign="center" color="#8a7662" fontSize="0.85em" bold mb={1}>
        DISTILLED ESSENCES
      </Box>

      <div
        style={{
          width: '210px',
          height: '120px',
          position: 'relative',
          margin: '0 auto',
        }}
      >
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
            const isOverloaded = count > 3;
            const cfg = RUNE_COLORS[color];
            const fillPercent = Math.min(100, (count / 3) * 100);

            return (
              <div
                key={color}
                style={{
                  width: '38px',
                  height: '100%',
                  display: 'flex',
                  alignItems: 'flex-end',
                  justifyContent: 'center',
                }}
              >
                <div
                  style={{
                    width: '100%',
                    height: `${fillPercent}%`,
                    backgroundColor: isOverloaded ? '#e74c3c' : cfg.border,
                    borderRadius: '0 0 10px 10px',
                    opacity: isOverloaded ? 0.95 : 0.85,
                    transition: 'height 0.4s ease',
                    boxShadow: isOverloaded ? '0 0 15px #e74c3c' : `0 0 12px ${cfg.border}`,
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
        {(['red', 'green', 'blue'] as const).map((color) => {
          const count = totalRunes[color] || 0;
          const isOverloaded = count > 3;
          const cfg = RUNE_COLORS[color];
          return (
            <div key={color} style={{ textAlign: 'center', width: '48px' }}>
              <div style={{ fontWeight: 'bold', fontSize: '1.1em', color: isOverloaded ? '#e74c3c' : cfg.text }}>
                {count > 3 ? `${count}!` : count}
              </div>
              <div style={{ fontSize: '0.7em', color: isOverloaded ? '#e74c3c' : '#888' }}>
                {isOverloaded ? 'OVERLOAD' : cfg.label}
              </div>
            </div>
          );
        })}
      </div>
    </Box>
  );
};

const RecipeCard = ({ recipe, isMatch }: { recipe: RecipeData; isMatch: boolean }) => {
  const bInfo = BASE_INFO[recipe.base] || BASE_INFO.water;
  const isHighTier =
    recipe.high_tier ||
    recipe.requires_rainbow ||
    (recipe.runes.red || 0) > 3 ||
    (recipe.runes.green || 0) > 3 ||
    (recipe.runes.blue || 0) > 3;

  return (
    <div
      style={{
        width: '100%',
        boxSizing: 'border-box',
        padding: '8px 12px',
        backgroundColor: isMatch ? 'rgba(46, 204, 113, 0.15)' : 'rgba(15, 12, 10, 0.7)',
        border: isMatch ? '2px solid #2ecc71' : '1px solid #3d3023',
        borderRadius: '5px',
        boxShadow: isMatch ? '0 0 10px rgba(46, 204, 113, 0.3)' : 'none',
        marginBottom: '8px',
        flexShrink: 0,
        opacity: isHighTier ? 0.65 : 1,
      }}
    >
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
        <span style={{ fontWeight: 'bold', color: isMatch ? '#5cd65c' : '#ffd700', fontSize: '0.95em' }}>
          {recipe.name}
        </span>
        <div>
          {isHighTier && (
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

export const AlchemyCauldron = () => {
  const { act, data } = useBackend<Data>();
  const [recipeSearch, setRecipeSearch] = useState('');

  const ingredients = data.ingredients || [];
  const totalRunes = data.total_runes || { red: 0, green: 0, blue: 0, rainbow: 0 };
  const hasBase = (data.base_amount || 0) >= (data.base_need || 60) && data.base_type !== 'none';
  const isBaseCorrect = data.matched_recipe && data.matched_base === data.base_type;

  const isOverloaded = totalRunes.red > 3 || totalRunes.green > 3 || totalRunes.blue > 3;

  const isReadyToBrew = ingredients.length >= 1 && hasBase && data.on && data.brewing === 0 && !isOverloaded;

  const filteredRecipes = (data.recipes || []).filter((r) =>
    r.name.toLowerCase().includes(recipeSearch.toLowerCase())
  );

  return (
    <Window title="Alchemy Laboratory (Cauldron)" width={860} height={640}>
      <Window.Content>
        <style>
          {`
            .alchemy-scroll-area {
              scrollbar-width: thin !important;
              scrollbar-color: #8c6239 #14100d !important;
            }
            .alchemy-scroll-area::-webkit-scrollbar {
              width: 9px !important;
              display: block !important;
            }
            .alchemy-scroll-area::-webkit-scrollbar-track {
              background: #14100d !important;
              border-radius: 4px !important;
            }
            .alchemy-scroll-area::-webkit-scrollbar-thumb {
              background: #8c6239 !important;
              border-radius: 4px !important;
              border: 1px solid #b8860b !important;
            }
            .alchemy-scroll-area::-webkit-scrollbar-thumb:hover {
              background: #b8860b !important;
            }
          `}
        </style>

        <div style={{ display: 'flex', width: '100%', height: '100%', gap: '10px' }}>
          <div style={{ width: '490px', height: '100%', flexShrink: 0 }}>
            <Section
              title="Distillation Workshop"
              fill
              style={{ backgroundColor: '#161311', border: '1px solid #4a3828' }}
              buttons={
                <Button
                  icon="fire"
                  color={data.on ? 'danger' : 'default'}
                  onClick={() => act('toggle_fire')}
                >
                  {data.on ? 'Fire: Burning' : 'Fire: Extinguished'}
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
                      padding: '45px 10px',
                      backgroundColor: 'rgba(15, 12, 10, 0.7)',
                      borderRadius: '8px',
                      border: '1px solid #33261a',
                      overflow: 'hidden',
                      minHeight: '170px',
                      display: 'flex',
                      flexDirection: 'column',
                      justifyContent: 'space-between',
                    }}
                  >
                    <img
                      src={resolveAsset('alchemy_couldron.png')}
                      style={{
                        position: 'absolute',
                        top: '55%',
                        left: '50%',
                        transform: 'translate(-50%, -50%)',
                        width: '420px',
                        height: '250px',
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
                      mb={1}
                      fontSize="0.95em"
                      textAlign="center"
                      style={{ position: 'relative', zIndex: 1, textShadow: '0 1px 3px black' }}
                    >
                      Reaction Ingredients
                    </Box>

                    <div
                      style={{
                        display: 'flex',
                        justifyContent: 'center',
                        gap: '24px',
                        position: 'relative',
                        zIndex: 1,
                      }}
                    >
                      {[0, 1].map((index) => (
                        <IngredientSlot
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
                  {data.matched_recipe && isBaseCorrect && !isOverloaded && (
                    <Box textAlign="center" mb={1} bold color="#2ecc71">
                      Reaction Identified: {data.matched_recipe}
                    </Box>
                  )}

                  {data.matched_recipe && !isBaseCorrect && !isOverloaded && (
                    <Box textAlign="center" mb={1} bold color="#e74c3c">
                      Wrong Base. Needs {BASE_INFO[data.matched_base || 'water'].label} (currently has {BASE_INFO[data.base_type].label})
                    </Box>
                  )}

                  {isOverloaded && (
                    <Box textAlign="center" mb={0.5} color="#e74c3c" fontSize="0.85em" bold>
                      Cauldron Overload. Max 3 runes per color. Use Grand Laboratory.
                    </Box>
                  )}

                  {!data.matched_recipe && ingredients.length >= 1 && !isOverloaded && (
                    <Box textAlign="center" mb={1} color="#e67e22" fontSize="0.85em">
                      Unknown Formula (Essences might fail to meld)
                    </Box>
                  )}

                  {!hasBase && (
                    <Box textAlign="center" mb={0.5} color="#e74c3c" fontSize="0.85em" bold>
                      Needs at least {data.base_need} oz of liquid base (Water, Wine, or Milk).
                    </Box>
                  )}

                  <Button
                    fluid
                    color={data.matched_recipe && isBaseCorrect && !isOverloaded ? 'good' : 'caution'}
                    disabled={!isReadyToBrew}
                    onClick={() => act('brew')}
                    style={{ height: '42px', fontSize: '1.1em', fontWeight: 'bold' }}
                  >
                    {data.brewing > 0 ? `Boiling (${data.brewing}/3)...` : 'Brew Potion'}
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </div>

          <div style={{ flex: '1 1 auto', height: '100%', minWidth: 0, overflow: 'hidden' }}>
            <Section
              title="Alchemist Folio"
              fill
              style={{ backgroundColor: 'rgba(28, 24, 20, 0.8)', border: '1px solid #4a3828' }}
            >
              <div style={{ display: 'flex', flexDirection: 'column', width: '100%' }}>
                <div style={{ marginBottom: '10px', flexShrink: 0 }}>
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
                    height: '470px',
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
      </Window.Content>
    </Window>
  );
};
