/datum/job/roguetown/vanguard
	title = "Vanguard"
	flag = BOGGUARD
	department_flag = GARRISON
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	selection_color = JCOLOR_SOLDIER

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "Either a fresh lowborn recruit with something to prove or paying off your crimes with a mandated tour of duty, you have been assigned to the lowtown bastion. \
	You have a roof over your head, meagre coin in your pocket, and a thankless job protecting the outskirts of town against what lurks beyond.\
	While typically under less supervision than the Men at Arms stationed in hightown, you will be called upon as members of the garrison by the Marshal or the Crown. \
	Serve their will as the first line of defence from threats beyond the borders of civilisation, hold the vanguard bastion, and try to survive another day."
	display_order = JDO_TOWNGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/vanguard
	advclass_cat_rolls = list(CTAG_VANGUARD = 20)

	give_bank_account = 8
	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_vigilante.ogg'
	social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_SURVIVAL_EXPERT)
	job_subclasses = list(
		/datum/advclass/vanguard/footman,
		/datum/advclass/vanguard/archer
	)

/datum/outfit/job/roguetown/vanguard
	// armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden
	// cloak = /obj/item/clothing/cloak/wardencloak
	// shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	// belt = /obj/item/storage/belt/rogue/leather
	// backr = /obj/item/storage/backpack/rogue/satchel
	// wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/helmet/skullcap
	cloak = /obj/item/clothing/cloak/half/shadowcloak
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	job_bitflag = BITFLAG_GARRISON

/datum/advclass/vanguard/archer
	name = "Vanguard Archer"
	tutorial = "You are well versed in the ways of handling a bow. \
	You will stand in the back, and protect the front with arrows."	
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
		/obj/item/storage/keyring/guard = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/signal_horn = 1
		)
	H.verbs |= /mob/proc/haltyell
	H.set_blindness(0)


/datum/advclass/vanguard/footman
	name = "Vanguard Footman"
	tutorial = "You are adequately briefed on the ways of wielding pointy sticks. \
	You will stand in the front, and protect."
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
