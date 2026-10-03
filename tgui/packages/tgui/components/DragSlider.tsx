import {
  type KeyboardEvent,
  type PointerEvent,
  useEffect,
  useState,
} from 'react';
import { Box, ProgressBar, Stack, Tooltip } from 'tgui-core/components';

type DragSliderProps = {
  label: string;
  value: number;
  minValue?: number;
  maxValue?: number;
  unit?: string;
  hint?: string;
  /** Every change while the pointer is down, for anything that should follow the drag live. */
  onDrag?: (value: number) => void;
  /** The value to keep: a release, a key press, or a typed number. */
  onChange: (value: number) => void;
};

/**
 * A slider that follows the pointer while it is held and commits on release. Arrow keys, Page
 * Up/Down, Home and End move it from the keyboard, and the number beside it can be typed into.
 * The same control the volume menu uses, made general so other windows can share it.
 */
export const DragSlider = (props: DragSliderProps) => {
  const {
    label,
    value,
    minValue = 0,
    maxValue = 100,
    unit = '%',
    hint,
    onDrag,
    onChange,
  } = props;
  const [dragValue, setDragValue] = useState<number | null>(null);
  const [pendingValue, setPendingValue] = useState<number | null>(null);
  const displayedValue = dragValue ?? pendingValue ?? value;
  useEffect(() => {
    if (value === pendingValue) setPendingValue(null);
  }, [value, pendingValue]);

  const span = Math.max(1, maxValue - minValue);
  const clamp = (next: number) =>
    Math.max(minValue, Math.min(maxValue, Math.round(next)));
  const valueAtPointer = (event: PointerEvent<HTMLDivElement>) => {
    const { left, width } = event.currentTarget.getBoundingClientRect();
    return clamp(minValue + ((event.clientX - left) / width) * span);
  };
  const commit = (next: number) => {
    const kept = clamp(next);
    setPendingValue(kept);
    onChange(kept);
  };
  const follow = (next: number) => {
    setDragValue(next);
    onDrag?.(next);
  };
  const onKeyDown = (event: KeyboardEvent<HTMLDivElement>) => {
    const nextValue = {
      ArrowLeft: displayedValue - 1,
      ArrowDown: displayedValue - 1,
      ArrowRight: displayedValue + 1,
      ArrowUp: displayedValue + 1,
      PageDown: displayedValue - 10,
      PageUp: displayedValue + 10,
      Home: minValue,
      End: maxValue,
    }[event.key];
    if (nextValue !== undefined) {
      event.preventDefault();
      commit(nextValue);
    }
  };
  const percent = ((displayedValue - minValue) / span) * 100;
  const title = hint ? (
    <Tooltip content={hint} position="right">
      <b>{label}</b>
    </Tooltip>
  ) : (
    <b>{label}</b>
  );

  return (
    <Stack align="center" mb={0.75}>
      <Stack.Item basis="36%" shrink={0}>
        {title}
      </Stack.Item>
      <Stack.Item grow>
        <div
          className="DragSlider Slider"
          role="slider"
          tabIndex={0}
          aria-label={label}
          aria-valuemin={minValue}
          aria-valuemax={maxValue}
          aria-valuenow={displayedValue}
          aria-valuetext={`${displayedValue}${unit}`}
          onKeyDown={onKeyDown}
          onPointerDown={(event) => {
            if (event.button !== 0) return;
            event.preventDefault();
            event.currentTarget.focus();
            event.currentTarget.setPointerCapture(event.pointerId);
            follow(valueAtPointer(event));
          }}
          onPointerMove={(event) => {
            if (event.currentTarget.hasPointerCapture(event.pointerId)) {
              follow(valueAtPointer(event));
            }
          }}
          onPointerUp={(event) => {
            if (!event.currentTarget.hasPointerCapture(event.pointerId)) return;
            commit(valueAtPointer(event));
            setDragValue(null);
            event.currentTarget.releasePointerCapture(event.pointerId);
          }}
          onLostPointerCapture={() => setDragValue(null)}
        >
          <ProgressBar
            value={displayedValue}
            minValue={minValue}
            maxValue={maxValue}
            empty
          />
          <div className="Slider__cursorOffset" style={{ width: `${percent}%` }}>
            <div className="Slider__cursor" />
          </div>
        </div>
      </Stack.Item>
      <Stack.Item shrink={0}>
        <Tooltip content={`Click the number to type a value.`}>
          <Box width={5}>
            <input
              key={displayedValue}
              className="Input"
              style={{ width: '3.5rem' }}
              aria-label={`${label} value`}
              inputMode="numeric"
              defaultValue={displayedValue}
              onBlur={(event) => {
                const text = event.currentTarget.value.trim();
                const number = Number(text);
                const typed =
                  text && Number.isFinite(number)
                    ? clamp(number)
                    : displayedValue;
                event.currentTarget.value = String(typed);
                if (typed !== displayedValue) commit(typed);
              }}
              onKeyDown={(event) => {
                // Escape puts the old number back, so a half-typed value can be abandoned
                if (event.key === 'Escape') {
                  event.currentTarget.value = String(displayedValue);
                }
                if (event.key === 'Enter' || event.key === 'Escape') {
                  event.preventDefault();
                  event.currentTarget.blur();
                }
              }}
            />
            {unit ? ` ${unit}` : null}
          </Box>
        </Tooltip>
      </Stack.Item>
    </Stack>
  );
};
