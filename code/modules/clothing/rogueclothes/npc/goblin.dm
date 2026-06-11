/obj/item/clothing/suit/roguetown/armor/plate/half/iron/goblin
	name = "哥布林板甲"
	icon_state = "plate_armor_item"
	item_state = "plate_armor"
	icon = 'icons/roguetown/mob/monster/goblins.dmi'
	smeltresult = /obj/item/ingot/iron
	allowed_race = list(/datum/species/goblin, /datum/species/goblin/hell, /datum/species/goblin/cave, /datum/species/goblin/sea, /datum/species/goblin/moon)
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	sellprice = 0

/obj/item/clothing/suit/roguetown/armor/leather/goblin
	name = "哥布林皮甲"
	icon_state = "leather_armor_item"
	item_state = "leather_armor"
	icon = 'icons/roguetown/mob/monster/goblins.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	allowed_race = list(/datum/species/goblin, /datum/species/goblin/hell, /datum/species/goblin/cave, /datum/species/goblin/sea, /datum/species/goblin/moon)
	sellprice = 0

/obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
	name = "哥布林皮裙"
	icon_state = "cloth_armor"
	item_state = "cloth_armor"
	icon = 'icons/roguetown/mob/monster/goblins.dmi'
	allowed_race = list(/datum/species/goblin, /datum/species/goblin/hell, /datum/species/goblin/cave, /datum/species/goblin/sea, /datum/species/goblin/moon)
	body_parts_covered = GROIN
	armor = null
	sellprice = 0

/obj/item/clothing/head/roguetown/helmet/leather/goblin
	name = "哥布林皮盔"
	icon_state = "leather_helm_item"
	item_state = "leather_helm"
	icon = 'icons/roguetown/mob/monster/goblins.dmi'
	allowed_race = list(/datum/species/goblin, /datum/species/goblin/hell, /datum/species/goblin/cave, /datum/species/goblin/sea, /datum/species/goblin/moon)
	sellprice = 0
	dropshrink = null

/obj/item/clothing/head/roguetown/helmet/goblin
	name = "哥布林头盔"
	icon_state = "plate_helm_item"
	item_state = "plate_helm"
	icon = 'icons/roguetown/mob/monster/goblins.dmi'
	allowed_race = list(/datum/species/goblin, /datum/species/goblin/hell, /datum/species/goblin/cave, /datum/species/goblin/sea, /datum/species/goblin/moon)
	body_parts_covered = HEAD|EARS|HAIR|EYES
	sellprice = 0
	smeltresult = /obj/item/ingot/iron
	dropshrink = null
