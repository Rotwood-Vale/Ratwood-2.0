
import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  PARCHMENT_SHADOW,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SERIF,
  sectionHeaderStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type Objective = {
  explanation: string;
};

type Data = {
  title: string;
  description: string;
  objectives: Objective[];
  tips: string[];
};

export const AntagonistBriefing = () => {
  const { data } = useBackend<Data>();

  return (
    <Window width={620} height={680} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>
            {data.title || 'Antagonist Briefing'}
          </div>

          <div style={subtitleStyle}>
            Your purpose, your obligations, and the fate that awaits.
          </div>

          <div style={rulerStyle} />

          <div style={sectionHeaderStyle}>
            Your Role
          </div>

          <div
            style={{
              ...cardStyle,
              fontFamily: SERIF,
              fontSize: FONT_BODY,
              color: INK,
              lineHeight: '1.5',
              whiteSpace: 'pre-wrap',
            }}
          >
            {data.description ||
              'You have been given a role whose purpose remains to be discovered.'}
          </div>

          <div style={{ ...sectionHeaderStyle, marginTop: '12px' }}>
            Your Objectives
          </div>

          {!data.objectives?.length ? (
            <div
              style={{
                ...cardStyle,
                fontFamily: SERIF,
                fontSize: FONT_BODY,
                color: INK_SOFT,
                fontStyle: 'italic',
              }}
            >
              No formal objectives have been assigned. Follow the guidance
              above and the instructions given for your role.
            </div>
          ) : (
            data.objectives.map((objective, index) => (
              <div
                key={`${index}-${objective.explanation}`}
                style={{
                  ...cardStyle,
                  display: 'flex',
                  gap: '10px',
                  alignItems: 'baseline',
                  fontFamily: SERIF,
                  fontSize: FONT_BODY,
                  color: INK,
                  lineHeight: '1.5',
                  marginBottom: '6px',
                  borderLeft: `3px solid ${SEAL_AMBER}`,
                }}
              >
                <b style={{ color: SEAL_AMBER }}>
                  {index + 1}.
                </b>
                <span style={{ whiteSpace: 'pre-wrap' }}>
                  {objective.explanation}
                </span>
              </div>
            ))
          )}

          {!!data.tips?.length && (
            <>
              <div style={{ ...sectionHeaderStyle, marginTop: '12px' }}>
                Counsel &amp; Advice
              </div>

              <div
                style={{
                  ...cardStyle,
                  fontFamily: SERIF,
                  fontSize: FONT_BODY,
                  color: INK_SOFT,
                }}
              >
                {data.tips.map((tip, index) => (
                  <div
                    key={`${index}-${tip}`}
                    style={{
                      padding: '5px 0',
                      borderBottom:
                        index < data.tips.length - 1
                          ? `1px dashed ${PARCHMENT_SHADOW}`
                          : 'none',
                    }}
                  >
                    <span style={{ color: INK_FAINT }}>
                      •{' '}
                    </span>
                    {tip}
                  </div>
                ))}
              </div>
            </>
          )}

          <div
            style={{
              ...subtitleStyle,
              textAlign: 'center',
              color: INK_FAINT,
              marginTop: '16px',
            }}
          >
            Choose your actions wisely. Your story is not yet written.
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
