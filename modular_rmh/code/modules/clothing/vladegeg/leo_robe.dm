/obj/item/clothing/suit/roguetown/shirt/leo_robe
	slot_flags = ITEM_SLOT_SHIRT | ITEM_SLOT_ARMOR
	name = "leopard robe"
	desc = "An exquisite silky robe with a leopard pattern."
	body_parts_covered = CHEST|GROIN|VITALS
	icon = 'modular_rmh/icons/clothing/vladegeg/tig.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/tig.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/tig_sleeves.dmi'
	sleevetype = "armor"
	icon_state = "tig"
	item_state = "tig"
	nodismemsleeves = TRUE
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE

/obj/item/clothing/suit/roguetown/shirt/leo_robe/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "tig_open"
			flags_inv = HIDEBOOB
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_armor()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/leo_robe/leopard
	color = "#d88a32ff"

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/leo_robe
	name = "leopard robe"
	result = list(/obj/item/clothing/suit/roguetown/shirt/leo_robe)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 25

//LOADOUT

/datum/loadout_item/leo_robe
	name = "leopard robe"
	path = /obj/item/clothing/suit/roguetown/shirt/leo_robe

/datum/loadout_item/leo_robe_leopard
	name = "leopard robe (leopard colored)"
	path = /obj/item/clothing/suit/roguetown/shirt/leo_robe/leopard
