GLOBAL_LIST_EMPTY(barony_titles)

/obj/effect/proc_holder/spell/self/convertrole/militia
	name = "Recruit Militia"
	desc = "Call a local to serve in the barony's militia."
	new_role = "Militiaman"
	overlay_state = "recruit_guard"
	recruitment_faction = "Barony Garrison"
	recruitment_message = "Serve the barony, %RECRUIT!"
	accept_message = "FOR THE BARONY!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/militia/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(.)
		ADD_TRAIT(recruit, TRAIT_BARONY_WATCH, TRAIT_GENERIC)

/obj/effect/proc_holder/spell/self/convertrole/servant/manor
	name = "Recruit Manor Servant"
	recruitment_message = "Serve the manor, %RECRUIT!"
	accept_message = "FOR THE MANOR!"

/obj/effect/proc_holder/spell/self/grant_title/barony
	name = "Grant Barony Title"
	desc = "Grant someone a title of the barony... Or shame."

/obj/effect/proc_holder/spell/self/grant_title/barony/get_title_registry()
	return GLOB.barony_titles

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

/proc/find_baron(required_stat = CONSCIOUS)
	for(var/mob/living/carbon/human/candidate in GLOB.human_list)
		if(candidate.mind && candidate.job == "Baron" && candidate.stat <= required_stat)
			return candidate

/proc/notify_barony_watch(message)
	for(var/mob/living/carbon/human/watchman in GLOB.human_list)
		if(HAS_TRAIT(watchman, TRAIT_BARONY_WATCH))
			to_chat(watchman, message)

/mob/living/carbon/human/proc/get_barony_targets()
	var/list/targets = list()
	for(var/mob/living/carbon/human/candidate in (GLOB.human_list - src))
		if(candidate.mind)
			targets[candidate.real_name] = candidate
	return targets

/mob/living/carbon/human/proc/declare_barony_outlaw()
	set name = "Declare Barony Outlaw"
	set category = "Voice of Command"
	if(stat)
		return
	var/list/targets = get_barony_targets()
	var/choice = input(src, "Outlaw, or pardon, a person in the barony", "BARON") as null|anything in targets
	if(!choice)
		return
	var/mob/living/carbon/human/target = targets[choice]
	if(QDELETED(target))
		return
	toggle_barony_outlaw(target, src)

/mob/living/carbon/human/proc/request_barony_outlaw()
	set name = "Request Barony Outlaw"
	set category = "Voice of Command"
	if(stat)
		return
	var/list/targets = get_barony_targets()
	var/choice = input(src, "Outlaw, or pardon, a person in the barony", "MASTER WARDEN") as null|anything in targets
	if(!choice)
		return
	var/mob/living/carbon/human/target = targets[choice]
	if(QDELETED(target))
		return
	var/mob/living/carbon/human/baron = find_baron()
	if(baron)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(baron_outlaw_requested), src, baron, target)
		return
	toggle_barony_outlaw(target, src)

/proc/baron_outlaw_requested(mob/living/carbon/human/warden, mob/living/carbon/human/baron, mob/living/carbon/human/target)
	var/choice = alert(baron, "The master warden requests to outlaw, or pardon, [target.real_name]!", "WARDEN OUTLAW REQUEST", "Yes", "No")
	if(choice != "Yes" || QDELETED(baron) || baron.stat > CONSCIOUS || QDELETED(target))
		if(warden)
			to_chat(warden, span_warning("The baron has denied the request for declaring an outlaw!"))
		return
	toggle_barony_outlaw(target, baron)

/proc/toggle_barony_outlaw(mob/living/carbon/human/target, mob/living/carbon/human/declarer)
	if(HAS_TRAIT(target, TRAIT_BARONY_OUTLAW))
		REMOVE_TRAIT(target, TRAIT_BARONY_OUTLAW, TRAIT_GENERIC)
		log_game("[key_name(declarer)] pardoned [key_name(target)] as a barony outlaw.")
		notify_barony_watch(span_notice("[target.real_name] is no longer an outlaw of the barony."))
		return
	ADD_TRAIT(target, TRAIT_BARONY_OUTLAW, TRAIT_GENERIC)
	log_game("[key_name(declarer)] declared [key_name(target)] a barony outlaw.")
	notify_barony_watch(span_userdanger("[target.real_name] has been declared an outlaw of the barony. They must be captured or slain."))

/mob/living/carbon/human/proc/post_barony_bounty()
	set name = "Post Barony Bounty"
	set category = "Voice of Command"
	if(stat)
		return
	var/list/outlaws = list()
	for(var/mob/living/carbon/human/candidate in (GLOB.human_list - src))
		if(candidate.mind && HAS_TRAIT(candidate, TRAIT_BARONY_OUTLAW))
			outlaws[candidate.real_name] = candidate
	if(!length(outlaws))
		to_chat(src, span_warning("No one is outlawed in the barony."))
		return
	var/choice = input(src, "Whose head does the barony want?", "BARON") as null|anything in outlaws
	if(!choice)
		return
	var/mob/living/carbon/human/target = outlaws[choice]
	if(QDELETED(target))
		return
	var/amount = input(src, "How many mammons for the head? The barony pays between [BARONY_BOUNTY_MIN_AMOUNT] and [BARONY_BOUNTY_MAX_AMOUNT].", "BARON") as null|num
	if(isnull(amount))
		return
	amount = round(amount)
	if(amount < BARONY_BOUNTY_MIN_AMOUNT || amount > BARONY_BOUNTY_MAX_AMOUNT)
		to_chat(src, span_warning("The barony pays between [BARONY_BOUNTY_MIN_AMOUNT] and [BARONY_BOUNTY_MAX_AMOUNT] mammons for a head."))
		return
	var/reason = input(src, "For what crimes is [target.real_name] wanted in the barony?", "BARON") as null|text
	if(!reason)
		return
	post_head_bounty(target, amount, reason, real_name)
	notify_barony_watch(span_userdanger("The baron has put [amount] mammons on the head of [target.real_name], wanted in the barony for: [html_encode(reason)]."))
	message_admins("[ADMIN_LOOKUPFLW(src)] has set a barony bounty on [ADMIN_LOOKUPFLW(target)] with the reason of: '[reason]'")
