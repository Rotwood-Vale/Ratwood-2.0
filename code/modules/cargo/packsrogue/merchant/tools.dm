/datum/supply_pack/rogue/tools/soft_tallow
	name = "软兽脂"
	cost = 20
	contains = list(
		/obj/item/reagent_containers/food/snacks/tallow/soft,
	)

/datum/supply_pack/rogue/tools
	group = "Tools"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/tools/scomst
	name = "SCOM传讯石"
	cost = 120
	contains = list(/obj/item/scomstone)

/datum/supply_pack/rogue/tools/serfst
	name = "农奴传讯石"
	cost = 40
	contains = list(/obj/item/scomstone/bad)

/datum/supply_pack/rogue/tools/chains
	name = "铁链"
	cost = 15
	contains = list(
					/obj/item/rope/chain,
					/obj/item/rope/chain,
					/obj/item/rope/chain,
				)

/datum/supply_pack/rogue/tools/lockpicks
	name = "开锁器"
	cost = 20
	contains = list(/obj/item/lockpickring/mundane)

/datum/supply_pack/rogue/tools/sacks
	name = "麻袋"
	cost = 10
	contains = list(
					/obj/item/storage/roguebag,
					/obj/item/storage/roguebag,
					/obj/item/storage/roguebag,
				)

/datum/supply_pack/rogue/tools/paper
	name = "纸张"
	cost = 20
	contains = list(
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
					/obj/item/paper/scroll,
				)

/datum/supply_pack/rogue/tools/flint
	name = "燧石"
	cost = 15
	contains = list(
					/obj/item/flint,
					/obj/item/flint,
					/obj/item/flint,
				)

/datum/supply_pack/rogue/tools/pipes
	name = "烟斗"
	cost = 15
	contains = list(
					/obj/item/clothing/mask/cigarette/pipe,
					/obj/item/clothing/mask/cigarette/pipe,
					/obj/item/clothing/mask/cigarette/pipe/westman
				)

/datum/supply_pack/rogue/tools/bait
	name = "高级鱼饵"
	cost = 15
	contains = list(
					/obj/item/natural/worms/grubs,
					/obj/item/natural/worms/grubs,
					/obj/item/natural/worms/leech,
					/obj/item/natural/worms/leech,
					/obj/item/natural/worms/leech,
				)

/datum/supply_pack/rogue/tools/prarml
	name = "木制义肢手臂（左）"
	cost = 40
	contains = list(/obj/item/bodypart/l_arm/prosthetic/woodleft)

/datum/supply_pack/rogue/tools/prarmr
	name = "木制义肢手臂（右）"
	cost = 40
	contains = list(/obj/item/bodypart/r_arm/prosthetic/woodright)

/datum/supply_pack/rogue/tools/prlegl
	name = "木制义肢腿（左）"
	cost = 15
	contains = list(/obj/item/bodypart/l_leg/prosthetic)

/datum/supply_pack/rogue/tools/prlegr
	name = "木制义肢腿（右）"
	cost = 15
	contains = list(/obj/item/bodypart/r_leg/prosthetic)

/datum/supply_pack/rogue/tools/hoe
	name = "锄头"
	cost = 10
	contains = list(/obj/item/rogueweapon/hoe,)

/datum/supply_pack/rogue/tools/thresher
	name = "打谷器"
	cost = 10
	contains = list(/obj/item/rogueweapon/thresher,)

/datum/supply_pack/rogue/tools/sickle
	name = "镰刀"
	cost = 10
	contains = list(/obj/item/rogueweapon/sickle,)

/datum/supply_pack/rogue/tools/pfork
	name = "干草叉"
	cost = 10
	contains = list(/obj/item/rogueweapon/pitchfork,)


/datum/supply_pack/rogue/tools/plough
	name = "犁"
	cost = 50
	contains = list(/obj/structure/plough,)

/datum/supply_pack/rogue/tools/ironpick
	name = "铁镐"
	cost = 10
	contains = list(/obj/item/rogueweapon/pick,)

/datum/supply_pack/rogue/tools/soapps
	name = "肥皂"
	cost = 10
	contains = list(/obj/item/soap)

