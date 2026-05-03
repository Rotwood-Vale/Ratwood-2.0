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
			span_notice("[user] milks [(src == user) ? p_themselves() : src] into \the [container]."),
			span_notice("I milk [(src == user) ? "myself" : src] into \the [container].")
		)
		src?.sexcon?.adjust_arousal(2)
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
		span_notice("[user] milks [(src == user) ? p_themselves() : src] into \the [container]."),
		span_notice("I milk [(src == user) ? "myself" : src] into \the [container].")
	)
	
	// Try to continue if there's still space (and either blood remains or willing to take more damage)
	if(container.reagents.total_volume < container.reagents.maximum_volume)
		if(has_blood && blood_volume >= 20)
			try_blood_milking(user, container)
		else if(!has_blood && stat != DEAD)
			// Can continue burning essence if not dead yet
			try_blood_milking(user, container)

// Collect blood from open, non-fracture bleeding wounds on the targeted bodypart
/mob/living/carbon/human/proc/try_wound_bloodcollect(mob/living/user, obj/item/reagent_containers/glass/container)
	if(stat == DEAD)
		to_chat(user, span_warning("[src] is dead!"))
		return

	if(container.reagents.holder_full())
		to_chat(user, span_warning("[container] is already full."))
		return

	var/obj/item/bodypart/targeted_bp = get_bodypart(user.zone_selected)
	if(!targeted_bp)
		to_chat(user, span_warning("I can't reach that."))
		return

	// Gather all open, non-fracture bleeding wounds
	var/list/bleeding_wounds = list()
	for(var/datum/wound/W in targeted_bp.wounds)
		if(!istype(W, /datum/wound/fracture) && W.bleed_rate > 0)
			bleeding_wounds += W

	if(!bleeding_wounds.len)
		to_chat(user, span_warning("There is no open bleeding wound there to collect from."))
		return

	// Calculate how much blood to draw this tick
	// Artery wounds at normal bleed_rate; other wounds at 1.5x
	var/transfer_amount = 0
	for(var/datum/wound/W in bleeding_wounds)
		if(istype(W, /datum/wound/artery))
			transfer_amount += W.bleed_rate
		else
			transfer_amount += W.bleed_rate * 1.5
	transfer_amount = round(transfer_amount, 0.1)

	if(!do_after(user, 1 SECONDS, target = src))
		return

	// Re-verify after the delay
	if(stat == DEAD || !targeted_bp || !targeted_bp.wounds.len)
		return

	var/still_bleeding = FALSE
	for(var/datum/wound/W in targeted_bp.wounds)
		if(!istype(W, /datum/wound/fracture) && W.bleed_rate > 0)
			still_bleeding = TRUE
			break
	if(!still_bleeding)
		to_chat(user, span_warning("The wound has stopped bleeding."))
		return

	if(container.reagents.holder_full())
		to_chat(user, span_warning("[container] is now full."))
		return

	var/space_left = container.reagents.maximum_volume - container.reagents.total_volume
	var/actual_transfer = min(transfer_amount, space_left)

	transfer_blood_to(container, actual_transfer)

	user.visible_message(
		span_notice("[user] collects blood from [src]'s [targeted_bp.name] into \the [container]."),
		span_notice("I collect blood from [(src == user) ? "my" : "[src]'s"] [targeted_bp.name] into \the [container].")
	)

	// Continue collecting if there is still space and still bleeding
	if(container.reagents.total_volume < container.reagents.maximum_volume)
		try_wound_bloodcollect(user, container)
