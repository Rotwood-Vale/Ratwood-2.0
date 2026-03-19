/datum/mind
	/// Tracks whether this mind has already used the Karmic eye to receive a karmic token. Druids can drop TRAIT so it prevents them to abuse it.
	var/freehold_token_touched = FALSE

/obj/structure/roguemachine/freeholdpress/proc/target_apply_normal_reward(mob/living/carbon/human/target_human, reward_type)
	if(!target_human || !reward_type)
		return
	if(reward_type == /datum/status_effect/buff/freehold_normal_faith_spdper)
		target_human.apply_status_effect(/datum/status_effect/buff/freehold_normal_faith_spdper)
		return
	if(reward_type == /datum/status_effect/buff/freehold_normal_faith_strcon)
		target_human.apply_status_effect(/datum/status_effect/buff/freehold_normal_faith_strcon)
		return
	if(reward_type == /datum/status_effect/buff/freehold_normal_faith_intwil)
		target_human.apply_status_effect(/datum/status_effect/buff/freehold_normal_faith_intwil)
		return

/obj/structure/roguemachine/freeholdpress
	name = "Karmic eye"
	desc = "A machine that turns your karma into a reward."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "atm"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32

/obj/structure/roguemachine/freeholdpress/examine(mob/user)
	. = ..()
	. += span_notice("A non-Freeholder may press a karmic token from it only once in their life.")
	. += span_notice("A karmic token lasts only 3 minutes.")
	. += span_notice("A karmic token may be offered only to a Freeholder.")
	. += span_notice("A token of plain faith grants a lesser blessing (the receiver can pick a temporary buff).")
	. += span_notice("A token of great faith grants a greater blessing (the receiver can pick a permanent buff).")
	. += span_notice("A token of bad faith lays a curse instead (receiver is getting marked and punished).")
	. += span_notice("A blessing lasts only 3 minutes and must be claimed here before it fades.")
	. += span_notice("A Freeholder bearing a blessing is supposed to touch the machine to claim a reward.")

	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user

		if(HAS_TRAIT(human_user, TRAIT_FREEHOLDER))
			. += span_info("As a Freeholder, a lesser blessing lets me choose a temporary reward.")
			. += span_info("As a Freeholder, a greater blessing lets me choose a permanent reward.")
		else
			if(human_user.mind?.freehold_token_touched)
				. += span_warning("It has nothing more to grant me.")
			else
				. += span_info("It may still grant me a karmic token.")

