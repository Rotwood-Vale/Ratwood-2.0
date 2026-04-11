/obj/item/clothing/shirt/toga
	slot_flags = ITEM_SLOT_SHIRT | ITEM_SLOT_ARMOR
	name = "toga"
	desc = "A pristine white toga of flowing linen."
	body_parts_covered = CHEST|GROIN
	flags_inv = HIDEBOOB|HIDECROTCH
	icon = 'modular_rmh/icons/clothing/valentyi/toga.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/valentyi/onmob/toga.dmi'
	icon_state = "toga"
	item_state = "toga"
	var/base_icon = "toga"
	var/changed_icon = "toga"
	var/alt_wear = FALSE
	nodismemsleeves = TRUE
	sleevetype = null
	sleeved = null

/obj/item/clothing/shirt/toga/attack_right(mob/user)
	switch(alt_wear)
		if(FALSE)
			name = "revealing toga"
			body_parts_covered = null
			icon_state = "[changed_icon]_alt"
			to_chat(usr, span_warning("Now wearing more revealing!"))
			alt_wear = TRUE
		if(TRUE)
			name = "toga"
			body_parts_covered = CHEST|GROIN|VITALS
			icon_state = "[changed_icon]"
			to_chat(usr, span_warning("Now wearing normally!"))
			alt_wear = FALSE
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()
		L.update_inv_shirt()

/obj/item/clothing/shirt/toga/equipped(mob/user, slot)
	. = ..()
	if(user.gender == FEMALE)
		icon_state = "[base_icon]fem"
		changed_icon = "[base_icon]fem"
	else
		icon_state = "[base_icon]"
		changed_icon = "[base_icon]"

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/toga
	name = "toga"
	result = list(/obj/item/clothing/shirt/toga,)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

//SUPPLY PACKS

/datum/supply_pack/rogue/wardrobe/suits/toga
	name = "Toga"
	cost = 10
	contains = list(
					/obj/item/clothing/shirt/toga,
				)

//LOADOUT

/datum/loadout_item/toga
	name = "Toga"
	path = /obj/item/clothing/shirt/toga
