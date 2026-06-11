#define GARRISON_CROWN_COLOR "#C2A245"

/obj/item/clothing/head/roguetown/crown/serpcrown
	name = "王国之冠"
	article = "the"
	desc = "欲戴此冠，必承其重。"
	icon_state = "serpcrown"
	//dropshrink = 0
	dynamic_hair_suffix = null
	sellprice = 200
	resistance_flags = FIRE_PROOF | ACID_PROOF
	anvilrepair = /datum/skill/craft/armorsmithing
	visual_replacement = /obj/item/clothing/head/roguetown/crown/fakecrown
	var/listening = TRUE
	var/speaking = TRUE
	var/loudmouth_listening = TRUE
	var/garrisonline = TRUE
	var/messagereceivedsound = 'sound/misc/scom.ogg'
	var/hearrange = 0 // Only hearable by wearer
	is_important = TRUE
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP|ITEM_SLOT_MASK

/obj/item/clothing/head/roguetown/crown/serpcrown/Initialize(mapload)
	. = ..()
	if(SSroguemachine.crown)
		qdel(src)
	else
		SSroguemachine.crown = src
		SSroguemachine.scomm_machines += src
	become_hearing_sensitive()

/obj/item/clothing/head/roguetown/crown/serpcrown/proc/anti_stall()
	src.visible_message(span_warning("[SSmapping.map_adjustment.realm_name]之冠碎成尘埃，灰烬朝着要塞的方向飘然而去。"))
	SSroguemachine.scomm_machines -= src
	SSroguemachine.crown = null //Do not harddel.
	qdel(src) //Anti-stall

/obj/item/clothing/head/roguetown/crown/serpcrown/attack_right(mob/living/carbon/human/user)
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("我被束缚或失去行动能力时，无法使用这个！"))
		return
	user.changeNext_move(CLICK_CD_MELEE)
	visible_message(span_notice ("[user]将双手按在自己的王冠上。"))
	var/input_text = input(user, "输入你的公爵讯息：", "王冠SCOM")
	if(input_text)
		var/usedcolor = user.voice_color
		if(user.voicecolor_override)
			usedcolor = user.voicecolor_override
		user.whisper(input_text)
		if(length(input_text) > 100)
			input_text = "<small>[input_text]</small>"
		if(!garrisonline)
			for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
				S.repeat_message(input_text, src, usedcolor)
			for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
				S.repeat_message(input_text, src, usedcolor)
			for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines)
				S.repeat_message(input_text, src, usedcolor)

			GLOB.broadcast_list += list(list(
			"message"   = input_text,
			"tag"		= "[SSmapping.map_adjustment.realm_name]之冠",
			"timestamp" = station_time_timestamp("hh:mm:ss")
			))

		if(garrisonline)
			input_text = "<big><span style='color: [GARRISON_CROWN_COLOR]'>[input_text]</span></big>" // Prettying up for Garrison line
			for(var/obj/item/scomstone/bad/garrison/S in SSroguemachine.scomm_machines)
				S.repeat_message(input_text, src, usedcolor)
			for(var/obj/item/scomstone/garrison/S in SSroguemachine.scomm_machines)
				S.repeat_message(input_text, src, usedcolor)
			for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
				if(S.garrisonline)
					S.repeat_message(input_text, src, usedcolor)

/obj/item/clothing/head/roguetown/crown/serpcrown/attack_self(mob/living/user)
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("我被束缚或失去行动能力时，无法使用这个！"))
		return
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	garrisonline = !garrisonline
	to_chat(user, span_info("[garrisonline ? "我将王冠接入驻军SCOM线路。" : "我将王冠接入通用SCOM线路。"]"))

/obj/item/clothing/head/roguetown/crown/serpcrown/MiddleClick(mob/user)
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("我被束缚或失去行动能力时，无法使用这个！"))
		return
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(loudmouth_listening)
		to_chat(user, span_info("我压下了Loudmouth在SCOM石上的聒噪。若有需要，仍可将其彻底静音。"))
		loudmouth_listening = FALSE
	else
		listening = !listening
		speaking = !speaking
		to_chat(user, span_info("[speaking ? "我恢复了王冠的SCOM功能。" : "我关闭了王冠的SCOM功能。"]"))
		if(listening)
			loudmouth_listening = TRUE
	update_icon()

/obj/item/clothing/head/roguetown/crown/serpcrown/proc/repeat_message(message, atom/A, tcolor, message_language, list/tspans = list())
	if(A == src)
		return
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, messagereceivedsound, 100, TRUE, -1)
		say(message, spans = tspans, language = message_language)
	voicecolor_override = null

/obj/item/clothing/head/roguetown/crown/serpcrown/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
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

/obj/item/clothing/head/roguetown/crown/serpcrown/Destroy()
	lose_hearing_sensitivity()
	return ..()
