import type { CSSProperties } from 'react';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  FONT_SMALL,
  FONT_TITLE,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_RED,
  sectionHeaderStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';
import { WaxSeal } from './common/WaxSeal';

type Contributor = {
  name: string;
  amount: number;
};

type ProjectInfo = {
  type: string;
  name: string;
  description: string;
  cost: number;
  lockedReason: string;
};

type ActiveProject = {
  type: string;
  paid: number;
  maxContribution: number;
  contributors: Contributor[];
};

type AvailableProject = {
  type: string;
  canStart: BooleanLike;
};

type Data = {
  projects: ProjectInfo[];
  isLord: BooleanLike;
  vitae: number;
  maxVitae: number;
  activeProjects: ActiveProject[];
  availableProjects: AvailableProject[];
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

const formatVitae = (value: number) =>
  Math.round(value || 0).toLocaleString('en-US');

const findProject = (projects: ProjectInfo[], type: string): ProjectInfo =>
  projects.find((info) => info.type === type) || {
    type,
    name: type,
    description: '',
    cost: 0,
    lockedReason: '',
  };

const hintStyle: CSSProperties = {
  color: INK_SOFT,
  fontStyle: 'italic',
  fontSize: FONT_SMALL,
};

const emptyStyle: CSSProperties = {
  ...cardStyle,
  color: INK_FAINT,
  fontStyle: 'italic',
  textAlign: 'center',
};

const VitaeBar = (props: { value: number; max: number; color: string }) => {
  const { value, max, color } = props;
  const pct = max > 0 ? Math.max(0, Math.min((value / max) * 100, 100)) : 0;
  return (
    <div
      style={{
        background: PARCHMENT_SHADOW,
        height: '8px',
        borderRadius: '2px',
        margin: '6px 0 4px 0',
      }}
    >
      <div
        style={{
          background: color,
          width: `${pct}%`,
          height: '100%',
          borderRadius: '2px',
        }}
      />
    </div>
  );
};

const ActiveProjectCard = (props: {
  project: ActiveProject;
  info: ProjectInfo;
  index: number;
  isLord: boolean;
  act: ActFn;
}) => {
  const { project, info, index, isLord, act } = props;
  const remaining = Math.max(info.cost - project.paid, 0);
  const percent =
    info.cost > 0 ? Math.floor((project.paid / info.cost) * 100) : 100;
  const canContribute = project.maxContribution > 0;
  const progress = `${formatVitae(project.paid)} / ${formatVitae(info.cost)} vitae (${percent}%)`;
  const contributors = project.contributors.length
    ? project.contributors
        .map((entry) => `${entry.name} (${formatVitae(entry.amount)})`)
        .join(', ')
    : 'No one yet';

  return (
    <div style={cardStyle}>
      <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
        <WaxSeal label={info.name} mark={`${index + 1}`} size={44} />
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontWeight: 'bold', fontSize: FONT_TITLE }}>
            {info.name}
          </div>
          <div style={hintStyle}>{info.description}</div>
        </div>
      </div>
      <VitaeBar value={project.paid} max={info.cost} color={SEAL_RED} />
      <div
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          fontSize: FONT_SMALL,
          color: INK_SOFT,
        }}
      >
        <span>{progress}</span>
        <span>Remaining: {formatVitae(remaining)}</span>
      </div>
      <div style={{ ...hintStyle, marginTop: '4px' }}>
        Contributors: {contributors}
      </div>
      <div
        style={{
          display: 'flex',
          justifyContent: 'flex-end',
          gap: '6px',
          marginTop: '8px',
        }}
      >
        <button
          type="button"
          disabled={!canContribute}
          title={
            canContribute
              ? `I can give up to ${formatVitae(project.maxContribution)} vitae`
              : 'I have nothing left to give to this ritual'
          }
          style={inkButtonStyle({ color: SEAL_RED, disabled: !canContribute })}
          onClick={() => act('contribute', { type: project.type })}
        >
          Contribute
        </button>
        {isLord && (
          <button
            type="button"
            style={inkButtonStyle()}
            onClick={() => act('cancel_project', { type: project.type })}
          >
            Cancel
          </button>
        )}
      </div>
    </div>
  );
};

const AvailableProjectCard = (props: {
  project: AvailableProject;
  info: ProjectInfo;
  act: ActFn;
}) => {
  const { project, info, act } = props;
  const canStart = !!project.canStart;

  return (
    <div style={cardStyle}>
      <div style={{ fontWeight: 'bold', fontSize: FONT_TITLE }}>
        {info.name}
      </div>
      <div style={hintStyle}>{info.description}</div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          gap: '8px',
          marginTop: '8px',
        }}
      >
        <div style={{ minWidth: 0 }}>
          <div style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
            Cost: {formatVitae(info.cost)} vitae
          </div>
          {!canStart && !!info.lockedReason && (
            <div style={{ ...hintStyle, color: SEAL_RED }}>
              {info.lockedReason}
            </div>
          )}
        </div>
        <button
          type="button"
          disabled={!canStart}
          style={inkButtonStyle({ color: SEAL_RED, disabled: !canStart })}
          onClick={() => act('start_project', { type: project.type })}
        >
          Begin
        </button>
      </div>
    </div>
  );
};

export const CrimsonCrucible = () => {
  const { act, data } = useBackend<Data>();
  const {
    projects = [],
    vitae = 0,
    maxVitae = 0,
    activeProjects = [],
    availableProjects = [],
  } = data;
  const isLord = !!data.isLord;

  return (
    <Window width={680} height={720} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>Crimson Crucible</div>
          <div style={subtitleStyle}>
            {isLord
              ? 'Right of Dominion: begin rituals and feed them with vitae.'
              : 'Right of Sacrifice: feed the rituals your lord has begun.'}
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <span>My vitae</span>
            <span>
              {formatVitae(vitae)} / {formatVitae(maxVitae)}
            </span>
          </div>
          <VitaeBar value={vitae} max={maxVitae} color={SEAL_RED} />
          <div style={rulerStyle} />

          <div style={sectionHeaderStyle}>Active Rituals</div>
          {activeProjects.length ? (
            activeProjects.map((project, index) => (
              <ActiveProjectCard
                key={project.type}
                project={project}
                info={findProject(projects, project.type)}
                index={index}
                isLord={isLord}
                act={act}
              />
            ))
          ) : (
            <div style={emptyStyle}>
              The crucible is silent. No ritual has begun.
            </div>
          )}

          {isLord ? (
            <>
              <div style={sectionHeaderStyle}>New Rituals</div>
              {availableProjects.length ? (
                availableProjects.map((project) => (
                  <AvailableProjectCard
                    key={project.type}
                    project={project}
                    info={findProject(projects, project.type)}
                    act={act}
                  />
                ))
              ) : (
                <div style={emptyStyle}>No rituals are available.</div>
              )}
            </>
          ) : (
            <div style={{ ...hintStyle, textAlign: 'center' }}>
              Only the lord of the clan may begin or cancel rituals.
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
