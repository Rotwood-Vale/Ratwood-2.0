/atom/movable/screen/alert/status_effect/debuff/feintcd
	name = "Feint Cool down"
	desc = "I used it. I must wait, or risk a lower chance of success."
	icon_state = "feintcd"

/datum/status_effect/debuff/feintcd
	id = "feintcd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/feintcd
	duration = 15 SECONDS

/datum/status_effect/debuff/feintcd/on_creation(mob/living/new_owner, new_dur)
	if(new_dur)
		duration = new_dur
	return ..()

/atom/movable/screen/alert/status_effect/buff/feint_clash
	name = "Feint Clash!"
	desc = "I feinted and they didn't immediately fall for it... they might counter attack!"
	icon_state = "knockdown"

/datum/status_effect/buff/feint_clash
	id = "feint_clash"
	alert_type = /atom/movable/screen/alert/status_effect/buff/feint_clash
	duration = 4 SECONDS
	var/datum/weakref/clashed_mob
	var/was_feinted = FALSE

/datum/status_effect/buff/feint_clash/on_creation(mob/living/new_owner, mob/living/carbon/human/target)
	if(target)
		clashed_mob = WEAKREF(target)
	return ..()

/datum/status_effect/buff/feint_clash/on_remove()
	. = ..()
	if(was_feinted)
		return
	var/mob/living/carbon/human/HT = clashed_mob.resolve()
	if(HT)
		HT.apply_status_effect(/datum/status_effect/debuff/exposed, 5 SECONDS)
		HT.apply_status_effect(/datum/status_effect/debuff/clickcd, 2.5 SECONDS)
		HT.Immobilize(0.5 SECONDS)
		HT.stamina_add(HT.stamina * 0.1)
		HT.Slowdown(2)
		to_chat(owner, span_notice("[HT.p_they(TRUE)] fell for my feint attack!"))
		to_chat(HT, span_danger("I fall for [owner.p_their()] feint attack!"))
		owner.play_overhead_indicator('icons/mob/overhead_effects.dmi', "clash", 2 SECONDS, OBJ_LAYER, soundin = 'sound/combat/riposte.ogg', y_offset = 24)