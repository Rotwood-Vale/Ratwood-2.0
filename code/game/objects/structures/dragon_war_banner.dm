
/obj/structure/matthios/bandit_banner
	name = "Dragon War Banner"
	desc = ""
	anchored = TRUE
	density = TRUE
	icon = 'icons/roguetown/weapons/roguegiant_72.dmi'
	icon_state = "d_bannerw"
	var/list/buffed = list()
	var/retreatsound = 'sound/horns/o_retreat.ogg'
	var/rallysound = 'sound/horns/o_rally.ogg'
	var/holdsound = 'sound/horns/o_hold.ogg'
	var/chargesound = 'sound/horns/o_charge.ogg'
	var/farretreatsound = 'sound/horns/o_retreat_distant.ogg'
	var/farrallysound = 'sound/horns/o_rally_distant.ogg'
	var/farholdsound = 'sound/horns/o_hold_distant.ogg'
	var/farchargesound = 'sound/horns/o_charge_distant.ogg'
	var/hornchannel

/obj/structure/matthios/bandit_banner/Initialize()
	. = ..()

	START_PROCESSING(SSobj, src)
	return INITIALIZE_HINT_NORMAL

/obj/structure/matthios/bandit_banner/Destroy()
	for(var/mob/living/carbon/human/user in buffed)
		if(user)
			user.remove_status_effect(/datum/status_effect/dragons_grace)

	buffed.Cut()

	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/matthios/bandit_banner/process(mob/living/carbon/human/user)
	.. ()
	var/list/current = list()

	for(user in viewers(7, src))

	if(user.mind?.special_role != "Bandit")
		return FALSE

	current.Add(user)

	if(!(user in buffed))
		user.apply_status_effect(/datum/status_effect/dragons_grace)
		buffed.Add(user)

	for(user in buffed.Copy())

	if(!(user in current))
		user.remove_status_effect(/datum/status_effect/dragons_grace)
		buffed.Remove(user)

/obj/structure/matthios/bandit_banner/attack_hand(mob/living/user)

	if(!ishuman(user))
		return

	if(user.mind?.special_role == "Bandit")
		user.visible_message(span_warning("[user] begins pulling the dragon banner from the ground!"))
		do_after(user, 3 SECONDS, target = src)
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
		do_after(user, 15 SECONDS, target = src)
		user.visible_message(span_warning("[user] kicks the banner over!"))
		playsound(src, 'sound/misc/treefall.ogg', 70)
		new /obj/item/rogueweapon/special/dragonz(loc)
		qdel(src)


		//banner rally/hold commands

/obj/structure/matthios/bandit_banner/proc/sound_banner_announcement(mob/living/user, inputty, proc_type, spell_path, disttext)
	var/soundtouse

	user.stop_sound_channel(hornchannel)
	hornchannel = SSsounds.random_available_channel()
	user.visible_message(span_warning("[user] waves the flag!"))

	if(spell_path == /obj/effect/proc_holder/spell/invoked/banner/retreat) //retreat
		playsound(src, retreatsound, 100, TRUE, channel = hornchannel)
	if(proc_type == /obj/item/rogueweapon/special/dragonz/proc/wave_banner) //rally here
		playsound(src, rallysound, 100, TRUE, channel = hornchannel)
	if(proc_type == /obj/item/rogueweapon/special/dragonz/proc/deploy_banner) //hold
		playsound(src, holdsound, 100, TRUE, channel = hornchannel)
	if(spell_path == /obj/effect/proc_holder/spell/invoked/banner/charge) //charge
		playsound(src, chargesound, 100, TRUE, channel = hornchannel)
		return

	var/turf/origin_turf = get_turf(src)
	var/area/user_area = get_area(user)
	var/area/currentarea = get_area(user)
	var/CAMP = istype(user_area, /area/rogue/indoors/banditcamp)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)

		if(distance <= 7)

			if(player.faction[1] in user.faction)
				to_chat(player, span_warning("[user] sends out a horn signal at [currentarea.name]!"))
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


			switch(distance)
				if(0 to 20)
					disttext = " very close"
				if(20 to 40)
					disttext = " close"
				if(80 to 160)
					disttext = " far"
				else
					disttext = " very far"

			player.stop_sound_channel(hornchannel)

			player.playsound_local(get_turf(player), soundtouse, 35, FALSE, pressure_affected = FALSE, channel = hornchannel)
			message_admins("[player] sent out a horn signal: [inputty] from [ADMIN_VERBOSEJMP(user.loc)]")
			log_game("[player] sent out a horn signal: [inputty] from [loc_name(user.loc)]")


		//banner spell area

