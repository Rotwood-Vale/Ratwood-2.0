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
				else
					used_name = "a sheath"
			if(SHEATH_TYPE_SLIT)
				used_name = "a genital slit"
	else
		used_name = "[adjective] [penis.name][arousal_modifier]"
	var/branded = ""
	if(length(penis.branded_writing))
		branded = ", branded with <span style='font-size:125%;'>[span_boldwarning(penis.branded_writing)]</span>"
	return "[used_name][branded]"

/datum/mob_descriptor/testicles
	name = "balls"
	slot = MOB_DESCRIPTOR_SLOT_TESTICLES
	verbage = "has"
	show_obscured = TRUE

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
	if(length(testes.branded_writing))
		branded = ", branded with <span style='font-size:125%;'>[span_boldwarning(testes.branded_writing)]</span>"
	return "[adjective] pair of balls[branded]"

/datum/mob_descriptor/vagina
	name = "vagina"
	slot = MOB_DESCRIPTOR_SLOT_VAGINA
	verbage = "has"
	show_obscured = TRUE

/datum/mob_descriptor/vagina/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
	if(!vagina)
		return FALSE
	if(H.underwear)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return TRUE

/datum/mob_descriptor/vagina/get_description(mob/living/described)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
	var/vagina_type
	var/arousal_modifier
	switch(vagina.accessory_type)
		if(/datum/sprite_accessory/vagina/human)
			vagina_type = "plain vagina"
		if(/datum/sprite_accessory/vagina/hairy)
			vagina_type = "hairy vagina"
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
	if(length(vagina.branded_writing))
		branded = ", branded with <span style='font-size:125%;'>[span_boldwarning(vagina.branded_writing)]</span>"
	return "a [vagina_type][arousal_modifier][branded]"

/datum/mob_descriptor/breasts
	name = "breasts"
	slot = MOB_DESCRIPTOR_SLOT_BREASTS
	verbage = "has"
	show_obscured = TRUE

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
	if(length(breasts.branded_writing))
		branded = ", branded with <span style='font-size:125%;'>[span_boldwarning(breasts.branded_writing)]</span>"
	if(breasts.breast_size == 0)
		return "[adjective][branded]" 
	return "[adjective] pair of breasts[branded]"
