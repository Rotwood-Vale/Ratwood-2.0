/datum/job/roguetown/slavemaster
	title = "Slave Master"
	flag = SLAVEMASTER
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)

	job_traits = list(TRAIT_STEELHEARTED, TRAIT_DUNGEONMASTER, TRAIT_GUARDSMAN, TRAIT_DEATHBYSNUSNU, TRAIT_PURITAN_ADVENTURER, TRAIT_MEDIUMARMOR, TRAIT_XENOPHOBIC, TRAIT_NOBLE, TRAIT_DUNGEONMASTER_LABOR_CAMP) //'PURITAN_ADVENTURER' is the codename. Presents as 'INTERROGATOR', in-game. Doesn't provide any Inquisition-related boons, but gives instrucitons on how to use certain mechanics.
	display_order = JDO_DUNGEONEER
	advclass_cat_rolls = list(CTAG_SLAVEMASTER = 2)

	tutorial = "CHANGE THIS!! something something WHIPS something something keeping the rabble in line something something sterin guiding hand. You have a swanky room in the keep, you catch escaped slaves, and you put existing slaves to work. Check the jails for prisoners to enslave."

	announce_latejoin = FALSE
	outfit = /datum/outfit/job/roguetown/slavemaster
	give_bank_account = 25
	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_MINOR_NOBLE
	cmode_music = 'sound/music/combat_zybantine.ogg'
	job_subclasses = list(
		/datum/advclass/slavemaster
	)

/datum/job/roguetown/slavemaster/New()
	. = ..()
	peopleknowme = list()
	for(var/X in GLOB.garrison_positions)
		peopleknowme += X
	for(var/X in GLOB.noble_positions)
		peopleknowme += X
	for(var/X in GLOB.courtier_positions)
		peopleknowme += X

/datum/job/roguetown/slavemaster/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")

/datum/outfit/job/roguetown/slavemaster
	job_bitflag = BITFLAG_GARRISON

/datum/advclass/slavemaster
	name = "Slavemaster"
	tutorial = "CHANGE THIS!! something something WHIPS something something keeping the rabble in line something something sterin guiding hand"
	outfit = /datum/outfit/job/roguetown/slavemaster/base

	category_tags = list(CTAG_SLAVEMASTER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,//slave chasin'
	)
	subclass_skills = list(
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,//slave whippin
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER, //slave wranglin
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT, //slave beatin
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,//Enough for majority of surgeries without grinding.
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, //slave chasin'
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN, //slave detection
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN
	)
	// adv_stat_ceiling = list(STAT_STRENGTH = 16, STAT_CONSTITUTION = 16, STAT_WILLPOWER = 16)

/datum/outfit/job/roguetown/slavemaster/base/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim

	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/purple
	neck = /obj/item/clothing/neck/roguetown/bevor
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	belt = /obj/item/storage/belt/rogue/leather/shalal/purple
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	cloak = /obj/item/clothing/cloak/cape/purple
	backl = /obj/item/storage/backpack/rogue/backpack
	beltr = /obj/item/rogueweapon/whip/antique
	beltl = /obj/item/storage/keyring/dungeoneer
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison
	backpack_contents = list(/obj/item/flashlight/flare/torch/lantern, /obj/item/reagent_containers/glass/bottle/rogue/healthpot = 2, /obj/item/rope/chain = 1, /obj/item/flint = 1, /obj/item/clothing/neck/roguetown/collar/leather = 2)

	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	//Torture victim is for inquisition - doesn't even work without a psicross anymore so maybe come up with a variant for him specifically?
