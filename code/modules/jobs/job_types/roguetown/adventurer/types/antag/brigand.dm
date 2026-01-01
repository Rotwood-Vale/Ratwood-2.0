/datum/advclass/brigand //Strength class, starts with a selection of weapon classes and medium armor training
	name = "Brigand"
	tutorial = "Cast from society, you use your powerful physical might and endurance to take from those who are weaker from you."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit/brigand
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 4,	//have you seen this idiot's starting gear and skill spread??
		STATKEY_WIL = 3,	//-LCK +WIL
		STATKEY_CON = 2,
		STATKEY_SPD = 1,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,		//Knights will always be competent swordsmen regardless of class pick, so let's make all brigands competent axemen.
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,		//Them getting "okay" ranged skills was a little odd since it cuts into Sellsword's jack-of-all-tradesry.
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/bandit/brigand/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					)
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	neck = /obj/item/clothing/neck/roguetown/coif
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	id = /obj/item/mattcoin
	H.adjust_blindness(-3)
	var/weapons = list("The Brigand (Axes, Maces & Whips/Flails)","Common Soldiery (Polearms & Swords)", "The Nefarious Dusthead (Knives, Climbing & Athletics)")
	if(H.mind)
		var/weapon_choice = input(H, "Choose your expert-level proficiencies.", "HOW DOTH THOU WALK THROUGH LYFE, BRIGAND?") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("The Brigand (Axes, Maces & Whips/Flails)") //Battle axe & whip.
				beltl = /obj/item/rogueweapon/whip/nagaika
				beltr = /obj/item/rogueweapon/stoneaxe/battle
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Common Soldiery (Polearms & Swords)") //Steel arming sword & shield. On-spawn bolts, but no crossbow.
				backl= /obj/item/rogueweapon/shield/iron
				beltr = /obj/item/rogueweapon/sword
				beltl = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("The Nefarious Dusthead (Knives, Climbing & Athletics)") //Dagger, athletics, and OK lockpicking. You will never be a Knave. This is mostly a for-fun class, where else have you seen a knife strength build?
				beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
				backl = /obj/item/rogueweapon/whip
				beltl = /obj/item/lockpickring/mundane	//not replaceable unless a knave joins. intentional.
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_JOURNEYMAN, TRUE)
