/datum/advclass/agent/nachtjager
	name = "Grenzelhoftian Nachtjäger"
	tutorial = "The Nachtjäger are a group of devout followers of the ten, utilizing their holy miracles in tracking down and hunting those they suspect to be dark beings of heretical nature.. These are typically nimble fighters often utilizing silver weaponry in order to slay the beasts of the night."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES
	outfit = /datum/outfit/job/roguetown/agent/nachtjager
	class_select_category = CLASS_CAT_GRENZELHOFT
	category_tags = list(CTAG_COURTAGENT)
	allowed_patrons = ALL_DIVINE_PATRONS
	cmode_music = 'sound/music/templarofpsydonia.ogg'
	traits_applied = list(TRAIT_EXPERT_HUNTER, TRAIT_DODGEEXPERT, TRAIT_SILVER_BLESSED, TRAIT_COURTAGENT)
	subclass_languages = list(/datum/language/thievescant, /datum/language/grenzelhoftian)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_PER = 1,
		STATKEY_SPD = 1,
		STATKEY_STR = 2
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
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE
	)

/datum/outfit/job/roguetown/agent/nachtjager/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/silver = list("Silver Dagger", "Silver Shortsword", "Silver Rapier", "Silver Morningstar", "Silver Whip", "Silver Urumi")
		var/silver_choice = input(H, "Choose your WEAPON.", "PREPARE YOUR ARMS.") as anything in silver
		switch(silver_choice)
			if("Silver Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/silver
				beltr = /obj/item/rogueweapon/scabbard/sheath
			if("Silver Shortsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/silver
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Silver Rapier")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/rapier/silver
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Silver Morningstar")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/sflail/silver
			if("Silver Whip")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/whip/silver
			if("Silver Urumi")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/whip/urumi/silver

		beltl = /obj/item/rogueweapon/scabbard/sword
		belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/silver
		neck = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
		armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
		cloak = /obj/item/clothing/suit/roguetown/armor/longcoat/orange
		backr = /obj/item/storage/backpack/rogue/satchel
		gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
		head = /obj/item/clothing/head/roguetown/puritan/armored
		mask = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/orange
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
		backpack_contents = list(
			/obj/item/roguekey/mercenary = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel/rondel = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/lockpickring/mundane = 1,
		)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)

/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/orange
	color = CLOTHING_ORANGE

/obj/item/storage/belt/rogue/leather/battleskirt/faulds/orange
	color = CLOTHING_ORANGE

/obj/item/clothing/suit/roguetown/armor/longcoat/orange
	color = CLOTHING_ORANGE
