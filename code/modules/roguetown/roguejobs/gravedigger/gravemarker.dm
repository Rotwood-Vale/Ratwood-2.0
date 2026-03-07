/datum/crafting_recipe/roguetown/gravemarker
	name = "grave marker"
	result = /obj/structure/gravemarker
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	time = 10 SECONDS
	verbage_simple = "tie together"
	verbage = "ties together"
	craftsound = 'sound/foley/Building-01.ogg'
	structurecraft = /obj/structure/closet/dirthole
	craftdiff = 0

/datum/crafting_recipe/roguetown/gravemarker/TurfCheck(mob/user, turf/T)
	if(!(locate(/obj/structure/closet/dirthole) in T))
		to_chat(user, span_warning("There is no grave here."))
		return FALSE
	for(var/obj/structure/closet/dirthole/D in T)
		if(D.stage != 4)
			to_chat(user, span_warning("The grave isn't covered."))
			return FALSE
	if(locate(/obj/structure/gravemarker) in T)
		to_chat(user, span_warning("This grave is already hallowed."))
		return FALSE
	return TRUE

/obj/structure/gravemarker
	name = "grave marker"
	desc = "A simple marker honouring the departed.."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "gravemarker1"
	density = FALSE
	max_integrity = 0
	static_debris = list(/obj/item/grown/log/tree/stick = 1)
	anchored = TRUE
	layer = 2.91
	obj_flags = UNIQUE_RENAME
	var/wrotesign
	var/submission = TRUE

/obj/structure/gravemarker/examine(mob/user)
	. = ..()
	if(wrotesign)
		if(!user.is_literate())
			. += "I do not know how to read. Not like this one's name matters much anymore."
		else
			. += span_notice("A grave marker. It says... \"[wrotesign]\".")


/obj/structure/gravemarker/attackby(obj/item/W, mob/user, params)
	if(!user.cmode)
		if(!user.is_literate())
			to_chat(user, span_warning("I do not know how to write. It shall remain unmarked."))
			return
		if((user.used_intent.blade_class == BCLASS_STAB) && (W.wlength == WLENGTH_SHORT))
			if(wrotesign)
				to_chat(user, span_warning("Something is already carved here."))
				return
			else
				var/inputty = stripped_input(user, "Someone rests here. Perhaps I should carve a name?", "", null, 200)
				if(inputty && !wrotesign)
					wrotesign = inputty
					name = "[inputty]"
		else
			to_chat(user, span_warning("Alas, this will not work. I could carve words, if I stabbed at this with something posessing a short, sharp point. A knife comes to mind."))
			return

/obj/structure/gravemarker/Destroy()
	var/turf/T = get_turf(src)
	if(T)
		new /obj/item/grown/log/tree/stick(T)
	..()

/mob/dead/new_player/proc/reducespawntime(amt)
	if(ckey)
		if(amt)
			if(GLOB.respawntimes[ckey])
				GLOB.respawntimes[ckey] = GLOB.respawntimes[ckey] + amt

/obj/structure/gravemarker/OnCrafted(dir, mob/user)
	. = ..()
	icon_state = "gravemarker[rand(1,3)]"

	for(var/obj/structure/closet/dirthole/hole in loc)
		for(var/mob/living/carbon/human/corpse in hole)

			if(corpse.stat != DEAD)
				continue

			 //Check essential body parts before proceeding
			if(!corpse.get_bodypart(BODY_ZONE_HEAD))
				to_chat(user, span_userdanger("You cannot give this corpse a proper burial without its head."))
				continue

			if(!corpse.getorgan(/obj/item/organ/brain))
				to_chat(user, span_userdanger("You cannot give this corpse a proper burial without a brain, who would recieve it?."))
				continue

			to_chat(user, span_notice("I feel their soul finding peace..."))
			SEND_SIGNAL(user, COMSIG_GRAVE_CONSECRATED, hole)
			var/submission = ask_burial(corpse, user)

			if(submission)
				(pacify_coffin(hole, user))

			else//fakes burial so you can kill bill your way out
				record_round_statistic(STATS_BURIALS_REJECTED)

/proc/ask_burial(mob/living/carbon/human/corpse, mob/user)

	if(!corpse)
		return FALSE

	if(!corpse.mind || !corpse.mind.key)
		return TRUE

	var/mob/target = corpse

	var/mob/dead/observer/ghost = corpse.get_ghost()
	if(ghost)
		target = ghost

	var/choice = tgui_alert(
		target,
		"Do you submit to burial and pass on?\nYou have 60 seconds to decide.",
		"CHOICE OF LYFE",
		list("LIVE","REST"),
		60 SECONDS
	)

	if(!choice)
		choice = "REST"

	if(choice == "REST")
		return TRUE

	if(choice == "LIVE")


		//removes cuffs
		corpse.uncuff()

		// Restore heart if missing
		if(!corpse.getorgan(/obj/item/organ/heart))
			var/obj/item/organ/heart/H = new /obj/item/organ/heart()
			H.Insert(corpse)

		//removes zombie status
		corpse.mind.remove_antag_datum(/datum/antagonist/zombie)
		corpse.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)

		// Apply revive penalties and healing
		corpse.apply_status_effect(/datum/status_effect/debuff/revived)
		corpse.apply_status_effect(/datum/status_effect/buff/burial/determination, 0.1)

		var/list/wounds = corpse.get_wounds()
		//Prevents chain death
		if(wounds && wounds.len)
			corpse.heal_wounds(
			0,
			list(
				/datum/wound/dismemberment,
				/datum/wound/slash,
				/datum/wound/artery,
				/datum/wound/puncture,
				/datum/wound/fracture/head,
				/datum/wound/fracture/head/brain,
				/datum/wound/fracture/neck
				)
			)

		corpse.revive(full_heal = FALSE)
		corpse.grab_ghost(force = TRUE)
		corpse.update_body()
		to_chat(corpse,span_userdanger("Through sheer will you find a surge of strength, clawing your way back from death.")
						)

		return FALSE


