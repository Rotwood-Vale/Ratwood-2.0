/obj/item/speakerinq
	name = "密语者"
	desc = "甜美的秘密被如此轻易地低语而出。"
	var/speaking = TRUE
	sellprice = 20
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scomite"
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP|ITEM_SLOT_RING|ITEM_SLOT_HANDS
	possible_item_intents = list(INTENT_GENERIC)
	sleeved = 'icons/roguetown/clothing/onmob/neck.dmi'
	grid_width = 32
	grid_height = 32
	var/fakename = "密语者"

/obj/item/speakerinq/proc/repeat_message(message, atom/A, tcolor, message_language)
	if(A == src)
		return
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		var/mob/living/carbon/human/wearer = loc
		wearer.playsound_local(wearer, 'sound/vo/mobs/rat/rat_life.ogg', 50, TRUE)
		say(message, language = message_language)
	voicecolor_override = null

/obj/item/speakerinq/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
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


/obj/item/speakerinq/equipped(mob/user, slot)
	. = ..()
	switch(slot)
		if(SLOT_RING)
			fakename = "银质印戒"	
			name = fakename
	return TRUE		


/obj/item/speakerinq/dropped(mob/user, silent)
	. = ..()
	name = initial(name)
	sleeved = null
	mob_overlay_icon = null

/obj/item/speakerinq/Destroy()
	SSroguemachine.scomm_machines -= src
	return ..()

/obj/item/speakerinq/Initialize(mapload)
	. = ..()
	icon_state = "scomite_active"
	update_icon()
	SSroguemachine.scomm_machines += src

/obj/item/speakerinq/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	speaking = !speaking
	to_chat(user, span_info("我将密语低语器[speaking ? "解除禁言" : "禁言"]了。"))
	if(speaking)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = "[initial(icon_state)]"
	update_icon()

