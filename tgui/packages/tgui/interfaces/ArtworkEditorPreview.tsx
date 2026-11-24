import { useState } from 'react';
import { Box, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import type { ArtViewSettings } from './common/artViewSettings';
import { artIndex } from './common/gallerySlots';
import { ArtworkPreview } from './ExamineGallery';
import type { ExaminePanelData } from './ExaminePanelData';
import {
  type ExamineArtworkArea,
  ExamineArtworkMeasure,
} from './ExaminePanelLayout';

type Data = {
  url: string | null;
  view: ArtViewSettings;
  background: string;
  alternate: BooleanLike;
  nsfw: BooleanLike;
  backdrop?: string;
  has_thumbnails: BooleanLike;
  /** The edited picture's slot name, such as art_2 */
  image: string;
  /** The gallery's saved links, view settings and card backgrounds */
  images: string[] | null;
  art_view_settings: Record<string, ArtViewSettings>;
  card_backgrounds: Record<string, string>;
  gallery: ExaminePanelData['gallery'];
  /** The Character Gallery's window, which the Preview opens beside */
  gallery_window?: string;
};

export const ArtworkEditorPreview = () => {
  const { data, windowSession } = useBackend<Data>();
  return <PreviewWindow key={windowSession} data={data} />;
};

const PreviewWindow = ({ data }: { data: Data }) => {
  const [area, setArea] = useState<ExamineArtworkArea | null>(null);
  return (
    <Window
      fitWorkArea
      besideWindow={data.gallery_window}
      title="Artwork Preview"
      width={760}
      height={520}
    >
      <Window.Content>
        <Stack fill vertical>
          <div
            className="CharacterGallery__artPreviewViewport"
            style={{
              width: '100%',
              maxWidth: area ? area.gallery.width + 2 : undefined,
              alignSelf: 'center',
            }}
          >
            {data.url ? (
              area && (
                <ArtworkPreview
                  key={`${data.alternate}:${data.url}`}
                  area={area.gallery}
                  images={data.images ?? []}
                  settings={data.art_view_settings}
                  backgrounds={data.card_backgrounds}
                  index={artIndex(!!data.nsfw, data.image)}
                  url={data.url}
                  view={data.view}
                  background={data.background}
                  backdrop={data.backdrop}
                  gallery={data.gallery}
                  nsfw={!!data.nsfw}
                />
              )
            ) : (
              <Box color="label">
                Enter a direct image link to preview this artwork.
              </Box>
            )}
          </div>
          <ExamineArtworkMeasure
            hasThumbnails={!!data.has_thumbnails}
            plain={!!data.gallery?.plain}
            onMeasure={setArea}
          />
        </Stack>
      </Window.Content>
    </Window>
  );
};
