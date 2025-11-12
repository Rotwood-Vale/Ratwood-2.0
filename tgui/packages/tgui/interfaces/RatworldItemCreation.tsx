import React, { useEffect, useState } from 'react';
import { Box, Button, Dropdown, Input, LabeledList, NumberInput, Section, Stack, Tabs, DmIcon } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

// Types from backend
interface SearchResult { path: string; name?: string; icon?: string; icon_state?: string }
interface RarityEntry { id: number; name: string; color: string; slots: number; special?: boolean; ascendant?: boolean }
interface EnchantOption { id: string; name: string; min: number; max: number; percent?: boolean }

interface Data {
  search: string;
  results: SearchResult[];
  selected: { path?: string; icon?: string; icon_state?: string; name?: string };
  show_search?: boolean;
  rarities: RarityEntry[];
  rarity: number;
  attr_slots: number;
  slot_key: string;
  slot_keys: string[];
  enchant_options: EnchantOption[];
  ench_ids: (string | null)[];
  ench_vals: (number | null)[];
  name: string;
  desc: string;
  color: string;
}

const RarityTag = ({ r }: { r: RarityEntry }) => (
  <Box
    style={{
      color: r.color,
      textShadow: r.ascendant
        ? '0 0 6px rgba(108,43,217,0.9), 0 0 10px rgba(108,43,217,0.6)'
        : r.special
        ? '0 0 6px rgba(255,255,255,0.25)'
        : undefined,
      fontWeight: 700,
    }}
  >
    {r.name}
  </Box>
);

