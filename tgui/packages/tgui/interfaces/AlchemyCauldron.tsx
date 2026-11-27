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
    bg: 'rgba(92, 28, 28, 0.4)',
    border: '#7a2525',
    text: '#b84d4d',
    label: 'Red',
  },
  green: {
    bg: 'rgba(38, 69, 42, 0.4)',
    border: '#3b5e3f',
    text: '#629968',
    label: 'Green',
  },
  blue: {
    bg: 'rgba(35, 56, 79, 0.4)',
    border: '#344f6e',
    text: '#597c9e',
    label: 'Blue',
  },
  rainbow: {
    bg: 'linear-gradient(135deg, rgba(82,34,34,0.4), rgba(34,61,38,0.4), rgba(35,51,77,0.4))',
    border: '#734e78',
    text: '#b094b5',
    label: 'Rainbow',
  },
};

const BASE_INFO = {
  water: { label: 'Water', color: '#527494', icon: 'tint' },
  wine: { label: 'Wine', color: '#6b2222', icon: 'wine-glass-alt' },
  milk: { label: 'Milk', color: '#a8a499', icon: 'mug-hot' },
  none: { label: 'Empty', color: '#575249', icon: 'flask' },
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
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        borderRadius: '4px',
        border: '1px solid #2e2217',
      }}
    >
      <Stack align="center" justify="space-between">
        <Stack.Item>
          <Stack align="center">
            <Icon name={currentBase.icon} color={currentBase.color} mr={1} />
            <Box fontSize="0.95em" bold color={hasEnough ? currentBase.color : '#8f3333'}>
              Base: {currentBase.label} ({baseAmount} / {baseNeed} oz)
            </Box>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Box fontSize="0.85em" color="#777">
            {brewing > 0 ? (
              <span style={{ color: '#b87b32', fontWeight: 'bold' }}>Boiling ({brewing}/3)...</span>
            ) : hasEnough ? (
              <span style={{ color: '#598c60' }}>Ready</span>
            ) : (
              <span style={{ color: '#8f3333' }}>Needs 60 oz base.</span>
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
        width: '128px',
        height: '128px',
        backgroundImage: `url(${resolveAsset('alchemy_slot.png')})`,
        backgroundSize: '100% 100%',
        backgroundRepeat: 'no-repeat',
        imageRendering: 'pixelated',
        position: 'relative',
        padding: '10px',
        boxSizing: 'border-box',
        filter: 'drop-shadow(0 4px 8px rgba(0, 0, 0, 0.8))',
      }}
    >
      {item ? (
        <>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', zIndex: 2 }}>
            <span
              style={{
                fontSize: '0.85em',
                fontWeight: 'bold',
                color: '#c2a15f',
                lineHeight: '1.1em',
                maxWidth: '82px',
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
              style={{ padding: '1px 5px', fontSize: '9px', backgroundColor: '#6e2727', borderColor: '#4a1717' }}
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
              filter: 'drop-shadow(0 2px 4px rgba(0,0,0,0.8))',
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

          <div
            style={{
              position: 'absolute',
              bottom: '-12px',
              left: '8px',
              display: 'flex',
              gap: '4px',
              flexWrap: 'wrap',
              zIndex: 5,
            }}
          >
            {['red', 'green', 'blue', 'rainbow'].map((color) => {
              const count = item.runes[color] || 0;
              if (count <= 0) return null;
              const cfg = RUNE_COLORS[color];
              const isRainbow = color === 'rainbow';
              return (
                <span
                  key={color}
                  style={{
                    padding: '2px 5px',
                    borderRadius: '3px',
                    backgroundColor: '#120f0c',
                    border: `1px solid ${cfg.border}`,
                    fontSize: '0.8em',
                    color: cfg.text,
                    fontWeight: 'bold',
                    boxShadow: '0 2px 5px rgba(0, 0, 0, 0.9)',
                    textShadow: isRainbow ? '0 0 3px #734e78' : '0 1px 2px black',
                  }}
                >
                  {isRainbow ? `★ ${count}` : `${count}${cfg.label[0]}`}
                </span>
              );
            })}
          </div>
        </>
      ) : (
        <div
          onClick={() => {
            if (canInsert && !isBrewing) onInsert();
          }}
          style={{
            width: '100%',
            height: '100%',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            cursor: canInsert && !isBrewing ? 'pointer' : 'default',
            userSelect: 'none',
          }}
        >
          <Icon name="plus" size={1.8} color="#554b42" style={{ filter: 'drop-shadow(0 1px 2px black)' }} />
          <Box fontSize="0.75em" color="#6e6255" mt={0.5} style={{ textShadow: '0 1px 2px black' }}>
            Add
          </Box>
        </div>
      )}
    </div>
  );
};

