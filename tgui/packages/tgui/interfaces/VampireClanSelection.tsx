import { useState } from 'react';
import {
  Box,
  Button,
  Collapsible,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Power = {
  name: string;
  level: number;
  desc: string;
  vitaeCost: number;
};

type Coven = {
  id: string;
  name: string;
  desc: string;
  powers: Power[];
};

type Trait = {
  name: string;
  desc: string;
};

type LordForm = {
  name: string;
  desc: string;
};

type Clan = {
  id: string;
  name: string;
  desc: string;
  curse: string;
  downside: string;
  bloodPreference: string;
  tagline: string;
  isCustom: BooleanLike;
  covensToSelect: number;
  covenIds: string[];
  clanTraits: Trait[];
  lordTitle: string;
  lordForms: LordForm[];
  lordTraits: Trait[];
  vitaeBonus: number;
};

type Data = {
  clans: Clan[];
  covens: Coven[];
  defaultClanId: string;
  defaultClanName: string;
  maxNameLength: number;
};

const capFirst = (text: string) =>
  text ? text.charAt(0).toUpperCase() + text.slice(1) : '';

const isCoven = (coven: Coven | undefined): coven is Coven => !!coven;

const TraitList = (props: { traits: Trait[] }) => (
  <LabeledList>
    {props.traits.map((trait) => (
      <LabeledList.Item key={trait.name} label={trait.name}>
        {trait.desc}
      </LabeledList.Item>
    ))}
  </LabeledList>
);

const CovenEntry = (props: { coven: Coven }) => {
  const { coven } = props;
  return (
    <Collapsible title={coven.name}>
      <Box italic color="label" mb={1}>
        {capFirst(coven.desc)}
      </Box>
      {coven.powers.length > 0 ? (
        <LabeledList>
          {coven.powers.map((power) => (
            <LabeledList.Item
              key={`${power.level}-${power.name}`}
              label={`${power.level}. ${power.name}`}
            >
              <Box style={{ whiteSpace: 'pre-line' }}>
                {capFirst(power.desc)}
              </Box>
              <Box color="label">{power.vitaeCost} vitae</Box>
            </LabeledList.Item>
          ))}
        </LabeledList>
      ) : (
        <Box color="label">No powers documented.</Box>
      )}
    </Collapsible>
  );
};

const ClanDetails = (props: {
  clan: Clan;
  covens: Coven[];
  customName: string;
  maxNameLength: number;
  onCustomNameChange: (value: string) => void;
}) => {
  const { clan, covens, customName, maxNameLength, onCustomNameChange } = props;
  const clanCovens = clan.covenIds
    .map((covenId) => covens.find((coven) => coven.id === covenId))
    .filter(isCoven);
  const vitaeText =
    clan.vitaeBonus > 0
      ? `, endowed with an extra ${clan.vitaeBonus} vitae`
      : '';

  return (
    <>
      <Box italic color="label" mb={1}>
        {clan.tagline}
      </Box>
      {!!clan.isCustom && (
        <Section title="Clan Name">
          <Input
            fluid
            value={customName}
            onChange={onCustomNameChange}
            placeholder="Name your Caitiff bloodline..."
            maxLength={maxNameLength}
          />
          <Box mt={0.5} italic color="label">
            Leave blank to be known simply as the Custom Clan.
          </Box>
        </Section>
      )}
      <Section title="Lineage">
        <LabeledList>
          <LabeledList.Item label="Description">
            {capFirst(clan.desc)}
          </LabeledList.Item>
          <LabeledList.Item label="Curse">
            {capFirst(clan.curse)}
          </LabeledList.Item>
          <LabeledList.Item label="Downside">
            {capFirst(clan.downside)}
          </LabeledList.Item>
          <LabeledList.Item label="Blood">
            {capFirst(clan.bloodPreference)}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Lord of the Clan">
        <Box mb={1}>{`Hailed as the ${clan.lordTitle}${vitaeText}.`}</Box>
        {clan.lordForms.length > 0 && <TraitList traits={clan.lordForms} />}
        {clan.lordTraits.length > 0 && (
          <Box mt={1}>
            <Box color="label" mb={0.5}>
              Lord-only Boons
            </Box>
            <TraitList traits={clan.lordTraits} />
          </Box>
        )}
      </Section>
      {clan.clanTraits.length > 0 && (
        <Section title="Special Clan Traits">
          <TraitList traits={clan.clanTraits} />
        </Section>
      )}
      <Section title="Disciplines & Powers">
        {clanCovens.length > 0 ? (
          clanCovens.map((coven) => <CovenEntry key={coven.id} coven={coven} />)
        ) : (
          <Box italic color="label">
            {clan.isCustom
              ? `A Caitiff chooses ${clan.covensToSelect} disciplines later.`
              : 'None.'}
          </Box>
        )}
      </Section>
    </>
  );
};

export const VampireClanSelection = () => {
  const { act, data } = useBackend<Data>();
  const {
    clans = [],
    covens = [],
    defaultClanId,
    defaultClanName,
    maxNameLength,
  } = data;
  const [selectedId, setSelectedId] = useState(defaultClanId);
  const [customName, setCustomName] = useState('');

  const selected = clans.find((clan) => clan.id === selectedId) || clans[0];
  const fallbackText = `If no clan is chosen, you will be claimed by the ${defaultClanName}.`;

  return (
    <Window title="Clan Selection" width={900} height={680}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item width="260px">
                <Section title="Clans" fill scrollable>
                  {clans.map((clan) => (
                    <Button
                      key={clan.id}
                      fluid
                      icon={clan.isCustom ? 'question' : 'tint'}
                      selected={clan.id === selected?.id}
                      tooltip={clan.tagline}
                      tooltipPosition="right"
                      onClick={() => setSelectedId(clan.id)}
                    >
                      {clan.name}
                    </Button>
                  ))}
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section title={selected?.name} fill scrollable>
                  {!!selected && (
                    <ClanDetails
                      clan={selected}
                      covens={covens}
                      customName={customName}
                      maxNameLength={maxNameLength}
                      onCustomNameChange={setCustomName}
                    />
                  )}
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <NoticeBox info>
              <Stack align="center">
                <Stack.Item grow>{fallbackText}</Stack.Item>
                <Stack.Item>
                  <Button
                    icon="check"
                    color="good"
                    disabled={!selected}
                    onClick={() =>
                      act('accept_clan', {
                        clan_id: selected?.id,
                        custom_name: customName,
                      })
                    }
                  >
                    Accept Clan
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button icon="times" onClick={() => act('close')}>
                    Close
                  </Button>
                </Stack.Item>
              </Stack>
            </NoticeBox>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
