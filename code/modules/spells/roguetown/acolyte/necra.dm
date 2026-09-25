// Necrite
/obj/effect/proc_holder/spell/targeted/burialrite
	name = "Burial Rites"
	desc = "Consecrate a coffin or a grave. Sending any spirits within to Necras realm."
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	action_icon = 'icons/mob/actions/necramiracles.dmi'
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
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	action_icon = 'icons/mob/actions/necramiracles.dmi'
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
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	range = 6
	no_early_release = TRUE
	chargedrain = 0
	overlay_state = "necraportal"
	action_icon_state = "necraportal"
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
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	range = 5
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
	if(!targets || !length(targets))
		to_chat(user, "<font color='red'>To perform a miracle, you are supposed to stay next to their fallen body. If there no soul in the body, there will be no responce.</font>")
		return FALSE

	var/mob/living/target = targets[1]

	if(isliving(target) && target.stat == DEAD)
		return speakwithdead(user, target)
	else
		to_chat(user, "<font color='red'>They are not dead. Yet.</font>")
		return FALSE

/proc/speakwithdead(mob/user, mob/living/target)
	if(target.stat == DEAD && target.mind)
		var/message = input(user, "You speak to the spirit of [target.real_name]. What will you say?", "Speak with the Dead") as text|null

		if(message)
			if(target.mind.current)
				to_chat(target.mind.current, "<span style='color:gold'><b>[user.real_name]</b> says: \"[message]\"</span>")

			var/mob/dead/observer/ghost = null

			for (var/mob/dead/observer/G in world)
				if (G.mind == target.mind)
					ghost = G
					break

			if (!ghost && target.mind && target.mind.key)
				var/expected_ckey = ckey(target.mind.key)
				for (var/mob/dead/observer/G2 in world)
					if (G2.client && ckey(G2.key) == expected_ckey)
						ghost = G2
						break

			if (ghost && ghost != target.mind.current)
				to_chat(ghost, "<span style='color:gold'><b>[user.real_name]</b> says: \"[message]\"</span>")

			to_chat(user, "<span style='color:gold'>You say to the spirit: \"[message]\"</span>")

			var/mob/replier = null
			if (ghost && ghost.client)
				replier = ghost
			else if (target.mind.current && target.mind.current.client)
				replier = target.mind.current

			if(replier)
				var/spirit_message = input(replier, "An acolyte of Necra named [user.real_name] seeks your attention. What is your reply?", "Spirit's Response") as text|null
				if(spirit_message)
					to_chat(user, "<span style='color:silver'><i>The spirit whispers:</i> \"[spirit_message]\"</span>")
				else
					to_chat(user, "<span style='color:#aaaaaa'><i>The spirit chooses to remain silent...</i></span>")
			else
				to_chat(user, "<span style='color:#aaaaaa'><i>The spirit cannot answer right now...</i></span>")
		else
			to_chat(user, "<span style='color:#aaaaaa'><i>You choose not to speak.</i></span>")
	else
		to_chat(user, "<span style='color:#aaaaaa'><i>No spirit answers your call.</i></span>")

// BODY INTO COIN

/obj/effect/proc_holder/spell/invoked/fieldburials
	name = "Collect Coins"
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	action_icon = 'icons/mob/actions/necramiracles.dmi'
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
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "locatecorpse"
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

/obj/effect/proc_holder/spell/targeted/locate_dead/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/list/mob/corpses = list()

	for(var/mob/living/C in GLOB.dead_mob_list)
		if(!C.mind || C.contract_spawned)
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

		corpse_name += " of \a [descriptor_name]..."
		corpses[corpse_name] = C

	if(!length(corpses))
		to_chat(user, span_warning("The Undermaiden's grasp lets slip."))
		revert_cast()
		return .

	var/selected = tgui_input_list(user, "Which body shall I seek?", "Available Bodies", corpses)

	if(!selected || QDELETED(src) || QDELETED(user) || QDELETED(corpses[selected]))
		to_chat(user, span_warning("The Undermaiden's grasp lets slip."))
		return .

	var/mob/living/corpse = corpses[selected]

	var/turf/turf_user = get_turf(user)
	var/turf/turf_corpse = get_turf(corpse)

	if(!turf_user || !turf_corpse)
		to_chat(user, span_warning("The Undermaiden's grasp lets slip."))
		return .

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

