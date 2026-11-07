export type PictureBox = {
  left: number;
  top: number;
  width: number;
  height: number;
};

export const NO_BOX: PictureBox = { left: 0, top: 0, width: 0, height: 0 };

export const PICTURE_SIDE_MIN = 48;

export const PICTURE_TOO_NARROW_TEXT = 'This picture is too narrow to show.';

/** An area with no room for PICTURE_SIDE_MIN at all, as before it is measured, never makes a picture too thin. */
export const pictureTooThin = (
  aspect: number,
  area: { width: number; height: number },
  margin: number,
) => {
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
  area: { width: number; height: number },
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
