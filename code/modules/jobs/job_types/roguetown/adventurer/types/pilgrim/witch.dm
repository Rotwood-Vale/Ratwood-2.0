/datum/advclass/witch
	name = "Witch"
	tutorial = "You are a witch, seen as wisefolk to some and a demon to many. Ostracized and sequestered for wrongthinks or outright heresy, your potions are what the commonfolk turn to when all else fails, and for this they tolerate you — at an arm's length. Take care not to end 'pon a pyre, for the church condemns your left handed arts. \
	\nYour power flows through your TOTEM - a sacred focus bonded to your soul that you MUST hold to cast spells or miracles. You can only ever bond with ONE totem. Feed it with offerings to maintain your power: alchemical reagents for arcane magic, sacred items for divine miracles. Upgrade your totem with materials (magical stone, copper bar, tin bar, iron bar, silver bar, gold bar) to increase its capacity. \
	\nYou can customize your totem's name and description, and recall it to your hand at any time with your Recall Totem spell."
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

	// Cosmetic title selection
	H.adjust_blindness(-3)
	var/cosmetic_titles = list(
		"Witch", "Warlock",
		"Hexer", "Hextress",
		"Enchanter", "Enchantress",
		"Sorceress", "Sorcerer",
		"Conjurer", "Conjuress",
		"Charmer",
		"Diviner", "Divineness",
		"Spellweaver",
		"Mystic",
		"Occultist",
		"Ritualist",
		"Potioneer",
		"Shaman", "Shamaness",
		"Crone", "Peasant", "Herbalist"
	)
	var/cosmetic_choice = input(H, "What title do you bear?", "The Old Ways") as anything in cosmetic_titles
	if(cosmetic_choice)
		H.mind.cosmetic_class_title = cosmetic_choice
		to_chat(H, span_notice("You are known as a [cosmetic_choice]."))

	var/classes = list("Old Magick", "Godsblood", "Mystagogue")
	var/classchoice = input("How do your powers manifest?", "THE OLD WAYS") as anything in classes

	var/shapeshifts = list("Zad", "Cat", "Cat (Black)", "Bat")
	var/shapeshiftchoice = input("What form does your second skin take?", "THE OLD WAYS") as anything in shapeshifts

	switch (classchoice)
		if("Old Magick")

			// the original witch: arcyne 3 (buffed from t2) with arcane totem
			ADD_TRAIT(H, TRAIT_ARCYNE_T3, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
			H.mind?.adjust_spellpoints(14)
			// Give arcane totem
			var/obj/item/witch_totem/arcane_totem = new /obj/item/witch_totem(get_turf(H))
			arcane_totem.totem_type = "arcane"
			arcane_totem.current_energy = arcane_totem.max_energy // Start fully charged
			arcane_totem.bond_to_witch(H)
			H.put_in_hands(arcane_totem, forced = TRUE)

		if("Godsblood")

			//miracle witch: capped at t4 miracles. cannot pray to regain devo, but has high innate regen because of it. And aswell need to use totems and crosses to cast at all.
			var/datum/devotion/D = new /datum/devotion/(H, H.patron)
			H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_3)
			D.max_devotion *= 0.5
			neck = /obj/item/clothing/neck/roguetown/psicross/wood


			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			H.mind?.adjust_spellpoints(6)

			// Give divine totem
			var/obj/item/witch_totem/divine_totem = new /obj/item/witch_totem(get_turf(H))
			divine_totem.totem_type = "divine"
			divine_totem.current_energy = divine_totem.max_energy // Start fully charged
			divine_totem.bond_to_witch(H)
			H.put_in_hands(divine_totem, forced = TRUE)

		if("Mystagogue")
			// hybrid arcane/holy witch with t2 arcane and t2 miracles, but less spellpoints, lower max devotion and less regen (0.5). Still can't pray.
			var/datum/devotion/D = new /datum/devotion/(H, H.patron)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
			D.max_devotion *= 0.5


			ADD_TRAIT(H, TRAIT_ARCYNE_T2, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			H.mind?.adjust_spellpoints(8)
			neck = /obj/item/clothing/neck/roguetown/psicross/wood

			// Give hybrid totem
			var/obj/item/witch_totem/hybrid_totem = new /obj/item/witch_totem(get_turf(H))
			hybrid_totem.totem_type = "hybrid"
			hybrid_totem.current_energy = hybrid_totem.max_energy // Start fully charged
			hybrid_totem.bond_to_witch(H)
			H.put_in_hands(hybrid_totem, forced = TRUE)

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

	// SKILL SELECTION
	if(H.mind)
		var/misc_skills = list(
			"Stealing" = /datum/skill/misc/stealing,
			"Music" = /datum/skill/misc/music,
			"Tracking" = /datum/skill/misc/tracking,
			"Lockpicking" = /datum/skill/misc/lockpicking,
			"Sneaking" = /datum/skill/misc/sneaking,
			"Riding" = /datum/skill/misc/riding
		)
		var/labor_skills = list(
			"Farming" = /datum/skill/labor/farming,
			"Lumberjacking" = /datum/skill/labor/lumberjacking,
			"Fishing" = /datum/skill/labor/fishing,
			"Butchering" = /datum/skill/labor/butchering,
			"Mining" = /datum/skill/labor/mining
		)
		var/craft_skills = list(
			"Ceramics" = /datum/skill/craft/ceramics,
			"Masonry" = /datum/skill/craft/masonry,
			"Engineering" = /datum/skill/craft/engineering,
			"Traps" = /datum/skill/craft/traps,
			"Tanning" = /datum/skill/craft/tanning,
		)
		var/combat_skills = list(
			"Axes" = /datum/skill/combat/axes,
			"Unarmed" = /datum/skill/combat/unarmed,
			"Knives" = /datum/skill/combat/knives,
			"Wrestling" = /datum/skill/combat/wrestling,
			"Staves" = /datum/skill/combat/staves,
			"Whips & Flails" = /datum/skill/combat/whipsflails,
			"Bows" = /datum/skill/combat/bows,
			"Crossbows" = /datum/skill/combat/crossbows,
			"Polearms" = /datum/skill/combat/polearms,
			"Shields" = /datum/skill/combat/shields,
			"Slings" = /datum/skill/combat/slings,
			"Swords" = /datum/skill/combat/swords,
			"Maces" = /datum/skill/combat/maces
		)

		// Select one skill to EXPERT
		var/expert_skill_name = input(H, "Choose one skill to EXPERT. [1/1]", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills
		if(expert_skill_name)
			H.adjust_skillrank_up_to(misc_skills[expert_skill_name] || labor_skills[expert_skill_name] || craft_skills[expert_skill_name], SKILL_LEVEL_EXPERT, TRUE)
			if(expert_skill_name in misc_skills)
				misc_skills -= expert_skill_name
			if(expert_skill_name in labor_skills)
				labor_skills -= expert_skill_name
			if(expert_skill_name in craft_skills)
				craft_skills -= expert_skill_name 

		// Select one MISC/LABOR/CRAFT skill to JOURNEYMAN
		for(var/i in 1 to 1)
			var/journeyman_name = input(H, "Choose one skill to JOURNEYMAN. [1/1]", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills
			if(journeyman_name)
				H.adjust_skillrank_up_to(misc_skills[journeyman_name] || labor_skills[journeyman_name] || craft_skills[journeyman_name], SKILL_LEVEL_JOURNEYMAN, TRUE)
				if(journeyman_name in misc_skills)
					misc_skills -= journeyman_name
				if(journeyman_name in labor_skills)
					labor_skills -= journeyman_name
				if(journeyman_name in craft_skills)
					craft_skills -= journeyman_name

		// Select one COMBAT skill to JOURNEYMAN
		var/journeyman_combat_name = input(H, "Choose a COMBAT skill to JOURNEYMAN. [1/1]", "Skill Selection") as anything in combat_skills
		if(journeyman_combat_name)
			H.adjust_skillrank_up_to(combat_skills[journeyman_combat_name], SKILL_LEVEL_JOURNEYMAN, TRUE)
			if(journeyman_combat_name in combat_skills)
				combat_skills -= journeyman_combat_name

		// Select two skills to APPRENTICE
		for(var/i in 1 to 3)
			var/apprentice_name = input(H, "Choose a skill to APPRENTICE. [i]/3", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(apprentice_name)
				H.adjust_skillrank_up_to(misc_skills[apprentice_name] || labor_skills[apprentice_name] || craft_skills[apprentice_name] || combat_skills[apprentice_name], SKILL_LEVEL_APPRENTICE, TRUE)
				if(apprentice_name in misc_skills)
					misc_skills -= apprentice_name
				if(apprentice_name in labor_skills)
					labor_skills -= apprentice_name
				if(apprentice_name in craft_skills)
					craft_skills -= apprentice_name
				if(apprentice_name in combat_skills)
					combat_skills -= apprentice_name

		// Select three skills to NOVICE
		for(var/i in 1 to 2)
			var/novice_name = input(H, "Choose a skill to NOVICE. [i]/2", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(novice_name)
				H.adjust_skillrank_up_to(misc_skills[novice_name] || labor_skills[novice_name] || craft_skills[novice_name] || combat_skills[novice_name], SKILL_LEVEL_NOVICE, TRUE)
				if(novice_name in misc_skills)
					misc_skills -= novice_name
				if(novice_name in labor_skills)
					labor_skills -= novice_name
				if(novice_name in craft_skills)
					craft_skills -= novice_name
				if(novice_name in combat_skills)
					combat_skills -= novice_name

	// TRAIT SELECTION
	if(H.mind)
		var/witch_traits = list(
			"Seedknow" = TRAIT_SEEDKNOW,
			"Empath" = TRAIT_EMPATH,
			"Night Vision" = TRAIT_NIGHT_VISION,
			"Keen Ears" = TRAIT_KEENEARS,
			"Sleuth" = TRAIT_SLEUTH,
			"Outdoorsman" = TRAIT_OUTDOORSMAN,
			"Woodwalker" = TRAIT_WOODWALKER,
			"Light Step" = TRAIT_LIGHT_STEP,
			"Perfect Tracker" = TRAIT_PERFECT_TRACKER,
			"Beautiful" = TRAIT_BEAUTIFUL,
			"Good Lover" = TRAIT_GOODLOVER,
			"Intellectual" = TRAIT_INTELLECTUAL,
			"Sewing Expert" = TRAIT_SEWING_EXPERT,
			"Dyes Master" = TRAIT_DYES,
			"Survival Expert" = TRAIT_SURVIVAL_EXPERT
		)

		// Select three traits
		for(var/i in 1 to 4)
			var/trait_name = input(H, "Choose a trait [i]/4.", "Trait Selection") as anything in witch_traits
			if(trait_name)
				ADD_TRAIT(H, witch_traits[trait_name], TRAIT_GENERIC)
				if(trait_name in witch_traits)
					witch_traits -= trait_name

	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/armor/corset
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt/red

	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_LCK, 1)
		H.mind?.adjust_spellpoints(6)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_ZURCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_ZURCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_ZURCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_ZURCH, TRAIT_GENERIC)

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
