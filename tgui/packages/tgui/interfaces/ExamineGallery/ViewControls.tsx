import { type ReactNode, useEffect, useId, useRef, useState } from 'react';
import { Icon } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import type { ArtViewSettings } from '../CharacterGallery/shared';
import { ART_VIEW_LABELS } from '../common/artViewSettings';
import { MouseControlIcon } from '../common/MouseControlIcon';
import { zoomPercent } from './readingGeometry';
import {
  isReading,
  type ReaderState,
  viewLocked,
  zoomLocked,
} from './readingState';

const HIDE_DELAY_MS = 180;
const BUTTON = 'Button Button--color--default';

const MOUSE_CONTROLS = {
  next: ['left', 'Left-click the artwork for the next image'],
  pan: ['right', 'Hold the right mouse button and drag to pan oversized art'],
  scroll: ['wheel', 'Scroll the mouse wheel to move up or down'],
  zoom: ['wheel', 'Hold Ctrl and scroll the mouse wheel to zoom'],
  thumbnails: ['wheel', 'Scroll over a thumbnail to change images'],
} as const;

const GalleryMouseIcon = (props: { action: keyof typeof MOUSE_CONTROLS }) => {
  const [control, label] = MOUSE_CONTROLS[props.action];
  return (
    <MouseControlIcon
      className="ExamineGallery__mouseIcon"
      control={control}
      label={label}
    />
  );
};

export type ControlsPanel = 'view' | 'help' | null;

