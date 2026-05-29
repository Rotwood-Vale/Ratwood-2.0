/datum/advclass/gnoll/templar
	name = "Gnoll Templar"
	maximum_possible_slots = 1
	tutorial = "None are as valued to protect graggarite worship as his gnoll champions themselves."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/gnoll)
	outfit = /datum/outfit/job/roguetown/gnoll/templar
	applies_post_equipment = FALSE
	category_tags = list(CTAG_GNOLL)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_COMBAT_AWARE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 4,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE
	)
	cmode_music = 'sound/music/combat_graggar.ogg'

/datum/outfit/job/roguetown/gnoll/templar/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/templar(H)
		neck = /obj/item/storage/belt/rogue/pouch
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
			if("Parchments (LITERACY)")
				beltl = /obj/item/storage/backpack/rogue/satchel/short/parchments
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, 2, TRUE)
		don_pelt(H)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, start_maxed = FALSE)
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/templar
	icon_state = "templar"
	max_integrity = 600
	armor = ARMOR_GNOLL_STANDARD
