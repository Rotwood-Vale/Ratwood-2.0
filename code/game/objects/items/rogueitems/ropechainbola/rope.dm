/obj/item/rope
	name = "绳索"
	desc = "一条以麻编织成的绳子。"
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
	dropshrink = 0.9

/datum/intent/tie
	name = "捆绑"
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
		to_chat(user, span_warning("[C]没有手臂可绑。"))
		return

	if(C.cmode && C.mobility_flags & MOBILITY_STAND)
		to_chat(user, span_warning("我没法绑住他们，他们绷得太紧了！"))
		return

	var/surrender_mod = 1
	if(C.compliance || C.surrendering || HAS_TRAIT(C, TRAIT_BAGGED))
		surrender_mod = 0.5	

	C.visible_message(span_warning("[user]正试图用[src.name]绑住[C]的手臂！"), \
						span_userdanger("[user]正试图用[src.name]绑住我的手臂！"))
	playsound(loc, cuffsound, 100, TRUE, -2)

	if(!(do_mob(user, C, 60 * surrender_mod, double_progress = TRUE) && C.get_num_arms(FALSE)))
		to_chat(user, span_warning("我没能绑住[C]！"))
		return

	apply_cuffs(C, user)
	C.visible_message(span_warning("[user]用[src.name]绑住了[C]。"), \
						span_danger("[user]用[src.name]把我绑住了。"))
	SSblackbox.record_feedback("tally", "handcuffs", 1, type)
	log_combat(user, C, "绑住双手")

/obj/item/rope/proc/try_cuff_legs(mob/living/carbon/C, mob/living/user)
	if(C.legcuffed)
		return

	if(C.get_num_legs(FALSE) < 2)
		to_chat(user, span_warning("[C]缺少两条腿或一条腿。"))
		return

	if(C.cmode && C.mobility_flags & MOBILITY_STAND)
		to_chat(user, span_warning("我没法绑住他们，他们绷得太紧了！"))
		return

	var/surrender_mod = 1
	if(C.compliance || C.surrendering)
		surrender_mod = 0.5

	C.visible_message(span_warning("[user]正试图用[src.name]绑住[C]的双腿！"), \
						span_userdanger("[user]正试图用[src.name]绑住我的双腿！"))

	playsound(loc, cuffsound, 30, TRUE, -2)

	if(!do_mob(user, C, 60 * surrender_mod) || C.get_num_legs(FALSE) < 2)
		to_chat(user, span_warning("我没能绑住[C]！"))
		return

	apply_cuffs(C, user, TRUE)
	C.visible_message(span_warning("[user]用[src.name]绑住了[C]的双腿。"), \
						span_danger("[user]用[src.name]绑住了我的双腿。"))
	SSblackbox.record_feedback("tally", "legcuffs", 1, type)

	log_combat(user, C, "绑住双腿", TRUE)

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
