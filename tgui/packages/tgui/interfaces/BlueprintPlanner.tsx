import { useEffect, useMemo, useRef, useState } from 'react';
import { Box, Button, Icon, Input, Section, Stack, Tabs } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type BuildableType = {
  name: string;
  category: string;
  layer_type: 'floor' | 'wall' | 'obj' | 'border';
  reqs_text: string;
  image: string;
};

type GridCell = {
  x: number;
  y: number;
  z: number;
  type: string;
  dir?: number;
};

type ScannedCell = {
  x: number;
  y: number;
  z: number;
  layer: 'wall' | 'floor';
};

type Data = {
  buildable_types?: Record<string, BuildableType>;
  saved_grid?: GridCell[];
  saved_floors?: number;
  scanned_grid?: ScannedCell[];
};

const DIRS = {
  NORTH: 1,
  SOUTH: 2,
  EAST: 4,
  WEST: 8,
};

const DIR_ICONS: Record<number, string> = {
  1: 'arrow-up',
  2: 'arrow-down',
  4: 'arrow-right',
  8: 'arrow-left',
};

const NEXT_DIR: Record<number, number> = {
  1: 4,
  4: 2,
  2: 8,
  8: 1,
};

export const BlueprintPlanner = () => {
  const { act, data } = useBackend<Data>();
  const [selectedBrush, setSelectedBrush] = useState<string | null>(null);
  const [selectedCategory, setSelectedCategory] = useState<string>('All');
  const [searchText, setSearchText] = useState<string>('');

  const [currentDir, setCurrentDir] = useState<number>(DIRS.SOUTH);
  const [totalFloors, setTotalFloors] = useState<number>(2);
  const [activeZ, setActiveZ] = useState<number>(0);
  const [gridRadius, setGridRadius] = useState<number>(3);

  const [grid, setGrid] = useState<GridCell[]>([]);
  const [hoveredCell, setHoveredCell] = useState<{ x: number; y: number } | null>(null);

  const [confirmClear, setConfirmClear] = useState<boolean>(false);

  const initialized = useRef(false);

  useEffect(() => {
    if (!initialized.current && data.saved_grid !== undefined) {
      setGrid(data.saved_grid);
      if (data.saved_floors) {
        setTotalFloors(data.saved_floors);
      }
      initialized.current = true;
    }
  }, [data.saved_grid, data.saved_floors]);

  const buildableTypes = data.buildable_types || {};

  const handleCellClick = (x: number, y: number) => {
    setGrid((prev) => {
      if (!selectedBrush) {
        const cellItems = prev.filter((c) => c.x === x && c.y === y && c.z === activeZ);
        if (cellItems.length === 0) return prev;

        const border = cellItems.find((c) => buildableTypes[c.type]?.layer_type === 'border' && c.dir === currentDir);
        if (border) return prev.filter((c) => c !== border);

        const obj = cellItems.find((c) => buildableTypes[c.type]?.layer_type === 'obj');
        if (obj) return prev.filter((c) => c !== obj);

        return prev.filter((c) => !(c.x === x && c.y === y && c.z === activeZ));
      }

      const brushInfo = buildableTypes[selectedBrush];
      if (!brushInfo) return prev;
      const layer = brushInfo.layer_type;

      const hasWall = prev.some(
        (c) => c.x === x && c.y === y && c.z === activeZ && buildableTypes[c.type]?.layer_type === 'wall'
      );

      if (layer !== 'wall' && hasWall) {
        return prev;
      }

      const newGrid = prev.filter((c) => {
        if (c.x !== x || c.y !== y || c.z !== activeZ) return true;

        const cLayer = buildableTypes[c.type]?.layer_type;
        if (layer === 'wall') return false;
        if (layer === 'border' && cLayer === 'border' && c.dir === currentDir) return false;
        if (layer === 'obj' && cLayer === 'obj') return false;
        if (layer === 'floor' && cLayer === 'floor') return false;

        return true;
      });

      return [...newGrid, { x, y, z: activeZ, type: selectedBrush, dir: currentDir }];
    });
  };

  const handleCellContextMenu = (e: React.MouseEvent, x: number, y: number) => {
    e.preventDefault();
    setGrid((prev) => {
      return prev.map((c) => {
        if (c.x === x && c.y === y && c.z === activeZ && buildableTypes[c.type]?.layer_type === 'obj') {
          const oldDir = c.dir || DIRS.SOUTH;
          return { ...c, dir: NEXT_DIR[oldDir] || DIRS.NORTH };
        }
        return c;
      });
    });
  };

  const changeFloorCount = (delta: number) => {
    const newCount = Math.max(2, Math.min(4, totalFloors + delta));
    setTotalFloors(newCount);
    if (activeZ >= newCount) {
      setActiveZ(newCount - 1);
    }
    setGrid((prev) => prev.filter((c) => c.z < newCount));
  };

  const changeGridRadius = (delta: number) => {
    const newRad = Math.max(1, Math.min(10, gridRadius + delta));
    setGridRadius(newRad);
  };

  const saveDesign = () => {
    const packed_data: Record<string, string[]> = {};

    grid.forEach((c) => {
      if (c.z >= totalFloors) return;
      if (!packed_data[c.type]) packed_data[c.type] = [];
      packed_data[c.type].push(`${c.x},${c.y},${c.z},${c.dir || 2}`);
    });

    act('save_design', {
      packed_data,
      max_floors: totalFloors,
    });
  };

  const handleScan = () => {
    act('scan_terrain', {
      radius: 10,
      max_floors: totalFloors,
    });
  };

  const handleClear = () => {
    if (!confirmClear) {
      setConfirmClear(true);
      setTimeout(() => setConfirmClear(false), 3000);
    } else {
      setGrid([]);
      act('clear_design');
      setConfirmClear(false);
    }
  };

  const cells = useMemo(() => {
    const result: { x: number; y: number }[] = [];
    for (let y = gridRadius; y >= -gridRadius; y--) {
      for (let x = -gridRadius; x <= gridRadius; x++) {
        result.push({ x, y });
      }
    }
    return result;
  }, [gridRadius]);

  const cellMap = useMemo(() => {
    const map: Record<string, GridCell[]> = {};
    grid.forEach((c) => {
      const key = `${c.x}_${c.y}_${c.z}`;
      if (!map[key]) map[key] = [];
      map[key].push(c);
    });
    return map;
  }, [grid]);

  const scannedMap = useMemo(() => {
    const map: Record<string, ScannedCell> = {};
    (data.scanned_grid || []).forEach((c) => {
      map[`${c.x}_${c.y}_${c.z}`] = c;
    });
    return map;
  }, [data.scanned_grid]);

  const categories = useMemo(() => {
    const cats = new Set<string>();
    cats.add('All');
    Object.values(buildableTypes).forEach((item) => {
      if (item.category) cats.add(item.category);
    });
    return Array.from(cats);
  }, [buildableTypes]);

  const filteredKeys = useMemo(() => {
    return Object.keys(buildableTypes).filter((key) => {
      const item = buildableTypes[key];
      const matchCat = selectedCategory === 'All' || item.category === selectedCategory;
      const matchSearch = !searchText || item.name.toLowerCase().includes(searchText.toLowerCase());
      return matchCat && matchSearch;
    });
  }, [buildableTypes, selectedCategory, searchText]);

  const floorNames = [
    '1st Floor (Ground)',
    totalFloors === 2 ? '2nd Floor / Roof' : '2nd Floor',
    totalFloors === 3 ? '3rd Floor / Roof' : '3rd Floor',
    '4th Floor / Roof',
  ];

  const currentGridDimension = `${gridRadius * 2 + 1}x${gridRadius * 2 + 1}`;

  return (
    <Window title="Architectural Blueprint" width={1080} height={700}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width="340px">
            <Section title="Structures & Furniture" fill>
              <Stack vertical fill>
                <Stack.Item mb={1}>
                  <Input
                    fluid
                    placeholder="Search structure..."
                    value={searchText}
                    onChange={(e: any) => setSearchText(e.target.value)}
                  />
                </Stack.Item>

                <Stack.Item mb={1}>
                  <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
                    {categories.map((cat) => (
                      <Button
                        key={cat}
                        selected={selectedCategory === cat}
                        onClick={() => setSelectedCategory(cat)}
                        style={{ fontSize: '0.85em', padding: '3px 6px' }}
                      >
                        {cat}
                      </Button>
                    ))}
                  </Box>
                </Stack.Item>

                <Stack.Item mb={1}>
                  <Stack align="center" justify="space-between">
                    <Stack.Item>
                      <Button
                        icon="eraser"
                        selected={selectedBrush === null}
                        onClick={() => setSelectedBrush(null)}
                      >
                        Eraser
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Stack align="center">
                        <Box fontSize="0.85em" color="gray" mr={0.5}>
                          Dir:
                        </Box>
                        <Button
                          icon="arrow-up"
                          selected={currentDir === DIRS.NORTH}
                          onClick={() => setCurrentDir(DIRS.NORTH)}
                        />
                        <Button
                          icon="arrow-right"
                          selected={currentDir === DIRS.EAST}
                          onClick={() => setCurrentDir(DIRS.EAST)}
                        />
                        <Button
                          icon="arrow-down"
                          selected={currentDir === DIRS.SOUTH}
                          onClick={() => setCurrentDir(DIRS.SOUTH)}
                        />
                        <Button
                          icon="arrow-left"
                          selected={currentDir === DIRS.WEST}
                          onClick={() => setCurrentDir(DIRS.WEST)}
                        />
                      </Stack>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                <Stack.Item grow style={{ overflowY: 'auto', minHeight: 0 }}>
                  {filteredKeys.map((key) => {
                    const info = buildableTypes[key];
                    return (
                      <Button
                        key={key}
                        fluid
                        mb={1}
                        selected={selectedBrush === key}
                        onClick={() => setSelectedBrush(key)}
                        style={{
                          minHeight: '48px',
                          padding: '6px 10px',
                          display: 'flex',
                          alignItems: 'center',
                        }}
                      >
                        <Stack align="center" fill>
                          <Stack.Item mr={1.5}>
                            <Box
                              style={{
                                width: '32px',
                                height: '32px',
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                flexShrink: 0,
                              }}
                            >
                              {info.image && (
                                <img
                                  src={`data:image/png;base64,${info.image}`}
                                  style={{
                                    width: '32px',
                                    height: '32px',
                                    imageRendering: 'pixelated',
                                    pointerEvents: 'none',
                                  }}
                                />
                              )}
                            </Box>
                          </Stack.Item>
                          <Stack.Item grow textAlign="left">
                            <Box bold fontSize="0.95em" style={{ lineHeight: '1.2em' }}>
                              {info.name}
                            </Box>
                            <Box
                              fontSize="0.8em"
                              color="#bbb"
                              style={{ lineHeight: '1.2em', marginTop: '2px' }}
                            >
                              {info.reqs_text}
                            </Box>
                          </Stack.Item>
                        </Stack>
                      </Button>
                    );
                  })}
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section
              title="Workspace (RMB to rotate furniture)"
              fill
              buttons={
                <Stack align="center">
                  <Button color="blue" icon="satellite-dish" onClick={handleScan}>
                    Scan Area
                  </Button>
                  <Button
                    color={confirmClear ? "bad" : "danger"}
                    icon="trash"
                    onClick={handleClear}
                  >
                    {confirmClear ? "Confirm Clear?" : "Clear"}
                  </Button>
                  <Button color="good" icon="save" onClick={saveDesign}>
                    Finish Blueprint
                  </Button>
                </Stack>
              }
            >
              <Stack vertical fill>
                <Stack.Item mb={1}>
                  <Stack align="center" justify="space-between">
                    <Stack.Item grow>
                      <Tabs>
                        {Array.from({ length: totalFloors }).map((_, idx) => (
                          <Tabs.Tab
                            key={idx}
                            selected={activeZ === idx}
                            onClick={() => setActiveZ(idx)}
                          >
                            {floorNames[idx]}
                          </Tabs.Tab>
                        ))}
                      </Tabs>
                    </Stack.Item>

                    <Stack.Item ml={2}>
                      <Stack align="center">
                        <Box fontSize="0.85em" color="gray" mr={0.5}>
                          Grid:
                        </Box>
                        <Button
                          disabled={gridRadius <= 1}
                          onClick={() => changeGridRadius(-1)}
                        >
                          -
                        </Button>
                        <Box bold mx={1} color="#6e4106" style={{ minWidth: '55px', textAlign: 'center' }}>
                          {currentGridDimension}
                        </Box>
                        <Button
                          disabled={gridRadius >= 10}
                          onClick={() => changeGridRadius(1)}
                        >
                          +
                        </Button>

                        <Box mx={1.5} color="#444">|</Box>

                        <Box fontSize="0.85em" color="gray" mr={0.5}>
                          Floors:
                        </Box>
                        <Button
                          disabled={totalFloors <= 2}
                          onClick={() => changeFloorCount(-1)}
                        >
                          -
                        </Button>
                        <Box bold mx={1} color="white" style={{ minWidth: '20px', textAlign: 'center' }}>
                          {totalFloors}
                        </Box>
                        <Button
                          disabled={totalFloors >= 4}
                          onClick={() => changeFloorCount(1)}
                        >
                          +
                        </Button>
                      </Stack>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                <Stack.Item grow style={{ overflow: 'auto', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <Box
                    onMouseLeave={() => setHoveredCell(null)}
                    style={{
                      display: 'grid',
                      gridTemplateColumns: `repeat(${gridRadius * 2 + 1}, 36px)`,
                      gridTemplateRows: `repeat(${gridRadius * 2 + 1}, 36px)`,
                      gap: '2px',
                      backgroundColor: 'rgba(0, 0, 0, 0.4)',
                      padding: '12px',
                      borderRadius: '4px',
                      border: '1px solid #333',
                      margin: 'auto',
                    }}
                  >
                    {cells.map((cell) => {
                      const currentLayerCells = cellMap[`${cell.x}_${cell.y}_${activeZ}`] || [];
                      const lowerLayerCells = activeZ > 0 ? (cellMap[`${cell.x}_${cell.y}_${activeZ - 1}`] || []) : [];

                      const scannedCell = scannedMap[`${cell.x}_${cell.y}_${activeZ}`];

                      const floorTile = currentLayerCells.find((c) => buildableTypes[c.type]?.layer_type === 'floor');
                      const wallTile = currentLayerCells.find((c) => buildableTypes[c.type]?.layer_type === 'wall');
                      const objTile = currentLayerCells.find((c) => buildableTypes[c.type]?.layer_type === 'obj');
                      const borderTiles = currentLayerCells.filter((c) => buildableTypes[c.type]?.layer_type === 'border');

                      const lowerTile =
                        lowerLayerCells.find((c) => buildableTypes[c.type]?.layer_type === 'wall') ||
                        lowerLayerCells.find((c) => buildableTypes[c.type]?.layer_type === 'floor') ||
                        lowerLayerCells[0];

                      const hasNorthBorder = borderTiles.some((b) => b.dir === DIRS.NORTH);
                      const hasSouthBorder = borderTiles.some((b) => b.dir === DIRS.SOUTH);
                      const hasEastBorder = borderTiles.some((b) => b.dir === DIRS.EAST);
                      const hasWestBorder = borderTiles.some((b) => b.dir === DIRS.WEST);

                      const isCenter = cell.x === 0 && cell.y === 0;

                      const isHovered = hoveredCell?.x === cell.x && hoveredCell?.y === cell.y;
                      const ghostInfo = isHovered && selectedBrush ? buildableTypes[selectedBrush] : null;

                      const floorInfo = floorTile ? buildableTypes[floorTile.type] : undefined;
                      const wallInfo = wallTile ? buildableTypes[wallTile.type] : undefined;
                      const objInfo = objTile ? buildableTypes[objTile.type] : undefined;
                      const primaryBorderInfo = borderTiles.length > 0 ? buildableTypes[borderTiles[0].type] : undefined;
                      const lowerInfo = lowerTile ? buildableTypes[lowerTile.type] : undefined;

                      return (
                        <div
                          key={`${cell.x}_${cell.y}_${activeZ}`}
                          onClick={() => handleCellClick(cell.x, cell.y)}
                          onContextMenu={(e) => handleCellContextMenu(e, cell.x, cell.y)}
                          onMouseEnter={() => setHoveredCell({ x: cell.x, y: cell.y })}
                          style={{
                            width: '36px',
                            height: '36px',
                            backgroundColor: '#151515',
                            border: isCenter ? '2px solid #e74c3c' : '1px solid #2a2a2a',
                            cursor: 'pointer',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            position: 'relative',
                            userSelect: 'none',
                          }}
                        >
                          {scannedCell?.layer === 'wall' && (
                            <div style={{
                              position: 'absolute',
                              width: '100%',
                              height: '100%',
                              backgroundColor: 'rgba(200, 200, 200, 0.25)',
                              boxShadow: 'inset 0 0 4px rgba(0,0,0,0.8)',
                              pointerEvents: 'none',
                            }} />
                          )}
                          {scannedCell?.layer === 'floor' && (
                            <div style={{
                              position: 'absolute',
                              width: '100%',
                              height: '100%',
                              backgroundColor: 'rgba(100, 150, 100, 0.2)',
                              pointerEvents: 'none',
                            }} />
                          )}

                          {!floorInfo && !wallInfo && !objInfo && borderTiles.length === 0 && lowerInfo?.image && (
                            <img
                              src={`data:image/png;base64,${lowerInfo.image}`}
                              style={{
                                width: '32px',
                                height: '32px',
                                opacity: 0.28,
                                position: 'absolute',
                                pointerEvents: 'none',
                                imageRendering: 'pixelated',
                              }}
                            />
                          )}

                          {wallInfo?.image && (
                            <img
                              src={`data:image/png;base64,${wallInfo.image}`}
                              style={{
                                width: '32px',
                                height: '32px',
                                position: 'absolute',
                                pointerEvents: 'none',
                                imageRendering: 'pixelated',
                              }}
                            />
                          )}

                          {floorInfo?.image && (
                            <img
                              src={`data:image/png;base64,${floorInfo.image}`}
                              style={{
                                width: '32px',
                                height: '32px',
                                position: 'absolute',
                                pointerEvents: 'none',
                                imageRendering: 'pixelated',
                              }}
                            />
                          )}

                          {objInfo?.image && (
                            <img
                              src={`data:image/png;base64,${objInfo.image}`}
                              style={{
                                width: '32px',
                                height: '32px',
                                position: 'absolute',
                                pointerEvents: 'none',
                                imageRendering: 'pixelated',
                              }}
                            />
                          )}

                          {!objInfo && primaryBorderInfo?.image && (
                            <img
                              src={`data:image/png;base64,${primaryBorderInfo.image}`}
                              style={{
                                width: '28px',
                                height: '28px',
                                opacity: 0.8,
                                position: 'absolute',
                                pointerEvents: 'none',
                                imageRendering: 'pixelated',
                              }}
                            />
                          )}

                          {hasNorthBorder && (
                            <div style={{ position: 'absolute', top: 0, left: 0, right: 0, height: '3px', backgroundColor: '#00ffcc', boxShadow: '0 0 4px #00ffcc', pointerEvents: 'none' }} />
                          )}
                          {hasSouthBorder && (
                            <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, height: '3px', backgroundColor: '#00ffcc', boxShadow: '0 0 4px #00ffcc', pointerEvents: 'none' }} />
                          )}
                          {hasEastBorder && (
                            <div style={{ position: 'absolute', top: 0, bottom: 0, right: 0, width: '3px', backgroundColor: '#00ffcc', boxShadow: '0 0 4px #00ffcc', pointerEvents: 'none' }} />
                          )}
                          {hasWestBorder && (
                            <div style={{ position: 'absolute', top: 0, bottom: 0, left: 0, width: '3px', backgroundColor: '#00ffcc', boxShadow: '0 0 4px #00ffcc', pointerEvents: 'none' }} />
                          )}

                          {objTile && objTile.dir && (
                            <span
                              style={{
                                position: 'absolute',
                                top: '1px',
                                right: '2px',
                                fontSize: '11px',
                                color: '#00ffcc',
                                filter: 'drop-shadow(0 0 2px black)',
                                pointerEvents: 'none',
                              }}
                            >
                              <Icon name={DIR_ICONS[objTile.dir] || 'arrow-down'} />
                            </span>
                          )}

                          {isCenter && !floorInfo && !wallInfo && !objInfo && borderTiles.length === 0 && !lowerInfo && !scannedCell && (
                            <span style={{ color: '#e74c3c', fontSize: '11px', fontWeight: 'bold' }}>X</span>
                          )}

                          {ghostInfo?.image && (
                            <img
                              src={`data:image/png;base64,${ghostInfo.image}`}
                              style={{
                                width: ghostInfo.layer_type === 'border' ? '28px' : '32px',
                                height: ghostInfo.layer_type === 'border' ? '28px' : '32px',
                                position: 'absolute',
                                pointerEvents: 'none',
                                imageRendering: 'pixelated',
                                opacity: 0.5,
                                zIndex: 10,
                                filter: 'brightness(1.5) drop-shadow(0 0 2px #50320c)',
                              }}
                            />
                          )}
                        </div>
                      );
                    })}
                  </Box>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
