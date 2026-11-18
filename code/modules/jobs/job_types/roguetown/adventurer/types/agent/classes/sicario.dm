/datum/advclass/agent/sicario
	name = "Etruscan Sicario"
	tutorial = "The Sicario are a group of manipulators and charmers, utilizing their social skills and looks to ensnare their targets, giving them a false sense of security before driving a dagger into their backs.. Typically formed from past Vaqueros."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES
	outfit = /datum/outfit/job/roguetown/agent/sicario
	class_select_category = CLASS_CAT_ETRUSCA
	category_tags = list(CTAG_COURTAGENT)
	cmode_music = 'sound/music/templarofpsydonia.ogg'
	traits_applied = list(TRAIT_DECEIVING_MEEKNESS, TRAIT_DODGEEXPERT, TRAIT_GOODLOVER)
	subclass_languages = list(/datum/language/thievescant, /datum/language/etruscan)
	subclass_stats = list(
		STATKEY_WIL = 1,
		STATKEY_INT = 2,
		STATKEY_SPD = 3
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, 
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)
	
/datum/outfit/job/roguetown/agent/sicario/pre_equip(mob/living/carbon/human/H)
	..()
	r_hand = /obj/item/rogueweapon/sword/rapier/vaquero
	l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/rogueweapon/scabbard/sheath
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/faulds/red
	mouth = /obj/item/alch/rosa
	neck = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	cloak = /obj/item/clothing/suit/roguetown/armor/longcoat/red
	backl = /obj/item/storage/backpack/rogue/satchel
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/red
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	backpack_contents = list(
					/obj/item/roguekey/mercenary = 1,
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
					/obj/item/rogueweapon/huntingknife/idagger/steel/rondel = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/lockpickring/mundane = 1,
					/obj/item/reagent_containers/glass/bottle/alchemical/emberwine,
				)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T1)
	if(H.mind)
		var/weapons = list("Accordion","Bagpipe", "Banjo","Drum","Flute","Guitar","Harmonica","Harp","Hurdy-Gurdy","Jaw Harp","Lute","Psyaltery","Shamisen","Trumpet","Viola","Vocal Talisman")
		var/weapon_choice = input(H, "Choose your instrument.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Bagpipe")
				backr = /obj/item/rogue/instrument/bagpipe
			if("Banjo")
				backr = /obj/item/rogue/instrument/banjo
			if("Drum")
				backr = /obj/item/rogue/instrument/drum
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Harmonica")
				backr = /obj/item/rogue/instrument/harmonica
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Jaw Harp")
				backr = /obj/item/rogue/instrument/jawharp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Shamisen")
				backr = /obj/item/rogue/instrument/shamisen
			if("Trumpet")
				backr = /obj/item/rogue/instrument/trumpet
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals

/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/red
	color = CLOTHING_RED
/obj/item/storage/belt/rogue/leather/battleskirt/faulds/red
	color = CLOTHING_RED
/obj/item/clothing/suit/roguetown/armor/longcoat/red
	color = CLOTHING_RED
