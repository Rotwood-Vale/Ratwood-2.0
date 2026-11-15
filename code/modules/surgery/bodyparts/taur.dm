// TAURS
/obj/item/bodypart/taur
	/// Whether SPLURT-style taur genital artwork fits this body shape.
	var/uses_taur_genital_sprites = TRUE
	/// Whether this body can use insect ovipositor artwork.
	var/supports_ovipositor = FALSE
	/// Body-specific state prefix in taur_ovipositors.dmi; Ant remains the fallback.
	var/ovipositor_sprite = "ant"
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

	// Determines which set of taur barding sprites to use. Easiest way to do this, frankly... ough.
	// "m" = mammalian (canine, feline, tempest, kitsune, venard, skunk)
	// "r" = reptilian (drake, noodle, sloog)
	// "d" = deer
	// "s" = saiga
	// "h" = horse
	// null = no taur-specific clothing support
	var/taur_clothing_category = null
	/// Separate artwork allows horse fittings without changing existing taur sprites.
	var/taur_clothing_icon = 'icons/roguetown/clothing/special/onmob/taur_clothing.dmi'
	var/has_barding_tassets = TRUE
	/// Removable cloth currently fitted to this body.
	var/obj/item/caparison/applied_caparison
	// Customizable colors for plate tasset overlays (like detail_color on clothing)
	var/tasset1_color = null
	var/tasset2_color = null

	// Clip Masks allow you to apply a clipping filter to some other parts of human rendering to avoid anything overlapping the tail.
	// Specifically: update_inv_cloak, update_inv_shirt, update_inv_armor, and update_inv_pants.
	var/icon/clip_mask_icon = 'icons/mob/taurs.dmi'
	var/clip_mask_state = "taur_clip_mask_def"
	// Separate clip mask for legs only (shoes and pants) - used for digitigrade legs that don't need body clipping
	var/clip_mask_legs_state = null
	// Instantiated at runtime for speed
	var/tmp/icon/clip_mask
	var/tmp/icon/clip_mask_legs

/obj/item/bodypart/taur/New()
	. = ..()

	if(clip_mask_state)
		clip_mask = icon(icon = (clip_mask_icon || icon), icon_state = clip_mask_state)
	if(clip_mask_legs_state)
		clip_mask_legs = icon(icon = (clip_mask_icon || icon), icon_state = clip_mask_legs_state)

/obj/item/bodypart/taur/drop_limb(special)
	applied_caparison?.remove_from_taur()
	return ..()

/obj/item/bodypart/taur/Destroy()
	applied_caparison?.remove_from_taur()
	return ..()

/obj/item/bodypart/taur/proc/get_barding_state(obj/item/clothing/clothing)
	if(!taur_clothing_category || !clothing)
		return null
	if(taur_clothing_category in list("s", "h"))
		if(istype(clothing, /obj/item/clothing/cloak/psydontabard) || istype(clothing, /obj/item/clothing/cloak/templar/psydon) || istype(clothing, /obj/item/clothing/cloak/tabard/crusader/psydon))
			return "psydon"
		if(istype(clothing, /obj/item/clothing/cloak/templar/astrata) || istype(clothing, /obj/item/clothing/cloak/tabard/crusader/astrata))
			return "astrata"
	if(istype(clothing, /obj/item/clothing/cloak/stabard))
		return "caparison"
	if(istype(clothing, /obj/item/clothing/cloak))
		return (taur_clothing_category in list("s", "h")) ? "caparison" : "caparison-tabard"
	switch(clothing.armor_class)
		if(ARMOR_CLASS_LIGHT)
			if(istype(clothing, /obj/item/clothing/suit/roguetown/armor/chainmail))
				return "chainmail"
			if((taur_clothing_category in list("s", "h")) && istype(clothing, /obj/item/clothing/suit/roguetown/armor/gambeson))
				return "padded"
			return "leather"
		if(ARMOR_CLASS_MEDIUM)
			return "chainmail"
		if(ARMOR_CLASS_HEAVY)
			return "plate"
	return null

/obj/item/bodypart/taur/proc/get_barding_overlay(obj/item/clothing/clothing, worn_layer)
	var/taur_state = get_barding_state(clothing)
	if(!taur_state)
		return null
	var/mutable_appearance/barding = mutable_appearance(taur_clothing_icon, "[taur_state]_[taur_clothing_category]", -worn_layer)
	barding.pixel_x = offset_x
	if(clothing.color && (taur_state == "padded" || istype(clothing, /obj/item/clothing/cloak)))
		barding.color = clothing.color
	if((taur_clothing_category in list("s", "h")) && taur_state == "caparison")
		var/mutable_appearance/detail = mutable_appearance(taur_clothing_icon, "caparison-tabard_[taur_clothing_category]")
		detail.appearance_flags = RESET_COLOR
		detail.color = clothing.get_detail_color()
		barding.overlays += detail
	return barding

