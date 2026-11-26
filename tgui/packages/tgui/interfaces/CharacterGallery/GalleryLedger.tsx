import type { ComponentPropsWithRef, MouseEvent, ReactNode } from 'react';
import { Box, Button, Icon, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { buttonRole } from './buttonSemantics';

export const GalleryLedger = (props: {
  expanded: boolean;
  children: ReactNode;
}) => (
  <div
    className={classes([
      'CharacterGallery__ledger',
      props.expanded && 'CharacterGallery__ledger--expanded',
    ])}
  >
    {props.children}
  </div>
);

export const GalleryLedgerPane = (props: ComponentPropsWithRef<'div'>) => {
  const { className, ...rest } = props;
  return (
    <div
      {...rest}
      className={classes([
        'CharacterGallery__scroll CharacterGallery__workspace CharacterGallery__editor',
        className,
      ])}
    />
  );
};

export const GalleryLedgerDivider = (
  props: Pick<
    ComponentPropsWithRef<'button'>,
    'onClick' | 'onMouseDown' | 'ref'
  > & { label: string },
) => {
  const { label, ...buttonProps } = props;
  return (
    <button
      {...buttonProps}
      type="button"
      className="CharacterGallery__ledgerDivider"
      aria-label={label}
      title={label}
    >
      <span className="CharacterGallery__ledgerDividerTab" aria-hidden="true">
        <Icon name="chevron-left" />
      </span>
    </button>
  );
};

export const GalleryLedgerHeader = (props: {
  title: string;
  sideBySide: boolean;
  closeOnLeft?: boolean;
  onClose?: () => void;
  onMouseDown?: (event: MouseEvent) => void;
}) => {
  const { title, sideBySide, closeOnLeft, onClose, onMouseDown } = props;
  const close = onClose && (
    <Stack.Item className="CharacterGallery__ledgerHeaderClose">
      <Button
        {...buttonRole}
        icon={sideBySide ? 'chevron-left' : 'arrow-left'}
        onMouseDown={onMouseDown}
        onClick={onClose}
      >
        {sideBySide ? 'Collapse' : 'Back to Gallery'}
      </Button>
    </Stack.Item>
  );
  return (
    <Stack
      mb={1}
      align="center"
      justify={closeOnLeft ? 'flex-start' : 'space-between'}
    >
      {closeOnLeft && close}
      <Box bold>{title}</Box>
      {!closeOnLeft && close}
    </Stack>
  );
};
