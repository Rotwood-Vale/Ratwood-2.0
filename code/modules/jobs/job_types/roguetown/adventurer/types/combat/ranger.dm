/datum/advclass/ranger
	name = "守望者"
	tutorial = "你是一名熟谙荒野行路之道的游侠，多年来一直在常规兵卒难以涉足的蛮荒之地，接些向导与护卫的零活谋生。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/ranger
	class_select_category = CLASS_CAT_RANGER
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_OUTDOORSMAN)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/ranger/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名熟谙荒野行路之道的游侠，多年来一直在常规兵卒难以涉足的蛮荒之地，接些向导与护卫的零活谋生。"))
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	cloak = /obj/item/clothing/cloak/raincloak/green
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/bait = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.mind)
		var/weapons = list("反曲弓","十字弩")
		var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("反曲弓")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltl = /obj/item/quiver/arrows
			if("十字弩")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/quiver/bolts

/datum/advclass/ranger/wayfarer
	name = "远行客"
	tutorial = "你花了无数年头打磨许多本事：追捕活人、撬锁开门、闯进那些你本不该进去的地方……但你并非寻常毛贼。你受过专门训练，擅长追踪目标、追回赃物。而谷地，正是一桩肥差。"
	outfit = /datum/outfit/job/roguetown/adventurer/assassin
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander.ogg'
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/assassin/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你过的是受雇杀手的日子，刀刃与十字弩两样兵器都磨炼多年。"))
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel
	beltr = /obj/item/quiver/bolts
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.set_blindness(0)

/datum/advclass/ranger/bombadier
	name = "掷弹手"
	tutorial = "炸弹？你有，多得很，而且还懂得怎么再做更多。你跟着高明的炼金师学了多年，已经摸索出制造混乱的绝妙配方。现在，去炸点什么吧！"
	outfit = /datum/outfit/job/roguetown/adventurer/bombadier
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ALCHEMY_EXPERT) // Bombardier get an exception - alchemy is part of the gimmick.
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/bombadier/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("炸弹？你有，多得很，而且还懂得怎么再做更多。你跟着高明的炼金师学了多年，已经摸索出制造混乱的绝妙配方。现在，去炸点什么吧！"))
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	head = /obj/item/clothing/head/roguetown/roguehood
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mageorange
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/rogueweapon/mace/cudgel
	backpack_contents = list(
		/obj/item/bomb = 4,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.set_blindness(0)

/datum/advclass/ranger/bwanderer
	name = "地貌行者"
	tutorial = "荒野的险恶会随着地貌不同而变化，而你恰好对其中许多都颇有经验。"
	outfit = /datum/outfit/job/roguetown/adventurer/bwanderer
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander4.ogg'
	traits_applied = list(TRAIT_OUTDOORSMAN)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE, // Base skill, if not wanted, pick another weapon.
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE, // On par with battlemaster.
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE, // Still a ranger, nerfed. Want more? Go do it yourself, buddy.
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE, // Won't really equate to much.
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "选择轻甲可获得 +1 速度。选择中甲则会在获得对应特质的同时，额外得到 +1 力量。"

/datum/outfit/job/roguetown/adventurer/bwanderer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("荒野的险恶会随着地貌不同而变化，而你恰好对其中许多都颇有经验。"))
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	cloak = /obj/item/clothing/cloak/raincloak/green
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut // Technical main weapon?
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.mind)
		var/weapons = list("反曲弓","钩镰枪","投石索","十字弩")
		var/weapon_choice = input(H, "选择你的武器。", "整装备战") as anything in weapons
		switch(weapon_choice)
			if("反曲弓")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltl = /obj/item/quiver/arrows
			if("钩镰枪") // Debatable here, but we love variety.
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/billhook
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("投石索")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltl = /obj/item/quiver/sling/iron
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			if("十字弩") // Hunting crossbows were a thing in these times, shame we don't have an item for it.
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/quiver/bolts
		var/armors = list("轻甲","中甲")
		var/armor_choice = input(H, "选择你的护甲。", "整装备战") as anything in armors
		switch(armor_choice)
			if("轻甲")
				armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.change_stat(STATKEY_SPD, 1)
			if("中甲")
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				pants = /obj/item/clothing/under/roguetown/chainlegs/iron
				gloves = /obj/item/clothing/gloves/roguetown/chain/iron
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.change_stat(STATKEY_STR, 1)
				H.set_blindness(0)
