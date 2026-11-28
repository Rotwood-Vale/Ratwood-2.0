/datum/advclass/ashen_host/legionary
	name = "Ashen Legionary"
	tutorial = "A Legionary is no meager footsoldier, you are her plate-clad bloodied hand. Wielding dark sorceries, unholy incantations and heavy, dread armaments, no soldier is better prepared to inversely crucify the unworthy than you. Utilize Faith, Magic and Might to lay low any who would stand between you and HER ambition."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/ashen_host/legionary
	class_select_category = CLASS_CAT_CLERIC
	category_tags = list(CTAG_ASHEN)
	traits_applied = list(TRAIT_RITUALIST, TRAIT_HEAVYARMOR)
	maximum_possible_slots = 2
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_PER = 1,
		STATKEY_INT = 2,
		STATKEY_CON = 3,
		STATKEY_WIL = 4,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"Armor Plates" = /obj/item/repair_kit/metal,
	)
	extra_context = "This subclass gains the Wound Heal miracle and the Convert Heretic spell."

/datum/outfit/job/roguetown/ashen_host/legionary
	has_loadout = TRUE

/datum/outfit/job/roguetown/ashen_host/legionary/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_patron(/datum/patron/inhumen/zizo)
	H.set_blindness(0)
	to_chat(H, span_warning("You are the Lady's plate-clad hand. Lay low any who stand between Her and Her ambition."))

	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/ashen
	backr = /obj/item/rogueweapon/shield/tower/metal
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/ritechalk = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		)

	if(H.mind)
		if(H.mind.current)
			H.mind.current.faction += "[H.name]_faction"
		var/weapons = list("Longsword", "Mace", "Flail", "Axe", "Billhook")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Longsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long
			if("Mace")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/mace/steel
			if("Flail")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/flail/sflail
			if("Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
			if("Billhook")
				l_hand = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/spear/billhook
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE) //Minor regen, starts maxed out.

	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_heal)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast/unholyblast)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
	ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC) 

	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_INT, 2) 
		H.change_stat(STATKEY_PER, 2)

/datum/outfit/job/roguetown/ashen_host/legionary/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/helmets = list(
		"Pigface Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
		"Guard Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/guard,
		"Barred Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
		"Bucket Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
		"Knight Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/knight,
		"Visored Sallet" = /obj/item/clothing/head/roguetown/helmet/sallet/visored,
		"Snouted Visored Sallet" = /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
		"Armet" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
		"Snouted Armet" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/snouted,
		"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
		"Klappvisier Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		"Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		"Volfskulle Bascinet" = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
		"Roundface Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface,
		"Snouted Roundface Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/snouted,
		"None",
		)
	H.cmode_music = 'sound/music/combat_heretic.ogg'
	H.equip_to_slot_or_del(new /obj/item/rogueweapon/huntingknife/idagger/steel/kris/zizo, SLOT_IN_BACKPACK, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)

	if(H.mind)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			var/helmet_path = helmets[helmchoice]
			H.equip_to_slot_or_del(new helmet_path(H), SLOT_HEAD, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/half, SLOT_ARMOR, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk, SLOT_SHIRT, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/chain, SLOT_GLOVES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers, SLOT_WRISTS, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/armor, SLOT_SHOES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel, SLOT_WEAR_MASK, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/gorget, SLOT_NECK, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/chainlegs, SLOT_PANTS, TRUE)

/datum/advclass/ashen_host/speculator
	name = "Ashen Speculator"
	tutorial = " How can knowledge be Evil, when it grants Eternity ? There is Salvation in unholy scripture, Grace in darkness. Utilize faith and subterfuge to reveal the Light of the Pantheon for what it is, a dazzling lie that conceals the truth of HER ways."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/ashen_host/speculator
	class_select_category = CLASS_CAT_ROGUE
	category_tags = list(CTAG_ASHEN)
	traits_applied = list(TRAIT_RITUALIST, TRAIT_DODGEEXPERT)
	maximum_possible_slots = 2
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 3,
		STATKEY_INT = 3,
		STATKEY_CON = 1,
		STATKEY_WIL = 4,
		STATKEY_SPD = 3,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
	)
	subclass_stashed_items = list(
		"Sewing Kit" = /obj/item/repair_kit,
	)
	extra_context = "This subclass gains the Wound Heal miracle and the Convert Heretic spell."

/datum/outfit/job/roguetown/ashen_host/speculator
	has_loadout = TRUE

/datum/outfit/job/roguetown/ashen_host/speculator/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_patron(/datum/patron/inhumen/zizo)
	H.set_blindness(0)
	to_chat(H, span_warning("You are the eyes and knives of the Host. They will not see you coming."))

	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/ashen
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/roguebag = 1,
		/obj/item/ritechalk = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		)

	if(H.mind)
		if(H.mind.current)
			H.mind.current.faction += "[H.name]_faction"
		var/weapons = list("Daggers", "Rapier", "Sabre", "Whip", "Bow", "Crossbow", "Slurbow", "Urumi")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Daggers")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
				beltl = /obj/item/rogueweapon/scabbard/sheath
				beltr = /obj/item/rogueweapon/scabbard/sheath
			if("Rapier")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/rapier
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("Sabre")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/sabre
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("Whip")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/whip
			if("Bow")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/quiver/arrows
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
				beltl = /obj/item/rogueweapon/scabbard/sheath
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
			if("Crossbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/quiver/bolts
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/rogueweapon/scabbard/sheath
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
			if("Slurbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/quiver/bolts
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
				beltl = /obj/item/rogueweapon/scabbard/sheath
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
			if("Urumi")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/whip/urumi
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE) //Minor regen, starts maxed out.

	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_heal)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast/unholyblast)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
	ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)

/datum/outfit/job/roguetown/ashen_host/speculator/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.cmode_music = 'sound/music/combat_heretic.ogg'
	H.equip_to_slot_or_del(new /obj/item/rogueweapon/huntingknife/idagger/steel/kris/zizo, SLOT_IN_BACKPACK, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)

	H.equip_to_slot_or_del(new /obj/item/clothing/cloak/raincloak/mortus, SLOT_CLOAK, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/ragmask/black, SLOT_WEAR_MASK, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/heavy_leather_pants, SLOT_PANTS, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat, SLOT_ARMOR, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson, SLOT_SHIRT, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/fingerless_leather, SLOT_GLOVES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/leather/reinforced, SLOT_SHOES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers/leather/heavy, SLOT_WRISTS, TRUE)
