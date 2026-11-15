// taur_penis_onmob.dmi and taur_testicles_onmob.dmi: unmodified SPLURT/Skyrat artwork.
// Source: https://github.com/SPLURT-Station/S.P.L.U.R.T-tg
// modular_skyrat/master_files/icons/mob/sprite_accessory/genitals/
// Credit: SPLURT and Skyrat contributors. CC BY-SA 3.0: https://creativecommons.org/licenses/by-sa/3.0/
// taur_ovipositors.dmi and bee_tail_genitals.dmi: artwork supplied by tatsu.
/datum/sprite_accessory/penis
	icon = 'icons/mob/sprite_accessory/genitals/pintle.dmi'
	color_keys = 2
	color_key_names = list("Member", "Skin")
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER) //Vrell - Yes I know this is hacky but it works for now
	var/uses_size_sprites = TRUE
	var/static/taur_icon = 'icons/mob/sprite_accessory/genitals/taur_penis_onmob.dmi'
	var/static/list/taur_icon_states
	var/static/list/taur_icon_cache = list()

/// Require artwork at every selectable size and erection state.
/datum/sprite_accessory/penis/proc/has_taur_artwork()
	if(!taur_icon_states)
		taur_icon_states = icon_states(taur_icon)
	for(var/size in SMALL_PENIS_SIZE to MAX_PENIS_SIZE)
		for(var/hard in 0 to 1)
			if(!("m_penis_[icon_state]_[size]_[hard]_BEHIND_primary" in taur_icon_states))
				return FALSE
	return TRUE

/// Resolve a supported taur state, or null to retain the normal accessory.
/datum/sprite_accessory/penis/proc/get_taur_icon_state(obj/item/organ/penis/penis)
	if(!penis?.penis_taur_mode || !penis.owner)
		return null
	var/obj/item/bodypart/taur/taur = penis.owner.get_taur_tail()
	if(!taur?.uses_taur_genital_sprites)
		return null
	var/state
	if(penis.sheath_type != SHEATH_TYPE_NONE && penis.erect_state != ERECT_STATE_HARD)
		if(penis.sheath_type == SHEATH_TYPE_NORMAL)
			state = "sheath_[penis.erect_state == ERECT_STATE_NONE ? 0 : 1]"
		else if(penis.sheath_type == SHEATH_TYPE_SLIT)
			state = "slit_1"
	else
		state = "[icon_state]_[clamp(penis.penis_size, SMALL_PENIS_SIZE, MAX_PENIS_SIZE)]_[penis.erect_state == ERECT_STATE_HARD ? 1 : 0]"
	if(!taur_icon_states)
		taur_icon_states = icon_states(taur_icon)
	if("m_penis_[state]_BEHIND_primary" in taur_icon_states)
		return state
	return null

/datum/sprite_accessory/penis/get_appearance(obj/item/organ/organ, obj/item/bodypart/bodypart, color_string)
	var/obj/item/organ/penis/penis = organ
	var/state = get_taur_icon_state(penis)
	if(!state)
		return ..()
	if(!is_visible(organ, bodypart, organ.owner))
		return null
	color_string = sanitize_color_string(color_string)
	var/cache_key = "[state]-[color_string]"
	if(!taur_icon_cache[cache_key])
		var/list/colors = color_string_to_list(color_string)
		var/icon/colored_icon = icon(taur_icon, "m_penis_[state]_BEHIND_primary")
		colored_icon.Blend(colors[1], ICON_MULTIPLY)
		var/secondary_state = "m_penis_[state]_BEHIND_secondary"
		if(secondary_state in taur_icon_states)
			var/icon/secondary_icon = icon(taur_icon, secondary_state)
			secondary_icon.Blend(colors[2], ICON_MULTIPLY)
			colored_icon.Blend(secondary_icon, ICON_OVERLAY)
		taur_icon_cache[cache_key] = colored_icon
		trim_cache(taur_icon_cache, SPRITE_ACCESSORY_ICON_CACHE_LEN)
	var/mutable_appearance/appearance = mutable_appearance(taur_icon_cache[cache_key], layer = -BODY_BEHIND_LAYER)
	// Center the 64px artwork on the 32px character, as SPLURT does.
	appearance.pixel_x = -16
	var/list/appearances = list(appearance)
	adjust_appearance_list(appearances, organ, bodypart, organ.owner)
	return appearances

