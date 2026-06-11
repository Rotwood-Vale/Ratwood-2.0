/datum/advclass/cleric
	name = "武僧"
	tutorial = "你是一名云游侍僧，既通神迹，也习武艺。你舍弃了圣骑士所穿的锁子长罩甲，转而以不见血的打击折服对手。你肩上的行囊也沉甸甸的，里面装满了此行朝圣所需的补给。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	vampcompat = FALSE
	outfit = /datum/outfit/job/roguetown/adventurer/cleric
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	class_select_category = CLASS_CAT_CLERIC
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_OUTLANDER)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)
	// One of you is gonna look at me and act like I am stupid. It is a form of disguise
	// Also because the alternative is not very clean codewise.
	subclass_stashed_items = list(
		"《十神箴行录》" = /obj/item/book/rogue/bibble,
		"《Psydon 圣典》" = /obj/item/book/rogue/bibble/psy,
	)
	extra_context = "该子职业可从多种修行路线中择一。\
	不过，你所选的路线离徒手格斗越远，你在拳斗与摔跤上的本领也会衰退得越明显。\
	你的誓愿将决定整体速度、力量，以及获得的是闪避专家还是重创抗性特质。"

/datum/outfit/job/roguetown/adventurer/cleric
	allowed_patrons = ALL_PATRONS

/datum/outfit/job/roguetown/adventurer/cleric/pre_equip(mob/living/carbon/human/H)
	..()

	// Add druidic skill for Dendor followers
	if(istype(H.patron, /datum/patron/divine/dendor))
		H.adjust_skillrank(/datum/skill/magic/druidic, 3, TRUE)
		to_chat(H, span_notice("作为 登多尔 的信徒，我天生便知晓德鲁伊秘法。"))

	to_chat(H, span_warning("你是一名云游侍僧，既通神迹，也习武艺。\
	你舍弃了圣骑士所穿的锁子长罩甲，转而以不见血的打击折服对手。\
	你肩上的行囊也沉甸甸的，里面装满了此行朝圣所需的补给。"))
	head = /obj/item/clothing/head/roguetown/headband/monk
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backl = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
		/obj/item/reagent_containers/food/snacks/rogue/bread = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer = 1, //Plays into the classic stereotype of beer-loving monks and well-stocked pilgrims.
		)
	
	// Ascendant symbols go into the backpack, so you don't get insta-found out.
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			backpack_contents[/obj/item/clothing/neck/roguetown/psicross/inhumen] = 1
		if(/datum/patron/inhumen/matthios)
			backpack_contents[/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios] = 1
		if(/datum/patron/inhumen/graggar)
			backpack_contents[/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar] = 1
		if(/datum/patron/inhumen/baotha)	
			backpack_contents[/obj/item/clothing/neck/roguetown/psicross/inhumen/baotha] = 1

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)

	if(H.mind)
		var/weapons = list("戒律 - 徒手","拳刃","指虎","长棍")
		var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
		switch(weapon_choice)
			if("戒律 - 徒手")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 4, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist//Just this and disciple, effectively.
			if("拳刃")
				beltl = /obj/item/rogueweapon/katar/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("指虎")
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					beltl = /obj/item/rogueweapon/knuckles/psydon/old
					gloves = /obj/item/clothing/gloves/roguetown/bandages
				else
					beltl = /obj/item/rogueweapon/knuckles/bronzeknuckles
					gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("长棍")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				l_hand = /obj/item/rogueweapon/scabbard/gwstrap
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				gloves = /obj/item/clothing/gloves/roguetown/bandages

		//Wow, these sure are long!
		var/monk_vow = list("慰藉之誓 | +2 速度，闪避专家","壮举之誓 | +2 力量，重创抗性")
		var/vow_choice = input(H, "选择你的誓愿。", "立誓承戒") as anything in monk_vow
		switch(vow_choice)
			if("慰藉之誓 | +2 速度，闪避专家")
				H.change_stat(STATKEY_SPD, 2)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			if("壮举之誓 | +2 力量，重创抗性")
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
				H.change_stat(STATKEY_STR, 2)

	H.cmode_music = 'sound/music/combat_holy.ogg'

	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/psydontabard
			mask = /obj/item/clothing/head/roguetown/roguehood/psydon
		if(/datum/patron/divine/astrata)
			mask = /obj/item/clothing/head/roguetown/roguehood/astrata
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
		if(/datum/patron/divine/noc)
			mask =  /obj/item/clothing/head/roguetown/nochood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/noc
		if(/datum/patron/divine/abyssor)
			mask = /obj/item/clothing/head/roguetown/roguehood/abyssor
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor
		if(/datum/patron/divine/dendor)
			mask = /obj/item/clothing/head/roguetown/dendormask
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
		if(/datum/patron/divine/necra)
			mask = /obj/item/clothing/head/roguetown/necrahood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/necra
		if (/datum/patron/divine/malum)
			mask = /obj/item/clothing/head/roguetown/roguehood //placeholder
			cloak = /obj/item/clothing/cloak/templar/malumite
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora
			mask = /obj/item/clothing/head/roguetown/eoramask
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylix
			mask = /obj/item/clothing/mask/rogue/xylixmask
		else
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe //placeholder, anyone who doesn't have cool patron drip sprites just gets generic robes
			mask = /obj/item/clothing/head/roguetown/roguehood
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/psicross/xylix
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/cleric/paladin
	name = "圣骑士"
	tutorial = "你是一名圣洁骑士，披链甲，执钢兵。\
	别的教士或许会把闲暇花在研读经书上，而你却将自己的一切都献给了对抗 Psydonia 诸般邪恶之事。\
	一手长剑，一手紧握 psycross，便是你的道路。"
	outfit = /datum/outfit/job/roguetown/adventurer/paladin
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"《十神箴行录》" = /obj/item/book/rogue/bibble,
		"《Psydon 圣典》" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "该子职业可在两件圣物中择其一同行：一瓶命血药剂与医疗新手技艺，\
	或一把白银长剑，使剑术提升至熟练。Psydon 信徒则改为在两种教派分支间作出选择。"

