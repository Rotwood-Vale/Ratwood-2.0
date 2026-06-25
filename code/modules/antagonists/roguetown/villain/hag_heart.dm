/obj/structure/roguemachine/hag_heart
	name = "Mossmother's Heart"
	desc = "A pulsing, grotesque organ made of moss, roots, and something unspeakable. It thrums with the Mossmother's ancient power. The hag draws her immortality from this artifact."
	icon = 'icons/roguetown/items/hag/hag_heart.dmi'
	icon_state = "heart"
	density = TRUE
	anchored = TRUE
	max_integrity = 150
	var/datum/antagonist/hag/bound_hag
	var/destroyed = FALSE
	// Grand Rite tracking
	var/current_stage = 1
	var/max_stages = 3
	var/timer_id
	var/datum/hag_rite/chosen_rite
	var/list/delivered_items = list()
	var/rite_started = FALSE
	var/rite_completed = FALSE
	var/static/list/rite_requirements = alist(
		1 = list(/obj/item/reagent_containers/lux = 2, /obj/item/magic/manacrystal = 1),
		2 = list(/obj/item/magic/voidstone = 1, /obj/item/roguegem/diamond = 1),
		3 = list(/obj/item/magic/leyline = 1, /obj/item/ingot/gold = 2, /obj/item/magic/artifact = 1),
	)

/obj/structure/roguemachine/hag_heart/Initialize(mapload)
	. = ..()
	GLOB.hag_hearts += src

/obj/structure/roguemachine/hag_heart/Destroy()
	GLOB.hag_hearts -= src
	if(timer_id)
		deltimer(timer_id)
		priority_announce("The Grand Rite has been thwarted! The cackling fades into a pathetic whimper.", "Rite Severed")
		GLOB.hag_rite_active = FALSE
	if(!destroyed)
		on_destroyed()
	return ..()

/obj/structure/roguemachine/hag_heart/proc/on_damage()
	// Signal handler for when heart takes damage
	// Will add more logic in Phase 2 for ward mechanics
	return

/// Wards protect the heart. While any ward remains standing, the heart cannot be damaged.
/obj/structure/roguemachine/hag_heart/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armor_penetration = 0, object_damage_multiplier = 1)
	if(length(GLOB.hag_wards))
		if(sound_effect)
			src.visible_message(span_notice("Magical energy still safeguards the heart. The wards must fall first."))
		return FALSE
	return ..()

/obj/structure/roguemachine/hag_heart/proc/on_destroyed()
	destroyed = TRUE
	visible_message(span_boldwarning("The Mossmother's Heart shatters! Its ancient power dissipates into the bog!"))
	priority_announce("A terrible crack echoes across the land. The Mossmother's Heart has been destroyed — the hag can now be slain for good.", "The Heart Falls")
	// Notify the bound hag directly
	if(bound_hag?.owner?.current)
		to_chat(bound_hag.owner.current, span_userdanger("My heart is gone. If I die now, I will not return."))

/obj/structure/roguemachine/hag_heart/proc/link_hag(datum/antagonist/hag/hag_datum)
	bound_hag = hag_datum

/obj/structure/roguemachine/hag_heart/proc/get_bound_hag()
	return bound_hag

/obj/structure/roguemachine/hag_heart/examine(mob/user)
	. = ..()
	if(!bound_hag || !istype(user.mind?.has_antag_datum(/datum/antagonist/hag), /datum/antagonist/hag))
		return
	if(timer_id)
		var/time_left = timeleft(timer_id)
		if(time_left > 0)
			. += span_boldnotice("The Grand Rite of [chosen_rite.name] is in progress! [DisplayTimeText(time_left)] remain.")
		else
			. += span_boldnotice("The Grand Rite is reaching its crescendo...")
		return
	if(current_stage > max_stages)
		. += span_boldnotice("The tithes are complete. Interact with the heart to choose your Grand Rite.")
		return
	. += span_notice("The heart demands Stage [current_stage] tithes. Offer one of the following:")
	var/list/options = rite_requirements[current_stage]
	for(var/path in options)
		. += span_info("- [options[path]]x [initial(path:name)]")

