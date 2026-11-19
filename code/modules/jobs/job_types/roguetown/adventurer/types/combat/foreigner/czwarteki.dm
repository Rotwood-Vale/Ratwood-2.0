/datum/advclass/foreigner/shepherd
	name = "Szöréndnížine Shepherd"
	tutorial = "You're a simple shepherd hailing from Aavnr's Free City of Czwarteka, taking a pilgrimage or having fled for one reason or another. You can easily fend for yourself in the wilderness, and with enough practice, fend for yourself in combat against even armoured opponents with your traditional axe."
	extra_context = "This class is for experienced adventurers with a solid grasp on footwork and stamina management. Your weapon has special intents you can juggle through to make fights easier... Sometimes."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	subclass_languages = list(/datum/language/aavnic)
	outfit = /datum/outfit/job/roguetown/adventurer/freishepherd
	traits_applied = list()
	cmode_music = 'sound/music/frei_shepherd.ogg'
	subclass_stats = list(
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
		STATKEY_CON = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/freishepherd/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/head/roguetown/paddedcap
	head = /obj/item/clothing/head/roguetown/chaperon/greyscale/shepherd
	neck = /obj/item/clothing/neck/roguetown/psicross/reform
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shepherd
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter/shepherd
	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/rogueweapon/stoneaxe/battle/steppesman/chupa
	beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/shepherd
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft/freifechter
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flashlight/flare/torch = 1,
						)
