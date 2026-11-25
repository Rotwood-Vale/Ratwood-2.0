import type { ArtViewSettings } from '../../common/artViewSettings';

export type ReaderState = {
  view: ArtViewSettings['opening_view'];
  zoom: number;
  left: number;
  top: number;
  anchor?: {
    x: number;
    y: number;
    viewportWidth: number;
    viewportHeight: number;
  };
  /** Still on the view's opening framing, the opening crop of the view, which a resize keeps and a pan or zoom ends */
  framed?: boolean;
};

export const resetReader = (owner: ArtViewSettings): ReaderState => ({
  view: owner.opening_view,
  zoom: 1,
  left: 0,
  top: 0,
  framed: true,
});

export const isReading = (state: ReaderState) =>
  state.view !== 'whole' || state.zoom > 1;
