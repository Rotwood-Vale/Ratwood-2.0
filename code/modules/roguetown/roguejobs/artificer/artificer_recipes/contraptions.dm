
/////////////////////
/// Contraptions ///
///////////////////


/datum/artificer_recipe/contraptions
	i_type = "Contraptions"
	hammers_per_item = 10
	skill_level = 4

/datum/artificer_recipe/contraptions/autoshears
	name = "Auto Shears (+1 Bronze, +1 Bronze Cog)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/roguegear/bronze)
	created_item = /obj/item/contraption/shears

/datum/artificer_recipe/contraptions/drill
	name = "Clockwork Drill (+1 iron) (+1 Metal Gear) (+1 Wooden Plank)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/iron, /obj/item/roguegear/bronze, /obj/item/natural/wood/plank)
	created_item = /obj/item/contraption/pick/drill

/datum/artificer_recipe/contraptions/coolingbackpack
	name = "Cooling Backpack (+Cog, +Backpack)" // why are these recipes capitalized differently than every other crafting recipe my ocddddddddddd
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/storage/backpack/rogue/artibackpack
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/storage/backpack/rogue/backpack)

/datum/artificer_recipe/contraptions/cursed_collar
	name = "True Cursed Collar (+1 Bronze Cog, +1 Essence of Wilderness)"
	required_item = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/natural/cured/essence)
	created_item = /obj/item/clothing/neck/roguetown/cursed_collar
	hammers_per_item = 14
	skill_level = 5

/datum/artificer_recipe/contraptions/grappler
	name = "Grappler (+1 Iron Pick, +1 Chain, +2 Cog)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/grapplinghook
	additional_items = list(/obj/item/rogueweapon/pick, /obj/item/roguegear/bronze, /obj/item/roguegear/bronze, /obj/item/rope/chain)

/datum/artificer_recipe/contraptions/lockimprover
	name = "Lock Improver (1 bronze, +1 cog))"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/roguegear/bronze)
	created_item = /obj/item/contraption/lock_imprinter

/datum/artificer_recipe/contraptions/orestore
	name = "Mechanized Ore Bag, Bronze (+1 sac, +1 cog)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/storage/hip/orestore/bronze
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/storage/roguebag)

/datum/artificer_recipe/contraptions/mess_kit
	name = "Mess Kit (+2 Tin)"  // reduced cost using tin/pewter
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/tin, /obj/item/ingot/tin)
	created_item = /obj/item/storage/gadget/messkit

/datum/artificer_recipe/contraptions/metalizer
	name = "Wood Metalizer (+2 cog)"
	required_item = /obj/item/ingot/bronze
	additional_items = list( /obj/item/roguegear/bronze, /obj/item/roguegear/bronze)
	created_item = /obj/item/contraption/wood_metalizer

/datum/artificer_recipe/contraptions/waterpurifier
	name = "Self-Purifying Waterskin (+Waterskin)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/reagent_containers/glass/bottle/waterskin/purifier
	additional_items = list(/obj/item/reagent_containers/glass/bottle/waterskin)
