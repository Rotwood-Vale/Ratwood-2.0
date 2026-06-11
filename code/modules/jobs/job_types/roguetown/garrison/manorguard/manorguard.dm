/datum/job/roguetown/manorguard
	title = "Man at Arms"
	display_title = "府卫"
	flag = MANATARMS
	department_flag = GARRISON
	faction = "Station"
	total_positions = 8
	spawn_positions = 8

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED)
	tutorial = "你已证明自己忠诚且能干，因此被托付以保卫城镇、执行法令。\
				你长期接受战斗与守城作战训练，负责处理来自内外的威胁。\
				服从你的军士长、元帅与王权。向贵族与骑士致以应有敬意，如此你也会得到他们的尊重。不是以平民身份，而是以士兵身份。"
	display_order = JDO_CASTLEGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/manorguard
	advclass_cat_rolls = list(CTAG_MENATARMS = 20)

	give_bank_account = 22
	min_pq = 3
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_YEOMAN
	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	job_subclasses = list(
		/datum/advclass/manorguard/footsman,
		/datum/advclass/manorguard/skirmisher,
		/datum/advclass/manorguard/cavalry,
		/datum/advclass/manorguard/gormless,
		/datum/advclass/manorguard/retainer,
		/datum/advclass/manorguard/standard_bearer
	)

/datum/outfit/job/roguetown/manorguard
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/manorguard/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, cloak_and_title_setup)), 50)

/datum/outfit/job/roguetown/manorguard
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison
