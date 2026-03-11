
/obj/structure/matthios/bandit_banner
	name = "Dragon War Banner"
	desc = ""
	anchored = TRUE
	density = TRUE
	icon = 'icons/roguetown/weapons/roguegiant_72.dmi'
	icon_state = "d_bannerw"
	var/list/buffed = list()

/obj/structure/matthios/bandit_banner/Initialize()
	. = ..()

	START_PROCESSING(SSobj, src)
	return

	INITIALIZE_HINT_NORMAL

/obj/structure/matthios/bandit_banner/Destroy()

	for(var/mob/living/carbon/human/H in buffed)
	H.remove_status_effect(/datum/status_effect/buff/bandit_banner)

	buffed.Cut()

	STOP_PROCESSING(SSobj, src)
	return

	..()

/obj/structure/matthios/bandit_banner/process()
	var/list/current = list()

	for(var/mob/living/carbon/human/H in viewers(7, src))

	if(H.mind?.special_role != "Bandit")
	continue

	current.Add(H)

	if(!(H in buffed))
		H.apply_status_effect(/datum/status_effect/buff/bandit_banner)
		buffed.Add(H) // remove buff from those who left range

	for(var/mob/living/carbon/human/H in buffed.Copy())

	if(!(H in current))
		H.remove_status_effect(/datum/status_effect/buff/bandit_banner)
		buffed.Remove(H)

/datum/status_effect/buff/bandit_banner

	id = "bandit_banner"
	mob_effect_icon_state = "buff"
	examine_text = "SUBJECTPRONOUN fights with the fury of the dragon."
	alert_type = /atom/movable/screen/alert/status_effect

/datum/status_effect/buff/bandit_banner/on_apply()

	to_chat(owner, span_notice("You feel the strength of the dragon flow into your body."))

	owner.change_stat(STATKEY_STR, 1)
	owner.change_stat(STATKEY_PER, 1)
	owner.change_stat(STATKEY_WIL, 1)
	owner.change_stat(STATKEY_CON, 1)
	owner.change_stat(STATKEY_INT, 1)
	owner.change_stat(STATKEY_SPD, 1)
	owner.change_stat(STATKEY_LCK, 1)

/datum/status_effect/buff/bandit_banner/on_remove()

	to_chat(owner, span_notice("The dragon's strength fades."))

	owner.change_stat(STATKEY_STR, -1)
	owner.change_stat(STATKEY_PER, -1)
	owner.change_stat(STATKEY_WIL, -1)
	owner.change_stat(STATKEY_CON, -1)
	owner.change_stat(STATKEY_INT, -1)
	owner.change_stat(STATKEY_SPD, -1)
	owner.change_stat(STATKEY_LCK, -1)

/datum/status_effect/buff/bandit_banner/tick()

	if(owner) owner.energy_add(1)

/obj/structure/matthios/bandit_banner/attack_hand(mob/living/user)

	if(!ishuman(user))
		return

		if(user.mind.special_role == "Bandit")
		user.visible_message(span_warning("[user] begins pulling the dragon banner from the ground!"))

		if(!do_after(user, 3 SECONDS, target = src))
			return

		user.visible_message(span_warning("[user] pulls the dragon banner free!"))
		playsound(src, 'sound/items/empty_shovel.ogg', 70)

		var/obj/item/rogueweapon/special/dragonz/banner = new(user.loc)

		user.put_in_active_hand(banner)
		banner.pickup(user)
		banner.update_icon()
		user.update_inv_hands()

		qdel(src)

	else

		user.visible_message(span_warning("[user] attempts to kick the banner over!"))
		playsound(src, 'sound/misc/woodhit.ogg', 70)

		if(!do_after(user, 15 SECONDS, target = src))
		return

		user.visible_message(span_warning("[user] kicks the banner over!"))
		playsound(src, 'sound/misc/treefall.ogg', 70)

		new /obj/item/rogueweapon/special/dragonz(loc)

		qdel(src)