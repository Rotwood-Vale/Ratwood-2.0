/obj/item/rope
	name = "rope"
	desc = "A woven hemp rope."
	gender = PLURAL
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "rope"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 1
	throw_range = 3
	breakouttime = 5 SECONDS
	slipouttime = 1 MINUTES
	var/cuffsound = 'sound/blank.ogg'
	possible_item_intents = list(/datum/intent/tie)
	firefuel = 5 MINUTES
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	grid_width = 32
	grid_height = 64
	nudist_approved = TRUE

/datum/intent/tie
	name = "tie"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0

/obj/item/rope/Destroy()
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		if(M.handcuffed == src)
			M.handcuffed = null
			M.update_handcuffed()
			if(M.buckled && M.buckled.buckle_requires_restraints)
				M.buckled.unbuckle_mob(M)
		if(M.legcuffed == src)
			M.legcuffed = null
			M.update_inv_legcuffed()
	return ..()

/obj/item/rope/dropped(mob/user, silent)
	user.remove_movespeed_modifier(MOVESPEED_ID_CUFFED_LEG_SLOWDOWN)
	. = ..()

/obj/item/rope/attack(mob/living/carbon/C, mob/living/user)
	if(user.used_intent.type != /datum/intent/tie)
		..()
		return

	if(!istype(C))
		return

	if(user.aimheight > 4)
		try_cuff_arms(C, user)
		return

	if(user.aimheight <= 4)
		try_cuff_legs(C, user)
		return

/obj/item/rope/proc/try_cuff_arms(mob/living/carbon/C, mob/living/user)
	if(C.handcuffed)
		return

	if(!(C.get_num_arms(FALSE) || C.get_arm_ignore()))
		to_chat(user, span_warning("[C] has no arms to tie up."))
		return

	if(C.cmode && C.mobility_flags & MOBILITY_STAND)
		to_chat(user, span_warning("I can't tie them, they are too tense!"))
		return

	var/surrender_mod = 1
	if(C.compliance || C.surrendering || HAS_TRAIT(C, TRAIT_BAGGED))
		surrender_mod = 0.5	

	C.visible_message(span_warning("[user] is trying to tie [C]'s arms with [src.name]!"), \
						span_userdanger("[user] is trying to tie my arms with [src.name]!"))
	playsound(loc, cuffsound, 100, TRUE, -2)

	if(!(do_mob(user, C, 60 * surrender_mod, double_progress = TRUE) && C.get_num_arms(FALSE)))
		to_chat(user, span_warning("I fail to tie up [C]!"))
		return

	apply_cuffs(C, user)
	C.visible_message(span_warning("[user] ties [C] with [src.name]."), \
						span_danger("[user] ties me up with [src.name]."))
	SSblackbox.record_feedback("tally", "handcuffs", 1, type)
	log_combat(user, C, "handcuffed")

/obj/item/rope/proc/try_cuff_legs(mob/living/carbon/C, mob/living/user)
	if(C.legcuffed)
		return

	if(C.get_num_legs(FALSE) < 2)
		to_chat(user, span_warning("[C] is missing two or one legs."))
		return

	if(C.cmode && C.mobility_flags & MOBILITY_STAND)
		to_chat(user, span_warning("I can't tie them, they are too tense!"))
		return

	var/surrender_mod = 1
	if(C.compliance || C.surrendering)
		surrender_mod = 0.5

	C.visible_message(span_warning("[user] is trying to tie [C]'s legs with [src.name]!"), \
						span_userdanger("[user] is trying to tie my legs with [src.name]!"))

	playsound(loc, cuffsound, 30, TRUE, -2)

	if(!do_mob(user, C, 60 * surrender_mod) || C.get_num_legs(FALSE) < 2)
		to_chat(user, span_warning("I fail to tie up [C]!"))
		return

	apply_cuffs(C, user, TRUE)
	C.visible_message(span_warning("[user] ties [C]'s legs with [src.name]."), \
						span_danger("[user] ties my legs with [src.name]."))
	SSblackbox.record_feedback("tally", "legcuffs", 1, type)

	log_combat(user, C, "legcuffed", TRUE)

/obj/item/rope/proc/apply_cuffs(mob/living/carbon/target, mob/user, leg = FALSE)
	if(!leg)
		if(target.handcuffed)
			return

		if(!user.temporarilyRemoveItemFromInventory(src) )
			return

		var/obj/item/cuffs = src

		cuffs.forceMove(target)
		target.handcuffed = cuffs

		target.update_handcuffed()
		return
	else
		if(target.legcuffed)
			return

		if(!user.temporarilyRemoveItemFromInventory(src) )
			return

		var/obj/item/cuffs = src

		cuffs.forceMove(target)
		target.legcuffed = cuffs

		target.update_inv_legcuffed()
		target.add_movespeed_modifier(MOVESPEED_ID_CUFFED_LEG_SLOWDOWN, update=TRUE, priority=100, multiplicative_slowdown=2, movetypes=GROUND)
		return

