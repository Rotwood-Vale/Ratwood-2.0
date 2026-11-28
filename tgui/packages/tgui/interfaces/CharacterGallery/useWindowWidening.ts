import { useLayoutEffect, useRef } from 'react';

import { GalleryEditorGeometry } from './GalleryEditorGeometry';

/**
 * Resizes the Gallery for its editors and the Side Preview, then folds it back as they close.
 * previewGrowth is the Side Preview's width in CSS pixels while it is open.
 * Returns the release the window calls as it closes
 */
export const useWindowWidening = (
  expanded: boolean,
  artDialogKey: string | null,
  previewGrowth: number | undefined,
  scale: boolean,
  getContent: () => HTMLElement | null,
  onLayoutSettled: () => void,
) => {
  const geometry = useRef<GalleryEditorGeometry | null>(null);
  useLayoutEffect(() => {
    geometry.current = new GalleryEditorGeometry(scale, getContent);
    return () => geometry.current?.dispose();
  }, []);
  // A headshot editor already open keeps its wider window while the dialog sits over it
  useLayoutEffect(() => {
    geometry.current?.setExpanded(
      expanded || !!artDialogKey,
      expanded ? 'editor' : 'dialog',
      previewGrowth,
      onLayoutSettled,
    );
  }, [expanded, artDialogKey, previewGrowth]);
  return () => geometry.current?.dispose();
};
