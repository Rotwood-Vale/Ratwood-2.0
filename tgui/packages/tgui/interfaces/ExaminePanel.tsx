import { type SyntheticEvent, useEffect, useRef, useState } from 'react';
import { Button } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { ImageGalleryPage } from './ExamineGallery';
import { createGallerySession } from './ExamineGallery/gallerySession';
import type { ExaminePanelData } from './ExaminePanelData';
import {
  EXAMINE_HEIGHT,
  EXAMINE_WIDTH,
  ExamineContent,
  ExaminePage as Page,
} from './ExaminePanelLayout';
import { FlavorTextPage } from './ExaminePanelPages';

const COLLAPSED_WIDTH = 450;

const guardMedia = (event: SyntheticEvent) => {
  const target = event.target as HTMLElement;
  if (target.tagName === 'IMG' || target.tagName === 'VIDEO') {
    event.preventDefault();
  }
};

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
    song_title,
    song_artist,
    has_song,
    img_gallery,
    nsfw_img_gallery,
  } = data;
  const [currentPage, setCurrentPage] = useState(Page.FlavorText);
  const [gallerySession] = useState(createGallerySession);
  const galleryTabRef = useRef<HTMLDivElement>(null);
  const [collapsed, setCollapsed] = useState(false);
  const [expandedWidth, setExpandedWidth] = useState(EXAMINE_WIDTH);

  const hasGallery =
    (img_gallery?.length ?? 0) > 0 || (nsfw_img_gallery?.length ?? 0) > 0;
  const showTabs = hasGallery && !collapsed;
  const showGallery =
    hasGallery && !collapsed && currentPage === Page.ImageGallery;
  useEffect(() => {
    if (!hasGallery) {
      setCurrentPage(Page.FlavorText);
    }
  }, [hasGallery]);

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
      width={EXAMINE_WIDTH}
      height={EXAMINE_HEIGHT}
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
          >
            {song_title && song_artist
              ? `${song_title} — ${song_artist}`
              : (song_title ?? song_artist ?? null)}
          </Button>
        </>
      }
    >
      <Window.Content>
        <div
          style={{ display: 'contents' }}
          onContextMenu={guardMedia}
          onDragStart={guardMedia}
        >
          <ExamineContent
            tabs={
              showTabs
                ? { page: currentPage, setPage: setCurrentPage, galleryTabRef }
                : undefined
            }
          >
            <div style={{ display: showGallery ? 'none' : 'contents' }}>
              <FlavorTextPage collapsed={collapsed} />
            </div>
            {showGallery && (
              <ImageGalleryPage
                data={data}
                session={gallerySession}
                galleryTabRef={galleryTabRef}
              />
            )}
          </ExamineContent>
        </div>
      </Window.Content>
    </Window>
  );
};
