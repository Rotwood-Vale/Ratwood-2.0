/obj/item/listeningdevice/inq
	name = "listener"
	desc = "An ever-attentive ear..."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "listenstone"
	dropshrink = 0.6
	gripped_intents = null
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	alpha = 255
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	grid_width = 32
	grid_height = 32
	var/label = null
	var/inqdesc = null
	var/hidden = FALSE
	layer = TURF_LAYER
	plane = WALL_PLANE
	var/active = FALSE
	var/datum/status_effect/bugged/effect

/obj/item/listeningdevice/inq/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		desc = inqdesc
	else
		desc = initial(desc)

/obj/item/listeningdevice/inq/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()
	inqdesc = "An ever-attentive ear... [span_notice("This ear hasn't been bent. It's unlabelled.")]"

/obj/item/listeningdevice/inq/Destroy()
	lose_hearing_sensitivity()
	return ..()

/obj/item/listeningdevice/inq/attack_self(mob/living/user)
	var/input = input(user, "SIX LETTERS", "BEND AN EAR")
	if(!input)
		label = null
		inqdesc = "An ever-attentive ear... [span_notice("This ear hasn't been bent. It's unlabelled.")]"
		desc = inqdesc
		return
	label = uppertext(trim(input, 7))
	inqdesc = "An ever-attentive ear... [span_notice("This ear's been bent. It's labelled as [label].")]"
	desc = inqdesc
	return

/obj/item/listeningdevice/inq/attack_right(mob/living/user)
	if(!hidden)
		alpha = 30
		name = "thing"
		desc = "What is that thing?.."
		hidden = TRUE
		return TRUE
	alpha = 255
	name = initial(name)
	desc = initial(desc)
	hidden = FALSE
	return TRUE
/* FINISH THIS AT YOUR OWN LEISURE. IT WON'T TAKE MUCH WORK. AT MOST YOU'LL BE ADDING DISCOVERY CHECKS ON EXAMINE AND THE ABILITY TO RIP OFF DISCOVERED LISTENERS. HAVE FUN! - YISCHE
/obj/item/listeningdevice/attack(mob/living/M, mob/living/user)
	if(!active)
		to_chat(user, span_warning("[src] is inactive.."))
		return FALSE
	
	to_chat(user, span_notice("I attach [src] to [M]."))
	effect = M.apply_status_effect(/datum/status_effect/bugged)
	effect.device = src
	forceMove(M)
	M.contents.Add(src)

	if(M.STAPER > user.STASPD)
		to_chat(M, span_hidden("I feel something brush against the back of my neck. It stings."))

	..()
*/
/obj/item/listeningdevice/inq/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/bug.ogg', 50, FALSE, -1)
	active = !active
	if(active)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(icon_state)
	to_chat(user, span_info("I [active ? "undeafen" : "deafen"] the Listener."))
	update_icon()
	return

/obj/item/listeningdevice/inq/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(!active)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	if(!raw_message)
		return
	if(length(raw_message) > 100)
		raw_message = "<small>[raw_message]</small>"
	for(var/obj/item/speakerinq/S in SSroguemachine.scomm_machines)
		S.name = label ? "#[label]" : "#NOTSET"
		S.repeat_message(raw_message, src, usedcolor, message_language)
		S.name = (S.fakename)

/*
	COURT AGENT LISTENING DEVICES
*/
/obj/item/listeningdevice/agent
	name = "listening pearl"
	desc = "A black pearl..."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "midnight_pearl"
	dropshrink = 0.6
	gripped_intents = null
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	alpha = 255
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	grid_width = 32
	grid_height = 32
	var/label = null 
	var/hidden = FALSE
	layer = TURF_LAYER
	plane = WALL_PLANE
	var/active = FALSE
	var/fulldesc = null

/obj/item/listeningdevice/agent/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_COURTAGENT))
		desc = fulldesc
	else
		desc = initial(desc)

/obj/item/listeningdevice/agent/Initialize()
	. = ..()
	become_hearing_sensitive()
	fulldesc = "A black pearl... [span_notice("This pearl hasn't been activated. It's unlabelled.")]"

/obj/item/listeningdevice/Destroy()
	lose_hearing_sensitivity()
	return ..()

/obj/item/listeningdevice/agent/attack_self(mob/living/user)
	var/input = input(user, "SIX LETTERS", "HEAR ALL SECRETS")
	if(!input)
		label = null
		fulldesc = "A black pearl... [span_notice("This pearl hasn't been activated. It's unlabelled.")]"
		desc = fulldesc
		return
	label = uppertext(trim(input, 7))
	fulldesc = "An black pearl... [span_notice("This pearl has been activated. It's labelled as [label].")]"
	desc = fulldesc
	return

/obj/item/listeningdevice/inq/attack_right(mob/living/user)
	if(!hidden)
		alpha = 30
		name = "thing"
		desc = "What is that thing?.."
		hidden = TRUE
		return TRUE
	alpha = 255
	name = initial(name)
	desc = initial(desc)
	hidden = FALSE
	return TRUE

/obj/item/listeningdevice/agent/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/bug.ogg', 50, FALSE, -1)
	active = !active
	if(active)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(icon_state)
	to_chat(user, span_info("I [active ? "undeafen" : "deafen"] the Pearl."))
	update_icon()
	return

/obj/item/listeningdevice/agent/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(!active)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	if(!raw_message)
		return
	if(length(raw_message) > 100)
		raw_message = "<small>[raw_message]</small>"
	for(var/obj/item/speaker/agent/S in SSroguemachine.scomm_machines)
		S.name = label ? "#[label]" : "#NOTSET"
		S.repeat_message(raw_message, src, usedcolor, message_language)
		S.name = (S.fakename)
