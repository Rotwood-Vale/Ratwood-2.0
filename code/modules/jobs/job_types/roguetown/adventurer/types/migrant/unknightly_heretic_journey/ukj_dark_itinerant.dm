// FORSWORN KNIGHT - heavy plate and a big weapon

/datum/advclass/ukj_dark_itinerant
	name = "Forsworn Knight"
	tutorial = "You were once a knight of some forgotten house, until you broke your oath and swore a new one to an Ascendant. A varlet follows at your side, and you wear plain steel until your god finds you worthy of better."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/ukj_dark_itinerant
	category_tags = list(CTAG_UKJ_DARK_ITINERANT)
	subclass_social_rank = SOCIAL_RANK_MINOR_NOBLE
	traits_applied = list(TRAIT_DISGRACED_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_RITUALIST)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/ukj_dark_itinerant
	has_loadout = TRUE

/datum/outfit/job/roguetown/ukj_dark_itinerant/pre_equip(mob/living/carbon/human/H)
	..()
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 3,
		/obj/item/needle = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/ritechalk = 1,
	)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
	//give minion orders if they're a zizite
	if (istype (H.patron, /datum/patron/inhumen/zizo))
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
			H.mind.current.faction += "[H.name]_faction"
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			backpack_contents[/obj/item/book/rogue/bibble/zizo] = 1
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen
			backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/kris/zizo] = 1
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
			backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/matthios] = 1
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
			backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/rondel/baotha] = 1
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
			backpack_contents[/obj/item/rogueweapon/huntingknife/combat/messer/graggar] = 1
	if(H.mind)
		wretch_select_bounty(H)

