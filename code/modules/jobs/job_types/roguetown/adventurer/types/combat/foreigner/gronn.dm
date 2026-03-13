//Gronnic Itinerant is a combination subclass.
//A choice between polearms and ranged.
/datum/advclass/foreigner/gronn
	name = "Gronnic Itinerant"
	tutorial = "Whether separated from your clan, or otherwise cast aside? You've found your way to Ferentia. \
	Bound by blood oaths, violence and any other matter of mania that follows your people, how will you possibly adapt? \
	Perhaps, if another chief were to find you..."
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/gronnic
	subclass_languages = list(/datum/language/gronnic)
	cmode_music = 'sound/music/combat_gronn.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_INT = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "Inhumen exclusive. \
	Bruiser provides: +3STR/-2INT, JMAN polearms and JMAN riding, paired with critical resistance. \
	Archer provides:  +3PER/+2STR, EXPT bows, JMAN tracking."

/datum/outfit/job/roguetown/adventurer/gronnic
	allowed_patrons = ALL_INHUMEN_PATRONS

/datum/outfit/job/roguetown/adventurer/gronnic/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/stoneaxe/handaxe
	beltl = /obj/item/rogueweapon/huntingknife
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/rogueweapon/scabbard/sheath)

	if(H.mind)
		var/gronnish_lot = list("Bruiser","Archer")
		var/lot_choice = input(H, "Choose your LOT", "WHAT WERE YOU") as anything in gronnish_lot
		switch(lot_choice)
			if("Bruiser")
				//Equipment
				head = /obj/item/clothing/head/roguetown/helmet/nomadhelmet
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/halberd/bardiche
				//Skills & Stats.
				H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
				H.change_stat(STATKEY_STR, 3)
				H.change_stat(STATKEY_INT, -2)
				//The rest.
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			if("Archer")
				//Equipment
				head = /obj/item/clothing/head/roguetown/hatfur
				armor = /obj/item/clothing/suit/roguetown/armor/leather/Huus_quyaq
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				l_hand = /obj/item/quiver/arrows
				//Skills & Stats.
				H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)
				H.change_stat(STATKEY_PER, 3)
				H.change_stat(STATKEY_STR, 2)

	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

