// INQUISITION SCOM RING
// This is effectively almost the same as the bandit ring. It tastes the blood of the user to ensure they are a member of the inquisition, as to not make it too spammable like an ss13 radio. In exchange, non inquisition cannot send messages on it.
// It is supposed to be hush-hush that the inquisition has scomstones, which is why they appear as regular signet rings. (This is also a convenient excuse to re-use sprites.)
// is a subtype of the signet ring rather than the matthian scomstone purely for tallowpot stuff
/obj/item/clothing/ring/signet/silver/inqscomm
	desc = "The order of Saint Malum was tasked with coming up with a way for the Orthodoxy to communicate with each other, while still being able to seal missives with tallow. After three yils of restless toil, they came up with this marvel of otavan technology. May your communications endure.\n \
	There is a button on the side. It urges you to press it."
	slot_flags = ITEM_SLOT_RING|ITEM_SLOT_GLOVES
	muteinmouth = TRUE
	var/listening = TRUE
	var/speaking = TRUE
	sellprice = 150

/obj/item/clothing/ring/signet/silver/inqscomm/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()
	update_icon()
	SSroguemachine.scomm_machines += src

/obj/item/clothing/ring/signet/silver/inqscomm/attack_right(mob/living/carbon/human/user)
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("I cannot use this while restrained or incapacitated!"))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	to_chat(user, span_notice("I press a button on the side of the ring..."))
	if(!do_after(user, 1 SECONDS, FALSE, null, FALSE))
		to_chat(user, span_warning("The ring must properly taste my blood to send my message."))
		return
	user.set_blood_volume(max(user.get_blood_volume()-45, 0))
	user.fullscreen_redflash("redflash1")
	to_chat(user, span_warning("The ring pricks my finger!"))
	if(!HAS_TRAIT(user, TRAIT_INQUISITION) && !HAS_TRAIT(user, TRAIT_SCOMGNET_AUTHORIZED))
		src.say("UNAUTHORIZED BLOOD!")
		playsound(src, 'sound/items/indexer_cursed.ogg', 50, FALSE, -1)
		return
	
	var/input_text = input(user, "Enter your message:", "Message")
	if(input_text)
		var/usedcolor = user.voice_color
		if(user.voicecolor_override)
			usedcolor = user.voicecolor_override
		user.whisper(input_text)
		if(length(input_text) > 100)
			input_text = "<small>[input_text]</small>"
		for(var/obj/item/clothing/ring/signet/silver/inqscomm/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src, usedcolor)

/obj/item/clothing/ring/signet/silver/inqscomm/MiddleClick(mob/user)
	if(.)
		return
	if(user.restrained() || user.incapacitated())
		to_chat(user, span_warning("I cannot use this while restrained or incapacitated!"))
		return
	if(!HAS_TRAIT(user, TRAIT_INQUISITION) && !HAS_TRAIT(user, TRAIT_SCOMGNET_AUTHORIZED))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	listening = !listening
	speaking = !speaking
	to_chat(user, span_info("I [speaking ? "unmute" : "mute"] the SCOMgnet ring."))

/obj/item/clothing/ring/signet/silver/inqscomm/pickup(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_INQUISITION) && !HAS_TRAIT(user, TRAIT_SCOMGNET_AUTHORIZED))
		listening = FALSE
		speaking = FALSE
	..()

/obj/item/clothing/ring/signet/silver/inqscomm/examine(mob/user)
	if(HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_SCOMGNET_AUTHORIZED))
		desc = "The order of Saint Malum was tasked with coming up with a way for the Orthodoxy to communicate with each other, while still being able to seal missives with tallow. After three yils of restless toil, they came up with this marvel of otavan technology. May your communications endure.\n \
		There is a button on the side. It urges you to press it."
	else
		desc = "A ring of blessed silver, bearing the Archbishop's symbol. By dipping it in melted tallow, it can seal writs of religious importance."
	. = ..()


/obj/item/clothing/ring/signet/silver/inqscomm/doStrip(mob/stripper, mob/owner)
	if(!HAS_TRAIT(stripper, TRAIT_INQUISITION) && !HAS_TRAIT(stripper, TRAIT_SCOMGNET_AUTHORIZED))
		listening = FALSE
		speaking = FALSE
	. = ..()

/obj/item/clothing/ring/signet/silver/inqscomm/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(!HAS_TRAIT(user, TRAIT_PURITAN))
		return
	if(HAS_TRAIT(target, TRAIT_INQUISITION) || HAS_TRAIT(target, TRAIT_SCOMGNET_AUTHORIZED))
		return
	if(target.wear_ring)
		to_chat(user, span_warning("[target]'s ring finger must be free!"))
		return
	user.visible_message(span_cult("[user] presses twice on the side of the ring. It bites into their flesh, and blood wells from the wound..."))
	if(!do_after(user, 5 SECONDS) || target.wear_ring)
		return
	user.set_blood_volume(max(user.get_blood_volume()-45, 0))
	user.fullscreen_redflash("redflash2")
	if(!do_after(user, 5 SECONDS) || target.wear_ring)
		return
	user.visible_message(span_cult("[user] slips the bloodied ring onto [target]'s finger, pressing twice on it once more. The ring partakes of [target]'s blood, mixing with [user]'s..."))
	target.fullscreen_redflash("redflash2")
	target.set_blood_volume(max(target.get_blood_volume()-45, 0))
	ADD_TRAIT(target, TRAIT_SCOMGNET_AUTHORIZED, TRAIT_GENERIC)
	src.listening = TRUE
	src.speaking = TRUE
	target.equip_to_slot(src, SLOT_RING) // has to be unsafe otherwise won't work on unconscious people... should be fine since i already check if ring is free..?

/obj/item/clothing/ring/signet/silver/inqscomm/Destroy()
	lose_hearing_sensitivity()
	SSroguemachine.scomm_machines -= src
	return ..()

/obj/item/clothing/ring/signet/silver/inqscomm/proc/repeat_message(message, atom/A, tcolor, message_language)
	if(A == src)
		return
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, 'sound/vo/mobs/rat/rat_life.ogg', 50, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null

/obj/item/clothing/ring/signet/silver/inqscomm/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
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

/obj/item/clothing/ring/signet/silver/inqscomm/attack_self(mob/user) // is attack self as opposed to attack right.
	. = ..()
	if(tallowed)
		if(alert(user, "SCRAPE THE TALLOW OFF?", "SIGNET RING", "YES", "NO") != "NO")
			tallowed = FALSE
			update_icon()

/obj/item/clothing/ring/signet/silver/inqscomm/g
	name = "gold signet ring"
	icon_state = "signet"
	sellprice = 195
	is_silver = FALSE

/obj/item/clothing/ring/signet/silver/inqscomm/g/examine(mob/user)
	if(HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_SCOMGNET_AUTHORIZED))
		desc = "The order of Saint Malum was tasked with coming up with a way for the Orthodoxy to communicate with each other, while still being able to seal missives with tallow. After three yils of restless toil, they came up with this marvel of otavan technology. May your communications endure.\n \
		There is a button on the side. It urges you to press it."
	else
		desc = "A ring of opulent gold, bearing the symbol of Psydon. By dipping it in melted tallow, it can seal writs of religious importance - a matter better known to the Inquisition, rather than the Church or Crown."
	. = ..()
