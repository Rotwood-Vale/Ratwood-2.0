import { type CSSProperties, type ReactNode, useState } from 'react';
import { Input } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  badgeStyle,
  cardStyle,
  FONT_SMALL,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subtitleStyle,
  TITLE,
  TITLE_FONT,
  titleStyle,
} from './common/parchment';
import { WaxSeal } from './common/WaxSeal';

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

type ExpandedCovens = Record<string, boolean>;

const capFirst = (text: string) =>
  text ? text.charAt(0).toUpperCase() + text.slice(1) : '';

const isCoven = (coven: Coven | undefined): coven is Coven => !!coven;

const shellStyle: CSSProperties = {
  ...pageStyle,
  display: 'flex',
  flexDirection: 'column',
  height: '100%',
  minHeight: 0,
  padding: '14px 18px',
  boxSizing: 'border-box',
};

const bodyStyle: CSSProperties = {
  display: 'flex',
  gap: '14px',
  flex: 1,
  minHeight: 0,
};

const listPaneStyle: CSSProperties = {
  flex: '0 0 290px',
  overflowY: 'auto',
  paddingRight: '4px',
};

const detailPaneStyle: CSSProperties = {
  flex: 1,
  minWidth: 0,
  overflowY: 'auto',
  scrollbarGutter: 'stable',
  paddingRight: '6px',
};

const blockStyle: CSSProperties = {
  display: 'block',
};

const hintStyle: CSSProperties = {
  color: INK_SOFT,
  fontStyle: 'italic',
  fontSize: FONT_SMALL,
};

const traitRowStyle: CSSProperties = {
  padding: '3px 0',
  borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
};

const InfoBlock = (props: { title: string; children: ReactNode }) => (
  <div style={{ marginBottom: '10px' }}>
    <div style={{ ...sectionHeaderStyle, marginTop: '4px' }}>{props.title}</div>
    {props.children}
  </div>
);

const TraitList = (props: { traits: Trait[] }) => (
  <div>
    {props.traits.map((trait) => (
      <div key={trait.name} style={traitRowStyle}>
        <span style={{ fontWeight: 'bold', color: SEAL_AMBER }}>
          {trait.name}
        </span>
        {!!trait.desc && (
          <span style={{ color: INK_SOFT }}> — {trait.desc}</span>
        )}
      </div>
    ))}
  </div>
);

const ClanCard = (props: {
  clan: Clan;
  index: number;
  isSelected: boolean;
  onSelect: () => void;
}) => {
  const { clan, index, isSelected, onSelect } = props;
  return (
    <button
      type="button"
      onClick={onSelect}
      style={{
        ...cardStyle,
        display: 'flex',
        alignItems: 'center',
        gap: '10px',
        width: '100%',
        marginBottom: '8px',
        textAlign: 'left',
        cursor: 'pointer',
        fontFamily: SERIF,
        color: INK,
        border: `1px solid ${isSelected ? SEAL_RED : INK_FAINT}`,
        background: isSelected ? 'var(--p-tab-active-bg)' : 'var(--p-card-bg)',
      }}
    >
      <WaxSeal
        label={clan.name}
        mark={clan.isCustom ? '?' : `${index + 1}`}
        color={clan.isCustom ? 'amber' : 'red'}
        size={40}
      />
      <span style={{ ...blockStyle, minWidth: 0 }}>
        <span
          style={{ ...blockStyle, fontWeight: 'bold', fontSize: FONT_TITLE }}
        >
          {clan.name}
        </span>
        <span style={{ ...blockStyle, ...hintStyle }}>{clan.tagline}</span>
      </span>
    </button>
  );
};

const LordBlock = (props: { clan: Clan }) => {
  const { clan } = props;
  const vitaeText =
    clan.vitaeBonus > 0
      ? `, endowed with an extra ${clan.vitaeBonus} vitae`
      : '';
  return (
    <InfoBlock title="Lord of the Clan">
      <div>
        Hailed as the <b>{clan.lordTitle}</b>
        {vitaeText}.
      </div>
      {clan.lordForms.map((form) => (
        <div
          key={form.name}
          style={{ ...cardStyle, marginTop: '6px', marginBottom: '6px' }}
        >
          <div style={{ fontWeight: 'bold', color: SEAL_RED }}>{form.name}</div>
          {!!form.desc && <div style={hintStyle}>{form.desc}</div>}
        </div>
      ))}
      {clan.lordTraits.length > 0 && (
        <div style={{ marginTop: '6px' }}>
          <div style={{ color: INK_FAINT, fontSize: FONT_SMALL }}>
            Lord-only Boons
          </div>
          <TraitList traits={clan.lordTraits} />
        </div>
      )}
    </InfoBlock>
  );
};

