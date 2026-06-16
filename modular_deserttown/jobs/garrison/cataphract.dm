/datum/job/roguetown/cataphract
	title = "Cataphract"
	display_title = "铁甲骑兵"
	flag = CATAPHRACT
	department_flag = GARRISON
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_races = RACES_TOLERATED_UP
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	tutorial = "你是受过精英训练的铁甲骑兵；出身小贵族，自幼作为侍从长大，如今护卫着王室，听命于他们，在这黑暗时代中作为骑士精神的最后灯塔。 \
	你全然效忠于在位摄政及其安危。切勿辜负使命。"
	display_order = JDO_KNIGHT
	whitelist_req = TRUE
	outfit = /datum/outfit/job/roguetown/cataphract
	advclass_cat_rolls = list(CTAG_CATAPHRACT = 20)
	job_traits = list(TRAIT_NOBLE, TRAIT_STEELHEARTED, TRAIT_GUARDSMAN)
	give_bank_account = 22
	noble_income = 10
	min_pq = 8
	max_pq = null
	round_contrib_points = 2

	cmode_music = 'sound/music/combat_desert2.ogg'
	social_rank = SOCIAL_RANK_MINOR_NOBLE
	job_subclasses = list(
		/datum/advclass/cataphract/greatweapon,
		/datum/advclass/cataphract/shieldmaster,
		/datum/advclass/cataphract/dervish,
		)

/datum/outfit/job/roguetown/cataphract
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/cataphract/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Ser"
		if(should_wear_femme_clothes(H))
			honorary = "Dame"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)

/datum/outfit/job/roguetown/cataphract
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison

	backpack_contents = list(
		/obj/item/storage/keyring/guardknight = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
	)

/datum/advclass/cataphract/greatweapon
	name = "重武战士"
	tutorial = "你训练有素，打击力道远超常人——精通大剑、战斧、战锤和长柄武器。"
	outfit = /datum/outfit/job/roguetown/cataphract/greatweapon

	category_tags = list(CTAG_CATAPHRACT)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 3,//Heavy hitters. Less con/end, high strength.
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/cataphract/greatweapon/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("双手阔剑","大战锤","战斧","巨斧","刺击剑","卢塞恩战锤","阔刃矛")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("双手阔剑")
				r_hand = /obj/item/rogueweapon/greatsword/zwei
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("大战锤")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			if("战斧")
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
			if("巨斧")
				r_hand = /obj/item/rogueweapon/greataxe/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
			if("刺击剑")
				r_hand = /obj/item/rogueweapon/estoc
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("卢塞恩战锤")
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			if("阔刃矛")
				r_hand = /obj/item/rogueweapon/spear/partizan
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	head = /obj/item/clothing/head/roguetown/helmet/heavy/cataphract
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cataphract
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate
	cloak = /obj/item/clothing/cloak/catcloak
	pants = /obj/item/clothing/under/roguetown/platelegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/shalal

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1
	)

/datum/advclass/cataphract/shieldmaster
	name = "盾卫大师"
	tutorial = "你习惯于传统的步兵作战方式，精通剑、连枷和战锤。 \
	你的坚韧加上盾与武器的多面组合，让你成为战场上难以撼动的可怕对手！"
	outfit = /datum/outfit/job/roguetown/cataphract/shieldmaster

	category_tags = list(CTAG_CATAPHRACT)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,//Tanky, less strength, but high con/end.
		STATKEY_INT = 1,
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,

		/datum/skill/misc/riding = SKILL_EXP_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/cataphract/shieldmaster/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("沙姆希尔弯刀","鞭","战锤","军刀")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("沙姆希尔弯刀")
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("鞭")
				l_hand = /obj/item/rogueweapon/whip/antique
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
			if ("战锤")
				l_hand = /obj/item/rogueweapon/mace/warhammer
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			if("军刀")
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				l_hand = /obj/item/rogueweapon/sword/sabre
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	backl = /obj/item/rogueweapon/shield/iron/zybantine
	head = /obj/item/clothing/head/roguetown/helmet/heavy/cataphract
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cataphract
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate
	cloak = /obj/item/clothing/cloak/catcloak
	pants = /obj/item/clothing/under/roguetown/platelegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/shalal

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1
	)

// /datum/advclass/knight/mountedknight
// 	name = "Mounted Knight"
// 	tutorial = "You are the picture-perfect knight from a high tale, knowledgeable in riding steeds into battle. You specialize in weapons most useful on a saiga including swords, polearms, and bows."
// 	outfit = /datum/outfit/job/roguetown/knight/mountedknight
// 	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled

// 	category_tags = list(CTAG_CATAPHRACT)

