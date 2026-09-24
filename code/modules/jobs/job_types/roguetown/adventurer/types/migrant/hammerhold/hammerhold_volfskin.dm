/datum/advclass/hammerhold/volfskin
	name = "Hammerholdian Volfskin"
	tutorial = "You are a volfskin, one of the legendary Hammerholdian warriors who are said to be possessed by raging volf spirits in battles. Distrusted due to your less than savoury religious practices, but well-respected for your combat prowess."
	outfit = /datum/outfit/job/roguetown/hammerhold/volfskin
	category_tags = list(CTAG_HAMMERHOLD_VOLFSKIN)
	traits_applied = list(TRAIT_ORGAN_EATER, TRAIT_DUALWIELDER, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN, TRAIT_STEELHEARTED, TRAIT_OUTLANDER, TRAIT_HAMMERHOLD_WARBAND)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_INT = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN, //weapon pick bumps whatever you take to expert
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

	subclass_languages = list(
		/datum/language/hammerholdian,
	)

/datum/outfit/job/roguetown/hammerhold/volfskin
	allowed_patrons = list(/datum/patron/divine/abyssor, /datum/patron/inhumen/graggar) //Uniquely can be Graggarite unlike the rest of the party. Anything else gets turned Abyssorite. You get TRAIT_ORGAN_EATER either way.
	default_patron = /datum/patron/divine/abyssor

/datum/outfit/job/roguetown/hammerhold/volfskin/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn
	neck = /obj/item/clothing/neck/roguetown/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/trou/leather/gronn
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronn
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel

	switch(H.patron?.type)
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
		else
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor //allowed_patrons keeps this to Abyssor or Graggar, so anything landing here is Abyssorite.

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/reagent_containers/powder/moondust = 2 //"Raging volf spirits" in question
		)

	var/weapons = list("Twin Battle Axes", "Twin Warhammers", "Twin Seaxes", "Twin Claws")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Twin Battle Axes")
			beltl = /obj/item/rogueweapon/stoneaxe/battle
			beltr = /obj/item/rogueweapon/stoneaxe/battle
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
		if("Twin Warhammers")
			beltl = /obj/item/rogueweapon/mace/warhammer/steel
			beltr = /obj/item/rogueweapon/mace/warhammer/steel
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
		if("Twin Seaxes")
			beltl = /obj/item/rogueweapon/huntingknife/combat
			beltr = /obj/item/rogueweapon/huntingknife/combat
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
		if("Twin Claws")
			beltl = /obj/item/rogueweapon/handclaw/steel
			beltr = /obj/item/rogueweapon/handclaw/steel
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 4, TRUE)
		else //In case they DC or don't choose close the panel, etc
			beltl = /obj/item/rogueweapon/stoneaxe/battle
			beltr = /obj/item/rogueweapon/stoneaxe/battle
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)

	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.dna.species.soundpack_f = new /datum/voicepack/female/warrior()

	H.cmode_music = 'sound/music/combat_hornofthebeast.ogg'

	if(!H.has_language(/datum/language/hammerholdian))
		H.grant_language(/datum/language/hammerholdian)
		to_chat(H, span_info("I can speak Hammerholdian with ,h before my speech."))
