/obj/item/listeningdevice
	name = "窃听耳"
	desc = "一只永远在倾听的耳朵……"
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

/obj/item/listeningdevice/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		desc = inqdesc
	else
		desc = initial(desc)

/obj/item/listeningdevice/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()
	inqdesc = "一只永远在倾听的耳朵…… [span_notice("这只耳朵还没被掰弯。它没有标签。")]"

/obj/item/listeningdevice/Destroy()
	lose_hearing_sensitivity()
	return ..()

/obj/item/listeningdevice/attack_self(mob/living/user)
	var/input = input(user, "六个字符", "给耳朵做记号")
	if(!input)
		label = null
		inqdesc = "一只永远在倾听的耳朵…… [span_notice("这只耳朵还没被掰弯。它没有标签。")]"
		desc = inqdesc
		return
	label = uppertext(trim(input, 7))
	inqdesc = "一只永远在倾听的耳朵…… [span_notice("这只耳朵已经被掰弯了。它的标签是 [label]。")]"
	desc = inqdesc
	return

/obj/item/listeningdevice/attack_right(mob/living/user)
	if(!hidden)
		alpha = 30
		name = "东西"
		desc = "那是什么东西？.."
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
		to_chat(user, span_warning("[src]没有反应。"))
		return FALSE
	
	to_chat(user, span_notice("我把[src]装到了[M]身上。"))
	effect = M.apply_status_effect(/datum/status_effect/bugged)
	effect.device = src
	forceMove(M)
	M.contents.Add(src)

	if(M.STAPER > user.STASPD)
		to_chat(M, span_hidden("我感觉有什么掠过后颈，刺得发痛。"))

	..()
*/
/obj/item/listeningdevice/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/bug.ogg', 50, FALSE, -1)
	active = !active
	if(active)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(icon_state)
	to_chat(user, span_info("我将窃听耳[active ? "取消失聪" : "静聋"]了。"))
	update_icon()
	return

/obj/item/listeningdevice/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
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
