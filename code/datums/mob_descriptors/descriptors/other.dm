/datum/mob_descriptor/age
	name = "Age"
	slot = MOB_DESCRIPTOR_SLOT_AGE
	verbage = "%LOOK%"

/datum/mob_descriptor/age/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	return TRUE

/datum/mob_descriptor/age/get_description(mob/living/described)
	var/mob/living/carbon/human/H = described
	if(H.age == AGE_OLD)
		return "old"
	else if (H.age == AGE_MIDDLEAGED)
		return "middle-aged"
	else
		return "adult"

/datum/mob_descriptor/penis
	name = "penis"
	slot = MOB_DESCRIPTOR_SLOT_PENIS
	verbage = "has"
	show_obscured = TRUE
	descriptor_color = "#ff66cc"
	aroused_descriptor_color = "#ff5555"

/datum/mob_descriptor/penis/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
	if(!penis)
		return FALSE
	if(H.sexcon && H.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(H.underwear)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return TRUE

/datum/mob_descriptor/penis/get_description(mob/living/described)
	return get_description_for_watcher(described, null)

/datum/mob_descriptor/penis/get_description_for_watcher(mob/living/described, mob/watcher)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
	var/adjective
	var/arousal_modifier
	switch(penis.penis_size)
		if(1)
			adjective = "a small"
		if(2)
			adjective = "an average"
		if(3)
			adjective = "a large"
	if(H.sexcon)
		switch(H.sexcon.arousal)
			if(80 to INFINITY)
				arousal_modifier = ", throbbing violently"
			if(50 to 80)
				arousal_modifier = ", turgid and leaky"
			if(20 to 50)
				arousal_modifier = ", stiffened and twitching"
			else
				arousal_modifier = ", soft and flaccid"
	else
		arousal_modifier = ", soft and flaccid"
	var/used_name
	if(penis.erect_state != ERECT_STATE_HARD && penis.sheath_type != SHEATH_TYPE_NONE)
		switch(penis.sheath_type)
			if(SHEATH_TYPE_NORMAL)
				if(penis.penis_size == 3)
					used_name = "a fat sheath"
				else if(penis.penis_size == 1)
					used_name = "a meager sheath"
				else
					used_name = "a sheath"
			if(SHEATH_TYPE_SLIT)
				used_name = "a genital slit"
	else
		used_name = "[adjective] [penis.name][arousal_modifier]"
	var/branded = ""
	var/brand_text = ""
	if(length(penis.branded_writing))
		brand_text = penis.branded_writing
		if(penis.enslavement_mark)
			brand_text = "[brand_text], a mark of ownership"
	else if(penis.enslavement_mark)
		brand_text = "a mark of ownership"
	if(length(brand_text))
		branded = ", branded with <span style='font-size:150%;'>[span_boldwarning(brand_text)]</span>"
	var/base_description = "[used_name][branded]"
	var/obj/item/organ/testicles/testes = H.getorganslot(ORGAN_SLOT_TESTICLES)
	if(testes && penis.sheath_type != SHEATH_TYPE_SLIT)
		return base_description
	var/datum/mob_descriptor/pubes/pubes_descriptor = MOB_DESCRIPTOR(/datum/mob_descriptor/pubes)
	return pubes_descriptor.append_to_genital_description(base_description, H, watcher)

/datum/mob_descriptor/testicles
	name = "balls"
	slot = MOB_DESCRIPTOR_SLOT_TESTICLES
	verbage = "has"
	show_obscured = TRUE
	descriptor_color = "#ff66cc"
	aroused_descriptor_color = "#ff5555"

/datum/mob_descriptor/testicles/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/testicles/testes = H.getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
	if(penis && penis.sheath_type == SHEATH_TYPE_SLIT) //If our penis hides in a slit, dont describe testicles
		return FALSE
	if(!testes)
		return FALSE
	if(H.sexcon && H.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(H.underwear)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return TRUE

/datum/mob_descriptor/testicles/get_description(mob/living/described)
	return get_description_for_watcher(described, null)

/datum/mob_descriptor/testicles/get_description_for_watcher(mob/living/described, mob/watcher)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/testicles/testes = H.getorganslot(ORGAN_SLOT_TESTICLES)
	var/adjective
	switch(testes.ball_size)
		if(1)
			adjective = "a small"
		if(2)
			adjective = "an average"
		if(3)
			adjective = "a large"
	var/branded = ""
	var/brand_text = ""
	if(length(testes.branded_writing))
		brand_text = testes.branded_writing
		if(testes.enslavement_mark)
			brand_text = "[brand_text], a mark of ownership"
	else if(testes.enslavement_mark)
		brand_text = "a mark of ownership"
	if(length(brand_text))
		branded = ", branded with <span style='font-size:125%;'>[span_boldwarning(brand_text)]</span>"
	var/base_description = "[adjective] pair of balls[branded]"
	var/datum/mob_descriptor/pubes/pubes_descriptor = MOB_DESCRIPTOR(/datum/mob_descriptor/pubes)
	return pubes_descriptor.append_to_genital_description(base_description, H, watcher)

/datum/mob_descriptor/vagina
	name = "vagina"
	slot = MOB_DESCRIPTOR_SLOT_VAGINA
	verbage = "has"
	show_obscured = TRUE
	descriptor_color = "#ff66cc"
	aroused_descriptor_color = "#ff5555"

/datum/mob_descriptor/vagina/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
	if(!vagina)
		return FALSE
	if(H.sexcon && H.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(H.underwear)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return TRUE

/datum/mob_descriptor/vagina/get_description(mob/living/described)
	return get_description_for_watcher(described, null)

/datum/mob_descriptor/vagina/get_description_for_watcher(mob/living/described, mob/watcher)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
	var/vagina_type
	var/arousal_modifier
	switch(vagina.accessory_type)
		if(/datum/sprite_accessory/vagina/human)
			vagina_type = "plain vagina"
		if(/datum/sprite_accessory/vagina/hairy)
			vagina_type = "hairy vagina"
		if(/datum/sprite_accessory/vagina/trimmed)
			vagina_type = "trimmed vagina"
		if(/datum/sprite_accessory/vagina/spade)
			vagina_type = "spade vagina"
		if(/datum/sprite_accessory/vagina/furred)
			vagina_type = "furred vagina"
		if(/datum/sprite_accessory/vagina/gaping)
			vagina_type = "gaping vagina"
		if(/datum/sprite_accessory/vagina/cloaca)
			vagina_type = "cloaca"
	switch(H.sexcon.arousal)
		if(80 to INFINITY)
			arousal_modifier = ", gushing with arousal"
		if(50 to 80)
			arousal_modifier = ", slickened with arousal"
		if(20 to 50)
			arousal_modifier = ", wet with arousal"
	var/branded = ""
	var/brand_text = ""
	if(length(vagina.branded_writing))
		brand_text = vagina.branded_writing
		if(vagina.enslavement_mark)
			brand_text = "[brand_text], a mark of ownership"
	else if(vagina.enslavement_mark)
		brand_text = "a mark of ownership"
	if(length(brand_text))
		branded = ", branded with <span style='font-size:125%;'>[span_boldwarning(brand_text)]</span>"
	var/base_description = "a [vagina_type][arousal_modifier][branded]"
	if(H.getorganslot(ORGAN_SLOT_PENIS) || H.getorganslot(ORGAN_SLOT_TESTICLES))
		return base_description
	var/datum/mob_descriptor/pubes/pubes_descriptor = MOB_DESCRIPTOR(/datum/mob_descriptor/pubes)
	return pubes_descriptor.append_to_genital_description(base_description, H, watcher)

/datum/mob_descriptor/breasts
	name = "breasts"
	slot = MOB_DESCRIPTOR_SLOT_BREASTS
	verbage = "has"
	show_obscured = TRUE
	descriptor_color = "#ff66cc"
	aroused_descriptor_color = "#ff5555"

/datum/mob_descriptor/breasts/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
	if(!breasts)
		return FALSE
	if(H.underwear && H.underwear.covers_breasts)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_CHEST))
		return FALSE
	return TRUE

/datum/mob_descriptor/breasts/get_description(mob/living/described)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
	var/adjective
	switch(breasts.breast_size)
		if(0)
			adjective = "a flat chest"
		if(1)
			adjective = "a slight"
		if(2)
			adjective = "a small"
		if(3)
			adjective = "a moderate"
		if(4)
			adjective = "a large"
		if(5)
			adjective = "a generous"
		if(6)
			adjective = "a heavy"
		if(7)
			adjective = "a massive"
		if(8)
			adjective = "a heaping"
		if(9)
			adjective = "an obscene"
		if(10)
			adjective = "a backbreaking"
		if(11)
			adjective = "a stomach-hiding"
		if(12)
			adjective = "a torso-sized"
	var/branded = ""
	var/brand_text = ""
	if(length(breasts.branded_writing))
		brand_text = breasts.branded_writing
		if(breasts.enslavement_mark)
			brand_text = "[brand_text], a mark of ownership"
	else if(breasts.enslavement_mark)
		brand_text = "a mark of ownership"
	if(length(brand_text))
		branded = ", branded with <span style='font-size:125%;'>[span_boldwarning(brand_text)]</span>"
	if(breasts.breast_size == 0)
		return "[adjective][branded]"
	return "[adjective] pair of breasts[branded]"

/datum/mob_descriptor/pubes
	name = "pubes"
	slot = MOB_DESCRIPTOR_SLOT_PUBES
	verbage = "has"
	show_obscured = TRUE

/datum/mob_descriptor/pubes/proc/get_pubes_feature(mob/living/carbon/human/H)
	var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		return
	var/datum/bodypart_feature/pubes/feature = H.get_bodypart_feature_of_slot(BODYPART_FEATURE_PUBES)
	return feature

/datum/mob_descriptor/pubes/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/datum/bodypart_feature/pubes/feature = get_pubes_feature(H)
	if(!feature?.accessory_type)
		return FALSE
	if(H.sexcon && H.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(H.underwear)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return is_human_part_visible(H, HIDEJUMPSUIT|HIDECROTCH)

/datum/mob_descriptor/pubes/can_user_see(mob/living/described, mob/user)
	var/datum/preferences/viewer_preferences = user?.client?.prefs
	return !viewer_preferences || viewer_preferences.pubes

/datum/mob_descriptor/pubes/get_description(mob/living/described)
	return get_description_for_watcher(described, null)

/datum/mob_descriptor/pubes/get_description_for_watcher(mob/living/described, mob/watcher)
	var/mob/living/carbon/human/H = described
	var/datum/bodypart_feature/pubes/feature = get_pubes_feature(H)
	if(!feature?.accessory_type)
		return
	var/material_description = feature.get_description_name()
	var/list/accessory_colors = color_string_to_list(feature.accessory_colors)
	var/description_color = LAZYACCESS(accessory_colors, 1)
	if(description_color && user_allows_descriptor_color(watcher))
		description_color = sanitize_hexcolor(description_color, 6, TRUE, "#FFFFFF")
		material_description = "<span style='color:[description_color]'>[material_description]</span>"
	var/adjective
	switch(feature.accessory_type)
		if(/datum/sprite_accessory/pubes/hairy)
			adjective = "a dense bushel of [material_description]"
		if(/datum/sprite_accessory/pubes/trim)
			adjective = "[material_description] manicured neatly save for some wayward stubble"
		if(/datum/sprite_accessory/pubes/strip)
			adjective = "[material_description] shaved bare save for an inviting strip"
		if(/datum/sprite_accessory/pubes/heart)
			adjective = "a heart shaped mound of [material_description]"
		if(/datum/sprite_accessory/pubes/extreme)
			adjective = "a luridly unkempt jungle of [material_description]"
		if(/datum/sprite_accessory/pubes/cross)
			adjective ="[material_description] shaved into the shape of the Psycross"
		else//someone add more bush sprites but they forget to set the examine text? Just default to our descriptor name.
			adjective ="[material_description]"
	return "[adjective]"

/// The genital descriptor calling this proc already owns the visibility check.
/datum/mob_descriptor/pubes/proc/append_to_genital_description(base_description, mob/living/carbon/human/H, mob/watcher)
	if(!base_description)
		return base_description
	if(!can_user_see(H, watcher))
		return base_description
	var/pubes_description = get_description_for_watcher(H, watcher)
	if(!pubes_description)
		return base_description
	return "[base_description], framed by [pubes_description]"//we use pube_description and not just adjective so we can have the colors seperate

/datum/mob_descriptor/pits
	name = "armpits"
	slot = MOB_DESCRIPTOR_SLOT_PITS
	verbage = "has"
	show_obscured = TRUE

/datum/mob_descriptor/pits/proc/get_pits_feature(mob/living/carbon/human/H)
	var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		return
	var/datum/bodypart_feature/pits/feature = H.get_bodypart_feature_of_slot(BODYPART_FEATURE_PITS)
	return feature

/datum/mob_descriptor/pits/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/datum/bodypart_feature/pits/feature = get_pits_feature(H)
	if(!feature?.accessory_type)
		return FALSE
	if(H.underwear && H.underwear.covers_breasts)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_CHEST))
		return FALSE
	return is_human_part_visible(H, HIDEBOOB|HIDEJUMPSUIT)

