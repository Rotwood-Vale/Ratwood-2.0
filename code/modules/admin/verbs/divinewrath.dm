/client/proc/divine_wrath(mob/living/carbon/human/H)
	if(!holder || !check_rights(R_FUN))
		return

	if(!ishuman(H))
		to_chat(usr, span_warning("Target must be human!"))
		return

	var/list/curse_choices = list(
		"Curse of Astrata" = /datum/curse/astrata,
		"Curse of Noc" = /datum/curse/noc,
		"Curse of Dendor" = /datum/curse/dendor,
		"Curse of Abyssor" = /datum/curse/abyssor,
		"Curse of Ravox" = /datum/curse/ravox,
		"Curse of Necra" = /datum/curse/necra,
		"Curse of Xylix" = /datum/curse/xylix,
		"Curse of Pestra" = /datum/curse/pestra,
		"Curse of Malum" = /datum/curse/malum,
		"Curse of Eora" = /datum/curse/eora,
		"Curse of Zizo" = /datum/curse/zizo,
		"Curse of Graggar" = /datum/curse/graggar,
		"Curse of Matthios" = /datum/curse/matthios,
		"Curse of Baotha" = /datum/curse/baotha,
		)

	var/curse_pick = tgui_input_list(usr, "Choose a curse to apply or lift.", "Select Curse", curse_choices)
	if(!curse_pick || QDELETED(H))
		return

	var/curse_type = curse_choices[curse_pick]

	if(H.is_cursed(curse_type))
		H.remove_curse(curse_type)
		priority_announce("Gods have lifted [curse_pick] from [H.real_name]!", title = "DIVINE MERCY", sound = 'sound/misc/bell.ogg')
		message_admins("ADMIN DIVINE WRATH: ([ckey]) has lifted [curse_pick] from [H.real_name] ([H.ckey])")
		log_game("ADMIN DIVINE WRATH: ([ckey]) has lifted [curse_pick] from [H.real_name] ([H.ckey])")
		return

	if(length(H.curses) >= 1)
		to_chat(src, span_syndradio("[H.real_name] is already afflicted by another curse."))
		message_admins("ADMIN DIVINE WRATH: ([ckey]) has attempted to strike [H.real_name] ([H.ckey]) with [curse_pick]")
		log_game("ADMIN DIVINE WRATH: ([ckey]) has attempted to strike [H.real_name] ([H.ckey]) with [curse_pick]")
		return

	H.add_curse(curse_type)
	priority_announce("Gods have stricken [H.real_name] with [curse_pick]!", title = "DIVINE PUNISHMENT", sound = 'sound/misc/excomm.ogg')
	message_admins("ADMIN DIVINE WRATH: ([ckey]) has stricken [H.real_name] ([H.ckey]) with [curse_pick]")
	log_game("ADMIN DIVINE WRATH: ([ckey]) has stricken [H.real_name] ([H.ckey]) with [curse_pick]")