/datum/outfit/job/roguetown/adventurer/paladin/pre_equip(mob/living/carbon/human/H)
	to_chat(H, span_warning("你是一名圣洁骑士，披链甲，执钢兵。\
	别的教士或许会把闲暇花在研读经书上，而你却将自己的一切都献给了对抗 Psydonia 诸般邪恶之事。\
	一手长剑，一手紧握 psycross，便是你的道路。"))
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/iron
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/chain
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			backpack_contents[/obj/item/clothing/neck/roguetown/psicross/inhumen] = 1
		if(/datum/patron/inhumen/matthios)
			backpack_contents[/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios] = 1
		if(/datum/patron/inhumen/graggar)
			backpack_contents[/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar] = 1
		if(/datum/patron/inhumen/baotha)	
			backpack_contents[/obj/item/clothing/neck/roguetown/psicross/inhumen/baotha] = 1
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/psydontabard
			if(H.mind)
				var/helmets = list("巴布塔盔", "沙勒盔", "阿梅特盔","桶盔")
				var/helmet_choice = input(H, "选择你的头盔。", "行于祂的光中") as anything in helmets
				switch(helmet_choice)
					if("巴布塔盔")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute
					if("沙勒盔")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/psysallet
					if("阿梅特盔")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm
					if("桶盔")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/psybucket
		if(/datum/patron/divine/astrata)
			cloak = /obj/item/clothing/cloak/templar/astrata
			if(H.mind)
				var/helmets = list("Barbute", "Visored Barbute","Buckethelm")
				var/helmet_choice = input(H, "Choose your HELMET.", "WALK IN HER LIGHT.") as anything in helmets
				switch(helmet_choice)
					if("Barbute")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm
					if("Visored Barbute")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm/visor
					if("Buckethelm")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/astratan
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if(/datum/patron/divine/noc)
			cloak = /obj/item/clothing/cloak/templar/noc
			head = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if(/datum/patron/divine/abyssor)
			cloak = /obj/item/clothing/cloak/abyssortabard
			head = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if(/datum/patron/divine/dendor)
			cloak = /obj/item/clothing/cloak/templar/dendor
			head = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if(/datum/patron/divine/necra)
			cloak = /obj/item/clothing/cloak/templar/necra
			head = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if (/datum/patron/divine/malum)
			cloak = /obj/item/clothing/cloak/templar/malum
			head = /obj/item/clothing/head/roguetown/helmet/heavy/malum
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/cloak/templar/eora
			head = /obj/item/clothing/head/roguetown/helmet/heavy/eoran
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if (/datum/patron/divine/ravox)
			cloak = /obj/item/clothing/cloak/cleric/ravox
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylix
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if (/datum/patron/divine/pestra)
			cloak = /obj/item/clothing/cloak/templar/pestra
			head = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		else
			cloak = /obj/item/clothing/cloak/cape/crusader
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	if(H.mind)
		if(!istype(H?.patron, /datum/patron/old_god)) //Psydonics are special.
			C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1) //Capped to T1 miracles.
			var/oaths = list("司祭之路 - 医疗与欢宴","十字军之路 - 白银武器")
			var/oath_choice = input(H, "选择你的誓约。", "宣示你的祝福") as anything in oaths
			switch(oath_choice)
				if("司祭之路 - 医疗与欢宴")
					H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_APPRENTICE, TRUE)
					beltl = /obj/item/reagent_containers/glass/bottle/rogue/healthpot //No needles or cloth, but a basic potion of lifeblood - similar to the Sorcerer's manna potion. Take the 'Physician's Apprentice' virtue for that, uncapped skills, and more.
				if("十字军之路 - 白银武器")
					var/crusaderweapon = list("白银长剑", "白银钉锤", "白银连枷", "白银长矛", "白银斧", "白银长鞭")
					var/crusaderweapon_choice = input(H, "选择你的白银武器，十字军！") as anything in crusaderweapon
					switch(crusaderweapon_choice)
						if("白银长剑")
							H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
							l_hand = /obj/item/rogueweapon/sword/long/silver //Turns the Paladin into a pre-Exorcist version of the Monster Hunter. Differences are +1 CON / -1 INT, access to minor miracles, and more limb coverage.
							beltl = /obj/item/rogueweapon/scabbard/sword //Functionally, inflicts silverbane at the cost of -5 damage. Likely won't be a balancing issue, unless we start seeing +5-10 Clerics overnight.
						if("白银钉锤")
							H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
							beltl = /obj/item/rogueweapon/mace/steel/silver
						if("白银连枷")
							H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
							beltl = /obj/item/rogueweapon/flail/sflail/silver
						if("白银长矛")
							H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
							l_hand = /obj/item/rogueweapon/spear/silver
						if("白银斧")
							H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
							l_hand = /obj/item/rogueweapon/stoneaxe/woodcut/silver
						if("白银长鞭")
							H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
							l_hand = /obj/item/rogueweapon/whip/silver // Die, monster! You don't belong in this world!
		else
			var/denominations = list("如祂一般忍受 - 信仰", "如殉者一般蒙覆 - 甲胄")
			var/denomination_choice = input("选择你的教派分支。", "汝对祂的信仰") as anything in denominations
			switch(denomination_choice)
				if("如祂一般忍受 - 信仰")
					C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
					H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_JOURNEYMAN, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
					armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate
				if("如殉者一般蒙覆 - 甲胄")
					C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
					H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_APPRENTICE, TRUE)
					ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC) //Basically a bit more flavourful Knight Errant, so may as very well give HEAVYARMOR
					armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate
	var/weapons = list("长剑","钉锤","连枷","鞭","长矛","斧")
	var/weapon_choice = input(H, "选择你的武器。", "执起神赐兵刃") as anything in weapons
	switch(weapon_choice)
		if("长剑")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
				beltr = /obj/item/rogueweapon/sword/long/oldpsysword
			else
				beltr = /obj/item/rogueweapon/sword/long
			r_hand = /obj/item/rogueweapon/scabbard/sword
		if("钉锤")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
				beltr = /obj/item/rogueweapon/mace/cudgel/psy/old
			else
				beltr = /obj/item/rogueweapon/mace
		if("连枷")
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
			beltr = /obj/item/rogueweapon/flail
		if("鞭")
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
			beltr = /obj/item/rogueweapon/whip
		if("长矛")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
				r_hand = /obj/item/rogueweapon/spear/psyspear/old
			else
				r_hand = /obj/item/rogueweapon/spear
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			beltr = /obj/item/rogueweapon/shield/buckler
		if("斧")
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
	H.set_blindness(0)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			wrists = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			wrists = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/roguetown/psicross/xylix
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/cleric/cantor
	name = "颂唱者"
	tutorial = "你曾是吟游诗人, 但如今你已寻得新的召命。神圣向你睁开了双眼，于是你开始穿行于一座又一座城镇之间，歌唱赞诗，传颂你的主神何其伟大。"
	outfit = /datum/outfit/job/roguetown/adventurer/cantor
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_EMPATH)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "该子职业拥有更高阶的神迹，并可使用吟游激励。"

