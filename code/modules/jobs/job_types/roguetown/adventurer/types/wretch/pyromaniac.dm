/datum/advclass/wretch/pyromaniac
	name = "纵火狂"
	tutorial = "你是臭名昭著、痴迷火焰的纵火犯，怀着私人恩怨向谷地中混乱的诸势力复仇。用烈焰与灾祸带去动乱和毁灭吧！只是……尽量别让自己的爆炸物炸到自己，毕竟你并不防火。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/pyromaniac
	cmode_music = 'sound/music/Iconoclast.ogg'
	class_select_category = CLASS_CAT_MAGE
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_INT = 3
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, // RUN BOY RUN
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT, // To escape grapplers, fuck you
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wretch/pyromaniac/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff //wear protection :)
	mask = /obj/item/clothing/mask/rogue/facemask/
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full //Protect your head!
	pants = /obj/item/clothing/under/roguetown/splintlegs
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	r_hand = /obj/item/bomb
	l_hand = /obj/item/bomb
	backpack_contents = list(
		/obj/item/bomb = 2,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/flint = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	if(H.mind)
		var/weapons = list("弓术", "弩术", "让烈焰降临吧！！！")
		var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("弓术")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltl = /obj/item/quiver/pyroarrows
			if("弩术")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 4, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/quiver/pyrobolts
			if("让烈焰降临吧！！！")
				H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 2, TRUE)
				backr = /obj/item/rogueweapon/woodstaff/toper
				if(H.mind)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/spitfire)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/rebuke)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stoneskin) // To not be instapaincritted if you accidentally hit yourself
		wretch_select_bounty(H)
