
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


/obj/item/war_horn/proc/sound_horn(mob/living/user, datum/intent)
	user.stop_sound_channel(hornchannel)
	hornchannel = SSsounds.random_available_channel()
	user.visible_message(span_warning("[user] sounds the horn!"))
	if(intent.type == /datum/intent/war_horn/retreat) //retreat
		playsound(src, retreatsound, 100, TRUE, channel = hornchannel)
	if(intent.type == /datum/intent/war_horn/rally) //rally here
		playsound(src, rallysound, 100, TRUE, channel = hornchannel)
	if(intent.type == /datum/intent/war_horn/hold) //hold
		playsound(src, holdsound, 100, TRUE, channel = hornchannel)
	if(intent.type == /datum/intent/war_horn/charge) //charge
		playsound(src, chargesound, 100, TRUE, channel = hornchannel)

	var/turf/origin_turf = get_turf(src)
	var/area/currentarea = get_area(user.loc)
	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			if(player.faction[1] in user.faction)
				to_chat(player, span_warning("[user] signals to [user.a_intent] at [currentarea.location_name]!"))
			continue
		var/dirtext = " to the "
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "north"
			if(SOUTH)
				dirtext += "south"
			if(EAST)
				dirtext += "east"
			if(WEST)
				dirtext += "west"
			if(NORTHWEST)
				dirtext += "northwest"
			if(NORTHEAST)
				dirtext += "northeast"
			if(SOUTHWEST)
				dirtext += "southwest"
			if(SOUTHEAST)
				dirtext += "southeast"
			else //Where ARE you.
				dirtext = ", although I cannot make out a direction"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " very close"
			if(20 to 40)
				disttext = " close"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " far"
			else
				disttext = " very far"
		//sound played for other players
		player.stop_sound_channel(hornchannel)
		var/soundtouse
		if(intent.type == /datum/intent/war_horn/retreat)
			if(distance < 80)
				soundtouse = retreatsound
			else
				soundtouse = farretreatsound
		if(intent.type == /datum/intent/war_horn/rally)
			if(distance < 80)
				soundtouse = rallysound
			else
				soundtouse = farrallysound
		if(intent.type == /datum/intent/war_horn/hold)
			if(distance < 80)
				soundtouse = holdsound
			else
				soundtouse = farholdsound
		if(intent.type == /datum/intent/war_horn/charge)
			if(distance < 80)
				soundtouse = chargesound
			else
				soundtouse = farchargesound
		if(player.faction[1] in user.faction) //first is probably their primary.
			to_chat(player, span_warning("I hear the signal to [user.a_intent.name] somewhere[disttext][dirtext] in the [currentarea.name]!"))
		else
			to_chat(player, span_warning("I hear a foreign signal somewhere[disttext][dirtext]!"))
		player.playsound_local(get_turf(player), soundtouse, 35, FALSE, pressure_affected = FALSE, channel = hornchannel)


		//banner rally/hold commands