/obj/structure/roguemachine/hag_heart/attackby(obj/item/I, mob/user, params)
	// Only the bound hag can make tithes
	if(!istype(user.mind?.has_antag_datum(/datum/antagonist/hag), /datum/antagonist/hag))
		return ..()
	if(current_stage > max_stages || timer_id)
		return ..()

	var/list/current_reqs = rite_requirements[current_stage]
	var/path_to_check = I.type

	var/is_valid = FALSE
	for(var/req_path in current_reqs)
		if(istype(I, req_path))
			path_to_check = req_path
			is_valid = TRUE
			break

	if(!is_valid)
		to_chat(user, span_warning("The heart has no hunger for [I]."))
		return ..()

	var/total_needed = current_reqs[path_to_check]
	var/already_delivered = delivered_items[path_to_check] || 0

	user.transferItemToLoc(I, src, TRUE)
	qdel(I)
	already_delivered++
	delivered_items[path_to_check] = already_delivered

	to_chat(user, span_notice("The heart pulses greedily as it consumes the [initial(path_to_check:name)]. ([already_delivered]/[total_needed])"))
	playsound(src, 'sound/magic/slimesquish.ogg', 50, TRUE)

	if(already_delivered >= total_needed)
		to_chat(user, span_boldnotice("The heart has been satiated with [initial(path_to_check:name)] for this stage!"))
		// Check if the entire stage is complete
		var/stage_done = TRUE
		for(var/req_path in current_reqs)
			var/needed = current_reqs[req_path]
			if((delivered_items[req_path] || 0) < needed)
				stage_done = FALSE
				break
		if(stage_done)
			current_stage++
			delivered_items.Cut()
			if(current_stage > max_stages)
				to_chat(user, span_boldnotice("The tithes are complete! The heart is ready to channel your spite. Interact with it to choose your Grand Rite."))
	return TRUE

/obj/structure/roguemachine/hag_heart/attack_hand(mob/living/user)
	if(!istype(user.mind?.has_antag_datum(/datum/antagonist/hag), /datum/antagonist/hag))
		return ..()
	if(current_stage > max_stages && !timer_id && !rite_started)
		select_rite(user)
	return ..()

/obj/structure/roguemachine/hag_heart/proc/select_rite(mob/living/user)
	if(!user.GetComponent(/datum/component/hag_curio_tracker))
		to_chat(user, span_warning("Your soul is not twisted enough to conduct this rite."))
		return

	var/list/rites = list()
	for(var/path in subtypesof(/datum/hag_rite))
		var/datum/hag_rite/R = new path()
		rites[R.name] = R

	var/selection = tgui_input_list(user, "Choose the Grand Rite", "The Final Cackle", rites)
	if(!selection || timer_id)
		return

	chosen_rite = rites[selection]
	priority_announce("A terrible, ancient cackle echoes across the land. The Grand Rite of [chosen_rite.name] has begun! You have 20 minutes.", "The Mossmother Stirs")

	rite_started = TRUE
	GLOB.hag_rite_active = TRUE
	timer_id = addtimer(CALLBACK(src, PROC_REF(finish_rite)), 20 MINUTES, TIMER_STOPPABLE)

/obj/structure/roguemachine/hag_heart/proc/finish_rite()
	if(!chosen_rite)
		return

	// Find the live bound hag's curio component
	var/datum/component/hag_curio_tracker/HCT
	if(bound_hag?.owner?.current && bound_hag.owner.current.stat != DEAD)
		HCT = bound_hag.owner.current.GetComponent(/datum/component/hag_curio_tracker)

	if(!HCT)
		priority_announce("The Grand Rite fizzles away... the Mossmother has no tether left in this realm.", "Rite Failed")
		GLOB.hag_rite_active = FALSE
		return

	priority_announce("The Grand Rite is complete. [chosen_rite.name] has fallen upon the world! Ancient grievances are at last settled.", "The Mossmother Ascends")
	rite_completed = TRUE
	GLOB.hag_rite_active = FALSE

	// Curse every living player who is NOT a current boon-holding ally (no curse scar)
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.stat == DEAD || !H.mind)
			continue
		if(H.mind.has_antag_datum(/datum/antagonist/hag))
			continue
		// Active pact-bearers with NO curse are allies — spare them
		if(H.mind in bound_hag.bound_followers)
			continue
		bound_hag.active_curses[H.mind] ||= list()
		var/datum/hag_curse/curse = new chosen_rite.curse_path(H.mind, 100)
		bound_hag.active_curses[H.mind] += curse
		to_chat(H, span_userdanger("The world screams in agony. You are now afflicted by [chosen_rite.name]!"))

/// HAG RITE DATUMS

/datum/hag_rite
	var/name = "Generic Rite"
	var/desc = "A dark ritual."
	var/curse_path = /datum/hag_curse/unseemly

/datum/hag_rite/blighted_earth
	name = "The Rite of Blighted Earth"
	desc = "The bog's rot seeps into the legs of all mortals, leaving them shuffling through the world like the dead."
	curse_path = /datum/hag_curse/no_run

/datum/hag_rite/unveiled_ugliness
	name = "The Rite of Unveiled Ugliness"
	desc = "The veil of vanity is stripped away, leaving all mortals grotesque to behold."
	curse_path = /datum/hag_curse/unseemly

/datum/hag_rite/silent_world
	name = "The Rite of the Silent World"
	desc = "The Mossmother steals every tongue. No voice will carry until her spite is sated."
	curse_path = /datum/hag_curse/mute
