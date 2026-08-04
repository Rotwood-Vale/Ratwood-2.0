import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Input,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Track = {
  title: string;
  selected: boolean;
  duration_seconds: number;
  duration_label: string;
  phrase_count: number;
  custom: boolean;
  analyzed_duration: boolean;
};

type Phrase = {
  time: number;
  text: string;
};

type SelectedTrack = {
  title: string;
  custom: boolean;
  duration_seconds: number;
  duration_label: string;
  analyzed_duration: boolean;
  spacing_seconds: number;
  lyrics: string;
  json: string;
  phrases: Phrase[];
};

type Data = {
  tracks: Track[];
  selected?: SelectedTrack | null;
  is_expert: boolean;
  playing: boolean;
  repeat_enabled: boolean;
  repeat_mode: 'once' | 'repeat';
  elapsed_seconds: number;
  progress_ratio: number;
  playback_id: number;
  auto_song_enabled: boolean;
  auto_singing_title?: string | null;
  playing_track_title?: string | null;
  playing_duration_seconds: number;
  playing_duration_label: string;
  band_invite_active: boolean;
  band_invite_seconds_left: number;
  band_members: BandMember[];
  is_band_leader: boolean;
};

type BandMember = {
  name: string;
  instrument: string;
  track: string;
  mode: string;
};

type BardAct = (action: string, params?: Record<string, unknown>) => void;
type BardTab = 'text' | 'timing';

type EditorPanelProps = {
  selected?: SelectedTrack | null;
  activeTab: BardTab;
  setActiveTab: (tab: BardTab) => void;
  canEditSelected: boolean;
  lyricsDraft: string;
  updateLyrics: (value: string) => void;
  spacingDraft: number;
  setSpacingDraft: (value: number) => void;
  act: BardAct;
};

const BardEditorPanel = (props: EditorPanelProps) => {
  const {
    selected,
    activeTab,
    setActiveTab,
    canEditSelected,
    lyricsDraft,
    updateLyrics,
    spacingDraft,
    setSpacingDraft,
    act,
  } = props;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <BardEditorTabs
          activeTab={activeTab}
          setActiveTab={setActiveTab}
          canEditSelected={canEditSelected}
          spacingDraft={spacingDraft}
          setSpacingDraft={setSpacingDraft}
          act={act}
        />
      </Stack.Item>
      <Stack.Item grow basis={0}>
        <BardEditorContent
          selected={selected}
          activeTab={activeTab}
          canEditSelected={canEditSelected}
          lyricsDraft={lyricsDraft}
          updateLyrics={updateLyrics}
          spacingDraft={spacingDraft}
          act={act}
        />
      </Stack.Item>
    </Stack>
  );
};

