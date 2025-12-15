// TAURS
/obj/item/bodypart/taur
	name = "taur"
	desc = ""
	icon = 'icons/mob/taurs.dmi'
	icon_state = ""
	attack_verb = list("hit")
	max_damage = 200
	body_zone = BODY_ZONE_TAUR
	body_part = LEGS
	body_damage_coeff = 1
	px_x = -16
	px_y = 12
	max_stamina_damage = 50
	subtargets = list(BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT)
	grabtargets = list(BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT)
	dismember_wound = /datum/wound/dismemberment/taur
	unlimited_bleeding = TRUE

	// Taur stuff!
	// offset_x forces the limb_icon to be shifted on x relative to the human (since these are >32x32)
	var/offset_x = -16
	// taur_icon_state sets which icon to use from icons/mob/taurs.dmi to render
	// (we don't use icon_state to avoid duplicate rendering on dropped organs)
	var/taur_icon_state = "naga_s"
	var/taur_markings_state = null
	var/taur_tertiary_state = null

	// We can Blend() a color with the base greyscale color, only some tails support this
	var/has_taur_color = FALSE
	var/color_blend_mode = BLEND_ADD
	var/taur_color = null
	var/taur_markings = null
	var/taur_tertiary = null

	// Clip Masks allow you to apply a clipping filter to some other parts of human rendering to avoid anything overlapping the tail.
	// Specifically: update_inv_cloak, update_inv_shirt, update_inv_armor, and update_inv_pants.
	var/icon/clip_mask_icon = 'icons/mob/taurs.dmi'
	var/clip_mask_state = "taur_clip_mask_def"
	// Instantiated at runtime for speed
	var/tmp/icon/clip_mask

/obj/item/bodypart/taur/New()
	. = ..()

	if(clip_mask_state)
		clip_mask = icon(icon = (clip_mask_icon || icon), icon_state = clip_mask_state)

/obj/item/bodypart/taur/get_limb_icon(dropped, hideaux = FALSE)
	// List of overlays
	. = list()

	var/image_dir = 0
	if(dropped)
		image_dir = SOUTH

	// This section is based on Virgo's human rendering, there may be better ways to do this now
	var/icon/tail_s = new/icon("icon" = icon, "icon_state" = taur_icon_state, "dir" = image_dir)
	if(has_taur_color)
		tail_s.Blend(taur_color, color_blend_mode)

	var/icon/taur_m = new/icon("icon" = icon, "icon_state" = taur_markings_state, "dir" = image_dir)
	if(has_taur_color)
		taur_m.Blend(taur_markings, color_blend_mode)

	var/icon/taur_t = new/icon("icon" = icon, "icon_state" = taur_tertiary_state, "dir" = image_dir)
	if(has_taur_color)
		taur_t.Blend(taur_tertiary, color_blend_mode)

	var/image/working = image(tail_s)
	// because these can overlap other organs, we need to layer slightly higher
	working.layer = -BODYPARTS_LAYER // -FRONT_MUTATIONS_LAYER = tail renders over tits, -BODYPARTS_LAYER = tail renders underneath the tits, as it should
	working.pixel_x = offset_x

	var/image/markings = image(taur_m)
	markings.layer = -BODY_ADJ_LAYER
	markings.pixel_x = offset_x

	var/image/tertiary = image(taur_t)
	tertiary.layer = -BODY_ADJ_LAYER
	tertiary.pixel_x = offset_x

	. += working
	. += markings
	. += tertiary

/*********************************/
/* TAUR TYPES                    */
/*********************************/
GLOBAL_LIST_INIT(taur_types, subtypesof(/obj/item/bodypart/taur))

/obj/item/bodypart/taur/lamia
	name = "Lamia Tail"

	offset_x = -16
	taur_icon_state = "altnaga_s"
	taur_markings_state = "naga_tail_markings_lamian_tail" // who tf named these???

	has_taur_color = TRUE

