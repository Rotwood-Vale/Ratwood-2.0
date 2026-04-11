/datum/sex_action/chastityplay/kick_cage
	name = "Kick their chastity"
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS

/datum/sex_action/chastityplay/kick_cage/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!requires_other_target(user, target))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_NUTCRACKER))
		return FALSE
	if(!target_has_front_chastity(target))
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/kick_cage/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!requires_other_target(user, target))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_NUTCRACKER))
		return FALSE
	if(user.resting)
		return FALSE
	if(!target_has_front_chastity(target))
		return FALSE
	if(!user.Adjacent(target))
		return FALSE
	if(!can_reach_target_groin(user, target))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_L_FOOT) && !check_location_accessible(user, user, BODY_ZONE_PRECISE_R_FOOT))
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/kick_cage/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/device = target.sexcon.has_chastity_cage() ? "cage" : "belt"
	play_chastity_impact_sound(target, 'sound/combat/hits/kick/kick.ogg', 40, 100, TRUE, -1)
	if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
		user.visible_message(span_warning("[user] places the flat of [user.p_their()] foot against [target]'s spiked [device] and pushes \u2014 slowly, testing how much give there is."))
		return
	user.visible_message(span_warning("[user] shifts [user.p_their()] weight back and raises [user.p_their()] foot, eye-level with [target]'s [device]."))

/datum/sex_action/chastityplay/kick_cage/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/force = user.sexcon.force
	var/device = target.sexcon.has_chastity_cage() ? "cage" : "belt"
	var/msg
	var/arousal_amt = 0.7
	var/pain_amt = 2

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
		user.sexcon.try_pelvis_crush(target)

	switch(force)
		if(SEX_FORCE_LOW)
			msg = "[user] [user.sexcon.get_generic_force_adjective()] rolls [user.p_their()] sole over [target]'s [device] in slow, deliberate circles, the pressure just shy of cruel..."
			arousal_amt = 1.0
			pain_amt = 1.5
		if(SEX_FORCE_MID)
			msg = "[user] [user.sexcon.get_generic_force_adjective()] snaps [user.p_their()] foot into [target]'s [device] with a sharp crack, the impact biting inward through the steel..."
			arousal_amt = 0.6
			pain_amt = 4.5
		if(SEX_FORCE_HIGH)
			msg = "[user] [user.sexcon.get_generic_force_adjective()] hammers [user.p_their()] foot into [target]'s [device] again and again, the rhythm relentless, each kick louder and harder than the last..."
			arousal_amt = 0.25
			pain_amt = 7.5
		if(SEX_FORCE_EXTREME)
			msg = "[user] [user.sexcon.get_generic_force_adjective()] brings [user.p_their()] full weight down on [target]'s [device] in a grinding heel-stomp, steel screaming against steel..."
			arousal_amt = 0.0
			pain_amt = 11

	user.visible_message(user.sexcon.spanify_force(msg))
	if(force >= SEX_FORCE_EXTREME)
		play_chastity_impact_sound(target, 'sound/combat/hits/kick/stomp.ogg', 65, 100, TRUE, -1)
	else
		play_chastity_impact_sound(target, 'sound/combat/hits/kick/kick.ogg', 55, 100, TRUE, -1)
	user.sexcon.perform_sex_action(target, arousal_amt, pain_amt, TRUE)

	if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
		play_chastity_impact_sound(target, 'sound/combat/hits/bladed/genstab (1).ogg', 45, 45)
		user.visible_message(span_warning("The inward spikes punish every strike, digging deeper with each impact!"))
		user.sexcon.perform_sex_action(target, 0, 3.2, TRUE)
		user.sexcon.try_do_pain_scream(target, pain_amt + 3.2)
		if(force >= SEX_FORCE_HIGH && prob(35))
			to_chat(user, span_warning("A spike catches your foot during the kick, stinging sharply."))
			user.sexcon.perform_sex_action(user, 0, 1.2, TRUE)
			user.sexcon.try_do_pain_scream(user, 1.2)
		// At extreme force the heel-stomp can drive the spikes inward hard enough to cause internal torsion damage.
		// Applies to anyone with front chastity regardless of anatomy — the damage is blunt-force internal, not a tear.
		if(force >= SEX_FORCE_EXTREME && prob(20))
			var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
			if(chest && !chest.has_wound(/datum/wound/cbt))
				var/has_cock = !!target.getorganslot(ORGAN_SLOT_PENIS)
				var/has_cunt = !!target.getorganslot(ORGAN_SLOT_VAGINA)
				if(has_cock && has_cunt)
					playsound(get_turf(target), pick('modular/sound/masomoans/agony/CBTScreamIntersex1.ogg', 'modular/sound/masomoans/agony/CBTScreamIntersex2.ogg'), 85, FALSE, 2)
					target.add_splatter_floor(get_turf(target))
					target.visible_message(span_userdanger("[user]'s heel drives [target]'s spiked [device] inward with catastrophic force \u2014 something tears deep through [target.p_their()] groin, blood soaking [target.p_their()] thighs as [target.p_they()] crumple."))
					chest.add_wound(/datum/wound/cbt)
				else if(has_cock)
					playsound(get_turf(target), pick('modular/sound/masomoans/agony/CBTScreamMale1.ogg', 'modular/sound/masomoans/agony/CBTScreamMale2.ogg'), 85, FALSE, 2)
					target.add_splatter_floor(get_turf(target))
					target.visible_message(span_userdanger("[user]'s heel drives the spiked cage inward with full bodyweight behind it \u2014 the crunch that follows is wrong, deep, and [target.p_they()] fold[target.p_s()] immediately, [target.p_their()] stones wrecked by what just happened to them."))
					chest.add_wound(/datum/wound/cbt)
				else if(has_cunt)
					playsound(get_turf(target), pick('modular/sound/masomoans/agony/CBTScreamFemale1.ogg', 'modular/sound/masomoans/agony/CBTScreamFemale2.ogg'), 85, FALSE, 2)
					target.add_splatter_floor(get_turf(target))
					target.visible_message(span_userdanger("The heel-stomp drives [target]'s spiked belt into [target.p_their()] groin with brutal finality \u2014 something gives inside, [target.p_their()] legs buckling as the damage registers and the blood starts."))
					chest.add_wound(/datum/wound/cbt)

	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/kick_cage/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/device = target.sexcon.has_chastity_cage() ? "cage" : "belt"
	user.visible_message(span_warning("[user] drops [user.p_their()] foot and steps back from [target]'s [device], leaving it ringing."))

/datum/sex_action/chastityplay/kick_cage/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
