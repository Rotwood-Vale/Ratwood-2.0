/datum/job/roguetown/janissary
	title = "Janissary"
	display_title = "耶尼切里"
	flag = JANISSARY
	department_flag = GARRISON
	faction = "Station"
	total_positions = 7
	spawn_positions = 7

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	tutorial = "你是苏丹卫队的一员。确保城市及其臣民的安全，保卫当权者免受外界恐怖之物的侵害，守护苏丹国的存续。"
	display_order = JDO_CASTLEGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/janissary
	advclass_cat_rolls = list(CTAG_JANISSARY = 20)

	give_bank_account = 22
	min_pq = 3
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_YEOMAN
	cmode_music = 'sound/music/combat_desert1.ogg'
	job_subclasses = list(
		/datum/advclass/janissary/footman,
		/datum/advclass/janissary/zephyr,
		/datum/advclass/janissary/jezail,
		/datum/advclass/janissary/flagbearer,
	)

/datum/outfit/job/roguetown/janissary
	job_bitflag = BITFLAG_GARRISON

/datum/outfit/job/roguetown/janissary
	shoes = /obj/item/clothing/shoes/roguetown/shalal/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison
	cloak = /obj/item/clothing/cloak/citywatch/janissary
