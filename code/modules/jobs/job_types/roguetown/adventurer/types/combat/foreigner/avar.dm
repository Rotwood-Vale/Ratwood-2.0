//The League, but in space. Or something.
//Whip-javelin saiga-archer maniacs!
/datum/advclass/foreigner/aavnik
	name = "Aavnik Nitkov"
	tutorial = "A niktov. The slang for one who's done much, against both common good and their fellow man. \
	You're a brigand, of some sort. Perhaps not known, or violent in the same nature as all the others. \
	Yet, all the same, you're outcast from the people you'd once called your own. \
	What could you have done for them to toss you aside? Where had you failed?"
	allowed_races = RACES_ALL_KINDS
	traits_applied = list(TRAIT_STEELHEARTED)
	outfit = /datum/outfit/job/roguetown/adventurer/aavnik
	cmode_music = 'sound/music/combat_league.ogg'
	subclass_languages = list(/datum/language/aavnic)
	subclass_stats = list(//7 skill spread, since STR/SPD count for 2 each.
		STATKEY_PER = 3,
		STATKEY_STR = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
	//Universal skills
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

	extra_context = "This subclass provides the player with four loadouts. \
	Choosing the path of the saiga provides the Equestrian trait. \
	All others provide medium armour training."

/datum/outfit/job/roguetown/adventurer/aavnik/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	backr = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
	head = /obj/item/clothing/head/roguetown/papakha
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/quiver/javelin/iron
	neck = /obj/item/clothing/neck/roguetown/leather
	backpack_contents = list(
		/obj/item/flashlight/flare/torch,
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/rogueweapon/whip/nagaika,
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

	if(H.mind)
		var/aavnik_purpose = list("Saiga Archer","Footman","Axeman","Pikeman")
		var/purpose_choice = input(H, "Choose your FALL", "WHY YOU LEFT") as anything in aavnik_purpose
		switch(purpose_choice)
			if("Saiga Archer")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/riding, 4, TRUE)
				ADD_TRAIT(H, TRAIT_EQUESTRIAN, TRAIT_GENERIC)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/steppesman
				beltl = /obj/item/quiver/arrows
				var/turf/TU = get_turf(H)
				if(TU)
					new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(TU)
			if("Footman")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/steppesman
				beltl = /obj/item/rogueweapon/scabbard/sword
				backl = /obj/item/rogueweapon/shield/buckler
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			if("Axeman")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 3, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/battle/steppesman
				backl = /obj/item/rogueweapon/shield/buckler
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			if("Pikeman")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				r_hand = /obj/item/rogueweapon/spear/boar/aav
				l_hand = /obj/item/rogueweapon/katar/punchdagger/aav
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
