/obj/item
	var/allow_self_unequip = TRUE
	/// If TRUE, this item will always appear as a clickable link in examine, even without a custom name or description.
	var/always_show_examine_link = FALSE

/obj/item/allow_attack_hand_drop(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/C = user

		if(!(src in C.held_items) && !allow_self_unequip)
			to_chat(C, span_warning("我得找人帮忙把这东西脱下来！"))
			return FALSE

		if(!(src in C.held_items) && unequip_delay_self)
			if(unequip_delay_self >= 10)
				C.visible_message(span_smallnotice("[C]开始脱下[src]……"), span_smallnotice("我开始脱下[src]……"))
			if(edelay_type)
				if(move_after(C, minone(unequip_delay_self-C.STASPD), target = C))
					return TRUE
				else
					to_chat(C, span_warning("我费了好大劲也脱不下来。"))
					return FALSE
			else
				if(do_after(C, minone(unequip_delay_self-C.STASPD), target = C))
					return TRUE
				else
					to_chat(C, span_warning("我费了好大劲也脱不下来。"))
					return FALSE

	return ..()

/obj/item/MouseDrop(atom/over)
	if(!(loc == usr))
		return ..()

	if(ishuman(usr))
		var/mob/living/carbon/human/C = usr

		if(!(src in C.held_items) && (!allow_self_unequip || HAS_TRAIT(C, TRAIT_CHUNKYFINGERS))) //Zombie fingers don't take things off.
			to_chat(C, span_warning("我得找人帮忙把这东西脱下来！"))
			return FALSE

		if(!(src in C.held_items) && unequip_delay_self)
			if(unequip_delay_self >= 10)
				C.visible_message(span_smallnotice("[C]开始脱下[src]……"), span_smallnotice("我开始脱下[src]……"))
			if(edelay_type)
				if(move_after(C, minone(unequip_delay_self-C.STASPD), target = C))
					return ..()
				else
					to_chat(C, span_warning("我费了好大劲也脱不下来。"))
					return FALSE
			else
				if(do_after(C, minone(unequip_delay_self-C.STASPD), target = C))
					return ..()
				else
					to_chat(C, span_warning("我费了好大劲也脱不下来。"))
					return FALSE

	return ..()

/obj/item/clothing/MouseDrop(atom/over)
	if(!(loc == usr))
		return ..()

	if(ishuman(usr))
		var/mob/living/carbon/human/C = usr

		if(!(src in C.held_items) && !allow_self_unequip)
			to_chat(C, span_warning("我得找人帮忙把这东西脱下来！"))
			return FALSE

		if(!(src in C.held_items) && unequip_delay_self)
			if(unequip_delay_self >= 10)
				C.visible_message(span_smallnotice("[C]开始脱下[src]……"), span_smallnotice("我开始脱下[src]……"))
			if(edelay_type)
				if(move_after(C, minone(unequip_delay_self-C.STASPD), target = C))
					return ..()
				else
					to_chat(C, span_warning("我费了好大劲也脱不下来。"))
					return FALSE
			else
				if(do_after(C, minone(unequip_delay_self-C.STASPD), target = C))
					return ..()
				else
					to_chat(C, span_warning("我费了好大劲也脱不下来。"))
					return FALSE

	return ..()
