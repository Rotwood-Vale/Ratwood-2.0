/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|GROIN
	icon = 'modular_hearthstone/icons/obj/items/clothes/dress.dmi'
	mob_overlay_icon = 'modular_hearthstone/icons/obj/items/clothes/on_mob/dress.dmi'
	name = "strapless dress"
	desc = "It barely covers anything at all!"
	flags_inv = HIDEBOOB|HIDECROTCH
	icon_state = "strapless"
	sleevetype = null
	sleeved = null

//COLORS

/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/blue
	color = CLOTHING_BLUE

/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/purple
	color = "#664357"

/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/red
	color = "#6F0000"

/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/random/Initialize()
	color = pick(CLOTHING_BLACK, CLOTHING_BLUE, "#664357", "#6F0000")
	..()

/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/alt
	mob_overlay_icon = 'modular_hearthstone/icons/obj/items/clothes/on_mob/dress.dmi'
	name = "strapless dress"
	desc = "It barely covers anything at all!"
	flags_inv = HIDEBOOB|HIDECROTCH
	icon_state = "strapless2"
	icon = 'modular_hearthstone/icons/obj/items/clothes/dress.dmi'
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

//SUPPLY

/datum/supply_pack/rogue/wardrobe/suits/strapless_dress //just paint them yourself ffs
	name = "Strapless Dresses"
	cost = 10
	contains = list(
					/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless,
				)

/datum/supply_pack/rogue/wardrobe/suits/strapless_dress_alt
	name = "Alternative Strapless Dresses"
	cost = 10
	contains = list(
					/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/alt,
				)
