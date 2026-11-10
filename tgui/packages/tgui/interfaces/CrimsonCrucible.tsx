import type { ReactNode } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
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
  category: string;
  cost: number;
};

type ActiveProject = {
  type: string;
  paid: number;
  fromCup: number;
  maxContribution: number;
  lockedReason: string | null;
  contributors: Contributor[];
};

type AvailableProject = {
  type: string;
  lockedReason: string | null;
};

type Data = {
  projects: ProjectInfo[];
  vitaeReserve: number;
  capacityPerAscension: number;
  isLord: BooleanLike;
  vitae: number;
  maxVitae: number;
  cup: number;
  cupCapacity: number;
  maxPour: number;
  summoning: string | null;
  ascensions: number;
  sunStolen: BooleanLike;
  sunRiteDone: BooleanLike;
  activeProjects: ActiveProject[];
  availableProjects: AvailableProject[];
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

const LOCKED_OPACITY = 0.5;

const formatVitae = (value: number) =>
  Math.round(value || 0).toLocaleString('en-US');

const findProject = (projects: ProjectInfo[], type: string): ProjectInfo =>
  projects.find((info) => info.type === type) || {
    type,
    name: type,
    description: '',
    category: '',
    cost: 0,
  };

const inCategory = <T extends { type: string }>(
  entries: T[],
  projects: ProjectInfo[],
  category: string,
): T[] =>
  entries.filter(
    (entry) => findProject(projects, entry.type).category === category,
  );

const getPourTooltip = (
  maxPour: number,
  cup: number,
  cupCapacity: number,
  vitaeReserve: number,
) => {
  if (maxPour > 0) {
    return `I can pour up to ${formatVitae(maxPour)} vitae`;
  }
  if (cup >= cupCapacity) {
    return 'The cup is full';
  }
  return `The last ${formatVitae(vitaeReserve)} vitae stay with me`;
};

const getContributeTooltip = (
  project: ActiveProject,
  drawsFromCup: boolean,
) => {
  if (project.lockedReason) {
    return project.lockedReason;
  }
  if (project.maxContribution <= 0) {
    return 'I have nothing left to give to this ritual';
  }
  const source = drawsFromCup ? ', the cup first' : '';
  return `I can give up to ${formatVitae(project.maxContribution)} vitae${source}`;
};

const ActiveProjectSection = (props: {
  project: ActiveProject;
  info: ProjectInfo;
  isLord: boolean;
  drawsFromCup: boolean;
  act: ActFn;
}) => {
  const { project, info, isLord, drawsFromCup, act } = props;
  const remaining = Math.max(info.cost - project.paid, 0);
  const canContribute = !project.lockedReason && project.maxContribution > 0;
  const progress = `${formatVitae(project.paid)} / ${formatVitae(info.cost)} vitae`;
  const contributors = project.contributors.length
    ? project.contributors
        .map((entry) => `${entry.name} (${formatVitae(entry.amount)})`)
        .join(', ')
    : 'No one yet';

  return (
    <Section
      title={info.name}
      opacity={project.lockedReason ? LOCKED_OPACITY : undefined}
      buttons={
        <>
          <Button
            icon="tint"
            disabled={!canContribute}
            tooltip={getContributeTooltip(project, drawsFromCup)}
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
        {project.fromCup > 0 && (
          <LabeledList.Item label="From the cup">
            {formatVitae(project.fromCup)} vitae
          </LabeledList.Item>
        )}
        <LabeledList.Item label="Contributors">{contributors}</LabeledList.Item>
        {!!project.lockedReason && (
          <LabeledList.Item label="Waiting" color="average">
            {project.lockedReason}
          </LabeledList.Item>
        )}
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
  const locked = !!project.lockedReason;

  return (
    <Section
      title={info.name}
      opacity={locked ? LOCKED_OPACITY : undefined}
      buttons={
        <Button
          icon="play"
          disabled={locked}
          tooltip={project.lockedReason}
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
        {locked && (
          <LabeledList.Item label="Locked" color="bad">
            {project.lockedReason}
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

const ProjectColumn = (props: {
  title: string;
  header?: ReactNode;
  emptyText?: string;
  active: ActiveProject[];
  available: AvailableProject[];
  projects: ProjectInfo[];
  isLord: boolean;
  drawsFromCup: boolean;
  act: ActFn;
}) => {
  const {
    title,
    header,
    emptyText,
    active,
    available,
    projects,
    isLord,
    drawsFromCup,
    act,
  } = props;
  const isEmpty = !active.length && !available.length;

  return (
    <Section title={title} fill scrollable>
      {header}
      {active.map((project) => (
        <ActiveProjectSection
          key={project.type}
          project={project}
          info={findProject(projects, project.type)}
          isLord={isLord}
          drawsFromCup={drawsFromCup}
          act={act}
        />
      ))}
      {available.map((project) => (
        <AvailableProjectSection
          key={project.type}
          project={project}
          info={findProject(projects, project.type)}
          act={act}
        />
      ))}
      {isEmpty && !!emptyText && <NoticeBox>{emptyText}</NoticeBox>}
    </Section>
  );
};

export const CrimsonCrucible = () => {
  const { act, data } = useBackend<Data>();
  const {
    projects = [],
    vitaeReserve = 0,
    capacityPerAscension = 0,
    vitae = 0,
    maxVitae = 0,
    cup = 0,
    cupCapacity = 0,
    maxPour = 0,
    summoning,
    ascensions = 0,
    activeProjects = [],
    availableProjects = [],
  } = data;
  const isLord = !!data.isLord;
  const drawsFromCup = isLord && cup > 0;
  const ascensionTotal = projects.filter(
    (info) => info.category === 'ascension',
  ).length;
  const lordIsWhole = ascensionTotal > 0 && ascensions >= ascensionTotal;

  const columnProps = (category: string) => ({
    active: inCategory(activeProjects, projects, category),
    available: inCategory(availableProjects, projects, category),
    projects,
    isLord,
    drawsFromCup,
    act,
  });

  let sunHeader: ReactNode = null;
  if (data.sunStolen) {
    sunHeader = (
      <NoticeBox danger>
        The sun is torn from the sky. It returns only when its thief is slain.
      </NoticeBox>
    );
  } else if (data.sunRiteDone) {
    sunHeader = (
      <NoticeBox>The sun has returned. It cannot be stolen twice.</NoticeBox>
    );
  }

  let ascensionEmpty = 'No rite of ascension is underway.';
  if (lordIsWhole) {
    ascensionEmpty = 'The Lord is whole. No rite of ascension remains.';
  } else if (isLord) {
    ascensionEmpty = 'No rite of ascension is available.';
  }

  return (
    <Window width={1100} height={720}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Vitae">
              <LabeledList>
                <LabeledList.Item label="My Vitae">
                  <ProgressBar
                    value={vitae}
                    maxValue={Math.max(maxVitae, 1)}
                    color="bad"
                  >
                    {`${formatVitae(vitae)} / ${formatVitae(maxVitae)}`}
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item
                  label="The Cup"
                  buttons={
                    <Button
                      icon="fill-drip"
                      disabled={maxPour <= 0}
                      tooltip={getPourTooltip(
                        maxPour,
                        cup,
                        cupCapacity,
                        vitaeReserve,
                      )}
                      onClick={() => act('pour_vitae')}
                    >
                      Pour
                    </Button>
                  }
                >
                  <ProgressBar
                    value={cup}
                    maxValue={Math.max(cupCapacity, 1)}
                    color="bad"
                  >
                    {`${formatVitae(cup)} / ${formatVitae(cupCapacity)}`}
                  </ProgressBar>
                </LabeledList.Item>
              </LabeledList>
              <Box mt={1} italic color="label">
                {isLord
                  ? 'Right of Dominion: I begin rituals and direct the cup into them.'
                  : 'Right of Sacrifice: I pour vitae into the cup and feed the rituals my lord has begun.'}
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item grow basis={0}>
                <ProjectColumn
                  title="Summoning Rites"
                  header={
                    !!summoning && (
                      <NoticeBox info>
                        {`The crucible is calling a ${summoning} from beyond. Other servants must wait until the call is answered or fades.`}
                      </NoticeBox>
                    )
                  }
                  emptyText={
                    isLord
                      ? 'No summoning rite is available.'
                      : 'No summoning rite is underway.'
                  }
                  {...columnProps('summoning')}
                />
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <ProjectColumn
                  title="Ascension Rites"
                  header={
                    <Box mb={1}>
                      <ProgressBar
                        value={ascensions}
                        maxValue={Math.max(ascensionTotal, 1)}
                        color="bad"
                      >
                        {`Rites fulfilled: ${ascensions} / ${ascensionTotal}`}
                      </ProgressBar>
                      <Box mt={0.5} italic color="label">
                        {`Each fulfilled rite widens the cup by ${formatVitae(capacityPerAscension)} vitae.`}
                      </Box>
                    </Box>
                  }
                  emptyText={ascensionEmpty}
                  {...columnProps('ascension')}
                />
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <ProjectColumn
                  title="The Sun"
                  header={sunHeader}
                  emptyText={sunHeader ? '' : 'The sun still rules the sky.'}
                  {...columnProps('sun')}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
