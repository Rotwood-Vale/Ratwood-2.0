#define GARRISON_SCOM_COLOR "#FF4242"
#define NORMAL_SCOM_TRANSMISSION_DELAY 15 SECONDS
#define NORMAL_SCOM_PER_MESSAGE_DELAY 15 SECONDS
#define CHEESE_QUIET_TIME 2 MINUTES // How long stuffing a slice of cheese in quieten the SCOM

/obj/structure/roguemachine/scomm
	name = "SCOM传讯网"
	desc = "超自然光学通讯机是魔法与技术共同造就的奇迹，能够在远距离间收发消息。中间的按钮可用于建立私密的密语线连接。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "scomm1"
	density = FALSE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	pixel_y = 32
	anchored = TRUE
	verb_say = "squeaks"
	var/next_decree = 0
	var/listening = TRUE
	var/speaking = TRUE
	var/loudmouth_listening = TRUE
	var/dictating = FALSE
	var/scom_number
	var/scom_tag
	var/obj/structure/roguemachine/scomm/calling = null
	var/obj/structure/roguemachine/scomm/called_by = null
	/// Last time the SCOM sent a message. Used to check delay
	var/last_message = 0
	/// Whether this is a receive only SCOM, that cannot transmit any messages. Uses this for any kind of SCOM that is out of town and is not actionable
	var/receive_only = FALSE
	var/spawned_rat = FALSE
	var/garrisonline = FALSE
	/// Track whether it was cheesed recently
	var/last_cheese = 0

/obj/structure/roguemachine/scomm/OnCrafted(dirin, mob/user)
	. = ..()
	loc = user.loc
	pixel_y = 0
	switch(dirin)
		if(NORTH)
			pixel_y = 32
		if(SOUTH)
			pixel_y = -32
		if(EAST)
			pixel_x = 32
		if(WEST)
			pixel_x = -32

/obj/structure/roguemachine/scomm/r
	pixel_y = 0
	pixel_x = 32

/obj/structure/roguemachine/scomm/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/roguemachine/scomm/receive_only
	name = "RCOM传讯网"
	desc = "接收型光学通讯机是 SCOM传讯网 更廉价、更常见的版本，只能接收远距离消息。它们常见于城外，尤其是古老遗迹附近。"
	receive_only = TRUE

/obj/structure/roguemachine/scomm/receive_only/r
	pixel_y = 0
	pixel_x = 32

/obj/structure/roguemachine/scomm/receive_only/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/roguemachine/scomm/examine(mob/user)
	. = ..()
	. += span_small("普通线路有 [NORMAL_SCOM_TRANSMISSION_DELAY / 10] 秒延迟。高级的驻军线路则不受此限制。")
	. += span_smallnotice("你看见里面有几只老鼠在来回乱窜！也许它们会想吃一片奶酪？")
	if(scom_number)
		. += span_smallnotice("它的编号是 #[scom_number][scom_tag ? "，标识为 [scom_tag]" : ""]。")
	. += "<a href='?src=[REF(src)];directory=1'>名录</a>"
	. += "<b>国土法令：</b>"
	if(!length(GLOB.laws_of_the_land))
		. += span_danger("这片土地没有法律！<b>我们完了！</b>")
		return
	if(!user.is_literate())
		. += span_warning("呃……我看不懂这些……")
		return
	for(var/i in 1 to length(GLOB.laws_of_the_land))
		. += span_small("[i]. [GLOB.laws_of_the_land[i]]")

/obj/structure/roguemachine/scomm/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["directory"])
		view_directory(usr)

/obj/structure/roguemachine/scomm/proc/view_directory(mob/user)
	var/dat
	for(var/obj/structure/roguemachine/scomm/X in SSroguemachine.scomm_machines)
		dat += "#[X.scom_number] [X.scom_tag]<br>"

	var/datum/browser/popup = new(user, "scom_directory", "<center>鼠群名录</center>", 387, 420)
	popup.set_content(dat)
	popup.open(FALSE)

/obj/structure/roguemachine/scomm/process()
	if(world.time <= next_decree)
		return
	next_decree = world.time + rand(3 MINUTES, 8 MINUTES)
	if(!GLOB.lord_decrees.len)
		return
	if(!speaking)
		return
	say("[SSticker.rulertype]法令：[pick(GLOB.lord_decrees)]", spans = list("info"))

/obj/structure/roguemachine/scomm/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(called_by && !calling)
		calling = called_by
		calling.say("密语线已接通。", spans = list("info"))
		say("密语线已接通。", spans = list("info"))
		update_icon()
		return
	if(calling)
		listening = !listening
		to_chat(user, span_info("我将 SCOM传讯网 的输入[listening ? "解除静音" : "静音"]了。"))
		return
	if(loudmouth_listening)
		to_chat(user, span_info("我压下了 SCOM传讯网 上金口者的聒噪。你仍可将其彻底静音。"))
		loudmouth_listening = FALSE
	else
		listening = !listening
		speaking = listening
		to_chat(user, span_info("我将 SCOM传讯网[speaking ? "解除静音" : "静音"]了。"))
		if(listening)
			loudmouth_listening = TRUE
	update_icon()

