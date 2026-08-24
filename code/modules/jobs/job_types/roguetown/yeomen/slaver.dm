/datum/job/roguetown/slaver
	title = "Slaver"
	department_flag = YEOMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_YEOMAN
	allowed_races = ACCEPTED_RACES
	tutorial = "You are one of the many fingers part of slavery's long arm, away from the fiercest competition over in the far southeast of the world you have established yourself as the premier slaver in this duchy. Put your slaves to work or auction them off, acquire new ones from the lowtown garrison or through less savory means."
	display_order = JDO_SLAVER
	job_traits = list(TRAIT_SLEUTH)
	advclass_cat_rolls = list(CTAG_SLAVER = 2)
	job_subclasses = list(
		/datum/advclass/slaver
	)
	outfit = /datum/outfit/job/roguetown/slaver
	give_bank_account = 50
	min_pq = 25
	max_pq = null
	round_contrib_points = 4
	cmode_music = 'sound/music/cmode/towner/combat_towner3.ogg'
	social_rank = SOCIAL_RANK_YEOMAN

/datum/job/roguetown/slaver/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	if(!ishuman(H))
		return
	var/mob/living/carbon/human/human_target = H
	human_target.update_ownership_marks_for_slaver(human_target)

/datum/outfit/job/roguetown/slaver

/datum/advclass/slaver
	name = "Slaver"
	tutorial = "You are one of the many fingers part of slavery's long arm, away from the fiercest competition over in the far southeast of the world you have established yourself as the premier slaver in this duchy. Put your slaves to work or auction them off, acquire new ones from the lowtown garrison or through less savory means."
	outfit = /datum/outfit/job/roguetown/slaver/basic
	category_tags = list(CTAG_SLAVER)
	subclass_languages = list(/datum/language/celestial)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_CON = 2,
		STATKEY_STR = 1
	)
	subclass_skills = list(
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/slaver/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	id = /obj/item/scomstone
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/zyb
	belt = /obj/item/storage/belt/rogue/leather/shalal
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/rogueweapon/whip/bronze
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/veryrich,
		/obj/item/clothing/neck/roguetown/psicross/silver = 1,
		/obj/item/rogueweapon/surgery/cautery/branding = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 2,
		/obj/item/rope/chain,
		/obj/item/storage/keyring/rockhillslaver,
		)
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/velvet
	else if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
		armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
