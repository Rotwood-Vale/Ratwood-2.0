import { gallerySelectEvents } from './nativeSelect';

/** A native select with the gallery's key handling and an optional Unchanged choice first */
export const GallerySelect = (props: {
  'aria-label': string;
  'aria-describedby'?: string;
  value: string;
  disabled?: boolean;
  allowUnchanged?: boolean;
  options: { value: string; label: string }[];
  onChange: (value: string) => void;
}) => (
  <select
    aria-label={props['aria-label']}
    aria-describedby={props['aria-describedby']}
    value={props.value}
    disabled={props.disabled}
    {...gallerySelectEvents}
    onChange={(event) => props.onChange(event.target.value)}
  >
    {props.allowUnchanged && <option value="">Unchanged</option>}
    {props.options.map((option) => (
      <option key={option.value} value={option.value}>
        {option.label}
      </option>
    ))}
  </select>
);
