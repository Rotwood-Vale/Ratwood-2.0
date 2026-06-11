#define WARDEN_AMBUSH_MIN 2
#define WARDEN_AMBUSH_MAX 9

/obj/item/signal_horn
	name = "信号号角"
	desc = "守卫们携带的号角。吹响它会引来各种怪物和宵小的注意，好让守卫们将其清剿。"
	icon = 'modular_hearthstone/icons/obj/items/signalhorn.dmi'
	icon_state = "signalhorn"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 32
	grid_width = 64
	dropshrink = 0.9

/obj/item/signal_horn/examine()
	. = ..()
	. += span_notice("使用号角会让你站在原地，并一次性引发数次伏击，从而清理一片区域。它不能连续快速使用。")
	. += span_notice("使用后你会暂时筋疲力尽。最好带上同伴！")
	var/area/AR = get_area(src)
	var/datum/threat_region/TR = SSregionthreat.get_region(AR.threat_region)
	if(TR)
		. += span_notice("这片区域属于" + TR.region_name + "威胁区域的一部分。")
	else
		. += span_notice("这片区域不属于守卫的辖区")

/obj/item/signal_horn/attack_self(mob/living/user)
	. = ..()
	var/area/AR = get_area(user)
	var/datum/threat_region/TR = SSregionthreat.get_region(AR.threat_region)
	if(!TR || !TR.latent_ambush || TR.fixed_ambush)
		to_chat(user, span_warning("在这里吹响号角毫无意义。"))
		return
	if(user.get_will_block_ambush())
		to_chat(user, span_warning("这里太过明亮，敌人不会靠近。"))
		return
	if(!user.get_possible_ambush_spawn(min_dist = WARDEN_AMBUSH_MIN, max_dist = WARDEN_AMBUSH_MAX))
		to_chat(user, span_warning("这里植被太稀疏，敌人无处藏身。"))
		return
	if(TR && TR.last_induced_ambush_time && (world.time < TR.last_induced_ambush_time + 5 MINUTES))
		to_chat(user, span_warning("这里的敌人刚被清理过，也许你该等一会儿再吹号。"))
		return
	user.visible_message(span_userdanger("[user]就要吹响[src]了！"))
	user.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS) // We don't want them to spam the message.
	if(do_after(user, 30 SECONDS)) // Enough time for any antag to kick or interrupt third party, me think
		user.Immobilize(30) // A very crude solution to kill any solo gamer
		if(sound_horn(user))
			TR.last_induced_ambush_time = world.time

/obj/item/signal_horn/proc/sound_horn(mob/living/user)
	user.visible_message(span_userdanger("[user]吹响了号角！"))
	switch(user.job)
		if("Warden")
			playsound(src, 'modular_hearthstone/sound/items/bogguardhorn.ogg', 100, TRUE)
		if("Town Sheriff", "Watchman", "Sergeant", "Man at Arms")
			playsound(src, 'modular_hearthstone/sound/items/watchhorn.ogg', 100, TRUE)
		if("Knight Captain", "Royal Guard")
			playsound(src, 'modular_hearthstone/sound/items/rghorn.ogg', 100, TRUE)
		else
			playsound(src, 'modular_hearthstone/sound/items/signalhorn.ogg', 100, TRUE)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/turf/origin_turf = get_turf(src)

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7 || distance > 21) // two screens away
			continue
		var/dirtext = "，方向在"
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "北边"
			if(SOUTH)
				dirtext += "南边"
			if(EAST)
				dirtext += "东边"
			if(WEST)
				dirtext += "西边"
			if(NORTHWEST)
				dirtext += "西北方"
			if(NORTHEAST)
				dirtext += "东北方"
			if(SOUTHWEST)
				dirtext += "西南方"
			if(SOUTHEAST)
				dirtext += "东南方"
			else //Where ARE you.
				dirtext = "，但我分辨不出确切方向"

		switch(user.job)
			if("Warden")
				player.playsound_local(get_turf(player), 'modular_hearthstone/sound/items/bogguardhorn.ogg', 35, FALSE, pressure_affected = FALSE)
			if("Marshal", "Watchman", "Sergeant", "Man at Arms")
				player.playsound_local(get_turf(player), 'modular_hearthstone/sound/items/watchhorn.ogg', 35, FALSE, pressure_affected = FALSE)
			if("Knight Captain", "Knight")
				player.playsound_local(get_turf(player), 'modular_hearthstone/sound/items/rghorn.ogg', 35, FALSE, pressure_affected = FALSE)
			else
				player.playsound_local(get_turf(player), 'modular_hearthstone/sound/items/signalhorn.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, span_warning("我听见某处传来了守卫的号角声[dirtext]"))

	var/random_ambushes = 4 + rand(0,2) // 4 - 6 ambushes
	var/did_ambush = FALSE
	for(var/i = 0, i < random_ambushes, i++)
		var/silent = (i != 0)
		var/success = user.consider_ambush(TRUE, TRUE, min_dist = WARDEN_AMBUSH_MIN, max_dist = WARDEN_AMBUSH_MAX, silent = silent)
		if(success)
			did_ambush = TRUE
	return did_ambush
