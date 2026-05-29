/datum/advclass/gnoll/berserker
	name = "Gnoll Berserker"
	tutorial = "You are a warrior feared for your brutality, dedicated to using your might for your own gain. Might equals right, and you are the reminder of such a saying."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/gnoll)
	outfit = /datum/outfit/job/roguetown/gnoll/berserker
	cmode_music = 'sound/music/combat_graggar.ogg'
	category_tags = list(CTAG_GNOLL)
	applies_post_equipment = FALSE
	traits_applied = list(TRAIT_NOPAINSTUN, TRAIT_LIGHT_STEP, TRAIT_SLEUTH)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 4,
		STATKEY_WIL = 3,
		STATKEY_SPD = 4,
		STATKEY_INT = -3,
		STATKEY_PER = -1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE
	)

/datum/outfit/job/roguetown/gnoll/berserker/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor(H)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		belt = /obj/item/storage/belt/rogue/leather/rope/gnoll
		var/satchels = list("Arts (Instruments, Painting Supplies)","Crafts (Cloth, Leather, Needle)","Medicine (and Drugs)","Food (Butter, Peppermill, Meat)","Parchments (LITERACY)")
		var/satchel_choice = input(H, "Choose your supplies.", "HOW DO YOU HELP THE PACK?") as anything in satchels
		switch(satchel_choice)
			if("Arts (Instruments, Painting Supplies)")
				var/obj/item/canvas/canvas = new /obj/item/canvas(H.loc)
				H.put_in_l_hand(canvas)
				beltl = /obj/item/storage/backpack/rogue/satchel/short/arts
				H.adjust_skillrank_up_to(/datum/skill/misc/music, 4, TRUE)
			if("Crafts (Cloth, Leather, Needle)")
				beltl = /obj/item/storage/backpack/rogue/satchel/short/crafts
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, 1, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/tanning, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking, 1, TRUE)
			if("Medicine (and Drugs)")
				beltl = /obj/item/storage/backpack/rogue/satchel/short/medicine
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 1, TRUE)
			if("Food (Butter, Peppermill, Meat)")
				beltl = /obj/item/storage/backpack/rogue/satchel/short/food
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, 3, TRUE)
		don_pelt(H)