/datum/sprite_accessory/penis/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT, OFFSET_BELT_F)
	adjust_exposed_genital_layers(appearance_list, owner)

/datum/sprite_accessory/penis/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/penis/pp = organ
	if(pp.sheath_type != SHEATH_TYPE_NONE && pp.erect_state != ERECT_STATE_HARD)
		switch(pp.sheath_type)
			if(SHEATH_TYPE_NORMAL)
				if(pp.erect_state == ERECT_STATE_NONE)
					return "sheath_1"
				else
					return "sheath_2"
			if(SHEATH_TYPE_SLIT)
				if(pp.erect_state == ERECT_STATE_NONE)
					return "slit_1"
				else
					return "slit_2"

	if(uses_size_sprites)
		// Tiny shares sprites with small pintles, might add something later on
		var/sprite_size = clamp(pp.penis_size, SMALL_PENIS_SIZE, DEFAULT_PENIS_SIZE)
		if(pp.erect_state == ERECT_STATE_HARD)
			return "[icon_state]_2_[sprite_size]"
		else
			return "[icon_state]_1_[sprite_size]"
	else
		if(pp.erect_state == ERECT_STATE_HARD)
			return "[icon_state]_2"
		else
			return "[icon_state]_1"

/datum/sprite_accessory/penis/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.sexcon && owner.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(owner.underwear)
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDECROTCH)

/datum/sprite_accessory/penis/human
	icon_state = "human"
	name = "Plain"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/sprite_accessory/penis/knotted
	icon_state = "knotted"
	name = "Knotted"
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)

/datum/sprite_accessory/penis/flared
	icon_state = "flared"
	name = "Flared"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/sprite_accessory/penis/flared_knotted
	icon_state = "flared"
	name = "Flared, Knotted"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/sprite_accessory/penis/barbknot
	icon_state = "barbknot"
	name = "Barbed, Knotted"
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)

/datum/sprite_accessory/penis/tapered
	icon_state = "tapered"
	name = "Tapered"
	default_colors = list("C52828", "C52828")

/datum/sprite_accessory/penis/taperedknot
	icon_state = "taperedknot"
	name = "Tapered, Knotted"
	default_colors = list("C52828", "C52828")

/datum/sprite_accessory/penis/taperedknot_mammal
	icon_state = "taperedknot"
	name = "Tapered, Knotted"
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)

/datum/sprite_accessory/penis/tapered_mammal
	icon_state = "tapered"
	name = "Tapered"
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)

/datum/sprite_accessory/penis/tentacle
	icon_state = "tentacle"
	name = "Tentacled"
	default_colors = list("C52828", "C52828")

/datum/sprite_accessory/penis/hemi
	icon_state = "hemi"
	name = "Hemi"
	default_colors = list("C52828", "C52828")

/datum/sprite_accessory/penis/hemi_mammal
	icon_state = "hemi"
	name = "Hemi"
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)

/datum/sprite_accessory/penis/hemiknot
	icon_state = "hemiknot"
	name = "Knotted Hemi"
	default_colors = list("C52828", "C52828")

/// Render artist-supplied base/UP states with a shared tint cache.
/datum/sprite_accessory/penis/proc/get_paired_overlay(base_state, top_state, color_string, top_layer, offset_x = 0)
	var/static/list/paired_icon_cache = list()
	color_string = sanitize_color_string(color_string)
	var/cache_key = "[icon]-[base_state]-[top_state]-[color_string]"
	if(!paired_icon_cache[cache_key])
		var/list/colors = color_string_to_list(color_string)
		var/icon/base_icon = icon(icon, base_state)
		base_icon.Blend(colors[1], ICON_MULTIPLY)
		var/icon/top_icon = icon(icon, top_state)
		top_icon.Blend(colors[1], ICON_MULTIPLY)
		paired_icon_cache[cache_key] = list(base_icon, top_icon)
		trim_cache(paired_icon_cache, SPRITE_ACCESSORY_ICON_CACHE_LEN)
	var/list/cached_icons = paired_icon_cache[cache_key]
	// Only tinted icons are shared; placement belongs to each new appearance.
	var/mutable_appearance/base_appearance = mutable_appearance(cached_icons[1], layer = -BODY_BEHIND_LAYER)
	var/mutable_appearance/top_appearance = mutable_appearance(cached_icons[2], layer = top_layer)
	base_appearance.pixel_x = offset_x
	top_appearance.pixel_x = offset_x
	return list(base_appearance, top_appearance)