/obj/item/bodypart/taur/proc/get_caparison_state(obj/item/caparison/cloth)
	if(!taur_clothing_category || !cloth)
		return null
	var/state
	switch(cloth.caparison_state)
		if("caparison")
			state = "caparison"
		if("psy_caparison")
			state = "psydon"
		if("astra_caparison")
			state = "astrata"
	if(state && ("[state]_[taur_clothing_category]" in icon_states(taur_clothing_icon)))
		return state
	return null

/obj/item/bodypart/taur/proc/get_applied_caparison_overlay()
	var/state = get_caparison_state(applied_caparison)
	if(!state)
		return null
	var/mutable_appearance/cloth = mutable_appearance(taur_clothing_icon, "[state]_[taur_clothing_category]", -(SHIRT_LAYER + 0.1))
	cloth.pixel_x = offset_x
	cloth.color = applied_caparison.color
	if(state == "caparison" && (taur_clothing_category in list("s", "h")))
		var/mutable_appearance/detail = mutable_appearance(taur_clothing_icon, "caparison-tabard_[taur_clothing_category]")
		detail.appearance_flags = RESET_COLOR
		detail.color = applied_caparison.get_detail_color()
		cloth.overlays += detail
	return cloth

/// The legacy deer sheet calls its second detail plate-tasset_d.
/obj/item/bodypart/taur/proc/get_tasset_state(index)
	if(taur_clothing_category == "d" && index == 2)
		return "plate-tasset_d"
	return "plate-tasset[index]_[taur_clothing_category]"

/obj/item/bodypart/taur/generate_limb_cache_key(dropped, hideaux)
	. = ..()
	. += jointext(list(
		taur_icon_state,
		taur_markings_state,
		taur_tertiary_state,
		has_taur_color,
		color_blend_mode,
		taur_color,
		taur_markings,
		taur_tertiary,
		taur_clothing_category,
		tasset1_color,
		tasset2_color,
		applied_caparison?.type,
		applied_caparison?.color,
		applied_caparison?.detail_color,
		clip_mask_icon,
		clip_mask_state,
		clip_mask_legs_state), "-")

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
	if(!dropped && applied_caparison)
		. += get_applied_caparison_overlay()

/*********************************/
/* TAUR TYPES                   */
/*********************************/
GLOBAL_LIST_INIT(taur_types, subtypesof(/obj/item/bodypart/taur))

// Ported from Ochre-Valley bf7ad24875 by SomeDeviant.
/obj/item/bodypart/taur/biglegs
	name = "Digitigrade Big Legs"
	icon = 'icons/mob/taurs/big_legs.dmi'
	taur_icon_state = "biglegs_s"
	taur_markings_state = "biglegs_norm"
	has_taur_color = TRUE
	uses_taur_genital_sprites = FALSE

/obj/item/bodypart/taur/biglegsstanced
	name = "Digitigrade Big Legs, Stanced"
	icon = 'icons/mob/taurs/big_legs.dmi'
	taur_icon_state = "biglegsstanced_s"
	taur_markings_state = "biglegs_stanced"
	has_taur_color = TRUE
	uses_taur_genital_sprites = FALSE

/obj/item/bodypart/taur/lamia
	uses_taur_genital_sprites = FALSE
	name = "Lamia Tail"

	offset_x = -16
	taur_icon_state = "altnaga_s"
	taur_markings_state = "naga_tail_markings_lamian_tail" // who tf named these???

	has_taur_color = TRUE