/datum/mob_descriptor/pits/can_user_see(mob/living/described, mob/user)
	var/datum/preferences/viewer_preferences = user?.client?.prefs
	return !viewer_preferences || viewer_preferences.pits

/datum/mob_descriptor/pits/get_description(mob/living/described)
	return get_description_for_watcher(described, null)

/datum/mob_descriptor/pits/get_description_for_watcher(mob/living/described, mob/watcher)
	var/mob/living/carbon/human/H = described
	var/datum/bodypart_feature/pits/feature = get_pits_feature(H)
	if(!feature?.accessory_type)
		return
	var/material_description = feature.get_description_name()
	var/list/accessory_colors = color_string_to_list(feature.accessory_colors)
	var/description_color = LAZYACCESS(accessory_colors, 1)
	if(description_color && user_allows_descriptor_color(watcher))
		description_color = sanitize_hexcolor(description_color, 6, TRUE, "#FFFFFF")
		material_description = "<span style='color:[description_color]'>[material_description]</span>"
	var/adjective
	switch(feature.accessory_type)
		if(/datum/sprite_accessory/pits/trim)
			adjective = "a trim, prickly spatter of"
		if(/datum/sprite_accessory/pits/moderate)
			adjective = "a few wispy strands of"
		if(/datum/sprite_accessory/pits/hairy)
			adjective = "a dense bush of"
		if(/datum/sprite_accessory/pits/extreme)
			adjective = "an utterly unkempt jungle of"
		else
			adjective = "an average crop of"
	return "[adjective] [material_description]"
