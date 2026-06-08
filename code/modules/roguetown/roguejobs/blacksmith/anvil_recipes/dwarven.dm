// Dwarven armor recipes - only visible and usable by dwarves (req_trait = TRAIT_DWARF_REPAIR)

/datum/anvil_recipe/armor/dwarven
	abstract_type = /datum/anvil_recipe/armor/dwarven
	appro_skill = /datum/skill/craft/armorsmithing
	i_type = "Armor"
	req_bar = /obj/item/ingot/steel
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	req_trait = TRAIT_DWARF_REPAIR

/datum/anvil_recipe/armor/dwarven/plate
	name = "Grudgebearer Dwarven Plate (+2 Steel, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven

/datum/anvil_recipe/armor/dwarven/apron
	name = "Grudgebearer Splint Apron (+2 Steel)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/smith

/datum/anvil_recipe/armor/dwarven/helm
	name = "Dwarven Helm (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven

/datum/anvil_recipe/armor/dwarven/helm/smith
	name = "Dwarven Smith Helm (+1 Steel)"
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith

/datum/anvil_recipe/armor/dwarven/gauntlets
	name = "Dwarven Gauntlets (+1 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/gloves/roguetown/plate/dwarven

/datum/anvil_recipe/armor/dwarven/boots
	name = "Dwarven Boots (+1 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/dwarven
