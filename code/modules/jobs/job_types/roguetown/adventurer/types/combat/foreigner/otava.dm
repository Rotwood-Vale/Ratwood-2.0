/datum/advclass/foreigner/repentant
	name = "Otavan Repentant"
	tutorial = "An exile from the Holy See of Otava, accused of heresy and cast out of your homeland as penance. \
	Some consider yours a fate worse than death; the metal alloy mask seared onto your face serving as a permanent reminder of your sins. \
	You are a living example of what becomes of those who stand in defiance of the Otavan inquisition."
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
	to_chat(H, span_warning("An exile from the Holy See of Otava, accused of heresy and cast out of your homeland as penance. \
	Some consider yours a fate worse than death; the metal alloy mask seared onto your face serving as a permanent reminder of your sins. \
	You are a living example of what becomes of those who stand in defiance of the Otavan inquisition."))
	mask = /obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched
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
