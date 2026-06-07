
///////////////////
/// Explosives ///
/////////////////


/datum/artificer_recipe/explosives
	i_type = "Explosives"
	hammers_per_item = 10
	skill_level = 3

/datum/artificer_recipe/explosives/tntbomb
	name = "Gun powder sticks"
	required_item = /obj/item/rogueore/coal
	created_item = list(/obj/item/tntstick, /obj/item/tntstick)
	additional_items = list(/obj/item/paper/scroll, /obj/item/paper/scroll,
							/obj/item/alch/coaldust, /obj/item/alch/coaldust,
							/obj/item/alch/firedust, /obj/item/alch/firedust)

/datum/artificer_recipe/explosives/satchelbomb
	name = "Gun powder satchel"
	required_item = /obj/item/storage/backpack/rogue/satchel
	created_item = /obj/item/satchel_bomb
	additional_items = list(/obj/item/tntstick, /obj/item/tntstick, /obj/item/tntstick)
	skill_level = 4


///////////////////////////
/// Gas-Belcher-Shells ///
/////////////////////////


/datum/artificer_recipe/explosives/smokebomb
	name = "gas belcher shells (x3) (+Cog)"
	required_item = /obj/item/ingot/bronze
	created_item = list(/obj/item/smokeshell, /obj/item/smokeshell, /obj/item/smokeshell)
	additional_items = list(/obj/item/roguegear/bronze)
