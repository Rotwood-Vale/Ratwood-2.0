// Dwarven armor recipes - only visible and usable by dwarves (req_trait = TRAIT_DWARF_REPAIR)

/datum/anvil_recipe/armor/dwarven
	abstract_type = /datum/anvil_recipe/armor/dwarven
	appro_skill = /datum/skill/craft/armorsmithing
	i_type = "Armor"
	req_bar = /obj/item/ingot/steel
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	req_trait = TRAIT_DWARF_REPAIR

/datum/anvil_recipe/armor/dwarven/plate
	name = "Grudgebearer Dwarven Plate (+3 Steel, +1 Bronze, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven

/datum/anvil_recipe/armor/dwarven/apron
	name = "Grudgebearer Splint Apron (+3 Steel, +1 Bronze)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/smith

/datum/anvil_recipe/armor/dwarven/helm
	name = "Dwarven Helm (+2 Steel, +1 Bronze)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven

/datum/anvil_recipe/armor/dwarven/helm/smith
	name = "Dwarven Smith Helm (+1 Steel, +1 Bronze)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith

/datum/anvil_recipe/armor/dwarven/gauntlets
	name = "Dwarven Gauntlets (+1 Steel, +1 Bronze, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/gloves/roguetown/plate/dwarven

/datum/anvil_recipe/armor/dwarven/boots
	name = "Dwarven Boots (+1 Steel, +1 Bronze, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/dwarven

// Dwarven weapon recipes - gated by TRAIT_DWARF_REPAIR like the armor

/datum/anvil_recipe/weapons/dwarven
	abstract_type = /datum/anvil_recipe/weapons/dwarven
	req_bar = /obj/item/ingot/steel
	craftdiff = SKILL_LEVEL_MASTER
	req_trait = TRAIT_DWARF_REPAIR

/datum/anvil_recipe/weapons/dwarven/maul
	name = "Dwarvish Maul (+4 Steel, +1 Bronze)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/mace/maul/steel

/datum/anvil_recipe/weapons/dwarven/spikedmaul
	name = "Spiked Maul (+3 Steel, +1 Bronze)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/mace/maul/spiked
