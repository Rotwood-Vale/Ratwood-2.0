/datum/advclass/foreigner/repentant
	name = "奥塔瓦 忏悔者"
	tutorial = "你是来自 奥塔瓦 教廷的流亡者，因异端之罪被逐出故土，以此作为赎罚。\
	有些人觉得你的下场比死亡更惨；那副烙在脸上的合金面具，便是你罪孽永不磨灭的印记。\
	你活生生地证明了，反抗 Otava 宗教审判之人最终会落得何等下场。"
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/repentant
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)//No licker. Intentional.
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_SPD = -1,
		STATKEY_STR = -1,
		STATKEY_WIL = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/adventurer/repentant/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是来自 奥塔瓦 教廷的流亡者，因异端之罪被逐出故土，以此作为赎罚。\
	有些人觉得你的下场比死亡更惨；那副烙在脸上的合金面具，便是你罪孽永不磨灭的印记。\
	你活生生地证明了，反抗 Otava 宗教审判之人最终会落得何等下场。"))
	mask = /obj/item/clothing/mask/rogue/facemask/ancient/mad_touched
	wrists = /obj/item/clothing/neck/roguetown/psicross
	shirt = /obj/item/clothing/cloak/psydontabard
	gloves = /obj/item/clothing/gloves/roguetown/chain/psydon
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	belt = /obj/item/storage/belt/rogue/leather/rope/dark
	head = /obj/item/clothing/head/roguetown/roguehood/psydon
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/whip
	backpack_contents = list(/obj/item/rogueweapon/huntingknife = 1)
