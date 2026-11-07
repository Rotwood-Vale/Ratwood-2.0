import { Tooltip } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { resolveAsset } from '../../assets';
import { type Backdrop, type BackdropFigure, faceFrames } from './backdrops';

/** How much bigger than its own pixels a table's tile is drawn, a whole number so its pixels stay square before the perspective. */
const TILE_SCALE = 2;

export const SceneBackdrop = (props: {
  scene: Extract<Backdrop, { kind: 'scene' }>;
  figures: BackdropFigure[];
  area: { width: number; height: number };
  faceRef: (element: HTMLDivElement | null) => void;
}) => {
  const { scene, figures, area, faceRef } = props;
  const { id, room, table } = scene;
  const faceFigure = figures.find((figure) => figure.blink);
  // Each frame is in a data attribute to be loaded ahead, and in a custom property for the styles to draw
  const frames = faceFigure
    ? faceFrames(faceFigure).map(([name, asset]) => [name, resolveAsset(asset)])
    : [];
  const roomShare = table?.farEdge ?? 1;
  const farEdge = `${roomShare * 100}%`;
  const roomHeight = area.height * roomShare;
  const scale = Math.max(
    area.width / scene.roomWidth,
    roomHeight / scene.roomHeight,
  );

  return (
    <div
      className={classes([
        'ExamineGallery__scene',
        `ExamineGallery__scene--${id}`,
      ])}
      style={
        {
          '--far-edge': farEdge,
          perspective: table ? `${table.perspective}px` : undefined,
          perspectiveOrigin: table
            ? `50% calc(${farEdge} + ${table.eyeBelowEdge}px)`
            : undefined,
        } as React.CSSProperties
      }
    >
      <div
        className="ExamineGallery__sceneRoom"
        style={{ backgroundImage: `url("${resolveAsset(room)}")` }}
      />
      {figures.map((figure) => (
        <div
          key={figure.id}
          className="ExamineGallery__sceneFigure"
          style={{ backgroundImage: `url("${resolveAsset(figure.layer)}")` }}
        />
      ))}
      {faceFigure && (
        <div
          key={faceFigure.id}
          ref={faceRef}
          className="ExamineGallery__sceneFace"
          {...Object.fromEntries(
            frames.map(([name, url]) => [`data-${name}`, url]),
          )}
          style={Object.fromEntries(
            frames.map(([name, url]) => [`--${name}`, `url("${url}")`]),
          )}
        />
      )}
      {figures.map((figure) => {
        const { label } = figure;
        if (!label || !area.width || !area.height) {
          return null;
        }
        // The key includes area.width and area.height so a resize remounts the Tooltip and closes it. A resize moves the
        // figure out from under a still pointer, which fires no mouseleave, so the tooltip would stay open where the figure was
        return (
          <Tooltip
            key={`${figure.id}:${area.width}:${area.height}`}
            position="top"
            content={
              <>
                <strong>{label.title}</strong>
                <br />
                <em>{label.description}</em>
              </>
            }
          >
            <div
              className="ExamineGallery__figureLabel"
              role="img"
              aria-label={`${label.title}. ${label.description}`}
              style={{
                left:
                  (area.width - scene.roomWidth * scale) / 2 +
                  label.left * scale,
                top: roomHeight - (scene.roomHeight - label.top) * scale,
                width: label.width * scale,
                height: label.height * scale,
                clipPath: label.clipPath,
              }}
            />
          </Tooltip>
        );
      })}
      {table && (
        <>
          <div
            className="ExamineGallery__sceneTable"
            style={{
              backgroundImage: `url("${resolveAsset(table.tile)}")`,
              backgroundSize: `${table.tileWidth * TILE_SCALE}px ${table.tileHeight * TILE_SCALE}px`,
              transform: `rotateX(${table.angle}deg)`,
            }}
          />
          <div className="ExamineGallery__sceneRim" />
        </>
      )}
    </div>
  );
};
