/datum/job/roguetown/sheikh
	title = "Sheikh"
	flag = SHEIKH
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 3//more slots since they manage the steward/clerk roles for now as well - scratch that bringing the steward back
	spawn_positions = 3
	allowed_ages = ALL_AGES_LIST
	allowed_races = RACES_TOLERATED_UP
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_COUNCILLOR
	tutorial = "You may have inherited this role, bought your way into it, or were appointed by the Royal Family themselves; \
			Regardless of origin, you now serve as an assistant, planner, and juror for the Vizier. \
			You help him oversee the taxation, construction, and planning of new laws. \
			Your main focus is to assist the Vizier with their duties, answering only to them and the Sultan."
	whitelist_req = FALSE
	outfit = /datum/outfit/job/roguetown/sheikh
	advclass_cat_rolls = list(CTAG_SHEIKH = 2)

	give_bank_account = 40
	noble_income = 20
	min_pq = 1 //Probably a bad idea to have a complete newbie advising the monarch
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_desert2.ogg'
	social_rank = SOCIAL_RANK_NOBLE
	job_traits = list(TRAIT_NOBLE, TRAIT_SEEPRICES_SHITTY)
	job_subclasses = list(
		/datum/advclass/sheikh
	)

/datum/job/roguetown/sheikh/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/index = findtext(H.real_name, " ")
		if(index)
			index = copytext(H.real_name, 1,index)
		if(!index)
			index = H.real_name
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Lord"
		if(H.gender == FEMALE)
			honorary = "Lady"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

/datum/advclass/sheikh
	name = "Sheikh"
	tutorial = "You may have inherited this role, bought your way into it, or were appointed by the Royal Family themselves; \
			Regardless of origin, you now serve as an assistant, planner, and juror for the Vizier. \
			You help him oversee the taxation, construction, and planning of new laws. \
			You only answer to the Sultan, Sultana, Heir, or Heiress. However, your main focus is to assist the Vizier with their duties."
	outfit = /datum/outfit/job/roguetown/sheikh/basic
	category_tags = list(CTAG_SHEIKH)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_STR = -1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/sheikh
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/sheikh/basic/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/councillor
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/storage/keyring/steward // If this turns out to be overbearing re:stewardry bump down to the clerk keyring instead.
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel = 1)
