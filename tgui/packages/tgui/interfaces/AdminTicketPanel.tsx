import { useEffect, useRef, useState } from 'react';
import {
  Box,
  Button,
  Input,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Message = {
  timestamp: string;
  author: string;
  message: string;
  is_admin: BooleanLike;
  full_text: string;
  embed_type?: string;
  embed_url?: string;
};

type Ticket = {
  id: number;
  name: string;
  state: string;
  initiator_ckey: string;
  initiator_name: string;
  opened_at: number;
  closed_at: number | null;
  initiator_connected: BooleanLike;
};

type Data = {
  active_tickets: Ticket[];
  closed_tickets: Ticket[];
  resolved_tickets: Ticket[];
  admin_hide_charname: BooleanLike;
  selected_ticket: {
    ticket_id: number;
    ticket_name: string;
    ticket_state: string;
    initiator_ckey: string;
    initiator_name: string;
    opened_at: number;
    closed_at: number | null;
    messages: Message[];
    can_send: BooleanLike;
    is_admin: BooleanLike;
    initiator_connected: BooleanLike;
  } | null;
};

export const AdminTicketPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    active_tickets,
    closed_tickets,
    resolved_tickets,
    selected_ticket,
    admin_hide_charname,
  } = data;

  const [tabIndex, setTabIndex] = useState(0);
  const [inputText, setInputText] = useState('');
  const [showEmbedInput, setShowEmbedInput] = useState<
    'image' | 'video' | null
  >(null);
  const [embedUrl, setEmbedUrl] = useState('');
  const [inputRows, setInputRows] = useState(1);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const chatTextareaRef = useRef<HTMLTextAreaElement>(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [selected_ticket?.messages.length, selected_ticket?.ticket_id]);

  const handleSend = () => {
    if (inputText.trim() && selected_ticket) {
      act('send_message', {
        ticket_id: selected_ticket.ticket_id,
        message: inputText,
      });
      setInputText('');
      setInputRows(1);
      if (chatTextareaRef.current) {
        chatTextareaRef.current.style.height = 'auto';
      }
    }
  };

  const handleSelectTicket = (ticketId: number) => {
    act('select_ticket', { ticket_id: ticketId });
  };

  const handleEmbedSend = () => {
    if (embedUrl.trim() && selected_ticket && showEmbedInput) {
      act('embed_media', {
        ticket_id: selected_ticket.ticket_id,
        url: embedUrl.trim(),
        embed_type: showEmbedInput,
      });
      setEmbedUrl('');
      setShowEmbedInput(null);
    }
  };

  const getTickets = () => {
    switch (tabIndex) {
      case 0:
        return active_tickets;
      case 1:
        return closed_tickets;
      case 2:
        return resolved_tickets;
      default:
        return [];
    }
  };

  const getStatusColor = (state: string) => {
    switch (state) {
      case 'ACTIVE':
        return 'good';
      case 'CLOSED':
        return 'bad';
      case 'RESOLVED':
        return 'average';
      default:
        return 'default';
    }
  };

  const tickets = getTickets();

  return (
    <Window width={1200} height={800} title={`Admin Ticket Panel (${active_tickets.length} active)`}>
      <Window.Content>
        <Stack fill>
          {/* Left Panel - Ticket List */}
          <Stack.Item width="350px">
            <Section fill scrollable title="Tickets">
              <Tabs>
                <Tabs.Tab
                  selected={tabIndex === 0}
                  onClick={() => setTabIndex(0)}
                >
                  Active ({active_tickets.length})
                </Tabs.Tab>
                <Tabs.Tab
                  selected={tabIndex === 1}
                  onClick={() => setTabIndex(1)}
                >
                  Closed ({closed_tickets.length})
                </Tabs.Tab>
                <Tabs.Tab
                  selected={tabIndex === 2}
                  onClick={() => setTabIndex(2)}
                >
                  Resolved ({resolved_tickets.length})
                </Tabs.Tab>
              </Tabs>
              <Box mt={1}>
                {tickets.length === 0 ? (
                  <Box color="label" italic>
                    No tickets in this category
                  </Box>
                ) : (
                  tickets.map((ticket) => (
                    <Box
                      key={ticket.id}
                      className="candystripe"
                      p={1}
                      mb={0.5}
                      backgroundColor={
                        selected_ticket?.ticket_id === ticket.id
                          ? 'rgba(0, 100, 200, 0.3)'
                          : undefined
                      }
                      style={{ cursor: 'pointer' }}
                      onClick={() => handleSelectTicket(ticket.id)}
                    >
                      <Stack>
                        <Stack.Item grow>
                          <Box bold>
                            #{ticket.id} - {ticket.initiator_name}
                          </Box>
                          <Box fontSize="0.9em" color="label">
                            {ticket.name.substring(0, 50)}
                            {ticket.name.length > 50 ? '...' : ''}
                          </Box>
                        </Stack.Item>
                        <Stack.Item>
                          <Box color={getStatusColor(ticket.state)}>
                            {ticket.state}
                          </Box>
                          {!ticket.initiator_connected && (
                            <Box color="bad" fontSize="0.8em">
                              [DC]
                            </Box>
                          )}
                        </Stack.Item>
                      </Stack>
                    </Box>
                  ))
                )}
              </Box>
            </Section>
          </Stack.Item>

          {/* Right Panel - Ticket Details & Chat */}
          <Stack.Item grow>
            <Stack vertical fill>

              {selected_ticket ? (
                <>
                  {/* Action Buttons */}
                  <Stack.Item>
                    <Section>
                      <Stack>
                        <Stack.Item>
                          <Box bold fontSize="1.2em">
                            Ticket #{selected_ticket.ticket_id}
                          </Box>
                          <Box color="label">{selected_ticket.ticket_name}</Box>
                        </Stack.Item>
                        <Stack.Item grow />
                      </Stack>
                      {/* Admin quick tools row */}
                      {selected_ticket.is_admin && (
                        <Stack mt={1} wrap>
                          <Stack.Item>
                            <Button
                              compact
                              tooltip="PP (Player Panel) - Open the player panel for this mob."
                              onClick={() =>
                                act('ticket_pp', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              PP
                            </Button>
                            <Button
                              compact
                              tooltip="VV (View Variables) - Open View Variables for this mob."
                              onClick={() =>
                                act('ticket_vv', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              VV
                            </Button>
                            <Button
                              compact
                              tooltip="SM (Subtle Message) - Send a subtle IC message to this player's mind."
                              onClick={() =>
                                act('ticket_sm', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              SM
                            </Button>
                            <Button
                              compact
                              tooltip="FLW (Follow) - Ghost-follow this mob as an observer."
                              onClick={() =>
                                act('ticket_flw', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              FLW
                            </Button>
                            <Button
                              compact
                              tooltip="TP (Traitor Panel) - Open the traitor panel for this mob."
                              onClick={() =>
                                act('ticket_tp', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              TP
                            </Button>
                            <Button
                              compact
                              color="bad"
                              tooltip="Smite - Divine Retribution! Use very rarely."
                              onClick={() =>
                                act('ticket_smite', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              Smite
                            </Button>
                            <Button
                              compact
                              tooltip="Cake - Give the player a (random) slice of cake."
                              onClick={() =>
                                act('ticket_cake', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              Cake
                            </Button>
                            <Button
                              compact
                              color="good"
                              tooltip="Aheal - Quickly revive and fully heal the player."
                              onClick={() =>
                                act('ticket_aheal', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              Aheal
                            </Button>
                            <Button
                              compact
                              tooltip="PQ (Check Player Quality) - Open the PQ panel for this player."
                              onClick={() =>
                                act('ticket_pq', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              PQ
                            </Button>
                            <Button
                              compact
                              tooltip="GM (Get Mob) - Teleport this mob to you."
                              onClick={() =>
                                act('ticket_gm', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              GM
                            </Button>
                            <Button
                              compact
                              tooltip="JM (Jump Mob) - Jump to this mob's location."
                              onClick={() =>
                                act('ticket_jm', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              JM
                            </Button>
                            <Button
                              compact
                              tooltip="ND (Narrate Directly) - Send a direct narrative message to this player."
                              onClick={() =>
                                act('ticket_nd', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              ND
                            </Button>
                            <Button
                              compact
                              tooltip="AP (AtomProc) - Call an arbitrary proc on this mob. Use with care."
                              onClick={() =>
                                act('ticket_ap', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              AP
                            </Button>
                          </Stack.Item>
                        </Stack>
                      )}
                      <Stack mt={1}>
                        <Stack.Item>
                          <Button
                            icon="exclamation-triangle"
                            color="bad"
                            disabled={selected_ticket.ticket_state !== 'ACTIVE'}
                            onClick={() =>
                              act('reject', {
                                ticket_id: selected_ticket.ticket_id,
                              })
                            }
                          >
                            Reject
                          </Button>
                          <Button
                            icon="gamepad"
                            color="average"
                            disabled={selected_ticket.ticket_state !== 'ACTIVE'}
                            onClick={() =>
                              act('ic_issue', {
                                ticket_id: selected_ticket.ticket_id,
                              })
                            }
                          >
                            IC Issue
                          </Button>
                          <Button
                            icon="times"
                            color="bad"
                            disabled={selected_ticket.ticket_state !== 'ACTIVE'}
                            onClick={() =>
                              act('close', {
                                ticket_id: selected_ticket.ticket_id,
                              })
                            }
                          >
                            Close
                          </Button>
                          <Button
                            icon="check"
                            color="good"
                            disabled={selected_ticket.ticket_state !== 'ACTIVE'}
                            onClick={() =>
                              act('resolve', {
                                ticket_id: selected_ticket.ticket_id,
                              })
                            }
                          >
                            Resolve
                          </Button>
                          <Button
                            icon="hand-paper"
                            color="average"
                            disabled={selected_ticket.ticket_state !== 'ACTIVE'}
                            onClick={() =>
                              act('handle', {
                                ticket_id: selected_ticket.ticket_id,
                              })
                            }
                          >
                            Handle
                          </Button>
                          {selected_ticket.ticket_state !== 'ACTIVE' && (
                            <Button
                              icon="redo"
                              color="good"
                              onClick={() =>
                                act('reopen', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              Reopen
                            </Button>
                          )}
                          <Button
                            icon="edit"
                            onClick={() =>
                              act('retitle', {
                                ticket_id: selected_ticket.ticket_id,
                              })
                            }
                          >
                            Retitle
                          </Button>
                        </Stack.Item>
                      </Stack>
                    </Section>
                  </Stack.Item>

                  {/* Conversation view + input */}
                  <>
                      <Stack.Item grow>
                        <Section fill scrollable title="Conversation">
                          <Stack vertical>
                            {selected_ticket.messages.length === 0 ? (
                              <Stack.Item>
                                <Box color="label" italic>
                                  No messages yet
                                </Box>
                              </Stack.Item>
                            ) : (
                              selected_ticket.messages.map((msg, index) => (
                                <Stack.Item key={index}>
                                  <Box
                                    backgroundColor={
                                      msg.is_admin
                                        ? 'rgba(0, 100, 200, 0.12)'
                                        : 'rgba(40, 40, 40, 0.5)'
                                    }
                                    p={1}
                                    mb={0.6}
                                    style={{
                                      borderRadius: '4px',
                                      borderLeft: msg.is_admin
                                        ? '3px solid #4a90e2'
                                        : '3px solid #888',
                                      wordBreak: 'break-word',
                                      whiteSpace: 'pre-wrap',
                                    }}
                                  >
                                    <Stack>
                                      <Stack.Item>
                                        <Box
                                          bold
                                          color={msg.is_admin ? 'blue' : 'white'}
                                        >
                                          {msg.author}
                                        </Box>
                                      </Stack.Item>
                                      <Stack.Item grow />
                                      <Stack.Item>
                                        <Box fontSize="0.9em" color="label">
                                          {msg.timestamp}
                                        </Box>
                                      </Stack.Item>
                                    </Stack>
                                    {msg.embed_type === 'image' &&
                                    msg.embed_url ? (
                                      <img
                                        src={msg.embed_url}
                                        alt="Embedded image"
                                        style={{
                                          maxWidth: '100%',
                                          maxHeight: '400px',
                                          borderRadius: '4px',
                                          marginTop: '4px',
                                          display: 'block',
                                        }}
                                      />
                                    ) : msg.embed_type === 'video' &&
                                      msg.embed_url ? (
                                      <video
                                        src={msg.embed_url}
                                        controls
                                        style={{
                                          maxWidth: '100%',
                                          maxHeight: '300px',
                                          borderRadius: '4px',
                                          marginTop: '4px',
                                          display: 'block',
                                        }}
                                      />
                                    ) : (
                                      <Box mt={0.4}>{msg.message}</Box>
                                    )}
                                  </Box>
                                </Stack.Item>
                              ))
                            )}
                            <div ref={messagesEndRef} />
                          </Stack>
                        </Section>
                      </Stack.Item>

                      {selected_ticket.is_admin && (
                        <Stack.Item>
                          <Section>
                            <Stack>
                              <Stack.Item grow>
                                <textarea
                                  ref={chatTextareaRef}
                                  className="Input TextArea Input--fluid"
                                  placeholder="Type your response... (Shift+Enter for newline)"
                                  value={inputText}
                                  rows={inputRows}
                                  onChange={(e) => {
                                    const val = e.target.value;
                                    setInputText(val);
                                    e.target.style.height = 'auto';
                                    e.target.style.height = `${Math.min(e.target.scrollHeight, 144)}px`;
                                    const lines = (val.match(/\n/g) || []).length + 1;
                                    setInputRows(Math.min(Math.max(lines, 1), 6));
                                  }}
                                  onKeyDown={(e) => {
                                    if (e.key === 'Enter' && !e.shiftKey) {
                                      e.preventDefault();
                                      handleSend();
                                    }
                                  }}
                                  disabled={!selected_ticket.can_send}
                                  maxLength={1024}
                                  style={{ resize: 'none', overflow: 'hidden' }}
                                />
                              </Stack.Item>
                              <Stack.Item>
                                <Button
                                  icon="paper-plane"
                                  color="good"
                                  disabled={
                                    !selected_ticket.can_send ||
                                    !inputText.trim()
                                  }
                                  onClick={handleSend}
                                >
                                  Send
                                </Button>
                                <Button
                                  icon="user-secret"
                                  tooltip={
                                    admin_hide_charname
                                      ? 'Character name hidden — click to show it'
                                      : 'Character name visible — click to hide it'
                                  }
                                  selected={!!admin_hide_charname}
                                  onClick={() => act('toggle_charname')}
                                >
                                  {admin_hide_charname ? 'Anon' : 'Named'}
                                </Button>
                                <Button
                                  icon="image"
                                  color="blue"
                                  tooltip="Embed an image URL into the ticket (https only)"
                                  disabled={!selected_ticket.can_send}
                                  selected={showEmbedInput === 'image'}
                                  onClick={() =>
                                    setShowEmbedInput(
                                      showEmbedInput === 'image'
                                        ? null
                                        : 'image',
                                    )
                                  }
                                >
                                  Img
                                </Button>
                                <Button
                                  icon="film"
                                  color="purple"
                                  tooltip="Embed a video URL into the ticket (https only)"
                                  disabled={!selected_ticket.can_send}
                                  selected={showEmbedInput === 'video'}
                                  onClick={() =>
                                    setShowEmbedInput(
                                      showEmbedInput === 'video'
                                        ? null
                                        : 'video',
                                    )
                                  }
                                >
                                  Vid
                                </Button>
                              </Stack.Item>
                            </Stack>
                            {showEmbedInput && (
                              <Box mt={0.5}>
                                <Stack>
                                  <Stack.Item grow>
                                    <Input
                                      fluid
                                      placeholder={`Paste ${showEmbedInput} URL (must start with https://)...`}
                                      value={embedUrl}
                                      onChange={setEmbedUrl}
                                      onEnter={handleEmbedSend}
                                    />
                                  </Stack.Item>
                                  <Stack.Item>
                                    <Button
                                      color="good"
                                      disabled={
                                        !embedUrl
                                          .trim()
                                          .startsWith('https://')
                                      }
                                      onClick={handleEmbedSend}
                                    >
                                      Embed {showEmbedInput}
                                    </Button>
                                    <Button
                                      onClick={() => {
                                        setShowEmbedInput(null);
                                        setEmbedUrl('');
                                      }}
                                    >
                                      Cancel
                                    </Button>
                                  </Stack.Item>
                                </Stack>
                                <Box
                                  mt={0.5}
                                  p={0.75}
                                  fontSize="0.85em"
                                  color="label"
                                  style={{
                                    borderRadius: '4px',
                                    border: '1px solid rgba(255,255,255,0.1)',
                                    background: 'rgba(0,0,0,0.3)',
                                  }}
                                >
                                  <Box bold color="white" mb={0.3}>
                                    How to embed media
                                  </Box>
                                  <Box>
                                    1. Find a{' '}
                                    {showEmbedInput === 'image'
                                      ? 'direct image link'
                                      : 'direct video link'}{' '}
                                    — right-click the{' '}
                                    {showEmbedInput === 'image'
                                      ? 'image'
                                      : 'video'}{' '}
                                    on a website and choose{' '}
                                    <Box
                                      as="span"
                                      bold
                                      color="white"
                                    >
                                      &quot;Copy image address&quot;
                                    </Box>
                                    .
                                  </Box>
                                  <Box mt={0.3}>
                                    2. The URL must start with{' '}
                                    <Box
                                      as="span"
                                      bold
                                      color="good"
                                    >
                                      https://
                                    </Box>{' '}
                                    and end with the file extension (e.g.{' '}
                                    {showEmbedInput === 'image'
                                      ? '.png, .jpg, .gif, .webp'
                                      : '.mp4, .webm, .ogg'}
                                    ).
                                  </Box>
                                  <Box mt={0.3}>
                                    3. Paste the URL above and click{' '}
                                    <Box as="span" bold color="white">
                                      Embed {showEmbedInput}
                                    </Box>
                                    . Both you and the player will see it.
                                  </Box>
                                  {showEmbedInput === 'image' && (
                                    <Box mt={0.3} color="average">
                                      Tip: Imgur, Discord CDN, or direct GitHub
                                      raw links work well.
                                    </Box>
                                  )}
                                  {showEmbedInput === 'video' && (
                                    <Box mt={0.3} color="average">
                                      Tip: YouTube/Twitch clips won&apos;t work
                                      — use a direct .mp4 or .webm URL instead.
                                    </Box>
                                  )}
                                </Box>
                              </Box>
                            )}
                            {!selected_ticket.can_send && (
                              <Box
                                color="bad"
                                mt={0.5}
                                fontSize="0.9em"
                              >
                                This ticket is closed
                              </Box>
                            )}
                          </Section>
                        </Stack.Item>
                      )}
                    </>


                </>
              ) : (
                <Stack.Item grow>
                  <Section fill>
                    <Stack fill vertical align="center" justify="center">
                      <Stack.Item>
                        <Box fontSize="1.5em" color="label">
                          Select a ticket to view details
                        </Box>
                      </Stack.Item>
                    </Stack>
                  </Section>
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