/obj/effect/proc_holder/spell/invoked/bless_cross
	name = "Bless Cross"
	desc = "Channel holy energy to bless a Necran cross, allowing it to be activated against undead. devout can maintain one cross, while masters can maintain three. You can unbless a previously blessed cross to reclaim the slot."
	invocations = list("Necra, grant this cross your watchful gaze!")
	sound = 'sound/magic/bless.ogg'
	devotion_cost = 100
	recharge_time = 2 MINUTES
	chargetime = 1 SECONDS
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "bless_cross"
	action_icon_state = "bless_cross"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	associated_skill = /datum/skill/magic/holy

	/// List of blessed crosses this caster maintains
	var/list/obj/structure/fluff/psycross/necra/cloth/blessed_crosses = list()

/obj/effect/proc_holder/spell/invoked/bless_cross/cast(list/targets, mob/living/user)
	var/obj/structure/fluff/psycross/necra/cloth/cross = targets[1]

	if(!istype(cross))
		to_chat(user, span_warning("I can only bless cloth decorated Necran crosses!"))
		revert_cast()
		return FALSE

	var/holy_skill = user.get_skill_level(associated_skill)
	var/max_crosses = (holy_skill >= SKILL_LEVEL_MASTER) ? 3 : 1

	for(var/i = blessed_crosses.len; i > 0; i--)
		var/obj/structure/fluff/psycross/necra/cloth/C = blessed_crosses[i]
		if(QDELETED(C) || !C.necran_blessing)
			blessed_crosses -= C

	if(cross.necran_blessing)
		if(cross in blessed_crosses)
			if(!do_after(user, 10 SECONDS, target = cross))
				revert_cast()
				return FALSE
			cross.necran_blessing = FALSE
			if(cross.cross_active)
				cross.deactivate_cross()
			blessed_crosses -= cross
			playsound(cross, 'sound/magic/magnet.ogg', 50, TRUE)
			to_chat(user, span_notice("Cross unblessed. You can maintain [max_crosses - blessed_crosses.len] crosses again."))
			return TRUE
		else
			to_chat(user, span_warning("Another follower already blessed this cross!"))
			revert_cast()
			return FALSE

	// Check if we have room for another cross
	if(blessed_crosses.len >= max_crosses)
		to_chat(user, span_warning("You can only maintain [max_crosses] crosses! Unbless one first."))
		revert_cast()
		return FALSE

	// Bless the cross
	if(!do_after(user, 10 SECONDS, target = cross))
		revert_cast()
		return FALSE

	cross.necran_blessing = TRUE
	blessed_crosses += cross

	to_chat(user, span_notice("Cross blessed! You can bless [max_crosses - blessed_crosses.len] more crosses."))

	return TRUE

/obj/structure/fluff/psycross/necra
	name = "necran cross"
	desc = "Not all of the ten bear crosses, but as they oft mark the grave, so do Necrans raise these in honor of the dead. The undermaiden watches."
	icon_state = "cross_necra"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	max_integrity = 300

/obj/structure/fluff/psycross/necra/Initialize(mapload)
	. = ..()
	// - I don't think these need to hear anymore, so I'm cautiously turning this off..
	// chance2hear isn't referenced anywhere in the code!
	lose_hearing_sensitivity()

/obj/structure/fluff/psycross/necra/cloth
	desc = "A Necran cross blessed by a loyal follower. The strips of fabric symbolize the tears of the undermaiden as she welcomes another soul back. It seems sturdy."
	icon_state = "cross_necra_cloth"
	// It's going to be hard to get rid of these when they're not active.
	max_integrity = 1200
	/// Is the cross blessed by a necran?
	var/necran_blessing = FALSE
	/// Is the cross currently active?
	var/cross_active = FALSE
	/// Range of the necran aura
	var/aura_range = 7
	/// List of mobs currently affected by the aura
	var/list/mob/living/affected_mobs = list()
	/// Time when the cross was last activated
	var/last_activation_time = 0
	/// Cooldown between activations
	var/activation_cooldown = 5 SECONDS
	/// Time before auto-deactivation when no undead are detected
	var/auto_deactivate_time = 300 SECONDS
	/// Undead check for auto deactivation
	var/undead_found = 0

