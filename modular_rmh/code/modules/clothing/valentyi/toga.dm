/obj/item/clothing/suit/roguetown/shirt/dress/toga
	name = "托加袍"
	desc = "一件洁白无瑕、以飘逸亚麻制成的托加袍。"
	body_parts_covered = CHEST|GROIN
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

/obj/item/clothing/suit/roguetown/shirt/dress/toga/attack_right(mob/user)
	switch(alt_wear)
		if(FALSE)
			name = "暴露式托加袍"
			body_parts_covered = null
			icon_state = "[changed_icon]_alt"
			to_chat(usr, span_warning("当前穿法更加暴露！"))
			alt_wear = TRUE
		if(TRUE)
			name = "托加袍"
			body_parts_covered = CHEST|GROIN|VITALS
			icon_state = "[changed_icon]"
			to_chat(usr, span_warning("当前恢复为正常穿法！"))
			alt_wear = FALSE
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()
		L.update_inv_shirt()

/obj/item/clothing/suit/roguetown/shirt/dress/toga/equipped(mob/user, slot)
	. = ..()
	if(user.gender == FEMALE)
		icon_state = "[base_icon]fem"
		changed_icon = "[base_icon]fem"
	else
		icon_state = "[base_icon]"
		changed_icon = "[base_icon]"

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/toga
	name = "托加袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/toga,)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

//SUPPLY PACKS

/datum/supply_pack/rogue/wardrobe/suits/toga
	name = "托加袍"
	cost = 10
	contains = list(
					/obj/item/clothing/suit/roguetown/shirt/dress/toga,
				)

//LOADOUT

/datum/loadout_item/toga
	name = "托加袍"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/toga
