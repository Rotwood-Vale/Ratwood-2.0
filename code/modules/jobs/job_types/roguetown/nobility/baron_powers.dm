/obj/effect/proc_holder/spell/self/convertrole/militia
	name = "Recruit Militia"
	desc = "Call a local to serve in the barony's militia."
	new_role = "Militiaman"
	overlay_state = "recruit_guard"
	recruitment_faction = "Barony Garrison"
	recruitment_message = "Serve the barony, %RECRUIT!"
	accept_message = "FOR THE BARONY!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/grant_barony_residency
	name = "Grant Residency"
	desc = "Grant someone the right to a house in the barony, or take that right away."
	overlay_state = "recruit_titlegrant"
	antimagic_allowed = TRUE
	recharge_time = 100
	var/residency_range = 3

/obj/effect/proc_holder/spell/self/grant_barony_residency/cast(list/targets, mob/user = usr)
	. = ..()
	var/list/candidates = list()
	for(var/mob/living/carbon/human/candidate in (get_hearers_in_view(residency_range, user) - user))
		if(candidate.mind && candidate.get_face_name(null))
			candidates[candidate.name] = candidate
	if(!length(candidates))
		to_chat(user, span_warning("There is no one in range to hold a house of mine."))
		return
	var/choice = input(user, "Select a resident!", name) as null|anything in candidates
	if(!choice)
		to_chat(user, span_warning("Residency cancelled."))
		return
	var/mob/living/carbon/human/resident = candidates[choice]
	if(QDELETED(resident) || !(resident in get_hearers_in_view(residency_range, user)))
		to_chat(user, span_warning("Residency failed!"))
		return
	toggle_residency(resident, user)

/obj/effect/proc_holder/spell/self/grant_barony_residency/proc/toggle_residency(mob/living/carbon/human/resident, mob/living/carbon/human/baron)
	if(HAS_TRAIT(resident, TRAIT_BARONY_RESIDENT))
		baron.say("I HEREBY STRIP YOU, [uppertext(resident.name)], OF YOUR HOUSE IN THE BARONY!")
		REMOVE_TRAIT(resident, TRAIT_BARONY_RESIDENT, TRAIT_GENERIC)
		return
	baron.say("I HEREBY GRANT YOU, [uppertext(resident.name)], A HOUSE IN THE BARONY!")
	ADD_TRAIT(resident, TRAIT_BARONY_RESIDENT, TRAIT_GENERIC)

/mob/living/carbon/human/proc/declare_barony_outlaw()
	set name = "Declare Barony Outlaw"
	set category = "Voice of Command"
	if(stat)
		return
	var/list/candidates = list()
	for(var/mob/living/carbon/human/candidate in (GLOB.human_list - src))
		if(candidate.mind)
			candidates[candidate.real_name] = candidate
	var/choice = input(src, "Outlaw, or pardon, a person in the barony", "BARON") as null|anything in candidates
	if(!choice)
		return
	var/mob/living/carbon/human/target = candidates[choice]
	if(QDELETED(target))
		return
	toggle_barony_outlaw(target, src)

/proc/toggle_barony_outlaw(mob/living/carbon/human/target, mob/living/carbon/human/baron)
	if(HAS_TRAIT(target, TRAIT_BARONY_OUTLAW))
		REMOVE_TRAIT(target, TRAIT_BARONY_OUTLAW, TRAIT_GENERIC)
		log_game("[key_name(baron)] pardoned [key_name(target)] as a barony outlaw.")
		priority_announce("[target.real_name] is no longer an outlaw of the barony.", "The Baron Decrees", 'sound/misc/royal_decree.ogg', "Captain")
		return
	ADD_TRAIT(target, TRAIT_BARONY_OUTLAW, TRAIT_GENERIC)
	log_game("[key_name(baron)] declared [key_name(target)] a barony outlaw.")
	priority_announce("[target.real_name] has been declared an outlaw of the barony and must be captured or slain.", "The Baron Decrees", 'sound/misc/royal_decree2.ogg', "Captain")