/obj/structure/roguemachine/scomm/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/reagent_containers/food/snacks/rogue/cheddarslice))
		to_chat(user, span_smallnotice("你悄悄往 SCOM传讯网 里塞了一块奶酪，让里面的老鼠暂时安静了下来……"))
		last_cheese = world.time
		qdel(W)

/obj/structure/roguemachine/scomm/attack_right(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(called_by && !calling)
		called_by.say("密语线被拒绝。", spans = list("info"))
		say("密语线被拒绝。", spans = list("info"))
		called_by.calling = null
		called_by = null
		return
	if(calling)
		speaking = !speaking
		to_chat(user, span_info("我将 SCOM传讯网 的输出[speaking ? "解除静音" : "静音"]了。"))
		return
	var/canread = user.can_read(src, TRUE)
	var/contents
	contents += "<center>[uppertext(SSticker.rulertype)]的法令<BR>"
	contents += "-----------<BR><BR></center>"
	for(var/i = GLOB.lord_decrees.len to 1 step -1)
		contents += "[i]. <span class='info'>[GLOB.lord_decrees[i]]</span><BR>"
	if(!canread)
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 220)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/scomm/MiddleClick(mob/living/carbon/human/user)
	if(.)
		return
	if((HAS_TRAIT(user, TRAIT_GUARDSMAN) || (user.job == "Watchman") || (user.job == "Warden") || (user.job == "Master Warden") || (user.job == "Councillor") || (user.job == "Squire") || (user.job == "Marshal") || (user.job == "Grand Duke") || (user.job == "Knight Captain") || (user.job == "Grand Duchess") ||(user.job == "Hand") ||(user.job == "Vizier") || (user.job == "Sheikh") || (user.job == "Azeb") || (user.job == "Azebagha")))
		if(alert("你想切换线路，还是接入密语线？",, "切换", "密语线") != "密语线")
			garrisonline = !garrisonline
			to_chat(user, span_info("我[garrisonline ? "接入驻军 SCOM 线路" : "接入常规 SCOM 线路"]。"))
			playsound(loc, 'sound/misc/garrisonscom.ogg', 100, FALSE, -1)
			update_icon()
			return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(calling)
		calling.say("密语线已切断。", spans = list("info"))
		if(calling.calling == src || calling.called_by == src)
			var/obj/structure/roguemachine/scomm/old_calling = calling
			old_calling.called_by = null
			old_calling.calling = null
			old_calling.speaking = old_calling.listening
			old_calling.update_icon()
		calling = null
		called_by = null
		speaking = listening
		to_chat(user, span_info("我切断了密语线。"))
		say("密语线已切断。", spans = list("info"))
		update_icon()
	else
		say("请输入 SCOM传讯网 编号。", spans = list("info"))
		var/nightcall = input(user, "输入你拿到的编号。", "连接界面") as null|num
		if(!nightcall)
			return
		if(nightcall == scom_number)
			to_chat(user, span_warning("回应你的只有老鼠的吱叫声。"))
			playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
			return
		if(SSroguemachine.scomm_machines.len < nightcall)
			say("没有老鼠在维护这条密语线。", spans = list("info"))
			return
		var/obj/structure/roguemachine/scomm/S = SSroguemachine.scomm_machines[nightcall]
		if(istype(S, /obj/structure/roguemachine/scomm/receive_only))
			say("RCOM传讯网 里没有老鼠能回应密语线。")
			return
		if(istype(S, /obj/item/scomstone))
			say("这条密语线的老鼠到不了传讯石。") //Check prevents a runtime and leaves room to potentially make scomstones callable by ID later.
			playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
			return
		if(!S)
			to_chat(user, span_warning("回应你的只有老鼠的吱叫声。"))
			playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
			return
		if(S.calling || S.called_by)
			say("这条密语线上的老鼠正忙着。", spans = list("info"))
			return
		if(!S.speaking)
			say("这条密语线上的老鼠被堵住嘴了。", spans = list("info"))
			return
		calling = S
		S.called_by = src
		update_icon()

		for(var/i in 1 to 10)
			if(!calling)
				update_icon()
				return
			if(calling.calling == src)
				return
			calling.ring_ring()
			ring_ring()
			sleep(30)
		say("这条密语线上的老鼠已经筋疲力尽。", spans = list("info"))
		calling.called_by = null
		calling = null
		update_icon()

/obj/structure/roguemachine/scomm/receive_only/MiddleClick(mob/living/carbon/human/user)
	to_chat(user, span_warning("RCOM传讯网 里没有能送信的老鼠，它只能接收消息。"))
	return

/obj/structure/roguemachine/scomm/obj_break(damage_flag)
	..()
	calling?.say("密语线已切断。", spans = list("info"))
	calling?.speaking = calling?.listening
	calling?.called_by = null
	calling?.calling = null
	called_by = null
	calling = null
	speaking = FALSE
	listening = FALSE
	update_icon()
	icon_state = "[icon_state]-br"