/datum/outfit/job/roguetown/adventurer/cantor/pre_equip(mob/living/carbon/human/H)
	to_chat(H, span_warning("你曾是吟游诗人，但如今你已寻得新的召命。神圣向你睁开了双眼，于是你开始穿行于一座又一座城镇之间，歌唱赞诗，传颂你的主神何其伟大。"))
	H.mind?.current?.faction += "[H.name]_faction"
	head = /obj/item/clothing/head/roguetown/bardhat
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)//Capped to T2 miracles. Devotion at T2.
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T2)
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			backpack_contents[/obj/item/clothing/neck/roguetown/psicross/inhumen] = 1
		if(/datum/patron/inhumen/matthios)
			backpack_contents[/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios] = 1
		if(/datum/patron/inhumen/graggar)
			backpack_contents[/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar] = 1
		if(/datum/patron/inhumen/baotha)	
			backpack_contents[/obj/item/clothing/neck/roguetown/psicross/inhumen/baotha] = 1
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/mockery)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/templar/psydon
		if(/datum/patron/divine/astrata)
			cloak = /obj/item/clothing/cloak/templar/astrata
		if(/datum/patron/divine/noc)
			cloak = /obj/item/clothing/cloak/templar/noc
		if(/datum/patron/divine/abyssor)
			cloak = /obj/item/clothing/cloak/templar/abyssor
		if(/datum/patron/divine/dendor)
			cloak = /obj/item/clothing/cloak/templar/dendor
		if(/datum/patron/divine/necra)
			cloak = /obj/item/clothing/cloak/templar/necra
		if (/datum/patron/divine/malum)
			cloak = /obj/item/clothing/cloak/templar/malum
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/cloak/templar/eora
		if (/datum/patron/divine/ravox)
			cloak = /obj/item/clothing/cloak/templar/ravox
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylix
		if (/datum/patron/divine/pestra)
			cloak = /obj/item/clothing/cloak/templar/pestra
		if(/datum/patron/inhumen/zizo)
			cloak = /obj/item/clothing/cloak/cape/crusader
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
		else
			cloak = /obj/item/clothing/cloak/cape/crusader
	if(H.mind)
		var/weapons = list("手风琴","风笛", "班卓琴","鼓","长笛","吉他","口琴","竖琴","手摇风琴","口簧琴","鲁特琴","诗琴","三味线","小号","中提琴","歌声护符")
		var/weapon_choice = tgui_input_list(H, "选择你的乐器。", "执起乐器", weapons)
		H.set_blindness(0)
		switch(weapon_choice)
			if("手风琴")
				backr = /obj/item/rogue/instrument/accord
			if("风笛")
				backr = /obj/item/rogue/instrument/bagpipe
			if("班卓琴")
				backr = /obj/item/rogue/instrument/banjo
			if("鼓")
				backr = /obj/item/rogue/instrument/drum
			if("长笛")
				backr = /obj/item/rogue/instrument/flute
			if("吉他")
				backr = /obj/item/rogue/instrument/guitar
			if("口琴")
				backr = /obj/item/rogue/instrument/harmonica
			if("竖琴")
				backr = /obj/item/rogue/instrument/harp
			if("手摇风琴")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("口簧琴")
				backr = /obj/item/rogue/instrument/jawharp
			if("鲁特琴")
				backr = /obj/item/rogue/instrument/lute
			if("诗琴")
				backr = /obj/item/rogue/instrument/psyaltery
			if("三味线")
				backr = /obj/item/rogue/instrument/shamisen
			if("小号")
				backr = /obj/item/rogue/instrument/trumpet
			if("中提琴")
				backr = /obj/item/rogue/instrument/viola
			if("歌声护符")
				backr = /obj/item/rogue/instrument/vocals

	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/psicross/xylix
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/cleric/missionary
	name = "传教士"
	tutorial = "你是虔诚侍奉神明之人，与自己的主神有着极深的联系。你多年钻研经文、侍奉神祇，如今则踏入异乡，将自己的信仰传播四方。传道者偏重家业与营生，而牧者则以身作则，守护那些可能归入自己羊群的人。"
	outfit = /datum/outfit/job/roguetown/adventurer/missionary
	traits_applied = list(TRAIT_EMPATH)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,//just enough to reattach limbs, same as acolytes
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "该子职业可使用费伦提亚诸地最强大的神迹，但代价是其余方面将有所吃亏。"

