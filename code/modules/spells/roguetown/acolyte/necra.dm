// Necrite
/obj/effect/proc_holder/spell/targeted/burialrite
	name = "Burial Rites"
	desc = "Consecrate a coffin or a grave. Sending any spirits within to Necras realm."
	range = 5
	overlay_state = "consecrateburial"
	releasedrain = 30
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("Undermaiden grant thee passage forth and spare the trials of the forgotten.")
	invocation_type = "whisper" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 5 //very weak spell, you can just make a grave marker with a literal stick

/obj/effect/proc_holder/spell/targeted/burialrite/cast(list/targets, mob/user = usr)
	. = ..()
	var/success = FALSE
	for(var/obj/structure/closet/crate/coffin/coffin in view(1))
		success = pacify_coffin(coffin, user)
		if(success)
			user.visible_message("[user] consecrates [coffin]!", "My funeral rites have been performed on [coffin]!")
			return
	for(var/obj/structure/closet/dirthole/hole in view(1))
		success = pacify_coffin(hole, user)
		if(success)
			user.visible_message("[user] consecrates [hole]!", "My funeral rites have been performed on [hole]!")
			record_round_statistic(STATS_GRAVES_CONSECRATED)
			return
	to_chat(user, span_red("I failed to perform the rites."))

/obj/effect/proc_holder/spell/targeted/churn
	name = "Churn Undead"
	desc = "Stuns and explodes undead."
	range = 8//We return it, up from 4...
	overlay_state = "necra_ult"//Temp.
	releasedrain = 30
	chargetime = 6 SECONDS//Up from 2.
	recharge_time = 2 MINUTES//Up from 60.
	max_targets = 2//... in exchange for max targets...
	cast_without_targets = TRUE
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("The Undermaiden rebukes!!")
	invocation_type = "shout"
	miracle = TRUE
	devotion_cost = 150//... with a higher devotion cost, at +100, from 50.

/obj/effect/proc_holder/spell/targeted/churn/cast(list/targets,mob/living/user = usr)
	var/prob2explode = 100
	if(user && user.mind)
		prob2explode = 0
		for(var/i in 1 to user.get_skill_level(/datum/skill/magic/holy))
			prob2explode += 30
	for(var/mob/living/L in targets)
		var/isvampire = FALSE
		var/iszombie = FALSE
		if(L.stat == DEAD)
			continue
		if(L.mind)
			var/datum/antagonist/vampire/V = L.mind.has_antag_datum(/datum/antagonist/vampire)
			if(V && !SEND_SIGNAL(L, COMSIG_DISGUISE_STATUS))
				isvampire = TRUE
			if(L.mind.has_antag_datum(/datum/antagonist/zombie))
				iszombie = TRUE
			if(L.mind.special_role == "Vampire Lord" || L.mind.special_role == "Lich")	//Won't detonate Lich's or VLs but will fling them away.
				user.visible_message(span_warning("[L] overpowers being churned!"), span_userdanger("[L] is too strong, I am churned!"))
				user.Stun(50)
				user.throw_at(get_ranged_target_turf(user, get_dir(user,L), 7), 7, 1, L, spin = FALSE)
				return
		if((L.mob_biotypes & MOB_UNDEAD) || isvampire || iszombie)
			var/vamp_prob = prob2explode
			if(isvampire)
				vamp_prob -= 59
			if(prob(vamp_prob))
				L.visible_message("<span class='warning'>[L] has been churned by Necra's grip!", "<span class='danger'>I've been churned by Necra's grip!")
				explosion(get_turf(L), light_impact_range = 1, flame_range = 1, smoke = FALSE)
				L.Stun(50)
			else
				L.visible_message(span_warning("[L] resists being churned!"), span_userdanger("I resist being churned!"))
	..()
	return TRUE


/*
	DEATH'S DOOR
*/
/obj/effect/proc_holder/spell/invoked/deaths_door
	name = "Death's Door"
	desc = "Opens a one-way portal into a realm on the edge of death, People can be dragged into the portal to prevent their decay. Undead with be set aflame. Those whom enter the domain will find their Will to continue heavily weaken. <br>Necras domain can be left through a portal within to a shrine, or a grave/psycross marked with necra's sight."
	range = 6
	no_early_release = TRUE
	chargedrain = 0
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "necraportal"
	action_icon_state = "necraportal"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	charging_slowdown = 1
	chargetime = 2 SECONDS
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE
	sound = 'sound/misc/deadbell.ogg'
	invocations = list("Necra, show me my destination!")
	invocation_type = "shout"
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/deaths_door/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		return FALSE

	if(locate(/obj/structure/deaths_door_portal) in T)
		to_chat(user, span_warning("A gate already stands here."))
		return FALSE

	new /obj/structure/deaths_door_portal(T, user)
	return TRUE