/obj/item/war_horn/proc/sound_banner_announcement(mob/living/user, datum/intent, inputty)

	user.stop_sound_channel(hornchannel)
	hornchannel = SSsounds.random_available_channel()
	user.visible_message(span_warning("[user] waves the flag!"))

	if(intent.type == /datum/intent/war_horn/retreat) //retreat
		playsound(src, retreatsound, 100, TRUE, channel = hornchannel)
	if(intent.type == /datum/intent/war_horn/rally) //rally here
		playsound(src, rallysound, 100, TRUE, channel = hornchannel)
	if(intent.type == /datum/intent/war_horn/hold) //hold
		playsound(src, holdsound, 100, TRUE, channel = hornchannel)
	if(intent.type == /datum/intent/war_horn/charge) //charge
		playsound(src, chargesound, 100, TRUE, channel = hornchannel)

	var/turf/origin_turf = get_turf(src)
	var/area/currentarea = get_area(user.loc)
	var/CAMP = istype(target_area, /area/rogue/indoors/banditcamp)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			if(player.faction[1] in user.faction)
				to_chat(player, span_warning("[user] sends out a horn signal at [currentarea.location_name]!"))
				to_chat(player, span_colossus("[inputty]"))
			continue
		var/dirtext = " The dragon calls you to the "
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "north"
			if(SOUTH)
				dirtext += "south"
			if(EAST)
				dirtext += "east"
			if(WEST)
				dirtext += "west"
			if(NORTHWEST)
				dirtext += "northwest"
			if(NORTHEAST)
				dirtext += "northeast"
			if(SOUTHWEST)
				dirtext += "southwest"
			if(SOUTHEAST)
				dirtext += "southeast"
			if(CAMP)
				dirtext += "camp"
			else //Where ARE you.
				dirtext = ", although I cannot make out a direction"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " very close"
			if(20 to 40)
				disttext = " close"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " far"
			else
				disttext = " very far"
		//sound played for other players
		player.stop_sound_channel(hornchannel)
		var/soundtouse
		if(intent.type == /datum/intent/war_horn/retreat)
			if(distance < 80)
				soundtouse = o_rallysound
			else
				soundtouse = far_o_rallysound
		if(intent.type == /datum/intent/war_horn/rally)
			if(distance < 80)
				soundtouse = rallysound
			else
				soundtouse = farrallysound
		if(intent.type == /datum/intent/war_horn/hold)
			if(distance < 80)
				soundtouse = holdsound
			else
				soundtouse = farholdsound
		if(intent.type == /datum/intent/war_horn/charge)
			if(distance < 80)
				soundtouse = chargesound
			else
				soundtouse = farchargesound
		if(player.faction[1] in user.faction) //first is probably their primary.
			to_chat(player, span_colossus("[inputty]"))

	player.playsound_local(get_turf(player), soundtouse, 35, FALSE, pressure_affected = FALSE, channel = hornchannel)
	message_admins("[user] sent out a horn signal: [inputty] from [ADMIN_VERBOSEJMP(user.loc)]")
	log_game("[user] sent out a horn signal: [inputty] from [loc_name(user.loc)]")


		//banner spell area

/obj/effect/proc_holder/spell/invoked/banner
	name = ""
	range = 7
	associated_skill = /datum/skill/misc/athletics
	devotion_cost = 0
	chargedrain = 0
	chargetime = 0
	releasedrain = 80
	recharge_time = 4 MINUTES
	miracle = FALSE
	sound = 'sound/magic/inspire_02.ogg'


/obj/effect/proc_holder/spell/invoked/order/retreat
	name = "Tactical Retreat!"
	chargedrain = 0
	chargetime = 0
	desc = "Gives 3 SPD 3 WILL to your compatriots!"
	overlay_state = "movemovemove"

/obj/effect/proc_holder/spell/invoked/banner/retreat/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		target.apply_status_effect(/datum/status_effect/buff/order/retreat)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/banner/retreat/nextmove_modifier()
	return

/datum/status_effect/buff/banner/retreat
	id = "movemovemove"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/retreat
	effectedstats = list(STATKEY_SPD = 3, STATKEY_WIL = 3)
	duration = 4 MINUTES

/atom/movable/screen/alert/status_effect/buff/banner/retreat
	name = "Tactical Retreat!!"
	desc = "The dragon has ordered me to fall back!"
	icon_state = "buff"

/datum/status_effect/buff/order/retreat/on_apply()
	. = ..()
	to_chat(owner, span_blue("The dragon orders me to fall back!"))

/obj/effect/proc_holder/spell/invoked/banner/charge
	name = "Charge!"
	desc = "Gives 2 STR and 2 PER to your compatriots!"
	overlay_state = "hold"
	chargedrain = 0
	chargetime = 0

/obj/effect/proc_holder/spell/invoked/banner/charge/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.holdtext
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/charge)
		return TRUE
	revert_cast()
	return FALSE


/datum/status_effect/buff/banner/charge
	id = "hold"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/charge
	effectedstats = list(STATKEY_STR = 2, STATKEY_PER = 2)
	duration = 4 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/charge
	name = "Charge!"
	desc = "The dragon wills it - now is the time to charge!"
	icon_state = "buff"

/datum/status_effect/buff/banner/charge/on_apply()
	. = ..()
	to_chat(owner, span_blue("My commander orders me to charge! For the dragon!"))


/obj/effect/proc_holder/spell/self/convertrole/bandit
	name = "Recruit bandit"
	new_role = "Bandit"
	overlay_state = "recruit_bog"
	recruitment_faction = "Bandit"
	recruitment_message = "We're in this together now, %RECRUIT!"
	accept_message = "For the dragon!"
	refuse_message = "I refuse."

