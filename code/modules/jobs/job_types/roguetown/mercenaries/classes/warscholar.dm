/datum/advclass/mercenary/warscholar
	name = "Naledi Hierophant"
	tutorial = "You are a Naledi Hierophant, the most orthodox of all Naledian Magi to an outsider. You practice the art of Exomagic - channeling mana outward for both destructive and constructive purposes. Many of your kinds prioritize enhancing the potential of their teammates from behind, believing in the superiority and potent of the humen body. Some however, may take a more direct approach to the question of how to lay low Psydon's foes - incineration and annihilation."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS

	outfit = /datum/outfit/job/roguetown/mercenary/warscholar
	subclass_languages = list(/datum/language/celestial)
	class_select_category = CLASS_CAT_NALEDI
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_WARMAGE)
	cmode_music = 'sound/music/warscholar.ogg'
	traits_applied = list(TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT, TRAIT_NALEDI, TRAIT_MAGEDEXTERITY)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_CON = -1
	)
	age_mod = /datum/class_age_mod/war_scholar
	virtue_restrictions = list(/datum/virtue/combat/tough_hide)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 6, "post_aspect_spells" = list(/datum/action/cooldown/spell/mindlink, /datum/action/cooldown/spell/mending), "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/arcyne = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
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
	if(H.mind)
		detailcolor = input(H, "Choose a color.", "NALEDIAN COLORPLEX") as anything in naledicolors
		detailcolor = naledicolors[detailcolor]
		H.mind.AddSpell(new /datum/action/cooldown/spell/ley_lines)
	r_hand = /obj/item/rogueweapon/woodstaff/implement/grand/naledi
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
	var/naledi_book = pick(/obj/item/book/rogue/naledi1, /obj/item/book/rogue/naledi2, /obj/item/book/rogue/naledi3, /obj/item/book/rogue/naledi4)
	backpack_contents = list(
		/obj/item/chalk = 1,
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rogueweapon/spellbook/greater = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		(naledi_book) = 1
		)
	H.merctype = 14


/datum/advclass/mercenary/warscholar/pontifex
	name = "Naledi Pontifex"
	age_mod = /datum/class_age_mod/pontifex
	tutorial = "A Naledi Pontifex, trained in the discipline of Automagic - enhancement of one's own body through Arcyne Magick. \
		Your fists and your will are the one thing that cannot be deprived from you, handy tools when your homeland is rife with treacherous djinns and humens alike. \
		Where your fists fall short, your wits prevail. Where your magyck falters, your fists answer. \
		And when both are found wanting, the Naledian art of blade conjuration will lend you a Katar to cut demons and humens alike to ribbons."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/mercenary/warscholar_pontifex
	subclass_languages = list(/datum/language/celestial, /datum/language/thievescant)
	class_select_category = CLASS_CAT_NALEDI
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_WARMAGE)
	cmode_music = 'sound/music/warscholar.ogg'
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_ARCYNE, TRAIT_NALEDI)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 3
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/arcyne = SKILL_LEVEL_EXPERT, // Bare-handed abilities no weapon and read AA. Match unarmed.
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
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 4, ward = TRUE, "locked_aspects" = list(/datum/magic_aspect/autowardry))

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex
	var/detailcolor
	var/sidearm_selected
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex/Topic(href, href_list)
	. = ..()
	if(href_list["sidearm"])
		sidearm_selected = href_list["sidearm"]

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
	if(H.mind)
		detailcolor = input(H, "Choose a color.", "NALEDIAN COLORPLEX") as anything in naledicolors
		detailcolor = naledicolors[detailcolor]
		H.mind.AddSpell(new /datum/action/cooldown/spell/fist_of_psydon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/grasp_of_psydon())
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadowstep)
		H.mind.AddSpell(new /datum/action/cooldown/spell/storm_of_psydon())
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/blade_of_psydon())
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.set_chant("unarmed")

	sidearm_selected = null
	var/chant_html = get_spellfist_chant_html(src, H)
	H << browse(chant_html, "window=spellfist_tutorial;size=650x700")
	onclose(H, "spellfist_tutorial", src)

	var/open_time = world.time
	while(!sidearm_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellfist_tutorial")

	if(!sidearm_selected)
		sidearm_selected = "katar"

	switch(sidearm_selected)
		if("katar")
			H.put_in_hands(new /obj/item/rogueweapon/katar(H))
		if("knuckledusters")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/knuckles(H))

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
	var/naledi_book = pick(/obj/item/book/rogue/naledi1, /obj/item/book/rogue/naledi2, /obj/item/book/rogue/naledi3, /obj/item/book/rogue/naledi4)
	backpack_contents = list(
		/obj/item/chalk = 1,
		/obj/item/roguekey/mercenary = 1,
		/obj/item/lockpick = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		(naledi_book) = 1,
		/obj/item/rogueweapon/spellbook/greater = 1,
		)
	H.merctype = 14

/datum/advclass/mercenary/warscholar/vizier
	name = "Naledi Vizier"
	tutorial = "You are a Naledi Vizier. Your research into miracles and holy incantations has lead you to esoteric magycks. Though psydonians have long struggled to channel their all-father's divinity, The Great City of Naledi came the closest with its Origin Magic."
	outfit = /datum/outfit/job/roguetown/mercenary/warscholar_vizier
	traits_applied = list(TRAIT_ALCHEMY_EXPERT, TRAIT_NALEDI, TRAIT_MEDICINE_EXPERT, TRAIT_MAGEDEXTERITY, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
	)
	virtue_restrictions = list(/datum/virtue/combat/tough_hide)
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
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 6, "locked_aspects" = list(/datum/magic_aspect/lesser_augmentation), "ward" = TRUE)

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
		detailcolor = input(H, "Choose a color.", "NALEDIAN COLORPLEX") as anything in naledicolors
		detailcolor = naledicolors[detailcolor]
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/rimecast)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
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
