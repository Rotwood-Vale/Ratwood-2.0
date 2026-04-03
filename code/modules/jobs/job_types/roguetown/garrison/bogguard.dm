/datum/job/roguetown/bogguardsman
	title = "Bog Guard"
	flag = BOGGUARD
	department_flag = GARRISON
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	selection_color = JCOLOR_SOLDIER

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "You've handed your resume, which mostly consisted of showing up, and in exchange you have a spot among the Bog Guards. \
	You have a roof over your head, coin in your pocket, and a thankless job protecting the outskirts of town against bandits and volfs."
	display_order = JDO_TOWNGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/bogguardsman
	advclass_cat_rolls = list(CTAG_BOGGUARDSMAN = 20)

	give_bank_account = 8
	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_blackoak.ogg'
	social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_SURVIVAL_EXPERT)
	job_subclasses = list(
		/datum/advclass/bogguardsman/footman,
		/datum/advclass/bogguardsman/archer
	)

/datum/outfit/job/roguetown/bogguardsman
	backr = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/helmet/skullcap
	cloak = /obj/item/clothing/cloak/stabard/bog
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	job_bitflag = BITFLAG_GARRISON

/datum/advclass/bogguardsman/archer
	name = "Bog Archer"
	outfit = /datum/outfit/job/roguetown/bogguardsman/archer
	category_tags = list(CTAG_bogguardsman)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_PER = 3,//9 points but no buff
		STATKEY_SPD = 2,
		STATKEY_WIL = 2
	)
	subclass_skills = list(
		/datum/skill/combat/bows = 4,
		/datum/skill/combat/slings = 4,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/axes = 2,
		/datum/skill/combat/swords = 2,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/sneaking = 4,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/tracking = 3,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/riding = 2,
		/datum/skill/craft/cooking = 1, // This should let them fry meat on fires.
	)

/datum/outfit/job/roguetown/bogguardsman/archer/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	beltr = /obj/item/quiver/arrows //replaces sword
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel
	id = /obj/item/scomstone/bad/garrison
	backpack_contents = list(
		/obj/item/roguekey/walls = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/signal_horn = 1
		)
	H.verbs |= /mob/proc/haltyell
	H.set_blindness(0)


/datum/advclass/bogguardsman/footman
	name = "Bog Guard Footman"
	outfit = /datum/outfit/job/roguetown/bogguardsman/footman
	category_tags = list(CTAG_bogguardsman)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,//No special superbuffs!
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/axes = 3,
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/maces = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/shields = 3,
		/datum/skill/combat/slings = 2,
		/datum/skill/combat/bows = 1,
		/datum/skill/combat/crossbows = 1,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/tracking = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/riding = 2,
		/datum/skill/craft/cooking = 1, // This should let them fry meat on fires.
	)

/datum/outfit/job/roguetown/bogguardsman/footman/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	beltr = /obj/item/rogueweapon/sword
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel
	r_hand = /obj/item/rogueweapon/spear
	id = /obj/item/scomstone/bad/garrison
	backpack_contents = list(
		/obj/item/storage/keyring/guard = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/signal_horn = 1
		)
	H.verbs |= /mob/proc/haltyell
	H.set_blindness(0)
