// Light Armor Pack. Only includes the "highest tier" plus a special package of budget armor.
// Pricing principles - Based on uhh sell price x 1.5 approx lol.

/datum/supply_pack/rogue/light_armor
	group = "Armor (Light)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/light_armor/padded_gambeson
	name = "衬垫棉甲"
	cost = 40 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)

/datum/supply_pack/rogue/light_armor/leather_gorget
	name = "皮护喉"
	cost = 20 // Base sellprice of 10
	contains = list(/obj/item/clothing/neck/roguetown/leather)

/datum/supply_pack/rogue/light_armor/leather_bracers
	name = "硬皮臂甲"
	cost = 20 // Base sellprice of 10
	contains = list(/obj/item/clothing/wrists/roguetown/bracers/leather/heavy)

/datum/supply_pack/rogue/light_armor/heavy_leather_pants
	name = "硬皮裤"
	cost = 30 // Base sellprice of 20
	contains = list(/obj/item/clothing/under/roguetown/heavy_leather_pants)

/datum/supply_pack/rogue/light_armor/hide_armor
	name = "兽皮甲"
	cost = 30 // Base sellprice of 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/hide)

/datum/supply_pack/rogue/light_armor/heavy_leather_armor
	name = "硬皮甲"
	cost = 30 // Base sellprice of 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy)

/datum/supply_pack/rogue/light_armor/studded_leather_armor
	name = "铆钉皮甲"
	cost = 40 // I added 5 to the base sellprice of 25 because it cost 1 ingot
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/studded)

/datum/supply_pack/rogue/light_armor/heavy_leather_coat
	name = "硬皮外套"
	cost = 35 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat)

/datum/supply_pack/rogue/light_armor/heavy_leather_jacket
	name = "硬皮夹克"
	cost = 35 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket)

/datum/supply_pack/rogue/light_armor/heavy_leather_gloves
	name = "厚皮手套"
	cost = 20 // No one buying this lmao it costs 1 fur
	contains = list(/obj/item/clothing/gloves/roguetown/angle)

/datum/supply_pack/rogue/light_armor/heavy_padded_coif
	name = "厚衬垫头巾"
	cost = 35 // Equivalent to a padded gambeson on the head, so pricier
	contains = list(/obj/item/clothing/neck/roguetown/coif/heavypadding)

/datum/supply_pack/rogue/light_armor/reinforced_hood
	name = "加固兜帽"
	cost = 40 // The mage hood type, in a sense. This is the one that fits on the face or head but not the neck.
	contains = list(
					/obj/item/clothing/head/roguetown/roguehood/reinforced)

/datum/supply_pack/rogue/light_armor/padded_leather_hood
	name = "衬垫皮兜帽" // The newer version of the hood that fits around the neck like a coif.
	cost = 40
	contains = list(
					/obj/item/clothing/head/roguetown/helmet/leather/armorhood)

/datum/supply_pack/rogue/light_armor/studded_leather_hood
	name = "铆钉皮兜帽"
	cost = 50
	contains = list(/obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced,)

// Exotic import stuff goes here. Should probably be a little pricier than normal stuff. 2x average? Be sure to name the purchase option so it relates to the actual item, but also what slot it fills.

/datum/supply_pack/rogue/light_armor/import
	group = "Imported Armor (Light)"

/datum/supply_pack/rogue/light_armor/import/otavangambeson
	name = "奥塔万击剑棉甲"
	cost = 60 // Base sellprice of 30
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan)

/datum/supply_pack/rogue/light_armor/import/otavanpants1
	name = "奥塔万厚皮裤"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan)

/datum/supply_pack/rogue/light_armor/import/otavanpants2
	name = "奥塔万击剑裤"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic)

/datum/supply_pack/rogue/light_armor/import/aavnicgambeson
	name = "阿夫尼克击剑棉甲"
	cost = 50 // Base sellprice of 30, doesn't cover legs so slightly cheaper
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter)

/datum/supply_pack/rogue/light_armor/import/caftan
	name = "衬垫卡夫坦长袍"
	cost = 60 // Base sellprice of 30
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah)

/datum/supply_pack/rogue/light_armor/import/kazenpants
	name = "风郡厚皮裤"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun)

/datum/supply_pack/rogue/light_armor/import/grenzhat
	name = "格伦泽尔霍夫特羽饰帽"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/head/roguetown/grenzelhofthat)

/datum/supply_pack/rogue/light_armor/import/grenzhipshirt
	name = "格伦泽尔霍夫特短摆衫"
	cost = 60 // Base sellprice of 30
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft)

/datum/supply_pack/rogue/light_armor/import/grenzpants
	name = "格伦泽尔霍夫特蓬裤"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants)

/datum/supply_pack/rogue/light_armor/import/desertgambanormal
	name = "沙漠棉甲"
	cost = 45 // Base sellprice of 20
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/zyb)

/datum/supply_pack/rogue/light_armor/import/zybgambaheavy
	name = "衬垫沙漠棉甲"
	cost = 60 // Base sellprice of 30
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb)

/datum/supply_pack/rogue/light_armor/import/naledigamba
	name = "纳莱迪衬垫棉甲"
	cost = 60 // Base sellprice of 30
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex)

/datum/supply_pack/rogue/light_armor/import/naleditrou
	name = "纳莱迪硬皮恰克丘尔裤"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/trou/leather/pontifex)

/datum/supply_pack/rogue/light_armor/import/zybtrou
	name = "宽松硬皮沙漠裤"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/trou/leather/pontifex/zyb)

/datum/supply_pack/rogue/light_armor/import/gronnarmor
	name = "格隆恩硬皮甲"
	cost = 45 // Base sellprice of 20
	contains = list (/obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn)

/datum/supply_pack/rogue/light_armor/import/gronnpants
	name = "游牧硬皮裤"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants)

/datum/supply_pack/rogue/light_armor/import/gronnpantsalt
	name = "格隆恩皮裤"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/trou/leather/gronn)

/datum/supply_pack/rogue/light_armor/import/gronnglovesleather
	name = "格隆恩毛衬厚皮手套"
	cost = 40 // Base sellprice of 20
	contains = list (/obj/item/clothing/gloves/roguetown/angle/gronn)
