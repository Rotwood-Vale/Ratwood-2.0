import type { BooleanLike } from 'tgui-core/react';

import type { GallerySettings } from './ExamineGallery/effects';

export type ExaminePanelData = {
  // Identity
  character_name: string;
  headshot: string;
  /** Whether headshot is a real picture rather than the placeholder */
  has_headshot: BooleanLike;
  headshot_zoom: number;
  headshot_x: number;
  headshot_y: number;
  is_admin: BooleanLike;
  obscured: boolean;
  // Descriptions
  flavor_text: string;
  ooc_notes: string;
  // Descriptions, but requiring manual input to see
  flavor_text_nsfw: string;
  ooc_notes_nsfw: string;
  img_gallery: string[];
  nsfw_img_gallery: string[];
  ooc_extra_image: string;
  nsfw_ooc_extra_image: string;
  is_playing: boolean;
  song_title: string;
  song_artist: string;
  has_song: boolean;
  is_vet: boolean;
  is_naked: boolean;
  nsfw_examine_always: Boolean;
  gallery: GallerySettings;
  image_backdrop: string;
  card_backgrounds: Record<string, string>;
  gallery_figures: string[];
};
