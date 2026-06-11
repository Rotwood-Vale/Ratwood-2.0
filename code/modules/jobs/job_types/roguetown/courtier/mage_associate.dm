/datum/job/roguetown/wapprentice
	title = "Magicians Associate"
	display_title = "法师侍从"
	flag = MAGEASSOCIATE
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 4
	spawn_positions = 4

	allowed_races = ACCEPTED_RACES
	spells = list(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	advclass_cat_rolls = list(CTAG_WASSOCIATE = 20)

	tutorial = "你的导师曾在你身上看见过潜力，尽管以如今这般严苛艰难的学业来看，你也不确定他们是否仍这么想。魔法之路危险难驯，而你距离能自称这一行的熟手，恐怕还差上数十年。听令，服侍，总有一天你会赢得属于自己的帽子。"

	outfit = /datum/outfit/job/roguetown/wapprentice

	display_order = JDO_MAGEASSOCIATE
	give_bank_account = TRUE

	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/nobility/combat_courtmage.ogg'
	advjob_examine = TRUE // So that Court Magicians can know if they're teachin' a Apprentice or if someone's a bit more advanced of a player. Just makes the title show up as the advjob's name.
	social_rank = SOCIAL_RANK_YEOMAN
	job_traits = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T2)
	job_subclasses = list(
		/datum/advclass/wapprentice/associate,
		/datum/advclass/wapprentice/alchemist,
		/datum/advclass/wapprentice/apprentice
	)

/datum/outfit/job/roguetown/wapprentice
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights/random
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/keyring/mageapprentice
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff
	shoes = /obj/item/clothing/shoes/roguetown/gladiator // FANCY SANDALS

/datum/advclass/wapprentice/associate
	name = "法师侍从"
	tutorial = "你曾只是个学徒，但经过学习与实践，你已经掌握了奥术的基础。如今你继续在导师手下做事、磨练本领，只为有朝一日也能被视作真正的大师。"
	outfit = /datum/outfit/job/roguetown/wapprentice/associate

	category_tags = list(CTAG_WASSOCIATE)
	traits_applied = list(TRAIT_ARCYNE_T3)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1
	)
	subclass_spellpoints = 21
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wapprentice/associate/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	beltl = /obj/item/storage/magebag/associate
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/chalk = 1,
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.mind?.adjust_spellpoints(6)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/wapprentice/alchemist
	name = "炼金侍从"
	tutorial = "在求学过程中，你渐渐不再专注于奥术本身，而是转向了自己真正热爱的炼金术。借由嬗变之艺，你已明白元素与奥术一样，都能被操弄、被扭转，最终服从于你的意志。"
	outfit = /datum/outfit/job/roguetown/wapprentice/alchemist

	category_tags = list(CTAG_WASSOCIATE)
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 1
	)
	subclass_spellpoints = 18
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/wapprentice/alchemist/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/magegreen
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	beltl = /obj/item/storage/magebag/alchemist
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/seeds/swampweed = 1,
		/obj/item/seeds/pipeweed = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/chalk = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/rogueweapon/sickle
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		H.change_stat(STATKEY_PER, -1)
		H.change_stat(STATKEY_INT, 1)
		H.mind?.adjust_spellpoints(3)//split studies, less magic
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
	if(H.mind)
		var/weapons = list("实用炼金","魔导医学")
		var/weapon_choice = input(H, "选择你的工具。", "选择你的专攻。") as anything in weapons
		switch(weapon_choice)
			if("实用炼金")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/aerosolize)
				H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 4, TRUE)
			if("魔导医学")
				l_hand = /obj/item/storage/belt/rogue/surgery_bag
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 4, TRUE)


/datum/advclass/wapprentice/apprentice
	name = "法师学徒"
	tutorial = "你的导师曾在你身上看见过潜力，尽管以如今这般严苛艰难的学业来看，你也不确定他们是否仍这么想。魔法之路危险难驯，而你距离能自称这一行的熟手，恐怕还差上数十年。听令，服侍，总有一天你会赢得属于自己的帽子。"
	outfit = /datum/outfit/job/roguetown/wapprentice/apprentice

	category_tags = list(CTAG_WASSOCIATE)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)//emphasizing the "serve" part of their description
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
	)
	subclass_spellpoints = 18
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,//running around for errands
	)

/datum/outfit/job/roguetown/wapprentice/apprentice/pre_equip(mob/living/carbon/human/H)
	beltl = /obj/item/storage/magebag/associate
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/chalk = 1,
		)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
