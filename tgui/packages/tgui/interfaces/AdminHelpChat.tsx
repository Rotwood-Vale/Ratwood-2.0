import { useEffect, useRef, useState } from 'react';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Message = {
  timestamp: string;
  author: string;
  message: string;
  is_admin: BooleanLike;
  embed_type?: string;
  embed_url?: string;
};

type Data = {
  ticket_id: number;
  ticket_name: string;
  ticket_state: string;
  messages: Message[];
  can_send: BooleanLike;
  initiator_ckey: string;
  initiator_name: string;
  opened_at: number;
  closed_at: number | null;
  is_admin: BooleanLike;
};

export const AdminHelpChat = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    ticket_id,
    ticket_name,
    ticket_state,
    messages,
    can_send,
    initiator_name,
    initiator_ckey,
    is_admin,
  } = data;
  const [inputText, setInputText] = useState('');
  const [inputRows, setInputRows] = useState(1);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const chatTextareaRef = useRef<HTMLTextAreaElement>(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages.length]);

  const handleSend = () => {
    if (inputText.trim()) {
      act('send_message', { message: inputText });
      setInputText('');
      setInputRows(1);
      if (chatTextareaRef.current) {
        chatTextareaRef.current.style.height = 'auto';
      }
    }
  };

  const getStatusColor = () => {
    switch (ticket_state) {
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

  return (
    <Window
      width={600}
      height={700}
      title={`Admin Help - Ticket #${ticket_id}`}
    >
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <Section>
              <Stack>
                <Stack.Item grow>
                  <Box bold fontSize="1.1em">
                    {ticket_name}
                  </Box>
                  {!is_admin && (
                    <Box color="label" fontSize="0.9em" mt={0.5}>
                      Your conversation with the admin team
                    </Box>
                  )}
                </Stack.Item>
                <Stack.Item>
                  <Box color={getStatusColor()} bold>
                    {ticket_state}
                  </Box>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section fill scrollable title="Messages">
              <Stack vertical>
                {messages.length === 0 ? (
                  <Stack.Item>
                    <Box color="label" italic p={2} textAlign="center">
                      {is_admin
                        ? 'No messages yet. Send a message to start the conversation.'
                        : 'Your message has been sent to the admin team. Please wait for a response.'}
                    </Box>
                  </Stack.Item>
                ) : (
                  messages.map((msg, index) => (
                    <Stack.Item key={index}>
                      <Box
                        backgroundColor={
                          msg.is_admin
                            ? 'rgba(0, 100, 200, 0.15)'
                            : 'rgba(100, 100, 100, 0.2)'
                        }
                        p={1}
                        mb={0.5}
                        style={{
                          borderLeft: msg.is_admin
                            ? '3px solid #4a90e2'
                            : '3px solid #888',
                        }}
                      >
                        <Stack>
                          <Stack.Item>
                            <Box
                              bold
                              color={msg.is_admin ? 'blue' : 'white'}
                              fontSize="1em"
                            >
                              {msg.author}
                            </Box>
                          </Stack.Item>
                          <Stack.Item grow />
                          <Stack.Item>
                            <Box fontSize="0.85em" color="label">
                              {msg.timestamp.substring(11, 19)}
                            </Box>
                          </Stack.Item>
                        </Stack>
                        {msg.embed_type === 'image' && msg.embed_url ? (
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
                        ) : msg.embed_type === 'video' && msg.embed_url ? (
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
                          <Box mt={0.5} style={{ wordWrap: 'break-word', whiteSpace: 'pre-wrap' }}>
                            {msg.message}
                          </Box>
                        )}
                      </Box>
                    </Stack.Item>
                  ))
                )}
                <div ref={messagesEndRef} />
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section>
              <Stack>
                <Stack.Item grow>
                  <textarea
                    ref={chatTextareaRef}
                    className="Input TextArea Input--fluid"
                    placeholder={
                      can_send
                        ? 'Type your message... (Shift+Enter for newline)'
                        : 'This ticket is closed'
                    }
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
                    disabled={!can_send}
                    maxLength={1024}
                    style={{ resize: 'none', overflow: 'hidden' }}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="paper-plane"
                    color="good"
                    disabled={!can_send || !inputText.trim()}
                    onClick={handleSend}
                  >
                    Send
                  </Button>
                </Stack.Item>
              </Stack>
              {!can_send && (
                <Box color="bad" mt={0.5} fontSize="0.9em">
                  This ticket is {ticket_state.toLowerCase()}. Use the adminhelp
                  verb to open a new ticket if needed.
                </Box>
              )}
              {can_send && !is_admin && (
                <Box color="label" mt={0.5} fontSize="0.85em" italic>
                  Please be patient. An admin will respond as soon as possible.
                </Box>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
