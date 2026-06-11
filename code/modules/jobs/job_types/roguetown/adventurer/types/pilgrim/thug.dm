/datum/advclass/thug
	name = "恶棍"
	tutorial = "也许你从来都不是镇上最聪明的那个人，但你还是混到了今天, 不管是替清道夫在镇里干些搬运脏活的零工，还是给别人当站在背后吓唬人的打手，又或者只是靠拳头或拳头的威胁去敲榨弱者。你大概也因为一些鸡毛蒜皮的小罪跟法律打过几次交道，但大家对你还算容忍，至少这里还有你一个落脚处。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_SEEPRICES_SHITTY, TRAIT_DRUNK_HEALING)
	category_tags = list(CTAG_TOWNER)
	cmode_music = 'sound/music/combat_bum.ogg'
	outfit = /datum/outfit/job/roguetown/adventurer/thug
	maximum_possible_slots = 8 // I dont want an army of towner thugs
	subclass_languages = list(/datum/language/thievescant)

/datum/outfit/job/roguetown/adventurer/thug/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	backpack_contents = list(/obj/item/reagent_containers/glass/bottle/rogue/beer = 1)

	var/classes = list("打手", "滑头", "大块头", "码头汉")
	var/classchoice = input(H, "你是哪种恶棍？", "拿起武器") as anything in classes

	switch(classchoice)

		if("打手")
			to_chat(H, span_warning("你是个打手，一个活在苦难世界里的下三滥恶棍, 打仗不够格，求安生又不够聪明。你地位上的不足，全靠胆气去弥补。"))
			H.set_blindness(0)

			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_CON, 3)
			H.change_stat(STATKEY_SPD, -1)
			H.change_stat(STATKEY_INT, -1)

			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			var/options = list("平底锅", "指虎", "纳瓦哈刀", "赤手空拳")
			var/option_choice = input(H, "选择你的家伙。", "拿起武器") as anything in options

			switch(option_choice)
				if("平底锅")
					H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/cooking/pan
				if("指虎")
					H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/rogueweapon/knuckles
				if("纳瓦哈刀")
					H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/rogueweapon/huntingknife/idagger/navaja
				if("赤手空拳")
					H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)

		if("滑头")
			to_chat(H, span_warning("你比其他人聪明了不止一点半点，而且你知道最好别总跟人贴脸拼命。和大多数同类不同，你还识字。"))
			H.set_blindness(0)

			H.change_stat(STATKEY_CON, -2)
			H.change_stat(STATKEY_SPD, 2)
			H.change_stat(STATKEY_INT, 2)

			ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)

			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)

			var/options = list("石索", "魔法砖块", "撬锁工具")
			var/option_choice = input(H, "选择你的手段。", "拿起武器") as anything in options

			switch(option_choice)
				if("石索")
					H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
					l_hand = /obj/item/quiver/sling
				if("魔法砖块")
					H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE)
					H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/magicians_brick)
				if("撬锁工具")
					H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_EXPERT, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_EXPERT, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_EXPERT, TRUE)
					ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
					r_hand = /obj/item/lockpickring/mundane

		if("大块头")
			to_chat(H, span_warning("你与其说是个正常人，不如说更像一头粮食喂大的怪物。你的体型与蛮力就是你最大的武器，虽然它们并不能补上你脑子里缺的那部分。"))
			H.set_blindness(0)

			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_HARDDISMEMBER, TRAIT_GENERIC)

			H.change_stat(STATKEY_STR, 3)
			H.change_stat(STATKEY_WIL, 2)
			H.change_stat(STATKEY_CON, 5)
			H.change_stat(STATKEY_SPD, -4)
			H.change_stat(STATKEY_INT, -6)
			H.change_stat(STATKEY_PER, -3)

			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking, SKILL_LEVEL_JOURNEYMAN, TRUE)

			var/options = list("徒手硬干", "大斧头", "大棒子")
			var/option_choice = input(H, "选择你的家伙。", "拿起武器") as anything in options

			switch(option_choice)
				if("徒手硬干")
					ADD_TRAIT(H, TRAIT_BASHDOORS, TRAIT_GENERIC)
					ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				if("大斧头")
					H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/greataxe
				if("大棒子")
					H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/mace

		if("码头汉")
			to_chat(H, span_warning("你年轻时回应了 阿比索尔 的呼唤，只不过走的是不怎么体面的路子，\
	见谁挡路就劫谁的财。如今你的船长要从罪恶生涯里抽身上岸，你也一样。不过陆地上，照样有钱可赚。"))
			H.set_blindness(0)

			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_WIL, 2)
			H.change_stat(STATKEY_CON, 2)
			H.change_stat(STATKEY_SPD, -1)
			H.change_stat(STATKEY_INT, -1)
			H.change_stat(STATKEY_PER, -1)

			head = /obj/item/clothing/head/roguetown/helmet/bandana
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
			pants = /obj/item/clothing/under/roguetown/trou/leather
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
			r_hand = /obj/item/rogueweapon/sword/cutlass
			beltr = /obj/item/rogueweapon/scabbard/sword
			beltl = /obj/item/rogueweapon/huntingknife/idagger

			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)

	var/gang = list("帮派 Rontz Ratz", "帮派 Blortz Volves", "算了")
	var/gang_choice = input(H, "想加入帮派吗？") as anything in gang

	switch(gang_choice)
		if("帮派 Rontz Ratz")
			to_chat(H, span_warning("我是街头帮派 隆兹石 Ratz 的一员，已经过去了太久太久，现在我们得重新壮大势力。\
			Blortz Volves 那帮杂种迟早得付出代价。\
			Rontz Rats 会咬人, 来感受这场恶斗吧！"))
			ADD_TRAIT(H, TRAIT_GANG_A, TRAIT_GENERIC)
			mask = /obj/item/clothing/mask/rogue/ragmask/red
		if("帮派 Blortz Volves")
			to_chat(H, span_warning("我是街头帮派 布洛兹石 Volves 的一员，已经过去了太久太久，现在我们得重新壮大势力。\
			Rontz Ratz 那帮杂种迟早得付出代价。 \
			Blortz Wolves 一嚎叫, 敌人就得发抖！"))
			ADD_TRAIT(H, TRAIT_GANG_B, TRAIT_GENERIC)
			mask = /obj/item/clothing/mask/rogue/ragmask/azure
		if("算了")
			return null
