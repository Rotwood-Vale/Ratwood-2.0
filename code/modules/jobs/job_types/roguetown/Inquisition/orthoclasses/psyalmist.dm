//Healer-bards. Boring, but it exists.
//Not intended for proper combat.
//Knives exist the same way it does on Arbalist, as a 'just in case'.
/datum/advclass/psyaltrist
	name = "Psyaltrist"
	tutorial = "You spent some time with cathedral choirs and psyaltrists. Now you spend your days applying the musical arts to the practical on behalf of His most Holy of Inquisitions."
	outfit = /datum/outfit/job/roguetown/psyaltrist
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_EMPATH, TRAIT_DODGEEXPERT)
	category_tags = list(CTAG_INQUISITION)
	subclass_languages = list(/datum/language/otavan)
	subclass_stats = list(//This does not follow the typical 8 stat setup.
		STATKEY_STR = 1,
		STATKEY_LCK = 1,
		STATKEY_WIL = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_MASTER,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE
	)
	subclass_stashed_items = list(
		"Of Psydon" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/psyaltrist/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/helmet/leather/chapeau
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/psyaltrist
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	cloak = /obj/item/clothing/cloak/psyaltrist
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	neck = /obj/item/clothing/neck/roguetown/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/psydon
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/clothing/ring/signet/silver
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T3)
	backpack_contents = list(/obj/item/roguekey/inquisition = 1,
	/obj/item/paper/inqslip/arrival/ortho = 1,
	/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger = 1,
	/obj/item/rogueweapon/scabbard/sheath = 1)

	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/mockery)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_inspire)//CtA, but blood cost and... kind of worse.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_sacrosanctity)//To get your blood back, m'lord.
		var/instruments = list("Accordion","Bagpipe", "Banjo","Drum","Flute","Guitar","Harmonica","Harp","Hurdy-Gurdy","Jaw Harp","Lute","Psyaltery","Shamisen","Trumpet","Viola","Vocal Talisman")
		var/instrument_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", instruments)
		H.set_blindness(0)
		switch(instrument_choice)
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Bagpipe")
				backr = /obj/item/rogue/instrument/bagpipe
			if("Banjo")
				backr = /obj/item/rogue/instrument/banjo
			if("Drum")
				backr = /obj/item/rogue/instrument/drum
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Harmonica")
				backr = /obj/item/rogue/instrument/harmonica
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Jaw Harp")
				backr = /obj/item/rogue/instrument/jawharp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Shamisen")
				backr = /obj/item/rogue/instrument/shamisen
			if("Trumpet")
				backr = /obj/item/rogue/instrument/trumpet
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals
		var/weapons = list("Psydonic Whip", "Psydonic Rapier")
		var/weapon_choice = tgui_input_list(H, "Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.", weapons)
		switch(weapon_choice)
			if("Psydonic Whip")
				H.put_in_hands(new /obj/item/rogueweapon/whip/psywhip_lesser(get_turf(H)), forced = TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
			if("Psydonic Rapier")
				H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/psy(get_turf(H)), forced = TRUE)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)

/datum/outfit/job/roguetown/psyaltrist
	job_bitflag = BITFLAG_HOLY_WARRIOR
