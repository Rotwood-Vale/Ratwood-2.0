import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

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

const ActiveProjectSection = (props: {
  project: ActiveProject;
  info: ProjectInfo;
  isLord: boolean;
  act: ActFn;
}) => {
  const { project, info, isLord, act } = props;
  const remaining = Math.max(info.cost - project.paid, 0);
  const canContribute = project.maxContribution > 0;
  const progress = `${formatVitae(project.paid)} / ${formatVitae(info.cost)} vitae`;
  const contributors = project.contributors.length
    ? project.contributors
        .map((entry) => `${entry.name} (${formatVitae(entry.amount)})`)
        .join(', ')
    : 'No one yet';

  return (
    <Section
      title={info.name}
      buttons={
        <>
          <Button
            icon="tint"
            disabled={!canContribute}
            tooltip={
              canContribute
                ? `I can give up to ${formatVitae(project.maxContribution)} vitae`
                : 'I have nothing left to give to this ritual'
            }
            onClick={() => act('contribute', { type: project.type })}
          >
            Contribute
          </Button>
          {isLord && (
            <Button
              icon="times"
              color="bad"
              onClick={() => act('cancel_project', { type: project.type })}
            >
              Cancel
            </Button>
          )}
        </>
      }
    >
      <Box italic color="label" mb={1}>
        {info.description}
      </Box>
      <ProgressBar
        value={project.paid}
        maxValue={Math.max(info.cost, 1)}
        color="bad"
      >
        {progress}
      </ProgressBar>
      <LabeledList>
        <LabeledList.Item label="Remaining">
          {formatVitae(remaining)} vitae
        </LabeledList.Item>
        <LabeledList.Item label="Contributors">{contributors}</LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const AvailableProjectSection = (props: {
  project: AvailableProject;
  info: ProjectInfo;
  act: ActFn;
}) => {
  const { project, info, act } = props;
  const canStart = !!project.canStart;

  return (
    <Section
      title={info.name}
      buttons={
        <Button
          icon="play"
          disabled={!canStart}
          onClick={() => act('start_project', { type: project.type })}
        >
          Begin
        </Button>
      }
    >
      <Box italic color="label">
        {info.description}
      </Box>
      <LabeledList>
        <LabeledList.Item label="Cost">
          {formatVitae(info.cost)} vitae
        </LabeledList.Item>
        {!canStart && !!info.lockedReason && (
          <LabeledList.Item label="Locked" color="bad">
            {info.lockedReason}
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
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
    <Window width={560} height={680}>
      <Window.Content scrollable>
        <Section title="My Vitae">
          <ProgressBar
            value={vitae}
            maxValue={Math.max(maxVitae, 1)}
            color="bad"
          >
            {`${formatVitae(vitae)} / ${formatVitae(maxVitae)}`}
          </ProgressBar>
          <Box mt={1} italic color="label">
            {isLord
              ? 'Right of Dominion: I begin rituals and feed them with vitae.'
              : 'Right of Sacrifice: I feed the rituals my lord has begun.'}
          </Box>
        </Section>
        <Section title="Active Rituals">
          {activeProjects.length ? (
            activeProjects.map((project) => (
              <ActiveProjectSection
                key={project.type}
                project={project}
                info={findProject(projects, project.type)}
                isLord={isLord}
                act={act}
              />
            ))
          ) : (
            <NoticeBox>The crucible is silent. No ritual has begun.</NoticeBox>
          )}
        </Section>
        {isLord ? (
          <Section title="New Rituals">
            {availableProjects.length ? (
              availableProjects.map((project) => (
                <AvailableProjectSection
                  key={project.type}
                  project={project}
                  info={findProject(projects, project.type)}
                  act={act}
                />
              ))
            ) : (
              <NoticeBox>No rituals are available.</NoticeBox>
            )}
          </Section>
        ) : (
          <NoticeBox info>
            Only the lord of the clan may begin or cancel rituals.
          </NoticeBox>
        )}
      </Window.Content>
    </Window>
  );
};
