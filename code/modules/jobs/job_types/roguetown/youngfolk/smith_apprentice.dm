/datum/job/roguetown/gapprentice
	title = "Guild Apprentice"
	flag = GUILDAPPRENTICE
	department_flag = YOUNGFOLK
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)

	tutorial = "Long hours and back-breaking work wouldnt even describe a quarter of what you do in a day for your Master. Its exhausting, filthy and you dont get much freetime: but someday youll get your own smithy, and youll have TWICE as many apprentices as your master does."

	outfit = /datum/outfit/job/roguetown/gapprentice
	display_order = JDO_GUILDAPPRENTICE
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_PEASANT

	advclass_cat_rolls = list(CTAG_GUILDAPPRENTICE = 2)
	job_subclasses = list(
		/datum/advclass/gapprentice
	)
	job_traits = list(TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT)


/datum/advclass/gapprentice
	name = "Guild Apprentice"
	tutorial = "Long hours and back-breaking work wouldnt even describe a quarter of what you do in a day for your Master. Its exhausting, filthy and you dont get much freetime: but someday youll get your own smithy, and youll have TWICE as many apprentices as your master does."
	outfit = /datum/outfit/job/roguetown/gapprentice/basic
	cmode_music = 'sound/music/cmode/towner/combat_towner3.ogg'
	category_tags = list(CTAG_GUILDAPPRENTICE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_CON = 1
	)
	subclass_skills = list(//apprentice levels in all smithing/engineering section. Journeyman in smelting.
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN, // Apprentice has spent more time smelting then smithing or tinkering
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/gapprentice/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	gloves = /obj/item/clothing/gloves/roguetown/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/roguekey/crafterguild
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/rogueweapon/tongs = 1,
		/obj/item/recipe_book/blacksmithing = 1,
		)
	if(H.gender == MALE)
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = null
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		cloak = /obj/item/clothing/cloak/apron/brown
