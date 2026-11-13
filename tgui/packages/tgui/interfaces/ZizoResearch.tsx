import { Box, Button, DmIcon, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Knowledge = {
  path: string;
  name: string;
  desc: string;
  cost: number;
  aspect?: string;
  lesser: BooleanLike;
  icon: string;
  state: string;
  item?: string;
  done: BooleanLike;
  disabled: BooleanLike;
};

type Info = {
  points: number;
  knowledge: Knowledge[];
};

const KnowledgeTree = () => {
  const { data } = useBackend<Info>();
  const { knowledge } = data;

  const tiers: Record<string, Knowledge[]> = {};
  knowledge.forEach((node) => {
    let tier = node.aspect || 'GREATER';
    if (!node.aspect && node.lesser) {
      tier = 'LESSER';
    }
    tiers[tier] = [...(tiers[tier] || []), node];
  });

  const rank = (tier: string) => {
    const i = ['LESSER', 'GREATER'].indexOf(tier);
    if (i < 0) {
      return 2;
    }
    return i;
  };

  return (
    <Section fill scrollable>
      <Stack vertical>
        {Object.entries(tiers)
          .sort(([a], [b]) => rank(a) - rank(b))
          .map(([tier, nodes]) => (
          <Stack.Item key={tier}>
            <Box textAlign="center" fontSize="24px" color="red">
              {tier}
            </Box>
            <Stack
              justify="center"
              align="center"
              backgroundColor="transparent"
              wrap="wrap"
            >
              {nodes.map((node) => (
                <KnowledgeNode key={node.path} node={node} />
              ))}
            </Stack>
            <hr style={{ border: '1px solid var(--section-title-color)' }} />
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

type KnowledgeNodeProps = {
  node: Knowledge;
};

const KnowledgeNode = (props: KnowledgeNodeProps) => {
  const { node } = props;
  const { data, act } = useBackend<Info>();
  const { points } = data;

  const isBuyable = !node.done && !node.disabled;

  const nodeStyle = () => {
    if (node.done) {
      return {
        background: 'var(--button-background-selected)',
        border: '2px solid var(--section-title-color)',
      };
    }
    if (points < node.cost || node.disabled) {
      return {
        background: 'var(--color-base-end)',
        border: '2px solid var(--color-border)',
        opacity: 0.5,
      };
    }
    return {
      background: 'var(--button-background)',
      border: '2px solid var(--section-separator-color)',
    };
  };

  return (
    <Stack.Item key={node.name}>
      <Button
        color="transparent"
        tooltip={`${node.name}: ${node.desc}`}
        disabled={!isBuyable}
        onClick={() => act('research', { path: node.path })}
        width="64px"
        height="64px"
        m="8px"
        style={{
          borderRadius: '50%',
          ...nodeStyle(),
        }}
      >
        <Box
          position="absolute"
          top="0px"
          left="0px"
          backgroundColor="black"
          textColor="white"
          bold
          style={{ margin: '2px', borderRadius: '100%' }}
        >
          {isBuyable && node.cost}
        </Box>
        <DmIcon
          icon={node.icon}
          icon_state={node.state}
          height="64px"
          width="64px"
          top="0px"
          left="0px"
          position="absolute"
        />
      </Button>
      <Box textAlign="center" fontSize="11px" width="80px">
        {node.name}
      </Box>
    </Stack.Item>
  );
};

export const ZizoResearch = () => {
  const { data } = useBackend<Info>();
  const { points } = data;

  return (
    <Window width={700} height={600} theme="azure_ascendant">
      <Window.Content>
        <Box
          position="absolute"
          top="8px"
          right="16px"
          p="4px 10px"
          bold
          backgroundColor="black"
          color="white"
          style={{ zIndex: 1, borderRadius: '4px' }}
        >
          SECRETS: {points}
        </Box>
        <KnowledgeTree />
      </Window.Content>
    </Window>
  );
};
