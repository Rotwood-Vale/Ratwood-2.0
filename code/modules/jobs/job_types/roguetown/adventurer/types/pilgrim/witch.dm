/datum/advclass/witch
	name = "Witch"
	tutorial = "You are a witch, seen as wisefolk to some and a demon to many. Ostracized and sequestered for wrongthinks or outright heresy, your potions are what the commonfolk turn to when all else fails, and for this they tolerate you — at an arm's length. Take care not to end 'pon a pyre, for the church condemns your left handed arts."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/witch
	subclass_social_rank = SOCIAL_RANK_PEASANT
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_DEATHSIGHT, TRAIT_WITCH, TRAIT_ARCYNE_T1, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1
	)

	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/witch/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/witchhat
	mask = /obj/item/clothing/head/roguetown/roguehood/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/storage/magebag/witch
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/reagent_containers/glass/mortar = 1,
						/obj/item/pestle = 1,
						/obj/item/candle/yellow = 2,
						/obj/item/recipe_book/alchemy = 1,
						/obj/item/recipe_book/survival = 1,
						/obj/item/recipe_book/magic = 1,
						/obj/item/chalk = 1
						)

	var/classes = list("Old Magick", "Godsblood", "Mystagogue")
	var/classchoice = input("How do your powers manifest?", "THE OLD WAYS") as anything in classes

	var/shapeshifts = list("Zad", "Cat", "Cat (Black)", "Bat")
	var/shapeshiftchoice = input("What form does your second skin take?", "THE OLD WAYS") as anything in shapeshifts

	switch (classchoice)
		if("Old Magick")
			// the original witch: arcyne t2 (buffed from t1) with 6 spellpoints
			ADD_TRAIT(H, TRAIT_ARCYNE_T2, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			H.mind?.adjust_spellpoints(9) // twelve if you pick arcyne potential
		if("Godsblood")
			//miracle witch: capped at t2 miracles. cannot pray to regain devo, but has high innate regen because of it (2 instead of 1 from major)
			var/datum/devotion/D = new /datum/devotion/(H, H.patron)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_2)
			D.max_devotion *= 0.5
			neck = /obj/item/clothing/neck/roguetown/psicross/wood
		if("Mystagogue")
			// hybrid arcane/holy witch with t1 arcane and t1 miracles, but less spellpoints, lower max devotion and less regen (0.5). Still can't pray.
			var/datum/devotion/D = new /datum/devotion/(H, H.patron)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
			D.max_devotion *= 0.5
			ADD_TRAIT(H, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			H.mind?.adjust_spellpoints(6) // twelve if you pick arcyne potential
			neck = /obj/item/clothing/neck/roguetown/psicross/wood

	if(H.mind)
		switch (shapeshiftchoice)
			if("Zad")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/crow/witch)
			if("Cat")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/cat)
			if("Cat (Black)")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/cat/black)
			if("Bat")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/bat/witch)

		switch (classchoice)
			if("Old Magick")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/guidance)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/arcynebolt)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/aerosolize)

	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/armor/corset
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt/red

	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_LCK, 1)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)

/obj/effect/proc_holder/spell/targeted/shapeshift/crow/witch
	knockout_on_death = 15 SECONDS
	shifted_speed_increase = 0.75 //25% slower than normal walking speed
	show_true_name = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/bat/witch
	overlay_state = "bat_transform"
	knockout_on_death = 15 SECONDS
	shifted_speed_increase = 0.75
	show_true_name = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/cat
	name = "Cat Form"
	desc = ""
	overlay_state = "cat_transform"
	gesture_required = TRUE
	chargetime = 5 SECONDS
	recharge_time = 50
	cooldown_min = 50
	shapeshift_type = /mob/living/simple_animal/pet/cat/witch_shifted
	convert_damage = FALSE
	do_gib = FALSE
	shifted_speed_increase = 1.35
	show_true_name = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/cat/black
	shapeshift_type = /mob/living/simple_animal/pet/cat/rogue/black/witch_shifted

/mob/living/simple_animal/pet/cat/witch_shifted
	name = "aloof cat"
	desc = "A bored-seeming feline. This one has a peculiar intelligence in its green eyes..."
	defprob = 90
	STASPD = 18
	STASTR = 1
	STACON = 3
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 2
	melee_damage_upper = 5

/mob/living/simple_animal/pet/cat/rogue/black/witch_shifted
	name = "voidblack cat"
	desc = "Supposedly sacred to Necra, and just as interested in rats as their lesser counterparts. This one has a strange intelligence behind its dark, wide eyes..."
	defprob = 90
	STASPD = 18
	STASTR = 1
	STACON = 3
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 2
	melee_damage_upper = 5

/datum/intent/simple/claw/witch_cat
	name = "scratch"
	attack_verb = list("scratches", "claws")