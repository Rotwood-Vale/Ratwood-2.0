import React, { useEffect, useRef, useState } from 'react';
import { Box, Button, DmIcon, LabeledList, Section, Stack, Tooltip } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

// Types for backend data
type StashItem = {
  uid: number;
  path: string;
  name: string;
  icon?: string | null;
  icon_state?: string | null;
  item_state?: string | null;
  preview_icon?: string | null;
  preview_state?: string | null;
  preview_scale?: number | null;
  mob_overlay_icon?: string | null;
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
};

// Grid sizing
const CELL = 48; // one logical slot size (px)
const ICON_PAD = 6; // breathing room inside slot

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
  const [scale, setScale] = useState<number>(Math.max((item.preview_scale || 1), guessed));

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
      } catch {
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

export const RatworldStash = () => {
  const { data, act } = useBackend<Data>();
  const { currency, items, grid_w, grid_h } = data;

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
                  const rect = e.currentTarget.getBoundingClientRect();
                  const gx = Math.floor((e.clientX - rect.left) / CELL) + 1;
                  const gy = Math.floor((e.clientY - rect.top) / CELL) + 1;
                  if (gx >= 1 && gx <= grid_w && gy >= 1 && gy <= grid_h) {
                    if (e.button === 0) {
                      act('deposit_at', { x: gx, y: gy });
                    }
                  }
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

                {/* Items */}
                {items.map((item) => (
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
                      onContextMenu={(e) => {
                        e.preventDefault();
                        act('move', { uid: item.uid, x: 1, y: 1 });
                      }}
                    >
                      <AutoScaledIcon item={item} />
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
