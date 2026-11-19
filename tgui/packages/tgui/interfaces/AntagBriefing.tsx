import type { CSSProperties } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  FONT_SMALL,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  titleStyle,
} from './common/parchment';

type Goal = {
  text: string;
  // null when the antag does not track this goal live
  completed: boolean | null;
};

type Mark = {
  at: number;
  label: string;
};

type Progress = {
  label: string;
  value: number;
  max: number;
  unit: string;
  marks: Mark[];
  lines: string[];
};

type Data = {
  title: string;
  flavour: string | null;
  explanation: string | null;
  goals: Goal[];
  progress: Progress | null;
};

const pct = (value: number, max: number): number =>
  max > 0 ? Math.min(100, Math.max(0, (value / max) * 100)) : 0;

const markLabelStyle = (left: number): CSSProperties => ({
  position: 'absolute',
  left: `${left}%`,
  transform:
    left >= 99 ? 'translateX(-100%)' : left <= 1 ? 'none' : 'translateX(-50%)',
  top: '20px',
  fontSize: FONT_SMALL,
  color: INK_SOFT,
  whiteSpace: 'nowrap',
  lineHeight: 1.2,
  textAlign: left >= 99 ? 'right' : left <= 1 ? 'left' : 'center',
});

const ProgressCard = (props: { progress: Progress }) => {
  const { label, value, max, unit, marks, lines } = props.progress;
  const fill = pct(value, max);
  return (
    <div style={cardStyle}>
      <div
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'baseline',
          marginBottom: '6px',
        }}
      >
        <span style={{ fontWeight: 'bold' }}>{label}</span>
        <span style={{ color: INK_SOFT }}>
          {value} {unit}
        </span>
      </div>
      <div
        style={{
          position: 'relative',
          height: '52px',
          margin: '0 4px',
        }}
      >
        <div
          style={{
            position: 'absolute',
            left: 0,
            right: 0,
            top: 0,
            height: '14px',
            background: PARCHMENT_SHADOW,
            border: `1px solid ${INK_FAINT}`,
            borderRadius: '2px',
            overflow: 'hidden',
          }}
        >
          <div
            style={{
              width: `${fill}%`,
              height: '100%',
              background: SEAL_GREEN,
              transition: 'width 300ms ease-out',
            }}
          />
        </div>
        {marks.map((mark) => {
          const left = pct(mark.at, max);
          const reached = value >= mark.at;
          return (
            <div key={mark.label}>
              <div
                style={{
                  position: 'absolute',
                  left: `${left}%`,
                  top: '-2px',
                  width: '2px',
                  height: '18px',
                  marginLeft: left >= 99 ? '-2px' : '-1px',
                  background: reached ? SEAL_GREEN : INK_SOFT,
                }}
              />
              <div
                style={{
                  ...markLabelStyle(left),
                  color: reached ? INK : INK_SOFT,
                  fontWeight: reached ? 'bold' : 'normal',
                }}
              >
                <div>{mark.label}</div>
                <div>{mark.at}</div>
              </div>
            </div>
          );
        })}
      </div>
      {lines.map((line) => (
        <div key={line} style={{ color: INK_SOFT, fontStyle: 'italic' }}>
          {line}
        </div>
      ))}
    </div>
  );
};

const GoalRow = (props: { goal: Goal; index: number }) => {
  const { goal, index } = props;
  const tracked = goal.completed !== null && goal.completed !== undefined;
  const done = !!goal.completed;
  return (
    <div
      style={{
        display: 'flex',
        gap: '8px',
        alignItems: 'baseline',
        padding: '4px 2px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        color: done ? INK_SOFT : INK,
      }}
    >
      <span
        style={{
          flex: '0 0 18px',
          textAlign: 'center',
          fontWeight: 'bold',
          color: done ? SEAL_GREEN : INK_FAINT,
        }}
      >
        {tracked ? (done ? '✔' : '☐') : `${index + 1}.`}
      </span>
      <span
        style={{
          flex: 1,
          textDecoration: done ? 'line-through' : 'none',
        }}
      >
        {goal.text}
      </span>
    </div>
  );
};

export const AntagBriefing = () => {
  const { act, data } = useBackend<Data>();
  const { title, flavour, explanation, goals, progress } = data;
  return (
    <Window width={640} height={780} title={title} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={{ ...titleStyle, color: SEAL_RED, letterSpacing: '1px' }}>
            {title}
          </div>
          <hr style={rulerStyle} />
          {!!flavour && (
            <p
              style={{
                fontStyle: 'italic',
                color: INK_SOFT,
                textAlign: 'justify',
                margin: '0 0 10px 0',
              }}
            >
              {flavour}
            </p>
          )}
          {!!explanation && (
            <>
              <div style={sectionHeaderStyle}>Your Purpose</div>
              <p style={{ textAlign: 'justify', margin: '0 0 10px 0' }}>
                {explanation}
              </p>
            </>
          )}
          {(!!progress || goals.length > 0) && (
            <div style={sectionHeaderStyle}>Goals</div>
          )}
          {!!progress && <ProgressCard progress={progress} />}
          {goals.map((goal, index) => (
            <GoalRow key={goal.text} goal={goal} index={index} />
          ))}
          <div style={{ textAlign: 'center', marginTop: '18px' }}>
            <button
              type="button"
              style={{
                ...inkButtonStyle(),
                padding: '4px 28px',
                fontFamily: SERIF,
              }}
              onClick={() => act('close')}
            >
              Close
            </button>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
