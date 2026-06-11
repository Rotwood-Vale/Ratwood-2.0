/obj/item/war_horn
	name = "通用战号"
	desc = "用于在战场上协调部队并发出警报，右键号角可发布自定义讯息。"
	icon = 'modular_helmsguard/icons/obj/items/warhorns.dmi'
	icon_state = "humanhorn"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_NORMAL
	possible_item_intents = list(/datum/intent/war_horn/retreat, /datum/intent/war_horn/rally, /datum/intent/war_horn/hold, /datum/intent/war_horn/charge)
	var/retreatsound = 'modular_hearthstone/sound/items/bogguardhorn.ogg'
	var/rallysound = 'modular_hearthstone/sound/items/watchhorn.ogg'
	var/holdsound = 'modular_hearthstone/sound/items/rghorn.ogg'
	var/chargesound = 'modular_hearthstone/sound/items/signalhorn.ogg'
	var/farretreatsound = 'modular_hearthstone/sound/items/bogguardhorn.ogg'
	var/farrallysound = 'modular_hearthstone/sound/items/watchhorn.ogg'
	var/farholdsound = 'modular_hearthstone/sound/items/rghorn.ogg'
	var/farchargesound = 'modular_hearthstone/sound/items/signalhorn.ogg'
	var/hornchannel

//someone has to get a 4th sound for each and missing distant sounds.

/obj/item/war_horn/human
	name = "青铜战号"
	icon_state = "humanhorn"
	retreatsound = 'modular_helmsguard/sound/items/horns/h_retreat.ogg'
	rallysound = 'modular_helmsguard/sound/items/horns/h_rally.ogg'
	holdsound = 'modular_helmsguard/sound/items/horns/h_hold.ogg'
	chargesound = 'modular_helmsguard/sound/items/horns/h_charge.ogg'
	farretreatsound = 'modular_helmsguard/sound/items/horns/h_retreat_distant.ogg'
	farrallysound = 'modular_helmsguard/sound/items/horns/h_rally_distant.ogg'
	farholdsound = 'modular_helmsguard/sound/items/horns/h_hold_distant.ogg'
	farchargesound = 'modular_helmsguard/sound/items/horns/h_charge_distant.ogg'

	
/obj/item/war_horn/orc
	name = "兽人战号"
	icon_state = "orchorn"
	retreatsound = 'modular_helmsguard/sound/items/horns/o_retreat.ogg'
	rallysound = 'modular_helmsguard/sound/items/horns/o_rally.ogg'
	holdsound = 'modular_helmsguard/sound/items/horns/o_hold.ogg'
	chargesound = 'modular_helmsguard/sound/items/horns/o_charge.ogg'
	farretreatsound = 'modular_helmsguard/sound/items/horns/o_retreat_distant.ogg'
	farrallysound = 'modular_helmsguard/sound/items/horns/o_rally_distant.ogg'
	farholdsound = 'modular_helmsguard/sound/items/horns/o_hold_distant.ogg'
	farchargesound = 'modular_helmsguard/sound/items/horns/o_charge_distant.ogg'

/datum/intent/war_horn
	attack_verb = list("击打", "挥击")
	item_d_type = "blunt"
	chargetime = 0
	swingdelay = 0

/datum/intent/war_horn/retreat
	name = "撤退"
	icon_state = "inretreat"

/datum/intent/war_horn/rally
	name = "集结"
	icon_state = "inrally"

/datum/intent/war_horn/hold
	name = "坚守"
	icon_state = "inhold"

/datum/intent/war_horn/charge
	name = "冲锋"
	icon_state = "incharge"

/obj/item/war_horn/attack_self(mob/living/user)
	. = ..()
	user.visible_message(span_warning("[user] 准备吹响 [src]！"))
	if(do_after(user, 15))
		sound_horn(user, user.a_intent)

/obj/item/war_horn/rmb_self(mob/user)
	. = ..()
	var/inputty = input("发布一则通告", "ROGUETOWN") as text|null
	if(inputty)
		sound_horn_announcement(user, user.a_intent, inputty)

/obj/item/war_horn/proc/sound_horn(mob/living/user, datum/intent)
	user.stop_sound_channel(hornchannel)
	hornchannel = SSsounds.random_available_channel()
	user.visible_message(span_warning("[user] 吹响了号角！"))
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
				to_chat(player, span_warning("[user] 在 [currentarea.location_name] 发出了 [user.a_intent] 信号！"))
			continue
		var/dirtext = "的"
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "北方"
			if(SOUTH)
				dirtext += "南方"
			if(EAST)
				dirtext += "东方"
			if(WEST)
				dirtext += "西方"
			if(NORTHWEST)
				dirtext += "西北方"
			if(NORTHEAST)
				dirtext += "东北方"
			if(SOUTHWEST)
				dirtext += "西南方"
			if(SOUTHEAST)
				dirtext += "东南方"
			else //Where ARE you.
				dirtext = "某个我分辨不清方向的位置"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = "很近"
			if(20 to 40)
				disttext = "较近"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = "较远"
			else
				disttext = "很远"
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
			to_chat(player, span_warning("我听见 [currentarea.name] 某处[disttext][dirtext]传来了[user.a_intent.name]的信号！"))
		else
			to_chat(player, span_warning("我听见某处[disttext][dirtext]传来了异族的号角信号！"))
		player.playsound_local(get_turf(player), soundtouse, 35, FALSE, pressure_affected = FALSE, channel = hornchannel)

/obj/item/war_horn/proc/sound_horn_announcement(mob/living/user, datum/intent, inputty)
	user.stop_sound_channel(hornchannel)
	hornchannel = SSsounds.random_available_channel()
	user.visible_message(span_warning("[user] 吹响了号角！"))
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
				to_chat(player, span_warning("[user] 在 [currentarea.location_name] 发出了号角信号！"))
				to_chat(player, span_colossus("[inputty]"))
			continue
		var/dirtext = "的"
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "北方"
			if(SOUTH)
				dirtext += "南方"
			if(EAST)
				dirtext += "东方"
			if(WEST)
				dirtext += "西方"
			if(NORTHWEST)
				dirtext += "西北方"
			if(NORTHEAST)
				dirtext += "东北方"
			if(SOUTHWEST)
				dirtext += "西南方"
			if(SOUTHEAST)
				dirtext += "东南方"
			else //Where ARE you.
				dirtext = "某个我分辨不清方向的位置"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = "很近"
			if(20 to 40)
				disttext = "较近"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = "较远"
			else
				disttext = "很远"
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
			to_chat(player, span_colossus("[inputty]"))
		else
			to_chat(player, span_warning("我听见某处[disttext][dirtext]传来了异族的号角信号！"))
		player.playsound_local(get_turf(player), soundtouse, 35, FALSE, pressure_affected = FALSE, channel = hornchannel)
	message_admins("[user] sent out a horn signal: [inputty] from [ADMIN_VERBOSEJMP(user.loc)]")
	log_game("[user] sent out a horn signal: [inputty] from [loc_name(user.loc)]")