/datum/sprite_accessory/penis/bee_tail
	icon = 'icons/mob/sprite_accessory/genitals/bee_tail_genitals.dmi'
	icon_state = "bee_tail_penis_small_base"
	name = "Ovipositor"
	color_keys = 1
	color_key_name = "Member"
	color_key_defaults = list(KEY_MUT_COLOR_ONE)
	relevant_layers = list(BODY_BEHIND_LAYER)

/datum/sprite_accessory/penis/bee_tail/proc/get_bee_tail_icon_state(penis_size, top = FALSE)
	var/size_name = penis_size <= SMALL_PENIS_SIZE ? "small" : (penis_size >= MAX_PENIS_SIZE ? "large" : "average")
	var/layer_name = top ? "up" : "base"
	return "bee_tail_penis_[size_name]_[layer_name]"

/datum/sprite_accessory/penis/bee_tail/get_appearance(obj/item/organ/organ, obj/item/bodypart/bodypart, color_string)
	var/obj/item/organ/penis/penis = organ
	if(!is_visible(organ, bodypart, organ.owner))
		return null
	var/state = get_bee_tail_icon_state(penis.penis_size)
	var/top_state = get_bee_tail_icon_state(penis.penis_size, TRUE)
	// Bee and Insect tails also draw on BODY_FRONT_LAYER; UP must sit above it.
	var/list/appearances = get_paired_overlay(state, top_state, color_string, -BODY_FRONT_LAYER + 0.1)
	adjust_appearance_list(appearances, organ, bodypart, organ.owner)
	return appearances

/datum/sprite_accessory/penis/bee_tail/has_taur_artwork()
	return FALSE

/datum/sprite_accessory/penis/bee_tail/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	// Each supplied size has one pose, shared by partial and full arousal.
	var/obj/item/organ/penis/penis = organ
	return get_bee_tail_icon_state(penis.penis_size)

/datum/sprite_accessory/penis/bee_tail/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/penis/penis = organ
	if(penis.erect_state == ERECT_STATE_NONE)
		return FALSE
	if(!owner || owner.get_taur_tail() || !..())
		return FALSE
	var/obj/item/organ/tail/tail = owner.getorganslot(ORGAN_SLOT_TAIL)
	if(!(tail?.accessory_type in list(/datum/sprite_accessory/tail/bee, /datum/sprite_accessory/tail/insect)) || !tail.is_visible())
		return FALSE
	var/datum/sprite_accessory/tail/tail_accessory = SPRITE_ACCESSORY(tail.accessory_type)
	return tail_accessory.is_visible(tail, null, owner)

/datum/sprite_accessory/penis/bee_tail/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	// Match the regular tail on its native 32px canvas.
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_UNDIES, OFFSET_UNDIES_F)

/// Legacy path retained for saved customizer entries; handles all supported insect bodies.
/datum/sprite_accessory/penis/ovipositor_ant
	icon = 'icons/mob/sprite_accessory/genitals/taur_ovipositors.dmi'
	icon_state = "taur_ovipositor_ant_small_base"
	name = "Ovipositor"
	color_keys = 1
	color_key_name = "Ovipositor"
	color_key_defaults = list(KEY_MUT_COLOR_ONE)
	/// Null until the immutable artwork has been checked once for this accessory.
	var/ovipositor_artwork_available

/datum/sprite_accessory/penis/ovipositor_ant/has_taur_artwork()
	if(!isnull(ovipositor_artwork_available))
		return ovipositor_artwork_available
	ovipositor_artwork_available = FALSE
	var/list/states = icon_states(icon)
	for(var/body_style in list("ant", "wasp", "spider"))
		for(var/size in SMALL_PENIS_SIZE to MAX_PENIS_SIZE)
			if(!(get_ovipositor_base_icon_state(size, body_style) in states))
				return FALSE
			if(!(get_ovipositor_top_icon_state(size, body_style) in states))
				return FALSE
	ovipositor_artwork_available = TRUE
	return TRUE

/datum/sprite_accessory/penis/ovipositor_ant/proc/get_ovipositor_base_icon_state(penis_size, body_style = "ant")
	var/size_name = penis_size <= SMALL_PENIS_SIZE ? "small" : (penis_size >= MAX_PENIS_SIZE ? "large" : "average")
	return "taur_ovipositor_[body_style]_[size_name]_base"

