//shield flail or longsword, tief can be this with red cross

/datum/job/roguetown/templar
	title = "Templar"
	department_flag = CHURCHMEN
	faction = "Station"
	tutorial = "Templars are warriors who have forsaken wealth and title in lieu of service to the church, due to either zealotry or a past shame. They guard the church and its bishop while keeping a watchful eye against heresy and nite-creechers. Within troubled dreams, they wonder if the blood they shed makes them holy or stained."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS
	outfit = /datum/outfit/job/roguetown/templar
	min_pq = 3 //Deus vult, but only according to the proper escalation rules
	max_pq = null
	round_contrib_points = 2
	total_positions = 3
	spawn_positions = 3
	advclass_cat_rolls = list(CTAG_TEMPLAR = 20)
	display_order = JDO_TEMPLAR
	social_rank = SOCIAL_RANK_MINOR_NOBLE
	give_bank_account = TRUE
	job_traits = list(TRAIT_RITUALIST, TRAIT_STEELHEARTED)

	//No nobility for you, being a member of the clergy means you gave UP your nobility. It says this in many of the church tutorial texts.
	virtue_restrictions = list(/datum/virtue/utility/noble)
	job_subclasses = list(
		/datum/advclass/templar/crusader
	)

/datum/outfit/job/roguetown/templar
	job_bitflag = BITFLAG_HOLY_WARRIOR
	has_loadout = TRUE
	allowed_patrons = ALL_DIVINE_PATRONS

/datum/job/roguetown/templar/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
//Title stuff. This is super sloppy.
		var/prev_real_name = H.real_name
		var/prev_name = H.name
//Default fallback title.
		var/title = "Votary"
//Actual titles now, based on pronouns.
		switch(H.pronouns)
			if(SHE_HER)
				title = "Sister"
			if(SHE_HER_M)
				title = "Sister"
			if(HE_HIM)
				title = "Brother"
			if(HE_HIM_F)
				title = "Brother"
//Now apply the actual title.
		H.real_name = "[title] [prev_real_name]"
		H.name = "[title] [prev_name]"

/datum/advclass/templar/crusader
	name = "Templar"
	tutorial = "You are a templar of the Church, trained in heavy weaponry and zealous warfare. You are the instrument of your God's wrath, clad in steel and faith."
	outfit = /datum/outfit/job/roguetown/templar/crusader
	category_tags = list(CTAG_TEMPLAR)
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,	//May tone down to 2; seems OK.
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
	)
	extra_context = "This subclass gains Expert skill in their weapon of choice. Taking a ranged option will provide Expert skills in Crossbows and Journeyman skills in Swordsmanship, at the cost of starting with reduced armor and atrophying in all other weapon skills."

