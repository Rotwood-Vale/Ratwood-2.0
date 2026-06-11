/datum/carebox_loot
	abstract_type = /datum/carebox_loot
	var/name = "战利品"
	var/list/loot
	var/random_loot_amt = 0
	var/list/random_loot


/datum/carebox_loot/wretch
	abstract_type = /datum/carebox_loot/wretch

/datum/carebox_loot/wretch/potion
	name = "治疗药水"
	loot = list(
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot
	)

/datum/carebox_loot/wretch/steel_mask
	name = "钢面罩"
	random_loot_amt = 1
	random_loot = list(
		/obj/item/clothing/mask/rogue/facemask/steel,
		/obj/item/clothing/mask/rogue/facemask/steel/hound,
	)

/datum/carebox_loot/wretch/steel_ingot
	name = "钢锭（2）"
	loot = list(
		/obj/item/ingot/steel,
		/obj/item/ingot/steel,
	)

/datum/carebox_loot/wretch/iron_ingot
	name = "铁锭（3）"
	loot = list(
		/obj/item/ingot/iron,
		/obj/item/ingot/iron,
		/obj/item/ingot/iron,
	)

/datum/carebox_loot/wretch/gambeson
	name = "软垫甲"
	loot = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy,
	)

/datum/carebox_loot/wretch/leather_clothes
	name = "皮制服"
	loot = list(
		/obj/item/clothing/shoes/roguetown/boots/leather/reinforced,
		/obj/item/clothing/gloves/roguetown/angle,
		/obj/item/clothing/wrists/roguetown/bracers/leather/heavy,
		/obj/item/clothing/under/roguetown/heavy_leather_pants,
	)

/datum/carebox_loot/wretch/leather_armor
	name = "皮甲"
	random_loot_amt = 1
	random_loot = list(
		/obj/item/clothing/suit/roguetown/armor/leather/studded,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat,
	)

/datum/carebox_loot/wretch/stampot
	name = "体力药水"
	loot = list(
		/obj/item/reagent_containers/glass/bottle/rogue/stampot,
	)

/datum/carebox_loot/wretch/manapot
	name = "法力药水"
	loot = list(
		/obj/item/reagent_containers/glass/bottle/rogue/manapot,
	)

/datum/carebox_loot/wretch/raisin_loaf
	name = "葡萄干面包"
	loot = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisinbread,
	)

/datum/carebox_loot/wretch/quiver
	name = "箭矢和弩矢"
	loot = list(
		/obj/item/quiver/arrows,
		/obj/item/quiver/bolts,
	)

/datum/carebox_loot/wretch/throwing_knifes
	name = "铁制飞刀"
	loot = list(
		/obj/item/storage/belt/rogue/leather/knifebelt/black/iron,
	)

/datum/carebox_loot/wretch/pouch_coins_mid
	name = "钱币袋"
	loot = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid,
	)

/datum/carebox_loot/wretch/chain_rope
	name = "锁链（2），绳索（1）"
	loot = list(
		/obj/item/rope/chain,
		/obj/item/rope/chain,
		/obj/item/rope,
	)

/datum/carebox_loot/wretch/lantern_bedroll
	name = "提灯和床卷"
	loot = list(
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/bedroll,
	)

/datum/carebox_loot/wretch/pouch_medicine
	name = "药品袋"
	loot = list(
		/obj/item/storage/belt/rogue/pouch/medicine,
	)

/datum/carebox_loot/wretch/bottle_bomb
	name = "瓶装炸弹（2）"
	loot = list(
		/obj/item/bomb,
		/obj/item/bomb,
	)

//These are otherwise unobtanium outside of some very specific loot tables and the loadout.
//Needed for heretic revelations for the antipope, too.
/datum/carebox_loot/wretch/zizite_cross
	name = "Zizite Cross (2)"
	loot = list(
		/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient,
		/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient,
	)