/obj/structure/fluff/psycross/necra/cloth/attack_hand(mob/living/user)
	. = ..()

	if(is_undead(user))
		return

	activate_cross(user)

/obj/structure/fluff/psycross/necra/cloth/Destroy()
	deactivate_cross()
	return ..()

/obj/structure/fluff/psycross/necra/cloth/proc/activate_cross(mob/living/user)
	if(cross_active)
		to_chat(user, span_warning("The cross is already active!"))
		return FALSE

	if(!necran_blessing)
		return FALSE

	if(world.time < last_activation_time + activation_cooldown)
		to_chat(user, span_warning("The cross needs time to recharge its holy energy."))
		return FALSE

	// Activate the cross
	cross_active = TRUE
	last_activation_time = world.time
	set_light(3, 2, LIGHT_COLOR_HOLY_MAGIC)
	icon_state = "cross_necra_cloth_active"
	visible_message(span_notice("The Necran cross begins to glow with a pale, holy light!"))
	playsound(src, 'sound/magic/ahh1.ogg', 50, TRUE)
	START_PROCESSING(SSobj, src)

	var/health_percentage = obj_integrity / max_integrity
	var/new_max_integrity = 600
	var/new_integrity = round(health_percentage * new_max_integrity)
	max_integrity = new_max_integrity
	obj_integrity = min(new_integrity, max_integrity)

	return TRUE

/obj/structure/fluff/psycross/necra/cloth/proc/deactivate_cross()
	if(!cross_active)
		return

	cross_active = FALSE
	set_light(0)
	icon_state = "cross_necra_cloth"
	visible_message(span_notice("The glow fades from the Necran cross."))

	// Inefficient but we're not doing this often.
	for(var/mob/living/L in affected_mobs)
		remove_undead_debuff(L)
		remove_necran_buff(L)
	affected_mobs.Cut()
	STOP_PROCESSING(SSobj, src)

	var/health_percentage = obj_integrity / max_integrity
	var/new_max_integrity = 1200
	var/new_integrity = round(health_percentage * new_max_integrity)
	max_integrity = new_max_integrity
	obj_integrity = min(new_integrity, max_integrity)
	undead_found = 0

/obj/structure/fluff/psycross/necra/cloth/proc/check_auto_deactivate()
	if(!cross_active)
		return

	if(!undead_found && last_activation_time + auto_deactivate_time < world.time)
		visible_message(span_notice("With no undead to purify, the cross's glow fades away."))
		deactivate_cross()
	else
		last_activation_time = world.time

/obj/structure/fluff/psycross/necra/cloth/process(delta_time)
	if(!cross_active)
		STOP_PROCESSING(SSobj, src)
		return
	var/list/current_mobs = list()

	for(var/mob/living/L in view(aura_range, src))
		current_mobs += L

		if(!affected_mobs[L])
			if(is_undead(L))
				apply_undead_debuff(L)
				affected_mobs[L] = TRUE
				undead_found++
			else if(is_necran_follower(L))
				apply_necran_buff(L)
				affected_mobs[L] = TRUE

	// Remove effects from mobs that left range or are no longer undead
	for(var/mob/living/L in affected_mobs)
		if(!(L in current_mobs))
			remove_undead_debuff(L)
			if(is_undead(L))
				undead_found = max(0, undead_found - 1)
			else
				remove_necran_buff(L)
			affected_mobs -= L

	if(!length(affected_mobs))
		check_auto_deactivate()

/obj/structure/fluff/psycross/necra/cloth/proc/is_necran_follower(mob/living/L)
	if(!iscarbon(L))
		return FALSE

	var/mob/living/carbon/C = L
	if(C.patron?.type == /datum/patron/divine/necra)
		return TRUE
	return FALSE

/obj/structure/fluff/psycross/necra/cloth/proc/is_undead(mob/living/L)
	if(L.mob_biotypes & MOB_UNDEAD)
		return TRUE
	if(L.mind?.has_antag_datum(/datum/antagonist/zombie))
		return TRUE
	return FALSE

