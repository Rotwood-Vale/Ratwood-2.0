import { Tooltip } from 'tgui-core/components';

export const MouseControlIcon = (props: {
  control: 'left' | 'right' | 'wheel';
  label: string;
  className?: string;
}) => {
  const { control, label, className } = props;

  return (
    <Tooltip content={label} position="top">
      <svg
        className={className}
        width="12"
        height="16"
        viewBox="0 0 12 16"
        role="img"
        aria-label={label}
      >
        {control === 'left' && (
          <path d="M1 7V5a4 4 0 0 1 4-4h.5v6Z" fill="currentColor" />
        )}
        {control === 'right' && (
          <path d="M11 7V5a4 4 0 0 0-4-4h-.5v6Z" fill="currentColor" />
        )}
        <path
          d="M5 1h2a4 4 0 0 1 4 4v5a5 5 0 0 1-10 0V5a4 4 0 0 1 4-4ZM1 7h10m-5-6v6"
          fill="none"
          stroke="currentColor"
        />
        {control === 'wheel' && (
          <rect
            x="4.5"
            y="2"
            width="3"
            height="4.5"
            rx="1.5"
            fill="currentColor"
          />
        )}
      </svg>
    </Tooltip>
  );
};