/obj/structure/roguemachine/freeholdpress/attack_hand(mob/user)
	. = ..()
	if(!ishuman(user))
		return .
	if(!Adjacent(user))
		return .

	var/mob/living/carbon/human/human_user = user

	if(HAS_TRAIT(human_user, TRAIT_FREEHOLDER))
		if(human_user.has_status_effect(/datum/status_effect/buff/freehold_great_faith))
			var/list/great_choices = list(
				"Strength",
				"Constitution",
				"Speed",
				"Perception",
				"Intelligence",
				"Willpower"
			)

			var/great_choice = input(human_user, "Choose your permanent reward to claim.", src.name) as null|anything in great_choices
			if(!great_choice)
				return .
			if(QDELETED(src) || QDELETED(human_user))
				return .
			if(!Adjacent(human_user))
				return .
			if(!human_user.has_status_effect(/datum/status_effect/buff/freehold_great_faith))
				to_chat(human_user, span_warning("The greater blessing has already faded."))
				playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
				return .

			switch(great_choice)
				if("Strength")
					human_user.STASTR += 1
				if("Constitution")
					human_user.STACON += 1
				if("Speed")
					human_user.STASPD += 1
				if("Perception")
					human_user.STAPER += 1
				if("Intelligence")
					human_user.STAINT += 1
				if("Willpower")
					human_user.STAWIL += 1

			human_user.remove_status_effect(/datum/status_effect/buff/freehold_great_faith)
			to_chat(human_user, span_notice("I'm accepting a great reward from the machine."))
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return .

		if(human_user.has_status_effect(/datum/status_effect/buff/freehold_normal_faith))
			var/list/normal_choices = list(
				"Speed and Perception",
				"Strength and Constitution",
				"Intelligence and Willpower"
			)

			var/normal_choice = input(human_user, "Choose your temporary reward to claim.", src.name) as null|anything in normal_choices
			if(!normal_choice)
				return .
			if(QDELETED(src) || QDELETED(human_user))
				return .
			if(!Adjacent(human_user))
				return .
			if(!human_user.has_status_effect(/datum/status_effect/buff/freehold_normal_faith))
				to_chat(human_user, span_warning("The blessing has already faded."))
				playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
				return .

			switch(normal_choice)
				if("Speed and Perception")
					target_apply_normal_reward(human_user, /datum/status_effect/buff/freehold_normal_faith_spdper)
				if("Strength and Constitution")
					target_apply_normal_reward(human_user, /datum/status_effect/buff/freehold_normal_faith_strcon)
				if("Intelligence and Willpower")
					target_apply_normal_reward(human_user, /datum/status_effect/buff/freehold_normal_faith_intwil)

			human_user.remove_status_effect(/datum/status_effect/buff/freehold_normal_faith)
			to_chat(human_user, span_notice("I'm accepting a lesser reward from the machine."))
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return .

		to_chat(human_user, span_warning("Im supposed to be marked by another person to claim anything from here."))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return .

	if(human_user.mind?.freehold_token_touched)
		to_chat(human_user, span_warning("This machine will grant me no further token. Only once per my life."))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return .

	if(locate(/obj/item/freehold_token) in human_user.contents)
		to_chat(human_user, span_warning("I already carry such a token."))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return .

	if(human_user.mind)
		human_user.mind.freehold_token_touched = TRUE

	to_chat(human_user, span_notice("The machine presses a fleeting token into my hand."))
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	new /obj/item/freehold_token(get_turf(human_user), human_user)
	return .
	
/obj/item/freehold_token
	name = "A karmic token"
	desc = "A fleeting token, warm from the press. It will not last long."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "karmacoin"
	w_class = WEIGHT_CLASS_SMALL
	var/owner_ckey
	var/owner_name
	var/in_use = FALSE

/obj/item/freehold_token/Initialize(mapload, mob/living/carbon/human/new_owner)
	. = ..()
	if(new_owner)
		owner_ckey = new_owner.ckey
		owner_name = new_owner.real_name
		new_owner.put_in_hands(src, TRUE)
	addtimer(CALLBACK(src, PROC_REF(expire_token)), 3 MINUTES)

/obj/item/freehold_token/proc/expire_token()
	if(QDELETED(src))
		return
	if(ismob(loc))
		var/mob/holder_mob = loc
		to_chat(holder_mob, span_warning("[src] crumbles into nothing. Its not supposed to last long."))
	qdel(src)

/obj/item/freehold_token/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return
	if(in_use)
		return
	if(!ishuman(user))
		return
	if(user.ckey != owner_ckey)
		to_chat(user, span_warning("This token does not answer to my hand."))
		return
	if(!ishuman(target))
		to_chat(user, span_warning("This token may only be offered to a Freeholder."))
		return

	var/mob/living/carbon/human/offering_user = user
	var/mob/living/carbon/human/target_human = target

	if(offering_user == target_human)
		to_chat(offering_user, span_warning("I cannot offer this token to myself."))
		return

	if(!HAS_TRAIT(target_human, TRAIT_FREEHOLDER))
		to_chat(offering_user, span_warning("[target_human] is not a Freeholder."))
		return

	if(get_dist(offering_user, target_human) > 1)
		return

	in_use = TRUE
	offering_user.visible_message(span_notice("[offering_user] begins offering [src] to [target_human]..."))

	if(!do_after(offering_user, 10 SECONDS, target = target_human))
		in_use = FALSE
		offering_user.visible_message(span_warning("[offering_user] fails to complete the offering."))
		return
	if(QDELETED(src) || QDELETED(offering_user) || QDELETED(target_human))
		qdel(src)
		return
	if(get_dist(offering_user, target_human) > 1)
		to_chat(offering_user, span_warning("[target_human] is too far away now."))
		in_use = FALSE
		return

	open_offer_window(offering_user, target_human)

