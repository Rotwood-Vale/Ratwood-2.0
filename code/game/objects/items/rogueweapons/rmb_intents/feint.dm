#define FEINT_BASE 50
#define INT_PERCENTAGE_BONUS 10
#define SKILL_PERCENTAGE_BONUS 15
#define FEINT_MAX_CHANCE 95
#define FEINT_MIN_CHANCE 5
#define FEINT_CLASH_CHANCE 50

/datum/rmb_intent/feint
	name = "feint"
	desc = "(RMB WHILE DEFENSE IS ACTIVE) A deceptive half-attack with no follow-through, meant to force your opponent to open their guard."
	icon_state = "rmbfeint"

/datum/rmb_intent/feint/special_attack(mob/living/user, atom/target)
	if(!isliving(target))
		return
	if(!user)
		return
	if(user.incapacitated())
		return
	if(!user.mind)
		return
	if(user.has_status_effect(/datum/status_effect/debuff/feintcd))
		return

	var/mob/living/HT = target
	var/mob/living/carbon/human/HU = user

	if(ishuman(HT)) // You feint someone who just tried to feint you, cancelling their attempted feint
		var/datum/status_effect/buff/feint_clash/clash = HT.has_status_effect(/datum/status_effect/buff/feint_clash)
		if(clash) // No need to check for mind as this will never happen with an NPC
			var/mob/living/carbon/human/clashed_mob = clash.clashed_mob.resolve()
			if(clashed_mob && clashed_mob == HU)
				clash.was_feinted = TRUE
				HU.play_overhead_indicator('icons/mob/overhead_effects.dmi', "clashr", 2 SECONDS, OBJ_LAYER, soundin = 'sound/combat/clash_draw.ogg', y_offset = 24)
				HU.visible_message(span_danger("[HU] counters [HT]'s feint, saving themselves from exposing their guard!"))
				HT.remove_status_effect(/datum/status_effect/buff/feint_clash)
			return

	// Anti typebait
	if(world.time < HT.last_cmode_time + CMODE_TIME_BUFFER) // You attempted to feint someone who wasn't in combat mode within the past 15 seconds
		playsound(user, 'sound/combat/feint.ogg', 100, TRUE)
		HU.visible_message(span_danger("[HU] feints an attack at [HT], and makes a fool of themselves!"))
		HU.Slowdown(3)
		HU.OffBalance(2 SECONDS)
		HU.apply_status_effect(/datum/status_effect/debuff/feintcd)
		return

	HU.visible_message(span_danger("[HU] feints an attack at [HT]!"))

	var/perc = FEINT_BASE
	var/obj/item/IT = HT.get_active_held_item()
	var/obj/item/IU = HU.get_active_held_item()
	var/ourskill = 0
	var/theirskill = 0
	var/skill_factor = 0
	if(HT.has_status_effect(/datum/status_effect/debuff/exposed))
		perc = 0
	else
		// Riposte counters feint, but if an active riposte is up, feint counters it.
		if(HT.d_intent == INTENT_PARRY) // No immunity. Just -20% chance to be feinted.
			if(istype(HT.rmb_intent, /datum/rmb_intent/riposte) && !HT.has_status_effect(/datum/status_effect/buff/clash)) 
				perc -= 20
		if(istype(HT.rmb_intent, /datum/rmb_intent/aimed)) // 10% easier to feint someone who is on aimed intent
			perc += 10
		if(IU)
			if(IU.associated_skill)
				ourskill = HU.get_skill_level(IU.associated_skill)
			if(HT.mind)
				if(IT?.associated_skill)
					theirskill = HT.get_skill_level(IT.associated_skill)
		perc += (ourskill - theirskill) * SKILL_PERCENTAGE_BONUS
		perc += (HU.STAINT - HT.STAINT) * INT_PERCENTAGE_BONUS
		if(HT.IsOffBalanced()) // Easier to feint a target who is off-balanced.
			perc += 10
		if(HU.IsOffBalanced() || !(HU.mobility_flags & MOBILITY_STAND)) // Feinter is off balanced or lying down? Shoddy feint
			perc -= 30
		skill_factor = (ourskill - theirskill)/2
		perc = CLAMP(perc, FEINT_MIN_CHANCE, FEINT_MAX_CHANCE)

	HU.apply_status_effect(/datum/status_effect/debuff/feintcd)
	HU.stamina_add(HU.stamina * 0.1)

	if(HT.has_status_effect(/datum/status_effect/buff/clash)) // Guaranteed feint on an active guard. 
		HT.remove_status_effect(/datum/status_effect/buff/clash)
		to_chat(HU, span_notice("[HT.p_their(TRUE)] guard disrupted!"))
	else if(!prob(perc))
		playsound(HU, 'sound/combat/feint.ogg', 100, TRUE)
		if(HU.client?.prefs.showrolls)
			to_chat(HU, span_warning("[HT.p_they(TRUE)] did not fall for my feint... [perc]%"))
		return

	if(HT.mind) // Won't happen against NPCs
		if(istype(HT.rmb_intent, /datum/rmb_intent/feint)) // Feint-on-feint violence!!!
			if(IU && IT)
				if(ishuman(HU) && ishuman(HT)) // Won't happen against NPCs
					if(prob(FEINT_CLASH_CHANCE))
						HU.play_overhead_indicator('icons/mob/overhead_effects.dmi', "clashtwo", 4 SECONDS, OBJ_LAYER, soundin = 'sound/combat/clash_initiate.ogg', y_offset = 24)
						HT.play_overhead_indicator('icons/mob/overhead_effects.dmi', "clashtwo", 4 SECONDS, OBJ_LAYER, soundin = 'sound/combat/clash_initiate.ogg', y_offset = 24)
						HU.visible_message(span_danger("[HU] clashes with [HT], leaving themselves open to a counter attack from [HT]!"))
						HU.apply_status_effect(/datum/status_effect/buff/feint_clash, HT)
						return

	HT.apply_status_effect(/datum/status_effect/debuff/exposed, 5 SECONDS)
	HT.apply_status_effect(/datum/status_effect/debuff/clickcd, max(1.5 SECONDS + skill_factor, 2.5 SECONDS))
	HT.Immobilize(0.5 SECONDS)
	HT.stamina_add(HT.stamina * 0.1)
	HT.Slowdown(2)
	to_chat(HU, span_notice("[HT.p_they(TRUE)] fell for my feint attack!"))
	to_chat(HT, span_danger("I fall for [HU.p_their()] feint attack!"))
	playsound(HU, 'sound/combat/riposte.ogg', 100, TRUE)

#undef FEINT_BASE
#undef INT_PERCENTAGE_BONUS
#undef SKILL_PERCENTAGE_BONUS
#undef FEINT_MAX_CHANCE
#undef FEINT_MIN_CHANCE
#undef FEINT_CLASH_CHANCE