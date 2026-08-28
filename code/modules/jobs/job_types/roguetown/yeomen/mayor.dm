/datum/job/roguetown/mayor
	title = "Sedeent Mayor"
	tutorial = "You are the mayor of the settlement Sedeent on Isle Sauro, you oversee the settlement and ensure everything runs accordingly.\
		You are in charge of the townsfolk, commerce, the militia and the exiles, your authority is near absolute on Sauro."
	flag = MAYOR
	department_flag = YEOMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	cmode_music = 'sound/music/cmode/towner/combat_towner3.ogg'
	
	outfit = /datum/outfit/job/roguetown/mayor
	display_order = JDO_MAYOR
	give_bank_account = 40
	min_pq = 8
	max_pq = null
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN

	advclass_cat_rolls = list(CTAG_MAYOR = 2)
	spells = list(/obj/effect/proc_holder/spell/self/convertrole/militia)

	job_subclasses = list(
		/datum/advclass/mayor
	)

/datum/advclass/mayor
	name = "Sedeent Mayor"
	tutorial = "You are the mayor of the settlement Sedeent on Isle Sauro, you oversee the settlement and ensure everything runs accordingly.\
		You are in charge of the townsfolk, commerce, the militia and the exiles, your authority is near absolute on Sauro."

	outfit = /datum/outfit/job/roguetown/mayor
	category_tags = list(CTAG_MAYOR)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN

	)

/datum/outfit/job/roguetown/mayor/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	id = /obj/item/scomstone/garrison
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	l_hand = /obj/item/rogueweapon/sword/rapier/dec
	cloak = /obj/item/clothing/cloak/half/red
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
	pants = /obj/item/clothing/under/roguetown/tights/black
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fencer
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	head = /obj/item/clothing/head/roguetown/inqhat/mayor
	mask = /obj/item/clothing/mask/rogue/spectacles/red
	backpack_contents = list(/obj/item/storage/keyring/sedeentmayor = 1)
	// backpack_contents = list(/obj/item/recipe_book/survival = 1)//superceded by tgui
	H.set_blindness(0)

/obj/effect/proc_holder/spell/self/convertrole/militia
	name = "Recruit Militia-Man"
	new_role = "Militia Watchman"
	overlay_state = "recruit_guard"
	recruitment_faction = "Watchman"
	recruitment_message = "Serve the town guard, %RECRUIT!"
	accept_message = "FOR THE CROWN!"
	refuse_message = "I refuse."
