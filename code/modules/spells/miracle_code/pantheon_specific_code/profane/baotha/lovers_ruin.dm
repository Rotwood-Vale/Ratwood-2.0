// T1, orison inspired healing spell that pours a drink called Lover's Ruin. Works like a red for baotha blessed, poisons non-blessed.
/obj/effect/proc_holder/spell/targeted/touch/loversruin
	name = "Lover's Ruin"
	desc = "A toast to passion that ends in ash.\n \
		Beseech Baotha to pour wine onto a container. Poisons the unfaithful, rewards Her blessed with healing."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "ruin"
	chargedrain = 0
	chargetime = 0
	releasedrain = 5
	miracle = TRUE
	devotion_cost = 5
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	hand_path = /obj/item/melee/touch_attack/loversruin
	recharge_time = 2 MINUTES

/obj/item/melee/touch_attack/loversruin
	name = "Baotha's Touch"
	catchphrase = null
	possible_item_intents = list(/datum/intent/fill)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#FFFFFF"
	var/right_click = FALSE

/obj/item/melee/touch_attack/loversruin/attack_self()
	qdel(src)

/obj/item/melee/touch_attack/loversruin/afterattack(atom/target, mob/living/carbon/human/user, proximity)
	if(istype(user.used_intent, /datum/intent/fill) && create_ichor(target, user))
		qdel(src)

/datum/reagent/medicine/loversruin
	name = "Lover's Ruin"
	description = "A sweet smelling concoction. It has small charred petals swimming on the surface."
	color = "#9c2745"
	taste_description = "sin"

/datum/reagent/medicine/loversruin/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_CRACKHEAD))
		if(volume >= 10)
			M.reagents.remove_reagent(/datum/reagent/medicine/loversruin, 2)
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+5, BLOOD_VOLUME_NORMAL)
		var/list/wCount = M.get_wounds()
		if(wCount.len > 0)
			M.heal_wounds(2, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise, /datum/wound/dynamic))
		if(volume > 0.99)
			M.adjustBruteLoss(-2  * REAGENTS_EFFECT_MULTIPLIER, 0)
			M.adjustFireLoss(-2  * REAGENTS_EFFECT_MULTIPLIER, 0)
			M.adjustOxyLoss(-2, 0)
			M.adjustToxLoss(-2, 0)
			M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5  * REAGENTS_EFFECT_MULTIPLIER)
			M.adjustCloneLoss(-4  * REAGENTS_EFFECT_MULTIPLIER, 0)
	else
		M.adjustToxLoss(3, 0)
		M.adjustOxyLoss(1, 0)
	..()

/obj/item/melee/touch_attack/loversruin/proc/create_ichor(atom/thing, mob/living/carbon/human/user)
	if(!thing.Adjacent(user))
		to_chat(user, span_info("I need to be closer to [thing] in order to try filling it with the concoction."))
		return

	if(thing.is_refillable())
		if(thing.reagents.holder_full())
			to_chat(user, span_warning("[thing] is full."))
			return
		
		user.visible_message(span_info("[user] extends a hand over [thing]. Sweet-smelling ichor drips from [user.p_their()] fingertips, like blood."), span_notice("I call forth [user.patron.name], to fill [thing] with Her blessings..."))

		var/holy_skill = user.get_skill_level(attached_spell.associated_skill)
		var/drip_speed = 56 - (holy_skill * 8)
		var/fatigue_spent = 0
		var/fatigue_used = max(3, holy_skill)
		while(do_after(user, drip_speed, target = thing))
			if(thing.reagents.holder_full() || (user.devotion.devotion - fatigue_used <= 0))
				break

			var/water_qty = max(1, holy_skill) + 1
			var/list/water_contents = list(/datum/reagent/medicine/loversruin = water_qty)
			var/datum/reagents/reagents_to_add = new()
			reagents_to_add.add_reagent_list(water_contents)
			reagents_to_add.trans_to(thing, reagents_to_add.total_volume, transfered_by = user, method = INGEST)

			fatigue_spent += fatigue_used
			user.stamina_add(fatigue_used)
			user.devotion?.update_devotion(-1.0)

			if(prob(80))
				playsound(user, 'sound/items/fillcup.ogg', 55, TRUE)
		
		return max(50, fatigue_spent)
	else
		to_chat(user, span_info("I'll need to find a container that can hold Her blessing."))
