import { Box, Button, Icon, Section } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { resolveAsset } from '../../assets';
import { HeadshotFrame, PictureTooLarge } from '../common/HeadshotFrame';
import { usePictureSize } from '../common/pictureSize';
import type { Framing } from './framing';
import { buttonRole, type ImageForm, useGalleryBackend } from './shared';

export const ChatAppearance = (props: {
  form: ImageForm;
  framing: Framing;
  retry: number;
  busy: boolean;
}) => {
  const { act, data } = useGalleryBackend();
  const { form, framing, retry, busy } = props;
  const original = usePictureSize(form.headshot);
  return (
    <Section title="Chat Appearance">
      <Box color="label" mb={1}>
        Choose how your headshot appears in the chat examine only. Examine
        Closer always uses the square portrait.
      </Box>
      <div className="CharacterGallery__chatOptions">
        {[false, true].map((useFraming) => {
          const chosen = !!data.headshot_frame_chat === useFraming;
          const title = useFraming ? 'Square Portrait' : 'Original Proportions';
          return (
            <Button
              key={String(useFraming)}
              disabled={busy}
              className={classes([
                'CharacterGallery__chatOption',
                chosen && 'CharacterGallery__chatOption--selected',
              ])}
              {...buttonRole}
              aria-label={title}
              aria-pressed={chosen}
              onClick={() => act('set_frame_chat', { enabled: useFraming })}
            >
              <div className="CharacterGallery__chatPreview">
                {useFraming ? (
                  <div className="CharacterGallery__chatSquare">
                    <HeadshotFrame
                      key={retry}
                      src={form.headshot!}
                      zoom={framing.zoom}
                      x={framing.x}
                      y={framing.y}
                    />
                  </div>
                ) : original.tooLarge ? (
                  <PictureTooLarge />
                ) : (
                  original.drawable && (
                    <img
                      key={retry}
                      className="CharacterGallery__chatOriginal"
                      src={resolveAsset(form.headshot!)}
                      alt="Chat headshot with original proportions"
                    />
                  )
                )}
              </div>
              <Box bold className="CharacterGallery__chatLabel">
                {chosen && <Icon name="check" mr={0.5} />}
                {title}
              </Box>
              <Box color="label" mt={0.5}>
                {useFraming
                  ? 'Matches the portrait above.'
                  : 'Keeps the original shape.'}
              </Box>
            </Button>
          );
        })}
      </div>
    </Section>
  );
};