/datum/sprite_accessory/penis/ovipositor_ant/proc/get_ovipositor_top_icon_state(penis_size, body_style = "ant")
	var/size_name = penis_size <= SMALL_PENIS_SIZE ? "small" : (penis_size >= MAX_PENIS_SIZE ? "large" : "average")
	return "taur_ovipositor_[body_style]_[size_name]_up"

/datum/sprite_accessory/penis/ovipositor_ant/get_taur_icon_state(obj/item/organ/penis/penis)
	var/obj/item/bodypart/taur/taur = penis?.owner?.get_taur_tail()
	if(!penis?.penis_taur_mode || !taur?.supports_ovipositor)
		return null
	// Resolve body-specific artwork independently of arousal visibility.
	if(!has_taur_artwork())
		return null
	return get_ovipositor_base_icon_state(penis.penis_size, taur.ovipositor_sprite)

/datum/sprite_accessory/penis/ovipositor_ant/get_appearance(obj/item/organ/organ, obj/item/bodypart/bodypart, color_string)
	var/obj/item/organ/penis/penis = organ
	var/state = get_taur_icon_state(penis)
	if(!state || !is_visible(organ, bodypart, organ.owner))
		return null
	var/obj/item/bodypart/taur/taur = penis.owner.get_taur_tail()
	var/top_state = get_ovipositor_top_icon_state(penis.penis_size, taur.ovipositor_sprite)
	var/list/appearances = get_paired_overlay(state, top_state, color_string, -BODY_ADJ_LAYER + 0.1, -16)
	adjust_appearance_list(appearances, organ, bodypart, organ.owner)
	return appearances

/datum/sprite_accessory/penis/ovipositor_ant/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/penis/penis = organ
	if(!owner || penis.erect_state == ERECT_STATE_NONE)
		return FALSE
	return ..()

/datum/sprite_accessory/testicles
	icon = 'icons/mob/sprite_accessory/genitals/gonads.dmi'
	color_key_name = "Sack"
	relevant_layers = list(BODY_ADJ_LAYER, BODY_BEHIND_LAYER)
	var/static/taur_icon = 'icons/mob/sprite_accessory/genitals/taur_testicles_onmob.dmi'
	var/static/list/taur_icon_states
	var/static/list/taur_icon_cache = list()

/// Testicles share the owner's Penis Taur Mode, as in SPLURT.
/datum/sprite_accessory/testicles/proc/get_taur_icon_state(obj/item/organ/testicles/testes)
	if(!testes?.owner)
		return null
	var/obj/item/organ/penis/penis = testes.owner.getorganslot(ORGAN_SLOT_PENIS)
	if(!penis?.penis_taur_mode)
		return null
	var/obj/item/bodypart/taur/taur = testes.owner.get_taur_tail()
	if(!taur?.uses_taur_genital_sprites)
		return null
	var/state = "m_testicles_[icon_state]_[clamp(testes.ball_size, MIN_TESTICLES_SIZE, MAX_TESTICLES_SIZE)]_FRONT"
	if(!taur_icon_states)
		taur_icon_states = icon_states(taur_icon)
	if(state in taur_icon_states)
		return state
	return null

/datum/sprite_accessory/testicles/get_appearance(obj/item/organ/organ, obj/item/bodypart/bodypart, color_string)
	var/obj/item/organ/testicles/testes = organ
	var/state = get_taur_icon_state(testes)
	if(!state)
		return ..()
	if(!is_visible(organ, bodypart, organ.owner))
		return null
	color_string = sanitize_color_string(color_string)
	var/cache_key = "[state]-[color_string]"
	if(!taur_icon_cache[cache_key])
		var/list/colors = color_string_to_list(color_string)
		var/icon/colored_icon = icon(taur_icon, state)
		colored_icon.Blend(colors[1], ICON_MULTIPLY)
		taur_icon_cache[cache_key] = colored_icon
		trim_cache(taur_icon_cache, SPRITE_ACCESSORY_ICON_CACHE_LEN)
	var/mutable_appearance/appearance = mutable_appearance(taur_icon_cache[cache_key], layer = -BODY_FRONT_LAYER)
	appearance.pixel_x = -16
	var/list/appearances = list(appearance)
	adjust_appearance_list(appearances, organ, bodypart, organ.owner)
	return appearances

