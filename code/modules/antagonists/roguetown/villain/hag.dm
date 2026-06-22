/datum/antagonist/hag
	name = "Hag"
	roundend_category = "Hags"
	antagpanel_category = "Roguetown"
	show_name_in_check_antagonists = TRUE
	job_rank = ROLE_HAG
	rogue_enabled = TRUE
	can_coexist_with_others = FALSE
	confess_lines = list(
		"I HEAR THE MOSSMOTHER'S WHISPERS!",
		"THE BOG HAS CLAIMED ME!",
		"MY GIFTS ALWAYS COME DUE!",
	)

	var/list/datum/mind/bound_followers = list()
	var/list/follower_links = list()

/datum/antagonist/hag/get_antag_cap_weight()
	return 2

/datum/antagonist/hag/on_gain()
	. = ..()
	if(!owner || !owner.current)
		return

	owner.special_role = name
	if(!objectives.len)
		var/datum/objective/hag/revenge_objective = new /datum/objective/hag(owner = owner)
		objectives += revenge_objective
		owner.store_memory("Objective: [revenge_objective.explanation_text]")

	if(length(GLOB.hag_starts))
		owner.current.forceMove(pick(GLOB.hag_starts))

	greet()

/datum/antagonist/hag/greet()
	to_chat(owner.current, span_userdanger("The bog answers my spite. Bind mortals to my will and prepare my revenge."))
	owner.announce_objectives()
	..()

/datum/antagonist/hag/apply_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/hag_body = mob_override || owner?.current
	if(!istype(hag_body) || !hag_body.mind)
		return
	hag_body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/hag_pact)

/datum/antagonist/hag/remove_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/hag_body = mob_override || owner?.current
	if(!istype(hag_body) || !hag_body.mind)
		return
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/hag_pact)

/datum/antagonist/hag/on_removal()
	cleanup_bound_followers()
	return ..()

/datum/antagonist/hag/proc/get_boon_source()
	return "hag_boon_[REF(src)]"

/datum/antagonist/hag/proc/add_bound_follower(datum/mind/follower)
	if(!follower)
		return
	bound_followers |= follower

/datum/antagonist/hag/proc/remove_bound_follower(datum/mind/follower)
	if(!follower)
		return
	bound_followers -= follower

/datum/antagonist/hag/proc/bind_follower(mob/living/carbon/human/target)
	if(!target?.mind || !owner?.current)
		return FALSE
	if(target.mind in bound_followers)
		return FALSE

	add_bound_follower(target.mind)
	ADD_TRAIT(target, TRAIT_LEECHIMMUNE, get_boon_source())

	var/datum/mindlink/link = new(owner.current, target)
	GLOB.mindlinks += link
	follower_links[target.mind] = link
	return TRUE

/datum/antagonist/hag/proc/unbind_follower(datum/mind/follower)
	if(!follower)
		return

	var/datum/mindlink/link = follower_links[follower]
	if(link)
		GLOB.mindlinks -= link
		qdel(link)
	follower_links -= follower

	if(follower.current)
		REMOVE_TRAIT(follower.current, TRAIT_LEECHIMMUNE, get_boon_source())

	remove_bound_follower(follower)

/datum/antagonist/hag/proc/cleanup_bound_followers()
	for(var/datum/mind/follower as anything in bound_followers.Copy())
		unbind_follower(follower)

/datum/antagonist/hag/roundend_report()
	var/list/report = list()
	report += span_header("The Hag")
	if(considered_alive(owner))
		report += span_greentext("The hag still lurked within the bog by round end.")
	else
		report += span_redtext("The hag's revenge was cut short.")
	if(length(bound_followers))
		report += span_notice("Bound followers gathered: [length(bound_followers)]")
	return report.Join("<br>")

/obj/effect/proc_holder/spell/invoked/hag_pact
	name = "Seal Pact"
	desc = "Offer a minor boon to a nearby mortal, binding them to your service if they accept."
	overlay_state = "mindlink"
	releasedrain = 30
	chargedrain = 0
	chargetime = 10
	recharge_time = 1 MINUTES
	range = 1
	ignore_los = FALSE
	warnie = "spellwarning"
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokegen
	sound = 'sound/magic/whiteflame.ogg'
	clothes_req = FALSE
	human_req = TRUE
	miracle = FALSE
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocations = list("Weave and wither")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/invoked/hag_pact/cast(list/targets, mob/living/user)
	if(!ishuman(targets[1]))
		to_chat(user, span_warning("Only mortals can be bound into a hag's pact."))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/target = targets[1]
	var/datum/antagonist/hag/hag_datum = user?.mind?.has_antag_datum(/datum/antagonist/hag)
	if(!hag_datum)
		revert_cast()
		return FALSE
	if(target == user)
		to_chat(user, span_warning("I cannot bargain with myself."))
		revert_cast()
		return FALSE
	if(!target.client || !target.mind)
		to_chat(user, span_warning("There is no willing mortal mind here to bind."))
		revert_cast()
		return FALSE
	if(target.mind.has_antag_datum(/datum/antagonist))
		to_chat(user, span_warning("Their nature is already claimed by another dark calling."))
		revert_cast()
		return FALSE
	if(target.mind in hag_datum.bound_followers)
		to_chat(user, span_warning("[target] is already bound to my pact."))
		revert_cast()
		return FALSE

	var/consent = alert(target, "[user.real_name] offers a hag's pact. Accept a minor bog-blessing and a telepathic bond?", "Hag Pact", "Accept", "Refuse")
	if(consent != "Accept")
		to_chat(user, span_warning("[target] refuses my bargain."))
		to_chat(target, span_notice("I refuse the hag's bargain."))
		revert_cast()
		return FALSE

	if(!hag_datum.bind_follower(target))
		to_chat(user, span_warning("The pact slips away before it can take hold."))
		revert_cast()
		return FALSE

	user.visible_message(span_notice("[user] seals a sinister pact with [target]."), span_notice("I bind [target] to my pact with a sliver of bog-magic."))
	to_chat(target, span_userdanger("The pact settles into my flesh. Bog leeches will shun me, and I can speak to the hag with ,m."))
	to_chat(user, span_notice("[target] is now bound to my pact. I can speak to them with ,m."))
	return TRUE
