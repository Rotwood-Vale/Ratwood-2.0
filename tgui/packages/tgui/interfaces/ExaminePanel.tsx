import { useState } from 'react';
import { Button, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { PageButton } from '../components/PageButton';
import { Window } from '../layouts';
import { ExaminePanelData } from './ExaminePanelData';
import { FlavorTextPage } from './ExaminePanelPages';
import { ImageGalleryPage } from './ExaminePanelPages';

enum Page {
  FlavorText,
  ImageGallery,
}

const DEFAULT_WIDTH = 1000;
const DEFAULT_HEIGHT = 700;
// Headshot is 350px; leftover covers Window content padding.
const COLLAPSED_WIDTH = 450;

export const ExaminePanel = (props) => {
  const { act, data } = useBackend<ExaminePanelData>();
  const {
    is_vet,
    character_name,
    is_playing,
    has_song,
    img_gallery,
    nsfw_img_gallery,
  } = data;
  const [currentPage, setCurrentPage] = useState(Page.FlavorText);
  const [collapsed, setCollapsed] = useState(false);
  const [expandedSize, setExpandedSize] = useState({
    width: DEFAULT_WIDTH,
    height: DEFAULT_HEIGHT,
  });

  const hasGallery = img_gallery.length > 0 || nsfw_img_gallery.length > 0;
  const showTabs = hasGallery && !collapsed;

  const toggleCollapse = () => {
    if (!collapsed) {
      setExpandedSize({
        width: window.innerWidth,
        height: window.innerHeight,
      });
      setCurrentPage(Page.FlavorText);
    }
    setCollapsed(!collapsed);
  };

  const pageContents =
    collapsed || currentPage === Page.FlavorText ? (
      <FlavorTextPage collapsed={collapsed} />
    ) : (
      <ImageGalleryPage />
    );

  return (
    <Window
      title={character_name}
      width={collapsed ? COLLAPSED_WIDTH : expandedSize.width}
      height={expandedSize.height}
      buttons={
        <>
          {!!is_vet}
          <Button
            icon={collapsed ? 'chevron-right' : 'chevron-left'}
            tooltip={collapsed ? 'Expand' : 'Collapse'}
            tooltipPosition="bottom-start"
            selected={collapsed}
            onClick={toggleCollapse}
          />
          <Button
            color="green"
            icon="music"
            tooltip="Music player"
            tooltipPosition="bottom-start"
            onClick={() => act('toggle')}
            disabled={!has_song}
            selected={!is_playing}
          />
        </>
      }
    >
      <Window.Content>
        <Stack vertical fill>
          {showTabs && (
            <Stack>
              <Stack.Item grow>
                <PageButton
                  currentPage={currentPage}
                  page={Page.FlavorText}
                  setPage={setCurrentPage}
                >
                  Flavor Text
                </PageButton>
              </Stack.Item>
              <Stack.Item grow>
                <PageButton
                  currentPage={currentPage}
                  page={Page.ImageGallery}
                  setPage={setCurrentPage}
                >
                  Image Gallery
                </PageButton>
              </Stack.Item>
            </Stack>
          )}
          {showTabs && <Stack.Divider />}
          <Stack.Item
            key="examine-content"
            grow
            position="relative"
            overflowX="hidden"
            overflowY="auto"
          >
            {pageContents}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
