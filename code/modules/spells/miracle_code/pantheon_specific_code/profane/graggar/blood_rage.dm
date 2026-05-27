//T0: Bloodrage  -- Uncapped STR buff.
/obj/effect/proc_holder/spell/self/graggar_bloodrage
	name = "Bloodrage"
	desc = "Tap into Graggar's wellspring of strength and knowledge, granting unbound power at the cost of temporary insanity and physical exhaustion." 		//reflavored into "graggar grants you some of the strength he got from stealing the souls of miscellaneous ravoxians"
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "bloodrage"
	recharge_time = 5 MINUTES
	invocations = list("SINISTAR, SHATTER MY BINDS!!", // VERY CLEAR that you are a heretic and VERY clear you've popped
						"GRAGGAR, GRAGGAR, GRAGGAR!!", // your anti-stun Im Going to Kill You Now spell
						"I EMBODY THE MOTIVE FORCE!!") // DO NOT add any ambiguious invocations
	invocation_type = "shout"
	sound = 'sound/magic/bloodrage.ogg'
	releasedrain = 10
	miracle = TRUE
	devotion_cost = 80
	antimagic_allowed = FALSE
	range = 0
	var/static/list/purged_effects = list(
	/datum/status_effect/incapacitating/immobilized,
	/datum/status_effect/incapacitating/paralyzed,
	/datum/status_effect/incapacitating/stun,
	/datum/status_effect/incapacitating/knockdown,)

/obj/effect/proc_holder/spell/self/graggar_bloodrage/cast(list/targets, mob/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.resting)
		H.set_resting(FALSE, FALSE)
	H.emote("warcry")
	for(var/effect in purged_effects)
		H.remove_status_effect(effect)
	H.apply_status_effect(/datum/status_effect/buff/bloodrage)
	H.visible_message(span_danger("[H] rises upward, boiling with immense rage!"))
	return TRUE
