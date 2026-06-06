
//////////////////////////
/// Portable-Stations ///
////////////////////////


/datum/artificer_recipe/portable
	i_type = "Portable Stations"
	hammers_per_item = 10
	skill_level = 3

/datum/artificer_recipe/portable/stove
	name = "Portable Stove (+1 Bronze Cog, +1 Tin Ingot)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/mobilestove
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/ingot/tin)

/datum/artificer_recipe/portable/smelter
	name = "Portable Smelter (+1 Coal)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/rogueore/coal = 1)
	created_item = /obj/item/contraption/smelter

/datum/artificer_recipe/portable/folding_alchcauldron
	name = "Folding Alchemical Cauldron (+1 Small Log, +Stone Pot, +Tin)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/reagent_containers/glass/bucket/pot/stone, /obj/item/ingot/tin)
	created_item = /obj/item/folding_table_stored/alchcauldron

/datum/artificer_recipe/portable/folding_alchstation_stored
	name = "Folding Alchemical Station (+2 Small Log, +Bottle, +Cog)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/reagent_containers/glass/bottle, /obj/item/roguegear/bronze)
	created_item = /obj/item/folding_table_stored/alchstation

/datum/artificer_recipe/portable/folding_table
	name = "Folding Table (+1 Small Log)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/folding_table_stored
	skill_level = 1
