import { useEffect, useMemo, useState } from 'react';
import { Box, Button, Image, Section, Stack } from 'tgui-core/components';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { ExaminePanelData } from './ExaminePanelData';

type FlavorTextPageProps = {
  collapsed?: boolean;
};

const FONT_MIN = 0.8;
const FONT_MAX = 1.5;
const FONT_STEP = 0.1;

const bumpEm = (value: number, dir: number) =>
  Math.min(FONT_MAX, Math.max(FONT_MIN, +(value + dir * FONT_STEP).toFixed(1)));

const EmButtons = (props: {
  value: number;
  onChange: (value: number) => void;
}) => {
  const atMin = props.value <= FONT_MIN;
  const atMax = props.value >= FONT_MAX;
  return (
    <>
      <Button
        color={atMin ? undefined : 'transparent'}
        compact
        icon="minus"
        disabled={atMin}
        onClick={() => props.onChange(bumpEm(props.value, -1))}
      />
      <Button
        color={atMax ? undefined : 'transparent'}
        compact
        icon="plus"
        disabled={atMax}
        onClick={() => props.onChange(bumpEm(props.value, 1))}
      />
    </>
  );
};

export const FlavorTextPage = (props: FlavorTextPageProps) => {
  const { collapsed = false } = props;
  const { data } = useBackend<ExaminePanelData>();
  const {
    flavor_text,
    flavor_text_nsfw,
    ooc_notes,
    ooc_notes_nsfw,
    headshot,
    is_naked,
    ooc_extra_image,
    nsfw_ooc_extra_image,
    nsfw_examine_always,
  } = data;
  const [oocNotesIndex, setOocNotesIndex] = useState<'SFW' | 'NSFW'>('SFW');
  const [flavorTextIndex, setFlavorTextIndex] = useState<'SFW' | 'NSFW'>('SFW');
  const [showHeadshot, setShowHeadshot] = useState(true);
  const [hideLeft, setHideLeft] = useState(false);
  const [oocEm, setOocEm] = useState({ SFW: 1, NSFW: 1 });
  const [flavorEm, setFlavorEm] = useState({ SFW: 1, NSFW: 1 });

  useEffect(() => {
    if (collapsed) {
      setHideLeft(false);
    }
  }, [collapsed]);

  const showLeft = collapsed || !hideLeft;

  const flavorHTML = useMemo(
    () => ({
      __html: `<span className='Chat'>${flavor_text}</span>`,
    }),
    [flavor_text],
  );

  const nsfwHTML = useMemo(
    () => ({
      __html: `<span className='Chat'>${flavor_text_nsfw}</span>`,
    }),
    [flavor_text_nsfw],
  );

  const oocHTML = useMemo(
    () => ({
      __html: `<span className='Chat'>${ooc_notes}</span>`,
    }),
    [ooc_notes],
  );

  const oocnsfwHTML = useMemo(
    () => ({
      __html: `<span className='Chat'>${ooc_notes_nsfw}</span>`,
    }),
    [ooc_notes_nsfw],
  );

  return (
    <Stack fill>
      {showLeft && (
        <Stack.Item
          grow={collapsed}
          width={collapsed ? undefined : '350px'}
          minWidth={collapsed ? 0 : undefined}
        >
          <Stack fill vertical>
            {showHeadshot && (
              <Stack.Item align="center">
                <img src={resolveAsset(headshot)} width="350px" height="350px" />
              </Stack.Item>
            )}
            <Stack.Item grow>
              <Section
                scrollable
                fill
                title="OOC Notes"
                preserveWhitespace
                buttons={
                  <>
                    <EmButtons
                      value={oocEm[oocNotesIndex]}
                      onChange={(value) =>
                        setOocEm({ ...oocEm, [oocNotesIndex]: value })
                      }
                    />
                    <Button
                      icon={showHeadshot ? 'chevron-up' : 'chevron-down'}
                      tooltip={showHeadshot ? 'Hide headshot' : 'Show headshot'}
                      selected={!showHeadshot}
                      onClick={() => setShowHeadshot(!showHeadshot)}
                    />
                    <Button
                      selected={oocNotesIndex === 'SFW'}
                      bold={oocNotesIndex === 'SFW'}
                      onClick={() => setOocNotesIndex('SFW')}
                      textAlign="center"
                      minWidth="60px"
                    >
                      SFW
                    </Button>
                    <Button
                      selected={oocNotesIndex === 'NSFW'}
                      disabled={!ooc_notes_nsfw}
                      bold={oocNotesIndex === 'NSFW'}
                      onClick={() => setOocNotesIndex('NSFW')}
                      textAlign="center"
                      minWidth="60px"
                    >
                      NSFW
                    </Button>
                  </>
                }
              >
                {oocNotesIndex === 'SFW' && (
                  <Box
                    style={{ zoom: oocEm.SFW }}
                    dangerouslySetInnerHTML={{
                      __html: ooc_notes
                        ? `<span class='Chat'>${ooc_notes}</span>`
                        : '<i>No OOC notes provided.</i>',
                    }}
                  />
                )}
                {oocNotesIndex === 'NSFW' && (
                  <Box
                    style={{ zoom: oocEm.NSFW }}
                    dangerouslySetInnerHTML={oocnsfwHTML}
                  />
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      )}
      {!collapsed && (
        <Stack.Item grow>
          <Section
            scrollable
            fill
            preserveWhitespace
            title="Flavor Text"
            buttons={
              <>
                <EmButtons
                  value={flavorEm[flavorTextIndex]}
                  onChange={(value) =>
                    setFlavorEm({ ...flavorEm, [flavorTextIndex]: value })
                  }
                />
                <Button
                  icon={hideLeft ? 'chevron-right' : 'chevron-left'}
                  tooltip={hideLeft ? 'Show left section' : 'Hide left section'}
                  selected={hideLeft}
                  onClick={() => setHideLeft(!hideLeft)}
                />
                <Button
                  selected={flavorTextIndex === 'SFW'}
                  bold={flavorTextIndex === 'SFW'}
                  onClick={() => setFlavorTextIndex('SFW')}
                  textAlign="center"
                  width="60px"
                >
                  SFW
                </Button>
                <Button
                  selected={flavorTextIndex === 'NSFW'}
                  disabled={
                    !flavor_text_nsfw || (!is_naked && !nsfw_examine_always)
                  }
                  bold={flavorTextIndex === 'NSFW'}
                  onClick={() => setFlavorTextIndex('NSFW')}
                  textAlign="center"
                  width="60px"
                >
                  NSFW
                </Button>
              </>
            }
          >
            {flavorTextIndex === 'SFW' && (
              <>
                <Box
                  style={{ zoom: flavorEm.SFW }}
                  dangerouslySetInnerHTML={{
                    __html: flavor_text
                      ? `<span class='Chat'>${flavor_text}</span>`
                      : '<i>No flavor text provided.</i>',
                  }}
                />
                {ooc_extra_image && (
                  <Box
                    mt={1}
                    dangerouslySetInnerHTML={{
                      __html: ooc_extra_image,
                    }}
                  />
                )}
              </>
            )}
            {flavorTextIndex === 'NSFW' && (
              <>
                <Box
                  style={{ zoom: flavorEm.NSFW }}
                  dangerouslySetInnerHTML={nsfwHTML}
                />
                {nsfw_ooc_extra_image && (
                  <Box
                    mt={1}
                    dangerouslySetInnerHTML={{
                      __html: nsfw_ooc_extra_image,
                    }}
                  />
                )}
              </>
            )}
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};

export const ImageGalleryPage = () => {
  const { data } = useBackend<ExaminePanelData>();
  const { img_gallery, nsfw_img_gallery, is_naked, nsfw_examine_always } = data;

  const [galleryMode, setGalleryMode] = useState<'SFW' | 'NSFW'>('SFW');

  const images =
    galleryMode === 'NSFW' ? nsfw_img_gallery || [] : img_gallery || [];

  return (
    <Section
      title="Image Gallery"
      fill
      scrollable
      buttons={
        <>
          <Button
            selected={galleryMode === 'SFW'}
            bold={galleryMode === 'SFW'}
            onClick={() => setGalleryMode('SFW')}
            textAlign="center"
            minWidth="60px"
          >
            SFW
          </Button>
          <Button
            selected={galleryMode === 'NSFW'}
            disabled={!nsfw_img_gallery || (!is_naked && !nsfw_examine_always)}
            bold={galleryMode === 'NSFW'}
            onClick={() => setGalleryMode('NSFW')}
            textAlign="center"
            minWidth="60px"
          >
            NSFW
          </Button>
        </>
      }
    >
      {images.length === 0 ? (
        <Box align="center" color="gray">
          No images available.
        </Box>
      ) : (
        <Stack fill justify="space-evenly">
          {images.map((val) => (
            <Stack.Item grow key={val}>
              <Section align="center">
                <Image
                  maxHeight="100%"
                  maxWidth="100%"
                  src={resolveAsset(val)}
                />
              </Section>
            </Stack.Item>
          ))}
        </Stack>
      )}
    </Section>
  );
};
