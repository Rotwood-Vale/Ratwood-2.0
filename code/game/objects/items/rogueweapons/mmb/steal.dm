#define PICKPOCKET_FUMBLE_FLOOR    -6
#define PICKPOCKET_NEARFAIL_CEIL    5
#define PICKPOCKET_MIDDLING_CEIL   10
#define PICKPOCKET_SHAKE_CEIL      17

/mob/living/carbon/human/proc/get_pickpocket_skill()
	return get_skill_level(/datum/skill/misc/stealing) + (has_world_trait(/datum/world_trait/matthios_fingers) ? 1 : 0)

/obj/item/proc/get_pickpocket_difficulty(is_belt = FALSE)
	return max(0, (w_class - WEIGHT_CLASS_NORMAL)) * 8

/obj/item/roguekey/get_pickpocket_difficulty(is_belt = FALSE)
	. = ..()
	. += 25
	if(is_belt)
		. += 20

/obj/item/storage/keyring/get_pickpocket_difficulty(is_belt = FALSE)
	. = ..()
	. += 25
	if(is_belt)
		. += 20

/mob/living/carbon/human/proc/pickpocket_extract_chance(obj/item/I, is_belt = FALSE)
	return clamp(45 + (get_pickpocket_skill() * 9) - I.get_pickpocket_difficulty(is_belt), 5, 100)

/mob/living/carbon/human/proc/pickpocket_feedback(mob/living/carbon/human/victim, margin, atom/movable/jostled)
	if(margin < PICKPOCKET_SHAKE_CEIL && jostled)
		var/matrix/old_matrix = jostled.transform
		animate(jostled, time = 1.5, loop = 0, transform = jostled.transform.Scale(1.07, 0.9))
		animate(time = 2, transform = old_matrix)
	if(margin < PICKPOCKET_NEARFAIL_CEIL)
		playsound(victim, "rustle", 60, TRUE, -4)
		victim.balloon_alert(victim, "someone's in my things!")
	else if(margin < PICKPOCKET_MIDDLING_CEIL)
		to_chat(victim, span_warning("I feel a faint tug at my belongings..."))

/mob/living/carbon/human/proc/grant_pickpocket_xp(mob/living/carbon/human/victim, amount)
	if(src != victim && victim.stat == CONSCIOUS && mind)
		mind.add_sleep_experience(/datum/skill/misc/stealing, amount, FALSE)

/mob/living/carbon/human/proc/finalize_pickpocket_steal(mob/living/carbon/human/victim, obj/item/picked, exp_to_gain)
	put_in_active_hand(picked)
	to_chat(src, span_green("I stole [picked]!"))
	victim.log_message("has had \the [picked] stolen by [key_name(src)]", LOG_ATTACK, color="white")
	log_message("has stolen \the [picked] from [key_name(victim)]", LOG_ATTACK, color="white")
	if(victim.client && victim.stat != DEAD)
		SEND_SIGNAL(src, COMSIG_ITEM_STOLEN, victim)
		record_featured_stat(FEATURED_STATS_THIEVES, src)
		record_featured_stat(FEATURED_STATS_CRIMINALS, src)
		GLOB.azure_round_stats[STATS_ITEMS_PICKPOCKETED]++
	if(has_flaw(/datum/charflaw/addiction/kleptomaniac))
		sate_addiction(/datum/charflaw/addiction/kleptomaniac)
	grant_pickpocket_xp(victim, exp_to_gain)

/// A steal-odds label floated over one grid item. Client-local, so only the thief sees it, never the mark.
/atom/movable/screen/pickpocket_odds
	plane = ABOVE_HUD_PLANE
	layer = ABOVE_HUD_LAYER + 1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT // clicks fall through to the item beneath
	maptext_x = 0
	maptext_y = 20
	maptext_width = 32
	maptext_height = 12

/datum/component/storage/proc/pickpocket_show(mob/living/carbon/human/thief)
	if(isnull(thief.client) || !show_to(thief))
		return FALSE
	return TRUE

/datum/pickpocket_session
	var/mob/living/carbon/human/thief
	var/mob/living/carbon/human/victim
	var/obj/item/storage/container
	var/datum/component/storage/STR
	var/margin = 0
	var/exp_to_gain = 0
	var/resolving = FALSE
	var/list/odds_labels

/datum/pickpocket_session/New(mob/living/carbon/human/thief, mob/living/carbon/human/victim, obj/item/storage/container, margin, exp_to_gain)
	. = ..()
	src.thief = thief
	src.victim = victim
	src.container = container
	src.margin = margin
	src.exp_to_gain = exp_to_gain
	STR = container.GetComponent(/datum/component/storage)
	if(!STR || !STR.pickpocket_show(thief))
		qdel(src)
		return
	build_odds_labels()
	RegisterSignal(thief, COMSIG_MOB_CLICKON, PROC_REF(on_click))
	RegisterSignal(thief, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), PROC_REF(on_disturbed))
	RegisterSignal(victim, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), PROC_REF(on_disturbed))