const BardEditorTabs = (props: {
  activeTab: BardTab;
  setActiveTab: (tab: BardTab) => void;
  canEditSelected: boolean;
  spacingDraft: number;
  setSpacingDraft: (value: number) => void;
  act: BardAct;
}) => {
  const { activeTab, setActiveTab, canEditSelected, spacingDraft, setSpacingDraft, act } = props;

  return (
    <Section>
      <Stack>
        <Stack.Item grow basis={0}>
          <Button fluid selected={activeTab === 'text'} onClick={() => setActiveTab('text')}>
            Text
          </Button>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Button fluid selected={activeTab === 'timing'} onClick={() => setActiveTab('timing')}>
            Timing
          </Button>
        </Stack.Item>
        <Stack.Item width="170px">
          <Stack align="center">
            <Stack.Item>
              <Box color="label">Delay</Box>
            </Stack.Item>
            <Stack.Item>
              <NumberInput
                value={spacingDraft}
                minValue={1}
                maxValue={120}
                step={1}
                stepPixelSize={4}
                width="64px"
                onChange={(value: number) => setSpacingDraft(value)}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                compact
                disabled={!canEditSelected}
                onClick={() =>
                  act('set_spacing', {
                    spacing: spacingDraft,
                  })
                }
              >
                Set
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const BardEditorContent = (props: {
  selected?: SelectedTrack | null;
  activeTab: BardTab;
  canEditSelected: boolean;
  lyricsDraft: string;
  updateLyrics: (value: string) => void;
  spacingDraft: number;
  act: BardAct;
}) => {
  const { selected, activeTab, canEditSelected, lyricsDraft, updateLyrics, spacingDraft, act } =
    props;

  if (!canEditSelected) {
    return (
      <Section fill>
        <Box color="label" textAlign="center" mt={4}>
          Недоступно для предзаготовленных
        </Box>
      </Section>
    );
  }

  if (activeTab === 'text') {
    return (
      <Section
        fill
        title="Input text"
        buttons={
          <Button
            icon="save"
            disabled={!canEditSelected}
            onClick={() =>
              act('set_lyrics', {
                lyrics: lyricsDraft,
                spacing: spacingDraft,
              })
            }
          >
            Build records
          </Button>
        }
      >
        <TextArea
          height="100%"
          fluid
          value={lyricsDraft}
          placeholder="Paste lyrics here. Tags like [Verse] will be stripped."
          onChange={updateLyrics}
          dontUseTabForIndent
        />
      </Section>
    );
  }

  return <BardTimingEditor selected={selected} act={act} />;
};

const BardTimingEditor = (props: { selected?: SelectedTrack | null; act: BardAct }) => {
  const { selected, act } = props;

  return (
    <Section fill scrollable title="Timing">
      {selected?.phrases?.length ? (
        <Stack vertical>
          {selected.phrases.map((phrase, index) => (
            <BardTimingRow
              key={`${phrase.time}-${index}`}
              phrase={phrase}
              index={index}
              act={act}
            />
          ))}
        </Stack>
      ) : (
        <Box color="label">No phrase records yet.</Box>
      )}
    </Section>
  );
};

const BardTimingRow = (props: { phrase: Phrase; index: number; act: BardAct }) => {
  const { phrase, index, act } = props;

  return (
    <Stack.Item>
      <Stack align="center">
        <Stack.Item width="82px">
          <NumberInput
            value={phrase.time}
            minValue={0}
            maxValue={9999}
            step={1}
            stepPixelSize={4}
            width="78px"
            onChange={(value: number) =>
              act('set_phrase_time', {
                index: index + 1,
                time: value,
              })
            }
          />
        </Stack.Item>
        <Stack.Item grow>
          <Input
            fluid
            value={phrase.text}
            onBlur={(value) =>
              act('set_phrase_text', {
                index: index + 1,
                text: value,
              })
            }
            onEnter={(value) =>
              act('set_phrase_text', {
                index: index + 1,
                text: value,
              })
            }
          />
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};

export const BardMusicLibrary = () => {
  const { data, act } = useBackend<Data>();
  const {
    tracks = [],
    selected,
    is_expert,
    playing,
    repeat_enabled,
    repeat_mode,
    elapsed_seconds,
    playback_id,
    auto_song_enabled,
    playing_track_title,
    playing_duration_seconds,
    playing_duration_label,
    band_invite_active,
    band_invite_seconds_left,
    band_members = [],
    is_band_leader,
  } = data;
  const [lyricsDraft, setLyricsDraft] = useState('');
  const [jsonDraft, setJsonDraft] = useState('');
  const [showPrepared, setShowPrepared] = useState(true);
  const [compactMode, setCompactMode] = useState(true);
  const [activeTab, setActiveTab] = useState<'text' | 'timing'>('timing');
  const [spacingDraft, setSpacingDraft] = useState(2);
  const [localElapsed, setLocalElapsed] = useState(0);
  const [elapsedAnchor, setElapsedAnchor] = useState({
    elapsed: 0,
    receivedAt: Date.now(),
  });
  const preparedTracks = tracks.filter((track) => !track.custom);
  const customTracks = tracks.filter((track) => track.custom);
  const allTracks = tracks;
  const canEditSelected = !!selected?.custom;
  const showBandInvite = !!band_invite_active;
  const canSingSelected = !!selected?.custom && !!selected?.phrases?.length;
  const isSingingSelected = !!auto_song_enabled;
  const selectedDuration =
    playing && playing_track_title === selected?.title
      ? playing_duration_seconds
      : selected?.duration_seconds || 0;
  const selectedDurationLabel =
    playing && playing_track_title === selected?.title
      ? playing_duration_label
      : selected?.duration_label || '0:00';
  const displayElapsed =
    playing && selectedDuration > 0
      ? repeat_enabled
        ? localElapsed % selectedDuration
        : Math.min(localElapsed, selectedDuration)
      : 0;
  const progressRatio =
    selectedDuration > 0 ? Math.min(displayElapsed / selectedDuration, 1) : 0;

  const updateLyrics = (value: string) => {
    setLyricsDraft(value);
  };

  useEffect(() => {
    setLyricsDraft(selected?.lyrics || '');
    setJsonDraft(selected?.json || '');
    setSpacingDraft(selected?.spacing_seconds || 2);
  }, [selected?.title, selected?.lyrics, selected?.json, selected?.spacing_seconds]);

  useEffect(() => {
    const elapsed = elapsed_seconds || 0;
    setElapsedAnchor({
      elapsed,
      receivedAt: Date.now(),
    });
    setLocalElapsed(elapsed);
  }, [playing, playback_id, playing_track_title]);

  useEffect(() => {
    if (!playing) {
      return;
    }
    const timer = setInterval(() => {
      setLocalElapsed(elapsedAnchor.elapsed + (Date.now() - elapsedAnchor.receivedAt) / 1000);
    }, 250);
    return () => clearInterval(timer);
  }, [elapsedAnchor, playing]);

  if (compactMode) {
    return (
      <Window width={520} height={520} title="Music">
        <Window.Content>
          <Stack vertical fill>
            <Stack.Item>
              <Section>
                <Stack align="center">
                  <Stack.Item grow basis={0}>
                    <Box bold fontSize={1.15}>
                      {selected?.title || 'No track selected'}
                    </Box>
                    {!!selected && (
                      <Box color="label">
                        {selected.duration_seconds}s ({selectedDurationLabel}),{' '}
                        {selected.phrases.length} records
                      </Box>
                    )}
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon={repeat_mode === 'repeat' ? 'repeat' : 'step-forward'}
                      selected={repeat_mode === 'repeat'}
                      onClick={() =>
                        act('set_repeat_mode', {
                          mode: repeat_mode === 'repeat' ? 'once' : 'repeat',
                        })
                      }
                    >
                      {repeat_mode === 'repeat' ? 'Loop' : 'Once'}
                    </Button>
                    <Button
                      icon={isSingingSelected ? 'microphone' : 'microphone-slash'}
                      disabled={!canSingSelected}
                      selected={isSingingSelected}
                      onClick={() => act('toggle_sing')}
                    >
                      {isSingingSelected ? 'Sing' : 'Mute'}
                    </Button>
                    <Button
                      icon={playing ? 'stop' : 'play'}
                      disabled={!selected}
                      onClick={() => act('play')}
                    >
                      {playing ? 'Stop' : 'Play'}
                    </Button>
                    <Button icon="expand" onClick={() => setCompactMode(false)}>
                      Full
                    </Button>
                  </Stack.Item>
                </Stack>
                {!!selected && (
                  <ProgressBar
                    value={progressRatio}
                    color="blue"
                    mt={0.5}
                  >
                    {Math.round(displayElapsed)}s / {selectedDuration}s
                  </ProgressBar>
                )}
              </Section>
            </Stack.Item>

            <Stack.Item grow basis={0}>
              <Section fill scrollable title={`Tracks (${allTracks.length})`}>
                <Stack vertical>
                  {allTracks.map((track) => (
                    <Stack.Item key={`${track.custom ? 'custom' : 'prepared'}-${track.title}`}>
                      <Button
                        fluid
                        selected={track.selected}
                        onClick={() =>
                          act('select', {
                            title: track.title,
                          })
                        }
                      >
                        <Stack align="center">
                          <Stack.Item grow basis={0}>
                            {track.title}
                          </Stack.Item>
                          <Stack.Item>
                            <Box color="label">
                              {track.duration_seconds}s ({track.duration_label})
                            </Box>
                          </Stack.Item>
                        </Stack>
                      </Button>
                    </Stack.Item>
                  ))}
                  {!allTracks.length && (
                    <Stack.Item>
                      <Box color="label">No tracks.</Box>
                    </Stack.Item>
                  )}
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window width={980} height={650} title="Music">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow basis={0}>
                  <Box bold fontSize={1.25}>
                    {selected?.title || 'No track selected'}
                  </Box>
                  {!!selected && (
                    <Box color="label">
                      {selected.duration_seconds}s ({selectedDurationLabel})
                      {selected.analyzed_duration ? '' : ' - fallback length'}
                    </Box>
                  )}
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon={repeat_mode === 'repeat' ? 'repeat' : 'step-forward'}
                    selected={repeat_mode === 'repeat'}
                    onClick={() =>
                      act('set_repeat_mode', {
                        mode: repeat_mode === 'repeat' ? 'once' : 'repeat',
                      })
                    }
                  >
                    {repeat_mode === 'repeat' ? 'Loop' : 'Once'}
                  </Button>
                  <Button
                    icon={isSingingSelected ? 'microphone' : 'microphone-slash'}
                    disabled={!canSingSelected}
                    selected={isSingingSelected}
                    onClick={() => act('toggle_sing')}
                  >
                    {isSingingSelected ? 'Sing' : 'Mute'}
                  </Button>
                  <Button
                    icon={playing ? 'stop' : 'play'}
                    disabled={!selected}
                    onClick={() => act('play')}
                  >
                    {playing ? 'Stop' : 'Play'}
                  </Button>
                  <Button icon="compress" onClick={() => setCompactMode(true)}>
                    Compact
                  </Button>
                </Stack.Item>
              </Stack>
              {!!selected && (
                <ProgressBar
                  value={progressRatio}
                  color="blue"
                  mt={0.5}
                >
                  {Math.round(displayElapsed)}s / {selectedDuration}s
                </ProgressBar>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section
              title={`Prepared (${preparedTracks.length})`}
              buttons={
                <Button
                  compact
                  icon={showPrepared ? 'chevron-up' : 'chevron-down'}
                  onClick={() => setShowPrepared(!showPrepared)}
                >
                  {showPrepared ? 'Hide' : 'Show'}
                </Button>
              }
            >
              {showPrepared && (
                <Box
                  style={{
                    display: 'grid',
                    gap: '4px',
                    gridTemplateColumns: 'repeat(4, minmax(0, 1fr))',
                  }}
                >
                  {preparedTracks.map((track) => (
                    <Button
                      key={track.title}
                      fluid
                      compact
                      selected={track.selected}
                      onClick={() =>
                        act('select', {
                          title: track.title,
                        })
                      }
                    >
                      {track.title}
                    </Button>
                  ))}
                </Box>
              )}
            </Section>
          </Stack.Item>

          {showBandInvite && (
            <Stack.Item>
              <Section
                title={`Band invite (${band_invite_seconds_left}s)`}
                buttons={
                  is_band_leader && (
                    <>
                      <Button icon="play" onClick={() => act('start_band')}>
                        Start
                      </Button>
                      <Button icon="times" color="red" onClick={() => act('cancel_band')}>
                        Cancel
                      </Button>
                    </>
                  )
                }
              >
                {band_members.length ? (
                  <Stack wrap>
                    {band_members.map((member, index) => (
                      <Stack.Item key={`${member.name}-${index}`}>
                        <Box>
                          <b>{member.name}</b> - {member.instrument}: {member.track} ({member.mode})
                        </Box>
                      </Stack.Item>
                    ))}
                  </Stack>
                ) : (
                  <Box color="label">Waiting for performers.</Box>
                )}
              </Section>
            </Stack.Item>
          )}

          <Stack.Item grow basis={0}>
            <Stack fill>
              <Stack.Item width="280px">
                <Section
                  fill
                  scrollable
                  title="Custom"
                  buttons={
                    is_expert && (
                      <Button
                        compact
                        icon="plus"
                        onClick={() =>
                          act('upload', {
                            lyrics: lyricsDraft,
                            spacing: spacingDraft,
                          })
                        }
                      >
                        Add song/track
                      </Button>
                    )
                  }
                >
                  <Stack vertical>
                    {customTracks.map((track) => (
                      <Stack.Item key={track.title}>
                        <Stack align="center">
                          <Stack.Item grow basis={0}>
                            <Button
                              fluid
                              compact
                              selected={track.selected}
                              onClick={() =>
                                act('select', {
                                  title: track.title,
                                })
                              }
                            >
                              {track.title}
                            </Button>
                          </Stack.Item>
                          <Stack.Item width="104px">
                            <Box color="label" textAlign="right">
                              {track.duration_seconds}s ({track.duration_label}),{' '}
                              {track.phrase_count}
                            </Box>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    ))}
                    {!customTracks.length && (
                      <Stack.Item>
                        <Box color="label">No custom tracks.</Box>
                      </Stack.Item>
                    )}
                  </Stack>
                </Section>
              </Stack.Item>

              <Stack.Item grow basis={0}>
                <BardEditorPanel
                  selected={selected}
                  activeTab={activeTab}
                  setActiveTab={setActiveTab}
                  canEditSelected={canEditSelected}
                  lyricsDraft={lyricsDraft}
                  updateLyrics={updateLyrics}
                  spacingDraft={spacingDraft}
                  setSpacingDraft={setSpacingDraft}
                  act={act}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item height="78px">
            <Section
              fill
              title="JSON"
              buttons={
                <>
                  <Button
                    icon="file-export"
                    disabled={!canEditSelected}
                    onClick={() => setJsonDraft(selected?.json || '')}
                  >
                    Export
                  </Button>
                  <Button
                    icon="file-import"
                    disabled={!canEditSelected}
                    onClick={() =>
                      act('import_json', {
                        json: jsonDraft,
                      })
                    }
                  >
                    Import
                  </Button>
                </>
              }
            >
              <TextArea
                height="32px"
                fluid
                value={jsonDraft}
                onChange={setJsonDraft}
                placeholder="Export prepares this string. Import applies the string to the selected track."
                dontUseTabForIndent
              />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
