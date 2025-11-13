import React, { useRef, useState } from 'react';
import { Box, Button, DmIcon, LabeledList, Section, Stack, Tooltip } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

// Types for backend data
type StashItem = {
  uid: string; // prefixed vault_uid (A/D/S/U + number)
  path: string;
  name: string;
  rarity?: number | null;
  rarity_color?: string | null;
  ench_texts?: string[] | null;
  display_uid?: string | null;
  icon?: string | null;
  icon_state?: string | null;
  item_state?: string | null;
  preview_icon?: string | null;
  preview_state?: string | null;
  preview_scale?: number | null;
  mob_overlay_icon?: string | null;
  damage?: number | null;
  damage_type?: string | null;
  x: number;
  y: number;
  w: number;
  h: number;
};

type Data = {
  currency: number;
  items: StashItem[];
  grid_w: number;
  grid_h: number;
  rev: number;
  cell_px?: number;
  debug_enabled?: boolean;
  is_admin?: boolean;
};

// Grid sizing
const DEFAULT_CELL = 32; // fallback slot size (px)
const ICON_PAD = 2; // breathing room inside slot

// Map numeric rarity to human-readable label (mirrors DM constants in code/modules/ratworld/rarity.dm)
const RARITY_LABEL: Record<number, string> = {
  1: 'Common',
  2: 'Magic',
  3: 'Rare',
  4: 'Epic',
  5: 'Legendary',
  6: 'Unique',
  7: 'Artifact',
  8: 'Ascendant',
};

const RARITY_COLOR: Record<number, string> = {
  1: '#bfbfbf',
  2: '#6ec1ff',
  3: '#d4b000',
  4: '#9b59b6',
  5: '#f39c12',
  6: '#b8860b',
  7: '#e74c3c',
  8: '#6c2bd9',
};

// Derive a display rarity if missing: if enchants exist but rarity absent, treat as Magic
function getDisplayRarity(item: StashItem): number | null {
  const hasEnchants = Array.isArray(item.ench_texts) && item.ench_texts.length > 0;
  if (typeof item.rarity === 'number' && item.rarity >= 1 && item.rarity <= 8) {
    // If enchants exist but rarity says Common, treat as at least Magic for display
    if (item.rarity === 1 && hasEnchants) return 2;
    return item.rarity;
  }
  if (hasEnchants) return 2; // Magic fallback for legacy records without rarity
  return null;
}

function getRarityColor(item: StashItem): string | null {
  const r = getDisplayRarity(item);
  if (r && RARITY_COLOR[r]) return RARITY_COLOR[r];
  return item.rarity_color || null;
}

