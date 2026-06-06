
//////////////
/// Rings ///
////////////


/datum/artificer_recipe/comms
	i_type = "Comms"
	hammers_per_item = 10
	skill_level = 5

/datum/artificer_recipe/comms/serfstone
	name = "Serf Stone (+1 amethyst, +1 Topar)"
	required_item = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegem/amethyst, /obj/item/roguegem/yellow) //using topar since the description calls it a "dull gem"
	created_item = /obj/item/scomstone/bad

/datum/artificer_recipe/comms/houndstone
	name = "Houndstone (+1 amethyst, +1 topar)"
	required_item = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegem/amethyst, /obj/item/roguegem/yellow)
	created_item = /obj/item/scomstone/bad/garrison

/datum/artificer_recipe/comms/scomstone
	name = "SCOM Stone (+1 amethyst, +1 gemerald)"
	required_item = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegem/amethyst, /obj/item/roguegem/green)
	created_item = /obj/item/scomstone

/datum/artificer_recipe/comms/emeraldchoker
	name = "Emerald Choker (+1 amethyst +Gold, +1 Gemerald)"
	required_item = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegem/amethyst, /obj/item/ingot/gold, /obj/item/roguegem/green)
	created_item = /obj/item/listenstone
