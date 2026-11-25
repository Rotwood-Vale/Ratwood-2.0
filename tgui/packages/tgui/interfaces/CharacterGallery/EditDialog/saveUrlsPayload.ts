import type { SourceDrafts } from './useSourceDrafts';

/** The parameters the Edit dialog's Apply sends with save_urls */
export const saveUrlsPayload = (
  editorId: number,
  drafts: SourceDrafts,
  activeAlternate: boolean,
  isArt: boolean,
) => ({
  editor_id: editorId,
  main: drafts.main.url,
  alternate: drafts.alternate.url,
  active_alternate: activeAlternate,
  ...(isArt && {
    main_background: drafts.main.background,
    alternate_background: drafts.alternate.background,
    main_view_settings: drafts.main.view,
    alternate_view_settings: drafts.alternate.view,
  }),
});