/obj/item/freehold_token/proc/open_offer_window(mob/living/carbon/human/offering_user, mob/living/carbon/human/target_human)
	if(QDELETED(src) || QDELETED(offering_user) || QDELETED(target_human))
		qdel(src)
		return
	if(get_dist(offering_user, target_human) > 1)
		in_use = FALSE
		return

	var/list/choices = list("Bad", "Normal", "Great", "Nevermind")
	var/secret_choice = input(offering_user, "Choose the token's intent.", src.name) as null|anything in choices
	if(secret_choice == "Nevermind" || !secret_choice)
		in_use = FALSE
		return

	to_chat(target_human, span_notice("[offering_user] offers you their desigion."))
	to_chat(offering_user, span_notice("[target_human] now considers your offering."))

	var/accept_choice = alert(target_human, "Accept this offering?", src.name, "Accept", "Refuse")

	if(QDELETED(src) || QDELETED(offering_user) || QDELETED(target_human))
		qdel(src)
		return

	if(accept_choice != "Accept")
		to_chat(offering_user, span_warning("[target_human] refuses the token."))
		to_chat(target_human, span_notice("You refuse the token."))
		in_use = FALSE
		return

	target_human.visible_message(span_notice("[target_human] begins accepting their fate..."))
	if(!do_after(target_human, 10 SECONDS, target = target_human))
		to_chat(offering_user, span_warning("[target_human] does not complete the process."))
		to_chat(target_human, span_warning("You fail to complete the process."))
		in_use = FALSE
		return

	if(QDELETED(src) || QDELETED(offering_user) || QDELETED(target_human))
		qdel(src)
		return
	if(get_dist(offering_user, target_human) > 1)
		to_chat(offering_user, span_warning("The process is broken by distance."))
		to_chat(target_human, span_warning("The process is broken."))
		in_use = FALSE
		return
	if(!HAS_TRAIT(target_human, TRAIT_FREEHOLDER))
		to_chat(offering_user, span_warning("[target_human] is no longer a Freeholder."))
		in_use = FALSE
		return

	switch(secret_choice)
		if("Bad")
			apply_bad_faith(offering_user, target_human)
		if("Normal")
			apply_normal_faith(offering_user, target_human)
		if("Great")
			apply_great_faith(offering_user, target_human)

/obj/item/freehold_token/proc/apply_bad_faith(mob/living/carbon/human/user, mob/living/carbon/human/target)
	target.remove_status_effect(/datum/status_effect/buff/freehold_normal_faith)
	target.remove_status_effect(/datum/status_effect/buff/freehold_great_faith)
	target.remove_status_effect(/datum/status_effect/buff/freehold_normal_faith_spdper)
	target.remove_status_effect(/datum/status_effect/buff/freehold_normal_faith_strcon)
	target.remove_status_effect(/datum/status_effect/buff/freehold_normal_faith_intwil)
	target.apply_status_effect(/datum/status_effect/debuff/freehold_bad_faith)
	user.visible_message(span_warning("[user] lays a token of bad faith upon [target]."))
	to_chat(target, span_warning("You have been marked by bad faith."))
	playsound(target, 'sound/misc/machineno.ogg', 100, FALSE, -1)
	qdel(src)

