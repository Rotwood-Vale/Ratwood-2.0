import { Dropdown, Tooltip } from 'tgui-core/components';

import { CardBackground, cardMaterial } from '../common/CardBackground';
import { useGalleryBackend } from './shared';

export const CardBackgroundControl = (props: {
  value: string;
  disabled?: boolean;
  onSelected: (background: string) => void;
}) => {
  const { data } = useGalleryBackend();
  const value = cardMaterial(props.value);
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
