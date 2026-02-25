/datum/job/roguetown/lady
	title = "Consort"
	flag = LADY
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	advclass_cat_rolls = list(CTAG_CONSORT = 20)
	tutorial = "Picked out of your political value rather than likely any form of love, you have become the Grand Duke's most trusted confidant--and likely friend--throughout your marriage. Your loyalty and perhaps even your love will be tested this day... for the daggers that threaten your beloved are as equally pointed at your own throat."

	spells = list(/obj/effect/proc_holder/spell/self/convertrole/servant,
	/obj/effect/proc_holder/spell/self/grant_nobility)
	outfit = /datum/outfit/job/roguetown/lady

	display_order = JDO_LADY
	give_bank_account = 50
	noble_income = 22
	min_pq = 5
	max_pq = null
	round_contrib_points = 3

	job_subclasses = list(
		/datum/advclass/lady/warrior,
		/datum/advclass/lady/merchant,
		/datum/advclass/lady/wizard,
		/datum/advclass/lady/loving
	)

/datum/job/roguetown/exlady
	title = "Consort Dowager"
	flag = LADY
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	display_order = JDO_LADY
	give_bank_account = TRUE 

/datum/outfit/job/roguetown/lady
	job_bitflag = BITFLAG_ROYALTY

/datum/advclass/lady/warrior
	name = "Fencer"
	tutorial = "You belonged to a Noble Martial Family, renowned for its prowess and skill. Though you would never be the heir of your lands, your family brought you up to know how to defend yourself. In Exchange for Martial Support, you have been married off to the local Lord. "
	outfit = /datum/outfit/job/roguetown/lady/warrior
	category_tags = list(CTAG_CONSORT)
	traits_applied = list(TRAIT_NOBLE, TRAIT_DODGEEXPERT, TRAIT_DECEIVING_MEEKNESS,TRAIT_MIASMA)
	subclass_stats = list(
		STATKEY_LCK = 2,
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = 1,
		STATKEY_STR = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/lady/warrior/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/sword/rapier
	if(should_wear_femme_clothes(H))
		beltl = /obj/item/storage/keyring/royal
		neck = /obj/item/storage/belt/rogue/pouch/coins/rich
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		head = /obj/item/clothing/head/roguetown/nyle/consortcrown
		shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
		id = /obj/item/scomstone/garrison
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	else if(should_wear_masc_clothes(H))
		head = /obj/item/clothing/head/roguetown/nyle/consortcrown
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		belt = /obj/item/storage/belt/rogue/leather
		beltl = /obj/item/storage/keyring/royal
		beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
		backr = /obj/item/storage/backpack/rogue/satchel
		id = /obj/item/clothing/ring/silver
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)

/datum/advclass/lady/merchant
	name = "Patrician"
	tutorial = "Hailing from Merchant Family, granted Nobility in foreign lands you have gained a marriage with the local Lord through Cunning Ways and lots of Mammon. Do what you must to keep your place at the local Lords Side. Show your worth."
	outfit = /datum/outfit/job/roguetown/lady/merchant
	category_tags = list(CTAG_CONSORT)
	noble_income = 80 // Only around 80 so its not absolutely broken amounts of coin
	traits_applied = list(TRAIT_NOBLE, TRAIT_SEEPRICES, TRAIT_CICERONE, TRAIT_KEENEARS,TRAIT_MIASMA)
	subclass_stats = list(
		STATKEY_LCK = 1,
		STATKEY_INT = 2,
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
		STATKEY_STR = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/lady/merchant/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		beltl = /obj/item/storage/keyring/royal
		neck = /obj/item/storage/belt/rogue/pouch/coins/rich
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		head = /obj/item/clothing/head/roguetown/nyle/consortcrown
		shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
		id = /obj/item/scomstone/garrison
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	else if(should_wear_masc_clothes(H))
		head = /obj/item/clothing/head/roguetown/nyle/consortcrown
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		belt = /obj/item/storage/belt/rogue/leather
		beltl = /obj/item/storage/keyring/royal
		beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
		backr = /obj/item/storage/backpack/rogue/satchel
		id = /obj/item/clothing/ring/silver
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)

/datum/advclass/lady/wizard
	name = "Magocrat"
	tutorial = "From Far lands, raised upon a Noble Family of Mages. You have earned the right of the local Lords Side, through your dedication and training to knowledge and power. Yet it has never been quite enough. And still you yearn to learn more."
	outfit = /datum/outfit/job/roguetown/lady/wizard
	category_tags = list(CTAG_CONSORT)
	traits_applied = list(TRAIT_NOBLE, TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_INTELLECTUAL,TRAIT_MIASMA)
	subclass_stats = list(
		STATKEY_LCK = 1,
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
	)
	subclass_spellpoints = 21
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/lady/wizard/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		beltl = /obj/item/storage/keyring/royal
		neck = /obj/item/storage/belt/rogue/pouch/coins/rich
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		head = /obj/item/clothing/head/roguetown/nyle/consortcrown
		shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
		id = /obj/item/scomstone/garrison
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	else if(should_wear_masc_clothes(H))
		head = /obj/item/clothing/head/roguetown/nyle/consortcrown
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		belt = /obj/item/storage/belt/rogue/leather
		beltl = /obj/item/storage/keyring/royal
		beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
		backr = /obj/item/storage/backpack/rogue/satchel
		id = /obj/item/clothing/ring/silver
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/roguegem/amethyst = 1, /obj/item/spellbook_unfinished/pre_arcyne = 1)

/datum/advclass/lady/loving
	name = "Consort"
	tutorial = "You are no Warrior, nor expert mage. You come from a renowned and wealthy Noble Family. One of Status and Dignity. Married off to the Local Lord of the Lands to Secure Alliances. Yet you fell in love. And as such, use the skills taught to you from your upbringing to assist your Love to the best of your ability."
	outfit = /datum/outfit/job/roguetown/lady/loving
	category_tags = list(CTAG_CONSORT)
	traits_applied = list(TRAIT_NOBLE, TRAIT_CRITICAL_WEAKNESS,TRAIT_GOODLOVER,TRAIT_BEAUTIFUL,TRAIT_NUTCRACKER,TRAIT_MIASMA)
	subclass_stats = list(
		STATKEY_LCK = 5,
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_WIL = 3,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,

	)

/datum/outfit/job/roguetown/lady/loving/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogue/instrument/harp
	if(should_wear_femme_clothes(H))
		beltl = /obj/item/storage/keyring/royal
		neck = /obj/item/storage/belt/rogue/pouch/coins/rich
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		head = /obj/item/clothing/head/roguetown/nyle/consortcrown
		shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
		id = /obj/item/scomstone/garrison
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	else if(should_wear_masc_clothes(H))
		head = /obj/item/clothing/head/roguetown/nyle/consortcrown
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		belt = /obj/item/storage/belt/rogue/leather
		beltl = /obj/item/storage/keyring/royal
		beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
		backr = /obj/item/storage/backpack/rogue/satchel
		id = /obj/item/clothing/ring/silver

/obj/effect/proc_holder/spell/self/convertrole/servant
	name = "Recruit Servant"
	new_role = "Servant"
	overlay_state = "recruit_servant"
	recruitment_faction = "Servants"
	recruitment_message = "Serve the crown, %RECRUIT!"
	accept_message = "FOR THE CROWN!"
	refuse_message = "I refuse."
	recharge_time = 100