//Choosing between skulls/respite
/* /obj/effect/proc_holder/spell/self/necra_spirits
	name = "Necra's Spirits"
	overlay_state = "consecrateburial"
	desc = "The undermaiden holds vengefulspirits within her grasp, allowing you to choose between <b>Her</b> allies."
	miracle = TRUE
	devotion_cost = 100
	recharge_time = 10 MINUTES
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/self/necra_spirits/cast(list/targets, mob/user)
	. = ..()
	var/choice = alert(user, "WHOM ANSWERS THE BELL?", "BRING FORTH SPIRITS", "Skulls", "Respite")
	switch(choice)
		if("Skulls")
			if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance))//No stacking.
				revert_cast()
			else
				user.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance)
				if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/raise_spirit_respite))//No, thanks.
					user.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/raise_spirit_respite)
		if("Respite")
			if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/raise_spirit_respite))//No stacking. Again. As funny as a dozen of these were.
				revert_cast()
			else
				user.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_spirit_respite)
				if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance))//Nope.
					user.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance)
		else
			revert_cast() */

// Speak with dead

/obj/effect/proc_holder/spell/invoked/speakwithdead
	name = "Speak with Dead"
	desc = "Call upon the Undermaiden to let your words reach a departed soul, and hear their whisper in return."
	max_targets = 0
	cast_without_targets = TRUE
	overlay_state = "speakwithdead"
	releasedrain = 30
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("The echoes of the departed stir, speak, O fallen one.")
	invocation_type = "whisper"
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/speakwithdead/cast(list/targets, mob/user = usr)
	. = ..()
	// Build list of souls who can be spoken with
	var/list/souls = list()
	for(var/mob/living/C in GLOB.dead_mob_list)
		if(!C.mind)
			continue
		var/mob/dead/observer/ghost = null
		for(var/mob/dead/observer/G in world)
			if(G.mind == C.mind)
				ghost = G
				break
		if(!ghost)
			continue	// no active ghost, cannot speak
		var/area/soul_area = get_area(C)
		var/area_str = soul_area ? "([soul_area.name]) " : ""
		souls["[area_str][C.real_name]"] = ghost

	if(!length(souls))
		to_chat(user, span_warning("No souls answer the Undermaiden's call at this time."))
		revert_cast()
		return .

	var/selected = tgui_input_list(user, "Whose soul shall I call forth?", "Speak with the Dead", souls)

	if(!selected || QDELETED(src) || QDELETED(user))
		revert_cast()
		return .

	var/mob/dead/observer/ghost = souls[selected]
	if(!ghost || QDELETED(ghost))
		to_chat(user, span_warning("The soul has slipped beyond reach."))
		return .

	// Prompt the ghost for consent
	var/consent = alert(ghost, "[user.real_name], a servant of the Undermaiden, calls upon you. Will you speak?", "Speak with the Living", "Yes", "No")
	if(consent != "Yes")
		to_chat(user, span_warning("The soul does not wish to speak."))
		return .

	if(QDELETED(ghost) || QDELETED(user))
		return .

	// Save ghost state, make them visible and move them to the Necran
	var/saved_invisibility = ghost.invisibility
	var/turf/saved_turf = get_turf(ghost)
	ghost.set_invisibility(0)
	ghost.forceMove(get_turf(user))
	ghost.status_flags |= GODMODE

	to_chat(user, span_cultsmall("A soul stirs before you. Speak aloud — they will hear you and can respond in kind. The connection lasts for one minute."))
	to_chat(ghost, span_cultsmall("You have been summoned before a servant of the Undermaiden. Speak aloud. The connection lasts for one minute."))
	playsound(get_turf(user), 'sound/vo/mobs/ghost/whisper (3).ogg', 60, TRUE)

	// 60 second communication window — restore ghost after
	addtimer(CALLBACK(src, PROC_REF(end_speakwithdead_session), ghost, saved_invisibility, saved_turf, user), 60 SECONDS, TIMER_STOPPABLE)

