/mob/living/carbon/human/proc/modular_handle_chastitything(mob/user)
	if(!user)
		return TRUE
	if(!get_location_accessible(src, BODY_ZONE_PRECISE_GROIN, grabs = FALSE, skipundies = TRUE))
		to_chat(user, span_warning("I can't reach that! Something is covering it."))
		return TRUE
	if(!chastity_device)
		return TRUE
	if(HAS_TRAIT(src, TRAIT_CHASTITY_LOCKED))
		to_chat(user, span_warning("I can't remove [src]'s chastity device while it's locked!"))
		return TRUE
	user.visible_message(span_warning("[user] starts removing [src]'s [chastity_device.name]."),span_warning("I start removing [src]'s [chastity_device.name]..."))
	if(do_after(user, 50, needhand = 1, target = src))
		var/obj/item/chastity/device = chastity_device
		if(!device)
			return TRUE
		device.remove_chastity(src)
		if(iscarbon(user))
			var/mob/living/carbon/carbon_user = user
			if(!carbon_user.put_in_hands(device))
				device.forceMove(get_turf(src))
		else
			device.forceMove(get_turf(src))
	return TRUE

/mob/living/carbon/human/proc/modular_handle_chastity_middleclick_strip(mob/user)
	if(!user)
		return TRUE

	if(chastity_device && chastity_device.locked)
		var/has_hammer = FALSE
		var/has_chisel = FALSE
		for(var/obj/item/held_item in user.held_items)
			if(istype(held_item, /obj/item/rogueweapon/hammer))
				has_hammer = TRUE
			if(istype(held_item, /obj/item/rogueweapon/chisel))
				has_chisel = TRUE
		if(has_hammer && has_chisel)
			var/obj/item/chastity/locked_device = chastity_device
			if(locked_device)
				locked_device.attempt_forced_removal(src, user)

	if(chastity_device && !chastity_device.locked)
		if(src == user)
			src.visible_message(span_notice("[user] begins to take off [chastity_device]..."))
		else
			src.visible_message(span_notice("[user] begins to take off [src]'s [chastity_device]..."))
		if(do_after(user, 30, needhand = 1, target = src))
			var/obj/item/chastity/device = chastity_device
			if(device)
				device.remove_chastity(src)
				if(!user.put_in_hands(device))
					device.forceMove(get_turf(src))

	return TRUE

/mob/living/carbon/human/proc/modular_strippanel_chastity_row()
	if(!get_location_accessible(src, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		return null
	var/chastity_action = "Nothing"
	if(chastity_device)
		if(HAS_TRAIT(src, TRAIT_CHASTITY_LOCKED))
			chastity_action = "Locked"
		else
			chastity_action = "Remove"
	var/chastity_row = "<tr><td><BR><B>Chastity:</B> <A href='?src=[REF(src)];chastitything=1'>"
	chastity_row += chastity_action
	chastity_row += "</A></td></tr>"
	return chastity_row

/mob/living/carbon/human/proc/modular_chastity_attached_toy_overlay()
	if(!istype(chastity_device?.attached_toy, /obj/item/dildo))
		return null

	var/mutable_appearance/mchastitydildo = mutable_appearance('modular/icons/obj/lewd/dildo.dmi', "dildo_belt_[chastity_device.attached_toy.dildo_size]", layer = -ABOVE_BODY_FRONT_LAYER)
	mchastitydildo.color = chastity_device.attached_toy.color

	if(dna && dna.species.sexes && !dna.species.custom_clothes)
		if(gender == MALE)
			if(OFFSET_BELT in dna.species.offset_features)
				mchastitydildo.pixel_x += dna.species.offset_features[OFFSET_BELT][1]
				mchastitydildo.pixel_y += dna.species.offset_features[OFFSET_BELT][2]
		else
			if(OFFSET_BELT_F in dna.species.offset_features)
				mchastitydildo.pixel_x += dna.species.offset_features[OFFSET_BELT_F][1]
				mchastitydildo.pixel_y += dna.species.offset_features[OFFSET_BELT_F][2]

	return mchastitydildo

/**
 * Called by toggle_extreme_ERP() (via hascall) when the player disables extreme ERP content.
 * If the player is currently wearing a spiked chastity device, it is forcibly removed and
 * dropped at their feet — spiked devices are extreme content and must not remain on a player
 * who has opted out of that category. Spiked status is determined by TRAIT_CHASTITY_SPIKED
 * being present in the device's chastity_standard_traits entry (the authoritative source).
 * Non-spiked devices are left undisturbed.
 */
/client/proc/modular_handle_extreme_erp_toggle_disable()
	if(!ishuman(mob))
		return
	var/mob/living/carbon/human/human_mob = mob
	var/obj/item/chastity/device = human_mob.chastity_device
	if(!device || !(TRAIT_CHASTITY_SPIKED in GLOB.chastity_standard_traits[device.chastity_type + 1]))
		return
	device.remove_chastity(human_mob)
	device.forceMove(get_turf(human_mob))
	human_mob.visible_message(span_notice("[human_mob]'s spiked chastity device falls away as the divine hand of Eora rejects the cruel ironwork."))

/client/proc/modular_handle_chastity_toggle_disable()
	if(!ishuman(mob))
		return
	var/mob/living/carbon/human/human_mob = mob
	var/obj/item/chastity/device = human_mob.chastity_device
	if(device)
		device.remove_chastity(human_mob)
		device.forceMove(get_turf(human_mob))
		human_mob.visible_message(span_notice("the divine hand of Eora slipped [device] free from [human_mob]'s loins!"))
