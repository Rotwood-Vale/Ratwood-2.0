/datum/mind
	var/freehold_token_touched = FALSE // I need to test it before mob/living/carbon/human because druids shitters going to abuse shit out of their ass broken spell

/obj/structure/roguemachine/freeholdpress/proc/target_apply_normal_reward(mob/living/carbon/human/H, reward_type) //helper help me
	if(!H || !reward_type)
		return
	if(reward_type == /datum/status_effect/buff/freehold_normal_faith_spdper)
		H.apply_status_effect(/datum/status_effect/buff/freehold_normal_faith_spdper)
		return
	if(reward_type == /datum/status_effect/buff/freehold_normal_faith_strcon)
		H.apply_status_effect(/datum/status_effect/buff/freehold_normal_faith_strcon)
		return
	if(reward_type == /datum/status_effect/buff/freehold_normal_faith_intwil)
		H.apply_status_effect(/datum/status_effect/buff/freehold_normal_faith_intwil)
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
		var/mob/living/carbon/human/H = user

		if(HAS_TRAIT(H, TRAIT_FREEHOLDER))
			. += span_info("As a Freeholder, a lesser blessing lets me choose a temporary reward.")
			. += span_info("As a Freeholder, a greater blessing lets me choose a permanent reward.")
		else
			if(H.mind?.freehold_token_touched)
				. += span_warning("It has nothing more to grant me.")
			else
				. += span_info("It may still grant me a karmic token.")


/obj/structure/roguemachine/freeholdpress/attack_hand(mob/user)
	if(!ishuman(user))
		return
	if(!Adjacent(user))
		return

	var/mob/living/carbon/human/H = user

	if(HAS_TRAIT(H, TRAIT_FREEHOLDER))
		if(H.has_status_effect(/datum/status_effect/buff/freehold_great_faith))
			var/list/great_choices = list(
				"Strength",
				"Constitution",
				"Speed",
				"Perception",
				"Intelligence",
				"Willpower"
			)

			var/great_choice = input(H, "Choose your permanent reward to claim.", src.name) as null|anything in great_choices
			if(!great_choice)
				return
			if(QDELETED(src) || QDELETED(H))
				return
			if(!Adjacent(H))
				return
			if(!H.has_status_effect(/datum/status_effect/buff/freehold_great_faith))
				to_chat(H, span_warning("The greater blessing has already faded."))
				playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
				return

			switch(great_choice)
				if("Strength")
					H.STASTR += 1
				if("Constitution")
					H.STACON += 1
				if("Speed")
					H.STASPD += 1
				if("Perception")
					H.STAPER += 1
				if("Intelligence")
					H.STAINT += 1
				if("Willpower")
					H.STAWIL += 1

			H.remove_status_effect(/datum/status_effect/buff/freehold_great_faith)
			to_chat(H, span_notice("I'm accepting a great reward from the machine."))
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return

		if(H.has_status_effect(/datum/status_effect/buff/freehold_normal_faith))
			var/list/normal_choices = list(
				"Speed and Perception",
				"Strength and Constitution",
				"Intelligence and Willpower"
			)

			var/normal_choice = input(H, "Choose your temporary reward to claim.", src.name) as null|anything in normal_choices
			if(!normal_choice)
				return
			if(QDELETED(src) || QDELETED(H))
				return
			if(!Adjacent(H))
				return
			if(!H.has_status_effect(/datum/status_effect/buff/freehold_normal_faith))
				to_chat(H, span_warning("The blessing has already faded."))
				playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
				return
			switch(normal_choice)
				if("Speed and Perception")
					target_apply_normal_reward(H, /datum/status_effect/buff/freehold_normal_faith_spdper)
				if("Strength and Constitution")
					target_apply_normal_reward(H, /datum/status_effect/buff/freehold_normal_faith_strcon)
				if("Intelligence and Willpower")
					target_apply_normal_reward(H, /datum/status_effect/buff/freehold_normal_faith_intwil)
			H.remove_status_effect(/datum/status_effect/buff/freehold_normal_faith)
			to_chat(H, span_notice("I'm accepting a lesser reward from the machine."))
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return
		to_chat(H, span_warning("Im supposed to be marked by another person to claim anything from here."))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(H.mind?.freehold_token_touched)
		to_chat(H, span_warning("This machine will grant me no further token. Only once per my life."))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	for(var/obj/item/freehold_token/T in H.contents)
		to_chat(H, span_warning("I already carry such a token."))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(H.mind)
		H.mind.freehold_token_touched = TRUE
	to_chat(H, span_notice("The machine presses a fleeting token into my hand."))
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	new /obj/item/freehold_token(get_turf(H), H)

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
		var/mob/M = loc
		to_chat(M, span_warning("[src] crumbles into nothing. Its not supposed to last long."))
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

	var/mob/living/carbon/human/U = user
	var/mob/living/carbon/human/H = target

	if(U == H)
		to_chat(U, span_warning("I cannot offer this token to myself."))
		return

	if(!HAS_TRAIT(H, TRAIT_FREEHOLDER))
		to_chat(user, span_warning("[H] is not a Freeholder."))
		return

	if(get_dist(U, H) > 1)
		return

	in_use = TRUE
	U.visible_message(span_notice("[U] begins offering [src] to [H]..."))

	if(!do_after(U, 10 SECONDS, target = H))
		in_use = FALSE
		U.visible_message(span_warning("[U] fails to complete the offering."))
		return
	if(QDELETED(src) || QDELETED(U) || QDELETED(H))
		qdel(src)
		return
	if(get_dist(U, H) > 1)
		to_chat(U, span_warning("[H] is too far away now."))
		in_use = FALSE
		return
	open_offer_window(U, H)

/obj/item/freehold_token/proc/open_offer_window(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(QDELETED(src) || QDELETED(user) || QDELETED(target))
		qdel(src)
		return
	if(get_dist(user, target) > 1)
		in_use = FALSE
		return

	var/list/choices = list("Bad", "Normal", "Great", "Nevermind")
	var/secret_choice = input(user, "Choose the token's intent.", src.name) as null|anything in choices
	if(secret_choice == "Nevermind" || !secret_choice)
		in_use = FALSE
		return

	to_chat(target, span_notice("[user] offers you their desigion."))
	to_chat(user, span_notice("[target] now considers your offering."))

	var/accept_choice = alert(target, "Accept this offering?", src.name, "Accept", "Refuse")

	if(QDELETED(src) || QDELETED(user) || QDELETED(target))
		qdel(src)
		return

	if(accept_choice != "Accept")
		to_chat(user, span_warning("[target] refuses the token."))
		to_chat(target, span_notice("You refuse the token."))
		in_use = FALSE
		return
	target.visible_message(span_notice("[target] begins accepting their fate..."))
	if(!do_after(target, 10 SECONDS, target = target))
		to_chat(user, span_warning("[target] does not complete the process."))
		to_chat(target, span_warning("You fail to complete the process."))
		in_use = FALSE
		return

	if(QDELETED(src) || QDELETED(user) || QDELETED(target))
		qdel(src)
		return
	if(get_dist(user, target) > 1)
		to_chat(user, span_warning("The process is broken by distance."))
		to_chat(target, span_warning("The process is broken."))
		in_use = FALSE
		return
	if(!HAS_TRAIT(target, TRAIT_FREEHOLDER))
		to_chat(user, span_warning("[target] is no longer a Freeholder."))
		in_use = FALSE
		return

	switch(secret_choice)
		if("Bad")
			apply_bad_faith(user, target)
		if("Normal")
			apply_normal_faith(user, target)
		if("Great")
			apply_great_faith(user, target)

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
