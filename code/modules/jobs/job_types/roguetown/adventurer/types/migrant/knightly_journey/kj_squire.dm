// SQUIRE-AT-ARMS - medium armor, a melee weapon and usually a shield

/datum/advclass/kj_squire
	name = "Squire-at-Arms"
	tutorial = "You fight on foot beside your knight with your shield raised, and you keep their armor in good repair. Serve them well long enough and you may be knighted yourself."
	outfit = /datum/outfit/job/roguetown/adventurer/kj_squire
	category_tags = list(CTAG_KJ_SQUIRE)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_MEDIUMARMOR, TRAIT_OUTLANDER)
	stat_budget = STAT_BUDGET_LOW
	favored_stats = list(STATKEY_INT = STAT_FAVORED, STATKEY_CON = STAT_FAVORED, STATKEY_WIL = STAT_FAVORED)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/kj_squire
	has_loadout = TRUE

/datum/outfit/job/roguetown/adventurer/kj_squire/pre_equip(mob/living/carbon/human/H)
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

/datum/outfit/job/roguetown/adventurer/kj_squire/choose_loadout(mob/living/carbon/human/H)
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
	var/cloaks_choice = input(H, "Choose your cloak.", "BEAR YOUR MASTER'S HERALDRY.") as anything in cloaks
	switch(cloaks_choice)
		if("Surcoat")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("Tabard")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("Jupon")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/arms_choice = input(H, "Chivalry is not yet dead. Choose your arms.", "TAKE UP ARMS") as anything in list("Arming Sword & Shield", "Mace", "Flail & Shield", "Messer & Buckler", "Battle Axe")
	switch(arms_choice)
		if("Arming Sword & Shield")
			H.put_in_hands(new /obj/item/rogueweapon/sword(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/shield/heater(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Mace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
		if("Flail & Shield")
			H.put_in_hands(new /obj/item/rogueweapon/flail(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/shield/heater(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Messer & Buckler")
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/messer(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/shield/buckler(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Battle Axe")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)

// HOBELAR - medium armor, a polearm and a horse

/datum/advclass/kj_squire_hobelar
	name = "Hobelar"
	tutorial = "You fight from horseback with a polearm and look after your own mount once the day is done. You're a fair hand in the saddle, whether your knight rides or walks."
	outfit = /datum/outfit/job/roguetown/adventurer/kj_squire_hobelar
	category_tags = list(CTAG_KJ_SQUIRE)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_MEDIUMARMOR, TRAIT_OUTLANDER)
	stat_budget = STAT_BUDGET_LOW
	favored_stats = list(STATKEY_WIL = STAT_VERY_FAVORED)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/adventurer/kj_squire_hobelar
	has_loadout = TRUE

/datum/outfit/job/roguetown/adventurer/kj_squire_hobelar/pre_equip(mob/living/carbon/human/H)
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

/datum/outfit/job/roguetown/adventurer/kj_squire_hobelar/choose_loadout(mob/living/carbon/human/H)
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
	var/cloaks_choice = input(H, "Choose your cloak.", "BEAR YOUR MASTER'S HERALDRY.") as anything in cloaks
	switch(cloaks_choice)
		if("Surcoat")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("Tabard")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("Jupon")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/arms_choice = input(H, "Chivalry is not yet dead. Choose your arms.", "TAKE UP ARMS") as anything in list("Halberd", "Billhook", "Spear & Javelins", "Lance & Buckler")
	switch(arms_choice)
		if("Halberd")
			H.put_in_hands(new /obj/item/rogueweapon/halberd(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("Billhook")
			H.put_in_hands(new /obj/item/rogueweapon/spear/billhook(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("Spear & Javelins")
			H.put_in_hands(new /obj/item/rogueweapon/spear(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/javelin/iron(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("Lance & Buckler")
			H.put_in_hands(new /obj/item/rogueweapon/spear/lance(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/buckler(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)

// BIDOWER - light armor, a bow and quick feet

/datum/advclass/kj_squire_bidower
	name = "Bidower"
	tutorial = "You travel light and fight from the back with bow, crossbow or sling, thinning out the enemy before your knight charges in."
	outfit = /datum/outfit/job/roguetown/adventurer/kj_squire_bidower
	category_tags = list(CTAG_KJ_SQUIRE)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_DODGEEXPERT, TRAIT_OUTLANDER)
	stat_budget = STAT_BUDGET_LOW
	favored_stats = list(STATKEY_PER = STAT_VERY_FAVORED, STATKEY_SPD = STAT_VERY_FAVORED)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/kj_squire_bidower
	has_loadout = TRUE

/datum/outfit/job/roguetown/adventurer/kj_squire_bidower/pre_equip(mob/living/carbon/human/H)
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

/datum/outfit/job/roguetown/adventurer/kj_squire_bidower/choose_loadout(mob/living/carbon/human/H)
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
	var/cloaks_choice = input(H, "Choose your cloak.", "BEAR YOUR MASTER'S HERALDRY.") as anything in cloaks
	switch(cloaks_choice)
		if("Surcoat")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("Tabard")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("Jupon")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/arms_choice = input(H, "Chivalry is not yet dead. Choose your arms.", "TAKE UP ARMS") as anything in list("Crossbow", "Bow", "Sling", "Javelins & Dagger")
	switch(arms_choice)
		if("Crossbow")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts(H), SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
		if("Bow")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/bodkin(H), SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
		if("Sling")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/sling(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/sling/iron(H), SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/huntingknife(H), SLOT_IN_BACKPACK, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)
		if("Javelins & Dagger")
			H.equip_to_slot_or_del(new /obj/item/quiver/javelin/iron(H), SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
