// ASHEN HOST SCOMSTONE

/obj/item/clothing/neck/roguetown/psicross/inhumen/ashen
	name = "iron zcross"
	desc = "A crude iron cross, cold to the touch."
	icon = 'icons/roguetown/clothing/neck.dmi' //CHANGE THIS to whichever .dmi holds zcross_iron
	icon_state = "zcross_iron"
	gripped_intents = null
	possible_item_intents = list(INTENT_GENERIC)
	slot_flags = ITEM_SLOT_RING|ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	obj_flags = null
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	muteinmouth = TRUE
	dropshrink = 0.75
	force = 5
	throwforce = 5
	sellprice = 0
	grid_width = 32
	grid_height = 32
	var/listening = TRUE
	var/speaking = TRUE

/obj/item/clothing/neck/roguetown/psicross/inhumen/ashen/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()
	SSroguemachine.scomm_machines += src

/obj/item/clothing/neck/roguetown/psicross/inhumen/ashen/Destroy()
	lose_hearing_sensitivity()
	SSroguemachine.scomm_machines -= src
	return ..()
/obj/item/clothing/neck/roguetown/psicross/inhumen/ashen/proc/is_ashen(mob/user)
	return HAS_TRAIT(user, TRAIT_ASHEN_HOST)

/obj/item/clothing/neck/roguetown/psicross/inhumen/ashen/examine(mob/user)
	. = ..()
	if(is_ashen(user))
		. += span_notice("Right-click to whisper to the Host. Middle-click to mute or unmute it.")

/obj/item/clothing/neck/roguetown/psicross/inhumen/ashen/attack_right(mob/living/carbon/human/user)
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("I cannot use this while restrained or incapacitated!"))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(!is_ashen(user))
		to_chat(user, span_warning("The cross is cold and silent."))
		return
	var/input_text = input(user, "Speak to the Host:", "The Lady Hears")
	if(!input_text)
		return
	var/usedcolor = user.voice_color
	if(user.voicecolor_override)
		usedcolor = user.voicecolor_override
	user.whisper(input_text)
	if(length(input_text) > 100)
		input_text = "<small>[input_text]</small>"
	for(var/obj/item/clothing/neck/roguetown/psicross/inhumen/ashen/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor)

/obj/item/clothing/neck/roguetown/psicross/inhumen/ashen/MiddleClick(mob/user)
	. = ..()
	if(.)
		return
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("I cannot use this while restrained or incapacitated!"))
		return
	if(!is_ashen(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	listening = !listening
	speaking = !speaking
	to_chat(user, span_info("I [speaking ? "unmute" : "mute"] the cross."))

/obj/item/clothing/neck/roguetown/psicross/inhumen/ashen/pickup(mob/living/user)
	if(!is_ashen(user))
		listening = FALSE
		speaking = FALSE
	..()

/obj/item/clothing/neck/roguetown/psicross/inhumen/ashen/doStrip(mob/stripper, mob/owner)
	if(!is_ashen(stripper))
		listening = FALSE
		speaking = FALSE
	. = ..()

/obj/item/clothing/neck/roguetown/psicross/inhumen/ashen/proc/repeat_message(message, atom/A, tcolor, message_language)
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

/obj/item/clothing/neck/roguetown/psicross/inhumen/ashen/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
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
