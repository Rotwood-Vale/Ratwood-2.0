/mob/living/carbon/human/proc/try_milking(mob/living/user, obj/item/reagent_containers/glass/container)
	if(!ishuman(src) || stat == DEAD)
		return
	if(!get_location_accessible(src, BODY_ZONE_CHEST))
		return

	// Constructs cannot be milked
	if(construct)
		to_chat(user, span_warning("[src] cannot be milked!"))
		return

	// Check if this is a deathless being with NO_HUNGER trait
	if(HAS_TRAIT(src, TRAIT_NOHUNGER))
		return try_blood_milking(user, container)

	var/obj/item/organ/breasts/B = has_breasts()
	if(!B)
		to_chat(user, span_warning("[src] cannot be milked!"))
		return
	if(!B.lactating)
		to_chat(user, span_warning("[src] does not seem to be producing milk."))
		return
	if(B.milk_stored < 1)
		to_chat(user, span_warning("[src] is out of milk!"))
		return

	if(container.reagents.total_volume < container.reagents.maximum_volume)

		var/size_limit = max(B.breast_size, 1)
		var/free_space = container.reagents.maximum_volume - container.reagents.total_volume
		var/milk_to_take = max(min(free_space, B.milk_stored, size_limit), 0)

		// Play milking sound before do_after
		playsound(get_turf(src), pick('modular/Creechers/sound/milking1.ogg', 'modular/Creechers/sound/milking2.ogg'), 100, TRUE, -1)

		if(!do_after(user, 20, target = src))
			return

		container.reagents.add_reagent(/datum/reagent/consumable/milk, milk_to_take)
		B.milk_stored -= milk_to_take
		user.visible_message(
			span_notice("[user] milks [p_themselves()] into \the [container]."),
			span_notice("I milk [(src == user) ? "myself" : src] into \the [container].")
		)
		user.sexcon.adjust_arousal(2)
		try_milking(user, container)
	else
		to_chat(user, span_warning("[container] is full."))

// Blood-to-milk conversion for deathless beings (revenants, vampires, etc. with TRAIT_NOHUNGER)
/mob/living/carbon/human/proc/try_blood_milking(mob/living/user, obj/item/reagent_containers/glass/container)
	// Check container space first
	if(container.reagents.total_volume >= container.reagents.maximum_volume)
		to_chat(user, span_warning("[container] is full."))
		return

	var/milk_produced = min(container.reagents.maximum_volume - container.reagents.total_volume, 10) // Produce 10 units of milk per attempt
	var/has_blood = blood_volume && blood_volume >= 20

	// Play milking sound
	playsound(get_turf(src), pick('modular/Creechers/sound/milking1.ogg', 'modular/Creechers/sound/milking2.ogg'), 100, TRUE, -1)

	if(!do_after(user, 20, target = src))
		return

	if(has_blood)
		// Consume blood to produce milk
		blood_volume = max(0, blood_volume - 20)
	else
		// No blood - take burn damage from life essence being drained
		adjustFireLoss(15)
	
	container.reagents.add_reagent(/datum/reagent/consumable/milk, milk_produced)
	user.visible_message(
		span_notice("[user] milks [src] into \the [container]."),
		span_notice("I milk [(src == user) ? "myself" : src] into \the [container].")
	)
	
	// Try to continue if there's still space (and either blood remains or willing to take more damage)
	if(container.reagents.total_volume < container.reagents.maximum_volume)
		if(has_blood && blood_volume >= 20)
			try_blood_milking(user, container)
		else if(!has_blood && stat != DEAD)
			// Can continue burning essence if not dead yet
			try_blood_milking(user, container)
