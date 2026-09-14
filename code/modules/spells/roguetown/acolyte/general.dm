// Lesser miracle
/obj/effect/proc_holder/spell/invoked/lesser_heal
	name = "Miracle"
	desc = "Heals target over time, causes damage if something is embedded in target. Burns undead instead of healing them if you worship the Ten.<br>Does not work on those worshipping the dead god."
	overlay_icon = 'icons/mob/actions/genericmiracles.dmi'
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	overlay_state = "lesserheal"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/heal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = TRUE
	devotion_cost = 10

/obj/effect/proc_holder/spell/invoked/lesser_heal/cast(list/targets, mob/living/user)
	. = ..()

	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]

	if(HAS_TRAIT(user, TRAIT_RESONANCE))//If the caster has the special funny Astratan trait...
		for(var/mob/living/carbon/fortified in view(2, get_turf(user)))
			if(user.patron?.undead_hater && (fortified.mob_biotypes & MOB_UNDEAD))//Resonance allows one to bypass the check above via an AoE. Slight damage to undead as a result.
				fortified.adjustFireLoss(5)
			else if(iscarbon(fortified))
				var/mob/living/carbon/C = fortified
				C.apply_status_effect(/datum/status_effect/buff/fortify)

	if(HAS_TRAIT(target, TRAIT_PSYDONITE))
		target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
		user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		return FALSE

	if(user.patron?.undead_hater && (target.mob_biotypes & MOB_UNDEAD))
		target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I'm burned by holy light!"))
		target.adjustFireLoss(10)
		target.fire_act(1, 10)
		return TRUE

	if(target.has_status_effect(/datum/status_effect/buff/healing))
		to_chat(user, span_warning("They are already under the effects of a healing aura!"))
		revert_cast()
		return FALSE

	var/conditional_buff = FALSE
	var/situational_bonus = 1
	var/is_inhumen = FALSE

	var/message_out = span_info("A choral sound comes from above and [target] is healed!")
	var/message_self = span_notice("I am bathed in healing choral hymns!")

	user.patron.on_lesser_heal(user, target, &message_out, &message_self, &conditional_buff, &situational_bonus, &is_inhumen)

	var/healing = 2.5

	if(conditional_buff)
		if(situational_bonus > 0)
			to_chat(user, "Channeling my patron's power is easier in these conditions!")
		healing += situational_bonus

	if(!ishuman(target))
		target.apply_status_effect(/datum/status_effect/buff/healing, healing, is_inhumen)
		return TRUE

	var/mob/living/carbon/human/human = target
	var/no_embeds = TRUE
	var/list/embeds = human.get_embedded_objects()

	for(var/object in embeds)
		if(istype(object, /obj/item/natural/worms/leech)) // Leeches and surgical cheeles are made an exception.
			continue

		no_embeds = FALSE
		break

	if(!no_embeds)
		target.visible_message("The wounds tear and rip around the embedded objects!", "Agonising pain shoots through your body as magycks try to sew around the embedded objects!")
		human.adjustBruteLoss(20)
		playsound(target, 'sound/combat/dismemberment/dismem (2).ogg', 100)
		human.emote("agony")
		return FALSE

	target.apply_status_effect(/datum/status_effect/buff/healing, healing)
	target.visible_message(message_out, message_self)

	return TRUE

// Miracle
/obj/effect/proc_holder/spell/invoked/heal
	name = "Fortify"
	desc = "Improves the targets ability to receive healing, buffing all healing done on them by 50%<br>Burns undead instead of healing them if you worship the Ten."
	overlay_icon = 'icons/mob/actions/astratamiracles.dmi'
	action_icon = 'icons/mob/actions/astratamiracles.dmi'
	overlay_state = "fortify"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
//	chargedloop = /datum/looping_sound/invokeholy
	chargedloop = null
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/heal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 20

/obj/effect/proc_holder/spell/invoked/heal/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		if(user.patron?.undead_hater && (target.mob_biotypes & MOB_UNDEAD)) //positive energy harms the undead
			target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I'm burned by holy light!"))
			target.adjustFireLoss(25)
			target.fire_act(1,10)
			return TRUE
		target.visible_message(span_info("A wreath of gentle light passes over [target]!"), span_notice("I'm bathed in holy light!"))
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			C.apply_status_effect(/datum/status_effect/buff/fortify)
		else
			target.adjustBruteLoss(-50)
			target.adjustFireLoss(-50)
		return TRUE
	revert_cast()
	return FALSE

// Bishop only miracle - This used to be T3 only but is too powerful and ate into apothecary's niche.
// Instantly heals all wounds & damage on a selected limb.
// Long CD (so a Medical class would still outpace this if there's more than one patient to heal)
/obj/effect/proc_holder/spell/invoked/wound_heal
	name = "Wound Miracle"
	desc = "Heals all wounds on a targeted limb."
	overlay_icon = 'icons/mob/actions/genericmiracles.dmi'
	overlay_state = "woundheal"
	action_icon_state = "woundheal"
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	releasedrain = 15
	chargedrain = 0
	chargetime = 3
	range = 1
	ignore_los = FALSE
	warnie = "sydwarning"
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/magic/woundheal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 2 MINUTES
	miracle = TRUE
	is_cdr_exempt = TRUE
	var/delay = 4.5 SECONDS	//Reduced to 1.5 seconds with Legendary
	devotion_cost = 100