/datum/outfit/job/roguetown/ukj_dark_itinerant/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	var/helmets = list(
		"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
		"Savoyard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
		"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
		"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
		"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
		"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
		"Snouted Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
		"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
		"Snouted Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/snouted,
		"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
		"Roundface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface,
		"Snouted Roundface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/snouted,
		"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		"Slitted Kettle"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		"Froggemund Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
		"Volf-Plate Helm"	= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
		"None"
	)
	var/helmchoice = input(H, "Choose your helm.", "TAKE UP HELMS") as anything in helmets
	var/helm = helmets[helmchoice]
	if(helm)
		H.equip_to_slot_or_del(new helm(H), SLOT_HEAD, TRUE)

	var/armors = list(
		"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
		"Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
		"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/half,
		"Fluted Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/half/fluted,
	)
	var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
	var/picked_armor = armors[armorchoice]
	if(picked_armor)
		H.equip_to_slot_or_del(new picked_armor(H), SLOT_ARMOR, TRUE)

	var/cloaks = list("Surcoat", "Tabard", "Jupon")
	var/cloaks_choice = input(H, "Choose your cloak.", "BEAR YOUR GOD'S COLORS.") as anything in cloaks
	switch(cloaks_choice)
		if("Surcoat")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("Tabard")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("Jupon")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/weapons = list("Greatsword", "Flamberge", "Zweihander", "Kriegsmesser", "Great Mace", "Partizan", "Glaive", "Mace", "Longsword + Shield", "Greataxe", "Warhammer + Shield", "Battle Axe")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Greatsword")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("Flamberge")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/grenz/flamberge(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("Zweihander")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/grenz(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("Kriegsmesser")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/kriegmesser(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("Great Mace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/goden/steel(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
		if("Partizan")
			H.put_in_hands(new /obj/item/rogueweapon/spear/partizan(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
		if("Glaive")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/glaive(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
		if("Mace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
		if("Longsword + Shield")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble(H), SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
		if("Greataxe")
			H.put_in_hands(new /obj/item/rogueweapon/greataxe/steel(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
		if("Warhammer + Shield")
			H.put_in_hands(new /obj/item/rogueweapon/mace/warhammer/steel(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
		if("Battle Axe")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)

// HARBINGER - light armor, a horse and a bow

/datum/advclass/ukj_dark_itinerant_harbinger
	name = "Knight Harbinger"
	tutorial = "Your old liege would see you hanged if they ever caught you. You ride as your god's herald now, striking from the saddle and moving on before anyone can catch up."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/ukj_dark_itinerant_harbinger
	category_tags = list(CTAG_UKJ_DARK_ITINERANT)
	subclass_social_rank = SOCIAL_RANK_MINOR_NOBLE
	traits_applied = list(TRAIT_DISGRACED_NOBLE, TRAIT_MEDIUMARMOR, TRAIT_DODGEEXPERT, TRAIT_STEELHEARTED, TRAIT_RITUALIST)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_INT = 3,
		STATKEY_WIL = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/ukj_dark_itinerant_harbinger
	has_loadout = TRUE

/datum/outfit/job/roguetown/ukj_dark_itinerant_harbinger/pre_equip(mob/living/carbon/human/H)
	..()
	gloves = /obj/item/clothing/gloves/roguetown/plate
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 3,
		/obj/item/needle = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/ritechalk = 1,
	)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
	if (istype (H.patron, /datum/patron/inhumen/zizo))
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
			H.mind.current.faction += "[H.name]_faction"
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			backpack_contents[/obj/item/book/rogue/bibble/zizo] = 1
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen
			backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/kris/zizo] = 1
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
			backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/matthios] = 1
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
			backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/rondel/baotha] = 1
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
			backpack_contents[/obj/item/rogueweapon/huntingknife/combat/messer/graggar] = 1
	if(H.mind)
		wretch_select_bounty(H)

/datum/outfit/job/roguetown/ukj_dark_itinerant_harbinger/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	var/helmets = list(
		"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
		"Savoyard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
		"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
		"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
		"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
		"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
		"Snouted Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
		"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
		"Snouted Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/snouted,
		"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
		"Roundface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface,
		"Snouted Roundface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/snouted,
		"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		"Slitted Kettle"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		"Froggemund Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
		"Volf-Plate Helm"	= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
		"None"
	)
	var/helmchoice = input(H, "Choose your helm.", "TAKE UP HELMS") as anything in helmets
	var/helm = helmets[helmchoice]
	if(helm)
		H.equip_to_slot_or_del(new helm(H), SLOT_HEAD, TRUE)

	var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in list("Light Coat", "Light Brigandine", "Steel Cuirass")
	switch(armor_choice)
		if("Light Coat")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat(H), SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/heavy_leather_pants(H), SLOT_PANTS, TRUE)
		if("Light Brigandine")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/brigandine/light(H), SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/splintlegs(H), SLOT_PANTS, TRUE)
		if("Steel Cuirass")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/half(H), SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/chainlegs(H), SLOT_PANTS, TRUE)

	var/cloaks = list("Surcoat", "Tabard", "Jupon")
	var/cloaks_choice = input(H, "Choose your cloak.", "BEAR YOUR GOD'S COLORS.") as anything in cloaks
	switch(cloaks_choice)
		if("Surcoat")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("Tabard")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("Jupon")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/weapons = list("Longsword + Crossbow", "Billhook + Recurve Bow", "Sabre + Recurve Bow", "Lance + Kite Shield", "Rapier + Longbow", "Estoc + Recurve Bow", "Sabre + Buckler", "Whip + Crossbow", "Urumi + Buckler")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Longsword + Crossbow")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts(H), SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("Billhook + Recurve Bow")
			H.put_in_hands(new /obj/item/rogueweapon/spear/billhook(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/arrows(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
		if("Sabre + Recurve Bow")
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/arrows(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("Lance + Kite Shield")
			H.put_in_hands(new /obj/item/rogueweapon/spear/lance(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
		if("Rapier + Longbow")
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/arrows(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("Estoc + Recurve Bow")
			H.put_in_hands(new /obj/item/rogueweapon/estoc(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/arrows(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("Sabre + Buckler")
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/buckler(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
		if("Whip + Crossbow")
			H.put_in_hands(new /obj/item/rogueweapon/whip(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
		if("Urumi + Buckler")
			H.put_in_hands(new /obj/item/rogueweapon/whip/urumi(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/buckler(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
