/datum/supply_pack/rogue/ranged_weapons
	group = "Weapons (Ranged)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/ranged_weapons/tossbladeiron
	name = "飞刀腰带，铁制"
	cost = 25
	contains = list(/obj/item/storage/belt/rogue/leather/knifebelt/black/iron)

/datum/supply_pack/rogue/ranged_weapons/tossbladesteel
	name = "飞刀腰带，钢制"
	cost = 45
	contains = list(/obj/item/storage/belt/rogue/leather/knifebelt/black/steel)

/datum/supply_pack/rogue/ranged_weapons/javeliniron
	name = "标枪，铁制"
	cost = 40 // 2 Iron Ingots
	contains = list(/obj/item/quiver/javelin/iron)

/datum/supply_pack/rogue/ranged_weapons/javelinsteel
	name = "标枪，钢制"
	cost = 80 // 2 Steel Ingots + Small Log
	contains = list(/obj/item/quiver/javelin/steel)

/datum/supply_pack/rogue/ranged_weapons/hurlbat
	name = "投掷斧"
	cost = 50 // 1 Steel Ingot, but a pretty strong weapon.
	contains = list(/obj/item/rogueweapon/stoneaxe/hurlbat)

/datum/supply_pack/rogue/ranged_weapons/crossbow
	name = "十字弩"
	cost = 30
	contains = list(
					/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow,
				)

/datum/supply_pack/rogue/ranged_weapons/recurvebow
	name = "反曲弓"
	cost = 20
	contains = list(
					/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve,
				)

/datum/supply_pack/rogue/ranged_weapons/longbow
	name = "长弓"
	cost = 45
	contains = list(
					/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow,
				)

/datum/supply_pack/rogue/ranged_weapons/quiver
	name = "箭袋"
	cost = 5
	contains = list(
					/obj/item/quiver,
				)

/datum/supply_pack/rogue/ranged_weapons/quivers/arrows
	name = "箭矢箭袋"
	cost = 35 // 2 Iron Ingots
	contains = list(
					/obj/item/quiver/arrows,
				)

/datum/supply_pack/rogue/ranged_weapons/quivers/barrows
	name = "穿甲箭箭袋"
	cost = 100 // 2 Steel Ingots + Sticks
	contains = list(
					/obj/item/quiver/bodkin,
				)

/datum/supply_pack/rogue/ranged_weapons/quivers/pyroarrows
	name = "火焰箭箭袋"
	cost = 100
	contains = list(
					/obj/item/quiver/pyroarrows,
				)

/datum/supply_pack/rogue/ranged_weapons/quivers/poisonarrows
	name = "毒箭箭袋"
	cost = 100
	contains = list(
					/obj/item/quiver/poisonarrows,
				)

/datum/supply_pack/rogue/ranged_weapons/quivers/bolts
	name = "弩矢箭袋"
	cost = 35 // 2 Iron Ingots
	contains = list(
					/obj/item/quiver/bolts,
				)

/datum/supply_pack/rogue/ranged_weapons/quivers/heavybluntbolts
	name = "重型钝头弩矢箭袋"
	cost = 35 // 2 Iron Ingots
	contains = list(
					/obj/item/quiver/heavybluntbolts,
				)


/datum/supply_pack/rogue/ranged_weapons/quivers/pyrobolts
	name = "爆燃弩矢箭袋"
	cost = 100 // Matching price of steel
	contains = list(
					/obj/item/quiver/pyrobolts,
				)

/datum/supply_pack/rogue/ranged_weapons/bottlebombs
	name = "瓶装炸弹"
	cost = 40
	contains = list(
					/obj/item/bomb,
					/obj/item/bomb,
					/obj/item/bomb,
					/obj/item/bomb,
					/obj/item/bomb
				)

/datum/supply_pack/rogue/ranged_weapons/slingandpouch
	name = "投石索与弹袋"
	cost = 15
	no_name_quantity = TRUE
	contains = list(
					/obj/item/gun/ballistic/revolver/grenadelauncher/sling,
					/obj/item/quiver/sling,
				)

/datum/supply_pack/rogue/ranged_weapons/slingiron
	name = "投石弹袋，铁制"
	cost = 35 // 2 Iron Ingots
	contains = list(
					/obj/item/quiver/sling/iron,
				)

/datum/supply_pack/rogue/ranged_weapons/net
	name = "网"
	cost = 20
	contains = list(
					/obj/item/net,
				)
