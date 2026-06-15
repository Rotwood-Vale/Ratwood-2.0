/datum/supply_pack/rogue/Pioneer
	group = "Pioneer"
	crate_name = "Gifts of Engineering"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/Pioneer/gambeson
	name = "棉甲"
	cost = 5
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson)

/datum/supply_pack/rogue/Pioneer/hgambeson
	name = "重型棉甲"
	cost = 15
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)

/datum/supply_pack/rogue/Pioneer/leather
	name = "皮甲"
	cost = 10
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather)

/datum/supply_pack/rogue/Pioneer/leather/studded
	name = "铆钉皮甲"
	cost = 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/studded)

/datum/supply_pack/rogue/Pioneer/leather/heavy
	name = "硬化皮甲"
	cost = 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy)

/datum/supply_pack/rogue/Pioneer/leather/hcoat
	name = "硬化皮外套"
	cost = 30
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat)

/datum/supply_pack/rogue/Pioneer/gorget
	name = "护喉"
	cost = 20
	contains = list(/obj/item/clothing/neck/roguetown/gorget)

/datum/supply_pack/rogue/Pioneer/steelgorget
	name = "Steel Gorget"
	cost = 30
	contains = list(/obj/item/clothing/neck/roguetown/gorget/steel)

/datum/supply_pack/rogue/Pioneer/steelcoif
	name = "钢锁子头巾"
	cost = 30
	contains = list(/obj/item/clothing/neck/roguetown/chaincoif)

/datum/supply_pack/rogue/Pioneer/leather/Lbracers
	name = "皮护臂"
	cost = 5
	contains = list(/obj/item/clothing/wrists/roguetown/bracers/leather)

/datum/supply_pack/rogue/Pioneer/leather/hbracers
	name = "硬化皮护臂"
	cost = 10
	contains = list(/obj/item/clothing/wrists/roguetown/bracers/leather/heavy)

/datum/supply_pack/rogue/Pioneer/leather/lgloves
	name = "皮手套"
	cost = 5
	contains = list(/obj/item/clothing/gloves/roguetown/leather)

/datum/supply_pack/rogue/Pioneer/leather/hlgloves
	name = "重型皮手套"
	cost = 10
	contains = list(/obj/item/clothing/gloves/roguetown/angle)

/datum/supply_pack/rogue/Pioneer/leather/flgloves
	name = "露指皮手套"
	cost = 10
	contains = list(/obj/item/clothing/gloves/roguetown/fingerless_leather)

/datum/supply_pack/rogue/Pioneer/leather/pants
	name = "皮裤"
	cost = 10
	contains = list(/obj/item/clothing/under/roguetown/trou/leather)

/datum/supply_pack/rogue/Pioneer/leather/hpants
	name = "硬化皮裤"
	cost = 20
	contains = list(/obj/item/clothing/under/roguetown/heavy_leather_pants)

/datum/supply_pack/rogue/Pioneer/leather/lhelmet
	name = "皮盔"
	cost = 5
	contains = list(/obj/item/clothing/head/roguetown/helmet/leather)

/datum/supply_pack/rogue/Pioneer/leather/hlhelmet
	name = "硬化皮盔"
	cost = 10
	contains = list(/obj/item/clothing/head/roguetown/helmet/leather/advanced)

/datum/supply_pack/rogue/Pioneer/leather/khelmet
	name = "锅盔"
	cost = 20
	contains = list(/obj/item/clothing/head/roguetown/helmet/kettle)

//Weaponry. They can't get a backup shovel.

/datum/supply_pack/rogue/Pioneer/parrydag
	name = "招架匕首"
	cost = 30
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/steel/parrying)

/datum/supply_pack/rogue/Pioneer/axepick
	name = "普拉斯基斧"
	cost = 25
	contains = list(/obj/item/rogueweapon/stoneaxe/woodcut/pick)

/datum/supply_pack/rogue/Pioneer/

//Tools of the trade.

/datum/supply_pack/rogue/Pioneer/Mancatcher
	name = "捕人叉"
	cost = 10
	contains = list(/obj/item/restraints/legcuffs/beartrap)

/datum/supply_pack/rogue/Pioneer/hammer
	name = "铁匠锤"
	cost = 20
	contains = list(/obj/item/rogueweapon/hammer/iron)

/datum/supply_pack/rogue/Pioneer/tongs
	name = "铁匠钳"
	cost = 20
	contains = list(/obj/item/rogueweapon/tongs)

/datum/supply_pack/rogue/Pioneer/chiselset

	name = "凿子与锤"
	cost = 20
	contains = list(/obj/item/rogueweapon/chisel/assembly/hammer)

/datum/supply_pack/rogue/Pioneer/handsaw
	name = "手锯"
	cost = 20
	contains = list(/obj/item/rogueweapon/handsaw)

/datum/supply_pack/rogue/Pioneer/linker
	name = "巧匠扳手"
	cost = 20
	contains = list(/obj/item/contraption/linker)

/datum/supply_pack/rogue/Pioneer/Sarrows
	name = "Steel Bodkin Arrow"
	cost = 3
	contains = list(/obj/item/ammo_casing/caseless/rogue/arrow/steel)

/datum/supply_pack/rogue/Pioneer/pyroarrows // Engineering arrows... they can have them...
	name = "Pyroclastic Arrow"
	cost = 3
	contains = list(/obj/item/ammo_casing/caseless/rogue/arrow/pyro)

/datum/supply_pack/rogue/Pioneer/pyrobolts
	name = "Pyroclastic bolt"
	cost = 3
	contains = list(/obj/item/ammo_casing/caseless/rogue/bolt/pyro)

/datum/supply_pack/rogue/Pioneer/cogs
	name = "齿轮"
	cost = 20
	contains = list(/obj/item/roguegear/bronze = 2)

