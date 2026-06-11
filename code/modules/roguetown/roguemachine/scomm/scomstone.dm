//SCOMSTONE                 SCOMSTONE

/obj/item/scomstone
	name = "传讯石"
	icon_state = "ring_scom"
	desc = "一枚沉重的金属戒指，中央嵌着一颗宝石，光芒黯淡，却仿佛活着。"
	gripped_intents = null
	dropshrink = 0.6
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_RING|ITEM_SLOT_HANDS
	obj_flags = null
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	muteinmouth = TRUE
	nudist_approved = TRUE
	var/cooldown = 60 SECONDS
	var/on_cooldown = FALSE
	var/listening = TRUE
	var/speaking = TRUE
	var/loudmouth_listening = TRUE
	var/messagereceivedsound = 'sound/misc/scom.ogg'
	var/scomstone_number
	var/hearrange = 1 // change to 0 if you want your special scomstone to be only hearable by wearer
	drop_sound = 'sound/foley/coinphy (1).ogg'
	sellprice = 100
	grid_width = 32
	grid_height = 32

/obj/item/scomstone/attack_right(mob/living/carbon/human/user)
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("我被束缚或失去行动能力时无法使用它！"))
		return
	if(on_cooldown)
		to_chat(user, span_warning("戒指里的宝石正散发着热量。它还在为上一次使用降温。"))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	visible_message(span_notice ("[user]把戒指贴到了自己的嘴边。"))
	var/input_text = input(user, "输入你的消息：", "消息")
	if(!input_text)
		return
	var/usedcolor = user.voice_color
	if(user.voicecolor_override)
		usedcolor = user.voicecolor_override
	user.whisper(input_text)
	if(length(input_text) > 100) //When these people talk too much, put that shit in slow motion, yeah
		input_text = "<small>[input_text]</small>"
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor)
	for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor)
	for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines) //make the listenstone hear scomstone
		S.repeat_message(input_text, src, usedcolor)
	SSroguemachine.crown?.repeat_message(input_text, src, usedcolor)
	on_cooldown = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_cooldown), user), cooldown)

	//Log message to global broadcast list.
	GLOB.broadcast_list += list(list(
	"message"   = input_text,
	"tag"		= "SCOM传讯网STONE #[scomstone_number]",
	"timestamp" = station_time_timestamp("hh:mm:ss")
	))

/obj/item/scomstone/proc/reset_cooldown(mob/living/carbon/human/user)
	to_chat(user, span_notice("[src]已经可以再次使用了。"))
	playsound(loc, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
	on_cooldown = FALSE

/obj/item/scomstone/MiddleClick(mob/user)
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("我被束缚或失去行动能力时无法使用它！"))
		return
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(loudmouth_listening)
		to_chat(user, span_info("我压下了传讯石上金口者的聒噪。你仍可将其彻底静音。"))
		loudmouth_listening = FALSE
	else
		listening = !listening
		speaking = !speaking
		to_chat(user, span_info("我将传讯石[speaking ? "解除静音" : "静音"]。"))
		if(listening)
			loudmouth_listening = TRUE
		update_icon()

/obj/item/scomstone/Destroy()
	SSroguemachine.scomm_machines -= src
	lose_hearing_sensitivity()
	return ..()

/obj/item/scomstone/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()
	update_icon()
	SSroguemachine.scomm_machines += src
	scomstone_number = SSroguemachine.scomm_machines.len

/obj/item/scomstone/examine(mob/user)
	. = ..()
	if(scomstone_number)
		. += "它的编号是 #[scomstone_number]。"

/obj/item/scomstone/proc/repeat_message(message, atom/A, tcolor, message_language)
	if(A == src)
		return
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, messagereceivedsound, 100, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null


/obj/item/scomstone/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	if(istype(loc, /obj/item))
		var/obj/item/I = loc
		I.send_speech(message, hearrange, I, , spans, message_language=language)
	else
		send_speech(message, hearrange, src, , spans, message_language=language)

/obj/item/scomstone/bad
	name = "农奴石"
	desc = "一枚粗制滥造、锈迹斑斑的金属戒指，里面嵌着的宝石几乎快撑不住了。"
	icon_state = "ring_serfscom"
	listening = FALSE
	sellprice = 20

/obj/item/scomstone/bad/attack_right(mob/user)
	return

// garrison scoms/listenstones

/obj/item/scomstone/garrison
	name = "王冠石"
	icon_state = "ring_crownscom"
	desc = "一枚带有王冠印记的华丽金戒，沉重而张扬。嵌着的宝石正兴奋地闪烁着。"
	var/garrisonline = TRUE
	messagereceivedsound = 'sound/misc/garrisonscom.ogg'
	hearrange = 0
	sellprice = 100

/obj/item/scomstone/garrison/attack_right(mob/living/carbon/human/user)
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("我被束缚或失去行动能力时无法使用它！"))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(on_cooldown)
		to_chat(user, span_warning("戒指里的宝石正散发着热量。它还在为上一次使用降温。"))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	visible_message(span_notice ("[user]把戒指贴到了自己的嘴边。"))
	var/input_text = input(user, "输入你的消息：", "消息")
	if(!input_text)
		return
	var/usedcolor = user.voice_color
	if(user.voicecolor_override)
		usedcolor = user.voicecolor_override
	user.whisper(input_text)
	if(length(input_text) > 100) //When these people talk too much, put that shit in slow motion, yeah
		input_text = "<small>[input_text]</small>"
	playsound(loc, 'sound/misc/garrisonscom.ogg', 100, FALSE, -1)
	if(garrisonline)
		input_text = "<big><span style='color: [GARRISON_SCOM_COLOR]'>[input_text]</span></big>" //Prettying up for Garrison line
		for(var/obj/item/scomstone/bad/garrison/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src, usedcolor)
		for(var/obj/item/scomstone/garrison/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src, usedcolor)
		for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
			if(S.garrisonline)
				S.repeat_message(input_text, src, usedcolor)
		SSroguemachine.crown?.repeat_message(input_text, src, usedcolor)
		on_cooldown = TRUE
		addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), cooldown)
		return
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor)
	for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor)
	for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor)
	SSroguemachine.crown?.repeat_message(input_text, src, usedcolor)
	on_cooldown = TRUE

	//Log messages that aren't sent on the garrison line.
	GLOB.broadcast_list += list(list(
	"message"   = input_text,
	"tag"		= "CROWNSTONE #[scomstone_number]",
	"timestamp" = station_time_timestamp("hh:mm:ss")
	))

	addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), cooldown)

/obj/item/scomstone/garrison/attack_self(mob/living/user)
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("我被束缚或失去行动能力时无法使用它！"))
		return
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	garrisonline = !garrisonline
	to_chat(user, span_info("我[garrisonline ? "接入驻军 SCOM 线路" : "接入常规 SCOM 线路"]。"))
	update_icon()

/obj/item/scomstone/garrison/update_icon()
	icon_state = "[initial(icon_state)][garrisonline ? "_on" : ""]"

/obj/item/scomstone/bad/garrison
	name = "猎犬石"
	desc = "一枚朴素的金属戒指，镶着一颗切工考究却色泽阴沉的宝石，上面带有王冠印记。"
	icon_state = "ring_houndscom"
	listening = FALSE
	sellprice = 20
	messagereceivedsound = 'sound/misc/garrisonscom.ogg'
	hearrange = 0
