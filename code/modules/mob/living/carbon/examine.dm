/mob/living/carbon/examine(mob/user)
	var/t_He = p_they(TRUE)
	var/t_his = p_their()
	var/t_has = p_have()
	var/t_is = p_are()

	. = list("<span class='info'>✠ ------------ ✠\nThis is \a <EM>[src]</EM>!")
	var/list/obscured = check_obscured_slots()

	var/m1 = "[t_He] [t_is]"
	var/m2 = "[t_his]"
	var/m3 = "[t_He] [t_has]"
	if(user == src)
		m1 = "I am"
		m2 = "my"
		m3 = "I have"

	if (handcuffed)
		. += span_warning("[m1] tied up with \a [handcuffed]!")
	if (head)
		. += "[m3] [head.get_examine_string(user)] on [m2] head. "
	if(wear_mask && !(SLOT_WEAR_MASK in obscured))
		. += "[m3] [wear_mask.get_examine_string(user)] on [m2] face."
	if(wear_neck && !(SLOT_NECK in obscured))
		. += "[m3] [wear_neck.get_examine_string(user)] around [m2] neck."

	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			. += "[m1] holding [I.get_examine_string(user)] in [m2] [get_held_index_name(get_held_index_of_item(I))]."

	if (back)
		. += "[m3] [back.get_examine_string(user)] on [m2] back."
	var/appears_dead = 0
/*	if (stat == DEAD)
		appears_dead = 1
		if(getorgan(/obj/item/organ/brain))
			. += span_dead("[t_He] [t_is] limp and unresponsive, with no signs of life.")
		else if(get_bodypart(BODY_ZONE_HEAD))
			. += span_dead("It appears that [t_his] brain is missing...")*/

	var/list/missing = get_missing_limbs()
	for(var/t in missing)
		if(t==BODY_ZONE_HEAD)
			. += span_dead("<B>[capitalize(m2)] [parse_zone(t)] is gone.</B>")
			continue
		. += span_warning("<B>[capitalize(m2)] [parse_zone(t)] is gone.</B>")

	var/list/msg = list("<span class='warning'>")
	var/temp = getBruteLoss()
	if(!(user == src && src.hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
		var/brute_text = get_damage_descriptor_text(temp, "[m3] some bruises.\n", "[m3] a lot of bruises!\n", "<B>[m1] black and blue!!</B>\n")
		if(brute_text)
			msg += brute_text

		temp = getFireLoss()
		var/fire_text = get_damage_descriptor_text(temp, "[m3] some burns.\n", "[m3] many burns!\n", "<B>[m1] dragon food!!</B>\n")
		if(fire_text)
			msg += fire_text

		temp = getCloneLoss()
		if(temp)
			if(temp < 25)
				msg += "[t_He] [t_is] slightly deformed.\n"
			else if (temp < 50)
				msg += "[t_He] [t_is] <b>moderately</b> deformed!\n"
			else
				msg += "<b>[t_He] [t_is] severely deformed!</b>\n"

	if(HAS_TRAIT(src, TRAIT_DUMB))
		msg += "[t_He] seem[p_s()] to be clumsy and unable to think.\n"
	
	var/list/modular_lines = carbon_modular_examine_lines(user, t_He, m1, m2, m3)
	if(length(modular_lines))
		msg += modular_lines

	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks))
		msg += "[t_He] [t_is] covered in something flammable.\n"
	if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks))
		msg += "[t_He] look[p_s()] a little soaked.\n"

	if(pulledby && pulledby.grab_state)
		msg += "[m1] restrained by [pulledby]'s grip.\n"

	msg += "</span>"

	. += msg.Join("")

	if(!appears_dead)
		if(stat == UNCONSCIOUS)
			. += span_warning("[m1] unconscious.")
		else if(InCritical())
			. += span_warning("[m1] barely conscious.")
	if (stat == DEAD)
		appears_dead = 1
		. += span_warning("[m1] unconscious.")
	var/trait_exam = common_trait_examine()
	if (!isnull(trait_exam))
		. += trait_exam

	if(isliving(user))
		var/mob/living/L = user
		if(STASTR > L.STASTR)
			if(STASTR > 15)
				. += span_warning("[t_He] look[p_s()] stronger than I.")
			else
				. += span_warning("<B>[t_He] look[p_s()] stronger than I.</B>")

	. += "✠ ------------ ✠</span>"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

// Helper for generating damage description text based on thresholds, used by both examine and condition summary on cursed collar UI.
/mob/living/carbon/proc/get_damage_descriptor_text(damage_amount, minor_text, moderate_text, severe_text)
	if(!damage_amount)
		return null
	if(damage_amount < 25)
		return minor_text
	if(damage_amount < 50)
		return moderate_text
	return severe_text

/mob/living/carbon/proc/get_damage_condition_summary()
	var/list/conditions = list()

	var/brute_condition = get_damage_descriptor_text(getBruteLoss(), "some bruises", "a lot of bruises", "black and blue")
	if(brute_condition)
		conditions += brute_condition

	var/fire_condition = get_damage_descriptor_text(getFireLoss(), "some burns", "many burns", "dragon food")
	if(fire_condition)
		conditions += fire_condition

	if(!length(conditions))
		return "No obvious bruises or burns"

	return capitalize(jointext(conditions, "; "))

/mob/living/carbon/proc/carbon_modular_examine_lines(mob/user, t_He, m1, m2, m3)
	var/list/lines = list()
	var/list/ext_lines = carbon_modular_examine_extension(user, t_He, m1, m2, m3)
	if(length(ext_lines))
		lines += ext_lines
	return lines