/datum/sprite_accessory/testicles/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT, OFFSET_BELT_F)
	adjust_taur_rear_layer(appearance_list, organ, owner)

/// Run after exposure/device layer adjustments, including the local modular override.
/datum/sprite_accessory/testicles/proc/adjust_taur_rear_layer(list/appearance_list, obj/item/organ/testicles/testes, mob/living/carbon/owner)
	var/obj/item/bodypart/taur/taur = owner?.get_taur_tail()
	if(!istype(taur, /obj/item/bodypart/taur/equine) || !get_taur_icon_state(testes))
		return
	// North sits below the tail; preserve an even lower device-imposed layer.
	var/mutable_appearance/appearance = appearance_list[1]
	set_north_appearance_layer(appearance_list, min(appearance.layer, -(BODY_ADJ_LAYER + 0.1)))

/datum/sprite_accessory/testicles/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/testicles/testes = organ
	return "[icon_state]_[testes.ball_size]"

/datum/sprite_accessory/testicles/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/penis/pp = owner.getorganslot(ORGAN_SLOT_PENIS)
	if(pp && pp.sheath_type == SHEATH_TYPE_SLIT)
		return FALSE
	if(owner.sexcon && owner.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(owner.underwear)
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDECROTCH)

/datum/sprite_accessory/testicles/pair
	name = "Pair"
	icon_state = "pair"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/breasts
	icon = 'icons/mob/sprite_accessory/genitals/breasts.dmi'
	color_key_name = "Breasts"
	relevant_layers = list(BODY_ADJ_LAYER, BODY_BEHIND_LAYER)
	var/can_jiggle = FALSE

/datum/sprite_accessory/breasts/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/breasts/badonkers = organ
	if(can_jiggle && owner && badonkers.is_jiggling)
		return "[icon_state]_[badonkers.breast_size]_jiggle"
	return "[icon_state]_[badonkers.breast_size]"

/datum/sprite_accessory/breasts/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BREASTS, OFFSET_BREASTS_F)

/datum/sprite_accessory/breasts/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.underwear && owner.underwear.covers_breasts)
		return FALSE
	return is_human_part_visible(owner, HIDEBOOB|HIDEJUMPSUIT)

/datum/sprite_accessory/breasts/pair
	icon_state = "pair"
	name = "Pair"
	color_key_defaults = list(KEY_CHEST_COLOR)
	can_jiggle = TRUE

/datum/sprite_accessory/breasts/quad
	icon_state = "quad"
	name = "Quad"
	color_key_defaults = list(KEY_CHEST_COLOR)
	can_jiggle = TRUE

/datum/sprite_accessory/breasts/sextuple
	icon_state = "sextuple"
	name = "Sextuple"
	color_key_defaults = list(KEY_CHEST_COLOR)
	can_jiggle = TRUE

/datum/sprite_accessory/breasts/pecs
	icon_state = "pecs"
	name = "Pecs"
	color_key_defaults = list(KEY_CHEST_COLOR)
	can_jiggle = TRUE

/datum/sprite_accessory/breasts/pecs/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/breasts/badonkers = organ
	if(can_jiggle && owner && badonkers.is_jiggling)
		return "[icon_state]_1_jiggle"
	return "[icon_state]_1"

/datum/sprite_accessory/breasts/pecs/nippleless
	name = "Pecs (Nippleless)"

/datum/sprite_accessory/breasts/pecs/nippleless/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/breasts/badonkers = organ
	if(can_jiggle && owner && badonkers.is_jiggling)
		return "[icon_state]_2_jiggle"
	return "[icon_state]_2"

