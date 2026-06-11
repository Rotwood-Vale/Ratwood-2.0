/datum/advclass/slaver/slave/service
	name = "侍役奴隶"
	tutorial = "你是不幸的奴隶，自故乡被掳走，带往 兹班图 接受奴工与顺从训练，久到你几乎只能模糊记得从前的自己……如今你正被从沙漠押往更残酷的土地，等待被售卖。"
	outfit = /datum/outfit/job/roguetown/slaver/slave/service
	traits_applied = list(TRAIT_GOODLOVER, TRAIT_EMPATH, TRAIT_BEAUTIFUL, TRAIT_OUTLANDER)
	category_tags = list(CTAG_SLAVER_SLAVE)

	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_SPD = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/fishing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/tanning = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,	
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/slaver/slave/service/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
	neck = /obj/item/clothing/neck/roguetown/cursed_collar
	belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt
	beltl = /obj/item/storage/belt/rogue/pouch
	beltr = /obj/item/flint
	shoes = /obj/item/clothing/shoes/roguetown/anklets
	mask = /obj/item/clothing/mask/rogue/exoticsilkmask
	backl = /obj/item/storage/backpack/rogue/satchel/short
	backpack_contents = list(
		/obj/item/soap/bath = 1,
		/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat = 1,
		/datum/supply_pack/rogue/alcohol/elfred = 1, 
	)
	H.virginity = TRUE
	H.cmode_music = 'sound/music/combat_zybantine.ogg'
	var/background = list("贵族（+阅读）", "平民（+2 幸运）")
	var/background_choice = input(H, "选择你的出身。", "出身抉择") as anything in background
	switch(background_choice)
		if("贵族（+阅读）")
			ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_EXPERT, TRUE)
		if("平民（+2 幸运）")
			H.change_stat(STATKEY_LCK, 2)

/datum/advclass/slaver/slave/battle
	name = "战斗奴隶"
	tutorial = "你是不幸的奴隶，自故乡被掳走，带往 兹班图 接受奴工与顺从训练，久到你几乎只能模糊记得从前的自己……如今你正被从沙漠押往更残酷的土地，等待被售卖。"
	outfit = /datum/outfit/job/roguetown/slaver/slave/battle
	traits_applied = list(TRAIT_GOODLOVER, TRAIT_BREADY, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_SLAVER_SLAVE)

	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 3,
		STATKEY_LCK = -1,
	)

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/music = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,	
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/slaver/slave/battle/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
	neck = /obj/item/clothing/neck/roguetown/cursed_collar
	belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt
	beltl = /obj/item/storage/belt/rogue/pouch
	beltr = /obj/item/flint
	shoes = /obj/item/clothing/shoes/roguetown/anklets
	mask = /obj/item/clothing/mask/rogue/exoticsilkmask
	backl = /obj/item/storage/backpack/rogue/satchel/short
	backpack_contents = list(
		/obj/item/soap/bath = 1,
	)
	H.virginity = TRUE
	H.cmode_music = 'sound/music/combat_zybantine.ogg'
	var/armor = list("中甲（+2 体质，+1 意志）", "闪避专家（+2 速度）")
	var/armor_choice = input(H, "选择你的防具。", "披挂迎战") as anything in armor
	switch(armor_choice)
		if("中甲（+2 体质，+1 意志）")
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			H.change_stat(STATKEY_CON, 2)
			H.change_stat(STATKEY_WIL, 1)
		if("闪避专家（+2 速度）")
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			H.change_stat(STATKEY_SPD, 2)
	var/weapon = list("刀剑", "鞭与链枷", "长柄武器", "钉锤", "战斧", "弓与弩", "拳头！！！")
	var/weapon_choice = input(H, "选择你的武器。", "披挂迎战") as anything in weapon
	switch(weapon_choice)
		if("刀剑")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("鞭与链枷")
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
		if("长柄武器")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("钉锤")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
		if("战斧")
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
		if("弓与弩")
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_PER, 2)
		if("拳头！！！")
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			H.change_stat(STATKEY_STR, 1)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
	var/background = list("贵族（+阅读）", "平民（+2 幸运）")
	var/background_choice = input(H, "选择你的出身。", "披挂迎战") as anything in background
	switch(background_choice)
		if("贵族（+阅读）")
			ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_EXPERT, TRUE)
		if("平民（+2 幸运）")
			H.change_stat(STATKEY_LCK, 2)


