// Regional or otherwise exclusive armor. NOT for Merc equipment (unless it is deemed so)
// Pricing Principles is based on vibes, but you don't want reskins worth /less/ than the originals.
// The Gronn stuff is all-in-one due to laziness, not as a standard.

/datum/supply_pack/rogue/armor_exotic
	group = "Armor (Exotic)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	no_name_quantity = TRUE

/datum/supply_pack/rogue/armor_exotic/hammerhold_pack_light
	name = "Ravager Leather Set (Light)"
	cost = 125
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/hammerhold,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/hammerhold,
		/obj/item/clothing/under/roguetown/trou/leather/hammerhold,
		/obj/item/clothing/gloves/roguetown/angle/hammerhold
		)

/datum/supply_pack/rogue/armor_exotic/hammerhold_pack_medium
	name = "Byrine Chain Set (Medium)"
	cost = 225
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/hammerhold/ownel,
		/obj/item/clothing/suit/roguetown/armor/brigandine/hammerhold,
		/obj/item/clothing/gloves/roguetown/chain/hammerhold,
		/obj/item/clothing/under/roguetown/splintlegs/iron/hammerhold
		)

/datum/supply_pack/rogue/armor_exotic/hammerhold_pack_heavy
	name = "Norsii Plate Set (Heavy)"
	cost = 400
	contains = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/bucket/hammerhold,
		/obj/item/clothing/suit/roguetown/armor/plate/iron/hammerhold,
		/obj/item/clothing/gloves/roguetown/plate/iron/hammerhold,
		/obj/item/clothing/under/roguetown/platelegs/iron/hammerhold,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron/hammerhold
		)
