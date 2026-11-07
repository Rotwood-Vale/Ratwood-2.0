import { Box } from 'tgui-core/components';

import { HEADSHOT_SLOT } from './shared';

type GuidelineScope = 'all' | 'general' | 'headshot' | 'sfw';

export const guidelineScope = (image: string): GuidelineScope => {
  if (image === HEADSHOT_SLOT) {
    return 'headshot';
  }
  return image.startsWith('nsfw_') ? 'general' : 'sfw';
};

export const ImageGuidelines = (props: { scope: GuidelineScope }) => (
  <details className="CharacterGallery__guidelines">
    <summary>Read Image Guidelines</summary>
    <Box mt={1}>
      <Box bold>General</Box>
      <ul>
        <li>
          Characters must be unquestionably adult in both appearance and age.
        </li>
        <li>
          Keep characters consistent with the setting’s aesthetic. We allow
          flexibility within reason.
        </li>
        <li>
          Respect removal requests from artists and the owners of depicted
          characters.
        </li>
      </ul>
      {(props.scope === 'all' || props.scope === 'headshot') && (
        <>
          <Box bold>Headshot</Box>
          <p>
            Keep portraits non-explicit and avoid excessive sexualization.
            Cleavage and thigh-up compositions are acceptable; nipple slips or
            compositions dominated by sexual body parts are not. While we do
            allow suggestive/risqué headshots, it should be within reason.
          </p>
        </>
      )}
      {(props.scope === 'all' || props.scope === 'sfw') && (
        <>
          <Box bold>SFW Gallery and OOC Extra</Box>
          <ul>
            <li>
              Risqué artwork, suggestive poses, mild blood/gore, and tasteful
              nudity are allowed within reason.
            </li>
            <li>
              No clearly visible genitals, arousal, anatomically explicit
              bulges, or visible nipples on breasts. Avoid excessive viscera,
              dismemberment, and overtly sexual poses.
            </li>
            <li>
              When unsure, use the NSFW gallery or ahelp.{' '}
              <b>We aim to be reasonable, not strict.</b>
            </li>
          </ul>
        </>
      )}
      <a
        href="https://wiki.ratwood.rip/index.php/Server_Rules"
        target="_blank"
        rel="noopener noreferrer"
      >
        Source: Server Rules
      </a>
    </Box>
  </details>
);