/obj/item/bodypart/taur/lamiastriped
	uses_taur_genital_sprites = FALSE
	name = "Striped Lamia Tail"

	offset_x = -16
	taur_icon_state = "altnaga_s"
	taur_markings_state = "naga_tail_markings_lamian_tail"
	taur_tertiary_state = "nagastriped_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/fatlamia
	uses_taur_genital_sprites = FALSE
	name = "Fat Lamia Tail"

	offset_x = -16
	taur_icon_state = "nagafat_s"
	taur_markings_state = "nagafat_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/mermaid
	uses_taur_genital_sprites = FALSE
	name = "Mermaid Tail"

	offset_x = -16
	taur_icon_state = "altmermaid_s"
	taur_markings_state = "altmermaid_markings"
	taur_tertiary_state = "altmermaid_markings2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/orca
	uses_taur_genital_sprites = FALSE
	name = "Orca Tail"

	offset_x = -16
	taur_icon_state = "orcamermaid_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/tentacle
	uses_taur_genital_sprites = FALSE
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
	taur_clothing_category = "m"
	taur_markings_state = "canine_markings"
	taur_tertiary_state = "canine_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/venard
	name = "Venard Body"

	offset_x = -16
	taur_icon_state = "venard_s"
	taur_clothing_category = "m"
	taur_markings_state = "venard_markings"
	taur_tertiary_state = "venard_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/drake
	name = "Drake Body"

	offset_x = -16
	taur_icon_state = "drake_s"
	taur_clothing_category = "r"
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
	taur_clothing_category = "r"
	taur_markings_state = "noodle_markings"
	taur_tertiary_state = "noodle_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/horse
	name = "Saiga Body"
	offset_x = -16
	taur_icon_state = "saiga_s"
	taur_clothing_category = "s"
	has_barding_tassets = FALSE
	clip_mask_state = "clip_mask_saiga"

	has_taur_color = TRUE

/obj/item/bodypart/taur/deer
	name = "Deer Body"

	offset_x = -16
	taur_icon_state = "deer_s"
	taur_clothing_category = "d"
	taur_markings_state = "deer_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/goat
	name = "Goat Legs"

	offset_x = -16
	taur_icon_state = "goat_s"
	taur_markings_state = "goat_markings"
	clip_mask_state = null
	clip_mask_legs_state = "clip_mask_goat"

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
	taur_clothing_category = "m"
	taur_markings_state = "kitsune_markings"
	taur_tertiary_state = "kitsune_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/feline
	name = "Feline Body"

	offset_x = -16
	taur_icon_state = "feline_s"
	taur_clothing_category = "m"
	taur_markings_state = "feline_markings"
	taur_tertiary_state = "feline_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/snep
	name = "Tempest Body"

	offset_x = -16
	taur_icon_state = "tempest_s"
	taur_clothing_category = "m"
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
	supports_ovipositor = TRUE
	ovipositor_sprite = "spider"
	name = "Spider Body"

	offset_x = -16
	taur_icon_state = "spider_s"
	taur_markings_state = "spider_markings"
	taur_tertiary_state = "spider_markings_2"

	has_taur_color = TRUE

/obj/item/bodypart/taur/spider/weaver
	name = "Weaver Spider Body"
	icon = 'icons/mob/weaver_spider.dmi'
	taur_icon_state = "weaver_s"
	taur_markings_state = "weaver_markings"
	taur_tertiary_state = "weaver_bands"
	clip_mask_icon = 'icons/mob/weaver_spider.dmi'
	clip_mask_state = "weaver_clip_mask"
	color_blend_mode = ICON_MULTIPLY

/obj/item/bodypart/taur/spider/weaver/get_limb_icon(dropped, hideaux = FALSE)
	. = ..()
	if(dropped)
		return

	// Only the north-facing central shell is in these states. Draw it over
	// clothing, sleeves, and long hair; keep hands and held items visible.
	var/list/shell_states = list("weaver_front_s", "weaver_front_markings", "weaver_front_bands")
	var/list/shell_colors = list(taur_color, taur_markings, taur_tertiary)
	for(var/i in 1 to length(shell_states))
		var/icon/shell_icon = icon(icon, shell_states[i])
		shell_icon.Blend(shell_colors[i], color_blend_mode)
		var/image/shell = image(shell_icon)
		shell.layer = -HAIREXTRA_LAYER + 0.1
		shell.pixel_x = offset_x
		. += shell

/obj/item/bodypart/taur/centipede
	supports_ovipositor = TRUE
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
	taur_clothing_category = "r"
	taur_markings_state = "sloog_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/ant
	supports_ovipositor = TRUE
	name = "Ant Body"

	offset_x = -16
	taur_icon_state = "ant_s"
	taur_markings_state = "ant_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/wasp
	supports_ovipositor = TRUE
	ovipositor_sprite = "wasp"
	name = "Wasp Body"

	offset_x = -16
	taur_icon_state = "wasp_s"
	taur_markings_state = "wasp_markings"

	has_taur_color = TRUE

/obj/item/bodypart/taur/insect
	supports_ovipositor = TRUE
	name = "Insect Body"

	offset_x = -16
	taur_icon_state = "insect_s"
	taur_markings_state = "insect_markings"
	taur_tertiary_state = "insect_markings_2"

	has_taur_color = TRUE

