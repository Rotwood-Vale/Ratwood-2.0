/mob/living/carbon/human/proc/try_milking(mob/living/user, obj/item/reagent_containers/glass/container)
	if(!ishuman(src) || stat == DEAD)
		return
	if(!get_location_accessible(src, BODY_ZONE_CHEST))
		return

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