const SingleFlask = ({
  color,
  count,
}: {
  color: 'red' | 'green' | 'blue';
  count: number;
}) => {
  const isOverloaded = count > 3;
  const cfg = RUNE_COLORS[color];

  const getCalibratedFill = (cnt: number) => {
    if (cnt <= 0) return 0;
    if (cnt === 1) return 26;
    if (cnt === 2) return 50;
    if (cnt === 3) return 74;
    return 82;
  };

  const fillPercent = getCalibratedFill(count);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', width: '56px' }}>
      <div
        style={{
          width: '46px',
          height: '125px',
          position: 'relative',
          userSelect: 'none',
        }}
      >
        <div
          style={{
            position: 'absolute',
            top: 0,
            left: 0,
            width: '100%',
            height: '100%',
            WebkitMaskImage: `url(${resolveAsset('alchemy_layer.png')})`,
            WebkitMaskSize: '100% 100%',
            WebkitMaskRepeat: 'no-repeat',
            WebkitMaskPosition: 'center',
            maskImage: `url(${resolveAsset('alchemy_layer.png')})`,
            maskSize: '100% 100%',
            maskRepeat: 'no-repeat',
            maskPosition: 'center',
            display: 'flex',
            alignItems: 'flex-end',
            zIndex: 1,
            pointerEvents: 'none',
          }}
        >
          <div
            style={{
              width: '100%',
              height: `${fillPercent}%`,
              backgroundColor: isOverloaded ? '#6b2020' : cfg.border,
              position: 'relative',
              transition: 'height 0.4s ease',
              boxShadow: isOverloaded
                ? 'inset 4px 0 7px rgba(0,0,0,0.7), inset -4px 0 7px rgba(0,0,0,0.7), inset 0 -6px 8px rgba(0,0,0,0.8)'
                : `inset 4px 0 6px rgba(0,0,0,0.6), inset -4px 0 6px rgba(0,0,0,0.6), inset 0 -6px 8px rgba(0,0,0,0.7), 0 0 6px ${cfg.bg}`,
            }}
          >
            <div
              style={{
                position: 'absolute',
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                background:
                  'linear-gradient(to right, rgba(0,0,0,0.55) 0%, transparent 20%, rgba(255,255,255,0.18) 46%, transparent 66%, rgba(0,0,0,0.65) 100%)',
                pointerEvents: 'none',
              }}
            />

            {fillPercent > 0 && (
              <div
                style={{
                  position: 'absolute',
                  top: 0,
                  left: '2px',
                  right: '2px',
                  height: '2px',
                  backgroundColor: 'rgba(215, 215, 215, 0.45)',
                  borderRadius: '50%',
                  pointerEvents: 'none',
                }}
              />
            )}
          </div>
        </div>

        <img
          src={resolveAsset('alchemy_colb.png')}
          style={{
            position: 'absolute',
            top: 0,
            left: 0,
            width: '100%',
            height: '100%',
            imageRendering: 'pixelated',
            pointerEvents: 'none',
            zIndex: 2,
            opacity: 0.85,
          }}
        />
      </div>

      <div
        style={{
          fontWeight: 'bold',
          fontSize: '1.05em',
          color: isOverloaded ? '#8f3333' : cfg.text,
          marginTop: '6px',
        }}
      >
        {count > 3 ? `${count}!` : count}
      </div>
      <div style={{ fontSize: '0.7em', color: isOverloaded ? '#8f3333' : '#666' }}>
        {isOverloaded ? 'OVERLOAD' : cfg.label}
      </div>
    </div>
  );
};

