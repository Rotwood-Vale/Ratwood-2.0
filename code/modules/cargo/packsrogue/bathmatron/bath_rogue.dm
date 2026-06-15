// Thievery Related Supplies. I sure hope this don't go wrong!!!
// Took lockpicks out so it don't get spammed. Get the expensive hairpins instead.

/datum/supply_pack/rogue/bath_rogue
	group = "Roguery"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

// Same as merchant
/datum/supply_pack/rogue/bath_rogue/chains
	name = "锁链"
	cost = 15
	contains = list(
		/obj/item/rope/chain,
		/obj/item/rope/chain,
		/obj/item/rope/chain,
	)

/datum/supply_pack/rogue/bath_rogue/goldpin
	name = "金发簪"
	cost = 70
	contains = list(/obj/item/lockpick/goldpin)

/datum/supply_pack/rogue/bath_rogue/silverpin
	name = "银发簪"
	cost = 140
	contains = list(/obj/item/lockpick/goldpin/silver)

/datum/supply_pack/rogue/bath_rogue/smokebomb
	name = "烟雾弹"
	cost = 25
	contains = list(
		/obj/item/bomb/smoke,
		/obj/item/bomb/smoke,
		/obj/item/bomb/smoke)

/datum/supply_pack/rogue/bath_rogue/mirrortransform
	name = "镜像变形卷轴"
	cost = 50
	contains = list(/obj/item/book/granter/spell/blackstone/mirror_transform)

/datum/supply_pack/rogue/bath_rogue/waterarrows
	name = "水箭"
	cost = 20
	contains = list (
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
	)

/datum/supply_pack/rogue/bath_rogue/waterbolts
	name = "水弩矢"
	cost = 20
	contains = list (
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
	)

/datum/supply_pack/rogue/bath_rogue/quiver
	name = "空箭袋"
	cost = 5
	contains = list(/obj/item/quiver)

/datum/supply_pack/rogue/bath_rogue/net
	name = "网"
	cost = 20
	contains = list(/obj/item/net)

/datum/supply_pack/rogue/bath_rogue/grappler
	name = "抓钩"
	cost = 200
	contains = list(/obj/item/grapplinghook)

/datum/supply_pack/rogue/bath_rogue/climbing_gear
	name = "攀爬装备"
	cost = 150
	contains = list(/obj/item/clothing/climbing_gear)

/datum/supply_pack/rogue/bath_rogue/whip
	name = "鞭子"
	cost = 20
	contains = list(/obj/item/rogueweapon/whip)

/datum/supply_pack/rogue/bath_rogue/brandiron
	name = "烙铁"
	cost = 20
	contains = list(/obj/item/rogueweapon/surgery/cautery/branding)
