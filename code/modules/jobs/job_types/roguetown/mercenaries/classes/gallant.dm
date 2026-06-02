/datum/advclass/mercenary/gallant
	name = "Gallant"
	tutorial = "Having left the bosom of the Church, whether by choice or by force, you have taken up the life of a mercenary. \
	Mayhaps you seek to bring honour to the name of your God or order, serving pious causes as a just warrior... or mayhaps the glitter of gold and glory has seen your heart turn to more worldly ambitions. \
	Either way, you are a Gallant, a mercenary templar."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	
	outfit = /datum/outfit/job/roguetown/mercenary/gallant
	subclass_languages = list(/datum/language/grenzelhoftian) //Grenzel Holy See
	class_select_category = CLASS_CAT_FAITH
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_RITUALIST, TRAIT_STEELHEARTED, TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_WIL = 3, //Templar stats with no holy warrior buff
		STATKEY_STR = 2,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/mercenary/gallant
	allowed_patrons = ALL_DIVINE_PATRONS

/datum/outfit/job/roguetown/mercenary/gallant/pre_equip(mob/living/carbon/human/H)
	..()
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	backr = /obj/item/rogueweapon/shield/tower/metal
	id = /obj/item/clothing/ring/silver
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg' // this is probably awful implementation. too bad!
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
			cloak = /obj/item/clothing/cloak/templar/astratan
		if(/datum/patron/divine/abyssor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
			head = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
			cloak = /obj/item/clothing/cloak/abyssortabard
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/roguetown/psicross/xylix
			cloak = /obj/item/clothing/cloak/templar/xylixian
			head = /obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm
			H.cmode_music = 'sound/music/combat_jester.ogg'
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
			head = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
			cloak = /obj/item/clothing/cloak/tabard/crusader/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/roguetown/psicross/necra
			cloak = /obj/item/clothing/cloak/templar/necran
			backpack_contents = list(/obj/item/flashlight/flare/torch, /obj/item/rogueweapon/huntingknife, /obj/item/roguekey/mercenary, /obj/item/rogueweapon/scabbard/sheath, /obj/item/storage/belt/rogue/pouch/coins/poor)
			REMOVE_TRAIT(H, TRAIT_RITUALIST, TRAIT_GENERIC)
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/roguetown/psicross/pestra
			head = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
			cloak = /obj/item/clothing/cloak/templar/pestran
		if(/datum/patron/divine/eora) //Eora content from stonekeep
			wrists = /obj/item/clothing/neck/roguetown/psicross/eora
			cloak = /obj/item/clothing/cloak/templar/eoran
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/roguetown/psicross/noc
			head = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
			cloak = /obj/item/clothing/cloak/tabard/crusader/noc
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/roguetown/psicross/ravox
			cloak = /obj/item/clothing/cloak/templar/ravox
			mask = /obj/item/clothing/head/roguetown/roguehood/ravoxgorget
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/roguetown/psicross/malum
			cloak = /obj/item/clothing/cloak/templar/malumite
			head = /obj/item/clothing/head/roguetown/helmet/heavy/malum
			wrists = /obj/item/clothing/neck/roguetown/psicross
			cloak = /obj/item/clothing/cloak/tabard/crusader/psydon
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			cloak = /obj/item/clothing/cloak/templar/astrata
			head = /obj/item/clothing/head/roguetown/helmet/heavy/astratan
		if(/datum/patron/divine/noc)
			cloak = /obj/item/clothing/cloak/templar/noc
			head = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
		if(/datum/patron/divine/abyssor)
			cloak = /obj/item/clothing/cloak/abyssortabard
			head = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
		if(/datum/patron/divine/dendor)
			cloak = /obj/item/clothing/cloak/templar/dendor
			head = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
		if(/datum/patron/divine/necra)
			cloak = /obj/item/clothing/cloak/templar/necra
			head = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
		if (/datum/patron/divine/malum)
			cloak = /obj/item/clothing/cloak/templar/malum
			head = /obj/item/clothing/head/roguetown/helmet/heavy/malum
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/cloak/templar/eora
			head = /obj/item/clothing/head/roguetown/helmet/heavy/eoran
		if (/datum/patron/divine/ravox)
			cloak = /obj/item/clothing/cloak/cleric/ravox
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold			
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylix
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket			
		if (/datum/patron/divine/pestra)
			cloak = /obj/item/clothing/cloak/templar/pestra
			head = /obj/item/clothing/head/roguetown/helmet/heavy/pestran			
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast)

	if(H.mind)
		var/weapons = list("Silver Longsword", "Silver Mace", "Silver Flail", "Silver Spear", "Silver Axe", "Silver Whip")
		var/weapon_choice = input(H, "Choose your silver weapon, Gallant!") as anything in weapons
		switch(weapon_choice)
			if("Silver Longsword")
				l_hand = /obj/item/rogueweapon/sword/long/silver
				beltl = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			if("Silver Spear")
				l_hand = /obj/item/rogueweapon/spear/silver
				r_hand = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			if("Silver Flail")
				beltl = /obj/item/rogueweapon/flail/sflail/silver
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			if("Silver Mace")
				beltl = /obj/item/rogueweapon/mace/steel/silver
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("Silver Axe")
				beltl = /obj/item/rogueweapon/stoneaxe/woodcut/silver
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
			if("Silver Whip")
				beltl = /obj/item/rogueweapon/whip/silver
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