/// Ends a Speak with Dead session: restores ghost to original state.
/obj/effect/proc_holder/spell/invoked/speakwithdead/proc/end_speakwithdead_session(mob/dead/observer/ghost, saved_invisibility, turf/saved_turf, mob/living/user)
	if(QDELETED(ghost))
		return
	ghost.status_flags &= ~GODMODE
	ghost.set_invisibility(saved_invisibility)
	if(saved_turf && !QDELETED(saved_turf))
		ghost.forceMove(saved_turf)
	to_chat(ghost, span_cultsmall("The Undermaiden's thread grows thin. You are pulled back."))
	if(!QDELETED(user))
		to_chat(user, span_cultsmall("The soul's presence fades. The connection has ended."))

// BODY INTO COIN

/obj/effect/proc_holder/spell/invoked/fieldburials
	name = "Collect Coins"
	overlay_state = "consecrateburial"
	antimagic_allowed = TRUE
	devotion_cost = 10
	miracle = TRUE
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/invoked/fieldburials/cast(list/targets, mob/living/user)
	. = ..()

	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	if(target.stat < DEAD)
		to_chat(user, span_warning("They're still alive!"))
		revert_cast()
		return FALSE

	if(world.time <= target.mob_timers["lastdied"] + 15 MINUTES)
		to_chat(user, span_warning("The body is too fresh for the rite."))
		revert_cast()
		return FALSE

	var/obj/item/roguecoin/silver/C = new(get_turf(target))
	C.pixel_x = rand(-6, 6)
	C.pixel_y = rand(-6, 6)

	to_chat(user, span_notice("You gather coins from [target.real_name]'s remains."))
	to_chat(target, span_danger("Your worldly wealth slips away with the rite..."))

	qdel(target)

	return TRUE

/*
	SOUL SPEAK OLD LEGACY
	Not used anymore, but kept for reference.
*/

/*
/obj/effect/proc_holder/spell/targeted/soulspeak
	name = "Speak with Soul"
	range = 5
	overlay_state = "speakwithdead"
	releasedrain = 30
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("She-Below brooks thee respite, be heard, wanderer.")
	invocation_type = "whisper" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/targeted/soulspeak/cast(list/targets,mob/user = usr)
	var/mob/living/carbon/spirit/capturedsoul = null
	var/list/souloptions = list()
	var/list/itemstore = list()
	for(var/mob/living/carbon/spirit/S in GLOB.mob_list)
		if(S.summoned)
			continue
		if(!S.client)
			continue
		souloptions += S.livingname
	var/pickedsoul = input(user, "Which wandering soul shall I commune with?", "Available Souls") as null|anything in souloptions
	if(!pickedsoul)
		to_chat(user, span_warning("I was unable to commune with a soul."))
		return
	for(var/mob/living/carbon/spirit/P in GLOB.mob_list)
		if(P.livingname == pickedsoul)
			to_chat(P, "<font color='blue'>You feel yourself being pulled out of the Underworld.</font>")
			sleep(2 SECONDS)
			if(QDELETED(P) || P.summoned)
				to_chat(user, "<font color='blue'>Your connection to the soul suddenly disappears!</font>")
				return
			capturedsoul = P
			break
	if(capturedsoul)
		for(var/obj/item/I in capturedsoul.held_items) // this is still ass
			capturedsoul.temporarilyRemoveItemFromInventory(I, force = TRUE)
			itemstore += I.type
			qdel(I)
		capturedsoul.loc = user.loc
		capturedsoul.summoned = TRUE
		capturedsoul.beingmoved = TRUE
		capturedsoul.invisibility = INVISIBILITY_OBSERVER
		capturedsoul.status_flags |= GODMODE
		capturedsoul.Stun(61 SECONDS)
		capturedsoul.density = FALSE
		addtimer(CALLBACK(src, PROC_REF(return_soul), user, capturedsoul, itemstore), 60 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(return_soul_warning), user, capturedsoul), 50 SECONDS)
		to_chat(user, "<font color='blue'>I feel a cold chill run down my spine, a ghastly presence has arrived.</font>")
		return ..()

/obj/effect/proc_holder/spell/targeted/soulspeak/proc/return_soul_warning(mob/user, mob/living/carbon/spirit/soul)
	if(!QDELETED(user))
		to_chat(user, span_warning("The soul is being pulled away..."))
	if(!QDELETED(soul))
		to_chat(soul, span_warning("I'm starting to be pulled away..."))

/obj/effect/proc_holder/spell/targeted/soulspeak/proc/return_soul(mob/user, mob/living/carbon/spirit/soul, list/itemstore)
	to_chat(user, "<font color='blue'>The soul returns to the Underworld.</font>")
	if(QDELETED(soul))
		return
	to_chat(soul, "<font color='blue'>You feel yourself being transported back to the Underworld.</font>")
	soul.drop_all_held_items()
	for(var/obj/effect/landmark/underworld/A in shuffle(GLOB.landmarks_list))
		soul.loc = A.loc
		for(var/I in itemstore)
			soul.put_in_hands(new I())
		break
	soul.beingmoved = FALSE
	soul.fully_heal(FALSE)
	soul.invisibility = initial(soul.invisibility)
	soul.status_flags &= ~GODMODE
	soul.density = initial(soul.density) */