/obj/item/freehold_token/proc/apply_normal_faith(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.has_status_effect(/datum/status_effect/debuff/freehold_bad_faith))
		to_chat(user, span_warning("Coal aura still stucks to [target]."))
		in_use = FALSE
		return
	if(target.has_status_effect(/datum/status_effect/buff/freehold_normal_faith) || target.has_status_effect(/datum/status_effect/buff/freehold_great_faith))
		to_chat(user, span_warning("[target] already bears a blessing."))
		in_use = FALSE
		return
	target.apply_status_effect(/datum/status_effect/buff/freehold_normal_faith)
	user.visible_message(span_notice("[user] lays a token of plain faith upon [target]."))
	to_chat(target, span_notice("A lesser blessing settles upon you. I should claim it at the machine."))
	playsound(target, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	qdel(src)

/obj/item/freehold_token/proc/apply_great_faith(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.has_status_effect(/datum/status_effect/debuff/freehold_bad_faith))
		target.remove_status_effect(/datum/status_effect/debuff/freehold_bad_faith)
		user.visible_message(span_notice("[user] lifts a stain of bad faith from [target]."))
		to_chat(target, span_notice("The shadow over your coal aura is lifted."))
		playsound(target, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
		qdel(src)
		return
	if(target.has_status_effect(/datum/status_effect/buff/freehold_normal_faith) || target.has_status_effect(/datum/status_effect/buff/freehold_great_faith))
		to_chat(user, span_warning("[target] already bears a blessing."))
		in_use = FALSE
		return
	target.apply_status_effect(/datum/status_effect/buff/freehold_great_faith)
	user.visible_message(span_notice("[user] lays a token of great faith upon [target]."))
	to_chat(target, span_notice("My efforts have been greatly praised. I must claim it quickly at the machine."))
	playsound(target, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
	qdel(src)

/atom/movable/screen/alert/status_effect/debuff/freehold_bad_faith
	name = "Bad Faith"
	desc = "You are COAL."
	icon_state = "debuff"

/datum/status_effect/debuff/freehold_bad_faith
	id = "freehold_bad_faith"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/freehold_bad_faith
	duration = 30 MINUTES
	effectedstats = list(STATKEY_STR = -3, STATKEY_CON = -3, STATKEY_WIL = -3, STATKEY_SPD = -3, STATKEY_PER = -3, STATKEY_INT = -3)

/atom/movable/screen/alert/status_effect/buff/freehold_normal_faith_spdper
	name = "Normal Faith"
	desc = "A small reward for my efforts."
	icon_state = "buff"

/datum/status_effect/buff/freehold_normal_faith_spdper
	id = "freehold_normal_faith_spdper"
	alert_type = /atom/movable/screen/alert/status_effect/buff/freehold_normal_faith_spdper
	duration = 30 MINUTES
	effectedstats = list(STATKEY_SPD = 1, STATKEY_PER = 1)

/atom/movable/screen/alert/status_effect/buff/freehold_normal_faith_strcon
	name = "Normal Faith"
	desc = "A small reward for my efforts."
	icon_state = "buff"

/datum/status_effect/buff/freehold_normal_faith_strcon
	id = "freehold_normal_faith_strcon"
	alert_type = /atom/movable/screen/alert/status_effect/buff/freehold_normal_faith_strcon
	duration = 30 MINUTES
	effectedstats = list(STATKEY_STR = 1, STATKEY_CON = 1)

/atom/movable/screen/alert/status_effect/buff/freehold_normal_faith_intwil
	name = "Normal Faith"
	desc = "A small reward for my efforts."
	icon_state = "buff"

/datum/status_effect/buff/freehold_normal_faith_intwil
	id = "freehold_normal_faith_intwil"
	alert_type = /atom/movable/screen/alert/status_effect/buff/freehold_normal_faith_intwil
	duration = 30 MINUTES
	effectedstats = list(STATKEY_INT = 1, STATKEY_WIL = 1)

/atom/movable/screen/alert/status_effect/buff/freehold_great_faith
	name = "Great Faith"
	desc = "My efforts have been noticed."
	icon_state = "buff"

/datum/status_effect/buff/freehold_great_faith
	id = "freehold_great_faith"
	alert_type = /atom/movable/screen/alert/status_effect/buff/freehold_great_faith
	duration = 3 MINUTES
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/buff/freehold_great_faith/on_apply()
	. = ..()
	if(ishuman(owner))
		to_chat(owner, span_notice("I have but a short while to claim a great reward from the machine."))

/atom/movable/screen/alert/status_effect/buff/freehold_normal_faith
	name = "Normal Faith"
	desc = "My efforts have been noticed."
	icon_state = "buff"

/datum/status_effect/buff/freehold_normal_faith
	id = "freehold_normal_faith"
	alert_type = /atom/movable/screen/alert/status_effect/buff/freehold_normal_faith
	duration = 3 MINUTES
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/buff/freehold_normal_faith/on_apply()
	. = ..()
	if(ishuman(owner))
		to_chat(owner, span_notice("I have but a short while to claim a lesser reward from the machine."))
