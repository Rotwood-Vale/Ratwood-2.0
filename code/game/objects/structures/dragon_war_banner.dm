/obj/structure/flag/matthios
	name = "Dragon War Banner"
	desc = ""
	anchored = TRUE
	density = TRUE
	icon = 'icons/obj/structures.dmi'
	icon_state = "woodenbarricade"

/obj/structure/flag/matthios/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/flag/matthios/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/flag/matthios/process()
	//has to be in line of sight
	for(var/mob/living/carbon/human/H in view(7, src))

		if(H.job == "bandit")

			if(!H.has_status_effect(/datum/status_effect/buff/bandit_banner))
				H.apply_status_effect(/datum/status_effect/buff/bandit_banner)

		else
			if(H.has_status_effect(/datum/status_effect/buff/bandit_banner))
				H.remove_status_effect(/datum/status_effect/buff/bandit_banner)

/datum/status_effect/buff/bandit_banner
	id = "bandit_banner"
	duration = -1
	tick_interval = 2
	examine_text = "SUBJECTPRONOUN fights with the fury of the dragon."

/datum/status_effect/buff/bandit_banner/on_apply()

	owner.change_stat(STAT_STR, 1)
	owner.change_stat(STAT_PER, 1)
	owner.change_stat(STAT_END, 1)
	owner.change_stat(STAT_CON, 1)
	owner.change_stat(STAT_INT, 1)
	owner.change_stat(STAT_SPD, 1)
	owner.change_stat(STAT_LCK, 1)

/datum/status_effect/buff/bandit_banner/on_remove()

	owner.change_stat(STAT_STR, -1)
	owner.change_stat(STAT_PER, -1)
	owner.change_stat(STAT_END, -1)
	owner.change_stat(STAT_CON, -1)
	owner.change_stat(STAT_INT, -1)
	owner.change_stat(STAT_SPD, -1)
	owner.change_stat(STAT_LCK, -1)

/datum/status_effect/buff/bandit_banner/tick()

	if(owner)
		owner.adjust_mana(1)

/obj/structure/flag/matthios/attack_hand(mob/living/user)

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(H.job == "bandit")

		user.visible_message(span_notice("[user] begins pulling the dragon banner from the ground!"))

		if(!do_after(user, 5 SECONDS, target = src))
			return

		user.visible_message(span_notice("[user] pulls the dragon banner free!"))

		var/obj/item/rogueweapon/dragonz/banner = new(user)
		user.put_in_active_hand(banner)


		qdel(src)

	else

		user.visible_message(span_notice("[user] attempts to kick the banner over!"))

		if(!do_after(user, 15 SECONDS, target = src))
			return

		user.visible_message(span_notice("[user] kicks the banner over!"))

		new /obj/item/rogueweapon/dragonz(loc)

		qdel(src)
