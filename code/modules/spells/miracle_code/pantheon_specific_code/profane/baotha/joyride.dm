// T3 - bond that lasts for 8 minutes as long as bonded are within 7 tiles, TRAIT_NOPAIN, spd = 5 end = 3
/datum/action/cooldown/spell/joyride
	name = "Joyride"
	desc = "A frenzy for two to partake in."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "joyride"
	range = 2
	chargetime = 0.5 SECONDS
	invocation_type = "emote"
	invocations = list("exhales. A deep-purple mist dances through the air...")		//apparently you can't get targets in the invocation
	sound = 'sound/magic/magnet.ogg'
	recharge_time = 60 SECONDS
	miracle = TRUE
	devotion_cost = 75
	associated_skill = /datum/skill/magic/holy

/datum/action/cooldown/spell/joyride/cast(list/targets, mob/living/user)
	var/mob/living/target = targets[1]

	var/datum/component/baotha_joyride/existing = user.GetComponent(/datum/component/baotha_joyride)
	if(existing)
		to_chat(user, span_warning("Your fates are already intertwined!"))
		revert_cast()
		return FALSE

	if(!istype(target, /mob/living/carbon) || target == user)
		revert_cast()
		return FALSE

	if(!do_after(user, 3 SECONDS, target = target))
		to_chat(user, span_warning("There is no joy without concentration!"))
		revert_cast()
		return FALSE

	var/holy_skill = user.get_skill_level(associated_skill)
	user.AddComponent(/datum/component/baotha_joyride, target, user, holy_skill)
	target.AddComponent(/datum/component/baotha_joyride/partner, target, user, holy_skill)

	user.visible_message(
		span_notice("[user] and [target] inhale a magenta mist. A strange aching feeling pounds in your chest."),			//baotha, goddess of combat-cuckolding
	)
	return TRUE
