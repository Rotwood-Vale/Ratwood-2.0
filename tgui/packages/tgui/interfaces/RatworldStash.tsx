<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
import React, { useEffect, useRef, useState } from 'react';
import { Box, Button, DmIcon, LabeledList, Section, Stack, Tooltip } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

// Backend-provided item record
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
import React from 'react';
import { Box, Button, DmIcon, LabeledList, Section, Stack, Tooltip } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
type StashItem = {
  uid: number;
  path: string;
  name: string;
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
  icon?: string;
  icon_state?: string;
  item_state?: string;
  preview_icon?: string;
  preview_state?: string;
  preview_scale?: number;
  mob_overlay_icon?: string;
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
  icon_state: string;
  icon?: string | null; // serialized icon file path
  mob_overlay_icon?: string | null; // optional on-mob sheet
  item_state?: string | null; // DM item_state for fallback
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
  rev: number;
};

// Grid sizing
const CELL = 48; // one logical slot size (px)
const ICON_PAD = 6; // breathing room around icon inside slot

// Tooltip with diagnostics for debugging scaling/icon metadata
const ItemTooltip = ({ item }: { item: StashItem }) => (
  <Stack vertical>
    <Stack.Item bold>{item.name}</Stack.Item>
    <Stack.Item italic>UID #{item.uid}</Stack.Item>
    <Stack.Item>icon: {String(item.icon || '')}</Stack.Item>
    <Stack.Item>icon_state: {String(item.icon_state || '')}</Stack.Item>
    <Stack.Item>item_state: {String(item.item_state || '')}</Stack.Item>
    <Stack.Item>preview_icon: {String(item.preview_icon || '')}</Stack.Item>
    <Stack.Item>preview_state: {String(item.preview_state || '')}</Stack.Item>
    <Stack.Item>preview_scale: {String(item.preview_scale || '')}</Stack.Item>
  </Stack>
);

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

// Generic content-aware scaling: measure non-transparent pixel bounds if possible,
// otherwise fall back to a sheet-based guess. Apply scaling via CSS transform for robustness.
const AutoScaledIcon = ({ item }: { item: StashItem }) => {
  const hostRef = useRef<HTMLDivElement | null>(null);
  // Fallback guess based on common sheet sizes (valuable/produce ~16px, clothing ~32px)
  const guessBase = (() => {
    const icon = resolvePreviewIcon(item) || '';
    const low = icon.toLowerCase();
    if (low.includes('valuable.dmi') || low.includes('produce.dmi')) return 16;
    return 32;
  })();
  const target = CELL - ICON_PAD;
  const guessed = Math.min(3, Math.max(1, target / guessBase));
  const [scale, setScale] = useState<number>(Math.max(item.preview_scale || 1, guessed));

  useEffect(() => {
    const host = hostRef.current;
    if (!host) return;
    const img: HTMLImageElement | null = host.querySelector('img');
    const measure = () => {
      if (!img || !img.naturalWidth || !img.naturalHeight) return;
      try {
        const canvas = document.createElement('canvas');
        canvas.width = img.naturalWidth;
        canvas.height = img.naturalHeight;
        const ctx = canvas.getContext('2d');
        if (!ctx) return;
        ctx.drawImage(img, 0, 0);
        const { data } = ctx.getImageData(0, 0, canvas.width, canvas.height);
        let minX = canvas.width, minY = canvas.height, maxX = 0, maxY = 0, count = 0;
        for (let y = 0; y < canvas.height; y++) {
          for (let x = 0; x < canvas.width; x++) {
            const i = (y * canvas.width + x) * 4;
            const a = data[i + 3];
            if (a > 32) {
              count++;
              if (x < minX) minX = x;
              if (y < minY) minY = y;
              if (x > maxX) maxX = x;
              if (y > maxY) maxY = y;
            }
          }
        }
        if (!count) return;
        const bw = maxX - minX + 1;
        const bh = maxY - minY + 1;
        const factor = Math.min(3, Math.max(1, target / Math.max(bw, bh)));
        setScale((prev) => (prev < factor ? factor : prev));
      } catch (e) {
        // ignore measurement failures
      }
    };
    if (img) {
      if (img.complete) measure(); else img.onload = measure;
    }
  }, [item.uid, target]);

  const base = target; // render logical base size, then scale via transform

  return (
    <div
      ref={hostRef}
      style={{
        width: base,
        height: base,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        overflow: 'hidden',
      }}
    >
      <div
        style={{
          width: base,
          height: base,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          imageRendering: 'pixelated',
          transform: `scale(${scale})`,
          transformOrigin: 'center center',
        }}
      >
        <DmIcon
          icon={resolvePreviewIcon(item)}
          icon_state={resolvePreviewState(item)}
          width={base}
          height={base}
        />
      </div>
    </div>
  );
};