/datum/outfit/job/roguetown/templar/crusader/pre_equip(mob/living/carbon/human/H)
	..()
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	backr = /obj/item/rogueweapon/shield/tower/metal
	id = /obj/item/clothing/ring/silver
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/storage/keyring/churchie = 1
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg' // this is probably awful implementation. too bad!
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
			cloak = /obj/item/clothing/cloak/templar/astratan
		if(/datum/patron/divine/abyssor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
			head = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
			cloak = /obj/item/clothing/cloak/abyssortabard
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/roguetown/psicross/xylix
			cloak = /obj/item/clothing/cloak/templar/xylixian
			head = /obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm
			H.cmode_music = 'sound/music/combat_jester.ogg'
			var/datum/inspiration/I = new /datum/inspiration(H)
			I.grant_inspiration(H, bard_tier = BARD_T1)
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
			head = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
			cloak = /obj/item/clothing/cloak/tabard/crusader/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/roguetown/psicross/necra
			cloak = /obj/item/clothing/cloak/templar/necran
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/roguetown/psicross/pestra
			head = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
			cloak = /obj/item/clothing/cloak/templar/pestran
		if(/datum/patron/divine/eora) //Eora content from stonekeep
			wrists = /obj/item/clothing/neck/roguetown/psicross/eora
			cloak = /obj/item/clothing/cloak/templar/eoran
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/roguetown/psicross/noc
			head = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
			cloak = /obj/item/clothing/cloak/tabard/crusader/noc
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/roguetown/psicross/ravox
			cloak = /obj/item/clothing/cloak/templar/ravox
			mask = /obj/item/clothing/head/roguetown/roguehood/ravoxgorget
			backpack_contents = list(/obj/item/ritechalk, /obj/item/book/rogue/law, /obj/item/rogueweapon/scabbard/sheath, /obj/item/storage/belt/rogue/pouch/coins/mid, /obj/item/storage/keyring/churchie)
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/roguetown/psicross/malum
			cloak = /obj/item/clothing/cloak/templar/malumite
			head = /obj/item/clothing/head/roguetown/helmet/heavy/malum
		if(/datum/patron/old_god)
			wrists = /obj/item/clothing/neck/roguetown/psicross
			cloak = /obj/item/clothing/cloak/tabard/crusader/psydon
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/rogueweapon/scabbard/sword
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.

/datum/outfit/job/roguetown/templar/crusader/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Longsword","Flail","Mace","Battle Axe", "Spear", "Crossbow + Shortsword")
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata) //Unique patron weapons, more can be added here if wanted.
			weapons += list("Solar Judgement", "Eclipsum Longsword")
			weapons -= "Longsword"//Eclipsum Longsword takes priority.
		if(/datum/patron/divine/noc)
			weapons += list("Moonlight Khopesh", "Eclipsum Longsword")
			weapons -= "Longsword"//Eclipsum Longsword takes priority.
		if(/datum/patron/divine/necra)
			weapons += list("Swift End", "Respite")
			weapons -= list("Flail", "Battle Axe")//First to have two wildly different weapons.
		if(/datum/patron/divine/pestra)
			weapons += "Plaguebringer Sickles"
		if(/datum/patron/divine/malum)
			weapons += "Forgefiend"
			weapons -= "Longsword"//Forgefiend takes priority.
		if(/datum/patron/divine/dendor)
			weapons += "Summer Scythe"
			weapons -= "Spear"//Scythe takes priority.
		if(/datum/patron/divine/xylix)
			weapons += "Cackle Lash"
		if(/datum/patron/divine/ravox)
			weapons += "Duel Settler"
			weapons -= "Mace"//Duel Settler takes priority.
		if(/datum/patron/divine/eora)
			weapons += list("The Heartstring", "Close Caress")
			weapons -= "Longsword"//Heartstring takes priority.
		if(/datum/patron/divine/abyssor)
			weapons += list("Tidecleaver", "Barotrauma")
			weapons -= "Battle Axe"//Tidecleaver takes priority.
	var/weapon_choice = input(H,"Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
//Generic weapons here.
		if("Longsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/church(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE) //Halfplate, not fullplate.
		if("Spear")
			H.put_in_hands(new /obj/item/rogueweapon/spear/holysee(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H), FALSE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Flail")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Mace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/steel(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Battle Axe")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
//Actual patron specific weapons below.
		if("Solar Judgement")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/exe/astrata(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Moonlight Khopesh")
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/nockhopesh(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Swift End")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail/necraflail(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Plaguebringer Sickles")
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE) // actually makes them usable for the templar.
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Forgefiend")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/grenz/flamberge/malum(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Summer Scythe")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/bardiche/scythe(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H), FALSE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE) // again, needs skill to actually use the weapon
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Cackle Lash")
			H.put_in_hands(new /obj/item/rogueweapon/whip/xylix(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Duel Settler")
			H.put_in_hands(new /obj/item/rogueweapon/mace/goden/steel/ravox(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("The Heartstring")
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/eora(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Tidecleaver")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle/abyssoraxe(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Respite")
			H.put_in_hands(new /obj/item/rogueweapon/greataxe/steel/necran(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H), FALSE)
			H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Eclipsum Longsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/holysee_lesser(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
//Unarmed specific stuff is locked to patrons who have it. RAAAAAAA!!!!!! HEAVY ARMOUR BRUISERS!!!!!!
		if("Close Caress")
			H.put_in_hands(new /obj/item/rogueweapon/knuckles/eora(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
		if("Barotrauma")
			H.put_in_hands(new /obj/item/rogueweapon/katar/abyssor(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate, SLOT_ARMOR, TRUE)
//Unusual loadouts, such as a crossbow.
		if("Crossbow + Shortsword")
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/half, SLOT_ARMOR, TRUE) //Cuirass, not halfplate. Slightly reduced starting armor.
			H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/short(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE) //Expert Crossbow, but Journeyman Swords and Apprentice-level combat skills elsewhere.
			H.adjust_skillrank(/datum/skill/combat/maces, -1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/axes, -1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, -1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/wrestling, -1, TRUE)//Haha... no.

//Helmets. This BLOWS with how it checks, but I'm lazy and it works.
//TODO: Remove this for a universal helmet select, once we have sprites for the others.
	if(H.patron.name == "Astrata" || H.patron.name == "Necra" || H.patron.name == "Eora" || H.patron.name == "Ravox")
		var/helmets = list("Visored / Sallet", "Helmet")
		var/selected_helmet = input(H, "Choose a helmet...", "Helmet") as anything in helmets
		switch(H.patron?.type)
			if(/datum/patron/divine/astrata)
				if(selected_helmet == "Visored / Sallet")
					H.equip_to_slot(new /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm/visor(H), SLOT_HEAD)
				else
					H.equip_to_slot(new /obj/item/clothing/head/roguetown/helmet/heavy/astratan(H), SLOT_HEAD)
			if(/datum/patron/divine/necra)
				if(selected_helmet == "Visored / Sallet")
					H.equip_to_slot(new /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm/hooded(H), SLOT_HEAD)
				else
					H.equip_to_slot(new /obj/item/clothing/head/roguetown/helmet/heavy/necran(H), SLOT_HEAD)
			if(/datum/patron/divine/eora)
				if(selected_helmet == "Visored / Sallet")
					H.equip_to_slot(new /obj/item/clothing/head/roguetown/helmet/sallet/eoran(H), SLOT_HEAD)
				else
					H.equip_to_slot(new /obj/item/clothing/head/roguetown/helmet/heavy/eoran(H), SLOT_HEAD)
			if(/datum/patron/divine/ravox)
				if(selected_helmet == "Visored / Sallet")
					H.equip_to_slot(new /obj/item/clothing/head/roguetown/helmet/heavy/ravox_visor(H), SLOT_HEAD)
				else
					H.equip_to_slot(new /obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm(H), SLOT_HEAD)

	// -- Start of section for god specific bonuses --
	if(H.patron?.type == /datum/patron/divine/astrata)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	if(H.patron?.type == /datum/patron/divine/dendor)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		ADD_TRAIT(H, TRAIT_SURVIVAL_EXPERT, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/noc)
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
		H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/abyssor)
		H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/necra)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
	if(H.patron?.type == /datum/patron/divine/pestra)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_MEDICINE_EXPERT, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/eora)
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
	if(H.patron?.type == /datum/patron/divine/malum)
		H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
		ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/ravox)
		H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/xylix)
		H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
	// -- End of section for god specific bonuses --
