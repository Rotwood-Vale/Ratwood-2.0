/datum/job/roguetown/bogger
	title = "Bog guard"
	flag = BOGGUARD
	department_flag = GARRISON
	faction = "Station"
	total_positions = 8
	spawn_positions = 8
	job_reopens_slots_on_death = FALSE
	selection_color = JCOLOR_SOLDIER
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	whitelist_req = TRUE
	display_order = JDO_TOWNGUARD
	min_pq = 0
	max_pq = null
	give_bank_account = 8
	social_rank = SOCIAL_RANK_PEASANT
	outfit = /datum/outfit/job/roguetown/bogger
	job_traits = list(TRAIT_SURVIVAL_EXPERT)
	job_stats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 1,
	)
	tutorial = "You are a Bog guard, a guard of the Rockhill bog. Patrol the marsh, defend the outpost and answer to the local authorities."

/datum/outfit/job/roguetown/bogger
	job_bitflag = BITFLAG_GARRISON
	head = /obj/item/clothing/head/roguetown/helmet/skullcap
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	cloak = /obj/item/clothing/cloak/stabard/bog
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel
	r_hand = /obj/item/rogueweapon/spear
	l_hand = /obj/item/rogueweapon/shield/wood
	id = /obj/item/scomstone/bad/garrison
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/signal_horn = 1,
	)

/datum/outfit/job/roguetown/bogger/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/tracking, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
	H.verbs |= /mob/proc/haltyell
