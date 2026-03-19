//STR/SPD combination sword and board class.
/datum/advclass/sellsword
	name = "Sellsword"
	tutorial = "Perhaps a mercenary, perhaps a deserter, it matters not. At one time, you killed for a master in return for gold. \
	Now you live with no such master over your head, taking what you please."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit/sellsword
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg' // cutpurse or deadly shadows...?
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/bandit/sellsword/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					)
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	id = /obj/item/mattcoin
	H.adjust_blindness(-3)
	var/weapons = list("The Deserter (Maces, Shields & Crossbows)","The Mercenary (Swords, Shields & Polearms)", "The Hunter (Axes, Archery, Sneaking, Climbing & Athletics)")
	if(H.mind)
		var/weapon_choice = input(H, "Choose your expert-level proficiencies.", "HOW DOTH THOU WALK THROUGH LYFE, SELLSWORD?") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("The Deserter (Maces, Shields & Crossbows)") 
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/rogueweapon/mace/steel
				beltr = /obj/item/quiver/bolts
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail
				head = /obj/item/clothing/head/roguetown/helmet/kettle
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
			if("The Mercenary (Swords, Shields & Polearms)") 
				backl = /obj/item/rogueweapon/shield/heater
				beltl = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/sword/short/falchion
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail
				head = /obj/item/clothing/head/roguetown/helmet/sallet
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			if("The Hunter (Axes, Archery, Sneaking, Climbing & Athletics)")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltl = /obj/item/quiver/arrows
				beltr = /obj/item/rogueweapon/stoneaxe/battle
				armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				cloak = /obj/item/clothing/cloak/raincloak/furcloak/black
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)

/datum/outfit/job/roguetown/bandit/sellsword/post_equip(mob/living/carbon/human/H)
	. = ..()
	for(var/datum/bounty/b in GLOB.head_bounties)
		if(b.target == H.real_name || b.target_hidden == H.real_name)
			H.change_stat(STATKEY_SPD, 1)
			H.change_stat(STATKEY_CON, 1)
