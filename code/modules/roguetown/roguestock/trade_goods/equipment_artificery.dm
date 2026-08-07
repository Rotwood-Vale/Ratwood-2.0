// ============================================================================
// ARTIFICERY - GADGETS
// ============================================================================

/datum/trade_good/equipment/crafted/mess_kit
	id = TRADE_GOOD_MESS_KIT
	name = "mess kit"
	item_type = /obj/item/storage/gadget/messkit

// ============================================================================
// ARTIFICERY - PROSTHETICS
// ============================================================================

// ES prosthetics are bodypart items with no shared per-material base type, so these goods
// match via alt_item_types (any limb of the material). Iron/steel prosthetics don't exist
// in ES — the iron good matches ES's wooden limbs, and steel stays dead (not in any order).
/datum/trade_good/equipment/crafted/bronze_prosthetic
	id = TRADE_GOOD_BRONZE_PROSTHETIC
	name = "bronze prosthetic limb"
	item_type = /obj/item/bodypart/l_arm/prosthetic/bronzeleft // representative limb; also drives derived pricing
	alt_item_types = list(
		/obj/item/bodypart/r_arm/prosthetic/bronzeright,
		/obj/item/bodypart/l_leg/prosthetic/bronzeleft,
		/obj/item/bodypart/r_leg/prosthetic/bronzeright,
	)

/datum/trade_good/equipment/crafted/iron_prosthetic
	id = TRADE_GOOD_IRON_PROSTHETIC
	name = "wooden prosthetic limb"
	item_type = /obj/item/bodypart/l_arm/prosthetic/woodleft // representative limb; also drives derived pricing
	alt_item_types = list(
		/obj/item/bodypart/r_arm/prosthetic/woodright,
		/obj/item/bodypart/l_leg/prosthetic,
		/obj/item/bodypart/r_leg/prosthetic,
	)

/datum/trade_good/equipment/crafted/steel_prosthetic
	id = TRADE_GOOD_STEEL_PROSTHETIC
	name = "steel prosthetic"
	item_type = null // no steel prosthetic in ES; kept out of all order mixes

// ============================================================================
// ARTIFICERY - CONTRAPTIONS
// ============================================================================

/datum/trade_good/equipment/crafted/voltic_gauntlets
	id = TRADE_GOOD_VOLTIC_GAUNTLETS
	name = "voltic contraption gauntlets"
	item_type = /obj/item/clothing/gloves/roguetown/contraption/voltic

/datum/trade_good/equipment/crafted/artificed_halfplate
	id = TRADE_GOOD_ARTIFICED_HALFPLATE
	name = "artificed half-plate"
	item_type = null // plate/paalloy/artificer does not exist in ES
