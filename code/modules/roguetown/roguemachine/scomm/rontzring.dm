// MATTHIAN SCOMCOIN

/obj/item/mattcoin
	name = "朗兹戒指"
	icon_state = "mattcoin"
	desc = "一枚已经褪色、中央嵌着红宝石的戒币。"
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_RING|ITEM_SLOT_GLOVES
	obj_flags = null
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	muteinmouth = TRUE
	var/listening = TRUE
	var/speaking = TRUE
	var/disguised = FALSE
	dropshrink = 0.7

	sellprice = 0
	grid_width = 32
	grid_height = 32

/obj/item/mattcoin/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()
	update_icon()
	SSroguemachine.scomm_machines += src
	name = pick("朗兹戒指", "金戒指")
	ADD_TRAIT(src, TRAIT_EXAMINE_SKIP, INNATE_TRAIT)

/obj/item/mattcoin/examine(mob/user)
	. = ..()
	. += span_notice("在手中使用戒指来伪装它。再次使用即可恢复原状。")

/obj/item/mattcoin/pickup(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_COMMIE))
		to_chat(user, "这枚戒币在我手中化成了灰烬！")
		playsound(loc, 'sound/items/firesnuff.ogg', 100, FALSE, -1)
		qdel(src)
	..()

/obj/item/mattcoin/doStrip(mob/stripper, mob/owner)
	if(!(stripper?.mind.has_antag_datum(/datum/antagonist/bandit))) //You're not a bandit, you can't strip the bandit coin
		to_chat(stripper, "[src]在我手中化成了灰烬！")
		playsound(stripper.loc, 'sound/items/firesnuff.ogg', 100, FALSE, -1)
		qdel(src)
		return FALSE
	. = ..()

/obj/item/mattcoin/attack_self(mob/living/user)
	. = ..()

	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("我被束缚或失去行动能力时无法使用它！"))
		return FALSE

	if(disguised)
		if(alert(user, "要解除伪装吗？", "伪装", "是", "否") == "是")
			name = "朗兹戒指"
			icon = 'icons/roguetown/items/misc.dmi'
			icon_state = "mattcoin"
			disguised = FALSE
			update_icon()
		return FALSE

	var/icon/J = new('icons/roguetown/clothing/bandit_rings.dmi')

	var/list/istates = list()

	for(var/icon_s in J.IconStates())
		if(findtext(icon_s, "mattcoin_"))
			istates += replacetext(icon_s, "mattcoin_", "")

	var/picked_name = input(user, "选择一种伪装", "ROGUETOWN") as null|anything in sortList(istates)
	if(!picked_name)
		return

	icon = 'icons/roguetown/clothing/bandit_rings.dmi'
	icon_state = "mattcoin_[picked_name]"

	name = replacetext(picked_name, "_", " ")
	disguised = TRUE

	update_icon()

/obj/item/mattcoin/attack_right(mob/living/carbon/human/user)
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("我在被束缚或失去行动能力时无法使用它！"))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	var/input_text = input(user, "输入你的消息：", "消息")
	if(input_text)
		var/usedcolor = user.voice_color
		if(user.voicecolor_override)
			usedcolor = user.voicecolor_override
		user.whisper(input_text)
		if(length(input_text) > 100)
			input_text = "<small>[input_text]</small>"
		for(var/obj/item/mattcoin/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src, usedcolor)

/obj/item/mattcoin/MiddleClick(mob/user)
	if(.)
		return
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("我被束缚或失去行动能力时无法使用它！"))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
	listening = !listening
	speaking = !speaking
	to_chat(user, span_info("我将马西奥斯通讯石[speaking ? "取消静音" : "静音"]了。"))
	update_icon()

/obj/item/mattcoin/Destroy()
	lose_hearing_sensitivity()
	SSroguemachine.scomm_machines -= src
	return ..()

/obj/item/mattcoin/proc/repeat_message(message, atom/A, tcolor, message_language)
	if(A == src)
		return
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, 'sound/foley/coins1.ogg', 20, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null


/obj/item/mattcoin/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	if(istype(loc, /obj/item))
		var/obj/item/I = loc
		I.send_speech(message, 0, I, , spans, message_language=language)
	else
		send_speech(message, 0, src, , spans, message_language=language)