export const RatworldStash = (props) => {
  const { data, act } = useBackend<Data>();
  const { currency, items, grid_w, grid_h } = data;

  return (
    <Window
      width={Math.max(360, grid_w * CELL + 32)}
      height={Math.max(360, grid_h * CELL + 160)}
      title="Ratworld Reliquary"
    >
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
  rev: number; // simple versioning counter
};

// Rough Diablo 2 style: grid of item squares. We don't have size yet, treat each as 1x1.
// Future: add width/height, rarity border colors, socket render, etc.

const CELL = 48; // size of a single grid cell in px (crisper for clothing icons)

export const RatworldStash = () => {
  const { data, act } = useBackend<Data>();
  const { currency, items, grid_w, grid_h } = data;

  // Fill grid cells with items; if more than grid size, scroll area will handle overflow.
  // For now unlimited rows; each row has GRID_COLS.
  return (
    <Window width={500} height={500} title="Ratworld Reliquary">
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Ledger">
              <LabeledList>
                <LabeledList.Item label="Mammon">{currency}</LabeledList.Item>
                <LabeledList.Item label="Actions">
                  <Button
                    icon="arrow-up"
                    onClick={() => act('deposit_hand')}
                    tooltip="Deposit item in your active hand"
                  >
                    Deposit Hand
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
          <Stack.Item grow>
            <Section title="Stash" fill>
              <Box
                position="relative"
                style={{
                  width: grid_w * CELL,
                  height: grid_h * CELL,
                  background: '#111',
                  border: '2px solid #333',
                }}
                onMouseDown={(e: React.MouseEvent<HTMLDivElement>) => {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
                  const rect = e.currentTarget.getBoundingClientRect();
=======
                  // Deposit item at clicked cell if any
                  const rect = (e.currentTarget as HTMLDivElement).getBoundingClientRect();
>>>>>>> Stashed changes
=======
                  // Deposit item at clicked cell if any
                  const rect = (e.currentTarget as HTMLDivElement).getBoundingClientRect();
>>>>>>> Stashed changes
=======
                  // Deposit item at clicked cell if any
                  const rect = (e.currentTarget as HTMLDivElement).getBoundingClientRect();
>>>>>>> Stashed changes
                  const gx = Math.floor((e.clientX - rect.left) / CELL) + 1;
                  const gy = Math.floor((e.clientY - rect.top) / CELL) + 1;
                  if (gx >= 1 && gx <= grid_w && gy >= 1 && gy <= grid_h) {
                    if (e.button === 0) {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======
                      // Left click deposits
>>>>>>> Stashed changes
=======
                      // Left click deposits
>>>>>>> Stashed changes
=======
                      // Left click deposits
>>>>>>> Stashed changes
                      act('deposit_at', { x: gx, y: gy });
                    }
                  }
                }}
              >
                {/* Grid background */}
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
                {Array.from({ length: grid_h }).map((_, ry) => (
                  <React.Fragment key={ry}>
                    {Array.from({ length: grid_w }).map((_, rx) => (
                      <Box
                        key={`${rx}-${ry}`}
                        style={{
                          position: 'absolute',
                          left: rx * CELL,
                          top: ry * CELL,
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                {[...Array(grid_h)].map((_, gy) => (
                  <React.Fragment key={gy}>
                    {[...Array(grid_w)].map((_, gx) => (
                      <Box
                        key={`${gx}-${gy}`}
                        style={{
                          position: 'absolute',
                          left: gx * CELL,
                          top: gy * CELL,
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                          width: CELL,
                          height: CELL,
                          boxSizing: 'border-box',
                          border: '1px solid #222',
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
                          background:
                            (rx + ry) % 2 === 0
                              ? 'rgba(255,255,255,0.02)'
                              : 'rgba(0,0,0,0.02)',
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                        }}
                      />
                    ))}
                  </React.Fragment>
                ))}
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream

                {/* Items */}
                {items.map(item => (
=======
                {/* Items */}
                {items.map((item) => (
>>>>>>> Stashed changes
=======
                {/* Items */}
                {items.map((item) => (
>>>>>>> Stashed changes
=======
                {/* Items */}
                {items.map((item) => (
>>>>>>> Stashed changes
                  <Tooltip key={item.uid} content={<ItemTooltip item={item} />} position="right">
                    <Box
                      style={{
                        position: 'absolute',
                        left: (item.x - 1) * CELL,
                        top: (item.y - 1) * CELL,
                        width: item.w * CELL,
                        height: item.h * CELL,
                        padding: 2,
                        background: '#222',
                        border: '1px solid #555',
                        overflow: 'hidden',
                        imageRendering: 'pixelated',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        cursor: 'pointer',
                      }}
                      onClick={() => act('withdraw', { uid: item.uid })}
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
                      onContextMenu={e => {
=======
                      onContextMenu={(e) => {
                        // Right-click to move item to top-left as simple demo
>>>>>>> Stashed changes
=======
                      onContextMenu={(e) => {
                        // Right-click to move item to top-left as simple demo
>>>>>>> Stashed changes
=======
                      onContextMenu={(e) => {
                        // Right-click to move item to top-left as simple demo
>>>>>>> Stashed changes
                        e.preventDefault();
                        act('move', { uid: item.uid, x: 1, y: 1 });
                      }}
                    >
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
                      <AutoScaledIcon item={item} />
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                      <DmIcon
                        icon={resolveIconSheet(item)}
                        icon_state={resolveIconState(item)}
                        width={CELL}
                        height={CELL}
                      />
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                    </Box>
                  </Tooltip>
                ))}
              </Box>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

interface ItemTooltipProps { item: StashItem }
const ItemTooltip = ({ item }: ItemTooltipProps) => {
  return (
    <Stack vertical>
      <Stack.Item bold>{item.name}</Stack.Item>
      <Stack.Item italic>UID #{item.uid}</Stack.Item>
      <Stack.Item>icon: {String((item as any).icon || '')}</Stack.Item>
      <Stack.Item>icon_state: {String(item.icon_state || '')}</Stack.Item>
      <Stack.Item>item_state: {String((item as any).item_state || '')}</Stack.Item>
      {/* Future: rarity color, sockets, stats, etc. */}
    </Stack>
  );
};

// Utility to chunk an array.
function chunk<T>(arr: T[], size: number): T[][] {
  const out: T[][] = [];
  for (let i = 0; i < arr.length; i += size) {
    out.push(arr.slice(i, i + size));
  }
  return out;
}

// Minimal fallback if backend lacks icon info; use a known small sheet
function inferIcon(dmPath: string): string {
  return 'icons/roguetown/items/produce.dmi';
}

function resolveIconSheet(item: StashItem): string {
  // Prefer explicit icon from backend
  if (item.icon) return item.icon;
  // Try on-mob overlay sheet if present, but prefer inventory counterpart (strip /onmob/)
  const moi = (item as any).mob_overlay_icon as string | undefined;
  if (moi) {
    if (moi.includes('/onmob/')) {
      return moi.replace('/onmob/', '/');
    }
    return moi;
  }
  // Fallback by path
  return inferIcon(item.path);
}

function resolveIconState(item: StashItem): string {
  // Prefer DM item_state for inventory icons when available
  if ((item as any).item_state && (item as any).item_state !== '') return (item as any).item_state as string;
  // Fallback to icon_state
  if (item.icon_state && item.icon_state !== '') return item.icon_state;
  return 'default';
}
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
