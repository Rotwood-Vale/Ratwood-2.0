import type { ReactNode, RefObject } from 'react';
import { Icon } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { ART_VIEW_HELP, ART_VIEW_LABELS } from '../../common/artViewSettings';
import { zoomPercent } from '../Reader/readingGeometry';
import type { ReaderState } from '../Reader/readingState';
import { GalleryMouseIcon } from './MouseHints';

/** The tray panel that is open, the view menu or the help, or null for neither */
export type ControlsPanel = 'view' | 'help' | null;

export const BUTTON = 'Button Button--color--default';

/** The zoom factor of the Zoom in button, whose reciprocal the Zoom out button takes */
const ZOOM_BUTTON_STEP = 1.25;

const VIEW_HELP = {
  whole: 'Shows the artwork as a framed card.',
  fitted: ART_VIEW_HELP.fitted,
  scroll: `${ART_VIEW_HELP.scroll} Pan or scroll to see beyond the frame.`,
} satisfies Record<ReaderState['view'], string>;

const SCROLLING_ONLY_TEXT = `Tall pictures always open in ${ART_VIEW_LABELS.scroll}`;

/** The tray's view button and the menu it opens */
export const ViewMenu = (props: {
  viewRef: RefObject<HTMLButtonElement | null>;
  viewId: string;
  panel: ControlsPanel;
  onPanel: (panel: ControlsPanel) => void;
  lockedView: boolean;
  /** The picture opens only in Scrolling, so its shape locks the view and not the owner */
  scrollingOnly: boolean;
  viewLabel: string;
  view: ReaderState['view'];
  onView: (view: ReaderState['view']) => void;
  onReset: () => void;
}) => {
  const { viewRef, viewId, panel, onPanel, lockedView, viewLabel } = props;
  const closeView = () => {
    onPanel(null);
    viewRef.current?.focus({ preventScroll: true });
  };
  return (
    <div className="ExamineGallery__viewControl">
      <button
        ref={viewRef}
        type="button"
        className={`ExamineGallery__viewToggle ${BUTTON}`}
        title={
          lockedView
            ? props.scrollingOnly
              ? SCROLLING_ONLY_TEXT
              : 'View locked by owner'
            : undefined
        }
        aria-expanded={panel === 'view'}
        aria-controls={viewId}
        aria-haspopup="dialog"
        onClick={() => onPanel(panel === 'view' ? null : 'view')}
      >
        {viewLabel}
        <Icon name={lockedView ? 'lock' : 'caret-down'} aria-hidden />
      </button>
      {panel === 'view' && (
        <div
          id={viewId}
          className="ExamineGallery__viewMenu"
          role="dialog"
          aria-label="Image view"
        >
          {lockedView ? (
            <span className="ExamineGallery__viewHelp">
              {props.scrollingOnly
                ? `${SCROLLING_ONLY_TEXT}.`
                : 'View is locked by the owner.'}
            </span>
          ) : (
            Object.entries(ART_VIEW_LABELS).map(([view, label]) => (
              <button
                key={view}
                type="button"
                className={classes([
                  BUTTON,
                  props.view === view && 'Button--selected',
                ])}
                aria-pressed={props.view === view}
                onClick={() => {
                  props.onView(view as ReaderState['view']);
                  closeView();
                }}
              >
                {label}
              </button>
            ))
          )}
          <button
            type="button"
            className={BUTTON}
            onClick={() => {
              props.onReset();
              closeView();
            }}
          >
            Reset view
          </button>
        </div>
      )}
    </div>
  );
};

export const ZoomButtons = (props: {
  lockedZoom: boolean;
  zoom: number;
  zoomMin: number;
  zoomMax: number;
  onZoom: (factor: number) => void;
}) => (
  <div
    className="ExamineGallery__zoomControls"
    role="group"
    aria-label="Image zoom"
    title={props.lockedZoom ? 'Zoom locked by owner' : undefined}
  >
    <button
      type="button"
      className={BUTTON}
      aria-label="Zoom out"
      disabled={props.lockedZoom || props.zoom <= props.zoomMin}
      onClick={() => props.onZoom(1 / ZOOM_BUTTON_STEP)}
    >
      −
    </button>
    <output aria-live="polite">{zoomPercent(props.zoom)}</output>
    <button
      type="button"
      className={BUTTON}
      aria-label="Zoom in"
      disabled={props.lockedZoom || props.zoom >= props.zoomMax}
      onClick={() => props.onZoom(ZOOM_BUTTON_STEP)}
    >
      +
    </button>
  </div>
);

/** The contextual help panel, which lists the controls the current view allows */
export const HelpPanel = (props: {
  helpId: string;
  helpTitleId: string;
  viewLabel: string;
  view: ReaderState['view'];
  reading: boolean;
  canAdvance: boolean;
  canPan: boolean;
  canZoom: boolean;
  lockedZoom: boolean;
  zoomShortcut: ReactNode;
  showMouseControls: boolean;
  onShowMouseControls: (show: boolean) => void;
}) => {
  const {
    helpId,
    helpTitleId,
    viewLabel,
    reading,
    canAdvance,
    canPan,
    canZoom,
    lockedZoom,
    zoomShortcut,
  } = props;
  return (
    <div
      id={helpId}
      className="ExamineGallery__helpPanel"
      role="dialog"
      aria-labelledby={helpTitleId}
    >
      <strong id={helpTitleId}>Contextual help</strong>
      <div>Updates with your view and available controls.</div>
      <div className="ExamineGallery__helpContext">
        {viewLabel}
        {props.view === 'whole' && reading && ' (zoomed)'}
      </div>
      <div>{VIEW_HELP[props.view]}</div>
      <dl className="ExamineGallery__helpActions">
        {canAdvance && (
          <>
            <dt>Next image</dt>
            <dd>
              <GalleryMouseIcon action="next" />
            </dd>
          </>
        )}
        {canPan && (
          <>
            <dt>Pan</dt>
            <dd>
              <GalleryMouseIcon action="pan" /> Hold and drag
            </dd>
            <dt>Scroll</dt>
            <dd>
              <GalleryMouseIcon action="scroll" />
            </dd>
          </>
        )}
        {(canZoom || lockedZoom) && (
          <>
            <dt>Zoom</dt>
            <dd>
              {canZoom ? (
                <>
                  {zoomShortcut} or <kbd>−</kbd> <kbd>+</kbd>
                </>
              ) : (
                'Locked by owner'
              )}
            </dd>
          </>
        )}
        {canAdvance && (
          <>
            <dt>Change image</dt>
            <dd>
              <GalleryMouseIcon action="thumbnails" /> Over thumbnails
              {!reading && (
                <>
                  {' '}
                  or <kbd>←</kbd> <kbd>→</kbd>
                </>
              )}
            </dd>
          </>
        )}
      </dl>
      <label className="ExamineGallery__mousePreference">
        <input
          type="checkbox"
          checked={props.showMouseControls}
          onChange={(event) =>
            props.onShowMouseControls(event.currentTarget.checked)
          }
        />
        Show mouse controls
      </label>
    </div>
  );
};