/datum/sprite_accessory/vagina
	/// Taur rendering reverses the selected sprite's north/south visibility.
	var/static/list/taur_icon_cache = list()
	icon = 'icons/mob/sprite_accessory/genitals/nethers.dmi'
	color_key_name = "Nethers"
	relevant_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/vagina/get_appearance(obj/item/organ/organ, obj/item/bodypart/bodypart, color_string)
	var/obj/item/organ/vagina/vagina = organ
	if(!vagina?.owner?.get_taur_tail() || !vagina.vagina_taur_enabled)
		return ..()
	if(!is_visible(organ, bodypart, organ.owner))
		return null
	color_string = sanitize_color_string(color_string)
	var/cache_key = "[type]-[color_string]"
	if(!taur_icon_cache[cache_key])
		var/state = "[icon_state]_FRONT"
		var/icon/colored_icon = icon(icon, state)
		colored_icon.Insert(icon(icon, state, SOUTH), "", NORTH)
		colored_icon.Insert(icon(icon, state, NORTH), "", SOUTH)
		var/list/colors = color_string_to_list(color_string)
		colored_icon.Blend(colors[1], ICON_MULTIPLY)
		taur_icon_cache[cache_key] = colored_icon
		trim_cache(taur_icon_cache, SPRITE_ACCESSORY_ICON_CACHE_LEN)
	var/mutable_appearance/appearance = mutable_appearance(taur_icon_cache[cache_key], layer = -BODY_FRONT_LAYER)
	var/list/appearances = list(appearance)
	adjust_appearance_list(appearances, organ, bodypart, organ.owner)
	return appearances

/datum/sprite_accessory/vagina/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT, OFFSET_BELT_F)
	adjust_exposed_genital_layers(appearance_list, owner)
	var/obj/item/organ/vagina/vagina = organ
	if(!vagina?.vagina_taur_enabled || !istype(owner?.get_taur_tail(), /obj/item/bodypart/taur/equine))
		return
	var/mutable_appearance/appearance = appearance_list[1]
	set_north_appearance_layer(appearance_list, min(appearance.layer, -(BODY_ADJ_LAYER + 0.1)))

/datum/sprite_accessory/vagina/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!organ.is_visible_on_owner())
		return FALSE
	if(owner.sexcon && owner.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(owner.underwear)
		return FALSE
	return is_human_part_visible(owner, HIDECROTCH|HIDEJUMPSUIT)

/datum/sprite_accessory/vagina/human
	icon_state = "human"
	name = "Plain"
	default_colors = list("ea6767")

/datum/sprite_accessory/vagina/hairy
	icon_state = "hairy"
	name = "Hairy"
	color_key_defaults = list(KEY_HAIR_COLOR)

/datum/sprite_accessory/vagina/trimmed
	icon_state = "trimmed"
	name = "Trimmed"
	color_key_defaults = list(KEY_HAIR_COLOR)

/datum/sprite_accessory/vagina/spade
	icon_state = "spade"
	name = "Spade"
	default_colors = list("C52828")

/datum/sprite_accessory/vagina/furred
	icon_state = "furred"
	name = "Furred"
	color_key_defaults = list(KEY_MUT_COLOR_ONE)

/datum/sprite_accessory/vagina/gaping
	icon_state = "gaping"
	name = "Gaping"
	default_colors = list("f99696")

/datum/sprite_accessory/vagina/cloaca
	icon_state = "cloaca"
	name = "Cloaca"
	default_colors = list("f99696")

/datum/sprite_accessory/vagina/bee_tail
	icon = 'icons/mob/sprite_accessory/genitals/bee_tail_genitals.dmi'
	icon_state = "bee_tail_oviduct_normal"
	name = "Oviduct"
	color_key_defaults = list(KEY_MUT_COLOR_ONE)
	relevant_layers = null
	layer = BODY_FRONT_LAYER - 0.1

/datum/sprite_accessory/vagina/bee_tail/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/datum/sex_controller/controller = owner?.sexcon
	if(controller && (controller.manual_arousal == SEX_MANUAL_AROUSAL_FULL || (controller.manual_arousal == SEX_MANUAL_AROUSAL_DEFAULT && controller.arousal > 20)))
		return "bee_tail_oviduct_hard"
	return "bee_tail_oviduct_normal"

/datum/sprite_accessory/vagina/bee_tail/get_appearance(obj/item/organ/organ, obj/item/bodypart/bodypart, color_string)
	if(!organ.owner || !is_visible(organ, bodypart, organ.owner))
		return null
	// South draws behind the body; the other supplied directions retain their front layer.
	var/state = get_icon_state(organ, bodypart, organ.owner)
	var/list/appearances = get_overlay(state, color_string)
	var/list/behind_appearances = get_overlay("[state]_behind", color_string)
	for(var/mutable_appearance/appearance as anything in behind_appearances)
		appearance.layer = -BODY_BEHIND_LAYER
	appearances += behind_appearances
	adjust_appearance_list(appearances, organ, bodypart, organ.owner)
	return appearances

/datum/sprite_accessory/vagina/bee_tail/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_UNDIES, OFFSET_UNDIES_F)
