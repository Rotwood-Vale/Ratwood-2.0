import type { BooleanLike } from 'tgui-core/react';

import type { ArtViewSettings } from '../common/artViewSettings';
import type { GallerySettings } from '../ExamineGallery/effects';

export type FormId = 'character' | 'gnoll';

export type ImageForm = {
  revision: number;
  alternates: Record<string, { active_alternate: BooleanLike }>;
  undo: string[];
  undo_removed: Record<string, number>;
  undo_clear: BooleanLike;
  undo_artwork_settings: BooleanLike;
  artwork_defaults: Pick<ArtViewSettings, 'opening_view' | 'lock'> & {
    card_background: string;
  };
  artwork_feedback: string | null;
  blocked_links: { label: string; url: string }[];
  id: FormId;
  name: string;
  headshot: string | null;
  headshot_zoom: number;
  headshot_x: number;
  headshot_y: number;
  ooc_extra_img: string | null;
  ooc_extra_img_size: number;
  nsfw_ooc_extra_img: string | null;
  nsfw_ooc_extra_img_size: number;
  img_gallery: string[] | null;
  nsfw_img_gallery: string[] | null;
  image_backdrop: string;
  card_backgrounds: Record<string, string>;
  art_view_settings: Record<string, ArtViewSettings>;
};

export type Data = {
  gallery: GallerySettings;
  artwork_preview_placement: 'side' | 'popup';
  prompt_timeout: number;
  link_max_length: number;
  image_actions: string[];
  confirm_actions: string[];
  link_hosts: string;
  url_editor: {
    id: number;
    form: FormId;
    image: string;
    label: string;
    main: string | null;
    alternate: string | null;
    active_alternate: BooleanLike;
    main_background?: string;
    alternate_background?: string;
    main_view_settings?: ArtViewSettings;
    alternate_view_settings?: ArtViewSettings;
    extensions: string[];
    error: string | null;
    popup_open?: BooleanLike;
  } | null;
  generation: number;
  edit_seq: number;
  gallery_dirty: BooleanLike;
  selected_form: FormId;
  can_save: BooleanLike;
  save_feedback: { message: string } | null;
  headshot_frame_chat: BooleanLike;
  gallery_max: number;
  zoom_min: number;
  zoom_max: number;
  extra_size_min: number;
  extra_size_max: number;
  backdrop_options: { value: string; label: string }[];
  card_background_options: { value: string; label: string }[];
  forms: ImageForm[];
};

/** The Edit dialog the server has open, for one image's current and alternate links */
export type UrlEditorData = NonNullable<Data['url_editor']>;

/** Whether the Edit dialog is for an artwork, the only kind the server sends card backdrops for */
export const isArtEditor = (editor: UrlEditorData) =>
  editor.main_background !== undefined;
