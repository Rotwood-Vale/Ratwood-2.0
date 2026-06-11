/datum/job/roguetown/vanguard
	title = "Vanguard"
	display_title = "先锋守卒"
	flag = BOGGUARD
	department_flag = GARRISON
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	selection_color = JCOLOR_SOLDIER

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "不论你是想证明自己的卑微新兵，还是被迫服役来偿还罪责的犯人，你如今都被派往下城区堡垒。\
	你有片瓦遮头，口袋里有点微薄军饷，还有一份没人感激的苦差，要替镇郊挡住荒野之外潜伏的威胁。\
	你隶属于那位冷淡的守林总长及其麾下守林人，也可能被元帅与王权当作驻军成员调遣。\
	按他们的意志行事，充当文明边境之外第一道防线，守住先锋堡垒，再努力多活一天。说不定哪天你也能跻身守林人之列。"
	display_order = JDO_TOWNGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/vanguard
	advclass_cat_rolls = list(CTAG_VANGUARD = 20)

	give_bank_account = 8
	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_blackoak.ogg'
	social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_SURVIVAL_EXPERT)
	job_subclasses = list(
		/datum/advclass/vanguard/footman,
		/datum/advclass/vanguard/archer
	)

/datum/outfit/job/roguetown/vanguard
	backr = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/helmet/skullcap
	cloak = /obj/item/clothing/cloak/shadowcloak
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	job_bitflag = BITFLAG_GARRISON

/datum/advclass/vanguard/archer
	name = "先锋弓手"
	tutorial = "你对弓术之道已算熟稔。\
	你将站在后方，用箭雨掩护前线。"	
	outfit = /datum/outfit/job/roguetown/vanguard/archer
	category_tags = list(CTAG_VANGUARD)
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

/datum/outfit/job/roguetown/vanguard/archer/pre_equip(mob/living/carbon/human/H)
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


/datum/advclass/vanguard/footman
	name = "先锋步卒"
	tutorial = "你对各种尖头长兵器的用法已经受过足够训练。\
	你将立于前线，担起守御。"
	outfit = /datum/outfit/job/roguetown/vanguard/footman
	category_tags = list(CTAG_VANGUARD)
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

/datum/outfit/job/roguetown/vanguard/footman/pre_equip(mob/living/carbon/human/H)
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
