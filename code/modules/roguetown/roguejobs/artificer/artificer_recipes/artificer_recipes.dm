/datum/artificer_recipe
	var/name
	var/list/additional_items = list()
	var/appro_skill = /datum/skill/craft/engineering
	var/required_item
	var/created_item
	/// Craft Difficulty here only matters for exp calculation and locking recipes based on skill level
	var/skill_level = 0
	var/obj/item/needed_item
	/// If tha current item has been hammered all the times it needs to
	var/hammered = FALSE
	/// How many times does this need to be hammered?
	var/hammers_per_item = 0
	var/progress
	/// I_type is like "sub category"
	var/i_type

	var/datum/parent

// Small design rules for Artificer!
// If you make any crafteable by the Artificer trough here make sure it interacts with Artificer Contraptions!

/datum/artificer_recipe/proc/advance(obj/item/I, mob/user)
	if(progress == 100)
		return
	if(hammers_per_item == 0)
		hammered = TRUE
		user.visible_message(span_warning("[user]敲打着这件装置。"))
		if(additional_items.len)
			needed_item = pick(additional_items)
			additional_items -= needed_item
		if(needed_item)
			to_chat(user, span_info("现在该加入[initial(needed_item.name)]了。"))
			return
	if(!needed_item && hammered)
		progress = 100
		return
	if(!hammered && hammers_per_item)
		switch(user.get_skill_level(appro_skill))
			if(SKILL_LEVEL_NONE to SKILL_LEVEL_NOVICE)
				hammers_per_item = max(0, hammers_per_item -= 0.5)
			if(SKILL_LEVEL_APPRENTICE to SKILL_LEVEL_JOURNEYMAN)
				hammers_per_item = max(0, hammers_per_item -= 1)
			if(SKILL_LEVEL_EXPERT to SKILL_LEVEL_MASTER)
				hammers_per_item = max(0, hammers_per_item -= 2)
			if(SKILL_LEVEL_LEGENDARY to INFINITY)
				hammers_per_item = max(0, hammers_per_item -= 3)
		user.visible_message(span_warning("[user]敲打着这件装置。"))
		return

/datum/artificer_recipe/proc/item_added(mob/user)
	user.visible_message(span_info("[user]加入了[initial(needed_item.name)]。"))
	if(istype(needed_item, /obj/item/natural/wood/plank))
		playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
	needed_item = null
	hammers_per_item = initial(hammers_per_item)
	hammered = FALSE

// --------- GENERAL -----------

/datum/artificer_recipe
	appro_skill = /datum/skill/craft/engineering

/datum/artificer_recipe/general
	i_type = "通用"

/datum/artificer_recipe/wood //TNevermind this being silly, I was silly and this needs to be redone proper
	name = "木制齿轮"
	required_item = /obj/item/natural/wood/plank
	created_item = /obj/item/roguegear/wood/basic
	hammers_per_item = 5
	skill_level = 1
	i_type = "通用"

/datum/artificer_recipe/wood/reliable
	name = "可靠木制齿轮 (+1 Essence of Lumber)"
	created_item = /obj/item/roguegear/wood/reliable
	additional_items = list(/obj/item/grown/log/tree/small/essence = 1)
	hammers_per_item = 10
	skill_level = 2

/datum/artificer_recipe/wood/unstable
	name = "不稳定木制齿轮 (+1 Essence of Wilderness)"
	created_item = /obj/item/roguegear/wood/unstable
	additional_items = list(/obj/item/natural/cured/essence = 1)
	hammers_per_item = 10
	skill_level = 3

/datum/artificer_recipe/bronze
	name = "青铜齿轮 2x"
	required_item = /obj/item/ingot/bronze
	created_item = list(/obj/item/roguegear/bronze,/obj/item/roguegear/bronze)
	hammers_per_item = 10
	skill_level = 1
	i_type = "通用"

/datum/artificer_recipe/iron
	i_type = "通用"

/datum/artificer_recipe/iron/locks
	name = "锁 3x"
	required_item = /obj/item/ingot/iron
	created_item = list(/obj/item/customlock, /obj/item/customlock, /obj/item/customlock)
	hammers_per_item = 5
	skill_level = 1

/datum/artificer_recipe/iron/keys
	name = "钥匙 3x"
	required_item = /obj/item/ingot/iron
	created_item = list(/obj/item/customblank, /obj/item/customblank, /obj/item/customblank)
	hammers_per_item = 5
	skill_level = 1