// Keep /taur/horse as the existing Saiga Body for saved characters.
/obj/item/bodypart/taur/equine
	name = "Horse Body"
	icon = 'icons/mob/horse_taur.dmi'
	taur_icon_state = "Horse_S"
	taur_markings_state = "Horse_Markings_2nd"
	taur_tertiary_state = "Markings_3rd"
	has_taur_color = TRUE
	color_blend_mode = ICON_MULTIPLY
	taur_clothing_category = "h"
	taur_clothing_icon = 'icons/roguetown/clothing/special/onmob/horse_clothing.dmi'
	clip_mask_icon = 'icons/mob/taurs.dmi'
	clip_mask_state = "clip_mask_saiga"

/obj/item/bodypart/taur/equine/generate_limb_cache_key(dropped, hideaux)
	return "[..()]-[json_encode(markings)]"

/obj/item/bodypart/taur/equine/get_limb_icon(dropped, hideaux = FALSE)
	. = ..()
	// Only the authored South strip sits behind the normal genital layer.
	// All other directions in this state are transparent.
	var/icon/front_below_icon = icon(icon, "Horse_front_bellow", dropped ? SOUTH : 0)
	front_below_icon.Blend(taur_color, color_blend_mode)
	var/image/front_below = image(front_below_icon)
	front_below.pixel_x = offset_x
	front_below.layer = -(BODY_BEHIND_LAYER + 0.1)
	. += front_below
	// These optional leg markings use their own wide sprites and color controls.
	for(var/marking_name in markings)
		var/datum/body_marking/marking = GLOB.body_markings[marking_name]
		if(marking?.taur_body_type != /obj/item/bodypart/taur/equine)
			continue
		var/icon/marking_icon = icon(marking.icon, marking.icon_state, dropped ? SOUTH : 0)
		marking_icon.Blend("#[markings[marking_name]]", ICON_MULTIPLY)
		var/image/overlay = image(marking_icon)
		overlay.pixel_x = offset_x
		overlay.layer = -BODY_ADJ_LAYER + (marking.icon_state == "Hooves_markings" ? 0.2 : 0.1)
		. += overlay

/// Hide only clothing pixels covered by the horse silhouette when facing north.
/// Clone cached appearances, including their detail overlays, before changing any icons.
/obj/item/bodypart/taur/equine/proc/occlude_north_clothing(list/appearances, parent_x = 0, parent_y = 0)
	for(var/index in 1 to length(appearances))
		var/mutable_appearance/appearance = new(appearances[index])
		var/clothing_x = parent_x + appearance.pixel_x
		var/clothing_y = parent_y + appearance.pixel_y
		if(appearance.icon)
			var/icon/clothing_icon = icon(appearance.icon, appearance.icon_state)
			clothing_icon.AddAlphaMask(get_north_clothing_mask(clothing_icon.Width(), clothing_icon.Height(), clothing_x, clothing_y))
			appearance.icon = clothing_icon
			appearance.icon_state = ""
		if(length(appearance.overlays))
			var/list/details = appearance.overlays.Copy()
			occlude_north_clothing(details, clothing_x, clothing_y)
			appearance.overlays = details
		if(length(appearance.underlays))
			var/list/background_details = appearance.underlays.Copy()
			occlude_north_clothing(background_details, clothing_x, clothing_y)
			appearance.underlays = background_details
		appearances[index] = appearance

/// An inverse body silhouette in North, fully opaque in the other directions.
/obj/item/bodypart/taur/equine/proc/get_north_clothing_mask(width, height, clothing_x, clothing_y)
	var/static/list/clothing_masks = list()
	var/key = "[icon]-[taur_icon_state]-[taur_markings_state]-[taur_tertiary_state]-[offset_x]-[width]-[height]-[clothing_x]-[clothing_y]"
	if(!clothing_masks[key])
		var/icon/mask = icon(icon, taur_icon_state)
		for(var/state in list(taur_markings_state, taur_tertiary_state))
			if(state)
				mask.Blend(icon(icon, state), ICON_OVERLAY)
		// Translate the wide body into the clothing canvas, including species offsets.
		mask.Crop(1 + clothing_x - offset_x, 1 + clothing_y, width + clothing_x - offset_x, height + clothing_y)
		mask.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,0, 1,1,1,1)
		mask.Opaque(COLOR_WHITE)
		mask.BecomeAlphaMask()
		var/icon/unchanged = icon(mask, "", NORTH)
		unchanged.Opaque(COLOR_WHITE)
		for(var/direction in list(SOUTH, EAST, WEST))
			mask.Insert(unchanged, "", direction)
		clothing_masks[key] = mask
		trim_cache(clothing_masks, SPRITE_ACCESSORY_ICON_CACHE_LEN)
	return clothing_masks[key]