/obj/structure/roguemachine/scomm/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSroguemachine, src)
	become_hearing_sensitive()
	update_icon()
	SSroguemachine.scomm_machines += src
	scom_number = SSroguemachine.scomm_machines.len

/obj/structure/roguemachine/scomm/update_icon()
	if(obj_broken)
		set_light(0)
		return
	if(garrisonline)
		icon_state = "scomm2"
		return
	if(calling)
		icon_state = "scomm2"
	else if(listening)
		icon_state = "scomm1"
	else
		icon_state = "scomm0"
	if(listening)
		if(!loudmouth_listening)
			icon_state = "scomm3"

/obj/structure/roguemachine/scomm/Destroy()
	lose_hearing_sensitivity()
	SSroguemachine.scomm_machines -= src
	STOP_PROCESSING(SSroguemachine, src)
	set_light(0)
	return ..()

/obj/structure/roguemachine/scomm/proc/ring_ring()
	playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+1, time = 0.5)
	animate(pixel_x = oldx-1, time = 0.5)
	animate(pixel_x = oldx, time = 0.5)

/obj/structure/roguemachine/scomm/proc/repeat_message(message, atom/A, tcolor, message_language, list/tspans, broadcaster_tag)
	if(A == src)
		return
	// The SCOM just do not work silently if cheesed
	if(last_cheese && (last_cheese + CHEESE_QUIET_TIME >= world.time))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null

/obj/structure/roguemachine/scomm/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(speaker.loc != loc)
		return
	if(!ishuman(speaker))
		return
	if(!listening)
		return
	if(receive_only)
		to_chat(speaker, span_warning("这台 RCOM传讯网 只能接收消息！"))
		return
	if(last_cheese && (last_cheese + CHEESE_QUIET_TIME >= world.time))
		to_chat(speaker, span_warning("那些老鼠似乎正忙着啃什么东西！"))
		return
	if(world.time < last_message + NORMAL_SCOM_PER_MESSAGE_DELAY)
		var/time_remaining = round((last_message + NORMAL_SCOM_PER_MESSAGE_DELAY - world.time) / 10)
		to_chat(speaker, span_warning("SCOM传讯网 里的老鼠还在恢复。再等 [time_remaining] 秒。"))
		return
	var/mob/living/carbon/human/H = speaker
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	// Update last message time
	last_message = world.time
	// Feedback to indicate successful sending
	playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
	if(raw_message)
		if(calling)
			if(calling.calling == src)
				calling.repeat_message(raw_message, src, usedcolor, message_language)
			return
		if(length(raw_message) > 100) //When these people talk too much, put that shit in slow motion, yeah
			raw_message = "<small>[raw_message]</small>"

		// Build message prefix with SCOM location.
		var/message_affix = ""
		if(scom_number)
			message_affix = "- [scom_tag ? "([scom_tag])" : ""]"
		if(message_affix)
			raw_message = "[raw_message][message_affix]"

		if(garrisonline)
			raw_message = "<span style='color: [GARRISON_SCOM_COLOR]'>[raw_message]</span>" //Prettying up for Garrison line
			for(var/obj/item/scomstone/garrison/S in SSroguemachine.scomm_machines)
				S.repeat_message(raw_message, src, usedcolor, message_language)
			for(var/obj/item/scomstone/bad/garrison/S in SSroguemachine.scomm_machines)
				S.repeat_message(raw_message, src, usedcolor, message_language)
			for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
				if(S.garrisonline)
					S.repeat_message(raw_message, src, usedcolor, message_language)
			SSroguemachine.crown?.repeat_message(raw_message, src, usedcolor, message_language)
			return
		else
			addtimer(CALLBACK(src, PROC_REF(repeat_message_scom), raw_message, usedcolor, message_language), NORMAL_SCOM_TRANSMISSION_DELAY)

// Repeat message for normal SCOM. Meant to be used in a callback with delay
/obj/structure/roguemachine/scomm/proc/repeat_message_scom(raw_message, usedcolor, message_language)
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		if(!S.calling)
			S.repeat_message(raw_message, src, usedcolor, message_language)
	for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(raw_message, src, usedcolor, message_language)
	for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(raw_message, src, usedcolor, message_language)//make the listenstone hear scom
	SSroguemachine.crown?.repeat_message(raw_message, src, usedcolor, message_language)

/obj/structure/roguemachine/scomm/proc/dictate_laws()
	if(dictating)
		return
	dictating = TRUE
	repeat_message("国土法令如下……", tcolor = COLOR_RED)
	INVOKE_ASYNC(src, PROC_REF(dictation))

/obj/structure/roguemachine/scomm/proc/dictation()
	if(!length(GLOB.laws_of_the_land))
		sleep(2)
		repeat_message("这片土地没有法律！", tcolor = COLOR_RED)
		dictating = FALSE
		return
	for(var/i in 1 to length(GLOB.laws_of_the_land))
		sleep(2)
		repeat_message("[i]. [GLOB.laws_of_the_land[i]]", tcolor = COLOR_RED)
	dictating = FALSE

/proc/scom_announce(message)
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		if(S.speaking)
			S.say(message, spans = list("info"))
