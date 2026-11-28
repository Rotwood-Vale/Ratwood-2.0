import {
  type Dispatch,
  type ReactNode,
  type RefObject,
  type SetStateAction,
  useLayoutEffect,
  useRef,
} from 'react';
import { Stack } from 'tgui-core/components';

import { PageButton } from '../components/PageButton';
import { Window } from '../layouts/Window';
import type { Area } from './common/cardLayout';
import { SealNumbers } from './ExamineGallery/Thumbs/SealNumbers';

export const EXAMINE_WIDTH = 1000;
export const EXAMINE_HEIGHT = 700;

export enum ExaminePage {
  FlavorText,
  ImageGallery,
}

export const ExamineContent = (props: {
  children: ReactNode;
  tabs?: {
    page: ExaminePage;
    setPage: Dispatch<SetStateAction<ExaminePage>>;
    galleryTabRef?: RefObject<HTMLDivElement | null>;
  };
}) => {
  const { children, tabs } = props;
  return (
    <Stack vertical fill>
      {tabs && (
        <>
          <Stack>
            <Stack.Item grow>
              <PageButton
                currentPage={tabs.page}
                page={ExaminePage.FlavorText}
                setPage={tabs.setPage}
              >
                Flavor Text
              </PageButton>
            </Stack.Item>
            <Stack.Item grow>
              <div ref={tabs.galleryTabRef}>
                <PageButton
                  currentPage={tabs.page}
                  page={ExaminePage.ImageGallery}
                  setPage={tabs.setPage}
                >
                  Image Gallery
                </PageButton>
              </div>
            </Stack.Item>
          </Stack>
          <Stack.Divider />
        </>
      )}
      <Stack.Item
        key="examine-content"
        grow
        position="relative"
        overflowX="hidden"
        overflowY="auto"
      >
        {children}
      </Stack.Item>
    </Stack>
  );
};

export type ExamineArtworkArea = {
  /** The whole viewer, picture and thumbnail strip */
  gallery: Area;
  reader: Area;
};

/** Invisible layout boxes measure the default Examine window without instantiating its native window or gallery. */
export const ExamineArtworkMeasure = (props: {
  hasThumbnails: boolean;
  plain: boolean;
  onMeasure: (area: ExamineArtworkArea) => void;
}) => {
  const { hasThumbnails, plain, onMeasure } = props;
  const galleryRef = useRef<HTMLDivElement>(null);
  const readerRef = useRef<HTMLDivElement>(null);
  useLayoutEffect(() => {
    const gallery = galleryRef.current;
    const reader = readerRef.current;
    if (!gallery || !reader) return;

    const measure = (width: number, height: number) => {
      if (!width || !height || !reader.clientWidth || !reader.clientHeight) {
        return;
      }
      onMeasure({
        gallery: { width, height },
        reader: { width: reader.clientWidth, height: reader.clientHeight },
      });
    };
    measure(gallery.clientWidth, gallery.clientHeight);
    const observer = new ResizeObserver(([entry]) => {
      measure(entry.contentRect.width, entry.contentRect.height);
    });
    observer.observe(gallery);
    return () => observer.disconnect();
  }, [onMeasure, hasThumbnails, plain]);

  return (
    <div inert className="CharacterGallery__artworkMeasure" aria-hidden="true">
      <div
        style={{
          width: EXAMINE_WIDTH,
          height: EXAMINE_HEIGHT,
          position: 'relative',
        }}
      >
        <div className="Window__rest" style={{ position: 'absolute' }}>
          <Window.Content>
            <ExamineContent
              tabs={{ page: ExaminePage.ImageGallery, setPage: () => {} }}
            >
              <div ref={galleryRef} className="ExamineGallery">
                <div className="ExamineGallery__main">
                  <div ref={readerRef} className="ExamineGallery__reader" />
                </div>
                <div className="ExamineGallery__lower">
                  {hasThumbnails && <div className="ExamineGallery__strip" />}
                  <div className="ExamineGallery__footer">
                    {hasThumbnails && (
                      <div className="ExamineGallery__footerStart">
                        <SealNumbers
                          images={['', '']}
                          selected={0}
                          plain={plain}
                          onPick={() => {}}
                        />
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </ExamineContent>
          </Window.Content>
        </div>
      </div>
    </div>
  );
};