export const ViewControls = (props: {
  owner: ArtViewSettings;
  state: ReaderState;
  panel: ControlsPanel;
  onPanel: (panel: ControlsPanel) => void;
  onView: (view: ReaderState['view']) => void;
  onZoom: (factor: number) => void;
  onReset: () => void;
  zoomMax: number;
  zoomMin: number;
  pinned: boolean;
  onPinned: (pinned: boolean) => void;
  showMouseControls: boolean;
  onShowMouseControls: (show: boolean) => void;
  imageCount: number;
  numbers: ReactNode;
  thumbnails: ReactNode;
  modes: ReactNode;
}) => {
  const { panel, onPanel, pinned, thumbnails } = props;
  const [revealed, setRevealed] = useState(false);
  const triggerRef = useRef<HTMLButtonElement>(null);
  const trayRef = useRef<HTMLDivElement>(null);
  const viewRef = useRef<HTMLButtonElement>(null);
  const helpRef = useRef<HTMLButtonElement>(null);
  const pointerInside = useRef(false);
  const pointerFocused = useRef(false);
  const hideTimer = useRef<ReturnType<typeof setTimeout>>(undefined);
  const id = useId();
  const viewId = `${id}-view`;
  const helpId = `${id}-help`;
  const helpTitleId = `${helpId}-title`;
  const viewLabel = ART_VIEW_LABELS[props.state.view];
  const reading = isReading(props.state);
  const lockedView = viewLocked(props.owner);
  const lockedZoom = zoomLocked(props.owner);
  const canAdvance = props.imageCount > 1;
  const canPan = reading && props.imageCount > 0;
  const canZoom = !lockedZoom && props.imageCount > 0;
  const showHints = props.showMouseControls;
  const zoomShortcut = (
    <span className="ExamineGallery__mouseAction">
      <kbd>Ctrl</kbd>
      <span className="ExamineGallery__keyJoin" aria-hidden="true">
        +
      </span>
      <GalleryMouseIcon action="zoom" />
    </span>
  );
  const visible = pinned || revealed || panel !== null;
  const focusInControls = (target: EventTarget | null) =>
    target === triggerRef.current ||
    (target instanceof Node && trayRef.current?.contains(target));
  const keyboardFocusInControls = (target: EventTarget | null) =>
    !pointerFocused.current &&
    target instanceof HTMLElement &&
    target.matches(':focus-visible') &&
    focusInControls(target);
  const show = () => {
    clearTimeout(hideTimer.current);
    setRevealed(true);
  };
  const hideSoon = () => {
    clearTimeout(hideTimer.current);
    hideTimer.current = setTimeout(() => {
      if (
        !pointerInside.current &&
        !keyboardFocusInControls(document.activeElement)
      ) {
        setRevealed(false);
      }
    }, HIDE_DELAY_MS);
  };
  const hoverControls = {
    onPointerEnter: (event: React.PointerEvent) => {
      if (event.pointerType === 'touch') return;
      pointerInside.current = true;
      show();
    },
    onPointerLeave: (event: React.PointerEvent) => {
      if (event.pointerType === 'touch') return;
      pointerInside.current = false;
      hideSoon();
    },
  };

  useEffect(() => () => clearTimeout(hideTimer.current), []);
  useEffect(() => {
    if (!panel) return;
    const dismissOutside = (event: PointerEvent) => {
      if (!focusInControls(event.target)) onPanel(null);
    };
    const dismissOnEscape = (event: KeyboardEvent) => {
      if (event.key !== 'Escape') return;
      event.preventDefault();
      event.stopPropagation();
      onPanel(null);
      (panel === 'view' ? viewRef : helpRef).current?.focus({
        preventScroll: true,
      });
    };
    document.addEventListener('pointerdown', dismissOutside);
    document.addEventListener('keydown', dismissOnEscape, true);
    return () => {
      document.removeEventListener('pointerdown', dismissOutside);
      document.removeEventListener('keydown', dismissOnEscape, true);
    };
  }, [panel, onPanel]);

  const closeView = () => {
    onPanel(null);
    viewRef.current?.focus({ preventScroll: true });
  };

  return (
    <div
      className="ExamineGallery__lower"
      onPointerDownCapture={(event) => {
        if (focusInControls(event.target)) pointerFocused.current = true;
      }}
      onKeyDownCapture={(event) => {
        if (!focusInControls(event.target)) return;
        pointerFocused.current = false;
        show();
      }}
      onFocus={(event) => {
        if (keyboardFocusInControls(event.target)) show();
      }}
      onBlur={(event) => {
        if (
          !focusInControls(event.target) ||
          focusInControls(event.relatedTarget)
        ) {
          return;
        }
        pointerFocused.current = false;
        if (event.relatedTarget) onPanel(null);
        hideSoon();
      }}
    >
      {thumbnails}
      <div className="ExamineGallery__footer">
        <div className="ExamineGallery__footerStart">
          {props.numbers}
          {showHints && (canAdvance || canPan) && (
            <div className="ExamineGallery__mouseHints ExamineGallery__mouseNavigation">
              {canAdvance && (
                <span className="ExamineGallery__mouseAction">
                  <GalleryMouseIcon action="next" />
                  <span className="ExamineGallery__hintLabel">Next image</span>
                </span>
              )}
              {canAdvance && canPan && (
                <span className="ExamineGallery__hintSeparator" aria-hidden>
                  |
                </span>
              )}
              {canPan && (
                <span className="ExamineGallery__mouseAction">
                  <GalleryMouseIcon action="pan" />
                  <span className="ExamineGallery__hintLabel">Drag to pan</span>
                </span>
              )}
            </div>
          )}
        </div>
        <button
          ref={triggerRef}
          type="button"
          className={`ExamineGallery__trayToggle ${BUTTON}`}
          aria-label="Gallery controls"
          aria-controls={id}
          aria-expanded={visible}
          {...hoverControls}
          onClick={show}
        >
          <Icon name="chevron-up" aria-hidden />
        </button>
        {showHints && (canPan || canZoom) && (
          <div className="ExamineGallery__mouseHints ExamineGallery__mouseZoom">
            {canPan && (
              <span className="ExamineGallery__mouseAction">
                <GalleryMouseIcon action="scroll" />
                <span className="ExamineGallery__hintLabel">Scroll</span>
              </span>
            )}
            {canPan && canZoom && (
              <span className="ExamineGallery__hintSeparator" aria-hidden>
                |
              </span>
            )}
            {canZoom && (
              <span className="ExamineGallery__mouseAction">
                {zoomShortcut}
                <span className="ExamineGallery__hintLabel">Zoom</span>
              </span>
            )}
          </div>
        )}
      </div>
      <div
        ref={trayRef}
        id={id}
        className={classes([
          'ExamineGallery__tray',
          visible && 'ExamineGallery__tray--visible',
          panel && 'ExamineGallery__tray--panelOpen',
        ])}
        inert={!visible}
        {...hoverControls}
      >
        <div className="ExamineGallery__trayClip">
          <div className="ExamineGallery__trayContent">
            <div className="ExamineGallery__trayActions">
              <div className="ExamineGallery__viewControl">
                <button
                  ref={viewRef}
                  type="button"
                  className={`ExamineGallery__viewToggle ${BUTTON}`}
                  title={lockedView ? 'View set by owner' : undefined}
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
                        View is locked by the owner.
                      </span>
                    ) : (
                      Object.entries(ART_VIEW_LABELS).map(([view, label]) => (
                        <button
                          key={view}
                          type="button"
                          className={classes([
                            BUTTON,
                            props.state.view === view && 'Button--selected',
                          ])}
                          aria-pressed={props.state.view === view}
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
              <div
                className="ExamineGallery__zoomControls"
                role="group"
                aria-label="Image zoom"
                title={lockedZoom ? 'Zoom locked by owner' : undefined}
              >
                <button
                  type="button"
                  className={BUTTON}
                  aria-label="Zoom out"
                  disabled={lockedZoom || props.state.zoom <= props.zoomMin}
                  onClick={() => props.onZoom(0.8)}
                >
                  −
                </button>
                <output aria-live="polite">
                  {zoomPercent(props.state.zoom)}
                </output>
                <button
                  type="button"
                  className={BUTTON}
                  aria-label="Zoom in"
                  disabled={lockedZoom || props.state.zoom >= props.zoomMax}
                  onClick={() => props.onZoom(1.25)}
                >
                  +
                </button>
              </div>
              <button
                ref={helpRef}
                type="button"
                className={`ExamineGallery__helpToggle ${BUTTON}`}
                title="Contextual help"
                aria-label="Contextual help"
                aria-expanded={panel === 'help'}
                aria-controls={helpId}
                aria-haspopup="dialog"
                onClick={() => onPanel(panel === 'help' ? null : 'help')}
              >
                <Icon name="circle-question" aria-hidden />
              </button>
              <button
                type="button"
                className={classes([
                  'ExamineGallery__pin',
                  BUTTON,
                  pinned && 'Button--selected',
                ])}
                title="Keep controls visible"
                aria-label="Keep controls visible"
                aria-pressed={pinned}
                onClick={() => {
                  show();
                  props.onPinned(!pinned);
                }}
              >
                <Icon name="thumbtack" aria-hidden />
              </button>
            </div>
            {panel === 'help' && (
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
                  {props.state.view === 'whole' && reading && ' (zoomed)'}
                </div>
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
                  {thumbnails && (
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
            )}
          </div>
        </div>
      </div>
      <div className="ExamineGallery__modes">{props.modes}</div>
    </div>
  );
};
