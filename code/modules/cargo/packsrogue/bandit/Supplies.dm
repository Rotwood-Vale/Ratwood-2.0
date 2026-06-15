
/datum/supply_pack/rogue/Supplies
	group = "Supplies"
	crate_name = "Gifts of Toil"
	crate_type = /obj/structure/closet/crate/chest/merchant

//////////////
// SUPPLIES //
//////////////

/datum/supply_pack/rogue/Supplies/cloth
	name = "布料"
	cost = 2
	contains = list(/obj/item/natural/cloth)

/datum/supply_pack/rogue/Supplies/rope
	name = "绳索"
	cost = 5
	contains = list(/obj/item/rope)

/datum/supply_pack/rogue/Supplies/chain
	name = "锁链"
	cost = 5
	contains = list(/obj/item/rope/chain)

/datum/supply_pack/rogue/Supplies/Satchel
	name = "挎包"
	cost = 10
	contains = list(/obj/item/storage/backpack/rogue/satchel)

/datum/supply_pack/rogue/Supplies/backpack
	name = "背包"
	cost = 15
	contains = list(/obj/item/storage/backpack/rogue/backpack)

/datum/supply_pack/rogue/Supplies/belt
	name = "皮带"
	cost = 5
	contains = list(/obj/item/storage/belt/rogue/leather)

/datum/supply_pack/rogue/Supplies/sack
	name = "麻袋"
	cost = 5
	contains = list(/obj/item/storage/roguebag)

/datum/supply_pack/rogue/Supplies/scroll
	name = "卷轴"
	cost = 5
	contains = list(/obj/item/paper/scroll)

/datum/supply_pack/rogue/Supplies/paper
	name = "纸张"
	cost = 2
	contains = list(/obj/item/paper)

/datum/supply_pack/rogue/Supplies/quill
	name = "羽毛笔"
	cost = 2
	contains = list(/obj/item/natural/feather)

/datum/supply_pack/rogue/Supplies/hardtack
	name = "硬饼干"
	cost = 10
	contains = list(/obj/item/reagent_containers/food/snacks/rogue/crackerscooked)

/datum/supply_pack/rogue/Supplies/needle
	name = "针"
	cost = 5
	contains = list(/obj/item/needle)

/datum/supply_pack/rogue/Supplies/Lamp
	name = "提灯"
	cost = 5
	contains = list(/obj/item/flashlight/flare/torch/lantern)

/datum/supply_pack/rogue/Supplies/gwstrap
	name = "巨兵器背带"
	cost = 15
	contains = list(/obj/item/rogueweapon/scabbard/gwstrap)

/datum/supply_pack/rogue/Supplies/scabbard
	name = "剑鞘"
	cost = 10
	contains = list(/obj/item/rogueweapon/scabbard/sword)

/datum/supply_pack/rogue/Supplies/sheath
	name = "匕首鞘"
	cost = 5
	contains = list(/obj/item/rogueweapon/scabbard/sheath)

/datum/supply_pack/rogue/Supplies/hknife
	name = "猎刀"
	cost = 5
	contains = list(/obj/item/rogueweapon/huntingknife)

/datum/supply_pack/rogue/Supplies/dagger
	name = "铁匕首"
	cost = 10
	contains = list(/obj/item/rogueweapon/huntingknife/idagger)

/datum/supply_pack/rogue/Supplies/daggerss
	name = "钢匕首"
	cost = 20
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/steel)

/datum/supply_pack/rogue/Supplies/daggersil
	name = "银匕首"
	cost = 80
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/silver)

/datum/supply_pack/rogue/Supplies/Waterskin
	name = "水袋"
	cost = 10
	contains = list(/obj/item/reagent_containers/glass/bottle/waterskin)

/datum/supply_pack/rogue/Supplies/flint
	name = "燧石"
	cost = 5
	contains = list(/obj/item/flint)

/datum/supply_pack/rogue/Supplies/chalk
	name = "一支粉笔"
	cost = 5
	contains = list(/obj/item/chalk)

