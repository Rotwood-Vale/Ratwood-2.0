
///////////////
/// Armour ///
/////////////

/datum/artificer_recipe/equipment
	i_type = "Equipment"
	hammers_per_item = 8
	skill_level = 4

/datum/artificer_recipe/equipment/artificer_armor
	name = "Artificer Armour (+2 ancient alloy ingot, +2 Bronze gear)"
	required_item = /obj/item/ingot/gilbranze
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/ingot/gilbranze, /obj/item/roguegear/bronze, /obj/item/roguegear/bronze)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/ancient/artificer

/datum/artificer_recipe/equipment/voltic_gauntlet
	name = "Voltic Gauntlet (+1 Tin ingot, +2 Bronze gear, +1 cinnabar ore)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/roguegear/bronze, /obj/item/ingot/tin, /obj/item/rogueore/cinnabar)
	created_item = /obj/item/clothing/gloves/roguetown/contraption/voltic

/datum/artificer_recipe/equipment/steam_shield
	name = "Steam Shield (+1 wood plank, +2 Bronze gear, +2 bronze ingot)"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/roguegear/bronze, /obj/item/natural/wood/plank, /obj/item/ingot/bronze, /obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/shield/steam





// --------- WEAPON -----------

/datum/artificer_recipe/equipment/wooden_staff //Again, a bit silly, but is important
	name = "Wooden Staff (+1 Plank)"
	created_item = /obj/item/rogueweapon/woodstaff
	additional_items = list(/obj/item/natural/wood/plank = 1)
	hammers_per_item = 3

/datum/artificer_recipe/equipment/bow // easier recipe for bows
	name = "Wooden Bow (+1 Fiber) (+1 Plank)"
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	hammers_per_item = 3
	additional_items = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/fibers = 1)

/datum/artificer_recipe/equipment/training_sword
	name = "Wooden Sword (+1 Plank)"
	created_item = /obj/item/rogueweapon/mace/wsword
	additional_items = list(/obj/item/natural/wood/plank = 1)
	hammers_per_item = 3

/datum/artificer_recipe/equipment/training_dagger

	name = "Wooden Dagger (3x) (+1 Plank)"
	created_item = list(/obj/item/rogueweapon/huntingknife/idagger/wood,
						/obj/item/rogueweapon/huntingknife/idagger/wood,
						/obj/item/rogueweapon/huntingknife/idagger/wood
						)
	additional_items = list(/obj/item/natural/wood/plank = 1)
	hammers_per_item = 2

/datum/artificer_recipe/equipment/wooden_shield
	name = "Wooden Shield (+1 Plank)"
	created_item = /obj/item/rogueweapon/shield/wood/crafted
	additional_items = list(/obj/item/natural/wood/plank = 1)
	hammers_per_item = 6
	skill_level = 2

/obj/item/rogueweapon/shield/wood/crafted
	sellprice = 6

/datum/artificer_recipe/equipment/heater_shield
	name = "Heater Shield (+1 Cured Leather)"
	created_item = /obj/item/rogueweapon/shield/heater/crafted
	additional_items = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/hide/cured = 1)
	hammers_per_item = 6
	skill_level = 3

/obj/item/rogueweapon/shield/heater/crafted
	sellprice = 6


/// CROSSBOW

/datum/artificer_recipe/equipment/crossbow
	name = "Crossbow (+1 Steel) (+1 Fiber)"
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/fibers)
	hammers_per_item = 10
	skill_level = 4

/datum/artificer_recipe/equipment/slurbow
	name = "Slurbow (+1 Steel) (+1 Fiber) (+1 Wood Plank)"
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/fibers, /obj/item/natural/wood/plank)
	hammers_per_item = 10
	skill_level = 5
