/datum/job/roguetown/churchling
	title = "Churchling"
	flag = CHURCHLING
	department_flag = YOUNGFOLK
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)

	tutorial = "Your family were zealots. They scolded you with a studded belt and prayed like sinners every waking hour of the day they weren't toiling in the fields. You escaped them by becoming a churchling--and a guaranteed education isn't so bad."

	outfit = /datum/outfit/job/roguetown/churchling
	display_order = JDO_CHURCHLING
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_PEASANT

	//You've given up your life for the Church. Why would you be noble?
	virtue_restrictions = list(/datum/virtue/utility/noble)

	advclass_cat_rolls = list(CTAG_CHURCHLING = 2)
	job_subclasses = list(
		/datum/advclass/churchling
	)
	job_traits = list(TRAIT_HOMESTEAD_EXPERT)

/datum/advclass/churchling
	name = "Churchling"
	tutorial = "Your family were zealots. They scolded you with a studded belt and prayed like sinners every waking hour of the day they weren't toiling in the fields. You escaped them by becoming a churchling--and a guaranteed education isn't so bad."
	outfit = /datum/outfit/job/roguetown/churchling/basic
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_CHURCHLING)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/churchling/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	neck = /obj/item/clothing/neck/roguetown/psicross
	if(should_wear_femme_clothes(H))
		head = /obj/item/clothing/head/roguetown/armingcap
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/robe
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights
	belt = /obj/item/storage/belt/rogue/leather/rope
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	beltl = /obj/item/storage/keyring/churchie

/datum/job/roguetown/churchling/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	H.advsetup = 1
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")

	spawn(50)
		if(H && H.client)
			_delayed_path_choice(H)

/datum/job/roguetown/churchling/proc/_delayed_path_choice(mob/living/carbon/human/H)
	if(!H || !H.client || !H.mind)
		return

	var/choice = alert(H, "Choose your path.", "Churchling Doctrine", "Loyalist", "Radical")

	if(choice == "Radical")
		grant_radical_path(H)
	else
		grant_old_path(H)

/datum/job/roguetown/churchling/proc/grant_old_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return

	REMOVE_TRAIT(H, TRAIT_CLERGYRADICAL, "job")
	H.reset_clergy_devotion(CLERIC_T1, CLERIC_REGEN_DEVOTEE, FALSE, CLERIC_REQ_1)
	to_chat(H, span_notice("I remain on the old path of devotion."))

/datum/job/roguetown/churchling/proc/grant_radical_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return

	ADD_TRAIT(H, TRAIT_CLERGYRADICAL, "job")
	H.church_favor += 1200
	H.reset_clergy_devotion(CLERIC_T1, CLERIC_REGEN_DEVOTEE, FALSE, CLERIC_REQ_1)
	to_chat(H, span_notice("I embrace the radical path."))

