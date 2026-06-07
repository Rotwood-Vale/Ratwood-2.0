/////////////////////////////
/// ARTIFICER COMPONENTS ///
///////////////////////////


/datum/artificer_recipe/components
	i_type = "Components"
	hammers_per_item = 10
	skill_level = 1

/datum/artificer_recipe/components/wood/cog
	name = "Wooden Cog"
	required_item = /obj/item/natural/wood/plank
	created_item = /obj/item/roguegear/wood/basic
	hammers_per_item = 5

/datum/artificer_recipe/components/wood/cog/reliable
	name = "Reliable Wooden Cog (+1 Essence of Lumber)"
	created_item = /obj/item/roguegear/wood/reliable
	additional_items = list(/obj/item/grown/log/tree/small/essence = 1)
	hammers_per_item = 10
	skill_level = 2

/datum/artificer_recipe/components/wood/cog/unstable
	name = "Unstable Wooden Cog (+1 Essence of Wilderness)"
	created_item = /obj/item/roguegear/wood/unstable
	additional_items = list(/obj/item/natural/cured/essence = 1)
	hammers_per_item = 10
	skill_level = 3

/datum/artificer_recipe/components/bronze/cog
	name = "Bronze Cog (x2)"
	required_item = /obj/item/ingot/bronze
	created_item = list(/obj/item/roguegear/bronze, /obj/item/roguegear/bronze)
	skill_level = 3


/datum/artificer_recipe/components/chains
	name = "Iron Chain"
	required_item = /obj/item/ingot/iron
	created_item = /obj/item/rope/chain

/datum/artificer_recipe/components/jingle_bells
	name = "Jingling Bells"
	required_item = /obj/item/ingot/iron
	created_item = list(/obj/item/jingle_bells, /obj/item/jingle_bells, /obj/item/jingle_bells, /obj/item/jingle_bells, /obj/item/jingle_bells)

/datum/artificer_recipe/components/nails
	name = "Nails (x8)"
	required_item = /obj/item/ingot/tin
	created_item = list(/obj/item/construction/nail,
						/obj/item/construction/nail,
						/obj/item/construction/nail,
						/obj/item/construction/nail,
						/obj/item/construction/nail,
						/obj/item/construction/nail,
						/obj/item/construction/nail,
						/obj/item/construction/nail)