/datum/supply_pack/rogue/Supplies/bedroll
	name = "铺盖卷"
	cost = 5
	contains = list(/obj/item/bedroll)

/datum/supply_pack/rogue/Supplies/soap
	name = "一块肥皂"
	cost = 10	// Hahaha why not
	contains = list(/obj/item/soap)

//////////////
// UTILITY //
//////////////

/datum/supply_pack/rogue/Supplies/rubyband
	name = "马西奥斯传讯石"
	cost = 20
	contains = list(/obj/item/mattcoin)

/datum/supply_pack/rogue/Supplies/Dragonscale
	name = "龙鳞项链"
	cost = 1200
	contains = list(/obj/item/clothing/neck/roguetown/dragon_scale)

/datum/supply_pack/rogue/Supplies/smokebomb
	name = "烟雾弹"
	cost = 30
	contains = list(/obj/item/bomb/smoke)

/datum/supply_pack/rogue/Supplies/bomb
	name = "火焰弹"
	cost =	60
	contains = list(/obj/item/bomb)

/datum/supply_pack/rogue/Supplies/leathercollar
	name = "皮项圈"
	cost =	20
	contains = list(/obj/item/clothing/neck/roguetown/collar/leather)

/datum/supply_pack/rogue/Supplies/cursedcollar
	name = "Cursed Collar"
	cost =	25
	contains = list(/obj/item/clothing/neck/roguetown/cursed_collar)

/datum/supply_pack/rogue/Supplies/chainleash
	name = "锁链牵绳"
	cost =	20
	contains = list(/obj/item/leash/chain)

/datum/supply_pack/rogue/Supplies/lockpicks
	name = "开锁器"
	cost = 25	// More expensive if your class doesn't have them.
	contains = list(/obj/item/lockpickring/mundane)

/datum/supply_pack/rogue/Supplies/grapplinghook
	name =	"抓钩"
	cost =	1000	// You're better off stealing this.
	contains = list(/obj/item/grapplinghook)

/datum/supply_pack/rogue/Supplies/climbing_gear
	name = "攀爬装备"
	cost = 800		// Really fucking good, you can drop down z-levels and hang there. 
	contains = list(/obj/item/clothing/climbing_gear)

/datum/supply_pack/rogue/Supplies/pick
	name = "铁镐"
	cost = 12		// Also a thing you can just kinda find, though moderately useful.
	contains = list(/obj/item/rogueweapon/pick)

/datum/supply_pack/rogue/Supplies/pick/steel
	name = "钢镐"
	cost = 35
	contains = list(/obj/item/rogueweapon/pick/steel)

//////////////
// COOKING  //		//Very basic ingredients. Nothing like meat or fruits, you can go and get those yourself. Buying components for everyone on your own will add up quickly. What are YOU bringing for the Matthios potluck?
//////////////

/datum/supply_pack/rogue/Supplies/cooking/flour
	name = "面粉"
	cost = 2	//Base component.
	contains = list(/obj/item/reagent_containers/powder/flour)

/datum/supply_pack/rogue/Supplies/cooking/rice
	name = "米粒"
	cost = 2	//Base component.
	contains = list(/obj/item/reagent_containers/food/snacks/grown/rice)

/datum/supply_pack/rogue/Supplies/cooking/butter
	name = "黄油"
	cost = 5	//Base component.
	contains = list(/obj/item/reagent_containers/food/snacks/butter)

/datum/supply_pack/rogue/Supplies/cooking/carrot
	name = "生胡萝卜"
	cost = 2	//Base component.
	contains = list(/obj/item/reagent_containers/food/snacks/grown/carrot)

/datum/supply_pack/rogue/Supplies/cooking/cackleberry
	name = "一枚蛋"
	cost = 2	//Base component.
	contains = list(/obj/item/reagent_containers/food/snacks/egg)

/datum/supply_pack/rogue/Supplies/cooking/peppermill
	name = "胡椒研磨器"
	cost = 35	//You're basically paying for an OK quantity of easy steak meals.
	contains = list(/obj/item/reagent_containers/peppermill)
