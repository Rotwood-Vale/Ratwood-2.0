import { Box, Button } from 'tgui-core/components';

import type { ArtCrop, ArtViewSettings } from '../../common/artViewSettings';

/** The magnifier for the framing editor's view, with the box's size in pixels and Reset */
export const EditorMagnifier = (props: {
  ready: boolean;
  zoom: number;
  zoomMax: number;
  onZoom: (direction: 1 | -1) => void;
  size: [number, number] | null;
  box: ArtCrop;
  crop: ArtCrop | undefined;
  view: ArtViewSettings['opening_view'];
  onReset: () => void;
}) => {
  const { ready, zoom, zoomMax, onZoom, size, box, crop, view, onReset } =
    props;
  return (
    <div className="CharacterGallery__cropControls">
      <div className="CharacterGallery__cropControlGroup">
        <Box color="label">Magnify Editor</Box>
        <Button
          compact
          aria-label="Magnify Editor Less"
          tooltip="Magnify the editing picture less to see more of it. Viewers never see this."
          disabled={!ready || zoom <= 1}
          onClick={() => onZoom(-1)}
        >
          −
        </Button>
        <span className="CharacterGallery__cropZoom">{zoom.toFixed(1)}×</span>
        <Button
          compact
          aria-label="Magnify Editor More"
          tooltip="Magnify the editing picture to place the framing box more precisely. Viewers never see this."
          disabled={!ready || zoom >= zoomMax}
          onClick={() => onZoom(1)}
        >
          +
        </Button>
      </div>
      <div className="CharacterGallery__cropControlGroup">
        <Box color="label" className="CharacterGallery__cropSize">
          {!!size &&
            `${Math.round(box.w * size[0])} × ${Math.round(box.h * size[1])} px`}
        </Box>
        <Button
          compact
          icon="undo"
          disabled={!crop}
          tooltip={
            view === 'scroll'
              ? 'Back to the full width at the top of the picture.'
              : 'Back to the whole picture.'
          }
          onClick={() => onReset()}
        >
          Reset
        </Button>
      </div>
    </div>
  );
};