/obj/effect/proc_holder/spell/invoked/banner
	var/obj/item/rogueweapon/special/dragonz/attached_banner
	var/status_effect_path
	name = ""
	range = 10
	associated_skill = /datum/skill/misc/athletics
	devotion_cost = 0
	chargedrain = 0
	chargetime = 0
	releasedrain = 80
	miracle = FALSE
	COOLDOWN_DECLARE(banner_spell)

/obj/effect/proc_holder/spell/invoked/banner/cast(list/targets, mob/living/user)
	. = ..()

	for(var/mob/living/target in range(10, user))

		if(!COOLDOWN_FINISHED (src, banner_spell))
			to_chat(user, span_danger("The [src] is not ready yet! [round(COOLDOWN_TIMELEFT(src, banner_spell) / 10, 1)] seconds left!"))
			continue
		if(target.stat == DEAD)
			continue
		if(!(target.faction[1] in user.faction))
			continue

		target.apply_status_effect(status_effect_path)


		if(status_effect_path == /datum/status_effect/buff/order/retreat)
			banner.sound_banner_announcement(user, null, /obj/effect/proc_holder/spell/invoked/banner/retreat)

		else
			banner.sound_banner_announcement(user, null, /obj/effect/proc_holder/spell/invoked/banner/charge)

	return TRUE

		//retreat

/obj/effect/proc_holder/spell/invoked/banner/retreat
	status_effect_path = /datum/status_effect/buff/order/retreat
	name = "Tactical Retreat!"
	desc = "Gives 3 SPD 3 WILL to your compatriots!"
	overlay_state = "movemovemove"
	recharge_time = 5 MINUTES

/datum/status_effect/buff/banner/retreat
	id = "movemovemove"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/retreat
	effectedstats = list(STATKEY_SPD = 3, STATKEY_WIL = 3)
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/buff/banner/retreat
	name = "Tactical Retreat!!"
	desc = "The dragon has ordered me to fall back!"
	icon_state = "buff"

/datum/status_effect/buff/order/retreat/on_apply()
	. = ..()
	to_chat(owner, span_blue("The dragon orders me to fall back!"))


		//charge

/obj/effect/proc_holder/spell/invoked/banner/charge
	status_effect_path = /datum/status_effect/buff/order/charge
	name = "Charge!"
	desc = "Gives 2 STR and 2 PER to your compatriots!"
	overlay_state = "hold"
	recharge_time = 5 MINUTES

/datum/status_effect/buff/banner/charge
	id = "hold"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/charge
	effectedstats = list(STATKEY_STR = 2, STATKEY_PER = 2)
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/charge
	name = "Charge!"
	desc = "The dragon wills it - now is the time to charge!"
	icon_state = "buff"

/datum/status_effect/buff/banner/charge/on_apply()
	. = ..()
	to_chat(owner, span_blue("My commander orders me to charge! For the dragon!"))


		//convert


/obj/effect/proc_holder/spell/self/convertrole/bandit
	var/obj/item/rogueweapon/special/dragonz/attached_banner
	name = "Recruit bandit"
	new_role = "Bandit"
	overlay_state = "recruit_bog"
	recruitment_faction = "Bandit"
	recruitment_message = "We're in this together now, %RECRUIT!"
	accept_message = "For the dragon!"
	refuse_message = "I refuse."

