/** A measured width and height in layout pixels, such as the gallery's art area or the framing stage */
export type Area = { width: number; height: number };

export type PictureBox = {
  left: number;
  top: number;
  width: number;
  height: number;
};

export const NO_BOX: PictureBox = { left: 0, top: 0, width: 0, height: 0 };

export const PICTURE_SIDE_MIN = 48;

/** Room left around the picture for its frame, in pixels. Holds $rail-thickness of ExamineGallery.scss, and the deal keyframes there land in the 4 px left over. */
export const FRAME_MARGIN = 18;

/** Extra room around the picture while the tilt is on, so a wide picture's near edge and rail stay inside the panel at the full lean, as a 936 px wide picture leaning 7 degrees grows about 4.2% at its near edge. Sized with $rail-thickness in ExamineGallery.scss */
export const TILT_MARGIN = 14;

export const TILTED_CARD_MARGIN = FRAME_MARGIN + TILT_MARGIN;

export const PICTURE_TOO_NARROW_TEXT = 'This picture is too narrow to show.';

/** An area with no room for PICTURE_SIDE_MIN at all, as before it is measured, never makes a picture too thin. */
export const pictureTooThin = (aspect: number, area: Area, margin: number) => {
  const room = Math.min(area.width, area.height) - margin * 2;
  if (room < PICTURE_SIDE_MIN) {
    return false;
  }
  const box = pictureBox(aspect, area, margin);
  return Math.min(box.width, box.height) < PICTURE_SIDE_MIN;
};

/** Centred on whole pixels, so the frame's art stays crisp. */
export const pictureBox = (
  aspect: number,
  area: Area,
  margin: number,
): PictureBox => {
  const height = Math.max(
    Math.min(area.height - margin * 2, (area.width - margin * 2) / aspect),
    0,
  );
  const fitHeight = Math.round(height);
  const fitWidth = Math.round(height * aspect);
  return {
    width: fitWidth,
    height: fitHeight,
    left: Math.round((area.width - fitWidth) / 2),
    top: Math.round((area.height - fitHeight) / 2),
  };
};
