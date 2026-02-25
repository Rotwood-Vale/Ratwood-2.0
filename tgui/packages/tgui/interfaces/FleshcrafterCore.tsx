import { useBackend } from '../backend';
import { Box, Button, NoticeBox, Section, Tabs } from '../components';

type Page = 'home' | 'learn' | 'research' | 'quests' | 'upgrade';

export const MiraclesUI = (_props, context) => {
  const { act, data } = useBackend(context);
  const page: Page = data.page || 'home';
  const pages = data.pages || [];

  return (
    <Box p={1}>
      <Section
        title="Miracles"
        buttons={(
          <Box>
            <Box inline mr={2}>Favor: <b>{data.favor}</b></Box>
            <Box inline mr={2}>MP: <b>{data.mp}</b></Box>
            <Box inline>RP: <b>{data.rp}</b></Box>
          </Box>
        )}
      >
        <Tabs>
          <Tabs.Tab selected={page === 'home'} icon="th" onClick={() => act('set_page', { page: 'home' })}>
            Home
          </Tabs.Tab>
          {pages.map(p => (
            <Tabs.Tab
              key={p.id}
              selected={page === p.id}
              icon={p.icon}
              onClick={() => act('set_page', { page: p.id })}
            >
              {p.label}
            </Tabs.Tab>
          ))}
        </Tabs>

        {page === 'home' && <NoticeBox>Выбери вкладку.</NoticeBox>}
        {page === 'learn' && <LearnPage />}
        {page === 'research' && <ResearchPage />}
        {page === 'quests' && <QuestsPage />}
        {page === 'upgrade' && <UpgradePage />}
      </Section>
    </Box>
  );
};

const LearnPage = (_props, context) => {
  const { act, data } = useBackend(context);
  const buckets = data.learn_buckets || {};
  const tab = data.learn_tab || 'none';
  const patronNames = Object.keys(buckets).sort();

  return (
    <Section title="Learn">
      <Tabs>
        <Tabs.Tab selected={tab === 'none'} onClick={() => act('learn_set_tab', { tab: 'none' })}>
          None
        </Tabs.Tab>
        {patronNames.map(n => (
          <Tabs.Tab key={n} selected={tab === n} onClick={() => act('learn_set_tab', { tab: n })}>
            {n}
          </Tabs.Tab>
        ))}
      </Tabs>

      {tab === 'none' && <NoticeBox>Выбери патрона.</NoticeBox>}

      {tab !== 'none' && (buckets[tab]?.length ? (
        <Box>
          {buckets[tab].map((m, idx) => (
            <Section key={idx} title={`${m.name} (T${m.tier})`}>
              <Box mb={1} color="grey">{m.desc}</Box>
              <Button
                icon="plus"
                disabled={m.learned || data.mp < m.cost}
                content={m.learned ? 'Learned' : `Learn (${m.cost} MP)`}
                onClick={() => act('learn_spell', { type: m.type })}
              />
            </Section>
          ))}
        </Box>
      ) : (
        <NoticeBox>Нет доступных чудес.</NoticeBox>
      ))}
    </Section>
  );
};

const ResearchPage = (_props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Section title="Research">
      <Box mb={1}>
        <Button
          icon="flask"
          disabled={!data.is_fleshcrafter || data.favor < data.RESEARCH_RP_PRICE_FLAVOR}
          content={`Buy RP (${data.RESEARCH_RP_PRICE_FLAVOR} Favor)`}
          onClick={() => act('buy_rp')}
        />
        <Button
          icon="bolt"
          disabled={!data.is_fleshcrafter || data.favor < data.MIRACLE_MP_PRICE_FLAVOR}
          content={`Buy MP (${data.MIRACLE_MP_PRICE_FLAVOR} Favor)`}
          onClick={() => act('buy_mp')}
        />
      </Box>

      <Box>
        <Box>Artefacts: <b>{data.unlocked_artefacts ? 'Unlocked' : 'Locked'}</b></Box>
        <Box>Organs T1: <b>{data.unlocked_org_t1 ? 'Unlocked' : 'Locked'}</b></Box>
        <Box>Organs T2: <b>{data.unlocked_org_t2 ? 'Unlocked' : 'Locked'}</b></Box>
        <Box>Organs T3: <b>{data.unlocked_org_t3 ? 'Unlocked' : 'Locked'}</b></Box>
      </Box>
    </Section>
  );
};

const QuestsPage = (_props, context) => {
  const { act, data } = useBackend(context);
  const quests = data.quests || [];

  return (
    <Section
      title="Quests"
      buttons={(
        <Button
          icon="random"
          disabled={(data.reroll_charges || 0) < 1}
          content={`Reroll (${data.reroll_charges || 0})`}
          onClick={() => act('quests_reroll')}
        />
      )}
    >
      {quests.length === 0 && <NoticeBox>Нет квестов.</NoticeBox>}

      {quests.map((q, i) => (
        <Section key={i} title={q.title}>
          {Object.keys(q.difficulties || {}).map(diff => {
            const D = q.difficulties[diff];
            const locked = q.accepted_diff && q.accepted_diff !== diff;
            return (
              <Box key={diff} mb={1}>
                <Box inline mr={2}><b>{diff.toUpperCase()}</b></Box>
                <Box inline mr={2}>{D.desc}</Box>
                <Box inline mr={2} color="good"><b>{D.reward}</b> Favor</Box>
                <Button
                  icon="gift"
                  disabled={locked || D.spawned}
                  content={locked ? 'Locked' : (D.spawned ? 'Spawned' : 'Get item')}
                  onClick={() => act('quests_spawn', { index: i + 1, diff })}
                />
              </Box>
            );
          })}
        </Section>
      ))}
    </Section>
  );
};

const UpgradePage = (_props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Section title="Upgrade">
      <Button
        icon="arrow-up"
        disabled={data.has_diag_g || !data.has_diag || (data.mp < 2)}
        content={data.has_diag_g ? 'Upgraded' : 'Upgrade Diagnose (2 MP)'}
        onClick={() => act('upgrade_diag')}
      />
      {!data.has_diag && <NoticeBox warning>Нужен Diagnose.</NoticeBox>}
    </Section>
  );
};
