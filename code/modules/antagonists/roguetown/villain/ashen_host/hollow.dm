// HOLLOW LEGIONARIES
// Disposable bone-soldiers of the Ashen Host. Weaker than every living class, medium armor at best,

/datum/advclass/ashen_host/hollow
	name = "Hollow Legionary"
	tutorial = "You are a Legionary of the Godslaying War, a bone-soldier dragged from the grave and bound to the Ashen Host. You are the least of its soldiers, a spent blade that the Legate may use and throw away. Your mind is hollow and your flesh is long gone, yet you remember how to march, guard and strike. Serve the Legate, follow the Host, and spend yourself where you are told."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/ashen_host/hollow/legionary
	class_select_category = CLASS_CAT_ACCURSED
	category_tags = list(CTAG_ASHEN)
	maximum_possible_slots = 10
	applies_post_equipment = TRUE
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_SPD = -1,
		STATKEY_PER = 1,
		STATKEY_INT = -5,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)
	adv_stat_ceiling = list(STAT_CONSTITUTION = 12, STAT_WILLPOWER = 14)

/datum/advclass/ashen_host/hollow_ballistiares
	name = "Hollow Ballistiares"
	tutorial = "Your frame has wept off its skin and your fingers are mere bone, yet your aim remains true. You were a Legionary's bowman in the Godslaying War, and the Ashen Host has bound you to its ranks. Stay behind the Legate's line and loose where you are told. You are the least of the Host, and it will spend you freely."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/ashen_host/hollow/ballistiares
	class_select_category = CLASS_CAT_ACCURSED
	category_tags = list(CTAG_ASHEN)
	maximum_possible_slots = 4
	applies_post_equipment = TRUE
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_BLOODLOSS_IMMUNE)
	subclass_stats = list(
		STATKEY_PER = 5,
		STATKEY_WIL = 2,
		STATKEY_CON = -4,
		STATKEY_INT = -5,
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)
	adv_stat_ceiling = list(STAT_CONSTITUTION = 10, STAT_WILLPOWER = 14)

// Shared skeleton setup
/datum/outfit/job/roguetown/ashen_host/hollow

/datum/outfit/job/roguetown/ashen_host/hollow/pre_equip(mob/living/carbon/human/H)
	..()

	H.become_skeleton()
	H.possible_rmb_intents = list(/datum/rmb_intent/feint,\
	/datum/rmb_intent/aimed,\
	/datum/rmb_intent/riposte,\
	/datum/rmb_intent/strong,\
	/datum/rmb_intent/weak)
	H.swap_rmb_intent(num=1)

	H.set_patron(/datum/patron/inhumen/zizo)
	if(H.mind)
		H.mind.add_antag_datum(new /datum/antagonist/skeleton())
	ADD_TRAIT(H, TRAIT_OUTLAW, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SHATTER_WEAKNESS, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NO_VOICEPACK_OVERRIDE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSLEEP, TRAIT_GENERIC)
	H.grant_language(/datum/language/undead)
	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/undead

	H.choose_name_popup("Hollow Legionary")

	H.cmode_music = 'sound/music/combat_weird.ogg'

	belt = /obj/item/storage/belt/rogue/leather/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient
	backr = /obj/item/storage/backpack/rogue/satchel/black

	H.taints_loot = TRUE

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)

/datum/outfit/job/roguetown/ashen_host/hollow/proc/choose_neck(mob/living/carbon/human/H)
	var/neckwear = list("Coif", "Gorget")
	var/neckwear_choice = input(H, "Choose your PROTECTION.", "A BULWARK TO LAST FOREVER.") as anything in neckwear
	switch(neckwear_choice)
		if("Coif")
			neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
		if("Gorget")
			neck = /obj/item/clothing/neck/roguetown/gorget/steel/ancient

/datum/outfit/job/roguetown/ashen_host/hollow/proc/choose_cloak(mob/living/carbon/human/H)
	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

/datum/outfit/job/roguetown/ashen_host/hollow/proc/finish_hollow(mob/living/carbon/human/H)
	H.set_blindness(0)
	H.energy = H.max_energy
	to_chat(H, span_danger("You are playing an Antagonist role. Your very existence is an abomination — everyone is justified in laying you down. You are an ancient warrior risen from death."))

/datum/outfit/job/roguetown/ashen_host/hollow/legionary/pre_equip(mob/living/carbon/human/H)
	..()

	head = /obj/item/clothing/head/roguetown/helmet/heavy/ancient
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
	shoes = /obj/item/clothing/shoes/roguetown/sandals/ancient
	gloves = /obj/item/clothing/gloves/roguetown/chain/ancient
	r_hand = /obj/item/rogueweapon/shield/gilbranze

	backpack_contents = list(
		/obj/item/natural/feather = 1, // For your helm
		/obj/item/storage/belt/rogue/pouch/coins/gilbranze = 1
	)

	H.adjust_blindness(-3)
	var/weapons = list("Gladius", "Khopesh", "Shortsword", "Axe", "Flail")
	var/weapons_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
	switch(weapons_choice)
		if("Gladius")
			l_hand = /obj/item/rogueweapon/sword/short/gladius/ancient
			beltl = /obj/item/rogueweapon/scabbard
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Khopesh")
			l_hand = /obj/item/rogueweapon/sword/sabre/ancient
			beltl = /obj/item/rogueweapon/scabbard
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Shortsword")
			l_hand = /obj/item/rogueweapon/sword/short/ancient
			beltl = /obj/item/rogueweapon/scabbard
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Axe")
			l_hand = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
		if("Flail")
			l_hand = /obj/item/rogueweapon/flail/sflail/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)

	var/sidearms = list("Javelins", "Net", "Dagger")
	var/sidearms_choice = input(H, "Choose your SIDEARM.", "RAGE AGAINST THE LYVING.") as anything in sidearms
	switch(sidearms_choice)
		if("Javelins")
			beltr = /obj/item/quiver/javelin/ancient
		if("Net")
			beltr = /obj/item/net
		if("Dagger")
			beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient

	choose_neck(H)
	choose_cloak(H)
	finish_hollow(H)

/datum/outfit/job/roguetown/ashen_host/hollow/ballistiares/pre_equip(mob/living/carbon/human/H)
	..()

	head = /obj/item/clothing/head/roguetown/helmet/kettle/ancient
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
	shoes = /obj/item/clothing/shoes/roguetown/sandals/ancient
	gloves = /obj/item/clothing/gloves/roguetown/chain/ancient
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient

	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/gilbranze = 1
	)

	H.adjust_blindness(-3)
	var/weapons = list("Recurve Bow", "Yew Longbow", "Crossbow", "Sling")
	var/weapons_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
	switch(weapons_choice)
		if("Recurve Bow")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			beltr = /obj/item/quiver/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
		if("Yew Longbow")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
			beltr = /obj/item/quiver/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
		if("Crossbow")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/ancient
			beltr = /obj/item/quiver/boltsancient
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
		if("Sling")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			beltr = /obj/item/quiver/sling/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)

	choose_neck(H)
	choose_cloak(H)
	finish_hollow(H)
