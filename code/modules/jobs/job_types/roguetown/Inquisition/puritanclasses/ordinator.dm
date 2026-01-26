//The Inquisitor's 'martial' archetype. An Ordinator.
//Portrayed similarly to a Hollywood knight; remarkably strong and skilled, but cripplingly slow and vulnerable to the environment.
//Superb for one-on-one clashes, but relies on a full sect - and a saiga - for maximum effectiveness.
/datum/advclass/puritan/ordinator
	name = "Ordinator"
	tutorial = "Adjudicator-Sergeants, hailing from the neighboring Psydonic Orders. Oft-mistaken for golems due to the lethargy imposed by their blessed plate armor, these holy knights have forsaken every other pursuit for a singular purpose: to break the inhumen against their knee."
	outfit = /datum/outfit/job/roguetown/puritan/ordinator
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/combat_inqordinator.ogg'

	category_tags = list(CTAG_PURITAN)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_HEAVYARMOR,
		TRAIT_SILVER_BLESSED,
		TRAIT_INQUISITION,
		TRAIT_PURITAN,
		TRAIT_OUTLANDER
		)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_INT = 1
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/puritan/ordinator/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1) //Capped to T2 miracles.
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate/ordinator
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	id = /obj/item/clothing/ring/signet/silver
	pants = /obj/item/clothing/under/roguetown/platelegs
	cloak = /obj/item/clothing/cloak/ordinatorcape
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	head = /obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	backpack_contents = list(
		/obj/item/storage/keyring/puritan = 1,
		/obj/item/paper/inqslip/arrival/inq = 1
		)

/datum/outfit/job/roguetown/puritan/ordinator/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Psydonic Broadsword + Dagger", "Psydonic Poleaxe + Dagger", "Apocrypha (Greatsword) + Dagger", "Covenant And Creed (Broadsword + Shield)", "Covenant and Consecratia (Flail + Shield)")
	var/weapon_choice = input(H,"CHOOSE YOUR RELIQUARY PIECE.", "WIELD THEM IN HIS NAME.") as anything in weapons
	switch(weapon_choice)
		if("Psydonic Broadsword + Dagger")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/kriegmesser/psy/preblessed(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
		if("Psydonic Poleaxe + Dagger")
			H.put_in_hands(new /obj/item/rogueweapon/greataxe/psy/preblessed(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
		if("Apocrypha (Greatsword) + Dagger")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/psygsword/relic(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
		if("Covenant And Creed (Broadsword + Shield)")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/bsword/psy/relic(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal/psy, SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
		if("Covenant and Consecratia (Flail + Shield)")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail/psyflail/relic(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal/psy, SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