/proc/necra_dir_arrow(dir)
	switch(dir)
		if(NORTH)      return "↑"
		if(SOUTH)      return "↓"
		if(EAST)       return "→"
		if(WEST)       return "←"
		if(NORTHEAST)  return "↗"
		if(NORTHWEST)  return "↖"
		if(SOUTHEAST)  return "↘"
		if(SOUTHWEST)  return "↙"
	return "•"

/proc/necra_repeat_arrow(arrow, count)
	var/result = ""
	for(var/i in 1 to count)
		result += arrow
	return result

/obj/effect/proc_holder/spell/targeted/locate_dead
	name = "Locate Corpse"
	desc = "Call upon the Undermaiden to guide you to a lost soul."
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "locatecorpse"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	action_icon_state = "locatecorpse"
	sound = 'sound/magic/whiteflame.ogg'
	releasedrain = 30
	chargedrain = 0.5
	max_targets = 0
	cast_without_targets = TRUE
	miracle = TRUE
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	invocations = list("Undermaiden, guide my hand to those who have lost their way.")
	invocation_type = "whisper"
	recharge_time = 15 SECONDS
	devotion_cost = 35
	/// Weakref to the currently tracked corpse for periodic updates.
	var/datum/weakref/tracked_corpse = null
	/// Stoppable timer ID for periodic directional updates.
	var/locate_timer_id = null

/obj/effect/proc_holder/spell/targeted/locate_dead/Destroy()
	if(locate_timer_id)
		deltimer(locate_timer_id)
		locate_timer_id = null
	tracked_corpse = null
	return ..()

