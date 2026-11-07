import { type CSSProperties, useId } from 'react';

import { resolveAsset } from '../../assets';

const CARD_BACKGROUNDS = [
  'black',
  'charcoal',
  'red',
  'green',
  'transparent',
  'glass',
] as const;

type CardMaterial = (typeof CARD_BACKGROUNDS)[number];

export const cardMaterial = (value?: string): CardMaterial =>
  CARD_BACKGROUNDS.includes(value as CardMaterial)
    ? (value as CardMaterial)
    : 'transparent';

export const CardBackground = (props: { value?: string }) => {
  const material = cardMaterial(props.value);
  const filterId = `card-glass-${useId().replaceAll(':', '')}`;
  const painted = ['charcoal', 'red', 'green'].includes(material);
  return (
    <span
      aria-hidden="true"
      className={`CardBackground CardBackground--${material}`}
      style={
        {
          '--card-paint': painted
            ? `url("${resolveAsset('gallery_card_paint.png')}")`
            : undefined,
          '--card-reflection': `url("#${filterId}")`,
        } as CSSProperties
      }
    >
      {material === 'glass' && (
        <svg width="0" height="0" className="CardBackground__filters">
          <defs>
            <filter
              id={filterId}
              x="-10%"
              y="-10%"
              width="120%"
              height="120%"
              colorInterpolationFilters="sRGB"
            >
              <feTurbulence
                type="fractalNoise"
                baseFrequency=".012 .024"
                numOctaves="2"
                seed="7"
                result="surface"
              />
              <feDisplacementMap
                in="SourceGraphic"
                in2="surface"
                scale="18"
                xChannelSelector="R"
                yChannelSelector="G"
              />
            </filter>
          </defs>
        </svg>
      )}
    </span>
  );
};