/obj/structure/fluff/psycross/necra/cloth/proc/apply_necran_buff(mob/living/carbon/human/H)
	// Freaking necran cows! Raah!
	if(!istype(H))
		return

	var/holy_skill = H.get_skill_level(/datum/skill/magic/holy)
	var/buff_tier

	// Determine buff tier based on holy skill
	if(holy_skill >= SKILL_LEVEL_MASTER)
		buff_tier = 3
	else if(holy_skill >= SKILL_LEVEL_APPRENTICE)
		buff_tier = 2
	else
		buff_tier = 1

	// Apply the appropriate buff status effect
	H.apply_status_effect(/datum/status_effect/buff/necran_mists, buff_tier)

/obj/structure/fluff/psycross/necra/cloth/proc/apply_undead_debuff(mob/living/target)
	if(!target || !is_undead(target))
		return

	var/is_lich = target.mind?.has_antag_datum(/datum/antagonist/lich)

	if(is_lich)
		// Stronger debuff for liches
		target.apply_status_effect(/datum/status_effect/debuff/necran_cross/strong)
		to_chat(target, span_danger("You feel the hateful gaze of the undermaiden burn bright upon your very soul!"))
	else
		target.apply_status_effect(/datum/status_effect/debuff/necran_cross)
		to_chat(target, span_danger("You feel the hateful gaze of the undermaiden burn upon your very soul!"))

/obj/structure/fluff/psycross/necra/cloth/proc/remove_undead_debuff(mob/living/target)
	if(!target)
		return
	target.remove_status_effect(/datum/status_effect/debuff/necran_cross)
	target.remove_status_effect(/datum/status_effect/debuff/necran_cross/strong)

/obj/structure/fluff/psycross/necra/cloth/proc/remove_necran_buff(mob/living/carbon/human/H)
	if(!istype(H))
		return

	H.remove_status_effect(/datum/status_effect/buff/necran_mists)

/obj/structure/fluff/psycross/necra/cloth/examine(mob/user)
	. = ..()
	if(cross_active)
		. += span_notice("The cross is actively glowing with holy energy, weakening undead in the area.")
		. += span_notice("The energy coursing through the cross seems to make it more fragile.")
	else if(necran_blessing)
		. += span_info("You can touch it to activate its holy aura.")
		. += span_good("A necran blessed this cross, the undermaiden is watching.")
	if(ishuman(user) && necran_blessing)
		var/mob/living/carbon/human/H = user
		if(H.dna?.species?.id == "revenant")
			. += span_danger("I feel the undermaiden's scornful gaze!")

#define MOVESPEED_ID_NECRAN_CROSS "movespeed_necran_cross"

/datum/status_effect/debuff/necran_cross
	id = "necran_cross_debuff"
	duration = -1 // Removed when leaving range or cross deactivates
	alert_type = /atom/movable/screen/alert/status_effect/necran_cross_debuff
	var/slowdown_multiplier = 2
	var/strength_debuff = -2
	var/perception_debuff = -2
	var/fortune_debuff = -2

/datum/status_effect/debuff/necran_cross/on_apply()
	var/mob/living/carbon/human/H = owner
	if(istype(H))
		owner.add_movespeed_modifier(MOVESPEED_ID_NECRAN_CROSS, update=TRUE, priority=100, multiplicative_slowdown=slowdown_multiplier)

		effectedstats = list(
		STATKEY_STR = strength_debuff,
		STATKEY_PER = perception_debuff,
		STATKEY_LCK = fortune_debuff
			)

	. = ..()
	return TRUE

/datum/status_effect/debuff/necran_cross/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_NECRAN_CROSS)
	return ..()

/datum/status_effect/debuff/necran_cross/strong
	slowdown_multiplier = 4
	strength_debuff = -2
	perception_debuff = -2
	fortune_debuff = -5

/atom/movable/screen/alert/status_effect/necran_cross_debuff
	name = "Holy Purification"
	desc = "The holy light of Necra weakens your undead form. Your movements are slowed and your senses dulled."
	icon_state = "holy"

#define NECRAN_MISTS_FILTER "necra_mists_filter"

/datum/status_effect/buff/necran_mists
	id = "necran_mists"
	duration = -1 // Removed when leaving range
	alert_type = /atom/movable/screen/alert/status_effect/buff/necran_mists
	/// Tier of buff (1-3)
	var/buff_tier = 1
	var/speed_buff = 1
	var/outline_colour = "#929186"