/datum/artificer_recipe/iron/lockpicks
	name = "开锁器 (x3)"
	required_item = /obj/item/ingot/iron
	created_item = list(/obj/item/lockpick,/obj/item/lockpick,/obj/item/lockpick)
	hammers_per_item = 5
	skill_level = 2

/datum/artificer_recipe/iron/lockpickring
	name = "开锁环 (x3)"
	required_item = /obj/item/ingot/iron
	created_item = list(/obj/item/lockpickring,/obj/item/lockpickring,/obj/item/lockpickring)
	hammers_per_item = 5
	skill_level= 0

// --------- TOOLS -----------

/datum/artificer_recipe/wood/tools
	name = "木槌"
	created_item = /obj/item/rogueweapon/hammer/wood
	hammers_per_item = 8
	i_type = "工具"

/datum/artificer_recipe/bronze/tools
	name = "青铜提灯 3x"
	created_item = list(/obj/item/flashlight/flare/torch/lantern/bronzelamptern,/obj/item/flashlight/flare/torch/lantern/bronzelamptern,/obj/item/flashlight/flare/torch/lantern/bronzelamptern)
	hammers_per_item = 9
	skill_level = 3
	i_type = "工具"

/datum/artificer_recipe/bronze/tools/wrench
	name = "工程扳手 (+1 齿轮)"
	created_item = /obj/item/contraption/linker
	additional_items = list(/obj/item/roguegear/bronze)
	skill_level = 0
	hammers_per_item = 5

/datum/artificer_recipe/bronze/tools/headhook
	name = "头钩 (+2 纤维)"
	created_item = /obj/item/storage/hip/headhook/bronze
	additional_items = list(/obj/item/natural/fibers, /obj/item/natural/fibers)
	skill_level = 3

/datum/artificer_recipe/bronze/tools/waterpurifier
	name = "自净水袋 (+1 水袋)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/reagent_containers/glass/bottle/waterskin/purifier
	additional_items = list(/obj/item/reagent_containers/glass/bottle/waterskin)

/datum/artificer_recipe/bronze/tools/grappler
	name = "抓钩发射器 (+1 铁镐)(+2 青铜齿轮)(+1 绳子)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/grapplinghook
	additional_items = list(/obj/item/rogueweapon/pick, /obj/item/roguegear/bronze, /obj/item/roguegear/bronze, /obj/item/rope)
	skill_level = 4

// --------- Contraptions -----------

/datum/artificer_recipe/contraptions
	i_type = "装置"

/datum/artificer_recipe/contraptions/serfstone
	name = "农奴石 (+1 齿轮, +1 Topar)"
	required_item = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/roguegem/yellow) //using topar since the description calls it a "dull gem"
	created_item = /obj/item/scomstone/bad
	skill_level = 5

/datum/artificer_recipe/contraptions/houndstone
	name = "猎犬石 (+1 齿轮, +1 Topar)"
	required_item = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/roguegem/yellow)
	created_item = /obj/item/scomstone/bad/garrison
	skill_level = 5

/datum/artificer_recipe/contraptions/scomstone
	name = "SCOM传讯网 石 (+1 齿轮, +1 翠晶, Arcyne)"
	required_item = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/roguegem/green)
	created_item = /obj/item/scomstone
	skill_level = 5

/datum/artificer_recipe/contraptions/emeraldchoker
	name = "绿宝石项圈 (+1 齿轮, +黄金, +1 翠晶, Arcyne)"
	required_item = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/ingot/gold, /obj/item/roguegem/green)
	created_item = /obj/item/listenstone
	skill_level = 5

/datum/artificer_recipe/contraptions/folding_table
	name = "折叠桌 (+1 小原木)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/contraption/folding_table_stored
	hammers_per_item = 5
	skill_level = 1

/datum/artificer_recipe/contraptions/folding_alchcauldron
	name = "折叠坩埚架 (+1 小原木, +石锅, +锡)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/reagent_containers/glass/bucket/pot/stone, /obj/item/ingot/tin)
	created_item = /obj/item/folding_table_stored/alchcauldron
	skill_level = 3

/datum/artificer_recipe/contraptions/folding_alchstation_stored
	name = "炼金站工具包 (+2 小原木, +瓶子, +齿轮)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/reagent_containers/glass/bottle, /obj/item/roguegear)
	created_item = /obj/item/folding_table_stored/alchstation
	skill_level = 3

