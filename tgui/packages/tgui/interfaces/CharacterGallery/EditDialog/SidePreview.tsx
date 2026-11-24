import { useRef } from 'react';
import { Box } from 'tgui-core/components';

import type { Area } from '../../common/cardLayout';
import { useNativeWheel } from '../../common/useNativeWheel';
import { ArtworkPreview } from '../../ExamineGallery';
import type { ExaminePanelData } from '../../ExaminePanelData';
import type { ImageForm } from '../types';
import type { SourceDraft } from './useSourceDrafts';

/** Must match the padding of .CharacterGallery__sidePreview, plus the viewer's 1px frame */
const SIDE_CHROME = 2 * 8 + 2;

/** The Side Preview's request: held is the width the editor keeps in layout pixels, growth what the window grows by in CSS pixels */
export type SidePreviewState = {
  open: boolean;
  /** The window finished the last resize asked for */
  settled: boolean;
  held: number;
  growth: number;
};

/** How much wider the window must grow to show the viewer as large as the room allows, up to the viewers' size */
export const sidePreviewWidth = (
  viewer: Area,
  room: number,
  height: number,
) => {
  const scale = Math.max(
    0,
    Math.min(
      1,
      (room - SIDE_CHROME) / viewer.width,
      (height - SIDE_CHROME) / viewer.height,
    ),
  );
  return Math.min(room, Math.floor(viewer.width * scale) + SIDE_CHROME);
};

/**
 * The viewer as viewers get it, drawn from the draft among the form's saved pictures in whatever room the
 * window has right of the editor. It takes no focus, keys, clicks or wheel
 */
export const SidePreview = (props: {
  left: number;
  area: Area;
  form: ImageForm | undefined;
  /** The edited picture's position counted from 0 */
  index: number;
  source: SourceDraft;
  alternate: boolean;
  gallery: ExaminePanelData['gallery'];
  nsfw: boolean;
}) => {
  const { left, area, form, index, source, alternate, gallery, nsfw } = props;
  const ref = useRef<HTMLElement>(null);
  useNativeWheel(ref, (event) => event.preventDefault());
  return (
    <aside
      ref={ref}
      className="CharacterGallery__sidePreview"
      style={{ left }}
      aria-label="Artwork Preview"
      onMouseDown={(event) => event.preventDefault()}
    >
      <div className="CharacterGallery__artPreviewViewport">
        {source.previewUrl ? (
          <ArtworkPreview
            key={`${alternate}:${source.previewUrl}`}
            area={area}
            images={(nsfw ? form?.nsfw_img_gallery : form?.img_gallery) ?? []}
            settings={form?.art_view_settings}
            backgrounds={form?.card_backgrounds}
            index={index}
            url={source.previewUrl}
            view={source.view}
            background={source.background}
            backdrop={form?.image_backdrop}
            gallery={gallery}
            nsfw={nsfw}
          />
        ) : (
          <Box color="label">
            Enter a direct image link to preview this artwork.
          </Box>
        )}
      </div>
    </aside>
  );
};
