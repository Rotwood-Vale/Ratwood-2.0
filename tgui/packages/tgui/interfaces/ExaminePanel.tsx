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
const COLLAPSED_WIDTH = 450;

const setWindowSize = (width: number, height: number) => {
  const ratio = window.devicePixelRatio || 1;
  Byond.winset(Byond.windowId, {
    size: `${width * ratio}x${height * ratio}`,
  });
};

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
  const [expandedWidth, setExpandedWidth] = useState(DEFAULT_WIDTH);

  const hasGallery = img_gallery.length > 0 || nsfw_img_gallery.length > 0;
  const showTabs = hasGallery && !collapsed;
  const showGallery = !collapsed && currentPage === Page.ImageGallery;

  const toggleCollapse = () => {
    if (!collapsed) {
      setExpandedWidth(window.innerWidth);
      setCurrentPage(Page.FlavorText);
      setWindowSize(COLLAPSED_WIDTH, window.innerHeight);
    } else {
      setWindowSize(expandedWidth, window.innerHeight);
    }
    setCollapsed(!collapsed);
  };

  return (
    <Window
      title={character_name}
      width={DEFAULT_WIDTH}
      height={DEFAULT_HEIGHT}
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
            <div style={{ display: showGallery ? 'none' : 'contents' }}>
              <FlavorTextPage collapsed={collapsed} />
            </div>
            {showGallery && <ImageGalleryPage />}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
