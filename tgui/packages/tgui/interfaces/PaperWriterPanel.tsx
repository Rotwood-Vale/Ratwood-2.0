import React, { useEffect, useRef, useState } from 'react';
import {
  Box,
  Button,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  draft: string;
  preview_html: string;
  font: string;
  standard_font: string;
  fonts: string[];
  maxlen: number;
};

export const PaperWriterPanel = () => {
  const { act, data } = useBackend<Data>();
  const {
    draft: initialDraft,
    preview_html,
    font: backendFont,
    standard_font,
    fonts,
    maxlen,
  } = data;

  const [draft, setDraft] = useState(initialDraft || '');
  const [font, setFont] = useState(backendFont || 'default');
  const [previewDirty, setPreviewDirty] = useState(false);
  const draftInputRef = useRef<HTMLTextAreaElement | null>(null);
  // Tracks whether the textarea is focused so backend echoes don't override live input.
  const isFocused = useRef(false);
  // Holds the pending debounce timer so it can be cancelled explicitly.
  const debounceHandle = useRef<ReturnType<typeof setTimeout> | null>(null);
  // Monotonic client action sequence to let backend ignore stale out-of-order actions.
  const actionSeq = useRef(0);

  const nextActionSeq = () => {
    actionSeq.current += 1;
    return actionSeq.current;
  };

  useEffect(() => {
    // Only sync from server if the user is not actively typing.
    if (!isFocused.current) {
      setDraft(initialDraft || '');
    }
  }, [initialDraft]);

  useEffect(() => {
    setFont(backendFont || 'default');
  }, [backendFont]);

  const pushDraft = (nextDraft: string, nextFont: string = font) => {
    setDraft(nextDraft);
    if (nextFont !== font) {
      setFont(nextFont);
    }
    setPreviewDirty(true);
  };

  const pushFont = (nextFont: string) => {
    setFont(nextFont);
    setPreviewDirty(true);
  };

  const updatePreview = () => {
    act('update_draft', { draft, font, seq: nextActionSeq() });
    setPreviewDirty(false);
  };

  useEffect(() => {
    if (!previewDirty) {
      return;
    }
    debounceHandle.current = setTimeout(() => {
      act('update_draft', { draft, font, seq: nextActionSeq() });
      setPreviewDirty(false);
      debounceHandle.current = null;
    }, 450);
    return () => {
      if (debounceHandle.current !== null) {
        clearTimeout(debounceHandle.current);
        debounceHandle.current = null;
      }
    };
  }, [previewDirty, draft, font]);

  const insertToken = (startToken: string, endToken = '') => {
    const input = draftInputRef.current;
    if (!input) {
      pushDraft(`${draft}${startToken}${endToken}`);
      return;
    }

    const start = input.selectionStart ?? draft.length;
    const end = input.selectionEnd ?? draft.length;
    const selectedText = draft.slice(start, end);
    const nextDraft =
      draft.slice(0, start) +
      startToken +
      selectedText +
      endToken +
      draft.slice(end);

    pushDraft(nextDraft);

    requestAnimationFrame(() => {
      input.focus();
      const selectionStart = start + startToken.length;
      const selectionEnd = selectionStart + selectedText.length;
      if (selectedText.length > 0) {
        input.setSelectionRange(selectionStart, selectionEnd);
      } else {
        input.setSelectionRange(selectionStart, selectionStart);
      }
    });
  };

  const insertColorBlock = (hexValue: string) => {
    insertToken(`-=${hexValue}`, '=-');
  };

  const remaining = Math.max(0, maxlen - draft.length);

  return (
    <Window width={760} height={680} title="Letter Editor">
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Input">
              <Stack mb={1} wrap>
                <Stack.Item>
                  <Button onClick={() => insertToken('**', '**')}>Bold</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => insertToken('*', '*')}>Italics</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => insertToken('# ')}>Header</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => insertToken('((', '))')}>Small</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => insertToken('\n---\n')}>Rule</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => insertToken('\n* item')}>Bullet List</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => insertToken('\n1. item')}>Numbered List</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => insertToken('%f')}>Field</Button>
                </Stack.Item>
              </Stack>

              <Stack mb={1} wrap align="center">
                <Stack.Item>
                  <Box color="label">Color:</Box>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => insertColorBlock('862F20')}>Red Ink</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => insertColorBlock('14103F')}>Blue Ink</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => insertColorBlock('1A3A1A')}>Green</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => insertColorBlock('8B6914')}>Gold</Button>
                </Stack.Item>
              </Stack>

              <Box mb={1}>
                <label>
                  Font:{' '}
                  <select
                    value={font}
                    onChange={(event) =>
                      pushFont((event.target as HTMLSelectElement).value)
                    }
                  >
                    {(fonts || []).map((fontName) => (
                      <option key={fontName} value={fontName}>
                        {fontName === 'default'
                          ? `Standard (${standard_font || 'legacy pen'})`
                          : fontName}
                      </option>
                    ))}
                  </select>
                </label>
              </Box>

              <Box mt={1} mb={1} color={remaining < 50 ? 'bad' : 'label'}>
                Draft characters: {draft.length}/{maxlen}
              </Box>
              <Box mb={1}>
                <Stack wrap>
                  <Stack.Item>
                    <Button
                      icon="sync"
                      color={previewDirty ? 'average' : undefined}
                      onClick={updatePreview}>
                      Update Preview
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="question-circle"
                      onClick={() => act('help')}>
                      Help
                    </Button>
                  </Stack.Item>
                </Stack>
              </Box>
              <textarea
                ref={draftInputRef}
                style={{
                  height: '220px',
                  width: '100%',
                  resize: 'vertical',
                }}
                value={draft}
                onChange={(event) => pushDraft(event.target.value)}
                onFocus={() => { isFocused.current = true; }}
                onBlur={() => { isFocused.current = false; }}
                placeholder="Write your letter..."
              />
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Preview">
              <Box
                style={{
                  background: '#fdf6e3',
                  border: '1px solid #b8a27d',
                  minHeight: '250px',
                  padding: '10px',
                  fontFamily: 'serif',
                }}
                dangerouslySetInnerHTML={{ __html: preview_html || '' }}
              />
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Stack>
              <Stack.Item>
                <Button
                  color="good"
                  icon="signature"
                  onClick={() => {
                    // Cancel any pending debounce and send draft+sign as one atomic action
                    // to avoid the update_draft / sign race under server time dilation.
                    if (debounceHandle.current !== null) {
                      clearTimeout(debounceHandle.current);
                      debounceHandle.current = null;
                    }
                    setPreviewDirty(false);
                    act('sign', { draft, font, seq: nextActionSeq() });
                  }}>
                  Done
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  color="average"
                  icon="eraser"
                  onClick={() => {
                    if (debounceHandle.current !== null) {
                      clearTimeout(debounceHandle.current);
                      debounceHandle.current = null;
                    }
                    setDraft('');
                    setPreviewDirty(false);
                    act('clear', { seq: nextActionSeq() });
                  }}>
                  Clear
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  color="bad"
                  icon="times"
                  onClick={() => act('close')}>
                  Close
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