export const RatworldItemCreation = () => {
  const { data, act } = useBackend<Data>();
  const d: Partial<Data> = (data as any) || {};
  // Local search input with debounce to avoid searching on every keystroke
  const [q, setQ] = useState<string>((d && d.search) || '');
  // Derived view: show search pane when nothing selected
  const hasSelection = !!(d && d.selected && d.selected.path);
  useEffect(() => {
    const id = setTimeout(() => {
      if (q !== (d && d.search)) act('search', { q });
    }, 400);
    return () => clearTimeout(id);
  }, [q, d.search, act]);

  const raritiesSafe = Array.isArray((d as any) && (d as any).rarities) ? (d as any).rarities : [];
  const rarityTabs = (
    <Tabs>
      {raritiesSafe.map((r) => (
        <Tabs.Tab key={r.id} selected={d?.rarity === r.id} onClick={() => act('set_rarity', { rarity: r.id })}>
          <RarityTag r={r} />
        </Tabs.Tab>
      ))}
    </Tabs>
  );

  const enchOptions = Array.isArray((d as any) && (d as any).enchant_options) ? (d as any).enchant_options : [];
  const optionsForDropdown = enchOptions.map((o) => ({ value: o.id, displayText: `${o.name}` }));
  const slotKeys = Array.isArray((d as any) && (d as any).slot_keys) ? (d as any).slot_keys : [];
  const results = Array.isArray((d as any) && (d as any).results) ? (d as any).results : [];
  const attrSlots = (typeof (d as any).attr_slots === 'number' && isFinite((d as any).attr_slots as any)) ? ((d as any).attr_slots as any as number) : 0;
  const selectedIcon = d && d.selected && d.selected.icon ? d.selected.icon : 'icons/roguetown/items/produce.dmi';
  const selectedState = d && d.selected && d.selected.icon_state ? d.selected.icon_state : 'default';
  const selectedName = d && d.selected && d.selected.name ? d.selected.name : undefined;
  const slotKey = d && d.slot_key ? d.slot_key : '';
  const showSearch = !!(d && d.show_search);

  return (
    <Window width={880} height={640}>
      <Window.Content scrollable>
        <Stack vertical fill>
          {showSearch && (
          <Section title="Search">
            <Stack>
              <Input
                fluid
                value={q}
                onChange={(v: string) => setQ(v)}
                placeholder="Type to search by name or type path..."
              />
              <Button ml={1} onClick={() => act('search', { q })} content="Search" />
              <Button ml={1} onClick={() => act('toggle_search')} content="Close" />
            </Stack>
            <Stack wrap>
              {results.map((r) => (
                <Box key={r.path} mr={2} mb={2} p={1} style={{ border: '1px solid rgba(255,255,255,0.15)', borderRadius: 2, width: 128 }}>
                  <Stack vertical align="center">
                    <Box width={12} height={12} m={1}>
                      <DmIcon
                        icon={r.icon || 'icons/roguetown/items/produce.dmi'}
                        icon_state={r.icon_state || 'default'}
                        style={{ width: '100%', height: '100%', imageRendering: 'pixelated' }}
                      />
                    </Box>
                    <Box color="label" textAlign="center" style={{ maxWidth: 200, wordBreak: 'break-word' }}>
                      {r.name || r.path}
                    </Box>
                    <Button
                      mt={1}
                      color="good"
                      content="Select item"
                      onClick={() => {
                        act('select_type', { path: r.path });
                        setQ('');
                      }}
                    />
                  </Stack>
                </Box>
              ))}
            </Stack>
          </Section>
          )}

          {
          <Section title="Preview & Customize" fill>
            <Stack align="flex-start">
              {/* 64x64 fixed preview in a small card */}
              <Stack.Item>
                <Box
                  width={72}
                  height={72}
                  mr={2}
                  p={1}
                  style={{
                    border: '1px solid rgba(255,255,255,0.25)',
                    background: 'rgba(0,0,0,0.25)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                  }}
                >
                  <Box width={64} height={64} style={{ overflow: 'hidden' }}>
                    <DmIcon
                      icon={selectedIcon}
                      icon_state={selectedState}
                      style={{ imageRendering: 'pixelated', width: '100%', height: '100%', objectFit: 'contain', pointerEvents: 'none', userSelect: 'none' }}
                    />
                  </Box>
                </Box>
              </Stack.Item>
              <Stack.Item grow>
                <Box style={{ maxHeight: 520, overflowY: 'auto' }}>
                  <Stack vertical>
                  <Stack align="baseline" justify="space-between">
                    <Box bold>Rarity</Box>
                    <Button content="Search items" onClick={() => act('toggle_search')} />
                  </Stack>
                  {rarityTabs}
                  <LabeledList>
                    <LabeledList.Item label="Item slot">
                      <Dropdown
                        selected={slotKey}
                        options={slotKeys.map((k) => ({ value: k, displayText: k }))}
                        onSelected={(v) => act('set_slot_key', { slot_key: v })}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Name">
                      <Input value={(d && d.name) || ''} onChange={(v: string) => act('set_name', { name: v })} placeholder={selectedName || 'Optional custom name'} />
                    </LabeledList.Item>
                    <LabeledList.Item label="Description">
                      <Input value={(d && d.desc) || ''} onChange={(v: string) => act('set_desc', { desc: v })} placeholder="Optional description" />
                    </LabeledList.Item>
                    <LabeledList.Item label="Color (hex)">
                      <Input value={(d && d.color) || ''} onChange={(v: string) => act('set_color', { color: v })} placeholder="#RRGGBB" />
                    </LabeledList.Item>
                       <LabeledList.Item label={`Enchantments (${attrSlots})`} />
                       {Array.from({ length: attrSlots }).map((_, i) => {
                      const idx = i + 1;
                         const currentId = (d && d.ench_ids && d.ench_ids[i]) ? d.ench_ids[i] : null;
                         const current = enchOptions.find((o) => o.id === currentId);
                      const hint = current ? `${current.min} - ${current.max}${current.percent ? '%' : ''}` : '';
                      return (
                        <LabeledList.Item key={idx} label={`Slot ${idx}`}>
                          <Stack align="center">
                            <Dropdown
                              selected={currentId || undefined}
                              options={optionsForDropdown}
                              onSelected={(v) => act('set_ench', { index: idx, id: v })}
                              placeholder="Pick enchantment"
                            />
                            <Box width={40} ml={1} mr={1} color="label" textAlign="center">
                              {hint}
                            </Box>
                            <NumberInput
                              disabled={!currentId}
                                 value={(d && d.ench_vals && (d.ench_vals[i] as any)) ? (d.ench_vals[i] as any) : 0}
                              minValue={current?.min ?? 0}
                              maxValue={current?.max ?? 0}
                              step={current && (current.min % 1 !== 0 || current.max % 1 !== 0) ? 0.1 : 1}
                              onChange={(val: number) => currentId && act('set_ench_val', { id: currentId, val })}
                              style={{ width: 120, marginLeft: 4 }}
                            />
                            <Box ml={1}>{current?.percent ? '%' : ''}</Box>
                          </Stack>
                        </LabeledList.Item>
                      );
                    })}
                  </LabeledList>
                    <Box width="100%" textAlign="center" mt={2}>
                      <Button
                        disabled={!(d && d.selected && d.selected.path)}
                        content="Create Item"
                        onClick={() => act('create')}
                        color="good"
                        bold
                      />
                    </Box>
                  </Stack>
                </Box>
              </Stack.Item>
            </Stack>
          </Section>
          }
        </Stack>
      </Window.Content>
    </Window>
  );
};
