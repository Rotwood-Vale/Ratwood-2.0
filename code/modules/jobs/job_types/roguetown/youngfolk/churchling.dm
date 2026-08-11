/datum/job/roguetown/churchling
	title = "Churchling"
	flag = CHURCHLING
	department_flag = YOUNGFOLK
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)

	tutorial = "Your family were zealots. They scolded you with a studded belt and prayed like sinners every waking hour of the day they weren't toiling in the fields. You escaped them by becoming a churchling--and a guaranteed education isn't so bad."

	outfit = /datum/outfit/job/roguetown/churchling
	display_order = JDO_CHURCHLING
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	advjob_examine = TRUE
	social_rank = SOCIAL_RANK_PEASANT

	//You've given up your life for the Church. Why would you be noble?
	virtue_restrictions = list(/datum/virtue/utility/noble)

	advclass_cat_rolls = list(CTAG_CHURCHLING = 20)
	job_subclasses = list(
		/datum/advclass/churchling,
		/datum/advclass/churchling/neophyte,
	)

/datum/advclass/churchling
	name = "Churchling"
	tutorial = "Your family were zealots. They scolded you with a studded belt and prayed like sinners every waking hour of the day they weren't toiling in the fields. You escaped them by becoming a churchling--and a guaranteed education isn't so bad."
	outfit = /datum/outfit/job/roguetown/churchling/basic
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_CHURCHLING)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/churchling/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	neck = /obj/item/clothing/neck/roguetown/psicross
	if(should_wear_femme_clothes(H))
		head = /obj/item/clothing/head/roguetown/armingcap
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/robe
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights
	belt = /obj/item/storage/belt/rogue/leather/rope
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	beltl = /obj/item/storage/keyring/churchie

/datum/outfit/job/roguetown/churchling/basic/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if (H && H.mind)
		_delayed_path_choice(H)

/datum/outfit/job/roguetown/churchling/basic/proc/_delayed_path_choice(mob/living/carbon/human/H)
	if(!H || !H.client || !H.mind)
		return

	var/choice = alert(H, "Choose your path.", "Churchling Doctrine", "Loyalist", "Radical")

	if(choice == "Radical")
		grant_radical_path(H)
	else
		grant_old_path(H)

/datum/outfit/job/roguetown/churchling/basic/proc/grant_old_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return

	REMOVE_TRAIT(H, TRAIT_CLERGYRADICAL, "job")
	H.reset_clergy_devotion(CLERIC_T2, CLERIC_REGEN_DEVOTEE, FALSE, CLERIC_REQ_2)
	to_chat(H, span_notice("I remain on the old path of devotion."))

/datum/outfit/job/roguetown/churchling/basic/proc/grant_radical_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return

	ADD_TRAIT(H, TRAIT_CLERGYRADICAL, "job")
	H.church_favor += 1200
	H.reset_clergy_devotion(CLERIC_T2, CLERIC_REGEN_DEVOTEE, FALSE, CLERIC_REQ_2)
	to_chat(H, span_notice("I embrace the radical path."))

/datum/advclass/churchling/neophyte
	name = "Neophyte"
	tutorial = "You are a Templar-in-training, a prospective holy warrior of the Church with much to learn, and much more to prove. You've been given some hand-me-downs from the Church's armory, and the barest blessings of your chosen Divine."
	outfit = /datum/outfit/job/roguetown/churchling/neophyte
	category_tags = list(CTAG_CHURCHLING)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_SQUIRE_REPAIR)
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
	)
	allowed_patrons = list(
		/datum/patron/divine/astrata,
		/datum/patron/divine/noc,
		/datum/patron/divine/abyssor,
		/datum/patron/divine/dendor,
		/datum/patron/divine/necra,
		/datum/patron/divine/malum,
		/datum/patron/divine/eora,
		/datum/patron/divine/ravox,
		/datum/patron/divine/xylix,
		/datum/patron/divine/pestra
	)
	extra_context = "Tennite only, and lacks the per-God bonuses Templars usually get. Bears T1 miracles of your chosen patron (loyalist only), and Journeyman level combat skills in one of the following: Swords (and Shields), Maces, Whips/Flails, Polearms and Axes "

/datum/outfit/job/roguetown/churchling/neophyte/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_blindness(-3)
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/keyring/churchie
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	head = /obj/item/clothing/head/roguetown/helmet/leather/armorhood
	backpack_contents = list(
		/obj/item/rogueweapon/hammer/wood = 1,
		/obj/item/needle = 1

	)
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			cloak = /obj/item/clothing/cloak/templar/astrata
			wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
		if(/datum/patron/divine/noc)
			cloak = /obj/item/clothing/cloak/templar/noc
			wrists = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			cloak = /obj/item/clothing/cloak/abyssortabard
			wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			cloak = /obj/item/clothing/cloak/templar/dendor
			wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
		if(/datum/patron/divine/necra)
			cloak = /obj/item/clothing/cloak/templar/necra
			wrists = /obj/item/clothing/neck/roguetown/psicross/necra
		if (/datum/patron/divine/malum)
			cloak = /obj/item/clothing/cloak/templar/malum
			wrists = /obj/item/clothing/neck/roguetown/psicross/malum
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/cloak/templar/eora
			wrists = /obj/item/clothing/neck/roguetown/psicross/eora
		if (/datum/patron/divine/ravox)
			cloak = /obj/item/clothing/cloak/cleric/ravox
			wrists = /obj/item/clothing/neck/roguetown/psicross/ravox
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylix
			wrists = /obj/item/clothing/neck/roguetown/psicross/xylix
		if (/datum/patron/divine/pestra)
			cloak = /obj/item/clothing/cloak/templar/pestra
			wrists = /obj/item/clothing/neck/roguetown/psicross/pestra

	var/weapons = list("Longsword","Mace","Flail","Whip","Spear","Axe")
	var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP YOUR GOD'S ARMS.") as anything in weapons
	switch(weapon_choice)
		if("Longsword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			beltr = /obj/item/rogueweapon/sword/long
			r_hand = /obj/item/rogueweapon/scabbard/sword
		if("Mace")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			beltr = /obj/item/rogueweapon/mace
		if("Flail")
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
			beltr = /obj/item/rogueweapon/flail
		if("Whip")
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
			beltr = /obj/item/rogueweapon/whip
		if("Spear")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			r_hand = /obj/item/rogueweapon/spear
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			beltr = /obj/item/rogueweapon/shield/buckler
		if("Axe")
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
	H.set_blindness(0)

/datum/outfit/job/roguetown/churchling/neophyte/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.reset_clergy_devotion(CLERIC_T1, CLERIC_REGEN_DEVOTEE, FALSE, CLERIC_REQ_1)