const RuneFlasks = ({ totalRunes }: { totalRunes: Record<string, number> }) => {
  return (
    <Box
      style={{
        padding: '14px 10px',
        backgroundColor: 'rgba(10, 8, 7, 0.9)',
        borderRadius: '6px',
        border: '1px solid #291d12',
      }}
    >
      <Box textAlign="center" color="#6e5d4a" fontSize="0.82em" bold mb={1.5} style={{ letterSpacing: '0.5px' }}>
        DISTILLED ESSENCES
      </Box>

      <div
        style={{
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          gap: '36px',
        }}
      >
        <SingleFlask color="red" count={totalRunes.red || 0} />
        <SingleFlask color="green" count={totalRunes.green || 0} />
        <SingleFlask color="blue" count={totalRunes.blue || 0} />
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
        backgroundColor: isMatch ? 'rgba(46, 82, 51, 0.22)' : 'rgba(12, 10, 8, 0.75)',
        border: isMatch ? '1px solid #4a7550' : '1px solid #2b2014',
        borderRadius: '4px',
        boxShadow: isMatch ? '0 0 6px rgba(59, 107, 65, 0.25)' : 'none',
        marginBottom: '8px',
        flexShrink: 0,
        opacity: isHighTier ? 0.6 : 1,
      }}
    >
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
        <span style={{ fontWeight: 'bold', color: isMatch ? '#6fa374' : '#c2a15f', fontSize: '0.92em' }}>
          {recipe.name}
        </span>
        <div>
          {isHighTier && (
            <span style={{ color: '#ad722f', fontSize: '0.7em', fontWeight: 'bold', marginRight: '6px' }}>
              ★ Lab Only
            </span>
          )}
          <span style={{ fontSize: '0.72em', color: recipe.skill_met ? '#666' : '#8a3333' }}>
            {recipe.skill}
          </span>
        </div>
      </div>

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div style={{ display: 'flex', gap: '5px', flexWrap: 'wrap' }}>
          {['red', 'green', 'blue'].map((color) => {
            const amt = recipe.runes[color];
            if (!amt) return null;
            const cfg = RUNE_COLORS[color];
            return (
              <span
                key={color}
                style={{
                  padding: '2px 5px',
                  borderRadius: '2px',
                  backgroundColor: cfg.bg,
                  border: `1px solid ${cfg.border}`,
                  color: cfg.text,
                  fontSize: '0.75em',
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
                padding: '2px 5px',
                borderRadius: '2px',
                background: 'linear-gradient(135deg, rgba(82,34,34,0.35), rgba(34,61,38,0.35), rgba(35,51,77,0.35))',
                border: '1px solid #734e78',
                color: '#b094b5',
                fontSize: '0.75em',
                fontWeight: 'bold',
              }}
            >
              + ★ Rainbow
            </span>
          )}
        </div>

        <span
          style={{
            padding: '2px 5px',
            borderRadius: '2px',
            backgroundColor: 'rgba(0, 0, 0, 0.6)',
            border: `1px solid ${bInfo.color}`,
            color: bInfo.color,
            fontSize: '0.72em',
            fontWeight: 'bold',
            display: 'flex',
            alignItems: 'center',
            gap: '4px',
          }}
        >
          <Icon name={bInfo.icon} size={0.85} />
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
    <Window title="Alchemy Laboratory (Cauldron)" width={1024} height={720}>
      <Window.Content>
        <style>
          {`
            .alchemy-scroll-area {
              scrollbar-width: thin !important;
              scrollbar-color: #57412b #100d0a !important;
            }
            .alchemy-scroll-area::-webkit-scrollbar {
              width: 8px !important;
              display: block !important;
            }
            .alchemy-scroll-area::-webkit-scrollbar-track {
              background: #100d0a !important;
              border-radius: 2px !important;
            }
            .alchemy-scroll-area::-webkit-scrollbar-thumb {
              background: #473523 !important;
              border-radius: 2px !important;
              border: 1px solid #634b33 !important;
            }
            .alchemy-scroll-area::-webkit-scrollbar-thumb:hover {
              background: #634b33 !important;
            }
          `}
        </style>

        <div style={{ display: 'flex', width: '100%', height: '100%', gap: '10px' }}>
          <div style={{ width: '490px', height: '100%', flexShrink: 0 }}>
            <Section
              title="Distillation Workshop"
              fill
              style={{ backgroundColor: '#130f0c', border: '1px solid #38291a' }}
              buttons={
                <Button
                  icon="fire"
                  color={data.on ? 'danger' : 'default'}
                  onClick={() => act('toggle_fire')}
                  style={{
                    backgroundColor: data.on ? '#6e2727' : '#2b231b',
                    borderColor: data.on ? '#8f3333' : '#453526',
                  }}
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
                      padding: '36px 10px 24px 10px',
                      backgroundColor: 'rgba(10, 8, 6, 0.75)',
                      borderRadius: '6px',
                      border: '1px solid #291d12',
                      minHeight: '185px',
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
                        opacity: 0.28,
                        imageRendering: 'pixelated',
                        pointerEvents: 'none',
                        zIndex: 0,
                      }}
                    />

                    <Box
                      bold
                      color="#9c8052"
                      mb={1}
                      fontSize="0.92em"
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
                    <Box textAlign="center" mb={1} bold color="#598c60">
                      Reaction Identified: {data.matched_recipe}
                    </Box>
                  )}

                  {data.matched_recipe && !isBaseCorrect && !isOverloaded && (
                    <Box textAlign="center" mb={1} bold color="#8f3333">
                      Wrong Base. Needs {BASE_INFO[data.matched_base || 'water'].label} (currently has {BASE_INFO[data.base_type].label})
                    </Box>
                  )}

                  {isOverloaded && (
                    <Box textAlign="center" mb={0.5} color="#8f3333" fontSize="0.85em" bold>
                      Cauldron Overload. Max 3 runes per color. Use Grand Laboratory.
                    </Box>
                  )}

                  {!data.matched_recipe && ingredients.length >= 1 && !isOverloaded && (
                    <Box textAlign="center" mb={1} color="#946538" fontSize="0.85em">
                      Unknown Formula (Essences might fail to meld)
                    </Box>
                  )}

                  {!hasBase && (
                    <Box textAlign="center" mb={0.5} color="#8f3333" fontSize="0.85em" bold>
                      Needs at least {data.base_need} oz of liquid base (Water, Wine, or Milk).
                    </Box>
                  )}

                  <Button
                    fluid
                    disabled={!isReadyToBrew}
                    onClick={() => act('brew')}
                    style={{
                      height: '42px',
                      fontSize: '1.05em',
                      fontWeight: 'bold',
                      backgroundColor: data.matched_recipe && isBaseCorrect && !isOverloaded ? '#305436' : '#2b231b',
                      borderColor: data.matched_recipe && isBaseCorrect && !isOverloaded ? '#47784f' : '#453526',
                      color: isReadyToBrew ? '#c7dfc9' : '#574e44',
                    }}
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
              style={{ backgroundColor: 'rgba(19, 15, 12, 0.85)', border: '1px solid #38291a' }}
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
      </Window.Content>
    </Window>
  );
};
