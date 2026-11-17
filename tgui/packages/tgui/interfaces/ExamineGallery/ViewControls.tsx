import { useEffect, useId, useRef } from 'react';
import { Button } from 'tgui-core/components';

import { type ArtViewSettings, buttonRole } from '../CharacterGallery/shared';
import { zoomPercent } from './readingGeometry';
import type { ReaderState } from './readingState';
import { viewLocked, zoomLocked } from './readingState';

export const ViewControls = (props: {
  owner: ArtViewSettings;
  state: ReaderState;
  open: boolean;
  onOpen: (open: boolean) => void;
  onView: (view: ReaderState['view']) => void;
  onZoom: (factor: number) => void;
  onReset: () => void;
  zoomMax: number;
  zoomMin: number;
}) => {
  const root = useRef<HTMLDivElement>(null);
  const id = useId();
  const lockedView = viewLocked(props.owner);
  const lockedZoom = zoomLocked(props.owner);
  const hidden = lockedView && lockedZoom;
  const close = () => {
    props.onOpen(false);
    root.current
      ?.querySelector<HTMLElement>('.ExamineGallery__viewToggle')
      ?.focus({ preventScroll: true });
  };
  useEffect(() => {
    if (!props.open) return;
    const onPointer = (event: PointerEvent) => {
      if (!root.current?.contains(event.target as Node)) props.onOpen(false);
    };
    const onKey = (event: KeyboardEvent) => {
      if (event.key !== 'Escape') return;
      event.preventDefault();
      event.stopPropagation();
      close();
    };
    document.addEventListener('pointerdown', onPointer);
    document.addEventListener('keydown', onKey);
    return () => {
      document.removeEventListener('pointerdown', onPointer);
      document.removeEventListener('keydown', onKey);
    };
  }, [props.open]);
  useEffect(() => {
    if (hidden && props.open) props.onOpen(false);
  }, [hidden, props.open]);
  if (hidden) return null;
  return (
    <div
      ref={root}
      className="ExamineGallery__viewControl"
      onBlur={(event) => {
        if (
          event.relatedTarget &&
          !event.currentTarget.contains(event.relatedTarget)
        ) {
          props.onOpen(false);
        }
      }}
    >
      <Button
        {...buttonRole}
        className="ExamineGallery__viewToggle"
        aria-label="View"
        aria-expanded={props.open}
        aria-controls={id}
        aria-haspopup="dialog"
        onClick={() => props.onOpen(!props.open)}
      >
        View <span aria-hidden="true">▾</span>
      </Button>
      {props.open && (
        <div
          id={id}
          className="ExamineGallery__viewMenu"
          role="dialog"
          aria-label="View controls"
        >
          {lockedView ? (
            <span className="ExamineGallery__viewHelp">
              {props.state.view === 'whole' ? 'Whole Pic' : 'Scroll View'} | Set
              by owner
            </span>
          ) : (
            <div
              className="ExamineGallery__viewChoices"
              role="group"
              aria-label="Image view"
            >
              <Button
                {...buttonRole}
                selected={props.state.view === 'whole'}
                aria-pressed={props.state.view === 'whole'}
                onClick={() => {
                  props.onView('whole');
                  close();
                }}
              >
                Whole Pic
              </Button>
              <Button
                {...buttonRole}
                selected={props.state.view === 'scroll'}
                aria-pressed={props.state.view === 'scroll'}
                onClick={() => {
                  props.onView('scroll');
                  close();
                }}
              >
                Scroll View
              </Button>
            </div>
          )}
          <Button
            {...buttonRole}
            onClick={() => {
              props.onReset();
              close();
            }}
          >
            Reset view
          </Button>
          {!lockedZoom && (
            <div
              className="ExamineGallery__zoomControls"
              role="group"
              aria-label="Image zoom"
            >
              <Button
                {...buttonRole}
                aria-label="Zoom out"
                disabled={props.state.zoom <= props.zoomMin}
                onClick={() => props.onZoom(0.8)}
              >
                −
              </Button>
              <output aria-live="polite">
                {zoomPercent(props.state.zoom)}
              </output>
              <Button
                {...buttonRole}
                aria-label="Zoom in"
                disabled={props.state.zoom >= props.zoomMax}
                onClick={() => props.onZoom(1.25)}
              >
                +
              </Button>
            </div>
          )}
          {!lockedZoom && (
            <small className="ExamineGallery__zoomHint">
              Ctrl + Scroll with MMB to Zoom
            </small>
          )}
          {lockedZoom && (
            <span className="ExamineGallery__viewHelp">
              Zoom is locked by the owner.
            </span>
          )}
        </div>
      )}
    </div>
  );
};
