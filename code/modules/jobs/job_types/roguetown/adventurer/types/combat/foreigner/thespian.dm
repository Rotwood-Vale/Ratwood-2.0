/datum/advclass/foreigner/bronzeclad
	name = "Thespian-Errant"
	tutorial = "Gladiators from the arenas of Raneshen and Lirvas, reenactors from the curtain-dazzled courts of Otava and Grenzelhoft, and \
	shieldbearers from the outermost reaches of Psydonia itself; all are unified in their subconscious pursuit of entertaining something greater \
	than themselves. You are a skilled combatant from beyond Ferentia, who - for one reason or another - is intimately familiar with fighting in ancient equipment."

	outfit = /datum/outfit/job/roguetown/adventurer/bronzeclad
	cmode_music = 'sound/music/combat_thespian.ogg'
	allowed_races = RACES_ALL_KINDS
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)//vampires aren't allowed to gladiator larp, sire
	maximum_possible_slots = 3 //Should be categorically rarer to see than Iron- and Steel-clad adventurers. Tickles the powerscale ala the Exorcist, albeit to a wider extent with its potential combinations.
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_CRITICAL_RESISTANCE)//may work on a lesser TRAIT_STRONGKICK so the leonidus wannabes can do the spartan kick.
	subclass_stats = list(
		STATKEY_STR = 2, //+2(4)/+3/+2/-2(-4)=weighted 5 point total. +2 strength mostly for greatshield requirement. Slightly below other adv weights but they get crit resistnace and limited slots so whatever.
		STATKEY_WIL = 3,
		STATKEY_CON = 2,
		STATKEY_SPD = -2,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

	extra_context = "This subclass can pick from a wide array of bronze weapons, armor, and origins to specialize in. Bronze armor - while easily pierced - is exceptionally durable and resistant against critical hits. A total of four Disciplines are available, each providing a different trait and armoring-tier."

/datum/outfit/job/roguetown/adventurer/bronzeclad/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("The curtains part, the shieldline rallies, and the eyes of a thousand shadows fall upon you. Snarling gladiator, enthralled shieldbearer, vestumed actor; ready yourself for another bout."))
	if(H.mind)
		var/bronzeweapon = list("Spatha & +1 Unarmed","Trident & +1 Unarmed","Greataxe & +1 Unarmed","Dolabra & +1 Unarmed","Winged Spear + Greatshield","Apophis + Greatshield","Gladius + Shield","Kopis + Shield","Makhaira + Shield","Khopesh + Shield","Axe + Shield","Warclub + Shield","Flail + Shield","Spear + Shield","Arbelos + Gladius","Nothing - Skilled Pugilist, +I STR/WIL & -1 INT")
		var/bronzeweapon_choice = input(H, "Choose your WEAPONS.", "PUT ON A SHOW FOR THE CROWD.") as anything in bronzeweapon
		switch(bronzeweapon_choice)
			if("Spatha & +1 Unarmed")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/broadsword/bronze
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Trident & +1 Unarmed")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/trident
				beltr = /obj/item/net
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Greataxe & +1 Unarmed")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe/bronze
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Dolabra & +1 Unarmed")
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/pick/bronze
			if("Winged Spear + Greatshield")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/bronze/winged/strapless
				backr = /obj/item/rogueweapon/shield/bronze/great
			if("Apophis + Greatshield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/greatkhopesh
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/bronze/great
			if("Gladius + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/gladius
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/bronze
			if("Makhaira + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/messer/bronze
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/bronze
			if("Kopis + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/falchion/militia/bronze
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/bronze
			if("Khopesh + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/bronze
			if("Axe + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/bronzebattleaxe
				backr = /obj/item/rogueweapon/shield/bronze
			if("Warclub + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/mace/warhammer/bronze
				backr = /obj/item/rogueweapon/shield/bronze
			if("Flail + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/bronze
				backr = /obj/item/rogueweapon/shield/bronze
			if("Spear + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/rogueweapon/shield/bronze
				r_hand = /obj/item/rogueweapon/spear/bronze/strapless
			if("Arbelos + Gladius")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/sword/short/gladius
				r_hand = /obj/item/rogueweapon/katar/bronze/gladiator
				backr = /obj/item/rogueweapon/scabbard/sword
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("Nothing - Skilled Pugilist, +I STR/WIL & -1 INT")//weighted 7. If disciple weaponless trait gets merged ill add it here to force unarmed only
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_INT, -1)

		var/bronzesidearm = list("A Javelin's Bag", "A Sling With Bronze Pellets", "A Bow With Bronze Arrows", "Another Gladius & Skills In Dual-Wielding", "Another Makhaira & Skills In Dual-Wielding", "Another Khopesh & Skills In Dual-Wielding", "Another Axe & Skills In Dual-Wielding")
		var/bronzesidearm_choice = input(H, "Choose your ACCOUTREMENTS.", "PREPARE YOUR OPENING ACT.") as anything in bronzesidearm
		switch(bronzesidearm_choice)
			if("A Javelin's Bag")
				beltl = /obj/item/quiver/javelin/bronze
			if("A Sling With Bronze Pellets")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
				beltl = /obj/item/quiver/sling/bronze
			if("A Bow With Bronze Arrows")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/classic
				beltl = /obj/item/quiver/bronzearrows
			if("Another Gladius & Skills In Dual-Wielding")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/short/gladius
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("Another Makhaira & Skills In Dual-Wielding")//these names may confuse people, but its soulful to display their actual titles rather than "messer"
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/short/messer/bronze
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("Another Khopesh & Skills In Dual-Wielding")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("Another Axe & Skills In Dual-Wielding")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_APPRENTICE, TRUE)
				l_hand = /obj/item/rogueweapon/stoneaxe/woodcut/bronzebattleaxe//i hate this objs naming path, just terrible
		var/bronzediscipline = list("Thespian - Dodge Expert, -I CON/STR & +III SPD","Gladiator - Skin-Armored & Immunity To Pain","Shieldbearer - Well-Armored & Maille Training","Bulwark - Fully-Armored & Plate Training")
		var/bronzediscipline_choice = input(H, "Choose your DISCIPLINE.", "EMBRACE GLORY AND DEATH.") as anything in bronzediscipline
		switch(bronzediscipline_choice)
			if("Thespian - Dodge Expert, -I CON/STR & +III SPD")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.change_stat(STATKEY_SPD, 3)
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_STR, -1)
				H.change_stat(STATKEY_CON, -1)
				head = /obj/item/clothing/head/roguetown/headband/red
				mask = /obj/item/clothing/mask/rogue/facemask/bronze
				armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze/light
				pants = /obj/item/clothing/under/roguetown/skirt/red
				wrists = /obj/item/clothing/wrists/roguetown/bracers/bronze
				belt = /obj/item/storage/belt/rogue/leather
			if("Gladiator - Skin-Armored & Immunity To Pain")
				ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC) //Lite!Barbarian.
				head = /obj/item/clothing/head/roguetown/helmet/bronzegladiator
				wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator
				armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest/gladiator //a leather armor
				shirt = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/gladiator //a gambeson
				pants = /obj/item/clothing/under/roguetown/loincloth/brown
				belt = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/red
				//shirt = /obj/item/clothing/suit/roguetown/shirt/tribalrag/gladiator //no empty hands to put this in, and cannot seem to 'pre-load' the cosmetic slot of a skin armor. Can hang in limbo untill someone figures out how to grant it.
			if("Shieldbearer - Well-Armored & Maille Training")
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				head = /obj/item/clothing/head/roguetown/helmet/heavy/bronze
				neck = /obj/item/clothing/neck/roguetown/gorget/bronze
				wrists = /obj/item/clothing/wrists/roguetown/bracers/bronze
				armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze
				cloak = /obj/item/clothing/cloak/cape/red
				pants = /obj/item/clothing/under/roguetown/skirt/red
				belt = /obj/item/storage/belt/rogue/leather
			if("Bulwark - Fully-Armored & Plate Training")
				ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
				head = /obj/item/clothing/head/roguetown/helmet/bronze
				neck = /obj/item/clothing/neck/roguetown/bevor/bronze
				wrists = /obj/item/clothing/wrists/roguetown/bracers/bronze
				armor = /obj/item/clothing/suit/roguetown/armor/plate/full/bronze/alt
				pants = /obj/item/clothing/under/roguetown/loincloth/brown
				cloak = /obj/item/clothing/cloak/cape/red
				belt = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/red
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/bronze
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/combat/bronze = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.set_blindness(0)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			id = /obj/item/clothing/neck/roguetown/psicross/bronze
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/bronze
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze
		if(/datum/patron/divine/ravox)
			id = /obj/item/clothing/neck/roguetown/psicross/ravox/bronze
		if(/datum/patron/divine/astrata)
			id = /obj/item/clothing/neck/roguetown/psicross/astrata/bronze
		if(/datum/patron/divine/malum)
			id = /obj/item/clothing/neck/roguetown/psicross/malum/bronze
		if(/datum/patron/divine/noc)
			id = /obj/item/clothing/neck/roguetown/psicross/noc/bronze
		else
			id = /obj/item/clothing/ring/bronze
