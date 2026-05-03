// Light Armor Pack. Only includes the "highest tier" plus a special package of budget armor.
// Pricing principles - Based on uhh sell price x 1.5 approx lol.

/datum/supply_pack/rogue/light_armor
	group = "Armor (Light)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/light_armor/padded_gambeson
	name = "Padded Gambeson"
	cost = 40 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)

/datum/supply_pack/rogue/light_armor/leather_gorget
	name = "Leather Gorget"
	cost = 20 // Base sellprice of 10
	contains = list(/obj/item/clothing/neck/roguetown/leather)

/datum/supply_pack/rogue/light_armor/leather_bracers
	name = "Hardened Leather Bracers"
	cost = 20 // Base sellprice of 10
	contains = list(/obj/item/clothing/wrists/roguetown/bracers/leather/heavy)

/datum/supply_pack/rogue/light_armor/heavy_leather_pants
	name = "Hardened Leather Pants"
	cost = 30 // Base sellprice of 20
	contains = list(/obj/item/clothing/under/roguetown/heavy_leather_pants)

/datum/supply_pack/rogue/light_armor/hide_armor
	name = "Hide Armor"
	cost = 30 // Base sellprice of 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/hide)

/datum/supply_pack/rogue/light_armor/heavy_leather_armor
	name = "Hardened Leather Armor"
	cost = 30 // Base sellprice of 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy)

/datum/supply_pack/rogue/light_armor/studded_leather_armor
	name = "Studded Leather Armor"
	cost = 40 // I added 5 to the base sellprice of 25 because it cost 1 ingot
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/studded)

/datum/supply_pack/rogue/light_armor/heavy_leather_coat
	name = "Hardened Leather Coat"
	cost = 35 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat)

/datum/supply_pack/rogue/light_armor/heavy_leather_jacket
	name = "Hardened Leather Jacket"
	cost = 35 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket)

/datum/supply_pack/rogue/light_armor/heavy_leather_gloves
	name = "Heavy Leather Gloves"
	cost = 20 // No one buying this lmao it costs 1 fur
	contains = list(/obj/item/clothing/gloves/roguetown/angle)

/datum/supply_pack/rogue/light_armor/heavy_padded_coif
	name = "Heavy Padded Coif"
	cost = 35 // Equivalent to a padded gambeson on the head, so pricier
	contains = list(/obj/item/clothing/neck/roguetown/coif/heavypadding)

/datum/supply_pack/rogue/light_armor/reinforced_hood
	name = "Reinforced Hood"
	cost = 40 //It's armour. Quite good, given layering, too. Someone else can adjust this. EDIT: I'm someone else. If it's such good armor, let's make it as expensive as the other good armor in its class, like the padded gambeson. Steel mask is probably better, you're buying this if you want swag.
	contains = list(
					/obj/item/clothing/head/roguetown/roguehood/reinforced,
				)

// Exotic import stuff goes here. Should probably be a little pricier than normal stuff. 2x average? Be sure to name the purchase option so it relates to the actual item, but also what slot it fills.

/datum/supply_pack/rogue/light_armor/import
	group = "Imported Armor (Light)"

/datum/supply_pack/rogue/light_armor/import/otavangambeson
	name = "Otavan Fencing Gambeson"
	cost = 60 // Base sellprice of 30
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan)

/datum/supply_pack/rogue/light_armor/import/otavanpants1
	name = "Otavan Heavy Leather Trousers"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan)

/datum/supply_pack/rogue/light_armor/import/otavanpants2
	name = "Otavan Fencing Trousers"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic)

/datum/supply_pack/rogue/light_armor/import/aavnicgambeson
	name = "Aavnic Fencing Gambeson"
	cost = 50 // Base sellprice of 30, doesn't cover legs so slightly cheaper
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter)

/datum/supply_pack/rogue/light_armor/import/caftan
	name = "Padded Caftan"
	cost = 60 // Base sellprice of 30
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah)

/datum/supply_pack/rogue/light_armor/import/kazenpants
	name = "Kazengunese Heavy Leather Trousers"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun)

/datum/supply_pack/rogue/light_armor/import/grenzhat
	name = "Grenzelhoftian Plume Hat"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/head/roguetown/grenzelhofthat)

/datum/supply_pack/rogue/light_armor/import/grenzhipshirt
	name = "Grenzelhoftian Hip Shirt"
	cost = 60 // Base sellprice of 30
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft)

/datum/supply_pack/rogue/light_armor/import/grenzpants
	name = "Grenzelhoftian Paumpers"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants)

/datum/supply_pack/rogue/light_armor/import/desertgambanormal
	name = "Desert Gambeson"
	cost = 45 // Base sellprice of 20
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/zyb)

/datum/supply_pack/rogue/light_armor/import/zybgambaheavy
	name = "Padded Desert Gambeson"
	cost = 60 // Base sellprice of 30
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb)

/datum/supply_pack/rogue/light_armor/import/naledigamba
	name = "Naledian Padded Gambeson"
	cost = 60 // Base sellprice of 30
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex)

/datum/supply_pack/rogue/light_armor/import/naleditrou
	name = "Naledian Hardened Leather Chaqchur (Pants)"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/trou/leather/pontifex)

/datum/supply_pack/rogue/light_armor/import/zybtrou
	name = "Baggy Hardened Leather Desert Pants"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/trou/leather/pontifex/zyb)

/datum/supply_pack/rogue/light_armor/import/gronnarmor
	name = "Gronnic Hardened Leather Armor"
	cost = 45 // Base sellprice of 20
	contains = list (/obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn)

/datum/supply_pack/rogue/light_armor/import/gronnpants
	name = "Nomad Hardened Leather Pants"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants)

/datum/supply_pack/rogue/light_armor/import/gronnpantsalt
	name = "Gronnic Leather Pants"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/trou/leather/gronn)

/datum/supply_pack/rogue/light_armor/import/gronnglovesleather
	name = "Gronnic Fur-lined Heavy Leather Gloves"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/gloves/roguetown/angle/gronn)
