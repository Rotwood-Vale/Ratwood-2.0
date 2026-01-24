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
	overlay_state = "deathdoor"
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
/obj/effect/proc_holder/spell/self/necra_spirits
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
			revert_cast()

// Speak with dead

/obj/effect/proc_holder/spell/invoked/speakwithdead
    name = "Speak with Dead"
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

/obj/effect/proc_holder/spell/targeted/locate_dead
	name = "Locate Corpse"
	desc = "Call upon the Undermaiden to guide you to a lost soul."
	overlay_state = "necraeye"
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

		corpse_name += " of \a [descriptor_name]..."
		corpses[corpse_name] = C

	if(!length(corpses))
		to_chat(user, span_warning("The Undermaiden's grasp lets slip."))
		revert_cast()
		return .

	var/mob/selected = tgui_input_list(user, "Which body shall I seek?", "Available Bodies", corpses)

	if(QDELETED(src) || QDELETED(user) || QDELETED(corpses[selected]))
		to_chat(user, span_warning("The Undermaiden's grasp lets slip."))
		return .

	var/corpse = corpses[selected]

	var/turf/turf_user = get_turf(user)
	var/turf/turf_corpse = get_turf(corpse)
	var/list/directions = list()
	// Vertical (Z-level) direction
	if(turf_user.z != turf_corpse.z)
		if(turf_corpse.z > turf_user.z)
			directions += "upwards"
		else
			directions += "downwards"

	// Horizontal direction (only if we can meaningfully compare)
	if(turf_user.x != turf_corpse.x || turf_user.y != turf_corpse.y)
		var/direction = get_dir(turf_user, turf_corpse)
		switch(direction)
			if(NORTH)      directions += "north"
			if(SOUTH)      directions += "south"
			if(EAST)       directions += "east"
			if(WEST)       directions += "west"
			if(NORTHEAST)  directions += "northeast"
			if(NORTHWEST)  directions += "northwest"
			if(SOUTHEAST)  directions += "southeast"
			if(SOUTHWEST)  directions += "southwest"
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

	var/direction_text
	if(length(directions))
		direction_text = english_list(directions, and_text = " and ")
	else
		direction_text = "nowhere discernible"

	to_chat(user, span_notice("The Undermaiden pulls on your hand, guiding you [direction_text]. [distance_text]"))