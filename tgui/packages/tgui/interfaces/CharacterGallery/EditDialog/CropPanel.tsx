import type { ReactNode } from 'react';
import { Box, Button } from 'tgui-core/components';

import type { Area } from '../../common/cardLayout';
import { CropEditor } from '../ArtCrop/CropEditor';
import { ROW_NAMES, type SourceDraft } from './useSourceDrafts';

/** The Edit dialog's framing column, for the source row picked in it or last touched */
export const CropPanel = (props: {
  source: SourceDraft;
  isAlternate: boolean;
  showAlternate: boolean;
  panelRow: number;
  setPanelRow: (row: number) => void;
  busy: boolean;
  openingArea?: Area;
  /** The dialog's actions, under the Magnify Editor row or under the placeholder */
  children?: ReactNode;
}) => {
  const {
    source: panel,
    isAlternate,
    showAlternate,
    panelRow,
    setPanelRow,
    busy,
    openingArea,
  } = props;
  const shownRow = showAlternate ? panelRow : 0;
  const panelUrl = panel.previewUrl;
  const panelView = panel.shown;
  const panelName = ROW_NAMES[shownRow];
  return (
    <div className="CharacterGallery__cropPanel">
      {showAlternate && (
        <div className="CharacterGallery__cropSources">
          {ROW_NAMES.map((name, index) => (
            <Button
              key={name}
              compact
              selected={shownRow === index}
              color={shownRow === index ? undefined : 'transparent'}
              onClick={() => setPanelRow(index)}
            >
              {name}
            </Button>
          ))}
        </div>
      )}
      {!!panelUrl && (
        <CropEditor
          key={`${isAlternate}:${panelView.opening_view === 'whole'}:${panelUrl}`}
          url={panelUrl}
          view={panelView.opening_view}
          crop={panelView.crop}
          openingArea={openingArea}
          lock={panelView.lock}
          scrollingOnly={panel.scrollingOnly}
          label={panelName}
          disabled={busy}
          onChange={(crop) => panel.setCrop(crop)}
          actions={props.children}
        />
      )}
      {!panelUrl && (
        <>
          <div className="CharacterGallery__framingPlaceholder">
            <strong>Framing</strong>
            <Box color="label">
              Enter a direct image link to preview and frame your artwork.
            </Box>
          </div>
          {props.children}
        </>
      )}
    </div>
  );
};