// Tooltip content: normal mode shows rarity name + enchantments; debug shows diagnostics
const ItemTooltip = ({ item, debug }: { item: StashItem; debug: boolean }) => {
  if (debug) {
    return (
      <Stack vertical>
        <Stack.Item bold>{item.name}</Stack.Item>
        <Stack.Item italic>UID {displayUid(item)}</Stack.Item>
        <Stack.Item>icon: {String(item.icon || '')}</Stack.Item>
        <Stack.Item>icon_state: {String(item.icon_state || '')}</Stack.Item>
        <Stack.Item>item_state: {String(item.item_state || '')}</Stack.Item>
        <Stack.Item>preview_icon: {String(item.preview_icon || '')}</Stack.Item>
        <Stack.Item>preview_state: {String(item.preview_state || '')}</Stack.Item>
        <Stack.Item>preview_scale: {String(item.preview_scale || '')}</Stack.Item>
      </Stack>
    );
  }
  const lines = item.ench_texts || [];
  const dispRarity = getDisplayRarity(item);
  const rarityLabel = (dispRarity && RARITY_LABEL[dispRarity]) || 'Unknown';
  const rarityColor = getRarityColor(item) || undefined;
  const dmg = item.damage ?? null;
  const dmgType = (item.damage_type || '').toLowerCase();
  const dmgColor = dmgType === 'brute' ? '#e74c3c' : dmgType === 'burn' ? '#e67e22' : '#ddd';
  return (
    <Box style={{ minWidth: 240, textAlign: 'center', position: 'relative' }}>
      <Box
        style={{
          position: 'relative',
          padding: 10,
          border: `1px solid ${rarityColor || '#444'}`,
          background: 'rgba(0,0,0,0.70)',
          borderRadius: 6,
          boxShadow: rarityColor
            ? `0 0 12px 3px ${rarityColor}55, inset 0 0 0 1px ${rarityColor}33`
            : '0 0 8px rgba(0,0,0,0.4)',
        }}
      >
        <Box bold style={{ color: rarityColor || '#e0e0e0', marginBottom: 4 }}>{item.name || ''}</Box>
        <Box style={{ color: rarityColor || '#c0c0c0', opacity: 0.95, marginBottom: 6 }}>{dispRarity ? rarityLabel : ''}</Box>
        {!!dmg && (
          <Box bold style={{ color: dmgColor, marginBottom: 6 }}>
            Damage {dmg}
          </Box>
        )}
        {lines.length > 0 ? (
          <Stack vertical>
            {lines.map((t, i) => (
              <Stack.Item key={i}>{t}</Stack.Item>
            ))}
          </Stack>
        ) : (
          <Box color="label">No enchantments</Box>
        )}
      </Box>
    </Box>
  );
};
function resolvePreviewIcon(item: StashItem): string {
  if (item.preview_icon) return item.preview_icon;
  if (item.icon) return item.icon;
  const moi = item.mob_overlay_icon;
  if (moi) {
    if (moi.includes('/onmob/')) return moi.replace('/onmob/', '/');
    return moi;
  }
  return 'icons/roguetown/items/produce.dmi';
}

function resolvePreviewState(item: StashItem): string {
  if (item.preview_state && item.preview_state !== '') return item.preview_state;
  if (item.item_state && item.item_state !== '') return item.item_state;
  if (item.icon_state && item.icon_state !== '') return item.icon_state;
  return 'default';
}

function displayUid(item: StashItem): string {
  const raw = item.display_uid || item.uid;
  const text = String(raw || '');
  if (/^\d+$/.test(text)) return `U${text}`;
  return text;
}

