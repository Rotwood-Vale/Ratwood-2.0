/obj/item/clothing/suit/roguetown/armor/leather/druid
	name = "druid armor"
	desc = "A carefully layered armor of cured leather, living oak bark, and woven leaves. Flexible yet resilient, it carries the quiet strength of the forest."

	icon = 'modular_rmh/icons/clothing/vladegeg/armor/druid.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/armor/onmob/druid.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/armor/onmob/helpers/druid_sleeves.dmi'

	icon_state = "druid"
	item_state = "druid"
	slot_flags = ITEM_SLOT_SHIRT | ITEM_SLOT_ARMOR
	salvage_result = /obj/item/natural/hide/cured

//CRAFTING

/datum/crafting_recipe/roguetown/leather/druid
	name = "druid armor"
	result = /obj/item/clothing/suit/roguetown/armor/leather/druid
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/hide/cured = 2)
	craftdiff = 2

//LOADOUT

/datum/loadout_item/druid
	name = "druid armor"
	path = /obj/item/clothing/suit/roguetown/armor/leather/druid
	triumph_cost = 3
