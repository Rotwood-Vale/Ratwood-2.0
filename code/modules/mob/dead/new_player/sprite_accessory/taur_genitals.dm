/datum/sprite_accessory/penis/taur
	abstract_type = /datum/sprite_accessory/penis/taur
	icon = 'icons/mob/sprite_accessory/genitals/taur_penis_onmob.dmi'
	pixel_x = -16
	relevant_layers = list(BODY_BEHIND_LAYER)
	color_key_names = list("Member", "Sheath / slit")
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)

/datum/sprite_accessory/penis/taur/knotted
	name = "Knotted"
	icon_state = "knotted"

/datum/sprite_accessory/penis/taur/flared
	name = "Flared"
	icon_state = "flared"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)
	default_colors = null

/datum/sprite_accessory/penis/taur/tapered
	name = "Tapered"
	icon_state = "tapered"

/datum/sprite_accessory/penis/taur/barbed
	name = "Barbed, Knotted"
	icon_state = "barbknot"

/datum/sprite_accessory/penis/taur/tentacle
	name = "Tentacled"
	icon_state = "tentacle"

/datum/sprite_accessory/testicles/taur
	name = "Pair"
	icon = 'icons/mob/sprite_accessory/genitals/taur_testicles_onmob.dmi'
	icon_state = "pair"
	pixel_x = -16
	relevant_layers = list(BODY_FRONT_LAYER)
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/testicles/taur/hidden
	name = "Hidden"
	icon = null
	color_keys = 0
	color_disabled = TRUE

/datum/sprite_accessory/testicles/taur/hidden/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return FALSE

/datum/sprite_accessory/penis/taur/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/penis/member = organ
	if(!isnum(member.penis_size) || member.penis_size != round(member.penis_size) || member.penis_size < MIN_PENIS_SIZE || member.penis_size > MAX_PENIS_SIZE)
		return null
	var/state
	if(member.erect_state != ERECT_STATE_HARD)
		switch(member.sheath_type)
			if(SHEATH_TYPE_NORMAL)
				state = "m_penis_sheath_[member.erect_state == ERECT_STATE_NONE ? 0 : 1]"
			if(SHEATH_TYPE_SLIT)
				state = "m_penis_slit_1"
	if(!state)
		state = "m_penis_[icon_state]_[member.get_sprite_size()]_[member.erect_state == ERECT_STATE_HARD ? 1 : 0]"
	var/obj/item/bodypart/taur/body = owner?.get_bodypart(BODY_ZONE_TAUR)
	var/placement = get_taur_penis_placement(body?.type)
	return placement ? "[placement]:[state]" : state

/datum/sprite_accessory/testicles/taur/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/testicles/testicles = organ
	if(!isnum(testicles.ball_size) || testicles.ball_size != round(testicles.ball_size) || testicles.ball_size < MIN_TESTICLES_SIZE || testicles.ball_size > MAX_TESTICLES_SIZE)
		return null
	return "m_testicles_pair_[testicles.ball_size]"

/datum/sprite_accessory/penis/taur/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	// Taur frames already include body-specific offsets.
	return

/datum/sprite_accessory/testicles/taur/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return

/datum/sprite_accessory/penis/taur/generate_icon_state(overlay_icon_state, color_list, passed_layer, suffix)
	var/separator = findtext(overlay_icon_state, ":")
	var/placement
	if(separator)
		placement = copytext(overlay_icon_state, 1, separator)
		overlay_icon_state = copytext(overlay_icon_state, separator + 1)
	var/state = "[overlay_icon_state]_[suffix]"
	var/icon/result = icon(icon, "[state]_primary")
	result.Blend(color_list[overlay_icon_state == "m_penis_slit_1" ? 2 : 1], ICON_MULTIPLY)
	if(findtext(overlay_icon_state, "m_penis_sheath_") == 1)
		var/icon/sheath = icon(icon, "[state]_secondary")
		sheath.Blend(color_list[2], ICON_MULTIPLY)
		result.Blend(sheath, ICON_OVERLAY)
	if(placement)
		var/icon/positioned = new
		var/result_state = icon_states(result)[1]
		for(var/direction in GLOB.cardinals)
			var/icon/frame = icon(result, result_state, direction)
			switch(placement)
				if("canine")
					frame.Shift(SOUTH, 2)
				if("deer")
					frame.Shift(NORTH, 2)
				if("sloog")
					// Move toward the tail and below the lower body in each side view.
					if(direction == EAST || direction == WEST)
						frame.Shift(REVERSE_DIR(direction), 6)
						frame.Shift(SOUTH, 2)
			positioned.Insert(frame, "", direction)
		result = positioned
	result.GetPixel(1, 1)
	return result

/// Identifies placements that require their own sprite frames and cache entries.
/proc/get_taur_penis_placement(taur_type)
	switch(taur_type)
		if(/obj/item/bodypart/taur/canine)
			return "canine"
		if(/obj/item/bodypart/taur/deer)
			return "deer"
		if(/obj/item/bodypart/taur/sloog)
			return "sloog"
	return null

/proc/uses_taur_genital_sprites(taur_type)
	var/static/list/supported_bodies = list(
		/obj/item/bodypart/taur/canine,
		/obj/item/bodypart/taur/deer,
		/obj/item/bodypart/taur/drake,
		/obj/item/bodypart/taur/dragon,
		/obj/item/bodypart/taur/feline,
		/obj/item/bodypart/taur/horse,
		/obj/item/bodypart/taur/kitsune,
		/obj/item/bodypart/taur/noodle,
		/obj/item/bodypart/taur/otie,
		/obj/item/bodypart/taur/rat,
		/obj/item/bodypart/taur/redpanda,
		/obj/item/bodypart/taur/skunk,
		/obj/item/bodypart/taur/sloog,
		/obj/item/bodypart/taur/snep,
		/obj/item/bodypart/taur/tiger,
		/obj/item/bodypart/taur/venard,
	)
	return taur_type in supported_bodies

/// Resolve only known visual equivalents. Unsupported forms keep their original art.
/// The stored accessory and its palette remain unchanged across transformations/transplants.
/proc/resolve_taur_genital_accessory(accessory_type, taur_type)
	var/static/list/equivalents = list(
		/datum/sprite_accessory/penis/knotted = /datum/sprite_accessory/penis/taur/knotted,
		/datum/sprite_accessory/penis/flared = /datum/sprite_accessory/penis/taur/flared,
		/datum/sprite_accessory/penis/tapered = /datum/sprite_accessory/penis/taur/tapered,
		/datum/sprite_accessory/penis/barbknot = /datum/sprite_accessory/penis/taur/barbed,
		/datum/sprite_accessory/penis/tentacle = /datum/sprite_accessory/penis/taur/tentacle,
		/datum/sprite_accessory/testicles/pair = /datum/sprite_accessory/testicles/taur,
	)
	if(uses_taur_genital_sprites(taur_type))
		if(accessory_type == /datum/sprite_accessory/penis/tapered_mammal)
			return /datum/sprite_accessory/penis/taur/tapered
		return equivalents[accessory_type] || accessory_type
	for(var/ordinary in equivalents)
		if(equivalents[ordinary] == accessory_type)
			return ordinary
	return accessory_type