export const RatworldStash = () => {
  const { data, act } = useBackend<Data>();
  const { currency, items, grid_w, grid_h } = data;
  const CELL = data.cell_px || DEFAULT_CELL;
  const showDebug = !!data.debug_enabled;
  // Icon component sized to grid cells, fill footprint proportionally via CSS (no explicit px sizing)
  const FitIcon = ({ item }: { item: StashItem }) => {
    // Stretch preview to fully fill its grid footprint, even if that distorts aspect ratio.
    return (
      <div
        style={{
          width: '100%',
          height: '100%',
          overflow: 'hidden',
          pointerEvents: 'none',
          userSelect: 'none',
        }}
      >
        <DmIcon
          icon={resolvePreviewIcon(item)}
          icon_state={resolvePreviewState(item)}
          style={{
            imageRendering: 'pixelated',
            width: '100%',
            height: '100%',
            objectFit: 'fill',
            pointerEvents: 'none',
            userSelect: 'none',
          }}
        />
      </div>
    );
  };
  const [draggingUid, setDraggingUid] = useState<string | null>(null);
  const [dragOrigin, setDragOrigin] = useState<{x: number; y: number} | null>(null);
  const [hoverCell, setHoverCell] = useState<{x: number; y: number} | null>(null);
  const gridRef = useRef<HTMLDivElement | null>(null);

  const findItem = (uid: string | null) => items.find(i => i.uid === uid);
  // Pulse keyframes injected once
  const PULSE_STYLE = `@keyframes pulseValid {0% {box-shadow:0 0 4px 1px rgba(242,217,76,0.35);}50% {box-shadow:0 0 10px 3px rgba(242,217,76,0.85);}100% {box-shadow:0 0 4px 1px rgba(242,217,76,0.35);}}@keyframes pulseInvalid {0% {box-shadow:0 0 4px 1px rgba(204,51,51,0.35);}50% {box-shadow:0 0 10px 3px rgba(204,51,51,0.85);}100% {box-shadow:0 0 4px 1px rgba(204,51,51,0.35);}}`;
  const EFFECTS_STYLE = `
    @keyframes stashPulse {0% { box-shadow: 0 0 8px 2px rgba(255,255,255,0.25); } 50% { box-shadow: 0 0 14px 6px rgba(255,255,255,0.45); } 100% { box-shadow: 0 0 8px 2px rgba(255,255,255,0.25); }}
    @keyframes textPulse {0% { text-shadow: 0 0 2px rgba(255,255,255,0.2); } 50% { text-shadow: 0 0 6px rgba(255,255,255,0.6); } 100% { text-shadow: 0 0 2px rgba(255,255,255,0.2); }}
    @keyframes sparkleFloat {0% { transform: translateY(0px) scale(1); opacity: 0.8; } 50% { transform: translateY(-3px) scale(1.08); opacity: 1; } 100% { transform: translateY(0px) scale(1); opacity: 0.8; }}
    @keyframes fireFlicker {0%, 100% { transform: translateY(0px); opacity: 0.75; } 50% { transform: translateY(-1px); opacity: 1; }}
    @keyframes emberRise {0% { transform: translateY(0px) scale(0.9); opacity: 0.85; } 50% { transform: translateY(-3px) scale(1); opacity: 1; } 100% { transform: translateY(0px) scale(0.9); opacity: 0.85; }}
  `;

  // Determine if current drag target placement collides with another item.
  const placementBlocked = (() => {
    if (!draggingUid || !hoverCell) return false;
    const item = findItem(draggingUid);
    if (!item) return false;
    const tx = hoverCell.x;
    const ty = hoverCell.y;
    // Bounds check
    if (tx < 1 || ty < 1 || tx + item.w - 1 > grid_w || ty + item.h - 1 > grid_h) return true;
    // Collision with other items
    for (const other of items) {
      if (other.uid === item.uid) continue;
      const ox1 = other.x;
      const oy1 = other.y;
      const ox2 = other.x + other.w - 1;
      const oy2 = other.y + other.h - 1;
      const tx2 = tx + item.w - 1;
      const ty2 = ty + item.h - 1;
      const separated = (tx2 < ox1) || (ox2 < tx) || (ty2 < oy1) || (oy2 < ty);
      if (!separated) return true;
    }
    return false;
  })();

  return (
    <Window
      width={Math.max(360, grid_w * CELL + 32)}
      height={Math.max(360, grid_h * CELL + 160)}
      title="Ratworld Reliquary"
    >
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Ledger">
              <LabeledList>
                <LabeledList.Item label="Mammon">{currency}</LabeledList.Item>
                <LabeledList.Item label="Actions">
                  {data.is_admin && (
                    <Button
                      icon={data.debug_enabled ? 'bug' : 'bug'}
                      selected={!!data.debug_enabled}
                      ml={1}
                      onClick={() => act('toggle_debug')}
                      tooltip={data.debug_enabled ? 'Disable stash debug spam' : 'Enable stash debug spam (admins/devs only)'}
                    >
                      Debug
                    </Button>
                  )}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section title="Stash" fill>
              <div
                ref={gridRef}
                style={{
                  position: 'relative',
                  width: grid_w * CELL,
                  height: grid_h * CELL,
                  background: '#111',
                  border: '2px solid #333',
                  userSelect: 'none',
                }}
                onMouseMove={(e: React.MouseEvent<HTMLDivElement>) => {
                  const rect = e.currentTarget.getBoundingClientRect();
                  const gx = Math.floor((e.clientX - rect.left) / CELL) + 1;
                  const gy = Math.floor((e.clientY - rect.top) / CELL) + 1;
                  if (gx >= 1 && gx <= grid_w && gy >= 1 && gy <= grid_h) {
                    setHoverCell({ x: gx, y: gy });
                  } else {
                    setHoverCell(null);
                  }
                }}
                onMouseUp={(e: React.MouseEvent<HTMLDivElement>) => {
                  if (draggingUid) {
                    const item = findItem(draggingUid);
                    const drop = hoverCell;
                    if (item && drop) {
                      // If dropped on different cell, attempt move; else treat as withdraw
                      if (drop.x !== item.x || drop.y !== item.y) {
                        act('move', { uid: item.uid, x: drop.x, y: drop.y });
                      } else {
                        act('withdraw', { uid: item.uid });
                      }
                    }
                    setDraggingUid(null);
                    setDragOrigin(null);
                    setHoverCell(null);
                  } else if (!draggingUid && e.button === 0) {
                    // Background left-click deposit (only if not dragging)
                    const rect = e.currentTarget.getBoundingClientRect();
                    const gx = Math.floor((e.clientX - rect.left) / CELL) + 1;
                    const gy = Math.floor((e.clientY - rect.top) / CELL) + 1;
                    if (gx >= 1 && gx <= grid_w && gy >= 1 && gy <= grid_h) {
                      act('deposit_at', { x: gx, y: gy });
                    }
                  }
                }}
                onDoubleClick={(e: React.MouseEvent<HTMLDivElement>) => {
                  // Double-click empty space: attempt to withdraw first item? No, keep empty for now.
                }}
              >
                {/* Grid background */}
                {Array.from({ length: grid_h }).map((_, ry) => (
                  <React.Fragment key={ry}>
                    {Array.from({ length: grid_w }).map((_, rx) => (
                      <Box
                        key={`${rx}-${ry}`}
                        style={{
                          position: 'absolute',
                          left: rx * CELL,
                          top: ry * CELL,
                          width: CELL,
                          height: CELL,
                          boxSizing: 'border-box',
                          border: '1px solid #222',
                          background: (rx + ry) % 2 === 0
                            ? 'rgba(255,255,255,0.02)'
                            : 'rgba(0,0,0,0.02)',
                        }}
                      />
                    ))}
                  </React.Fragment>
                ))}

                {/* Items (stretch-to-fit) */}
                {items.map((item) => {
                  const dispRarity = getDisplayRarity(item);
                  const rarityColor = getRarityColor(item) || undefined;
                  const box = (
                    <Box
                      style={{
                        position: 'absolute',
                        left: (item.x - 1) * CELL,
                        top: (item.y - 1) * CELL,
                        width: item.w * CELL,
                        height: item.h * CELL,
                        padding: 0,
                        background: '#222',
                        border: '1px solid #444',
                        imageRendering: 'pixelated',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        cursor: draggingUid === item.uid ? 'grabbing' : 'pointer',
                        opacity: draggingUid === item.uid ? 0.35 : 1,
                        // Subtle rarity glow; animate for Epic+
                        boxShadow: rarityColor ? `0 0 8px 2px ${rarityColor}40, inset 0 0 0 1px ${rarityColor}33` : undefined,
                        animation: dispRarity && dispRarity >= 4 ? 'rwStashPulse 2.6s ease-in-out infinite' : undefined,
                      }}
                      // No native drag props on Box; native ghost suppressed by inner wrapper's pointerEvents and draggable=false
                      onMouseDown={(e) => {
                        if (e.button === 0) {
                          // Immediate client-side pickup SFX request
                          act('sfx_pickup', { uid: item.uid });
                          setDraggingUid(item.uid);
                          setDragOrigin({ x: item.x, y: item.y });
                          setHoverCell({ x: item.x, y: item.y });
                          e.stopPropagation();
                        }
                      }}
                      onContextMenu={(e) => {
                        e.preventDefault();
                        // Right-click quick withdraw
                        act('withdraw', { uid: item.uid });
                      }}
                      onDoubleClick={(e) => {
                        // Quick withdraw on double click
                        act('withdraw', { uid: item.uid });
                        e.stopPropagation();
                      }}
                    >
                      {/* Inner rim, lightly colored by rarity */}
                      <div
                        style={{
                          position: 'absolute',
                          inset: 0,
                          border: `1px solid ${rarityColor ? rarityColor : '#333'}`,
                          opacity: rarityColor ? 0.5 : 1,
                          pointerEvents: 'none',
                        }}
                      />
                      {/* UID badge overlay (debug only) */}
                      {showDebug && (
                        <div
                          style={{
                            position: 'absolute',
                            left: 1,
                            top: 1,
                            background: 'rgba(0,0,0,0.55)',
                            color: '#f2d94c',
                            fontSize: 10,
                            lineHeight: '12px',
                            padding: '0 3px',
                            borderRadius: 2,
                            pointerEvents: 'none',
                            userSelect: 'none',
                          }}
                        >
                          {displayUid(item)}
                        </div>
                      )}
                      <div
                        style={{ pointerEvents: 'none', userSelect: 'none' }}
                        draggable={false}
                        onDragStart={(e) => e.preventDefault()}
                      >
                        <FitIcon item={item} />
                      </div>
                      {/* Name and rarity overlay (keep neutral text color here) */}
                      <div
                        style={{
                          position: 'absolute',
                          left: 1,
                          right: 1,
                          bottom: 1,
                          background: 'rgba(0,0,0,0.45)',
                          borderRadius: 2,
                          padding: '1px 2px',
                          pointerEvents: 'none',
                        }}
                      >
                        <div style={{
                          fontSize: 10,
                          lineHeight: '11px',
                          color: '#ddd',
                          whiteSpace: 'nowrap',
                          overflow: 'hidden',
                          textOverflow: 'ellipsis',
                        }}>{item.name || ''}</div>
                        <div style={{
                          fontSize: 9,
                          lineHeight: '10px',
                          color: '#bbb',
                          opacity: 0.9,
                          textAlign: 'center',
                        }}>{dispRarity ? RARITY_LABEL[dispRarity] : ''}</div>
                      </div>
                    </Box>
                  );
                  return (
                    <Tooltip key={item.uid} content={<ItemTooltip item={item} debug={showDebug} />} position="right">
                      {box}
                    </Tooltip>
                  );
                })}
                {draggingUid && hoverCell && (() => {
                  const item = findItem(draggingUid);
                  if (!item) return null;
                  return (
                    <Box
                      style={{
                        position: 'absolute',
                        left: (hoverCell.x - 1) * CELL,
                        top: (hoverCell.y - 1) * CELL,
                        width: item.w * CELL,
                        height: item.h * CELL,
                        pointerEvents: 'none',
                        border: placementBlocked ? '2px solid #cc3333' : '2px solid #f2d94c',
                        background: placementBlocked ? 'rgba(204,51,51,0.18)' : 'rgba(242,217,76,0.16)',
                        animation: placementBlocked ? 'pulseInvalid 1s infinite' : 'pulseValid 1.15s infinite',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                      }}
                    >
                      <DmIcon
                        icon={resolvePreviewIcon(item)}
                        icon_state={resolvePreviewState(item)}
                        style={{
                          opacity: 0.18,
                          imageRendering: 'pixelated',
                          width: '100%',
                          height: '100%',
                          objectFit: 'fill',
                          pointerEvents: 'none',
                        }}
                      />
                    </Box>
                  );
                })()}
                {/* Inject only placement pulse animations */}
                <style>{PULSE_STYLE}</style>
                {/* Gentle overall item pulse (no flames) */}
                <style>
                  {`@keyframes rwStashPulse {0%{filter: brightness(1)} 50%{filter: brightness(1.12)} 100%{filter: brightness(1)}}`}
                </style>
              </div>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
