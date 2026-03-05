/datum/advclass/hedgemage //mage class - like the Magician, but more evil.
	name = "Hedge Magician"
	tutorial = "Formerly a renown magician, you were forced to leave your comftorable \
	tower for one reason or another. However, as tarnished as your reputation may be \
	show them you are still not to be underestimated."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit/hedgemage
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_ARCYNE_T3, TRAIT_MAGEARMOR, TRAIT_ALCHEMY_EXPERT)
	subclass_spellpoints = 36
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 2, // Adv mage get 2 perception so whatever. It is useful for aiming body parts but have no direct synergy with spells.
		STATKEY_LCK = 2,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN, // Jman Polearms, for better parrying without making them bandit level
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN, //needs climbing to get into hideout
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE, // Standards for athletics is 3, give them 2
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_MASTER,
	)

/datum/outfit/job/roguetown/bandit/hedgemage/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/woodstaff/diamond
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/book/spellbook = 1, // Spell resetting is a key identity of good mage
					)
	mask = /obj/item/clothing/mask/rogue/facemask/steel //idk if this makes it so they cant cast but i want all of the bandits to have the same mask
	neck = /obj/item/clothing/neck/roguetown/coif
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	id = /obj/item/mattcoin

/datum/outfit/job/roguetown/bandit/hedgemage/post_equip(mob/living/carbon/human/H)
	. = ..()
	for(var/datum/bounty/b in GLOB.head_bounties)
		if(b.target == H.real_name || b.target_hidden == H.real_name)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_SPD, 1)
