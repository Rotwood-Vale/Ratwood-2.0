/obj/item/storage/book
	name = "镂空书"
	desc = ""
	icon = 'icons/obj/library.dmi'
	icon_state ="book"
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE
	var/title = "书"

/obj/item/storage/book/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1

/obj/item/storage/book/attack_self(mob/user)
	to_chat(user, "<span class='notice'>[title]的书页已经被挖空了！</span>")
