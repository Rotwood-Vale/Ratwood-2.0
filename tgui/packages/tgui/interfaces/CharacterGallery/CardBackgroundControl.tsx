import { Dropdown, Tooltip } from 'tgui-core/components';

import { CardBackground, cardMaterial } from '../common/CardBackground';
import { gallerySelectEvents } from './nativeSelect';
import { useGalleryBackend } from './shared';

export const CardBackgroundControl = (props: {
  value: string;
  disabled?: boolean;
  allowUnchanged?: boolean;
  onSelected: (background: string) => void;
}) => {
  const { data } = useGalleryBackend();
  const value = cardMaterial(props.value);
  if (props.allowUnchanged) {
    return (
      <label className="CharacterGallery__bulkBackground">
        Card Backdrop
        <select
          aria-label="All artwork card backdrop"
          value={props.value}
          disabled={props.disabled}
          {...gallerySelectEvents}
          onChange={(event) => props.onSelected(event.target.value)}
        >
          <option value="">Unchanged</option>
          {data.card_background_options.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>
        {!!props.value && (
          <span className="CharacterGallery__materialSwatch">
            <CardBackground value={value} />
          </span>
        )}
      </label>
    );
  }
  const label = data.card_background_options.find(
    (option) => option.value === value,
  )?.label;
  const options = data.card_background_options.map((option) => ({
    value: option.value,
    displayText: (
      <span className="CharacterGallery__materialOption">
        <span className="CharacterGallery__materialSwatch">
          <CardBackground value={option.value} />
        </span>
        {option.label}
      </span>
    ),
  }));
  return (
    <Tooltip
      content={`${label ?? 'Transparent'}. Visible through transparent areas of this card's image.`}
    >
      {/* Dropdown drops the ref and hover handlers Tooltip gives its child */}
      <span style={{ display: 'inline-block' }}>
        <Dropdown
          width="auto"
          menuWidth={11}
          selected={value}
          displayText={
            <span className="CharacterGallery__materialOption">
              Card Backdrop
              <span className="CharacterGallery__materialSwatch">
                <CardBackground value={value} />
              </span>
            </span>
          }
          options={options}
          disabled={props.disabled}
          onSelected={props.onSelected}
        />
      </span>
    </Tooltip>
  );
};
