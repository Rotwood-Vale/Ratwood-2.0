import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type PetEntry = {
  ref: string;
  name: string;
  connected: boolean;
  condition: string;
  location: string;
  conscious: boolean;
  mental_state: string;
  selected: boolean;
  speech_altered: boolean;
  orgasm_denied: boolean;
  arousal_forced: boolean;
  clothing_forbidden: boolean;
  forced_love: boolean;
  received_cum_count: number | null;
  has_cursed_chastity: boolean;
  has_penis: boolean;
  has_vagina: boolean;
  chastity: {
    locked: boolean;
    front_mode: number;
    anal_open: boolean;
    spikes_on: boolean;
    is_flat: boolean;
  };
};

type Data = {
  invalid?: boolean;
  master_name: string;
  cooldown_remaining: number;
  high_pop_mode: boolean;
  selected_count: number;
  pets: PetEntry[];
};

export const CollarControl = () => {
  const { data } = useBackend<Data>();

  if (data.invalid) {
    return (
      <Window width={700} height={300}>
        <Window.Content>
          <NoticeBox danger>Collar control is no longer available.</NoticeBox>
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window width={1180} height={700}>
      <Window.Content>
        <Stack fill>
          <Stack.Item basis="28%" shrink>
            <Stack vertical>
              <Stack.Item>
                <PetSelection />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item basis="72%" grow>
            <ControlPanel />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const PetSelection = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Section
      title={`Pets (${data.selected_count} selected)`}
      style={{ maxHeight: '300px' }}
      buttons={
        <>
          <Button onClick={() => act('select_all')}>Select All</Button>
          <Button onClick={() => act('clear_selection')}>Clear</Button>
        </>
      }
    >
      <Box style={{ maxHeight: '230px', overflowY: 'auto' }}>
      <Table>
        <Table.Row header>
          <Table.Cell collapsing>Select</Table.Cell>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell collapsing>Conn</Table.Cell>
          <Table.Cell collapsing>Mental</Table.Cell>
          <Table.Cell>Flags</Table.Cell>
        </Table.Row>
        {data.pets?.map((pet) => (
          <Table.Row key={pet.ref}>
            <Table.Cell collapsing>
              <Button.Checkbox
                checked={pet.selected}
                selected={pet.selected}
                onClick={() =>
                  act('select_pet', {
                    pet_ref: pet.ref,
                    selected: pet.selected ? 0 : 1,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell>{pet.name}</Table.Cell>
            <Table.Cell collapsing>{pet.connected ? 'Yes' : 'No'}</Table.Cell>
            <Table.Cell collapsing>{pet.mental_state}</Table.Cell>
            <Table.Cell>{getPetFlags(pet)}</Table.Cell>
          </Table.Row>
        ))}
      </Table>
      </Box>
    </Section>
  );
};

const getPetFlags = (pet: PetEntry) => {
  return (
    [
      pet.speech_altered && 'Muted',
      pet.orgasm_denied && 'Denied',
      pet.arousal_forced && 'Aroused',
      pet.clothing_forbidden && 'Nudist',
      pet.forced_love && 'Love',
    ]
      .filter(Boolean)
      .join(', ') || 'None'
  );
};

const SelectedPetInfo = (props: { selectedPets: PetEntry[] }) => {
  const { selectedPets } = props;

  return (
    <Section title={`Pet Information (${selectedPets.length} selected)`}>
      {!selectedPets.length ? (
        <Box color="label">Select at least one pet to view details.</Box>
      ) : (
        <Stack vertical>
          {selectedPets.map((pet) => (
            <Stack.Item key={pet.ref}>
              <Section title={pet.name}>
                <LabeledList>
	                  <LabeledList.Item label="Condition">
	                    {pet.condition}
	                  </LabeledList.Item>
                  <LabeledList.Item label="Location">{pet.location}</LabeledList.Item>
                  <LabeledList.Item label="Mental State">
                    {pet.mental_state}
                  </LabeledList.Item>
                  <LabeledList.Item label="Pet Flags">
                    {getPetFlags(pet)}
                  </LabeledList.Item>
                  <LabeledList.Item label="Loads Received">
                    {pet.received_cum_count ?? 'N/A'}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            </Stack.Item>
          ))}
        </Stack>
      )}
    </Section>
  );
};

type ToggleVisualState = 'on' | 'off' | 'mixed' | 'unavailable';

const getToggleVisualState = (
  selectedPets: PetEntry[],
  key:
    | 'speech_altered'
    | 'orgasm_denied'
    | 'arousal_forced'
    | 'clothing_forbidden'
    | 'forced_love',
): ToggleVisualState => {
  if (!selectedPets.length) {
    return 'unavailable';
  }

  const activeCount = selectedPets.filter((pet) => pet[key]).length;
  if (activeCount === 0) {
    return 'off';
  }
  if (activeCount === selectedPets.length) {
    return 'on';
  }
  return 'mixed';
};

const toggleStateText = (
  state: ToggleVisualState,
  onText: string,
  offText: string,
) => {
  if (state === 'on') {
    return onText;
  }
  if (state === 'off') {
    return offText;
  }
  if (state === 'mixed') {
    return 'MIXED';
  }
  return 'N/A';
};

const toggleStateColor = (state: ToggleVisualState) => {
  if (state === 'on') {
    return 'pink';
  }
  if (state === 'off') {
    return 'good';
  }
  if (state === 'mixed') {
    return 'average';
  }
  return undefined;
};

const getCommandSectionTitle = (selectedPets: PetEntry[]) => {
  if (!selectedPets.length) {
    return 'Collar / Cage Commands';
  }

  const cursedCount = selectedPets.filter((pet) => pet.has_cursed_chastity).length;
  if (!cursedCount) {
    return 'Collar Commands';
  }
  if (cursedCount === selectedPets.length) {
    return 'Cage Commands';
  }
  return 'Collar / Cage Commands';
};

const CommandButton = (props: {
  label: string;
  onClick: () => void;
  disabled?: boolean;
  tooltip?: string;
  color?: string;
}) => {
  const { label, onClick, disabled, tooltip, color } = props;
  return (
    <Button
      fluid
      color={color}
      disabled={disabled}
      tooltip={tooltip}
      style={{ minHeight: '2.4rem', fontWeight: 600 }}
      onClick={onClick}
    >
      {label}
    </Button>
  );
};

const ControlPanel = () => {
  const { act, data } = useBackend<Data>();
  const [message, setMessage] = useState('');
  const [actionText, setActionText] = useState('');
  const [willText, setWillText] = useState('');

  const cooldown = data.cooldown_remaining > 0;
  const cooldownText = cooldown
    ? `${data.cooldown_remaining.toFixed(1)}s`
    : 'Ready';
  const selectedPets = data.pets?.filter((pet) => pet.selected) ?? [];
  const selectedCursedPets = selectedPets.filter((pet) => pet.has_cursed_chastity);
  const hasSelection = selectedPets.length > 0;
  const commandSectionTitle = getCommandSectionTitle(selectedPets);
  const speechState = getToggleVisualState(selectedPets, 'speech_altered');
  const clothingState = getToggleVisualState(
    selectedPets,
    'clothing_forbidden',
  );
  const loveState = getToggleVisualState(selectedPets, 'forced_love');
  const arousalState = getToggleVisualState(selectedPets, 'arousal_forced');
  const denialState = getToggleVisualState(selectedPets, 'orgasm_denied');

  const reasonForGeneralAction = cooldown
    ? `Cooling down (${cooldownText})`
    : !hasSelection
      ? 'Select at least one pet'
      : undefined;
  const reasonForCursedAction = cooldown
    ? `Cooling down (${cooldownText})`
    : !hasSelection
      ? 'Select at least one pet'
      : !selectedCursedPets.length
        ? 'No selected pets have cursed chastity'
        : selectedCursedPets.length > 1
          ? 'Select exactly one cursed pet'
        : undefined;

  const generalActionDisabled = !!reasonForGeneralAction;
  const cursedActionDisabled = !!reasonForCursedAction;

  return (
    <Section fill scrollable title="Control Panel">
      <Stack vertical>
      <Stack.Item>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Master">
              {data.master_name}
            </LabeledList.Item>
            <LabeledList.Item label="Cooldown">{cooldownText}</LabeledList.Item>
            <LabeledList.Item label="High Pop Mode">
              {data.high_pop_mode ? 'Enabled' : 'Disabled'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>

      <Stack.Item>
        <SelectedPetInfo selectedPets={selectedPets} />
      </Stack.Item>

      <Stack.Item grow>
        <Section title={commandSectionTitle} fill>
          <Stack>
            <Stack.Item basis="50%" grow>
              <Stack vertical>
                <Stack.Item>
                  <CommandButton
                    label="Listen (First Selected)"
                    disabled={generalActionDisabled}
                    tooltip={reasonForGeneralAction}
                    onClick={() => act('listen')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <CommandButton
                    label="Force Surrender"
                    disabled={generalActionDisabled}
                    tooltip={reasonForGeneralAction}
                    onClick={() => act('force_surrender')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <CommandButton
                    label={`Speech: ${toggleStateText(speechState, 'MUTED', 'NORMAL')}`}
                    color={toggleStateColor(speechState)}
                    disabled={generalActionDisabled}
                    tooltip={reasonForGeneralAction}
                    onClick={() => act('toggle_speech')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <CommandButton
                    label={`Clothing: ${toggleStateText(clothingState, 'FORBIDDEN', 'ALLOWED')}`}
                    color={toggleStateColor(clothingState)}
                    disabled={generalActionDisabled}
                    tooltip={reasonForGeneralAction}
                    onClick={() => act('toggle_clothing')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <CommandButton
                    label={`Forced Love: ${toggleStateText(loveState, 'ON', 'OFF')}`}
                    color={toggleStateColor(loveState)}
                    disabled={generalActionDisabled}
                    tooltip={reasonForGeneralAction}
                    onClick={() => act('toggle_love')}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>

            <Stack.Item basis="50%" grow>
              <Stack vertical>
                <Stack.Item>
                  <CommandButton
                    label="Shock Selected"
                    disabled={generalActionDisabled}
                    tooltip={reasonForGeneralAction}
                    color="average"
                    onClick={() => act('shock')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <CommandButton
                    label="Force Strip"
                    disabled={generalActionDisabled}
                    tooltip={reasonForGeneralAction}
                    onClick={() => act('force_strip')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <CommandButton
                    label={`Arousal: ${toggleStateText(arousalState, 'FORCED', 'NORMAL')}`}
                    color={toggleStateColor(arousalState)}
                    disabled={generalActionDisabled}
                    tooltip={reasonForGeneralAction}
                    onClick={() => act('toggle_arousal')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <CommandButton
                    label={`Orgasm Denial: ${toggleStateText(denialState, 'ON', 'OFF')}`}
                    color={toggleStateColor(denialState)}
                    disabled={generalActionDisabled}
                    tooltip={reasonForGeneralAction}
                    onClick={() => act('toggle_denial')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <CommandButton
                    label="Toggle Hallucinations"
                    color="average"
                    disabled={generalActionDisabled}
                    tooltip={reasonForGeneralAction}
                    onClick={() => act('toggle_hallucinations')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <CommandButton
                    label="Release Selected"
                    color="red"
                    disabled={generalActionDisabled}
                    tooltip={reasonForGeneralAction}
                    onClick={() => act('release_selected')}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Message">
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                value={message}
                onChange={setMessage}
                placeholder="Message to selected pets"
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                disabled={generalActionDisabled || !message}
                tooltip={
                  reasonForGeneralAction ||
                  (!message ? 'Enter a message first' : undefined)
                }
                onClick={() => {
                  act('send_message', { message });
                  setMessage('');
                }}
              >
                Send
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Force Action">
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                value={actionText}
                onChange={setActionText}
                placeholder="Speech or emote (example: *kneels)"
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                disabled={generalActionDisabled || !actionText}
                tooltip={
                  reasonForGeneralAction ||
                  (!actionText ? 'Enter action text first' : undefined)
                }
                onClick={() => {
                  act('force_action', { action_text: actionText });
                  setActionText('');
                }}
              >
                Force
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Impose Will">
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                value={willText}
                onChange={setWillText}
                placeholder="Unfiltered sensation/illusion text"
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                disabled={generalActionDisabled || !willText}
                tooltip={
                  reasonForGeneralAction ||
                  (!willText ? 'Enter imposed will text first' : undefined)
                }
                onClick={() => {
                  act('impose_will', { will_text: willText });
                  setWillText('');
                }}
              >
                Impose
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Cursed Chastity">
          <CursedChastityControls
            selectedPets={selectedPets}
            cursedActionDisabled={cursedActionDisabled}
            reasonForCursedAction={reasonForCursedAction}
          />
        </Section>
      </Stack.Item>
      </Stack>
    </Section>
  );
};

const CursedChastityControls = (props: {
  selectedPets: PetEntry[];
  cursedActionDisabled: boolean;
  reasonForCursedAction?: string;
}) => {
  const { act } = useBackend();
  const {
    selectedPets,
    cursedActionDisabled,
    reasonForCursedAction,
  } = props;

  const cursedPets = selectedPets.filter((pet) => pet.has_cursed_chastity);
  const selectedCursedPet = cursedPets.length === 1 ? cursedPets[0] : undefined;
  const showPenisControls = !!selectedCursedPet?.has_penis;
  const showVaginaControls = !!selectedCursedPet?.has_vagina;

  const currentLocked = selectedCursedPet?.chastity.locked ?? false;
  const currentAnalOpen = selectedCursedPet?.chastity.anal_open ?? false;
  const currentSpikesOn = selectedCursedPet?.chastity.spikes_on ?? false;
  const currentFlat = selectedCursedPet?.chastity.is_flat ?? false;
  const currentFrontMode = selectedCursedPet?.chastity.front_mode ?? 0;
  const penisOpen = currentFrontMode === 1 || currentFrontMode === 3;
  const vaginaOpen = currentFrontMode === 2 || currentFrontMode === 3;

  const togglePenisFrontMode = () => {
    const newMode = penisOpen
      ? showVaginaControls && vaginaOpen
        ? 2
        : 0
      : showVaginaControls && vaginaOpen
        ? 3
        : 1;
    act('chastity_set_front_mode', { front_mode: newMode });
  };

  const toggleVaginaFrontMode = () => {
    const newMode = vaginaOpen
      ? showPenisControls && penisOpen
        ? 1
        : 0
      : showPenisControls && penisOpen
        ? 3
        : 2;
    act('chastity_set_front_mode', { front_mode: newMode });
  };

  return (
    <Stack vertical>
      <Stack.Item>
        <Button
          fluid
          color={currentLocked ? 'red' : 'pink'}
          disabled={cursedActionDisabled}
          tooltip={reasonForCursedAction}
          onClick={() =>
            act('chastity_set_lock', { locked: currentLocked ? 0 : 1 })
          }
        >
          {currentLocked ? 'LOCKED' : 'UNLOCKED'}
        </Button>
      </Stack.Item>

      {showPenisControls && (
        <Stack.Item>
          <Button
            fluid
            color={penisOpen ? 'pink' : 'red'}
            disabled={cursedActionDisabled}
            tooltip={reasonForCursedAction}
            onClick={togglePenisFrontMode}
          >
            {penisOpen ? 'PENIS OPEN' : 'PENIS CLOSED'}
          </Button>
        </Stack.Item>
      )}

      {showVaginaControls && (
        <Stack.Item>
          <Button
            fluid
            color={vaginaOpen ? 'pink' : 'red'}
            disabled={cursedActionDisabled}
            tooltip={reasonForCursedAction}
            onClick={toggleVaginaFrontMode}
          >
            {vaginaOpen ? 'VAGINA OPEN' : 'VAGINA CLOSED'}
          </Button>
        </Stack.Item>
      )}

      <Stack.Item>
        <Button
          fluid
          color={currentAnalOpen ? 'pink' : 'red'}
          disabled={cursedActionDisabled}
          tooltip={reasonForCursedAction}
          onClick={() =>
            act('chastity_set_anal_open', {
              anal_open: currentAnalOpen ? 0 : 1,
            })
          }
        >
          {currentAnalOpen ? 'ANAL OPEN' : 'ANAL CLOSED'}
        </Button>
      </Stack.Item>

      <Stack.Item>
        <Button
          fluid
          color={currentSpikesOn ? 'red' : 'pink'}
          disabled={cursedActionDisabled}
          tooltip={reasonForCursedAction}
          onClick={() =>
            act('chastity_set_spikes', { spikes_on: currentSpikesOn ? 0 : 1 })
          }
        >
          {currentSpikesOn ? 'SPIKES EXTENDED' : 'SPIKES RETRACTED'}
        </Button>
      </Stack.Item>

      {showPenisControls && (
        <Stack.Item>
          <Button
            fluid
            color={currentFlat ? 'red' : 'good'}
            disabled={cursedActionDisabled}
            tooltip={reasonForCursedAction}
            onClick={() =>
              act('chastity_set_flat', { is_flat: currentFlat ? 0 : 1 })
            }
          >
            {currentFlat ? 'FLAT FIT' : 'STANDARD FIT'}
          </Button>
        </Stack.Item>
      )}

      <Box mt={1}>
        <NoticeBox>
          Direct-state controls require exactly one selected cursed pet.
        </NoticeBox>
      </Box>
    </Stack>
  );
};