/atom/movable/screen/alert/status_effect/buff/necran_mists
	name = "Necra's Mists"
	desc = "The sacred mists of Necra envelop you, granting protection and speed."
	icon_state = "holybuff"

/datum/status_effect/buff/necran_mists/on_creation(mob/living/new_owner, tier = 1)
	buff_tier = tier
	. = ..()

/datum/status_effect/buff/necran_mists/on_apply()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	switch(buff_tier)
		if(3) // Master or higher
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_MIRACLE)
			speed_buff = 3
		if(2) // Apprentice to Master
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_MIRACLE)
			speed_buff = 2
		if(1) // Below apprentice
			speed_buff = 1

	effectedstats = list(
		STATKEY_SPD = speed_buff
		)

	var/filter = H.get_filter(NECRAN_MISTS_FILTER)
	if(!filter)
		H.add_filter(NECRAN_MISTS_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 120, "size" = 1))
	. = ..()
	return TRUE

/datum/status_effect/buff/necran_mists/on_remove()
	var/mob/living/carbon/human/H = owner
	if(istype(H))
		// Remove traits
		REMOVE_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_MIRACLE)
		H.remove_filter(NECRAN_MISTS_FILTER)
	return ..()

/obj/effect/proc_holder/spell/invoked/necra_consecrate
	name = "Consecrate Ground"
	desc = "Channel holy energy to conjure an ethereal Necran cross upon a site made holy. All devout Necrans within it will receive boons, depending on the caster's holy skill. Those made unrevivable will receive greater effects."
	invocations = list("In the name of Her this ground is made SACROSANCT!")
	invocation_type = "shout"
	sound = 'sound/magic/ahh1.ogg'
	recharge_time = 130 SECONDS //2 min duration + 10 second CD inbetween. Unless it gets destroyed before.
	chargetime = 1.5 SECONDS
	range = 1
	releasedrain = 40
	chargedrain = 0.5
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokeholy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE
	devotion_cost = 100
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "consecrate_ground"
	action_icon_state = "consecrate_ground"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/necra_consecrate/cast(list/targets, mob/living/user = usr)
	. = ..()

	if(!length(targets))
		revert_cast()
		return FALSE

	var/turf/target_turf = get_turf(targets[1])
	if(!target_turf)
		revert_cast()
		return FALSE

	if(target_turf.density)
		revert_cast()
		return FALSE

	if(istype(target_turf, /turf/open/transparent/openspace))
		revert_cast()
		return FALSE

	var/effect_size = 2
	var/skill_level = user.get_skill_level(associated_skill)
	switch(skill_level)
		if(SKILL_LEVEL_EXPERT)
			effect_size = 3
		if(SKILL_LEVEL_MASTER to SKILL_LEVEL_LEGENDARY)
			effect_size = 4

/obj/effect/proc_holder/spell/invoked/necra_consecrate
	name = "Consecrate Ground"
	desc = "Channel holy energy to conjure an ethereal Necran cross upon a site made holy. All devout Necrans within it will receive boons, depending on the caster's holy skill. Those made unrevivable will receive greater effects."
	invocations = list("In the name of Her this ground is made SACROSANCT!")
	invocation_type = "shout"
	sound = 'sound/magic/ahh1.ogg'
	recharge_time = 130 SECONDS //2 min duration + 10 second CD inbetween. Unless it gets destroyed before.
	chargetime = 1.5 SECONDS
	range = 1
	releasedrain = 40
	chargedrain = 0.5
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokeholy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE
	devotion_cost = 100
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "consecrate_ground"
	action_icon_state = "consecrate_ground"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/necra_consecrate/cast(list/targets, mob/living/user = usr)
	. = ..()

	if(!length(targets))
		revert_cast()
		return FALSE

	var/turf/target_turf = get_turf(targets[1])
	if(!target_turf)
		revert_cast()
		return FALSE

	if(target_turf.density)	//On a wall
		revert_cast()
		return FALSE

	if(istype(target_turf, /turf/open/transparent/openspace))
		revert_cast()
		return FALSE

	var/effect_size = 2
	var/skill_level = user.get_skill_level(associated_skill)
	switch(skill_level)
		if(SKILL_LEVEL_EXPERT)
			effect_size = 3
		if(SKILL_LEVEL_MASTER to SKILL_LEVEL_LEGENDARY)
			effect_size = 4

	new /obj/structure/fluff/psycross/necra/consecrated(target_turf, effect_size)

	return TRUE


