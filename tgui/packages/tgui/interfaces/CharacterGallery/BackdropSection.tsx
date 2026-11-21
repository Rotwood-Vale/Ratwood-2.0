import { Box, Button, Section } from 'tgui-core/components';

import { type ImageForm, useGalleryBackend } from './shared';

export const BackdropSection = (props: { form: ImageForm }) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { form } = props;
  const busy = isBusy(form.id);
  return (
    <Section title="Image Gallery Backdrop">
      <Box color="label" mb={1}>
        What viewers see behind your pictures in the Image Gallery.
      </Box>
      <div
        className="CharacterGallery__actions"
        role="group"
        aria-label="Image Gallery Backdrop"
      >
        {data.backdrop_options.map((option) => {
          const chosen = option.value === form.image_backdrop;
          return (
            <Button
              key={option.value}
              icon={chosen ? 'check' : undefined}
              selected={chosen}
              bold={chosen}
              disabled={busy}
              aria-pressed={chosen}
              onClick={() => {
                if (!chosen) {
                  act('set_backdrop', {
                    form: form.id,
                    backdrop: option.value,
                  });
                }
              }}
            >
              {option.label}
            </Button>
          );
        })}
      </div>
    </Section>
  );
};