/// Necran cordage — blessed burial-cordage.
/// Binds the dead and undead much faster, and doesn't slow the user when dragging them.
/// Living targets require being prone on the ground AND aggressively grabbed.
/obj/item/rope/necran_cord
	name = "burial-cordage"
	desc = "A length of cord woven from burial linen and blessed by Necra's rites. The dead yield to it without struggle."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "inqcordage"
	item_state = "inqcordage"
	breakouttime = 8 SECONDS
	slipouttime = 900
	light_system = STATIC_LIGHT
	light_power = 1
	light_outer_range = 1.5
	light_color = "#e8f4ff"
	cuffsound = 'sound/misc/cordage.ogg'

/obj/item/rope/necran_cord/Initialize(mapload)
	. = ..()
	set_light(1.5, 0.4, 1.5, l_color = light_color)
	add_filter("necran_cord_glow", 2, list("type" = "outline", "color" = "#f5fbff", "alpha" = 70, "size" = 1))

/obj/item/rope/necran_cord/Destroy()
	remove_filter("necran_cord_glow")
	return ..()

/obj/item/rope/necran_cord/proc/can_bind_target(mob/living/carbon/C, mob/living/user)
	if(C.pulledby == user && user.grab_state >= GRAB_AGGRESSIVE)
		return TRUE
	to_chat(user, span_warning("I need [C] in an aggressive grab to bind them with this cord."))
	return FALSE

/obj/item/rope/necran_cord/proc/get_bind_time(mob/living/carbon/C, mob/living/user)
	var/surrender_mod = 1
	if(C.compliance || C.surrendering || HAS_TRAIT(C, TRAIT_BAGGED))
		surrender_mod = 0.5
	var/bind_time = 60 * surrender_mod
	if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		bind_time *= 0.5
	return bind_time

/obj/item/rope/necran_cord/try_cuff_arms(mob/living/carbon/C, mob/living/user)
	if(C.handcuffed)
		return
	if(!(C.get_num_arms(FALSE) || C.get_arm_ignore()))
		to_chat(user, span_warning("[C] has no arms to tie up."))
		return
	if(!can_bind_target(C, user))
		return
	C.visible_message(span_warning("[user] is trying to bind [C]'s arms with [src.name]!"), \
						span_userdanger("[user] is trying to bind my arms with [src.name]!"))
	playsound(loc, cuffsound, 100, TRUE, -2)
	if(!(do_mob(user, C, get_bind_time(C, user), double_progress = TRUE) && C.get_num_arms(FALSE)))
		to_chat(user, span_warning("I fail to tie up [C]!"))
		return
	apply_cuffs(C, user)
	C.visible_message(span_warning("[user] ties [C] with [src.name]."), \
						span_danger("[user] ties me up with [src.name]."))
	SSblackbox.record_feedback("tally", "handcuffs", 1, type)
	log_combat(user, C, "handcuffed")

/obj/item/rope/necran_cord/try_cuff_legs(mob/living/carbon/C, mob/living/user)
	if(C.legcuffed)
		return
	if(C.get_num_legs(FALSE) < 2)
		to_chat(user, span_warning("[C] is missing two or one legs."))
		return
	if(!can_bind_target(C, user))
		return
	C.visible_message(span_warning("[user] is trying to bind [C]'s legs with [src.name]!"), \
						span_userdanger("[user] is trying to bind my legs with [src.name]!"))
	playsound(loc, cuffsound, 30, TRUE, -2)
	if(!do_mob(user, C, get_bind_time(C, user)) || C.get_num_legs(FALSE) < 2)
		to_chat(user, span_warning("I fail to tie up [C]!"))
		return
	apply_cuffs(C, user, TRUE)
	C.visible_message(span_warning("[user] ties [C]'s legs with [src.name]."), \
						span_danger("[user] ties my legs with [src.name]."))
	SSblackbox.record_feedback("tally", "legcuffs", 1, type)
	log_combat(user, C, "legcuffed", TRUE)

/obj/item/rope/necran_cord/apply_cuffs(mob/living/carbon/target, mob/user, leg = FALSE)
	if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		src.breakouttime = 25
		src.slipouttime = 30 SECONDS
	else
		src.breakouttime = initial(breakouttime)
		src.slipouttime = initial(slipouttime)
	src.strip_delay = get_bind_time(target, user)
	. = ..()
	if(leg && HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		target.remove_movespeed_modifier(MOVESPEED_ID_CUFFED_LEG_SLOWDOWN)
