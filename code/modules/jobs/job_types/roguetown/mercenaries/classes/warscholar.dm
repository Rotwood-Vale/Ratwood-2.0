/datum/advclass/mercenary/warscholar
	name = "Naledi Hierophant"
	tutorial ="You are a Naledi Hierophant, a magician who studied under cloistered sages, well-versed in all manners of arcyne. You prioritize enhancing your teammates and distracting foes while staying in the backline."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/warscholar
	subclass_languages = list(/datum/language/celestial)
	class_select_category = CLASS_CAT_NALEDI
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/warscholar.ogg'
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_ALCHEMY_EXPERT, TRAIT_NALEDI)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_CON = -1
	)
	subclass_spellpoints = 15
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/warscholar
	var/detailcolor
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/mercenary/warscholar/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/naledicolors = sortList(list(
		"GOLD" = "#C8BE6D",
		"PALE PURPLE" = "#9E93FF",
		"BLUE" = "#A7B4F6",
		"BRICK BROWN" = "#773626",
		"PURPLE" = "#B542AC",
		"GREEN" = "#62a85f",
		"BLUE" = "#A9BFE0",
		"RED" = "#ED6762",
		"ORANGE" = "#EDAF6D",
		"PINK" = "#EDC1D5",
		"MAROON" = "#5F1F34",
		"BLACK" = "#242526"
	))
	to_chat(H, span_warning("You are a Naledi Hierophant, a magician who studied under cloistered sages, well-versed in all manners of arcyne. You prioritize enhancing your teammates and distracting foes while staying in the backline."))
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 5, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
		H.mind?.adjust_spellpoints(6)
	if(H.mind)
		detailcolor = input("Choose a color.", "NALEDIAN COLORPLEX") as anything in naledicolors
		detailcolor = naledicolors[detailcolor]
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/giants_strength)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/longstrider)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/guidance)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/haste)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fortitude)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/forcewall/greater)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/ley_lines)
	r_hand = /obj/item/rogueweapon/woodstaff/naledi


	head = /obj/item/clothing/head/roguetown/roguehood/hierophant
	cloak = /obj/item/clothing/cloak/hierophant
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	pants = /obj/item/clothing/under/roguetown/trou/leather
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi
	wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/flashlight/flare/torch
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/roguegem/amethyst/naledi = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1
		)
	H.merctype = 14

/datum/advclass/mercenary/warscholar/pontifex
	name = "Naledi Pontifex"
	tutorial = "You are a Naledi Pontifex, a warrior trained into a hybridized style of movement-controlling magic and hand-to-hand combat. Your chosen Path determines your specialization, though you'll never match another mage in pure magical power. Instead, you manifest an imitation of a shard of PSYDON's blade and rely on trickery and battlefield control."
	outfit = /datum/outfit/job/roguetown/mercenary/warscholar_pontifex
	subclass_languages = list(/datum/language/celestial)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_CIVILIZEDBARBARIAN, TRAIT_ARCYNE_T1, TRAIT_NALEDI)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
		STATKEY_PER = -1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_spellpoints = 4 // Override inheritance

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex
	var/detailcolor
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/naledicolors = sortList(list(
		"GOLD" = "#C8BE6D",
		"PALE PURPLE" = "#9E93FF",
		"BLUE" = "#A7B4F6",
		"BRICK BROWN" = "#773626",
		"PURPLE" = "#B542AC",
		"GREEN" = "#62a85f",
		"BLUE" = "#A9BFE0",
		"RED" = "#ED6762",
		"ORANGE" = "#EDAF6D",
		"PINK" = "#EDC1D5",
		"MAROON" = "#5F1F34",
		"BLACK" = "#242526"
	))
	to_chat(H, span_warning("You are a Naledi Pontifex, a warrior trained into a hybridized style of movement-controlling magic and hand-to-hand combat. Though your abilities in magical fields are lacking, you are far more dangerous than other magi in a straight fight. You manifest your calm, practiced skill into a killing intent that takes the shape of an arcyne blade."))
	if(H.mind)
		detailcolor = input("Choose a color.", "NALEDIAN COLORPLEX") as anything in naledicolors
		detailcolor = naledicolors[detailcolor]
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/bladeofpsydon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadowstep)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)
		H.mind.AddSpell(new/obj/effect/proc_holder/spell/invoked/projectile/repel)
		var/weapons = list("Path of War","Path of Control","Path of Shadows","Path of Survival")
		var/weapon_choice = input(H, "Choose your path.", "WHAT PATH DO YOU WALK?") as anything in weapons
		switch(weapon_choice)
			if("Path of War")//Weak combat stuff only
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/airblade)//longer CD than arcane bolt but more versatile
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
			if("Path of Control")//Battlefield control, minimal damage dealing
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/ensnare)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/forcewall/greater)
			if("Path of Shadows")//Sneaky trickster punchmage
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/lesserknock)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/invisibility)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/blindness/warscholar)
			if("Path of Survival")//Trade magic for skills
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, 3, TRUE)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)//as a bodyguard it can be REALLY important to find where the bleed is.

	head = /obj/item/clothing/head/roguetown/roguehood/pontifex
	gloves = /obj/item/clothing/gloves/roguetown/angle/pontifex
	head = /obj/item/clothing/head/roguetown/roguehood/pontifex
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/pointfex
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi
	wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/flashlight/flare/torch
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/lockpick = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.merctype = 14

