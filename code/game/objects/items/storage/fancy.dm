/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 */

/obj/item/storage/fancy
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	desc = ""
	resistance_flags = FLAMMABLE
	var/icon_type = "donut"
	var/spawn_type = null
	var/fancy_open = FALSE

/obj/item/storage/fancy/PopulateContents()
	. = ..()
	if(!spawn_type)
		return
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_FILL_TYPE, spawn_type)

/obj/item/storage/fancy/update_icon()
	if(fancy_open)
		icon_state = "[icon_type]box[contents.len]"
	else
		icon_state = "[icon_type]box"

/obj/item/storage/fancy/examine(mob/user)
	. = ..()
	if(fancy_open)
		if(length(contents) == 1)
			. += "There is one [icon_type] left."
		else
			. += "There are [contents.len <= 0 ? "no" : "[contents.len]"] [icon_type]s left."

/obj/item/storage/fancy/attack_self(mob/user)
	fancy_open = !fancy_open
	update_icon()
	. = ..()

/obj/item/storage/fancy/Exited()
	. = ..()
	fancy_open = TRUE
	update_icon()

/obj/item/storage/fancy/Entered()
	. = ..()
	fancy_open = TRUE
	update_icon()


