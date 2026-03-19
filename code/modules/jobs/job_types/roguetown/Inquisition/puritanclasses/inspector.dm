//The Inspector. Jack of all trades, master of none.
//Respectable assortment of skills, stats, and equipment; good at both subterfuge and combat.
//Functions very well on their own, and even better with a full sect.
/datum/advclass/puritan/inspector
	name = "Inspector"
	tutorial = "Investigators and diplomats, oft-selected from Confessors who've shown their aptitude in a variety of skills. A precise strike is all that's needed to forward the Orthodoxy's missive; whether it's struck with a diplomat's charm or a rapier's tip, however, is up to you."
	outfit = /datum/outfit/job/roguetown/puritan/inspector
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_PURITAN)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_DODGEEXPERT,
		TRAIT_MEDIUMARMOR,
		TRAIT_BLACKBAGGER,
		TRAIT_SILVER_BLESSED,
		TRAIT_INQUISITION,
		TRAIT_PERFECT_TRACKER,
		TRAIT_PURITAN,
		TRAIT_OUTLANDER
		)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_INT = 1
	)
	subclass_skills = list(
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/puritan/inspector/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1) //Capped to T2 miracles.
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/psydon
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	backr =  /obj/item/storage/backpack/rogue/satchel/otavan
	head = /obj/item/clothing/head/roguetown/inqhat
	mask = /obj/item/clothing/mask/rogue/spectacles/inq/spawnpair
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	id = /obj/item/clothing/ring/signet/silver
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat
	backpack_contents = list(
		/obj/item/storage/keyring/puritan = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
		/obj/item/rope/inqarticles/inquirycord = 1,
		/obj/item/grapplinghook = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/paper/inqslip/arrival/inq = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)


/datum/outfit/job/roguetown/puritan/inspector/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Psydonic Longsword", "Psydonic Rapier", "Daybreak (Whip)", "Stigmata (Halberd)", "Eucharist (Rapier)")
	var/weapon_choice = input(H,"FLOURISH YOUR SILVER.", "WIELD THEM IN HIS NAME.") as anything in weapons
	switch(weapon_choice)
		if("Psydonic Longsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/psysword/preblessed(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Psydonic Rapier")
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/psy/preblessed(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Daybreak (Whip)")
			H.put_in_hands(new /obj/item/rogueweapon/whip/antique/psywhip(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		if("Stigmata (Halberd)")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/psyhalberd/relic(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("Eucharist (Rapier)")
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/psy/relic(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
