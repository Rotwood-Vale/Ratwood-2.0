/datum/job/roguetown/councillor
	title = "Councillor"
	flag = COUNCILLOR
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_ages = ALL_AGES_LIST
	allowed_races = RACES_NO_CONSTRUCT		//Nobility, so no constructs.
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_COUNCILLOR
	tutorial = "You may have inherited this position, bought your way into it, or were appointed to it by merit--perish the thought! Whatever the case though, you work as an assistant and agent of the crown in matters of state. Whether this be aiding the steward, the sheriff, or the crown itself, or simply enjoying the free food of the keep, your duties vary day by day. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	whitelist_req = FALSE
	outfit = /datum/outfit/job/roguetown/councillor
	advclass_cat_rolls = list(CTAG_COUNCILLOR = 2)

	give_bank_account = 40
	noble_income = 20
	min_pq = 1 //Probably a bad idea to have a complete newbie advising the monarch
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_noble.ogg'
	social_rank = SOCIAL_RANK_NOBLE
	job_traits = list(TRAIT_NOBLE)
	job_subclasses = list(
		/datum/advclass/councillor/herald,
		/datum/advclass/councillor/advisor,
		/datum/advclass/councillor/cofferer,
		/datum/advclass/councillor/courtier
	)

//Herald Start
/datum/advclass/councillor/herald
	name = "Herald"
	tutorial = "You are a hardy survivalist noble, tasked with carrying messages across dangerous lands. Your experience in the wilds has made you a competent swordsman and tracker. Though you lack wealth, your endurance and blade have earned you a place among the court as a trusted courier."
	outfit = /datum/outfit/job/roguetown/councillor/herald
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled
	category_tags = list(CTAG_COUNCILLOR)
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_SURVIVAL_EXPERT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_INT = -1,
		STATKEY_WIL = -1
	)

	// survivalist skills with combat competence
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
	)


//Advisor Start
/datum/advclass/councillor/advisor
	name = "Advisor"
	tutorial = "You have a keen sense of political acumen and dabble in the arcane arts. Much like the jester, albeit in a less farcical manner, you are well-suited to giving the court advice on daily matters through both wit and minor sorcery. They might even listen if you tell them that a plan of theirs may have a hole in it that would sink it. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	outfit = /datum/outfit/job/roguetown/councillor/advisor
	category_tags = list(CTAG_COUNCILLOR)
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T2, TRAIT_INTELLECTUAL)
	subclass_spellpoints = 15
	subclass_stats = list(
		STATKEY_INT = 3,// smart and magically inclined
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_STR = -2,
		STATKEY_CON = -2
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)


//Cofferer Start
/datum/advclass/councillor/cofferer
	name = "Cofferer"
	tutorial = "Whether born into wealth, or earned through working up from the bottom, you have quite the reserve of mammon at your disposal. Use your silver-tongue to acquire more, or buy more favour with the court. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	outfit = /datum/outfit/job/roguetown/councillor/cofferer
	category_tags = list(CTAG_COUNCILLOR)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_STR = -1,
		STATKEY_CON = -2
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)

//Courtier Start
/datum/advclass/councillor/courtier
	name = "Courtier"
	tutorial = "You may have inherited this position, bought your way into it, or were appointed to it by merit--perish the thought! Whatever the case though, you work as an assistant and agent of the crown in matters of state. Whether this be aiding the steward, the sheriff, or the crown itself, or simply enjoying the free food of the keep, your duties vary day by day. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	outfit = /datum/outfit/job/roguetown/councillor/courtier
	category_tags = list(CTAG_COUNCILLOR)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_STR = -1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/councillor
	job_bitflag = BITFLAG_ROYALTY
///------------------------------------------------------------------------------
/datum/outfit/job/roguetown/councillor/herald/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/councillor
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	backr = /obj/item/rogueweapon/sword/decorated
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	ADD_TRAIT(H, TRAIT_SEEPRICES_SHITTY, JOB_TRAIT)



///------------------------------------------------------------------------------
/datum/outfit/job/roguetown/councillor/advisor/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid // a mediocre pouch of coins
	shirt = /obj/item/clothing/suit/roguetown/shirt/fancyjacket
	pants = /obj/item/clothing/under/roguetown/trou/beltpants
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/councillor
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	cloak = /obj/item/clothing/cloak/half/red
	// give them the shitty see prices trait
	ADD_TRAIT(H, TRAIT_SEEPRICES_SHITTY, JOB_TRAIT)



///------------------------------------------------------------------------------
/datum/outfit/job/roguetown/councillor/cofferer/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich // rich pouch of coins
	shirt = /obj/item/clothing/suit/roguetown/shirt/fancyjacket
	pants = /obj/item/clothing/under/roguetown/trou/beltpants
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/steward // Gets the steward's key
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	cloak = /obj/item/clothing/cloak/half/red
	ADD_TRAIT(H, TRAIT_SEEPRICES, JOB_TRAIT)

///------------------------------------------------------------------------------
/datum/outfit/job/roguetown/councillor/courtier/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	shirt = /obj/item/clothing/suit/roguetown/shirt/fancyjacket
	pants = /obj/item/clothing/under/roguetown/trou/beltpants
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/councillor
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	cloak = /obj/item/clothing/cloak/half/red
	ADD_TRAIT(H, TRAIT_SEEPRICES_SHITTY, JOB_TRAIT)

