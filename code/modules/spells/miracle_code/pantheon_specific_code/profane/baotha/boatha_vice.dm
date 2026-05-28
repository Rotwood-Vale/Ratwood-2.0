//T0 that tells the user the person's vice.
/datum/action/cooldown/spell/baotha_vice
	name = "Tell Vice"
	desc = "Tells you the targets Vice."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "vice"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 3
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 SECONDS 
	miracle = TRUE
	devotion_cost = 10
	var/list/fake_vices = list()

/datum/action/cooldown/spell/baotha_vice/cast(list/targets, mob/living/user)
	if(!ishuman(targets?[1]))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]
	var/vice_found

	if(HAS_TRAIT(H, TRAIT_DECEIVING_MEEKNESS) && user.get_skill_level(/datum/skill/magic/holy) <= SKILL_LEVEL_NOVICE)
		if(isnull(fake_vices[H]))
			fake_vices[H] = pick(GLOB.character_flaws)
		vice_found = fake_vices[H]

		if(prob(50 + ((H.STAPER - 10) * 10)))
			to_chat(H, span_warning("A pair of prying eyes were laid on me..."))

	if(!vice_found)
		if(H.charflaws)
			var/list/vices = list()
			for(var/datum/charflaw/cf in H.charflaws)
				vices.Add(cf.name)
			vice_found = english_list(vices)
		else
			to_chat(user, span_warning("Their heart is unreadable."))
			revert_cast()
			return FALSE

	to_chat(user, span_info("They are... [span_warning("a [vice_found]")]"))
	return TRUE