/datum/artificer_recipe/contraptions/mess_kit
	name = "行军炊具 (+2 铁)" // 3 Iron, cuz you get a pot, a pan and other things for free.
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/storage/gadget/messkit
	hammers_per_item = 5
	skill_level = 2

/datum/artificer_recipe/contraptions/mobilestove
	name = "便携炉 (+齿轮 +锡)" // capitalized to fall in line with the rest of engineering recipes T_T
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/ingot/tin)
	created_item = /obj/item/mobilestove
	hammers_per_item = 10
	skill_level = 3

/datum/artificer_recipe/contraptions/shears
	name = "截肢剪 (+2 青铜)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze = 2)
	created_item = /obj/item/contraption/shears
	hammers_per_item = 7
	skill_level = 4

/datum/artificer_recipe/contraptions/metalizer
	name = "木转金属器 (+1 木制齿轮)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/roguegear/wood/basic = 1)
	created_item = /obj/item/contraption/wood_metalizer
	hammers_per_item = 12
	skill_level = 4

/datum/artificer_recipe/contraptions/smelter
	name = "便携熔炉 (+1 煤炭)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/rogueore/coal = 1)
	created_item = /obj/item/contraption/smelter
	hammers_per_item = 10
	skill_level = 3

/datum/artificer_recipe/contraptions/imprinter
	name = "锁印器 (+1 可靠木制齿轮)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/roguegear/wood/reliable = 1)
	created_item = /obj/item/contraption/lock_imprinter
	hammers_per_item = 12
	skill_level = 4


/datum/artificer_recipe/contraptions/smokebombs
	name = "烟雾弹 (3x) (+1 煤炭)"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/rogueore/coal = 1)
	created_item = list(/obj/item/bomb/smoke,
						/obj/item/bomb/smoke,
						/obj/item/bomb/smoke)
	hammers_per_item = 12
	skill_level = 3

/datum/artificer_recipe/contraptions/orestore
	name = "机械矿袋，青铜 (+1 麻袋, +1 齿轮)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/storage/hip/orestore/bronze
	hammers_per_item = 12
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/storage/roguebag)
	skill_level = 3

/datum/artificer_recipe/contraptions/artificerarmor
	name = "工匠护甲 (+3 吉尔青铜, +2 青铜齿轮)"
	required_item = /obj/item/ingot/gilbranze
	additional_items = list(/obj/item/ingot/gilbranze,/obj/item/ingot/gilbranze, /obj/item/roguegear/bronze,/obj/item/roguegear/bronze)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/ancient/artificer
	hammers_per_item = 12
	skill_level = 4

/datum/artificer_recipe/contraptions/volticgauntlet
	name = "伏特护手 (+1 锡锭)(+2 青铜齿轮)(+1 cinnabar ore)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/roguegear/bronze,/obj/item/ingot/tin, /obj/item/rogueore/cinnabar)
	created_item = /obj/item/clothing/gloves/roguetown/contraption/voltic
	hammers_per_item = 12
	skill_level = 4

/datum/artificer_recipe/contraptions/coolingbackpack
	name = "冷却背包 (+1 青铜齿轮, +背包)" // why are these recipes capitalized differently than every other crafting recipe my ocddddddddddd
	required_item = /obj/item/ingot/bronze
	created_item =  /obj/item/storage/backpack/rogue/artibackpack
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/storage/backpack/rogue/backpack)
	skill_level = 5

/datum/artificer_recipe/contraptions/cursed_collar // lets people make the actual cursed collar, but gates it behind semi rare mats and engineering 
	name = "真诅咒项圈 (+1 青铜齿轮, +1 Essence of Wilderness)"
	required_item = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/natural/cured/essence)
	created_item = /obj/item/clothing/neck/roguetown/cursed_collar
	hammers_per_item = 14
	skill_level = 5
// --------- WEAPON -----------

/datum/artificer_recipe/wood/weapons //Again, a bit silly, but is important
	name = "木杖 (+1 木板)"
	created_item = /obj/item/rogueweapon/woodstaff
	additional_items = list(/obj/item/natural/wood/plank = 1)
	hammers_per_item = 3
	i_type = "武器"

/datum/artificer_recipe/wood/weapons/bow // easier recipe for bows
	name = "木弓 (+1 纤维) (+1 木板)"
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	hammers_per_item = 3
	additional_items = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/fibers = 1)

/datum/artificer_recipe/wood/weapons/wsword
	name = "木剑 (+1 木板)"
	created_item = /obj/item/rogueweapon/mace/wsword
	additional_items = list(/obj/item/natural/wood/plank = 1)
	hammers_per_item = 3

