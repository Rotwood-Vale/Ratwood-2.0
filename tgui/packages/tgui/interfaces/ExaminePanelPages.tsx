import { useEffect, useLayoutEffect, useMemo, useRef, useState } from 'react';
import { Box, Button, Section, Stack } from 'tgui-core/components';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import {
  HEADSHOT_PANEL_SIZE,
  HeadshotFrame,
  PictureTooLarge,
} from './common/HeadshotFrame';
import {
  guardPictures,
  holdPictures,
  usePictureSize,
} from './common/pictureSize';
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

/**
 * The admin view of the whole picture the framed headshot crops, or a note when it is over the pixel cap. The
 * wrapper is a square no taller than HEADSHOT_PANEL_SIZE, the room the framed headshot takes, and the picture is
 * fitted inside it with objectFit contain. Without the wrapper a tall picture pushes OOC Notes down the column and
 * a flat one leaves the box shorter than the Framed button, which then hangs over OOC Notes
 */
const OriginalHeadshot = (props: { src: string }) => {
  const { src } = props;
  const picture = usePictureSize(src);
  return (
    <div
      style={{
        width: '100%',
        maxHeight: `${HEADSHOT_PANEL_SIZE}px`,
        aspectRatio: '1',
      }}
    >
      {picture.tooLarge && <PictureTooLarge />}
      {picture.drawable && (
        <img
          src={resolveAsset(src)}
          style={{
            display: 'block',
            width: '100%',
            height: '100%',
            objectFit: 'contain',
          }}
        />
      )}
    </div>
  );
};

const OocExtra = (props: { html: string }) => {
  const { html } = props;
  const markupRef = useRef<HTMLDivElement>(null);
  // Changes only with the markup, as a new object makes React rewrite it, restoring replaced pictures and restarting
  // videos. Its pictures go in without their links, so none loads before its size is read
  const markup = useMemo(() => ({ __html: holdPictures(html) }), [html]);
  // After every render, so new elements are caught. Elements already checked are skipped
  useLayoutEffect(() => {
    if (markupRef.current) {
      guardPictures(markupRef.current);
    }
  });
  return (
    <div ref={markupRef}>
      <Box mt={1} dangerouslySetInnerHTML={markup} />
    </div>
  );
};

const chatHtml = (text: string, empty?: string) => ({
  __html: text ? `<span class="Chat">${text}</span>` : (empty ?? ''),
});

export const FlavorTextPage = (props: FlavorTextPageProps) => {
  const { collapsed = false } = props;
  const { data } = useBackend<ExaminePanelData>();
  const {
    flavor_text,
    flavor_text_nsfw,
    ooc_notes,
    ooc_notes_nsfw,
    headshot,
    has_headshot,
    headshot_zoom,
    headshot_x,
    headshot_y,
    is_admin,
    is_naked,
    ooc_extra_image,
    nsfw_ooc_extra_image,
    nsfw_examine_always,
  } = data;
  const [oocNotesIndex, setOocNotesIndex] = useState<'SFW' | 'NSFW'>('SFW');
  const [flavorTextIndex, setFlavorTextIndex] = useState<'SFW' | 'NSFW'>('SFW');
  const [showHeadshot, setShowHeadshot] = useState(true);
  const [showOriginal, setShowOriginal] = useState(false);
  const canShowOriginal = !!is_admin && !!has_headshot;
  const [hideLeft, setHideLeft] = useState(false);
  const [oocEm, setOocEm] = useState({ SFW: 1, NSFW: 1 });
  const [flavorEm, setFlavorEm] = useState({ SFW: 1, NSFW: 1 });

  useEffect(() => {
    if (collapsed) {
      setHideLeft(false);
    }
  }, [collapsed]);

  const showLeft = collapsed || !hideLeft;

  return (
    <Stack fill>
      {showLeft && (
        <Stack.Item
          grow={collapsed}
          width={collapsed ? undefined : '300px'}
          minWidth={collapsed ? 0 : undefined}
        >
          <Stack fill vertical>
            {showHeadshot && (
              <Stack.Item>
                <Box
                  mx="auto"
                  maxWidth={`${HEADSHOT_PANEL_SIZE}px`}
                  position="relative"
                >
                  {canShowOriginal && showOriginal ? (
                    <OriginalHeadshot src={headshot} />
                  ) : (
                    <HeadshotFrame
                      src={headshot}
                      zoom={headshot_zoom}
                      x={headshot_x}
                      y={headshot_y}
                    />
                  )}
                  {canShowOriginal && (
                    <Box position="absolute" top={0.25} right={0.25}>
                      <Button
                        compact
                        icon={showOriginal ? 'crop' : 'image'}
                        tooltip="Admins only. Switches between the framed headshot players see and the whole picture it crops."
                        onClick={() => setShowOriginal(!showOriginal)}
                      >
                        {showOriginal ? 'Framed' : 'Original'}
                      </Button>
                    </Box>
                  )}
                </Box>
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
                    dangerouslySetInnerHTML={chatHtml(
                      ooc_notes,
                      '<i>No OOC notes provided.</i>',
                    )}
                  />
                )}
                {oocNotesIndex === 'NSFW' && (
                  <Box
                    style={{ zoom: oocEm.NSFW }}
                    dangerouslySetInnerHTML={chatHtml(ooc_notes_nsfw)}
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
              <Box style={{ zoom: flavorEm.SFW }}>
                <Box
                  dangerouslySetInnerHTML={chatHtml(
                    flavor_text,
                    '<i>No flavor text provided.</i>',
                  )}
                />
                {ooc_extra_image && <OocExtra html={ooc_extra_image} />}
              </Box>
            )}
            {flavorTextIndex === 'NSFW' && (
              <Box style={{ zoom: flavorEm.NSFW }}>
                <Box dangerouslySetInnerHTML={chatHtml(flavor_text_nsfw)} />
                {nsfw_ooc_extra_image && (
                  <OocExtra html={nsfw_ooc_extra_image} />
                )}
              </Box>
            )}
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};