/datum/supply_pack/rogue/tools/herbsoap
	name = "草药皂"
	cost = 20
	contains = list(/obj/item/soap/bath)

/datum/supply_pack/rogue/tools/keyrings
	name = "钥匙圈"
	cost = 20
	contains = list(/obj/item/storage/keyring,
					/obj/item/storage/keyring,
					/obj/item/storage/keyring)

/datum/supply_pack/rogue/tools/scythe
	name = "长柄镰刀"
	cost = 25
	contains = list(/obj/item/rogueweapon/scythe)

/datum/supply_pack/rogue/tools/handsaw
	name = "手锯"
	cost = 35
	contains = list(/obj/item/rogueweapon/handsaw)

/datum/supply_pack/rogue/tools/handsaw
	name = "凿子"
	cost = 35
	contains = list(/obj/item/rogueweapon/chisel)

/datum/supply_pack/rogue/tools/hammer
	name = "锤子"
	cost = 35
	contains = list(/obj/item/rogueweapon/hammer/iron)

/datum/supply_pack/rogue/tools/fryingpan
	name = "平底锅"
	cost = 20
	contains = list(/obj/item/cooking/pan)

/datum/supply_pack/rogue/tools/tallowpot
	name = "兽脂锅"
	cost = 20
	contains = list(/obj/item/inqarticles/tallowpot)

/datum/supply_pack/rogue/tools/shopkeyy
	name = "备用店铺钥匙"
	cost = 10
	not_in_public = TRUE
	contains = list(/obj/item/roguekey/shop)

/datum/supply_pack/rogue/tools/alch_bottle
	name = "瓶子（炼金小瓶）"
	cost = 1
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical,)

/datum/supply_pack/rogue/tools/alch_bottles
	name = "瓶子（炼金小瓶，大宗装）" //Buy 8 now get 1 free!
	cost = 8
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical,/obj/item/reagent_containers/glass/bottle/alchemical,/obj/item/reagent_containers/glass/bottle/alchemical,
	/obj/item/reagent_containers/glass/bottle/alchemical,/obj/item/reagent_containers/glass/bottle/alchemical,/obj/item/reagent_containers/glass/bottle/alchemical,
	/obj/item/reagent_containers/glass/bottle/alchemical,/obj/item/reagent_containers/glass/bottle/alchemical,/obj/item/reagent_containers/glass/bottle/alchemical)


/datum/supply_pack/rogue/tools/alch_bottlenormal
	name = "瓶子"
	cost = 3
	contains = list(/obj/item/reagent_containers/glass/bottle,)

/datum/supply_pack/rogue/tools/alch_bottlesnormal
	name = "瓶子（大宗装）" //buy 4 get 1 free
	cost = 12
	contains = list(/obj/item/reagent_containers/glass/bottle/,/obj/item/reagent_containers/glass/bottle/,/obj/item/reagent_containers/glass/bottle/,
	/obj/item/reagent_containers/glass/bottle/,/obj/item/reagent_containers/glass/bottle/)

/datum/supply_pack/rogue/tools/headhook
	name = "铁制头颅钩"
	cost = 10
	contains = list(/obj/item/storage/hip/headhook)

/datum/supply_pack/rogue/tools/bottle_kit
	name = "装瓶套件"
	cost = 50
	contains = list(/obj/item/bottle_kit)

/datum/supply_pack/rogue/tools/surgeonsbag
	name = "满配外科包"
	cost = 80
	contains = list(/obj/item/storage/belt/rogue/surgery_bag)

/datum/supply_pack/rogue/tools/spade
	name = "木铲"
	cost = 5
	contains = list(/obj/item/rogueweapon/shovel/small)

/datum/supply_pack/rogue/tools/shovel
	name = "铁锹"
	cost = 20
	contains = list(/obj/item/rogueweapon/shovel)

/datum/supply_pack/rogue/tools/golem_upgrades
	name = "魔像技能展示器"
	cost = 35
	contains = list(/obj/item/construct_skill_core)

/datum/supply_pack/rogue/tools/scissors
	name = "铁剪刀"
	cost = 30
	contains = list(/obj/item/rogueweapon/huntingknife/scissors)
