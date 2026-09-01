// Light Armor Pack. Only includes the "highest tier" plus a special package of budget armor.
// Pricing principles - Based on uhh sell price x 1.5 approx lol.

/datum/supply_pack/rogue/light_armor
	group = "Armor (Light)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/light_armor/rough_headband
	name = "Headband, Roughspun"
	cost = 25 // 2 cloth + 5 fiber, added 7 for SF pricing
	contains = list(/obj/item/clothing/head/roguetown/headband/monk/barbarian)

/datum/supply_pack/rogue/light_armor/padded_headband
	name = "Headband, Padded"
	cost = 35 // 4 cloth + 4 fiber, added 10 for SF pricing
	contains = list(/obj/item/clothing/head/roguetown/headband/monk)

/datum/supply_pack/rogue/light_armor/padded_wrappings
	name = "Arm Wrappings, Padded"
	cost = 35 // 4 cloth + 4 fiber, same recipe cost as the padded headband
	contains = list(/obj/item/clothing/wrists/roguetown/bracers/cloth/monk)

/datum/supply_pack/rogue/light_armor/arming_cap
	name = "Arming Cap"
	cost = 20 // 1 cloth + 3 fiber, ditto
	contains = list(/obj/item/clothing/head/roguetown/paddedcap)

/datum/supply_pack/rogue/light_armor/padded_arming_cap
	name = "Arming Cap, Padded"
	cost = 28 // 2 cloth + 5 fiber, ditto
	contains = list(/obj/item/clothing/head/roguetown/paddedcap/heavy)

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

/datum/supply_pack/rogue/light_armor/paddedcoif
	name = "Padded Coif"
	cost = 26 // ditto
	contains = list(/obj/item/clothing/neck/roguetown/coif/padded)

/datum/supply_pack/rogue/light_armor/lightgambeson
	name = "Gambeson, Light"
	cost = 20 // these are actually really easy to make, and have far worse protection and integ than other gambersons.
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/light)

/datum/supply_pack/rogue/light_armor/lightgambesonskirt
	name = "Gambesoned Kilt, Light"
	cost = 18
	contains = list(/obj/item/clothing/under/roguetown/skirt/gambeson/light)

/datum/supply_pack/rogue/light_armor/paddedchausses
	name = "Chausses, Padded"
	cost = 18
	contains = list(/obj/item/clothing/under/roguetown/tights/clothlegs)

/datum/supply_pack/rogue/light_armor/heavypaddedchausses
	name = "Chausses, Heavy Padded"
	cost = 40
	contains = list(/obj/item/clothing/under/roguetown/tights/clothlegs/heavy)

/datum/supply_pack/rogue/light_armor/paddedmittens
	name = "Mittens, Padded"
	cost = 15
	contains = list(/obj/item/clothing/gloves/roguetown/cloth)

/datum/supply_pack/rogue/light_armor/heavypaddedmittens
	name = "Mittens, Heavy"
	cost = 30
	contains = list(/obj/item/clothing/gloves/roguetown/cloth/heavy)

/datum/supply_pack/rogue/light_armor/light_arming_jacket
	name = "Arming Jacket, Light"
	cost = 28 // gamberson equiv that trades leg protection to be cheaper.
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/lord/light)

/datum/supply_pack/rogue/light_armor/gambeson
	name = "Gambeson"
	cost = 32 // more expensive than clothes but not by a whole lot
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson)

/datum/supply_pack/rogue/light_armor/gambeson_skirt
	name = "Gambesoned Kilt"
	cost = 28
	contains = list(/obj/item/clothing/under/roguetown/skirt/gambeson)

/datum/supply_pack/rogue/light_armor/arming_jacket
	name = "Arming Jacket"
	cost = 40 // gamberson equiv that trades leg protection and a third more price for 50 more integ (300 vs 250). Or padded gamberson that trades leg protection for being a third cheaper, to look at it another way.
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/lord)

/datum/supply_pack/rogue/light_armor/padded_gambeson
	name = "Gambeson, Padded"
	cost = 60 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)

/datum/supply_pack/rogue/light_armor/padded_gambeson_skirt
	name = "Gambesoned Kilt, Padded"
	cost = 50
	contains = list(/obj/item/clothing/under/roguetown/skirt/gambeson/heavy)

/datum/supply_pack/rogue/light_armor/padded_arming_jacket
	name = "Arming Jacket, Padded"
	cost = 75 // padded gambeson equiv. that trades leg protection for 75 more integ (375 vs 300), touch pricier.
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy)

/datum/supply_pack/rogue/light_armor/reinforced_hood
	name = "Reinforced Hood"
	cost = 40 // The mage hood type, in a sense. This is the one that fits on the face or head but not the neck.
	contains = list(
					/obj/item/clothing/head/roguetown/roguehood/reinforced)

/datum/supply_pack/rogue/light_armor/padded_leather_hood
	name = "Padded Leather Hood" // The newer version of the hood that fits around the neck like a coif.
	cost = 40
	contains = list(
					/obj/item/clothing/head/roguetown/helmet/leather/armorhood)

/datum/supply_pack/rogue/light_armor/studded_leather_hood
	name = "Studded Leather Hood"
	cost = 50
	contains = list(/obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced,)

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
