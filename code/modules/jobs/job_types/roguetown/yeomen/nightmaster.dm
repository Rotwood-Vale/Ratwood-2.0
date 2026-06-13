/datum/job/roguetown/niteman
	title = "Bathmaster"
	display_title = "浴场主"
	flag = NITEMASTER
	department_flag = YEOMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	f_title = "浴场主事"
	allowed_races = ACCEPTED_RACES
	tutorial = "你与酒馆老板一同经营这间浴场，并将其对外出租。你负责为浴女们提供庇护，帮她们招揽营生，前提是你自己别又成了那个惹是生非、让众人勉强忍着的浪荡子。"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/niteman
	display_order = JDO_NITEMASTER
	give_bank_account = 20
	min_pq = 1
	max_pq = null
	bypass_lastclass = TRUE
	round_contrib_points = 3
	cmode_music = 'sound/music/cmode/nobility/combat_spymaster.ogg'
	social_rank = SOCIAL_RANK_YEOMAN
	job_traits = list(TRAIT_SEEPRICES,
		TRAIT_CICERONE,
		TRAIT_NUTCRACKER,
		TRAIT_GOODLOVER,
		TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_BATHMOM = 2)
	job_subclasses = list(
		/datum/advclass/bathmaster
	)

/datum/advclass/bathmaster
	name = "浴场主"
	tutorial = "你与酒馆老板一同经营这间浴场，并将其对外出租。你负责为浴女们提供庇护，帮她们招揽营生，前提是你自己别又成了那个惹是生非、让众人勉强忍着的浪荡子。"
	outfit = /datum/outfit/job/roguetown/niteman/basic
	category_tags = list(CTAG_BATHMOM)
	subclass_languages = list(/datum/language/thievescant)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/niteman/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/lockpick/goldpin/silver
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/purple
	wrists = /obj/item/storage/keyring/nightman
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	pants = /obj/item/clothing/under/roguetown/trou/leather
	beltl = /obj/item/rogueweapon/whip

	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 2,
		/obj/item/reagent_containers/powder/moondust = 2,
		/obj/item/reagent_containers/powder/spice = 1,
		/obj/item/mini_flagpole/bathhouse,
		)

	if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/nightman
		H.dna.species.soundpack_m = new /datum/voicepack/male/zeth()
	else if(should_wear_femme_clothes(H))
		cloak = /obj/item/clothing/cloak/matron
		armor = /obj/item/clothing/suit/roguetown/armor/armordress/alt
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/massage)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/takeapprentice)
