// Regional or otherwise exclusive armor. NOT for Merc equipment (unless it is deemed so)
// Pricing Principles is based on vibes, but you don't want reskins worth /less/ than the originals.
// The Gronn stuff is all-in-one due to laziness, not as a standard.

/datum/supply_pack/rogue/armor_exotic
	group = "Armor (Exotic)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	no_name_quantity = TRUE

/datum/supply_pack/rogue/armor_exotic/hammerhold_pack_light
	name = "掠袭者皮甲套装（轻型）"
	cost = 125
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn,
		/obj/item/clothing/under/roguetown/trou/leather/gronn,
		/obj/item/clothing/gloves/roguetown/angle/gronn
		)

/datum/supply_pack/rogue/armor_exotic/hammerhold_pack_medium
	name = "拜林链甲套装（中型）"
	cost = 225
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel,
		/obj/item/clothing/suit/roguetown/armor/brigandine/gronn,
		/obj/item/clothing/gloves/roguetown/chain/gronn,
		/obj/item/clothing/under/roguetown/splintlegs/iron/gronn
		)

/datum/supply_pack/rogue/armor_exotic/hammerhold_pack_heavy
	name = "恩诺尔西板甲套装（重型）"
	cost = 400
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/bucket/gronn,
		/obj/item/clothing/suit/roguetown/armor/plate/iron/gronn,
		/obj/item/clothing/gloves/roguetown/plate/iron/gronn,
		/obj/item/clothing/under/roguetown/platelegs/iron/gronn,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron/gronn
		)
