/datum/job/roguetown/squire
	title = "Squire"
	display_title = "侍从"
	flag = SQUIRE
	department_flag = GARRISON
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	advclass_cat_rolls = list(CTAG_SQUIRE = 20)
	job_traits = list(TRAIT_SQUIRE_REPAIR)

	tutorial = "你的家人总说你将来会有出息，他们对你的期待从来不止是做个农夫。你曾和伙伴们一起在田野里练基本功，拿木棍比剑，挥着连枷追兔子，也帮家里搬沉重的谷袋。\
		骑士看中了你的潜力，把你收作亲自照看的侍从。总有一天，你会成就些什么。"
	outfit = /datum/outfit/job/roguetown/squire
	display_order = JDO_SQUIRE
	give_bank_account = TRUE
	min_pq = -5 //squires aren't great but they can do some damage
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_PEASANT

	cmode_music = 'sound/music/combat_squire.ogg'
	job_subclasses = list(
		/datum/advclass/squire/lancer,
		/datum/advclass/squire/footman,
		/datum/advclass/squire/skirmisher
	)

/datum/outfit/job/roguetown/squire
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/squire
	id = /obj/item/scomstone/bad/garrison
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	backr = /obj/item/storage/backpack/rogue/satchel

	job_bitflag = BITFLAG_GARRISON		//Move this role to garrison section later. Shouldn't be under youngroles for transparancy they are garrison.

/datum/job/roguetown/squire/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, cloak_and_title_setup)), 50)

/datum/advclass/squire/lancer
	name = "枪骑侍从"
	tutorial = "你是下一代骑士枪骑兵与步战长枪手的候补。\
	你在长柄兵器上的训练，让你与其他侍从显得截然不同。"
	outfit = /datum/outfit/job/roguetown/squire/lancer

	category_tags = list(CTAG_SQUIRE)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/squire/lancer/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	r_hand = /obj/item/rogueweapon/spear
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/rogueweapon/hammer/copper
		)

/datum/advclass/squire/footman
	name = "步战侍从"
	tutorial = "你的训练几乎全都围绕剑术展开。\
	剑这种武器看似灵活百搭，真正用好却并不轻松。"
	outfit = /datum/outfit/job/roguetown/squire/footman

	category_tags = list(CTAG_SQUIRE)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/squire/footman/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/rogueweapon/hammer/copper
		)

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("铁剑","棍棒",)
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("铁剑")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/iron
			if("棍棒")
				beltr = /obj/item/rogueweapon/mace/cudgel

/datum/advclass/squire/skirmisher
	name = "游击侍从"
	tutorial = "随着军队编制愈发灵活、战术也日趋新式，不规则部队的重要性正日益凸显。\
	像你这样的年轻候补，正被训练成未来的精锐游击兵。"
	outfit = /datum/outfit/job/roguetown/squire/skirmisher

	category_tags = list(CTAG_SQUIRE)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/squire/skirmisher/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	beltr = /obj/item/quiver/arrows
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/rogueweapon/hammer/copper
		)
