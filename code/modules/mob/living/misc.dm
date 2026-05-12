/mob/living/proc/apply_necras_revival(grace_seconds = 2 MINUTES, touched_type = /datum/status_effect/debuff/necras_touched, claim_type = /datum/status_effect/debuff/necras_claim)
	apply_status_effect(touched_type)
	addtimer(CALLBACK(src, PROC_REF(apply_necras_claim_if_alive), claim_type), grace_seconds)

/mob/living/proc/apply_necras_claim_if_alive(claim_type = /datum/status_effect/debuff/necras_claim)
	if(stat == DEAD)
		return
	apply_status_effect(claim_type)
	to_chat(src, span_danger("Necra's mark settles upon me. Should I fall again too soon, no power can drag me back from Her embrace."))

/mob/proc/food_tempted(/obj/item/W, mob/user)
	return

/mob/proc/taunted(mob/user)
	return

/mob/proc/shood(mob/user)
	return

/mob/proc/beckoned(mob/user)
	return

/mob/proc/get_punch_dmg()
	return