/datum/pickpocket_session/Destroy()
	clear_odds_labels()
	if(thief)
		UnregisterSignal(thief, list(COMSIG_MOB_CLICKON, COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
		if(STR && thief.active_storage == STR)
			STR.hide_from(thief)
	if(victim)
		UnregisterSignal(victim, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
	thief = null
	victim = null
	container = null
	STR = null
	return ..()

/// Float a private steal-odds label over each grid item, seen only by the thief.
/datum/pickpocket_session/proc/build_odds_labels()
	odds_labels = list()
	if(isnull(thief.client))
		return
	var/is_belt = istype(container, /obj/item/storage/belt)
	for(var/obj/item/I in container.contents)
		var/atom/movable/screen/pickpocket_odds/label = new
		label.screen_loc = I.screen_loc
		label.maptext = "<span style='text-align:center;color:#ffe670'>[thief.pickpocket_extract_chance(I, is_belt)]%</span>"
		thief.client.screen += label
		odds_labels += label

/datum/pickpocket_session/proc/clear_odds_labels()
	if(thief?.client)
		for(var/atom/movable/screen/pickpocket_odds/label in odds_labels)
			thief.client.screen -= label
	QDEL_LIST(odds_labels)

/datum/pickpocket_session/proc/on_disturbed(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/pickpocket_session/proc/on_click(mob/source, atom/target, params)
	SIGNAL_HANDLER
	if(resolving)
		return COMSIG_MOB_CANCEL_CLICKON
	if(QDELETED(container) || QDELETED(victim) || QDELETED(thief) || !STR)
		qdel(src)
		return COMSIG_MOB_CANCEL_CLICKON
	if(target == STR.closer)
		qdel(src)
		return COMSIG_MOB_CANCEL_CLICKON
	if(isitem(target) && (target in container.contents))
		resolving = TRUE
		INVOKE_ASYNC(src, PROC_REF(attempt_lift), target)
		return COMSIG_MOB_CANCEL_CLICKON
	qdel(src)
	return

/datum/pickpocket_session/proc/attempt_lift(obj/item/wanted)
	if(thief.get_active_held_item())
		to_chat(thief, span_warning("My hand is full."))
		qdel(src)
		return
	var/success = prob(thief.pickpocket_extract_chance(wanted, istype(container, /obj/item/storage/belt)))
	if(success)
		STR.remove_from_storage(wanted, get_turf(victim))
	else
		to_chat(thief, span_warning("My fingers slip off [wanted]."))
	thief.pickpocket_feedback(victim, margin, container)
	if(success)
		thief.finalize_pickpocket_steal(victim, wanted, exp_to_gain)
	qdel(src)

/datum/intent/steal
	name = "steal"
	candodge = FALSE
	canparry = FALSE
	chargedrain = 0
	chargetime = 0
	noaa = TRUE

/datum/intent/steal/on_mmb(mob/living/carbon/human/victim, mob/living/carbon/human/thief, params)
	if(!ishuman(victim) || !ishuman(thief))
		return
	var/list/stealmods = list("chance_add" = 0, "range_add" = 0)
	SEND_SIGNAL(thief, COMSIG_HUMAN_PRE_STEAL, stealmods)
	var/range_add = stealmods["range_add"]
	if(!isnum(range_add))
		range_add = 0
	var/steal_radius = 1 + range_add
	var/list/stealablezones = list("chest", "neck", "groin", "r_hand", "l_hand", "r_leg", "l_leg")
	// Pickpocketting checks
	if(get_dist(thief, victim) > steal_radius)
		to_chat(thief, span_warning("[victim] is too far away."))
		return
	if(thief.get_active_held_item())
		to_chat(thief, span_warning("I can't pickpocket while my hand is full!"))
		return
	if(victim.cmode)
		to_chat(thief, "<span class='warning'>[victim] is alert. I can't pickpocket them like this.</span>")
		return
	if(!(thief.zone_selected in stealablezones))
		to_chat(thief, span_warning("What am I going to steal from there?"))
		return

	var/thiefskill = thief.get_pickpocket_skill()
	var/chance_add = stealmods["chance_add"]
	if(!isnum(chance_add))
		chance_add = 0
	var/effective_targetperception = victim.STAPER
	if(chance_add > 0)
		effective_targetperception = max(0, round(victim.STAPER * (100 - chance_add) / 100))
	var/exp_to_gain = thief.STAINT
	to_chat(thief, span_notice("I try to steal from [victim]..."))
	if(!do_after(thief, 1 SECONDS, target = victim, progress = 0))
		return
	// Pickpocketting checks after the channel in case something changed
	if(get_dist(thief, victim) > steal_radius)
		to_chat(thief, span_warning("[victim] is too far away."))
		return
	if(thief.get_active_held_item())
		to_chat(thief, span_warning("I can't pickpocket while my hand is full!"))
		return
	if(victim.cmode)
		to_chat(thief, "<span class='warning'>[victim] is alert. I can't pickpocket them like this.</span>")
		return
	if(!(thief.zone_selected in stealablezones))
		to_chat(thief, span_warning("What am I going to steal from there?"))
		return

	// No lifting from the front - it has to be from behind, or off someone who can't see at all.
	var/victim_unaware = victim.IsUnconscious() || victim.eyesclosed || victim.eye_blind || victim.eye_blurry || !(victim.mobility_flags & MOBILITY_STAND)
	var/list/mobsbehind = cone(victim, list(turn(victim.dir, 180)), list(thief))
	if(!victim_unaware && !mobsbehind.Find(thief))
		to_chat(thief, span_warning("They can see me!"))
		thief.changeNext_move(clickcd)
		return

	// The contested detection check: thieving + fortune vs perception + speed, scaled by the mark's awareness.
	var/thief_score = roll("[thiefskill + 1]d6") + round((thief.STALUC - 10) / 3)
	var/victim_score
	if(victim_unaware)
		victim_score = round(effective_targetperception * 0.35)
	else
		victim_score = effective_targetperception + round((victim.STASPD - 10) / 3)
	var/margin = thief_score - victim_score

	if(margin < 0)
		victim.log_message("has had an attempted pickpocket by [key_name(thief)]", LOG_ATTACK, color="white")
		thief.log_message("has attempted to pickpocket [key_name(victim)]", LOG_ATTACK, color="white")
		if(margin < PICKPOCKET_FUMBLE_FLOOR)
			thief.visible_message(span_danger("[thief] is caught rummaging through [victim]'s belongings!"))
			victim.balloon_alert(victim, "thief!")
			to_chat(victim, span_danger("[thief] tried to rob me!"))
		else
			to_chat(thief, span_warning("I can't get at it without being noticed. Best stop here."))
			victim.balloon_alert(victim, "...?")
			to_chat(victim, span_danger("Someone's fumbling at my belongings!"))
		thief.changeNext_move(clickcd)
		return

	var/list/stealpos = list()
	switch(thief.zone_selected)
		if("chest")
			if(victim.get_item_by_slot(SLOT_BACK_L))
				stealpos.Add(victim.get_item_by_slot(SLOT_BACK_L))
			if(victim.get_item_by_slot(SLOT_BACK_R))
				stealpos.Add(victim.get_item_by_slot(SLOT_BACK_R))
		if("neck")
			if(victim.get_item_by_slot(SLOT_NECK))
				stealpos.Add(victim.get_item_by_slot(SLOT_NECK))
		if("groin")
			if(victim.get_item_by_slot(SLOT_BELT))
				stealpos.Add(victim.get_item_by_slot(SLOT_BELT))
		if("l_leg")
			if(victim.get_item_by_slot(SLOT_BELT_L))
				stealpos.Add(victim.get_item_by_slot(SLOT_BELT_L))
		if("r_leg")
			if(victim.get_item_by_slot(SLOT_BELT_R))
				stealpos.Add(victim.get_item_by_slot(SLOT_BELT_R))
		if("r_hand", "l_hand")
			if(victim.get_item_by_slot(SLOT_RING))
				stealpos.Add(victim.get_item_by_slot(SLOT_RING))

	if(!length(stealpos))
		to_chat(thief, span_warning("I didn't find anything there. Perhaps I should look elsewhere."))
		thief.changeNext_move(clickcd)
		return

	var/obj/item/target = pick(stealpos)

	if(thief.zone_selected == "r_hand" || thief.zone_selected == "l_hand")
		var/ring_chance = clamp(8 + (thiefskill * 7), 3, 90)
		to_chat(thief, span_info("[target]: [ring_chance]% to slip free."))
		var/success = prob(ring_chance)
		if(success)
			victim.dropItemToGround(target)
		else
			to_chat(thief, span_warning("I can't work [target] loose without them noticing."))
		thief.pickpocket_feedback(victim, margin, target)
		if(success)
			thief.finalize_pickpocket_steal(victim, target, exp_to_gain)
		thief.changeNext_move(clickcd)
		return

	if(istype(target, /obj/item/storage))
		var/obj/item/storage/container = target
		var/datum/component/storage/storage = container.GetComponent(/datum/component/storage)
		if(!storage || !length(storage.contents()))
			to_chat(thief, span_warning("There's nothing in [container] worth taking."))
			thief.changeNext_move(clickcd)
			return
		thief.changeNext_move(clickcd)
		new /datum/pickpocket_session(thief, victim, container, margin, exp_to_gain)
		return

	victim.dropItemToGround(target)
	thief.pickpocket_feedback(victim, margin, target)
	thief.finalize_pickpocket_steal(victim, target, exp_to_gain)
	thief.changeNext_move(clickcd)
