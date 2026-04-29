/datum/job/roguetown/tribalvillager
	title = "Tribal Villager"
	flag = TRIBALVILLAGER
	department_flag = TRIBAL
	faction = "Station"
	total_positions = 6
	spawn_positions = 6
	selection_color = JCOLOR_TRIBAL

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/goblinp, /datum/species/anthromorphsmall, /datum/species/kobold)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	// tutorial = "Ooga Chacka WORK-a chacka."
	tutorial = "You are the lowest of the low in the tribe. You're the camp's laborer, in service to the Chief before all others. \
	They've chosen you, as the weakest of them all, to prepare and service the camp in whatever fashion they see fit. \
	Make sure everyone is fed, healthy, and satisfied, all while hoping maybe one day you'll be something more."
	display_order = JDO_TRIBALVILLAGER
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/tribalvillager
	advclass_cat_rolls = list(CTAG_PILGRIM = 20)

	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_gronn.ogg'
	// social_rank = SOCIAL_RANK_PEASANT
	// job_traits = list(TRAIT_WOODSMAN, TRAIT_SURVIVAL_EXPERT, TRAIT_TRIBAL)
	job_traits = list(TRAIT_TRIBAL, TRAIT_OUTDOORSMAN, TRAIT_DARKVISION)
	job_subclasses = list(
		/datum/advclass/barbersurgeon,
		/datum/advclass/blacksmith,
		/datum/advclass/cheesemaker,
		/datum/advclass/drunkard,
		/datum/advclass/fisher,
		/datum/advclass/miner,
		/datum/advclass/peasant,
		/datum/advclass/potter,
		/datum/advclass/seamstress,
		/datum/advclass/thug,
		/datum/advclass/witch,
		/datum/advclass/scavenger,
		/datum/advclass/woodworker
	)

/datum/outfit/job/roguetown/tribalvillager/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.faction += list("orcs", "tribe")
	if(!H.has_language(/datum/language/draconic))
		H.grant_language(/datum/language/draconic)
	if(SSmapping.config.map_name == "Build Your Own Settlement")
		head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
		cloak = /obj/item/clothing/cloak/tribal
		armor = null
		shirt = /obj/item/clothing/suit/roguetown/shirt/tribalrag
		belt = /obj/item/storage/belt/rogue/leather/rope
		pants = /obj/item/clothing/under/roguetown/loincloth/brown
		wrists = null
		shoes = null
