// BLACKGUARD - medium armor, a melee weapon and usually a shield

/datum/advclass/ukj_varlet
	name = "Blackguard"
	tutorial = "You stand in the line at your master's side and haul their gear the rest of the time. Each fight leaves you a little harder and a little more devout."
	outfit = /datum/outfit/job/roguetown/ukj_varlet
	category_tags = list(CTAG_UKJ_VARLET)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
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
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/ukj_varlet
	has_loadout = TRUE

/datum/outfit/job/roguetown/ukj_varlet/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/polishing_cream = 1,
		/obj/item/armor_brush = 1,
		/obj/item/repair_kit/metal = 1,
		/obj/item/repair_kit = 1,
		/obj/item/folding_table_stored = 1,
	)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			backpack_contents[/obj/item/book/rogue/bibble/zizo] = 1
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
	if(H.mind)
		wretch_select_bounty(H)

/datum/outfit/job/roguetown/ukj_varlet/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	var/helmets = list(
		"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"Bascinet Helmet"		= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"None"
	)
	var/helmchoice = input(H, "Choose your helm.", "TAKE UP HELMS") as anything in helmets
	var/helm = helmets[helmchoice]
	if(helm)
		H.equip_to_slot_or_del(new helm(H), SLOT_HEAD, TRUE)

	var/cloaks = list("Surcoat", "Tabard", "Jupon")
	var/cloaks_choice = input(H, "Choose your cloak.", "BEAR YOUR MASTER'S COLORS.") as anything in cloaks
	switch(cloaks_choice)
		if("Surcoat")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("Tabard")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("Jupon")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/arms_choice = input(H, "Choose your arms.", "TAKE UP ARMS FOR YOUR GOD") as anything in list("Arming Sword & Shield", "Mace", "Flail & Shield", "Messer & Buckler", "Battle Axe")
	switch(arms_choice)
		if("Arming Sword & Shield")
			H.put_in_hands(new /obj/item/rogueweapon/sword(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/shield/heater(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Mace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Flail & Shield")
			H.put_in_hands(new /obj/item/rogueweapon/flail(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/shield/heater(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Messer & Buckler")
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/messer(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/shield/buckler(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Battle Axe")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)

// STABLEHAND - medium armor, a polearm and a horse

/datum/advclass/ukj_varlet_stablehand
	name = "Stablehand"
	tutorial = "You ride to war with a polearm in hand and see to the horses when the fighting's over. At least the horses don't care who your master prays to."
	outfit = /datum/outfit/job/roguetown/ukj_varlet_stablehand
	category_tags = list(CTAG_UKJ_VARLET)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
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
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/ukj_varlet_stablehand
	has_loadout = TRUE

/datum/outfit/job/roguetown/ukj_varlet_stablehand/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/polishing_cream = 1,
		/obj/item/armor_brush = 1,
		/obj/item/repair_kit/metal = 1,
		/obj/item/repair_kit = 1,
		/obj/item/folding_table_stored = 1,
	)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			backpack_contents[/obj/item/book/rogue/bibble/zizo] = 1
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
	if(H.mind)
		wretch_select_bounty(H)

/datum/outfit/job/roguetown/ukj_varlet_stablehand/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	var/helmets = list(
		"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"Bascinet Helmet"		= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"None"
	)
	var/helmchoice = input(H, "Choose your helm.", "TAKE UP HELMS") as anything in helmets
	var/helm = helmets[helmchoice]
	if(helm)
		H.equip_to_slot_or_del(new helm(H), SLOT_HEAD, TRUE)

	var/cloaks = list("Surcoat", "Tabard", "Jupon")
	var/cloaks_choice = input(H, "Choose your cloak.", "BEAR YOUR MASTER'S COLORS.") as anything in cloaks
	switch(cloaks_choice)
		if("Surcoat")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("Tabard")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("Jupon")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/arms_choice = input(H, "Choose your arms.", "TAKE UP ARMS FOR YOUR GOD") as anything in list("Halberd", "Billhook", "Spear & Javelins", "Lance & Buckler")
	switch(arms_choice)
		if("Halberd")
			H.put_in_hands(new /obj/item/rogueweapon/halberd(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Billhook")
			H.put_in_hands(new /obj/item/rogueweapon/spear/billhook(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Spear & Javelins")
			H.put_in_hands(new /obj/item/rogueweapon/spear(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/javelin/iron(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Lance & Buckler")
			H.put_in_hands(new /obj/item/rogueweapon/spear/lance(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/buckler(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)

// HARRIER - light armor, a bow and quick feet

/datum/advclass/ukj_varlet_harrier
	name = "Harrier"
	tutorial = "You hang back and wear the enemy down with bolts, stones or javelins until your master is ready to finish them."
	outfit = /datum/outfit/job/roguetown/ukj_varlet_harrier
	category_tags = list(CTAG_UKJ_VARLET)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT)
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
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/ukj_varlet_harrier
	has_loadout = TRUE

/datum/outfit/job/roguetown/ukj_varlet_harrier/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/polishing_cream = 1,
		/obj/item/armor_brush = 1,
		/obj/item/repair_kit/metal = 1,
		/obj/item/repair_kit = 1,
		/obj/item/folding_table_stored = 1,
	)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			backpack_contents[/obj/item/book/rogue/bibble/zizo] = 1
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
	if(H.mind)
		wretch_select_bounty(H)

/datum/outfit/job/roguetown/ukj_varlet_harrier/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	var/helmets = list(
		"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"Bascinet Helmet"		= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"None"
	)
	var/helmchoice = input(H, "Choose your helm.", "TAKE UP HELMS") as anything in helmets
	var/helm = helmets[helmchoice]
	if(helm)
		H.equip_to_slot_or_del(new helm(H), SLOT_HEAD, TRUE)

	var/cloaks = list("Surcoat", "Tabard", "Jupon")
	var/cloaks_choice = input(H, "Choose your cloak.", "BEAR YOUR MASTER'S COLORS.") as anything in cloaks
	switch(cloaks_choice)
		if("Surcoat")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("Tabard")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("Jupon")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/arms_choice = input(H, "Choose your arms.", "TAKE UP ARMS FOR YOUR GOD") as anything in list("Crossbow", "Bow", "Sling", "Javelins & Dagger")
	switch(arms_choice)
		if("Crossbow")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts(H), SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Bow")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/bodkin(H), SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Sling")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/sling(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/sling/iron(H), SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/huntingknife(H), SLOT_IN_BACKPACK, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Javelins & Dagger")
			H.equip_to_slot_or_del(new /obj/item/quiver/javelin/iron(H), SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
