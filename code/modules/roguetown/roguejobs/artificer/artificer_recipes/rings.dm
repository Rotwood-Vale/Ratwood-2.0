/datum/artificer_recipe/comms
	i_type = "Comms"
	hammers_per_item = 10
	skill_level = 5


//////////////
/// Rings ///
////////////


/datum/artificer_recipe/comms/serfstone
	name = "Serf Stone (+1 Topar)"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/roguegem/yellow) //using topar since the description calls it a "dull gem"
	created_item = /obj/item/scomstone/bad

/datum/artificer_recipe/comms/scomstone
	name = "SCOM Stone (+1 Saffira)"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/roguegem/violet)
	created_item = /obj/item/scomstone

/datum/artificer_recipe/comms/emeraldchoker
	name = "Emerald Choker (+1 Gold Ingot, +1 Gemerald)"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/gold, /obj/item/roguegem/green)
	created_item = /obj/item/listenstone

/datum/artificer_recipe/comms/houndstone
	name = "Houndstone (+1 Rontz)"
	required_item = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegem/ruby)
	created_item = /obj/item/scomstone/bad/garrison