/datum/artificer_recipe/wood/weapons/wdagger

	name = "木匕首 (3x) (+1 木板)"
	created_item = list(/obj/item/rogueweapon/huntingknife/idagger/wood,
						/obj/item/rogueweapon/huntingknife/idagger/wood,
						/obj/item/rogueweapon/huntingknife/idagger/wood
						)
	additional_items = list(/obj/item/natural/wood/plank = 1)
	hammers_per_item = 2

/datum/artificer_recipe/wood/weapons/wshield
	name = "木盾 (+1 木板)"
	created_item = /obj/item/rogueweapon/shield/wood/crafted
	additional_items = list(/obj/item/natural/wood/plank = 1)
	hammers_per_item = 6
	skill_level = 2

/obj/item/rogueweapon/shield/wood/crafted
	sellprice = 6

/datum/artificer_recipe/wood/weapons/hshield
	name = "鸢形盾 (+1 熟皮)"
	created_item = /obj/item/rogueweapon/shield/heater/crafted
	additional_items = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/hide/cured = 1)
	hammers_per_item = 6
	skill_level = 3

/obj/item/rogueweapon/shield/heater/crafted
	sellprice = 6

/datum/artificer_recipe/wood/weapons/steamshield
	name = "蒸汽盾 (+1 木板)(+2 青铜齿轮)(+2 青铜锭)"
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/roguegear/bronze,/obj/item/natural/wood/plank, /obj/item/ingot/bronze,/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/shield/steam
	hammers_per_item = 12
	skill_level = 3

/// CROSSBOW

/datum/artificer_recipe/wood/weapons/crossbow
	name = "弩 (+1 钢) (+1 纤维)"
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/fibers)
	hammers_per_item = 10
	skill_level = 4

// --------- AMMUNITION -----------

/datum/artificer_recipe/ammunition
	i_type = "弹药"

/datum/artificer_recipe/ammunition/bolts
	name = "弩箭 20x (+2 木板, +1 铁)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/natural/wood/plank, /obj/item/natural/wood/plank, /obj/item/ingot/iron)
	created_item = list(/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt
					)
	hammers_per_item = 6
	skill_level = 2

/datum/artificer_recipe/ammunition/arrows
	name = "箭矢 20x (+2 木板, +1 铁)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/natural/wood/plank, /obj/item/natural/wood/plank,  /obj/item/ingot/iron)
	created_item = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron
					)
	hammers_per_item = 6
	skill_level = 2

/datum/artificer_recipe/ammunition/pyrobolt_five
	name = "火碎弩箭 x5 (+1 铁) (+1 fyritius)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/ingot/iron, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius)
	created_item = list(
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro,
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro,
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro,
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro,
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro
				)
	hammers_per_item = 6
	skill_level = 2


/datum/artificer_recipe/ammunition/pyroarrow_five
	name = "火碎箭 x5 (+1 铁) (+1 fyritius)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/ingot/iron, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius)
	created_item = list(
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro,
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro,
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro,
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro,
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro
				)
	hammers_per_item = 6
	skill_level = 2

/datum/artificer_recipe/ammunition/lead_ball
	name = "铅弹 x8 (+2 铁)"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = list(//Enough for a pouch.
				/obj/item/ammo_casing/caseless/bullet/lead,
				/obj/item/ammo_casing/caseless/bullet/lead,
				/obj/item/ammo_casing/caseless/bullet/lead,
				/obj/item/ammo_casing/caseless/bullet/lead,
				/obj/item/ammo_casing/caseless/bullet/lead,
				/obj/item/ammo_casing/caseless/bullet/lead,
				/obj/item/ammo_casing/caseless/bullet/lead,
				/obj/item/ammo_casing/caseless/bullet/lead,
				)
	hammers_per_item = 6
	skill_level = 4

/datum/artificer_recipe/ammunition/grapeshot
	name = "葡萄弹 x8 (+3 铁)"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = list(
				/obj/item/ammo_casing/caseless/bullet/grapeshot,
				/obj/item/ammo_casing/caseless/bullet/grapeshot,
				/obj/item/ammo_casing/caseless/bullet/grapeshot,
				/obj/item/ammo_casing/caseless/bullet/grapeshot,
				/obj/item/ammo_casing/caseless/bullet/grapeshot,
				/obj/item/ammo_casing/caseless/bullet/grapeshot,
				/obj/item/ammo_casing/caseless/bullet/grapeshot,
				/obj/item/ammo_casing/caseless/bullet/grapeshot,
				)
	hammers_per_item = 6
	skill_level = 4

