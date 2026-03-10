/datum/job/roguetown/penitent
	title = "Penitent"
	department_flag = CHURCHMEN
	faction = "Station"
	tutorial = "All those faithful and devout to the Ten are aware of the fact that Astrata's Authority instills Order and Tyranny both, in equal measures. Penitents, in essence, are a representation of such phenomena: unfortunate souls corrupted by the Four, yet deemed worthy of redemption by the Holy See. The stain of heresy remains, regardless, along with the voices whispering of sin.."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/penitent
	min_pq = 30 //Expected to be an RP-intense role with a good amount of coal-avoidance put upon the player, for now.
	max_pq = null
	round_contrib_points = 3
	total_positions = 1
	spawn_positions = 1
	advclass_cat_rolls = list(CTAG_PENITENT = 20)
	display_order = JDO_PENITENT
	social_rank = SOCIAL_RANK_PEASANT
	give_bank_account = TRUE
	job_traits = list(TRAIT_RITUALIST, TRAIT_STEELHEARTED, TRAIT_CHURCH_PENITENT)

	//Foreign heretic send here for redemption - knowledge of sect's location in the Vale would only be a temptation ICly and OOCly
	virtue_restrictions = list(/datum/virtue/heretic/zchurch_keyholder)
	job_subclasses = list(
		/datum/advclass/penitent/crusader
	)

/datum/outfit/job/roguetown/penitent
	job_bitflag = BITFLAG_HOLY_WARRIOR
	has_loadout = TRUE
	allowed_patrons = ALL_INHUMEN_PATRONS

/datum/job/roguetown/penitent/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
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

/datum/advclass/penitent/crusader
	name = "Penitent"
	tutorial = "You are a formerly devout worshipper of the Four currently undergoing Penance in one of the distant Tennite Churches. Judges of Grenzelhoft's Holy See deemed you worthy of salvation.. Were they right, however?"
	outfit = /datum/outfit/job/roguetown/penitent/crusader
	category_tags = list(CTAG_PENITENT)
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_PER = 2,
		STATKEY_SPD = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,		//Weapon skills upgraded to Expert, but they gain no starter weapon in exchange. Could be changed into providing skill selection.
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
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

/datum/outfit/job/roguetown/penitent/crusader/pre_equip(mob/living/carbon/human/H)
	..()
	if(!istype(H.patron, /datum/patron/inhumen))
		H.set_patron(/datum/patron/inhumen/zizo)//If you're not of the Inhumen before? You are now!
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/undivided
	id = /obj/item/clothing/ring/aalloy
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/book/rogue/bibble,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/storage/keyring/churchie = 1
		)
	gloves = /obj/item/clothing/gloves/roguetown/chain
	mask = /obj/item/clothing/mask/rogue/facemask/steel/paalloy
	head = /obj/item/clothing/head/roguetown/roguehood/astrata
	neck = /obj/item/clothing/neck/roguetown/gorget/controllable/shock_explosive
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	armor = /obj/item/clothing/suit/roguetown/armor/plate
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_2)	//Have to actively try and pray to their inhumen patrons to manifest EVIL miracles. The concept might later be remade into the choice of combinations between Tennite and Inhumen Patrons

	// -- Start of section for god specific bonuses --
	if(H.patron?.type == /datum/patron/inhumen/zizo)
		H.cmode_music = 'sound/music/combat_heretic.ogg'
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_EXPERT, TRUE)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/inhumen/baotha)
		H.cmode_music = 'sound/music/combat_baotha.ogg'
		H.adjust_skillrank_up_to(/datum/skill/misc/music, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_JOURNEYMAN, TRUE) // jessie we have to cook
		ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/inhumen/graggar)
		H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE) //small benefit here, graggar's already good enough for a heavy armor heretic
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/inhumen/matthios)
		H.cmode_music = 'sound/music/combat_matthios.ogg'
		H.grant_language(/datum/language/thievescant)
		H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_JOURNEYMAN, TRUE) //unlike wanderer, normal heretic can get these bonuses


/obj/item/clothing/neck/roguetown/gorget/controllable/shock_explosive/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(HAS_TRAIT(H, TRAIT_CHURCH_PENITENT)) //DEBUFF
			H.remove_status_effect(/datum/status_effect/debuff/collar_scorned)
			H.remove_stress(/datum/stressevent/collaroff)

/obj/item/clothing/neck/roguetown/gorget/controllable/shock_explosive/dropped(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(HAS_TRAIT(H, TRAIT_CHURCH_PENITENT)) //DEBUFF
			H.apply_status_effect(/datum/status_effect/debuff/collar_scorned)
			H.add_stress(/datum/stressevent/collaroff)