/datum/outfit/job/roguetown/adventurer/missionary/pre_equip(mob/living/carbon/human/H)
	to_chat(H, span_warning("你是虔诚侍奉神明之人，与自己的主神有着极深的联系。你多年钻研经文、侍奉神祇，如今则踏入异乡，将自己的信仰传播四方。"))
	if(H.mind?.current)
		H.mind.current.faction += "[H.name]_faction"
	// Grant bardic inspiration if Xylix is patron
	if(istype(H.patron, /datum/patron/divine/xylix))
		var/datum/inspiration/I = new /datum/inspiration(H)
		I.grant_inspiration(H, bard_tier = BARD_T2)
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		)
	var/is_non_pantheon_missionary = istype(H.patron, /datum/patron/inhumen/zizo) || istype(H.patron, /datum/patron/inhumen/matthios) || istype(H.patron, /datum/patron/inhumen/baotha) || istype(H.patron, /datum/patron/inhumen/graggar)
	if(!is_non_pantheon_missionary)
		backpack_contents[/obj/item/ritechalk] = 1
		ADD_TRAIT(H, TRAIT_RITUALIST, TRAIT_GENERIC)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/psydontabard
			head = /obj/item/clothing/head/roguetown/roguehood/psydon
		if(/datum/patron/divine/astrata)
			head = /obj/item/clothing/head/roguetown/roguehood/astrata
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
		if(/datum/patron/divine/noc)
			head =  /obj/item/clothing/head/roguetown/nochood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/noc
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/roguetown/roguehood/abyssor
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor
		if(/datum/patron/divine/dendor)
			head = /obj/item/clothing/head/roguetown/dendormask
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
		if(/datum/patron/divine/necra)
			head = /obj/item/clothing/head/roguetown/necrahood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/necra
		if (/datum/patron/divine/malum)
			head = /obj/item/clothing/head/roguetown/roguehood //placeholder
			cloak = /obj/item/clothing/cloak/templar/malumite
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora
			head = /obj/item/clothing/head/roguetown/eoramask
			beltl = /obj/item/rogueweapon/huntingknife/scissors
			backpack_contents[/obj/item/reagent_containers/eoran_seed] = 1
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylix
			mask = /obj/item/clothing/mask/rogue/xylixmask
		if(/datum/patron/inhumen/zizo)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe
			head = /obj/item/clothing/head/roguetown/roguehood
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
		else
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe //placeholder, anyone who doesn't have cool patron drip sprites just gets generic robes
			head = /obj/item/clothing/head/roguetown/roguehood
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3)//Only T4 NOT to start maxed, with a devotion cap.
	C.update_devotion(C.max_devotion / 4 - 50, C.max_devotion / 4 - 50, silent = TRUE) // Start at ~25% of devotion cap
	if(H.mind)
		var/weapons = list("传道者之路", "牧者之路")
		var/weapon_choice = input(H, "选择你的道路。", "选择你的修行") as anything in weapons
		switch(weapon_choice)
			if("传道者之路")//Discount homesteader. No trait so you can't level these skills up, nor do you have starting tools.
				r_hand = /obj/item/rogueweapon/woodstaff
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, 1, TRUE)//just so you can make pretty floors easier
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, 3, TRUE)
			if("牧者之路")//The "combat" variant. The core stat spread should keep this class from ever overshadowing the others, but it's worth keeping an eye out anyway.
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 3, TRUE)//Good luck fighting like a monk without monk stats or Dodge Expert.

	if(istype(H.patron, /datum/patron/divine))
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast)
	if(istype(H.patron, /datum/patron/inhumen))
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast/unholyblast)

	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/psicross/xylix
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/cleric/stigmata
	name = "圣痕者"
	tutorial = "普赛顿 在悲泣。你是全父最虔诚的教士之一，甘愿将他人的苦难背负到自己身上。你已弃绝暴力。你将受苦。你将忍耐。"
	outfit = /datum/outfit/job/roguetown/adventurer/stigmata
	allowed_races = RACES_NO_CONSTRUCT

	traits_applied = list(
		TRAIT_PACIFISM,
		TRAIT_EMPATH,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_STEELHEARTED
	)
	subclass_stats = list(
		STATKEY_CON = 5,
		STATKEY_WIL = 3,
		STATKEY_SPD = 1,
		STATKEY_STR = -2,
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "这是 普赛顿 信徒专属的子职业；若你当前并非其信徒，它会强制将你改为该信仰。你将成为和平主义者，并能调用 普赛顿 赦罪者能力的较弱版本。"

/datum/outfit/job/roguetown/adventurer/stigmata
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/adventurer/stigmata/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_blindness(-3)
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/storage/belt/rogue/pouch/medicine = 1
		)

	if (H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydonlux_tamper) // absolver's bleed transfer
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydonamend) // nerfed no-rez version of absolver's absolve

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = (CLERIC_REGEN_ABSOLVER / 2), start_maxed = TRUE)

