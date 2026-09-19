//Psydonian templars with decent devotion regen.
//Counting as minor nobles, as 'knights' of the See.
//They get combination setups. The backbone of the Inquisitor's sect.
/datum/advclass/psydoniantemplar // A templar, but for the Inquisition
	name = "Adjudicator"
	tutorial = "Psydonite knights, clad in fluted chainmaille and blessed with the capacity to invoke lesser miracles. \
	In lieu of greater miracles and rituals, they compensate through martial discipline and blessed weaponry."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/psydoniantemplar
	category_tags = list(CTAG_INQUISITION)
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/templarofpsydonia.ogg'
	subclass_social_rank = SOCIAL_RANK_MINOR_NOBLE
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_STR = 2,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/psydoniantemplar
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/psydoniantemplar/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	cloak = /obj/item/clothing/cloak/psydontabard
	gloves = /obj/item/clothing/gloves/roguetown/chain/psydon
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	belt = /obj/item/storage/belt/rogue/leather/black
	id = /obj/item/clothing/neck/roguetown/psicross/silver
	backpack_contents = list(/obj/item/roguekey/inquisition = 1,
	/obj/item/paper/inqslip/arrival/ortho = 1,
	/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
	/obj/item/clothing/ring/signet/silver = 1)

	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2) //Higher limit compared to others.
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_retribution)//Rebuke, but blood cost and worse.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_sacrosanctity)//To get your blood back, m'lord.

/datum/outfit/job/roguetown/psydoniantemplar/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/helmets = list("Barbute", "Sallet", "Armet", "Bucket Helm", "Greatplumed Armet", "Volfskulle Bascinet")
	var/helmet_choice = input(H,"Choose your HELMET.", "TAKE UP PSYDON'S HELMS.") as anything in helmets
	switch(helmet_choice)
		if("Barbute")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute, SLOT_HEAD, TRUE)
		if("Sallet")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psysallet, SLOT_HEAD, TRUE)
		if("Armet")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm, SLOT_HEAD, TRUE)
		if("Bucket Helm")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psybucket, SLOT_HEAD, TRUE)
		if("Greatplumed Armet")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/knight/psy/greatplume, SLOT_HEAD, TRUE)
		if("Volfskulle Bascinet")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/psydonic, SLOT_HEAD, TRUE)

	var/armors = list("Adjudicator - Mailled Hauberk, +II CON / +II WIL", "Justicar - Cuirass, +II INT / +II PER")
	var/armor_choice = input(H, "Choose your ARMOR.", "TAKE UP PSYDON'S MANTLE.") as anything in armors
	switch(armor_choice)
		if("Adjudicator - Mailled Hauberk, +II CON / +II WIL")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq, SLOT_SHIRT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers/chain, SLOT_WRISTS, TRUE)
		if("Justicar - Cuirass, +II INT / +II PER")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate, SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli, SLOT_SHIRT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers, SLOT_WRISTS, TRUE)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.change_stat(STATKEY_CON, -2)
			H.change_stat(STATKEY_WIL, -2)

	var/weapons = list("Psydonic Longsword", "Psydonic Broadsword", "Psydonic Executioner Sword", "Psydonic War Axe", "Psydonic Whip", "Psydonic Flail", "Psydonic Flanged Mace", "Psydonic Grand Mace", "Psydonic Halberd + Arming Sword", "Psydonic Spear + Flanged Mace", "Psydonic Poleaxe + Shortsword")
	var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
	switch(weapon_choice)
		if("Psydonic Longsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/psysword(H))
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Psydonic Broadsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/kriegmesser/psy(H))
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Psydonic Executioner Sword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/exe/psy(H))
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Psydonic War Axe")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle/psyaxe(H))
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
		if("Psydonic Whip")
			H.put_in_hands(new /obj/item/rogueweapon/whip/psywhip_lesser(H))
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		if("Psydonic Flail")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail/psyflail(H))
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		if("Psydonic Flanged Mace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/flanged/psy(H))
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
		if("Psydonic Grand Mace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/goden/psy(H))
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
		if("Psydonic Halberd + Arming Sword")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/psyhalberd(H))
			H.put_in_hands(new /obj/item/rogueweapon/sword/psy(H))
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble, SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("Psydonic Spear + Flanged Mace")
			H.put_in_hands(new /obj/item/rogueweapon/spear/psyspear(H))
			H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/flanged/psy(H))
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("Psydonic Poleaxe + Shortsword")
			H.put_in_hands(new /obj/item/rogueweapon/greataxe/psy(H))
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/psy(H))
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble, SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
