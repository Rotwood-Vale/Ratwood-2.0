/obj/item/paper/carbon
	name = "复写纸"
	icon_state = "paper_stack"
	item_state = "paper"
	var/copied = FALSE
	var/iscopy = FALSE

/obj/item/paper/carbon/update_icon_state()
	if(iscopy)
		icon_state = "cpaper"
	else if(copied)
		icon_state = "paper"
	else
		icon_state = "paper_stack"
	if(info)
		icon_state = "[icon_state]_words"

/obj/item/paper/carbon/proc/removecopy(mob/living/user)
	if(!copied)
		var/obj/item/paper/carbon/C = src
		var/copycontents = C.info
		var/obj/item/paper/carbon/Copy = new /obj/item/paper/carbon(user.loc)

		if(info)
			copycontents = replacetext(copycontents, "<font face=\"[PEN_FONT]\" color=", "<font face=\"[PEN_FONT]\" nocolor=")
			copycontents = replacetext(copycontents, "<font face=\"[CRAYON_FONT]\" color=", "<font face=\"[CRAYON_FONT]\" nocolor=")
			Copy.info += copycontents
			Copy.info += "</font>"
			Copy.name = "副本 - [C.name]"
			Copy.fields = C.fields
			Copy.updateinfolinks()
		to_chat(user, span_notice("我撕下了这张复写副本！"))
		C.copied = TRUE
		Copy.iscopy = TRUE
		Copy.update_icon_state()
		C.update_icon_state()
		user.put_in_hands(Copy)
	else
		to_chat(user, span_notice("这张纸上已经没有更多复写副本了！"))

/obj/item/paper/carbon/attack_hand(mob/living/user)
	if(loc == user && user.is_holding(src))
		removecopy(user)
		return
	return ..()
