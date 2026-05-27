// T2 - clears all stress. Forget your worries, pookie bear.
/obj/effect/proc_holder/spell/invoked/lasthigh
	name = "Last High"
	desc = "Pleasure's perfume, just before the fall."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "last_high"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	sound = 'sound/magic/timestop.ogg'
	invocations = list("completely clouds the air around them in a purple smog!")	//useful against any men in the mirror
	invocation_type = "emote"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 MINUTES
	miracle = TRUE
	devotion_cost = 75

/obj/effect/proc_holder/spell/invoked/lasthigh/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.mob_biotypes & MOB_UNDEAD)
			return FALSE

		target.visible_message(
			span_info("[target] is forced to deeply inhale a sweet smelling mist. They twist and choke as spittle runs down the corner of their mouth, yet an eerie calm passes over them."), 
			span_notice("The world fades around me. My throat melts, my stomach churns, and the pounding in my chest feels relentless. I can barely move, but it doesn't matter. Oblivion melts into love in front of my glossed-over eyes.")
		)
		target.adjustToxLoss(3)
		target.add_stress(/datum/stressevent/lasthigh)
		return TRUE

/datum/stressevent/lasthigh
	timer = 10 MINUTES
	stressadd = -99
	desc = span_hypnophrase("The world fades around me. My throat melts, my stomach churns, and the pounding in my chest feels relentless. I can barely move, but it doesn't matter. Oblivion melts into love in front of my glossed-over eyes.") 
