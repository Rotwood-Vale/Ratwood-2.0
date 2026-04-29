
/datum/job/roguetown/tribalrabble
	title = "Tribal Rabble"
	flag = TRIBALRABBLE
	department_flag = TRIBAL
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	selection_color = JCOLOR_TRIBAL

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/goblinp, /datum/species/anthromorphsmall, /datum/species/kobold)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "A gremlin among many other gremlins. You worship the chief as the representation of The Dragon, his chosen as the biggest and the strongest. \
	There's little to say about you, aside from your proclivity for skullduggery over outright skull smashing, much to your chief's disappointment. Obey when called upon. \
	This is The Dragon's island, and there's rumor of newcomers, which means more gold for him. \
	Perhaps if you brought a fresh slave or mammons... The Dragon would finally notice you."
	display_order = JDO_TRIBALRABBLE
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/tribalrabble
	advclass_cat_rolls = list(CTAG_TRIBALRABBLE = 20)

	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_gronn.ogg'
	social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_OUTDOORSMAN, TRAIT_SURVIVAL_EXPERT, TRAIT_TRIBAL, TRAIT_DARKVISION)
	job_subclasses = list(
		/datum/advclass/tribalrabble/rabble,
	)

/datum/outfit/job/roguetown/tribalrabble
	cloak = /obj/item/clothing/cloak/tribal
	belt = /obj/item/storage/belt/rogue/leather/rope
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	shirt = /obj/item/clothing/suit/roguetown/shirt/tribalrag
	pants = /obj/item/clothing/under/roguetown/loincloth/brown
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	beltr = /obj/item/quiver/arrows
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger

/datum/advclass/tribalrabble/rabble
	name = "Hunter"
	tutorial = "Ooga Chacka Sneaka-Chacka."
	outfit = /datum/outfit/job/roguetown/tribalrabble/rabble
	category_tags = list(CTAG_TRIBALRABBLE)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 3,)

	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/tribalrabble/rabble/pre_equip(mob/living/carbon/human/H)
	..()
	H.faction += list("orcs", "tribe")
	if(!H.has_language(/datum/language/draconic))
		H.grant_language(/datum/language/draconic)
	r_hand = /obj/item/rogueweapon/spear/stone
	backpack_contents = list(
		/obj/item/roguekey/tribal = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/lockpickring/mundane = 1,
		)
	H.set_blindness(0)