/obj/item/bodypart/taur/lamiastriped
	name = "Striped Lamia Tail"

	offset_x = -16
	taur_icon_state = "altnaga_s"
	taur_markings_state = "naga_tail_markings_lamian_tail"
	taur_tertiary_state = "nagastriped_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/fatlamia
	name = "Fat Lamia Tail"

	offset_x = -16
	taur_icon_state = "nagafat_s"
	taur_markings_state = "nagafat_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/mermaid
	name = "Mermaid Tail"

	offset_x = -16
	taur_icon_state = "altmermaid_s"
	taur_markings_state = "altmermaid_markings"
	taur_tertiary_state = "altmermaid_markings2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/orca
	name = "Orca Tail"

	offset_x = -16
	taur_icon_state = "orcamermaid_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/tentacle
	name = "Tentacles"

	offset_x = -16
	taur_icon_state = "tentacle_s"
	taur_markings_state = "tentacle_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/otie
	name = "Otie Body"

	offset_x = -16
	taur_icon_state = "otie_s"
	taur_markings_state = "otie_markings"
	taur_tertiary_state = "otie_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/canine
	name = "Canine Body"

	offset_x = -16
	taur_icon_state = "canine_s"
	taur_markings_state = "canine_markings"
	taur_tertiary_state = "canine_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/venard
	name = "Venard Body"

	offset_x = -16
	taur_icon_state = "venard_s"
	taur_markings_state = "venard_markings"
	taur_tertiary_state = "venard_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/drake
	name = "Drake Body"

	offset_x = -16
	taur_icon_state = "drake_s"
	taur_markings_state = "drake_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/dragon
	name = "Dragon Body"

	offset_x = -16
	taur_icon_state = "drake2_s"
	taur_markings_state = "drake2_markings"
	taur_tertiary_state = "drake2_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/noodle
	name = "Noodle Dragon Body"

	offset_x = -16
	taur_icon_state = "noodle_s"
	taur_markings_state = "noodle_markings"
	taur_tertiary_state = "noodle_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/horse
	name = "Saiga Body"

	offset_x = -16
	taur_icon_state = "saiga_s"
	clip_mask_state = "clip_mask_saiga"

	has_taur_color = TRUE

/obj/item/bodypart/taur/deer
	name = "Deer Body"

	offset_x = -16
	taur_icon_state = "deer_s"
	taur_markings_state = "deer_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/redpanda
	name = "Red Panda Body"

	offset_x = -16
	taur_icon_state = "redpanda_s"
	taur_markings_state = "redpanda_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/rat
	name = "Rat Body"

	offset_x = -16
	taur_icon_state = "rat_s"
	taur_markings_state = "rat_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/skunk
	name = "Skunk Body"

	offset_x = -16
	taur_icon_state = "skunk_s"
	taur_markings_state = "skunk_markings"
	taur_tertiary_state = "skunk_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/kitsune
	name = "Kitsune Body"

	offset_x = -16
	taur_icon_state = "kitsune_s"
	taur_markings_state = "kitsune_markings"
	taur_tertiary_state = "kitsune_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/feline
	name = "Feline Body"

	offset_x = -16
	taur_icon_state = "feline_s"
	taur_markings_state = "feline_markings"
	taur_tertiary_state = "feline_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/snep
	name = "Tempest Body"

	offset_x = -16
	taur_icon_state = "tempest_s"
	taur_markings_state = "feline_markings"
	taur_tertiary_state = "feline_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/tiger
	name = "Tiger Body"

	offset_x = -16
	taur_icon_state = "feline_s"
	taur_markings_state = "tiger_markings"
	taur_tertiary_state = "tiger_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/spider
	name = "Spider Body"

	offset_x = -16
	taur_icon_state = "spider_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/centipede
	name = "Centipede Body"

	offset_x = -16
	taur_icon_state = "centipede_s"
	taur_markings_state = "centipede_markings"
	taur_tertiary_state = "centipede_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/sloog
	name = "Sloog Body"

	offset_x = -16
	taur_icon_state = "sloog_s"
	taur_markings_state = "sloog_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/ant
	name = "Ant Body"

	offset_x = -16
	taur_icon_state = "ant_s"
	taur_markings_state = "ant_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/wasp
	name = "Wasp Body"

	offset_x = -16
	taur_icon_state = "wasp_s"
	taur_markings_state = "wasp_markings"

	has_taur_color = TRUE
