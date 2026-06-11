/datum/job/roguetown/warden
	title = "Warden"
	display_title = "守林人"
	flag = BOGGUARD
	department_flag = GARRISON
	faction = "Station"
	total_positions = 6
	spawn_positions = 6
	selection_color = JCOLOR_SOLDIER

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "你多半原本就是谷地荒林间的居民，后来志愿加入了守林人，这是一群守望未驯荒野的巡猎者。\
				守林人作为一支游侠兄弟会，并无更高层级的直属管辖，但元帅与王权仍会把你们当作驻军成员召来差遣。\
				依他们的意志行事，并换取一个巡猎者最渴望的东西，自由与安稳。"
	display_order = JDO_TOWNGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/warden
	advclass_cat_rolls = list(CTAG_WARDEN = 20)

	give_bank_account = 16
	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_blackoak.ogg'
	social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_OUTDOORSMAN, TRAIT_WOODSMAN, TRAIT_SURVIVAL_EXPERT)
	job_subclasses = list(
		/datum/advclass/warden/ranger,
		/datum/advclass/warden/forester
	)

/datum/outfit/job/roguetown/warden
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden
	cloak = /obj/item/clothing/cloak/wardencloak
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	id = /obj/item/scomstone/bad/garrison
	job_bitflag = BITFLAG_GARRISON

/datum/advclass/warden/ranger
	name = "巡猎手"
	tutorial = "你是一名巡猎手，本是猎人，自愿加入守林人之列。你在弓术上经验丰富。"
	outfit = /datum/outfit/job/roguetown/warden/ranger
	category_tags = list(CTAG_WARDEN)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_PER = 2,//7 points weighted, same as MAA. They get temp buffs in the woods instead of in the city.
		STATKEY_SPD = 2,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/slings = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE, // This should let them fry meat on fires.
	)

/datum/outfit/job/roguetown/warden/ranger/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/coif
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/warden
	beltr = /obj/item/quiver/arrows
	beltl = /obj/item/rogueweapon/huntingknife/idagger/warden_machete
	backpack_contents = list(
		/obj/item/storage/keyring/guard = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/signal_horn = 1
		)
	H.verbs |= /mob/proc/haltyell
	H.set_blindness(0)

	if(H.mind)
		var/helmets = list(
			"羚角之冠" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/antler,
			"狼首之盔"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf,
			"公羊颅盔"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/goat,
			"熊首之盔"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/bear,
			"无"
		)
		var/helmchoice = input(H, "选择你的道路。", "头盔选择") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]

		var/hoods = list(
			"寻常罩帽" 	= /obj/item/clothing/head/roguetown/roguehood/warden,
			"鹿角罩帽"		= /obj/item/clothing/head/roguetown/roguehood/warden/antler,
			"无"
		)
		var/hoodchoice = input(H, "选择你的兜帽。", "兜帽选择") as anything in hoods
		if(hoodchoice != "无")
			mask = hoods[hoodchoice]

/datum/advclass/warden/forester
	name = "林地卫手"
	tutorial = "你是一名林地卫手，本是山林樵夫，自愿加入守林人之列。你对斧与矛都有实战经验。"
	outfit = /datum/outfit/job/roguetown/warden/forester
	category_tags = list(CTAG_WARDEN)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,//7 points weighted, same as MAA. They get temp buffs in the woods instead of in the city.
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE, // This should let them fry meat on fires.
	)

/datum/outfit/job/roguetown/warden/forester/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick
	beltl = /obj/item/rogueweapon/huntingknife
	r_hand = /obj/item/rogueweapon/spear
	backpack_contents = list(
		/obj/item/storage/keyring/guard = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/signal_horn = 1
		)
	H.verbs |= /mob/proc/haltyell
	H.set_blindness(0)

	if(H.mind)
		var/helmets = list(
			"羚角之冠" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/antler,
			"狼首之盔"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf,
			"公羊颅盔"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/goat,
			"熊首之盔"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/bear,
			"无"
		)
		var/helmchoice = input(H, "选择你的道路。", "头盔选择") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]

		var/hoods = list(
			"寻常罩帽" 	= /obj/item/clothing/head/roguetown/roguehood/warden,
			"鹿角罩帽"		= /obj/item/clothing/head/roguetown/roguehood/warden/antler,
			"无"
		)
		var/hoodchoice = input(H, "选择你的兜帽。", "兜帽选择") as anything in hoods
		if(hoodchoice != "无")
			mask = hoods[hoodchoice]
