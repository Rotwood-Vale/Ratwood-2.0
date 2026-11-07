import { useEffect, useRef, useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Modal,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';

import { CardBackgroundControl } from './CardBackgroundControl';
import { guidelineScope, ImageGuidelines } from './ImageGuidelines';
import { useCopyUrl } from './LinkRow';
import { type Data, HEADSHOT_SLOT, useGalleryBackend } from './shared';
import { Thumbnail } from './Thumbnail';

const extensionList = (extensions: string[]) => {
  const names = extensions.map((extension) => extension.toUpperCase());
  const last = names.pop();
  return names.length ? `${names.join(', ')} or ${last}.` : `${last}.`;
};

export const UrlEditor = (props: {
  editor: NonNullable<Data['url_editor']>;
}) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { editor } = props;
  const busy = isBusy(editor.form);
  const isHeadshot = editor.image === HEADSHOT_SLOT;
  const isArt = editor.main_background !== undefined;
  const [mainBackground, setMainBackground] = useState(
    editor.main_background ?? 'transparent',
  );
  const [alternateBackground, setAlternateBackground] = useState(
    editor.alternate_background ?? 'transparent',
  );
  const [main, setMain] = useState(editor.main ?? '');
  const [alternate, setAlternate] = useState(editor.alternate ?? '');
  const [activeAlternate, setActiveAlternate] = useState(
    !!editor.active_alternate,
  );
  const [showAlternate, setShowAlternate] = useState(!!editor.alternate);
  const currentValue = activeAlternate ? alternate : main;
  const copier = useCopyUrl();
  const alternateTooltip = 'A backup link you can swap to.';
  const dialogRef = useRef<HTMLDivElement>(null);
  const mainRef = useRef<HTMLInputElement>(null);
  const alternateRef = useRef<HTMLInputElement>(null);
  // Read while rendering, as the window behind goes inert and drops its focus before effects run
  const previousFocus = useRef(document.activeElement as HTMLElement | null);
  useEffect(() => {
    (editor.active_alternate ? alternateRef : mainRef).current?.focus();
    return () => previousFocus.current?.focus();
  }, []);
  useEffect(() => {
    if (showAlternate && !editor.alternate) {
      (activeAlternate ? mainRef : alternateRef).current?.focus();
    }
  }, [showAlternate]);
  // Apply disables the inputs and takes focus with it. Watching busy too catches the same error twice
  useEffect(() => {
    if (editor.error && !busy) {
      (activeAlternate ? alternateRef : mainRef).current?.focus();
    }
  }, [editor.error, busy]);
  const cancel = () => act('cancel_urls', { editor_id: editor.id });
  return (
    <Modal className="CharacterGallery__urlModal" onEscape={cancel}>
      <div
        ref={dialogRef}
        role="dialog"
        aria-modal="true"
        aria-label={isArt ? `Edit ${editor.label}` : `${editor.label} URLs`}
        onKeyDown={(event) => {
          if (event.key !== 'Tab') {
            return;
          }
          const focusable = [
            ...(dialogRef.current?.querySelectorAll<HTMLElement>(
              'input, [tabindex="0"], summary, details[open] a[href]',
            ) ?? []),
          ];
          const first = focusable[0];
          const last = focusable[focusable.length - 1];
          if (event.shiftKey && document.activeElement === first) {
            event.preventDefault();
            last?.focus();
          } else if (!event.shiftKey && document.activeElement === last) {
            event.preventDefault();
            first?.focus();
          }
        }}
      >
        <Section title={isArt ? editor.label : `${editor.label} URLs`}>
          <ImageGuidelines scope={guidelineScope(editor.image)} />
          {/* Maps [activeAlternate, !activeAlternate] rather than [false, true], so row 0, labelled Current Image URL,
          always edits whichever of main and alternate is in use */}
          {[activeAlternate, !activeAlternate].map((isAlternate, index) => {
            if (index === 1 && !showAlternate) {
              return null;
            }
            const value = isAlternate ? alternate : main;
            const setValue = isAlternate ? setAlternate : setMain;
            const inputRef = isAlternate ? alternateRef : mainRef;
            const saved = isAlternate ? editor.alternate : editor.main;
            const background = isAlternate
              ? alternateBackground
              : mainBackground;
            const setBackground = isAlternate
              ? setAlternateBackground
              : setMainBackground;
            const label =
              index === 0 ? 'Current Image URL' : 'Alternate Image URL';
            return (
              <div
                key={String(isAlternate)}
                className="CharacterGallery__sourceRow"
              >
                <Thumbnail
                  label={label}
                  url={value === saved ? saved : null}
                  background={isArt ? background : undefined}
                />
                <div>
                  <Box bold mb={0.5}>
                    {index === 0 ? (
                      'Current Image'
                    ) : (
                      <Tooltip content={alternateTooltip}>
                        <span tabIndex={0}>
                          Alternate Image (Optional){' '}
                          <Icon name="circle-question" />
                        </span>
                      </Tooltip>
                    )}
                  </Box>
                  <input
                    ref={inputRef}
                    className="Input CharacterGallery__urlInput"
                    aria-label={label}
                    maxLength={data.link_max_length}
                    disabled={busy}
                    value={value}
                    onChange={(event) => {
                      setValue(event.target.value);
                    }}
                  />
                  <Box mt={0.5}>
                    <Button
                      compact
                      icon="copy"
                      disabled={!value.trim()}
                      onClick={() =>
                        copier.copy(value, `${label} copied.`, () => {
                          inputRef.current?.focus();
                          inputRef.current?.select();
                        })
                      }
                    >
                      Copy
                    </Button>
                  </Box>
                  {isArt && (
                    <Box inline mt={0.5}>
                      <CardBackgroundControl
                        value={background}
                        disabled={busy}
                        onSelected={(material) => {
                          setBackground(material);
                          // A menu pick leaves focus on the page body, out of reach of the modal's Escape
                          inputRef.current?.focus();
                        }}
                      />
                    </Box>
                  )}
                </div>
              </div>
            );
          })}
          <Box mb={1}>
            {showAlternate ? (
              <Button
                compact
                icon="exchange-alt"
                disabled={busy || !main.trim() || !alternate.trim()}
                onClick={() => {
                  setActiveAlternate(!activeAlternate);
                  copier.clear();
                }}
              >
                Swap Images
              </Button>
            ) : (
              <Button
                compact
                icon="plus"
                tooltip={alternateTooltip}
                disabled={busy}
                onClick={() => setShowAlternate(true)}
              >
                Add Alternate Image
              </Button>
            )}
          </Box>
          <Box color="label" mb={1}>
            Direct HTTPS links from {data.link_hosts}.{' '}
            {extensionList(editor.extensions)}
          </Box>
          {isHeadshot && (
            <Box color="label" mb={1}>
              Each link keeps its own framing.
            </Box>
          )}
          {!!editor.error && (
            <div role="alert">
              <Box color="bad" mb={1}>
                {editor.error}
              </Box>
            </div>
          )}
          <div role="status" aria-live="polite">
            {copier.message}
            {busy && (
              <Box color="label" mb={0.5}>
                <Icon name="spinner" spin mr={0.5} />
                Updating images…
              </Box>
            )}
          </div>
          <Stack justify="flex-end">
            <Button compact onClick={cancel}>
              Cancel
            </Button>
            <Button
              compact
              disabled={busy || !currentValue.trim()}
              onClick={() =>
                act('save_urls', {
                  editor_id: editor.id,
                  main,
                  alternate,
                  active_alternate: activeAlternate,
                  ...(isArt && {
                    main_background: mainBackground,
                    alternate_background: alternateBackground,
                  }),
                })
              }
            >
              Apply
            </Button>
          </Stack>
        </Section>
      </div>
    </Modal>
  );
};
