/datum/advclass/kj_follower/servitor
	name = "Servitor"
	tutorial = "You cook your knight's meals, mend their clothes and carry whatever they can't be bothered to. They'd be lost on the road without you, even if they rarely say so."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/kj_follower/servitor
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_KJ_FOLLOWER)
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	traits_applied = list(TRAIT_CICERONE, TRAIT_KEENEARS, TRAIT_SLEUTH, TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_OUTLANDER)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/ceramics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/kj_follower/servitor/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/under/roguetown/trou
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/cooking/pan
	beltr = /obj/item/rogueweapon/huntingknife
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
	/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 2,
	/obj/item/reagent_containers/food/snacks/rogue/handpie/fish = 2,
	/obj/item/reagent_containers/food/snacks/rogue/handpie/meat = 2,
	/obj/item/reagent_containers/glass/bottle/waterskin = 1,
	/obj/item/reagent_containers/glass/cup/silver = 2,
	/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
	/obj/item/soap/bath = 1,
	/obj/item/flint = 1,
	/obj/item/rogueweapon/scabbard/sheath = 1,
	/obj/item/flashlight/flare/torch/lantern = 1,
	/obj/item/folding_table_stored = 2,
	)