/obj/effect/proc_holder/spell/targeted/locate_dead/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/list/mob/corpses = list()

	// Option to stop current tracking (shown at top)
	if(tracked_corpse)
		corpses["✦ Stop Tracking Current Corpse"] = "STOP_TRACKING"

	// Option to search nearby NPC corpses
	corpses["✦ Search Nearby (NPC Corpses)"] = "NPC_SEARCH"

	for(var/mob/living/C in GLOB.dead_mob_list)
		if(!C.mind)
			continue

		if(istype(C, /mob/living/carbon/human))
			var/mob/living/carbon/human/B = C
			if(B.buried)
				continue

		var/time_dead = 0
		if(C.timeofdeath)
			time_dead = world.time - C.timeofdeath

		var/corpse_name

		if(time_dead < 5 MINUTES)
			corpse_name = "Fresh corpse "
		else if(time_dead < 10 MINUTES)
			corpse_name = "Recently deceased "
		else if(time_dead < 30 MINUTES)
			corpse_name = "Long dead "
		else
			corpse_name = "Forgotten remains of "

		var/list/d_list = C.get_mob_descriptors()
		var/trait_desc = "[capitalize(build_coalesce_description_nofluff(d_list, C, list(MOB_DESCRIPTOR_SLOT_TRAIT), "%DESC1%"))]"
		var/stature_desc = "[capitalize(build_coalesce_description_nofluff(d_list, C, list(MOB_DESCRIPTOR_SLOT_STATURE), "%DESC1%"))]"
		var/descriptor_name = "[trait_desc] [stature_desc]"

		if(descriptor_name == " ")
			descriptor_name = "Unknown"

		// Soul status: check if the player's mind is still present as a ghost
		var/soul_tag = ""
		if(istype(C.mind?.current, /mob/dead/observer))
			soul_tag = "[Lingers] "
		else if(C.mind?.key)
			soul_tag = "[Departed] "

		// Area prefix
		var/area/corpse_area_entry = get_area(C)
		var/area_prefix_entry = corpse_area_entry ? "([corpse_area_entry.name]) " : ""

		var/full_name = "[area_prefix_entry][soul_tag][corpse_name] of \a [descriptor_name]..."
		corpses[full_name] = C

	if(length(corpses) <= 2) // only the two special options exist, no real corpses
		to_chat(user, span_warning("The Undermaiden's grasp lets slip."))
		revert_cast()
		return .

	var/selected = tgui_input_list(user, "Which body shall I seek?", "Available Bodies", corpses)

	// Cancelled without selecting — refund devotion
	if(!selected || QDELETED(src) || QDELETED(user))
		revert_cast()
		return .

	// Handle special options
	if(corpses[selected] == "STOP_TRACKING")
		to_chat(user, span_notice("The Undermaiden releases her pull."))
		if(locate_timer_id)
			deltimer(locate_timer_id)
			locate_timer_id = null
		tracked_corpse = null
		revert_cast()
		return .

	if(corpses[selected] == "NPC_SEARCH")
		// Scan nearby area for mindless dead (NPC corpses)
		var/list/npc_corpses = list()
		for(var/mob/living/NPC in range(15, user))
			if(NPC.stat != DEAD)
				continue
			if(NPC.mind)
				continue	// skip player corpses, already shown above
			var/npc_area = get_area(NPC)
			var/npc_area_str = npc_area ? "([npc_area.name]) " : ""
			npc_corpses["[npc_area_str][NPC.name]"] = NPC
		if(!length(npc_corpses))
			to_chat(user, span_warning("No nearby corpses answer the Undermaiden's call."))
			revert_cast()
			return .
		var/npc_selected = tgui_input_list(user, "Nearby remains:", "Nearby Corpses", npc_corpses)
		if(!npc_selected || QDELETED(src) || QDELETED(user))
			revert_cast()
			return .
		var/mob/living/npc_corpse = npc_corpses[npc_selected]
		if(QDELETED(npc_corpse))
			revert_cast()
			return .
		// Track the NPC corpse and send initial update
		if(locate_timer_id)
			deltimer(locate_timer_id)
		tracked_corpse = WEAKREF(npc_corpse)
		locate_timer_id = addtimer(CALLBACK(src, PROC_REF(send_locate_update), user), 15 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)
		send_locate_update(user)
		return .

	var/mob/living/corpse = corpses[selected]
	if(QDELETED(corpse))
		to_chat(user, span_warning("The Undermaiden's grasp lets slip."))
		return .

	// Cancel existing timer and start fresh tracking
	if(locate_timer_id)
		deltimer(locate_timer_id)
	tracked_corpse = WEAKREF(corpse)
	locate_timer_id = addtimer(CALLBACK(src, PROC_REF(send_locate_update), user), 15 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

	// Send immediate update
	send_locate_update(user)

/// Sends a directional update to the user toward the tracked corpse.
/// Called immediately after selection and by the repeating timer.
/obj/effect/proc_holder/spell/targeted/locate_dead/proc/send_locate_update(mob/living/user)
	if(QDELETED(user) || !tracked_corpse)
		if(locate_timer_id)
			deltimer(locate_timer_id)
			locate_timer_id = null
		tracked_corpse = null
		return
	var/mob/living/corpse = tracked_corpse.resolve()
	if(!corpse || QDELETED(corpse))
		to_chat(user, span_warning("The Undermaiden's thread has gone cold. The soul is beyond reach."))
		if(locate_timer_id)
			deltimer(locate_timer_id)
			locate_timer_id = null
		tracked_corpse = null
		return

	var/turf/turf_user = get_turf(user)
	var/turf/turf_corpse = get_turf(corpse)

	if(!turf_user || !turf_corpse)
		to_chat(user, span_warning("The Undermaiden's grasp lets slip."))
		return

	var/vertical_text = null
	var/vertical_arrow = null
	var/horizontal_text = null
	var/horizontal_arrow = null

	if(turf_user.z != turf_corpse.z)
		var/z_difference = abs(turf_corpse.z - turf_user.z)

		if(turf_corpse.z > turf_user.z)
			vertical_text = "upwards"
			vertical_arrow = necra_repeat_arrow("⇧", z_difference)
		else
			vertical_text = "downwards"
			vertical_arrow = necra_repeat_arrow("⇩", z_difference)

	if(turf_user.x != turf_corpse.x || turf_user.y != turf_corpse.y)
		var/direction = get_dir(turf_user, turf_corpse)
		horizontal_arrow = necra_dir_arrow(direction)

		switch(direction)
			if(NORTH)      horizontal_text = "north"
			if(SOUTH)      horizontal_text = "south"
			if(EAST)       horizontal_text = "east"
			if(WEST)       horizontal_text = "west"
			if(NORTHEAST)  horizontal_text = "northeast"
			if(NORTHWEST)  horizontal_text = "northwest"
			if(SOUTHEAST)  horizontal_text = "southeast"
			if(SOUTHWEST)  horizontal_text = "southwest"

	var/dist = get_dist(turf_user, turf_corpse)
	var/distance_text

	if(dist > 100)
		distance_text = "Its presence feels distant."
	else if(dist > 50)
		distance_text = "The pull grows stronger, yet remains far."
	else if(dist > 20)
		distance_text = "You feel the corpse is not far now."
	else if(dist > 0)
		distance_text = "The corpse is very near."
	else
		distance_text = "It is here."

	var/direction_text = ""

	if(vertical_text)
		direction_text += "<br>Vertical: <b>[vertical_arrow]</b> [vertical_text]"

	if(horizontal_text)
		direction_text += "<br>Horizontal: <b>[horizontal_arrow]</b> [horizontal_text]"

	if(!length(direction_text))
		direction_text = "<br><b>•</b> nowhere discernible"

	var/area/corpse_area = get_area(turf_corpse)
	var/area_text = corpse_area ? corpse_area.name : "an unknown place"

	to_chat(user, span_notice("The Undermaiden pulls on your hand.[direction_text]<br>[distance_text] Its resting place lies within <b>[area_text]</b>."))

// =================== GHOST AWARENESS ===================

/// When a ghost speaks, Necran followers nearby hear a faint whisper of it.
/mob/dead/observer/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	. = ..()
	var/clean = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
	if(!clean)
		return
	var/turf/ghost_turf = get_turf(src)
	if(!ghost_turf)
		return
	for(var/mob/living/L in range(7, ghost_turf))
		if(!HAS_TRAIT(L, TRAIT_SOUL_EXAMINE))
			continue
		if(L.z != z)
			continue
		to_chat(L, span_deadsay("<i>A spirit murmurs nearby: \"[clean]\"</i>"))

/// Give Necrans the ability to see ghosts (see_invisible raised to observer level).
/datum/patron/divine/necra/on_gain(mob/living/pious)
	. = ..()
	if(ismob(pious))
		pious.see_invisible = max(pious.see_invisible, SEE_INVISIBLE_OBSERVER)

/datum/patron/divine/necra/on_loss(mob/living/pious)
	. = ..()
	if(ismob(pious))
		if(pious.see_invisible >= SEE_INVISIBLE_OBSERVER)
			pious.see_invisible = SEE_INVISIBLE_LIVING	// restore to normal living sight

// =====================================================
// Necra Death Sense — toggleable innate action
// =====================================================

/// Granted alongside TRAIT_SOUL_EXAMINE in job setup procs for Necra templars, monks, and heretics.
/// When active, Necran receives a death notice with exact area name whenever a player character dies.
/datum/action/innate/toggle_necra_deathsense
	name = "Necra's Eye (ON)"
	desc = "Receive Necra's whispers when a soul departs the mortal world. Toggle to silence them."
	icon_icon = 'icons/mob/actions/necramiracles.dmi'
	button_icon_state = "locatecorpse"

/datum/action/innate/toggle_necra_deathsense/Grant(mob/M)
	..()
	if(owner)
		Activate()

/datum/action/innate/toggle_necra_deathsense/Remove(mob/M)
	if(M)
		REMOVE_TRAIT(M, TRAIT_NECRA_DEATHSIGHT, "necra_deathsense_action")
	..()

/datum/action/innate/toggle_necra_deathsense/Activate()
	ADD_TRAIT(owner, TRAIT_NECRA_DEATHSIGHT, "necra_deathsense_action")
	name = "Necra's Eye (ON)"
	active = TRUE
	UpdateButtonIcon()

/datum/action/innate/toggle_necra_deathsense/Deactivate()
	REMOVE_TRAIT(owner, TRAIT_NECRA_DEATHSIGHT, "necra_deathsense_action")
	name = "Necra's Eye (OFF)"
	active = FALSE
	UpdateButtonIcon()
