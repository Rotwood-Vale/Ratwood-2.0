/datum/job/roguetown/rookie
	title = "Rookie"
	display_title = "新兵"
	flag = ROOKIE
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	advclass_cat_rolls = list(CTAG_ROOKIE = 20)
	job_traits = list(TRAIT_SQUIRE_REPAIR, TRAIT_GUARDSMAN)

	tutorial = "打杂、跑腿、修补甲胄、同本地人打交道，卫队总少不了多一双手、多一双眼、多一对耳朵。协助你的同袍应对内外威胁。\
				你只受过一丁点兵器和卫务训练，剩下的本事都得在差事里慢慢学。\
				服从你的上级，也就是除了你自己以外的所有人，并向贵族表示敬意。放机灵点，多学点东西，说不定哪天你就能活着熬成个像样的士兵。"

	outfit = /datum/outfit/job/roguetown/rookie
	display_order = JDO_SQUIRE
	give_bank_account = TRUE
	min_pq = 0 //starting role
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_PEASANT

	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	job_subclasses = list(
		/datum/advclass/rookie/frontline,
		/datum/advclass/rookie/backline
	)

/datum/outfit/job/roguetown/rookie
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	belt = /obj/item/storage/belt/rogue/leather
	id = /obj/item/scomstone/bad/garrison
	job_bitflag = BITFLAG_GARRISON

// /datum/job/roguetown/squire/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
// 	. = ..()
// 	if(ishuman(L))
// 		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, cloak_and_title_setup)), 50)


/datum/advclass/rookie/frontline
	name = "前线新兵"
	tutorial = "学得最快的路子，往往也是死得最快的路子。"
	outfit = /datum/outfit/job/roguetown/rookie/footman

	category_tags = list(CTAG_ROOKIE)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/shields = 2,
		/datum/skill/combat/maces = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/tracking = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/cooking = 1,
	)

/datum/outfit/job/roguetown/rookie/footman/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/stabard/surcoat/guard
	head = /obj/item/clothing/head/roguetown/helmet/kettle/
	if(SSmapping.current_map.map_name == "Rockhill")
		cloak = /obj/item/clothing/cloak/citywatch
		head = /obj/item/clothing/head/roguetown/helmet/kettle/citywatch
	if(SSmapping.current_map.map_name == "Desert Town")
		cloak = /obj/item/clothing/cloak/citywatch/janissary
		head = /obj/item/clothing/head/roguetown/helmet/janissaryhelm
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/hammer/iron,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("剑与盾","棍棒与盾","长矛")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("剑与盾")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/short/iron
				backl = /obj/item/rogueweapon/shield/iron
			if("棍棒与盾")
				r_hand = /obj/item/rogueweapon/mace/cudgel
				backl = /obj/item/rogueweapon/shield/iron
			if("长矛")
				r_hand = /obj/item/rogueweapon/spear
				backl = /obj/item/rogueweapon/scabbard/gwstrap

/datum/advclass/rookie/backline
	name = "后线新兵"
	tutorial = "保持距离，盯紧局势，趁他们没看见时狠狠干上一下。"
	outfit = /datum/outfit/job/roguetown/rookie/skirmisher

	category_tags = list(CTAG_ROOKIE)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/bows = 3,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/slings = 3,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/maces = 2,//clobbering criminals
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/tracking = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/cooking = 1,
	)

/datum/outfit/job/roguetown/rookie/skirmisher/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	pants = /obj/item/clothing/under/roguetown/trou/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	beltl = /obj/item/rogueweapon/mace/cudgel
	cloak = /obj/item/clothing/cloak/stabard/surcoat/guard
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	if(SSmapping.current_map.map_name == "Rockhill")
		cloak = /obj/item/clothing/cloak/citywatch
		head = /obj/item/clothing/head/roguetown/helmet/kettle/citywatch
	if(SSmapping.current_map.map_name == "Desert Town")
		cloak = /obj/item/clothing/cloak/citywatch/janissary
		head = /obj/item/clothing/head/roguetown/helmet/janissaryhelm
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/hammer/iron,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("十字弩","弓","投石索")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		var/armor_options = list("轻甲", "中甲")
		var/armor_choice = input(H, "选择你的护甲。", "穿上护甲") as anything in armor_options
		H.set_blindness(0)
		switch(weapon_choice)
			if("十字弩")
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("弓")
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("投石索")
				beltr = /obj/item/quiver/sling/iron
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling

		switch(armor_choice)
			if("轻甲")
				armor = /obj/item/clothing/suit/roguetown/armor/leather
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			if("中甲")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