/obj/effect/proc_holder/spell/invoked/wound_heal/cast(list/targets, mob/user = usr)
	if(ishuman(targets[1]))

		var/mob/living/carbon/human/target = targets[1]
		var/mob/living/carbon/human/HU = user
		var/def_zone = check_zone(user.zone_selected)
		var/obj/item/bodypart/affecting = target.get_bodypart(def_zone)

		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE

		if(!affecting)
			revert_cast()
			return FALSE
		if(length(affecting.embedded_objects))
			var/no_embeds = TRUE
			for(var/object in affecting.embedded_objects)
				if(!istype(object, /obj/item/natural/worms/leech))	//Leeches and surgical cheeles are made an exception.
					no_embeds = FALSE
			if(!no_embeds)
				to_chat(user, span_warning("We cannot seal wounds with objects inside this limb!"))
				revert_cast()
				return FALSE
		if(!do_after(user, (delay - (0.5 SECONDS * HU.get_skill_level(associated_skill)))))
			revert_cast()
			to_chat(user, span_warning("We were interrupted!"))
			return FALSE
		var/foundwound = FALSE
		if(length(affecting.wounds))
			for(var/datum/wound/wound in affecting.wounds)
				if(!isnull(wound) && wound.healable_by_miracles)
					wound.heal_wound(wound.whp)
					foundwound = TRUE
					user.visible_message(("<font color = '#488f33'>[capitalize(wound.name)] oozes a clear fluid and closes shut, forming into a sore bruise!</font>"))
					affecting.add_wound(/datum/wound/bruise/woundheal)
			if(foundwound)
				playsound(target, 'sound/magic/woundheal_crunch.ogg', 100, TRUE)
			affecting.change_bodypart_status(BODYPART_ORGANIC, heal_limb = TRUE)
			affecting.update_disabled()
			return TRUE
		else
			to_chat(user, span_warning("The limb is free of wounds."))
			revert_cast()
			return FALSE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/blood_heal
	name = "Blood Transfer Miracle"
	desc = "Transfers the blood from myself to the target with divine magycks. Ratio of transfer scales with holy skill."
	overlay_icon = 'icons/mob/actions/genericmiracles.dmi'
	overlay_state = "bloodheal"
	action_icon_state = "bloodheal"
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	ignore_los = FALSE
	warnie = "sydwarning"
	movement_interrupt = TRUE
	sound = 'sound/magic/bloodheal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 45 SECONDS
	miracle = TRUE
	devotion_cost = 50
	var/blood_price = 5
	var/blood_vol_restore = 7.5 //30 every 2 seconds.
	var/vol_per_skill = 1	//54 with legendary
	var/delay = 0.5 SECONDS

/obj/effect/proc_holder/spell/invoked/blood_heal/cast(list/targets, mob/user = usr)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/target = targets[1]
		var/mob/living/carbon/human/UH = user

		if(target == UH)
			to_chat(UH, span_warning("I cannot transfer my own blood to myself."))
			revert_cast()
			return FALSE

		if(UH.doing)
			to_chat(UH, span_warning("I can't cast this while doing something else."))
			revert_cast()
			return FALSE

		if(NOBLOOD in UH.dna?.species?.species_traits)
			to_chat(UH, span_warning("I have no blood to provide."))
			revert_cast()
			return FALSE

		if(target.get_blood_volume() >= BLOOD_VOLUME_NORMAL)
			to_chat(UH, span_warning("Their lyfeblood is at capacity. There is no need."))
			revert_cast()
			return FALSE

		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE

		UH.visible_message(span_warning("Tiny strands of red link between [UH] and [target], blood being transferred!"))
		playsound(UH, 'sound/magic/bloodheal_start.ogg', 100, TRUE)
		var/user_skill = UH.get_skill_level(associated_skill)
		var/user_informed = FALSE
		switch(user_skill)	//Bleeding happens every life(), which is every 2 seconds. Multiply these numbers by 4 to get the "bleedrate" equivalent values.
			if(SKILL_LEVEL_APPRENTICE)
				blood_price = 3.75
			if(SKILL_LEVEL_JOURNEYMAN)
				blood_price = 2.5
			if(SKILL_LEVEL_EXPERT)
				blood_price = 2
			if(SKILL_LEVEL_MASTER)
				blood_price = 1.625
			if(SKILL_LEVEL_LEGENDARY)
				blood_price = 1.25
		if(user_skill > SKILL_LEVEL_NOVICE)
			blood_vol_restore += vol_per_skill * user_skill
		var/max_loops = round(UH.get_blood_volume() / blood_price, 1) * 2	// x2 just in case the user is trying to fill themselves up while using it.
		var/datum/beam/bloodbeam = user.Beam(target,icon_state="blood",time=(max_loops * 5))
		for(var/i in 1 to max_loops)
			if(UH.get_blood_volume() > (BLOOD_VOLUME_SURVIVE / 2))
				if(do_after(UH, delay))
					target.set_blood_volume(min((target.get_blood_volume() + blood_vol_restore), BLOOD_VOLUME_NORMAL))
					UH.set_blood_volume(max((UH.get_blood_volume() - blood_price), 0))
					if(target.get_blood_volume() >= BLOOD_VOLUME_NORMAL && !user_informed)
						to_chat(UH, span_info("They're at a healthy blood level, but I can keep going."))
						user_informed = TRUE
				else
					UH.visible_message(span_warning("Severs the bloodlink from [target]!"))
					bloodbeam.End()
					return TRUE
			else
				UH.visible_message(span_warning("Severs the bloodlink from [target]!"))
				bloodbeam.End()
				return TRUE
		bloodbeam.End()
		return TRUE
	revert_cast()
	return FALSE