/datum/advclass/mercenary/warscholar/vizier
	name = "Naledi Vizier"
	tutorial = "You are a Naledi Vizier. Your research into miracles and holy incantations has lead you to esoteric magycks. Though psydonians have long struggled to channel their all-father's divinity, The Great City of Naledi came the closest with it's Origin Magic."
	outfit = /datum/outfit/job/roguetown/mercenary/warscholar_vizier
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_ALCHEMY_EXPERT, TRAIT_NALEDI, TRAIT_MEDICINE_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)
	subclass_spellpoints = 9

/datum/outfit/job/roguetown/mercenary/warscholar_vizier
	var/detailcolor
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/mercenary/warscholar_vizier/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/naledicolors = sortList(list(
		"GOLD" = "#C8BE6D",
		"PALE PURPLE" = "#9E93FF",
		"BLUE" = "#A7B4F6",
		"BRICK BROWN" = "#773626",
		"PURPLE" = "#B542AC",
		"GREEN" = "#62a85f",
		"BLUE" = "#A9BFE0",
		"RED" = "#ED6762",
		"ORANGE" = "#EDAF6D",
		"PINK" = "#EDC1D5",
		"MAROON" = "#5F1F34",
		"BLACK" = "#242526"
	))
	to_chat(H, span_warning("You are a Naledi Vizier. Your research into miracles and holy incantations has lead you to esoteric magycks. Though psydonians have long struggled to channel their all-father's divinity, The Great City of Naledi came the closest with it's Origin Magic."))
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 3, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
		H.mind?.adjust_spellpoints(3)
	r_hand = /obj/item/rogueweapon/woodstaff/naledi
	//Since we lack unique Vizier clothing, we're mixing hierophant and pontifex for Vizier
	head = /obj/item/clothing/head/roguetown/roguehood/hierophant	//Keep this hood. It's middling armor, but the robe/gambeson combination is exceedingly good armor for the class. The vizier's head is a weak point.
	cloak = /obj/item/clothing/cloak/hierophant
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	pants = /obj/item/clothing/under/roguetown/trou/leather
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi
	wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/flashlight/flare/torch
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backr = /obj/item/storage/backpack/rogue/satchel/black

	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
	if(H.mind)
		detailcolor = input("Choose a color.", "NALEDIAN COLORPLEX") as anything in naledicolors
		detailcolor = naledicolors[detailcolor]
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/frostbolt) // because other clerics get holy bolt and so you're not entirely pressured to take combat spells
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/regression)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convergence)	//increases heal effect,
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stasis)		//wound/injurying reversion, revive capable at a cost
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/acceleration)	//speedup with a cost
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/divergence)	//potential to heal and injure targets
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/psydonrespite)//Naledi Vizier spells functionally replace psydonite ones
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/check_boot)
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/psydonendure)
	H.merctype = 14



/datum/outfit/job/roguetown/mercenary/warscholar/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	for(var/obj/item/clothing/V in H.get_equipped_items(FALSE))
		if(V.naledicolor)
			V.color = detailcolor
			V.update_icon()
	H.regenerate_icons()

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	for(var/obj/item/clothing/V in H.get_equipped_items(FALSE))
		if(V.naledicolor)
			V.color = detailcolor
			V.update_icon()
	H.regenerate_icons()

/datum/outfit/job/roguetown/mercenary/warscholar_vizier/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	for(var/obj/item/clothing/V in H.get_equipped_items(FALSE))
		if(V.naledicolor)
			V.color = detailcolor
			V.update_icon()
	H.regenerate_icons()
