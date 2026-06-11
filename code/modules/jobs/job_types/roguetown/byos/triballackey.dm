
/datum/job/roguetown/tribalrabble
	title = "Tribal Rabble"
	display_title = "部落喽啰"
	flag = TRIBALRABBLE
	department_flag = TRIBAL
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	selection_color = JCOLOR_TRIBAL

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/goblinp, /datum/species/anthromorphsmall, /datum/species/kobold)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "在一群小怪胎里，你也只是其中一个小怪胎。你崇拜酋长，将其视作巨龙意志在人间的化身，因为祂所拣选的，自然就是最大最强的那个。 \
	除了比起正面砸烂别人脑袋，你更偏爱鬼祟伎俩之外，实在没什么特别之处，而这也常叫酋长失望。听到召唤就乖乖服从。 \
	这里是巨龙之岛，而今有传闻说外来者已抵达，这意味着又有更多金子可供祂攫取。 \
	说不定只要你献上新鲜的奴隶和更多财货……巨龙终会注意到你。"
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
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient

/datum/advclass/tribalrabble/rabble
	name = "潜猎者"
	tutorial = "你靠潜行、攀爬与偷窃活命，比起正面厮杀，你更擅长摸进阴影里把猎物连同财物一起带走。"
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