const CovenCard = (props: {
  coven: Coven;
  isExpanded: boolean;
  onToggle: () => void;
}) => {
  const { coven, isExpanded, onToggle } = props;
  return (
    <div style={{ ...cardStyle, padding: 0 }}>
      <button
        type="button"
        onClick={onToggle}
        style={{
          display: 'flex',
          alignItems: 'flex-start',
          gap: '8px',
          width: '100%',
          padding: '8px 12px',
          textAlign: 'left',
          cursor: 'pointer',
          fontFamily: SERIF,
          color: INK,
          background: 'transparent',
          border: 'none',
        }}
      >
        <span style={{ width: '12px', color: INK_FAINT }}>
          {isExpanded ? '▾' : '▸'}
        </span>
        <span style={{ flex: 1, minWidth: 0 }}>
          <span style={{ ...blockStyle, fontWeight: 'bold' }}>
            {coven.name}
          </span>
          <span style={{ ...blockStyle, ...hintStyle }}>
            {capFirst(coven.desc)}
          </span>
        </span>
      </button>
      {isExpanded && (
        <div style={{ padding: '0 12px 8px 32px' }}>
          {coven.powers.length > 0 ? (
            coven.powers.map((power) => (
              <div
                key={`${power.level}-${power.name}`}
                style={{ ...traitRowStyle, display: 'flex', gap: '8px' }}
              >
                <span style={{ ...badgeStyle(SEAL_RED), marginLeft: 0 }}>
                  {power.level}
                </span>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontWeight: 'bold' }}>
                    {power.name}
                    <span style={{ color: INK_FAINT, fontWeight: 'normal' }}>
                      {' '}
                      · {power.vitaeCost} vitae
                    </span>
                  </div>
                  <div style={{ color: INK_SOFT, whiteSpace: 'pre-line' }}>
                    {capFirst(power.desc)}
                  </div>
                </div>
              </div>
            ))
          ) : (
            <div style={hintStyle}>No powers documented.</div>
          )}
        </div>
      )}
    </div>
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
  const [expandedCovens, setExpandedCovens] = useState<ExpandedCovens>({});
  const clanCovens = clan.covenIds
    .map((covenId) => covens.find((coven) => coven.id === covenId))
    .filter(isCoven);

  const toggleCoven = (name: string) =>
    setExpandedCovens((prev) => ({ ...prev, [name]: !prev[name] }));

  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
        <WaxSeal
          label={clan.name}
          mark={clan.isCustom ? '?' : undefined}
          color={clan.isCustom ? 'amber' : 'red'}
          royal={!clan.isCustom}
          size={54}
        />
        <div style={{ minWidth: 0 }}>
          <div
            style={{
              fontFamily: TITLE_FONT,
              color: TITLE,
              fontSize: '22px',
              fontWeight: 'bold',
            }}
          >
            {clan.name}
          </div>
          <div style={hintStyle}>{clan.tagline}</div>
        </div>
      </div>
      <div style={rulerStyle} />
      {!!clan.isCustom && (
        <InfoBlock title="Clan Name">
          <Input
            fluid
            value={customName}
            onChange={onCustomNameChange}
            placeholder="Name your Caitiff bloodline..."
            maxLength={maxNameLength}
          />
          <div style={{ ...hintStyle, marginTop: '4px' }}>
            Leave blank to be known simply as the Custom Clan.
          </div>
        </InfoBlock>
      )}
      <InfoBlock title="Description">
        <div>{capFirst(clan.desc)}</div>
      </InfoBlock>
      <InfoBlock title="Curse / Downside">
        <div>{capFirst(clan.curse)}</div>
        {!!clan.downside && (
          <div style={{ color: INK_SOFT }}>{capFirst(clan.downside)}</div>
        )}
      </InfoBlock>
      <InfoBlock title="Blood Preference">
        <div>{capFirst(clan.bloodPreference)}</div>
      </InfoBlock>
      <LordBlock clan={clan} />
      {clan.clanTraits.length > 0 && (
        <InfoBlock title="Special Clan Traits">
          <TraitList traits={clan.clanTraits} />
        </InfoBlock>
      )}
      <InfoBlock title="Disciplines & Powers">
        {clanCovens.length > 0 ? (
          clanCovens.map((coven) => (
            <CovenCard
              key={coven.id}
              coven={coven}
              isExpanded={!!expandedCovens[coven.id]}
              onToggle={() => toggleCoven(coven.id)}
            />
          ))
        ) : (
          <div style={hintStyle}>
            {clan.isCustom
              ? `A Caitiff chooses ${clan.covensToSelect} disciplines later.`
              : 'None.'}
          </div>
        )}
      </InfoBlock>
    </div>
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
    <Window title="Clan Selection" width={980} height={720} theme="parchment">
      <Window.Content>
        <div style={shellStyle}>
          <div style={titleStyle}>Clan Selection</div>
          <div style={{ ...subtitleStyle, marginBottom: 0 }}>
            The Blood remembers. Choose your lineage.
          </div>
          <div style={rulerStyle} />
          <div style={bodyStyle}>
            <div style={listPaneStyle}>
              {clans.map((clan, index) => (
                <ClanCard
                  key={clan.id}
                  clan={clan}
                  index={index}
                  isSelected={clan.id === selected?.id}
                  onSelect={() => setSelectedId(clan.id)}
                />
              ))}
            </div>
            <div style={detailPaneStyle}>
              {!!selected && (
                <ClanDetails
                  clan={selected}
                  covens={covens}
                  customName={customName}
                  maxNameLength={maxNameLength}
                  onCustomNameChange={setCustomName}
                />
              )}
            </div>
          </div>
          <div style={{ ...rulerStyle, margin: '10px 0' }} />
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              gap: '12px',
            }}
          >
            <div style={hintStyle}>{fallbackText}</div>
            <div style={{ display: 'flex', gap: '8px', flexShrink: 0 }}>
              <button
                type="button"
                disabled={!selected}
                style={inkButtonStyle({
                  color: SEAL_RED,
                  disabled: !selected,
                })}
                onClick={() =>
                  act('accept_clan', {
                    clan_id: selected?.id,
                    custom_name: customName,
                  })
                }
              >
                Accept Clan
              </button>
              <button
                type="button"
                style={inkButtonStyle()}
                onClick={() => act('close')}
              >
                Close
              </button>
            </div>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
