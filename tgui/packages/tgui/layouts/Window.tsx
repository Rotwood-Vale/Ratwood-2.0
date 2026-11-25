/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import {
  type ComponentProps,
  type PropsWithChildren,
  type ReactNode,
  useEffect,
  useLayoutEffect,
  useState,
} from 'react';
import type { Box } from 'tgui-core/components';
import { UI_DISABLED, UI_INTERACTIVE } from 'tgui-core/constants';
import { type BooleanLike, classes } from 'tgui-core/react';
import { decodeHtmlEntities } from 'tgui-core/string';

import {
  backendSuspendStart,
  backendWindowGeometryReady,
  globalStore,
  selectBackend,
  useBackend,
  waitsForWindowGeometry,
} from '../backend';
import { useDebug } from '../debug/hooks';
import {
  dragStartHandler,
  recallWindowGeometry,
  resizeStartHandler,
  setWindowKey,
  watchPopupWorkArea,
} from '../drag';
import { createLogger } from '../logging';
import { Layout } from './Layout';
import { TitleBar } from './TitleBar';

const logger = createLogger('Window');
const DEFAULT_SIZE: [number, number] = [400, 600];

type Props = Partial<{
  buttons: ReactNode;
  canClose: BooleanLike;
  fitWorkArea: boolean;
  /** With fitWorkArea, the id of a window this one opens beside rather than over */
  besideWindow: string;
  height: number;
  onBeforeClose: () => void;
  theme: string;
  title: string;
  width: number;
}> &
  PropsWithChildren;

export const Window = (props: Props) => {
  const {
    canClose = true,
    fitWorkArea,
    besideWindow,
    theme,
    title,
    children,
    buttons,
    width,
    height,
    onBeforeClose,
  } = props;

  const { config, suspended, windowSession } = useBackend();
  const { debugLayout = false } = useDebug();
  const [isReadyToRender, setIsReadyToRender] = useState(false);

  // We need to set the window to be invisible before we can set its geometry
  // Otherwise, we get a flicker effect when the window is first rendered
  useLayoutEffect(() => {
    Byond.winset(Byond.windowId, {
      'is-visible': false,
    });
    setIsReadyToRender(true);
  }, []);

  const { scale } = config.window;
  const waitForGeometry = waitsForWindowGeometry(config.interface?.name);
  const gallerySession = waitForGeometry ? windowSession : undefined;
  const galleryKey = waitForGeometry ? config.window.key : undefined;

  useEffect(() => {
    if (!suspended && isReadyToRender) {
      Byond.winset(Byond.windowId, {
        'can-close': Boolean(canClose),
      });
      logger.log('mounting');
      const options = {
        ...config.window,
        size: DEFAULT_SIZE,
      };
      if (width && height) {
        options.size = [width, height];
      }
      if (config.window?.key) {
        setWindowKey(config.window.key);
      }
      let active = true;
      let stopWatchingWorkArea: (() => void) | undefined;
      let revealTimer: ReturnType<typeof setTimeout> | undefined;
      const isCurrent = () => {
        const current = selectBackend(globalStore.getState());
        return (
          active &&
          !current.suspended &&
          !current.suspending &&
          current.windowSession === windowSession &&
          current.config.window?.key === config.window?.key &&
          current.config.interface?.name === config.interface?.name
        );
      };
      const geometry = recallWindowGeometry(options, {
        fitWorkArea,
        besideWindow,
        isCurrent,
        useFallback: waitForGeometry,
      });
      if (waitForGeometry) {
        geometry
          .catch((error) =>
            logger.log('Window geometry could not be restored', error),
          )
          .then((opening) => {
            if (isCurrent()) {
              revealTimer = setTimeout(() => {
                if (isCurrent()) {
                  globalStore.dispatch(backendWindowGeometryReady());
                  if (fitWorkArea) {
                    stopWatchingWorkArea = watchPopupWorkArea(
                      isCurrent,
                      opening,
                    );
                  }
                }
              });
            }
          });
      } else {
        Byond.winset(Byond.windowId, {
          'is-visible': true,
        });
        logger.log('set to visible');
      }

      return () => {
        active = false;
        clearTimeout(revealTimer);
        stopWatchingWorkArea?.();
        logger.log('unmounting');
      };
    }
  }, [
    isReadyToRender,
    width,
    height,
    scale,
    waitForGeometry,
    gallerySession,
    galleryKey,
    fitWorkArea,
  ]);

  const dispatch = globalStore.dispatch;
  const fancy = config.window?.fancy;

  // Determine when to show dimmer
  const showDimmer =
    config.user &&
    (config.user.observer
      ? config.status < UI_DISABLED
      : config.status < UI_INTERACTIVE);
  return suspended ? null : (
    <Layout className="Window" theme={theme || config.window?.theme}>
      <TitleBar
        title={title || decodeHtmlEntities(config.title)}
        status={config.status}
        fancy={fancy}
        onDragStart={dragStartHandler}
        onClose={() => {
          logger.log('pressed close');
          onBeforeClose?.();
          dispatch(backendSuspendStart());
        }}
        canClose={canClose}
      >
        {buttons}
      </TitleBar>
      <div className={classes(['Window__rest', debugLayout && 'debug-layout'])}>
        {!suspended && children}
        {showDimmer && <div className="Window__dimmer" />}
      </div>
      {fancy && (
        <>
          <div
            className="Window__resizeHandle__e"
            onMouseDown={resizeStartHandler(1, 0) as any}
          />
          <div
            className="Window__resizeHandle__s"
            onMouseDown={resizeStartHandler(0, 1) as any}
          />
          <div
            className="Window__resizeHandle__se"
            onMouseDown={resizeStartHandler(1, 1) as any}
          />
        </>
      )}
    </Layout>
  );
};

type ContentProps = Partial<{
  className: string;
  fitted: boolean;
  scrollable: boolean;
  vertical: boolean;
}> &
  ComponentProps<typeof Box> &
  PropsWithChildren;

const WindowContent = (props: ContentProps) => {
  const { className, fitted, children, ...rest } = props;

  return (
    <Layout.Content
      className={classes(['Window__content', className])}
      {...rest}
    >
      {(fitted && children) || (
        <div className="Window__contentPadding">{children}</div>
      )}
    </Layout.Content>
  );
};

Window.Content = WindowContent;