// 	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_EQUESTRIAN)
// 	//Decent all-around stats. Nothing spectacular. Ranged/melee hybrid class on horseback.
// 	subclass_stats = list(
// 		STATKEY_STR = 2,
// 		STATKEY_INT = 1,
// 		STATKEY_CON = 1,
// 		STATKEY_WIL = 1,
// 		STATKEY_PER = 2,
// 	)
// 	subclass_skills = list(
// 		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
// 		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
// 		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
// 		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
// 		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
// 		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
// 		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
// 		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
// 		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
// 		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
// 	)

// /datum/outfit/job/roguetown/knight/mountedknight/pre_equip(mob/living/carbon/human/H)
// 	..()
// 	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
// 	H.verbs |= /mob/proc/haltyell

// 	if(H.mind)
// 		H.adjust_blindness(-3)
// 		var/weapons = list(
// 			"Longsword + Crossbow",
// 			"Billhook + Recurve Bow",
// 			"Grand Mace + Longbow",
// 			"Sabre + Recurve Bow",
// 			"Lance + Kite Shield"
// 		)
// 		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
// 		H.set_blindness(0)
// 		switch(weapon_choice)
// 			if("Longsword + Crossbow")
// 				beltl = /obj/item/rogueweapon/scabbard/sword
// 				r_hand = /obj/item/rogueweapon/sword/long
// 				beltr = /obj/item/quiver/bolts
// 				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
// 				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
// 			if("Billhook + Recurve Bow")
// 				r_hand = /obj/item/rogueweapon/spear/billhook
// 				backl = /obj/item/rogueweapon/scabbard/gwstrap
// 				beltr = /obj/item/quiver/arrows
// 				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
// 				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
// 			if("Grand Mace + Longbow")
// 				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
// 				beltr = /obj/item/quiver/arrows
// 				beltl = /obj/item/rogueweapon/mace/goden/steel
// 				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
// 			if("Sabre + Recurve Bow")
// 				l_hand = /obj/item/rogueweapon/scabbard/sword
// 				r_hand = /obj/item/rogueweapon/sword/sabre
// 				beltr = /obj/item/quiver/arrows
// 				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
// 				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
// 			if("Lance + Kite Shield")
// 				r_hand = /obj/item/rogueweapon/spear/lance
// 				backl = /obj/item/rogueweapon/shield/tower/metal
// 				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
// 				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_APPRENTICE, TRUE) // Let them skip dummy hitting

// 	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
// 	pants = /obj/item/clothing/under/roguetown/chainlegs

// 	if(H.mind)
// 		var/helmets = list(
// 			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
// 			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
// 			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
// 			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
// 			"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
// 			"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
// 			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
// 			"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
// 			"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
// 			"Slitted Kettle"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
// 			"None"
// 		)
// 		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
// 		if(helmchoice != "None")
// 			head = helmets[helmchoice]

// 		var/armors = list(
// 			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
// 			"Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
// 			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/half,
// 			"Fluted Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/half/fluted,
// 			"Full Plate"		= /obj/item/clothing/suit/roguetown/armor/plate/full,
// 			"Ornate Full Plate"	= /obj/item/clothing/suit/roguetown/armor/plate/full/fluted,
// 		)
// 		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
// 		armor = armors[armorchoice]

// 	backpack_contents = list(
// 		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
// 		/obj/item/rope/chain = 1,
// 		/obj/item/rogueweapon/scabbard/sheath = 1
// 	)


/datum/advclass/cataphract/dervish
	name = "皇家达尔维什"
	tutorial = "你的武艺对铁甲骑兵而言并不寻常。 \
	你的敏捷身法与精湛技巧令贵族贵妇无不赞叹，而你更偏爱敏捷优雅的刀剑。 \
	虽然你穿中等护甲时已是有效战力，但唯有换上更轻便的防护，你的闪避技巧才能真正大放异彩。"
	outfit = /datum/outfit/job/roguetown/cataphract/dervish

	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_DODGEEXPERT)
	category_tags = list(CTAG_CATAPHRACT)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/cataphract/dervish/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("弯刀与长弓","刺击剑与反曲弓","军刀与盾","鞭与弩")
		var/armor_options = list("轻皮甲", "轻板甲衣", "鳞甲")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in armor_options
		H.set_blindness(0)
		switch(weapon_choice)
			if("弯刀与长弓")
				r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				beltr = /obj/item/quiver/arrows
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)

			if("刺击剑与反曲弓")
				r_hand = /obj/item/rogueweapon/estoc
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)

			if("军刀与盾")
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/iron/zybantine
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)

			if("鞭与弩")
				beltl = /obj/item/rogueweapon/whip
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/bolts
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)

		switch(armor_choice)
			if("轻皮甲")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
			if("轻板甲衣")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
				pants = /obj/item/clothing/under/roguetown/splintlegs
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
			if("鳞甲")
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
				pants = /obj/item/clothing/under/roguetown/chainlegs
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted
	head = /obj/item/clothing/head/roguetown/helmet/heavy/cataphract
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate
	cloak = /obj/item/clothing/cloak/catcloak
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/shalal
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1
	)
	
	if (H.mind)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)