/obj/structure/fluff/psycross/necra/consecrated
	name = "spirit necran cross"
	desc = "A monument to Her holy sanctity, blessing her worshippers in vicinity. Those who have vowed their souls to her in full receive better boons. Standing in its presence, a sense of idle acceptance prods at your mind. We will all have to let go at some point."
	icon_state = "cross_necra_consecrate"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	layer = ABOVE_MOB_LAYER	//We want this to be more visible than not, adjust this as needed if it's ever used behind stuff
	plane = GAME_PLANE_UPPER
	max_integrity = 100	//3-5 hits with the average weapon (20-40 damage) to fully destroy.
	density = FALSE
	var/list/affected_mobs = list()
	var/range = 2
	var/expires_in = 2 MINUTES

/obj/structure/fluff/psycross/necra/consecrated/Initialize(mapload, newrange)
	. = ..()
	if(newrange)
		range = newrange
	addtimer(CALLBACK(src, PROC_REF(expire_self)), expires_in)
	START_PROCESSING(SSobj, src)

/obj/structure/fluff/psycross/necra/consecrated/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration, object_damage_multiplier)
	if(object_damage_multiplier)	//Mostly used by ranged weapons
		object_damage_multiplier = 1
	if(damage_amount > round(max_integrity / 3))	//We don't want this thing to be one-shottable, especially with our loosy-goosy obj / integ damage mods.
		damage_amount = (round(max_integrity / 3) + 1)	//+ 1 so it's guaranteed to go down in 3 hits, round() isn't consistent with this.
	. = ..()

/obj/structure/fluff/psycross/necra/consecrated/process()
	var/list/checked_dudes = list()
	for(var/mob/living/carbon/human/H in get_hearers_in_view(range, src, RECURSIVE_CONTENTS_CLIENT_MOBS))
		if(!H.devotion)
			continue
		if(H.devotion && istype(H.patron, /datum/patron/divine/necra))
			if(!(H in affected_mobs))
				var/datum/beam/newbeam = Beam(H, icon_state="necra_beam", time = 9999, maxdistance = range)
				affected_mobs[H] = newbeam
			else
				var/datum/beam/B = affected_mobs[H]
				if(!istype(B) || QDELETED(B))	//our beam got deleted, make a new one
					var/datum/beam/newbeam = Beam(H, icon_state="necra_beam", time = 9999, maxdistance = range)
					affected_mobs[H] = newbeam

			var/buff_tier = clamp(range - 1, 1, 3)
			if(HAS_TRAIT(H, TRAIT_CRITICAL_WEAKNESS))
				buff_tier = min(buff_tier + 1, 3)

			if(!H.has_status_effect(/datum/status_effect/buff/necran_mists))
				H.apply_status_effect(/datum/status_effect/buff/necran_mists, buff_tier)

			LAZYADD(checked_dudes, H)

	if(length(checked_dudes) != length(affected_mobs))
		for(var/mob/living/carbon/human/H in affected_mobs)	//We left the range, uh oh.
			if(!(H in checked_dudes))
				var/datum/beam/B = affected_mobs[H]
				if(B)
					B.End()
				H.remove_status_effect(/datum/status_effect/buff/necran_mists)
				LAZYREMOVE(affected_mobs, H)

/obj/structure/fluff/psycross/necra/consecrated/proc/expire_self()
	STOP_PROCESSING(SSobj, src)
	if(length(affected_mobs))
		for(var/mob/living/carbon/human/H in affected_mobs)
			H.remove_status_effect(/datum/status_effect/buff/necran_mists)
			var/datum/beam/B = affected_mobs[H]
			if(istype(B))
				B.End()
	affected_mobs.Cut()
	playsound(src, 'sound/magic/ahh1.ogg', 100, TRUE)
	if(!QDELETED(src))
		qdel(src)

/obj/structure/fluff/psycross/necra/consecrated/obj_destruction(damage_flag)
	expire_self()