// --------- PROSTHETICS -----------

/datum/artificer_recipe/prosthetics
	i_type = "义肢"

/datum/artificer_recipe/prosthetics/wood/arm_left
	name = "左木臂 (+2 木板) (+1 木制齿轮)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/natural/wood/plank = 2, /obj/item/roguegear/wood/basic = 1)
	created_item = /obj/item/bodypart/l_arm/prosthetic/woodleft
	hammers_per_item = 4
	skill_level = 2

/datum/artificer_recipe/prosthetics/wood/arm_right
	name = "右木臂 (+2 木板) (+1 木制齿轮)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/natural/wood/plank = 2, /obj/item/roguegear/wood/basic = 1)
	created_item = /obj/item/bodypart/r_arm/prosthetic/woodright
	hammers_per_item = 4
	skill_level = 2

/datum/artificer_recipe/prosthetics/wood/leg_left
	name = "左木腿 (+2 木板) (+1 木制齿轮)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/natural/wood/plank = 2, /obj/item/roguegear/wood/basic = 1)
	created_item = /obj/item/bodypart/l_leg/prosthetic
	hammers_per_item = 4
	skill_level = 2

/datum/artificer_recipe/prosthetics/wood/leg_right
	name = "右木腿 (+2 木板) (+1 木制齿轮)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/natural/wood/plank = 2, /obj/item/roguegear/wood/basic = 1)
	created_item = /obj/item/bodypart/r_leg/prosthetic
	hammers_per_item = 4
	skill_level = 2

// --------- BRONZE -----------

/datum/artificer_recipe/bronze/prosthetic
	name = "青铜义肢 (+1 齿轮)"
	created_item = /obj/item/contraption/bronzeprosthetic
	hammers_per_item = 15
	skill_level = 4
	additional_items = list(/obj/item/roguegear/bronze = 1)
	i_type = "义肢"

// --------- GOLD -----------

/datum/artificer_recipe/gold/prosthetic
	name = "金制义肢 (+2 齿轮)"
	required_item = /obj/item/ingot/gold
	created_item = /obj/item/contraption/goldprosthetic
	additional_items = list(/obj/item/roguegear/bronze,/obj/item/roguegear/bronze)
	hammers_per_item = 20
	skill_level = 5
	i_type = "义肢"

// --------- STEEL -----------

/datum/artificer_recipe/steel/prosthetic
	name = "钢制义肢 (+1 钢, +1 齿轮)"
	created_item = /obj/item/contraption/steelprosthetic
	required_item = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel = 1, /obj/item/roguegear/bronze = 1)
	hammers_per_item = 15
	skill_level = 4
	i_type = "义肢"

// --------- IRON -----------

/datum/artificer_recipe/iron/prosthetic //These are the inexpensive alternatives
	name = "铁制义肢 (+1 木板) (+1 齿轮)"
	created_item = /obj/item/contraption/ironprosthetic
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/wood/plank = 1, /obj/item/roguegear/bronze = 1)
	hammers_per_item = 4
	skill_level = 2
	i_type = "义肢"

// ------------ Explosives expansion----------
/datum/artificer_recipe/general
	i_type = "通用"


/datum/artificer_recipe/general/tntbomb
	name = "火药棒"
	required_item = /obj/item/rogueore/coal
	additional_items = list(/obj/item/paper/scroll,
							/obj/item/alch/coaldust,
							/obj/item/alch/coaldust,
							/obj/item/alch/airdust,
							/obj/item/alch/airdust,
							/obj/item/alch/firedust,
							/obj/item/alch/firedust)
	created_item = /obj/item/tntstick
	hammers_per_item = 5
	skill_level = 4

/datum/artificer_recipe/general/satchelbomb
	name = "火药包"
	required_item = /obj/item/storage/backpack/rogue/satchel
	additional_items = list(/obj/item/tntstick,
							/obj/item/tntstick,
							/obj/item/tntstick)
	created_item = /obj/item/satchel_bomb
	hammers_per_item = 5
	skill_level = 5

/datum/artificer_recipe/general/smokebomb
	name = "喷气枪弹 (x3) (+齿轮)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/roguegear)
	created_item = list(/obj/item/smokeshell,
						/obj/item/smokeshell,
						/obj/item/smokeshell)
	skill_level = 3
	hammers_per_item = 5
