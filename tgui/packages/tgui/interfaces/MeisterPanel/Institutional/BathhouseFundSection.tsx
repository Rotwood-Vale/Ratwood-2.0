import { useState } from 'react';

import {
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  FONT_BODY,
  INK_FAINT,
  inkButtonStyle,
  inkInputStyle,
  sectionHeaderStyle,
} from '../../common/parchment';
import { type TabProps } from '../types';

/**
 * Bathhouse employment section, shown on the Bathhouse fund view. Workers and
 * agents of the Bathhouse may render coin into the coffers, and the Bathmaster
 * sets a separate per-day withdrawal cap for each group - and may suspend a
 * group's payments outright until she resumes them.
 */
export const BathhouseFundSection = ({ data, act }: TabProps) => {
  const [deposit, setDeposit] = useState<string>('');
  const [workerLimit, setWorkerLimit] = useState<string>(
    String(data.bathhouse_worker_withdraw_limit),
  );
  const [agentLimit, setAgentLimit] = useState<string>(
    String(data.bathhouse_agent_withdraw_limit),
  );

  const depositNum = parseInt(deposit, 10) || 0;
  const workerLimitNum = parseInt(workerLimit, 10) || 0;
  const agentLimitNum = parseInt(agentLimit, 10) || 0;
  const depositDisabled = depositNum <= 0 || depositNum > data.account_balance;

  return (
    <>
      <div style={sectionHeaderStyle}>Employment Terms</div>
      <div style={{ color: INK_FAINT, marginBottom: 8, fontSize: FONT_BODY }}>
        <div>
          Workers of the Bathhouse may draw up to{' '}
          {data.bathhouse_worker_withdraw_limit}m per dae
          {!!data.bathhouse_worker_suspended && ' (payments suspended)'}.
        </div>
        <div>
          Agents of the Bathhouse may draw up to{' '}
          {data.bathhouse_agent_withdraw_limit}m per dae
          {!!data.bathhouse_agent_suspended && ' (payments suspended)'}.
        </div>
      </div>
      {!data.is_bathmaster && (
        <div style={{ color: INK_FAINT, marginBottom: 8, fontSize: FONT_BODY }}>
          {data.bathhouse_viewer_suspended
            ? 'The Nightmistress has suspended your payments until she resumes them.'
            : `You have ${data.bathhouse_withdraw_remaining}m remaining this dae.`}
        </div>
      )}

      <div style={sectionHeaderStyle}>Render Coin</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Amount</div>
        <div style={fieldValueStyle}>
          <input
            type="number"
            min={1}
            max={data.account_balance}
            value={deposit}
            onChange={(e) => setDeposit(e.target.value)}
            style={{ ...inkInputStyle, width: 110 }}
          />
          <span style={{ marginLeft: 6, color: INK_FAINT }}>
            mammon (of {data.account_balance}m)
          </span>
        </div>
      </div>
      <div style={{ marginTop: 6, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: depositDisabled })}
          disabled={depositDisabled}
          onClick={() => {
            act('deposit_institutional', {
              fund_id: 'bathhouse',
              amount: depositNum,
            });
            setDeposit('');
          }}
        >
          Render unto the Bathhouse
        </button>
      </div>

      {!!data.is_bathmaster && (
        <>
          <div style={sectionHeaderStyle}>Daily Withdrawal Limits</div>
          <GroupLimitControls
            label="Workers"
            limit={workerLimit}
            setLimit={setWorkerLimit}
            limitNum={workerLimitNum}
            suspended={!!data.bathhouse_worker_suspended}
            onSet={() =>
              act('set_bathhouse_limit', {
                group: 'worker',
                amount: workerLimitNum,
              })
            }
            onToggleSuspend={() =>
              act('toggle_bathhouse_suspension', { group: 'worker' })
            }
          />
          <GroupLimitControls
            label="Agents"
            limit={agentLimit}
            setLimit={setAgentLimit}
            limitNum={agentLimitNum}
            suspended={!!data.bathhouse_agent_suspended}
            onSet={() =>
              act('set_bathhouse_limit', {
                group: 'agent',
                amount: agentLimitNum,
              })
            }
            onToggleSuspend={() =>
              act('toggle_bathhouse_suspension', { group: 'agent' })
            }
          />
        </>
      )}
    </>
  );
};

/**
 * One row of Bathmaster controls for a single group (workers or agents): a
 * daily cap input with a Set button, plus a toggle that suspends or resumes
 * that group's payments entirely.
 */
const GroupLimitControls = (props: {
  label: string;
  limit: string;
  setLimit: (value: string) => void;
  limitNum: number;
  suspended: boolean;
  onSet: () => void;
  onToggleSuspend: () => void;
}) => (
  <div style={{ marginBottom: 10 }}>
    <div style={fieldRowStyle}>
      <div style={fieldLabelStyle}>{props.label}</div>
      <div style={fieldValueStyle}>
        <input
          type="number"
          min={0}
          max={10000}
          value={props.limit}
          onChange={(e) => props.setLimit(e.target.value)}
          style={{ ...inkInputStyle, width: 110 }}
        />
        <span style={{ marginLeft: 6, color: INK_FAINT }}>
          mammon per head, per dae
        </span>
      </div>
    </div>
    <div style={{ marginTop: 6, textAlign: 'right' }}>
      <button
        type="button"
        style={{
          ...inkButtonStyle({ disabled: props.limitNum < 0 }),
          marginRight: 6,
        }}
        disabled={props.limitNum < 0}
        onClick={props.onSet}
      >
        Set Limit
      </button>
      <button
        type="button"
        style={inkButtonStyle({})}
        onClick={props.onToggleSuspend}
      >
        {props.suspended ? 'Resume Payments' : 'Suspend Payments'}
      </button>
    </div>
  </div>
);
