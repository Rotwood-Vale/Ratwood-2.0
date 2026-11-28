import { type ReactNode, useRef } from 'react';

import type { Area } from '../common/cardLayout';
import { useElementSize } from './Reader/useElementSize';

/** Draws the whole viewer scaled to fit its slot and centred in it, never larger than viewers get it */
export const ArtworkViewport = (props: { area: Area; children: ReactNode }) => {
  const { area, children } = props;
  const slotRef = useRef<HTMLDivElement>(null);
  const slot = useElementSize(slotRef);
  const scale = Math.max(
    0,
    Math.min(1, (slot.width - 2) / area.width, (slot.height - 2) / area.height),
  );

  return (
    <div className="ExamineGallery__previewSlot" ref={slotRef}>
      <div
        className="ExamineGallery__previewFrame"
        style={{ width: area.width * scale + 2 }}
      >
        <div
          className="ExamineGallery__previewPicture"
          style={{ width: area.width * scale, height: area.height * scale }}
        >
          <div
            className="ExamineGallery__previewCanvas"
            style={{
              width: area.width,
              height: area.height,
              transform: `scale(${scale})`,
            }}
          >
            {children}
          </div>
        </div>
      </div>
    </div>
  );
};
