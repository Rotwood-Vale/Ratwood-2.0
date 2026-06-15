// Special Mercenary Weapons, at exorbitant prices
/datum/supply_pack/rogue/merc_weapons
	group = "Weapons (Exotic)"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/merc_weapons/saildagger
	name = "航海匕首"
	cost = 80
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero)

/datum/supply_pack/rogue/merc_weapons/erapier
	name = "伊特鲁斯卡刺剑"
	cost = 80
	contains = list(/obj/item/rogueweapon/sword/rapier/vaquero)

/datum/supply_pack/rogue/merc_weapons/shamshir
	name = "沙姆希尔弯刀"
	cost = 80
	contains = list(/obj/item/rogueweapon/sword/sabre/shamshir)

/datum/supply_pack/rogue/merc_weapons/beardedaxe
	name = "胡须斧"
	cost = 80
	contains = list(/obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi)

/datum/supply_pack/rogue/merc_weapons/naledistaff
	name = "纳莱迪战杖"
	cost = 80
	contains = list(/obj/item/rogueweapon/woodstaff/naledi)

/datum/supply_pack/rogue/merc_weapons/pulaxe
	name = "普拉斯基斧"
	cost = 80
	contains = list(/obj/item/rogueweapon/stoneaxe/woodcut/pick)

/datum/supply_pack/rogue/merc_weapons/navaja
	name = "纳瓦哈折刀"
	cost = 80
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/navaja)

/datum/supply_pack/rogue/merc_weapons/naginata
	name = "风郡薙刀（长柄武器）"
	cost = 80
	contains = list(/obj/item/rogueweapon/spear/naginata)

/datum/supply_pack/rogue/merc_weapons/kanabo
	name = "风郡金棒（巨棍）"
	cost = 200
	contains = list(/obj/item/rogueweapon/mace/goden/kanabo)

/datum/supply_pack/rogue/merc_weapons/ssangsudo
	name = "风郡双手刀（巨剑）"
	cost = 200
	contains = list(/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo)

/datum/supply_pack/rogue/merc_weapons/katana
	name = "风郡环刀（剑）"
	cost = 80
	contains = list(/obj/item/rogueweapon/sword/sabre/mulyeog)

/datum/supply_pack/rogue/merc_weapons/kazengunkodachi
	name = "风郡小太刀（短剑）"
	cost = 70
	contains = list(/obj/item/rogueweapon/sword/short/kazengun)

/datum/supply_pack/rogue/merc_weapons/kazengundagger
	name = "风郡短刀（匕首）"
	cost = 80
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun)

/datum/supply_pack/rogue/merc_weapons/kazengunhookblade
	name = "风郡钩剑"
	cost = 100
	contains = list(/obj/item/rogueweapon/sword/sabre/hook)

/datum/supply_pack/rogue/merc_weapons/kazengunscabbard
	name = "风郡剑鞘（加固）"
	cost = 80
	contains = list(/obj/item/rogueweapon/scabbard/sword/kazengun)

/datum/supply_pack/rogue/merc_weapons/kazengunscabbard_noparry
	name = "风郡剑鞘（仪礼）"
	cost = 40
	contains = list(/obj/item/rogueweapon/scabbard/sword/kazengun/noparry/loadout)

/datum/supply_pack/rogue/merc_weapons/kazengunsheath
	name = "小漆鞘"
	cost = 20
	contains = list(/obj/item/rogueweapon/scabbard/sheath/kazengun)

/datum/supply_pack/rogue/merc_weapons/nagaika
	name = "纳盖卡鞭"
	cost = 80
	contains = list(/obj/item/rogueweapon/whip/nagaika)

/datum/supply_pack/rogue/merc_weapons/glaive
	name = "长柄刃"
	cost = 120
	contains = list(/obj/item/rogueweapon/halberd/glaive)

/datum/supply_pack/rogue/merc_weapons/etruscanlongsword
	name = "伊特鲁斯卡长剑"
	cost = 409 // 409 because the Flos Duellatorum was written between 1400-1409 & Fiore is part of the reason frei gets an etruscan class
	contains = list(/obj/item/rogueweapon/sword/long/etruscan)

/datum/supply_pack/rogue/merc_weapons/handclaw_iron
	name = "格隆恩铁爪"
	cost = 150
	contains = list(/obj/item/rogueweapon/handclaw)

/datum/supply_pack/rogue/merc_weapons/handclaw_steel
	name = "格隆恩钢爪"
	cost = 200
	contains = list(/obj/item/rogueweapon/handclaw/steel)

/datum/supply_pack/rogue/merc_weapons/grenzelstaff
	name = "格伦泽尔霍夫特黑钢杖"
	cost = 100
	contains = list(/obj/item/rogueweapon/woodstaff/emerald/blacksteelstaff)

//// Elven Weapons
/datum/supply_pack/rogue/merc_weapons/elfsword
	name = "精灵短剑"
	cost = 60
	contains = list(/obj/item/rogueweapon/sword/short/elf)
	
/datum/supply_pack/rogue/merc_weapons/elflongsword
	name = "精灵长剑"
	cost = 80
	contains = list(/obj/item/rogueweapon/sword/long/elf)

/datum/supply_pack/rogue/merc_weapons/elfswordspear
	name = "精灵枪剑"
	cost = 100
	contains = list(/obj/item/rogueweapon/spear/naginata/elf)

/datum/supply_pack/rogue/merc_weapons/elfcurveblade
	name = "精灵弧刃剑"
	cost = 120
	contains = list(/obj/item/rogueweapon/greatsword/elf)

//adding it here because... it's a weapon!
/datum/supply_pack/rogue/merc_weapons/silverdagger
	name = "银匕首"
	cost = 120 //Silver weapons have been made much less powerful but much more common over time
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/silver)