/datum/supply_pack/rogue/Pioneer/bmbstrap
	name = "炸弹挎带"
	cost = 40 // 70 is far too much, it'd be easier to just make it.
	contains = list(/obj/item/bmbstrap)

//Meh grenades.

/datum/supply_pack/rogue/Pioneer/impactgrenade_smoke
	name = "碰炸手雷（烟雾）"
	cost = 15
	contains = list(/obj/item/impact_grenade/smoke)

/datum/supply_pack/rogue/Pioneer/impactgrenade_healing
	name = "碰炸手雷（治疗）"
	cost = 15
	contains = list(/obj/item/impact_grenade/smoke/healing_gas)

//Great grenades.

/datum/supply_pack/rogue/Pioneer/impactgrenade_poison
	name = "碰炸手雷（毒气）"
	cost = 40
	contains = list(/obj/item/impact_grenade/smoke/poison_gas)

/datum/supply_pack/rogue/Pioneer/impactgrenade_fire
	name = "碰炸手雷（火焰）"
	cost = 40
	contains = list(/obj/item/impact_grenade/smoke/fire_gas)

//Wild grenades.

/datum/supply_pack/rogue/Pioneer/impactgrenade_explosion
	name = "碰炸手雷（爆炸）"
	cost = 50
	contains = list(/obj/item/impact_grenade/explosion)

/datum/supply_pack/rogue/Pioneer/impactgrenade_blind
	name = "碰炸手雷（致盲）"
	cost = 50
	contains = list(/obj/item/impact_grenade/smoke/blind_gas)

/datum/supply_pack/rogue/Pioneer/impactgrenade_mute
	name = "碰炸手雷（沉默）"
	cost = 15
	contains = list(/obj/item/impact_grenade/smoke/mute_gas)

//WMDs.

/datum/supply_pack/rogue/Pioneer/blackpowder_stick
	name = "黑火药棒"
	cost = 100//From 35. Why was this 35? OOOUGH.
	contains = list(/obj/item/tntstick)

//WMDs, but for bombard and smokepowder stuff. Zezuz Pyst!!!
//A serious investment just to get started.
//Not even bringing up the other costs.
/datum/supply_pack/rogue/Pioneer/bombard_frame
	name = "轻型臼炮架"
	cost = 200
	contains = list(/obj/item/bombard_frame)

/datum/supply_pack/rogue/Pioneer/bombard_barrel
	name = "轻型臼炮管"
	cost = 200
	contains = list(/obj/item/bombard_barrel)

/datum/supply_pack/rogue/Pioneer/bombard_palantir
	name = "真知晶球"
	cost = 100
	contains = list(/obj/item/rogueweapon/palantir)

/datum/supply_pack/rogue/Pioneer/bombard_sponge
	name = "装药杆"
	cost = 100
	contains = list(/obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge)

/datum/supply_pack/rogue/Pioneer/smokepowder_flask
	name = "烟火药瓶"
	cost = 100
	contains = list(/obj/item/powderflask)

//WMDs, but shells for the above!!!!
//Smoke bombard charges.
/datum/supply_pack/rogue/Pioneer/bombard_charge_smoke
	name = "臼炮装药（烟雾）"
	cost = 20
	contains = list(/obj/item/cannonball/smoke)

/datum/supply_pack/rogue/Pioneer/bombard_charge_poison
	name = "臼炮装药（烟雾-毒气）"
	cost = 100
	contains = list(/obj/item/cannonball/smoke_poison)

/datum/supply_pack/rogue/Pioneer/bombard_charge_custom
	name = "臼炮装药（烟雾-自定义）"
	cost = 110
	contains = list(/obj/item/cannonball/smoke_custom)

//Dangerous bombard charges.
/datum/supply_pack/rogue/Pioneer/bombard_charge_canister
	name = "臼炮装药（霰射）"
	cost = 100
	contains = list(/obj/item/cannonball/canister)

/datum/supply_pack/rogue/Pioneer/bombard_charge_explosive
	name = "臼炮装药（爆炸）"
	cost = 250
	contains = list(/obj/item/cannonball/explosive)

/datum/supply_pack/rogue/Pioneer/bombard_charge_incendiary
	name = "臼炮装药（燃烧）"
	cost = 150
	contains = list(/obj/item/cannonball/incendiary)

//Misc bombard charges.
/datum/supply_pack/rogue/Pioneer/bombard_charge_flare
	name = "臼炮装药（照明）"
	cost = 20
	contains = list(/obj/item/cannonball/flare)

// Ranged Weaponry

/datum/supply_pack/rogue/Pioneer/bow
	name = "Bow"
	cost = 10
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow)

/datum/supply_pack/rogue/Pioneer/crossbow
	name = "Crossbow"
	cost = 20
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow)

/datum/supply_pack/rogue/Pioneer/recurvebow
	name = "Recurve Bow"
	cost = 20
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve)

/datum/supply_pack/rogue/Pioneer/longbow
	name = "Longbow"
	cost = 40
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow)

/datum/supply_pack/rogue/Pioneer/slurbow
	name = "Slurbow"
	cost = 40
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow)

// Standard Ammunition

/datum/supply_pack/rogue/Pioneer/quiver
	name = "Empty Quiver"
	cost = 5
	contains = list(/obj/item/quiver)

/datum/supply_pack/rogue/Pioneer/quivers/arrows
	name = "Quiver of Arrows"
	cost = 10
	contains = list(/obj/item/quiver/arrows)

/datum/supply_pack/rogue/Pioneer/quivers/bolts
	name = "Quiver of Bolts"
	cost = 20
	contains = list(/obj/item/quiver/bolts)
