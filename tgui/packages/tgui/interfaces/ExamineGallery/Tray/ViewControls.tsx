import { type ReactNode, useId, useRef } from 'react';
import { Icon } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import {
  ART_VIEW_LABELS,
  type ArtViewSettings,
  viewLocked,
  zoomLocked,
} from '../../common/artViewSettings';
import { isReading, type ReaderState } from '../Reader/readingState';
import { GalleryMouseIcon, HintGroup } from './MouseHints';
import {
  BUTTON,
  type ControlsPanel,
  HelpPanel,
  ViewMenu,
  ZoomButtons,
} from './TrayControls';
import { usePanelDismiss } from './usePanelDismiss';
import { useTrayReveal } from './useTrayReveal';

export const ViewControls = (props: {
  owner: ArtViewSettings;
  /** The picture opens only in Scrolling, so its shape and not the owner locks the view */
  scrollingOnly: boolean;
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
  const triggerRef = useRef<HTMLButtonElement>(null);
  const trayRef = useRef<HTMLDivElement>(null);
  const viewRef = useRef<HTMLButtonElement>(null);
  const helpRef = useRef<HTMLButtonElement>(null);
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
  const { revealed, show, hoverControls, rootHandlers, focusInControls } =
    useTrayReveal(triggerRef, trayRef, onPanel);
  usePanelDismiss(panel, onPanel, { viewRef, helpRef }, focusInControls);
  const visible = pinned || revealed || panel !== null;

  return (
    <div className="ExamineGallery__lower" {...rootHandlers}>
      {thumbnails}
      <div className="ExamineGallery__footer">
        <div className="ExamineGallery__footerStart">
          {props.numbers}
          {showHints && (canAdvance || canPan) && (
            <HintGroup
              className="ExamineGallery__mouseHints ExamineGallery__mouseNavigation"
              first={{
                shown: canAdvance,
                icon: <GalleryMouseIcon action="next" />,
                label: 'Next image',
              }}
              second={{
                shown: canPan,
                icon: <GalleryMouseIcon action="pan" />,
                label: 'Drag to pan',
              }}
            />
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
          <HintGroup
            className="ExamineGallery__mouseHints ExamineGallery__mouseZoom"
            first={{
              shown: canPan,
              icon: <GalleryMouseIcon action="scroll" />,
              label: 'Scroll',
            }}
            second={{ shown: canZoom, icon: zoomShortcut, label: 'Zoom' }}
          />
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
              <ViewMenu
                viewRef={viewRef}
                viewId={viewId}
                panel={panel}
                onPanel={onPanel}
                lockedView={lockedView}
                scrollingOnly={props.scrollingOnly}
                viewLabel={viewLabel}
                view={props.state.view}
                onView={props.onView}
                onReset={props.onReset}
              />
              <ZoomButtons
                lockedZoom={lockedZoom}
                zoom={props.state.zoom}
                zoomMin={props.zoomMin}
                zoomMax={props.zoomMax}
                onZoom={props.onZoom}
              />
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
              <HelpPanel
                helpId={helpId}
                helpTitleId={helpTitleId}
                viewLabel={viewLabel}
                view={props.state.view}
                reading={reading}
                canAdvance={canAdvance}
                canPan={canPan}
                canZoom={canZoom}
                lockedZoom={lockedZoom}
                zoomShortcut={zoomShortcut}
                showMouseControls={props.showMouseControls}
                onShowMouseControls={props.onShowMouseControls}
              />
            )}
          </div>
        </div>
      </div>
      <div className="ExamineGallery__modes">{props.modes}</div>
    </div>
  );
};
