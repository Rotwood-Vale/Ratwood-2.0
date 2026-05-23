import { type KeyboardEvent, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Autofocus, Box, Button, Section, Stack } from 'tgui-core/components';
import { isEscape, KEY } from 'tgui-core/keys';
import type { BooleanLike } from 'tgui-core/react';

import { Loader } from './common/Loader';

type Data = {
  autofocus: BooleanLike;
  buttons: string[];
  can_close: BooleanLike;
  large_buttons: BooleanLike;
  message: string;
  swapped_buttons: BooleanLike;
  timeout: number;
  title: string;
};

enum DIRECTION {
  Increment = 1,
  Decrement = -1,
}

export function AlertModal(props) {
  const { act, data } = useBackend<Data>();
  const {
    autofocus,
    buttons = [],
    can_close = true,
    large_buttons,
    message = '',
    timeout,
    title,
  } = data;

  // Stolen wholesale from fontcode
  function textWidth(text: string, font: string, fontsize: number) {
    // default font height is 12 in tgui
    font = `${fontsize}x ${font}`;
    const c = document.createElement('canvas');
    const ctx = c.getContext('2d') as CanvasRenderingContext2D;
    ctx.font = font;
    return ctx.measureText(text).width;
  }

  const [selected, setSelected] = useState(0);

  const buttonCount = Math.max(buttons.length, 1);
  const messageLines = message.split('\n');
  const longestMessageLine = messageLines.reduce(
    (longest, line) => Math.max(longest, line.length),
    0,
  );

  // Expand width for long explicit lines so the modal better matches paragraph content.
  const minWindowWidth = 345 + (buttons.length > 2 ? 55 : 0);
  const estimatedMessageWidth = longestMessageLine * 7 + 80;
  const windowWidth = Math.min(760, Math.max(minWindowWidth, estimatedMessageWidth));

  // very accurate estimate of padding for each num of buttons
  const paddingMagicNumber = 67 / buttonCount + 23;

  // At least one of the buttons has a long text message
  const isVerbose = buttons.some(
    (button) =>
      textWidth(button, '', large_buttons ? 14 : 12) > // 14 is the larger font size for large buttons
      windowWidth / buttonCount - paddingMagicNumber,
  );
  const largeSpacing = isVerbose && large_buttons ? 20 : 15;

  const messageContentWidth = Math.max(260, windowWidth - 70);
  const approxCharsPerLine = Math.max(20, Math.floor(messageContentWidth / 7));
  const estimatedLineCount = messageLines.reduce(
    (total, line) => total + Math.max(1, Math.ceil(line.length / approxCharsPerLine)),
    0,
  );
  const messageHeight = Math.min(560, estimatedLineCount * 18 + 6);
  const buttonHeight = isVerbose
    ? largeSpacing * buttonCount + 20
    : large_buttons
      ? 48
      : 38;

  // Dynamically sets window dimensions
  const windowHeight = Math.min(
    760,
    92 + messageHeight + buttonHeight + (timeout ? 6 : 0),
  );

  /** Changes button selection, etc */
  function keyDownHandler(event: KeyboardEvent<HTMLDivElement>) {
    switch (event.key) {
      case KEY.Space:
      case KEY.Enter:
        if (!buttons.length) {
          return;
        }
        act('choose', { choice: buttons[selected] });
        return;
      case KEY.Left:
        event.preventDefault();
        onKey(DIRECTION.Decrement);
        return;
      case KEY.Tab:
      case KEY.Right:
        event.preventDefault();
        onKey(DIRECTION.Increment);
        return;

      default:
        if (isEscape(event.key) && can_close) {
          act('cancel');
          return;
        }
    }
  }

  /** Manages iterating through the buttons */
  function onKey(direction: DIRECTION) {
    if (!buttons.length) {
      return;
    }
    const newIndex = (selected + direction + buttons.length) % buttons.length;
    setSelected(newIndex);
  }

  return (
    <Window canClose={can_close} height={windowHeight} title={title} width={windowWidth}>
      {!!timeout && <Loader value={timeout} />}
      <Window.Content onKeyDown={keyDownHandler}>
        <Section fill>
          <Stack fill vertical>
            <Stack.Item m={1}>
              <Box color="label" overflow="hidden" style={{ whiteSpace: 'pre-line' }}>
                {message}
              </Box>
            </Stack.Item>
            <Stack.Item>
              {!!autofocus && <Autofocus />}
              {isVerbose ? (
                <VerticalButtons selected={selected} />
              ) : (
                <HorizontalButtons selected={selected} />
              )}
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
}

type ButtonDisplayProps = {
  selected: number;
};

/**
 * Displays a list of buttons ordered by user prefs.
 */
function HorizontalButtons(props: ButtonDisplayProps) {
  const { act, data } = useBackend<Data>();
  const { buttons = [], large_buttons, swapped_buttons } = data;
  const { selected } = props;

  return (
    <Stack fill justify="space-around" reverse={!swapped_buttons}>
      {buttons.map((button, index) => (
        <Stack.Item grow={large_buttons ? 1 : undefined} key={index}>
          <Button
            fluid={!!large_buttons}
            minWidth={5}
            onClick={() => act('choose', { choice: button })}
            overflowX="hidden"
            px={2}
            py={large_buttons ? 0.5 : 0}
            selected={selected === index}
            textAlign="center"
          >
            {!large_buttons ? button : button.toUpperCase()}
          </Button>
        </Stack.Item>
      ))}
    </Stack>
  );
}

/**
 * Technically the parent handles more than 2 buttons, but you
 * should just be using a list input in that case.
 */
function VerticalButtons(props: ButtonDisplayProps) {
  const { act, data } = useBackend<Data>();
  const { buttons = [], large_buttons, swapped_buttons } = data;
  const { selected } = props;

  return (
    <Stack
      align="center"
      fill
      justify="space-around"
      reverse={!swapped_buttons}
      vertical
    >
      {buttons.map((button, index) => (
        <Stack.Item
          grow
          width={large_buttons ? '100%' : undefined}
          key={index}
          m={0}
        >
          <Button
            fluid
            minWidth={20}
            onClick={() => act('choose', { choice: button })}
            overflowX="hidden"
            px={2}
            py={large_buttons ? 0.5 : 0}
            selected={selected === index}
            textAlign="center"
          >
            {!large_buttons ? button : button.toUpperCase()}
          </Button>
        </Stack.Item>
      ))}
    </Stack>
  );
}