/datum/advclass/slaver/slave/arcyne
	name = "奥术奴隶"
	tutorial = "你是不幸的奴隶，自故乡被掳走，带往 兹班图 接受奴工与顺从训练，久到你几乎只能模糊记得从前的自己……如今你正被从沙漠押往更残酷的土地，等待被售卖。"
	outfit = /datum/outfit/job/roguetown/slaver/slave/arcyne
	traits_applied = list(TRAIT_GOODLOVER, TRAIT_ARCYNE_T3, TRAIT_OUTLANDER)
	category_tags = list(CTAG_SLAVER_SLAVE)

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/slaver/slave/arcyne/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
	neck = /obj/item/clothing/neck/roguetown/cursed_collar
	belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt
	beltl = /obj/item/storage/belt/rogue/pouch
	beltr = /obj/item/storage/magebag/associate
	shoes = /obj/item/clothing/shoes/roguetown/anklets
	mask = /obj/item/clothing/mask/rogue/exoticsilkmask
	backl = /obj/item/storage/backpack/rogue/satchel/short
	backr = /obj/item/rogueweapon/woodstaff/emerald
	gloves = /obj/item/clothing/gloves/roguetown/nomagic
	backpack_contents = list(
		/obj/item/soap/bath = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/roguegem/amethyst = 1, 
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
	)
	H.virginity = TRUE
	H.cmode_music = 'sound/music/combat_zybantine.ogg'
	if(H.mind)
		H?.mind.adjust_spellpoints(24)
	var/background = list("贵族（+阅读）", "平民（+2 幸运）")
	var/background_choice = input(H, "选择你的出身。", "披挂迎战") as anything in background
	switch(background_choice)
		if("贵族（+阅读）")
			ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_EXPERT, TRUE)
		if("平民（+2 幸运）")
			H.change_stat(STATKEY_LCK, 2)

/datum/advclass/slaver/slave/craftsman
	name = "工匠奴隶"
	tutorial = "你是不幸的奴隶，自故乡被掳走，带往 兹班图 接受奴工与顺从训练，久到你几乎只能模糊记得从前的自己……如今你正被从沙漠押往更残酷的土地，等待被售卖。"
	outfit = /datum/outfit/job/roguetown/slaver/slave/craftsman
	traits_applied = list(TRAIT_GOODLOVER, TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT, TRAIT_OUTLANDER)
	category_tags = list(CTAG_SLAVER_SLAVE)

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_MASTER, //One level above Towner Smiths
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/smelting = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/slaver/slave/craftsman/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
	neck = /obj/item/clothing/neck/roguetown/cursed_collar
	belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt
	beltl = /obj/item/storage/belt/rogue/pouch
	shoes = /obj/item/clothing/shoes/roguetown/anklets
	mask = /obj/item/clothing/mask/rogue/exoticsilkmask
	backl = /obj/item/storage/backpack/rogue/satchel/short
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	backpack_contents = list(
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/rogueweapon/tongs = 1,
		/obj/item/flint = 1,
		/obj/item/soap/bath = 1,
	)
	H.virginity = TRUE
	H.cmode_music = 'sound/music/combat_zybantine.ogg'
	if(H.mind)
		H?.mind.adjust_spellpoints(24)
	var/background = list("贵族（+阅读）", "平民（+2 幸运）")
	var/background_choice = input(H, "选择你的出身。", "披挂迎战") as anything in background
	switch(background_choice)
		if("贵族（+阅读）")
			ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_EXPERT, TRUE)
		if("平民（+2 幸运）")
			H.change_stat(STATKEY_LCK, 2)
