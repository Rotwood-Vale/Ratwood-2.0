/datum/job/roguetown/veteran
	title = "Veteran"
	display_title = "老兵"
	flag = VETERAN
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_sexes = list(MALE, FEMALE) //same as town guard
	allowed_races = RACES_NO_CONSTRUCT //Constructs are too new to even exist long enough to be veterans, plus noble title.
	tutorial = "你这一生都与战斗为伴。战争的织锦里，几乎没有哪种杀人手段是你未曾练过的。你不会自称英雄, 那些名号该留给烂在战场泥地里的死人，他们曾陪你把这门古老行当磨得纯熟。你如今夜里已睡不安稳，也不愿再想起自己为了活下去做过什么。拿冒险去换一份安稳军饷，是唯一合乎道理的选择，也许总有一天，你能放下刀兵，让这副疲惫的身躯真正歇息……"
	allowed_ages = list(AGE_OLD) //Middle-aged veteran NVKE
	advclass_cat_rolls = list(CTAG_VETERAN = 20)
	selection_color = JCOLOR_SOLDIER
	display_order = JDO_VET
	whitelist_req = TRUE
	give_bank_account = 35
	min_pq = 30 //Should...probably actually be a veteran of at least a few weeks before trying to teach others
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_MINOR_NOBLE
	cmode_music = 'sound/music/combat_veteran.ogg'
	job_subclasses = list(
		/datum/advclass/veteran/battlemaster,
		/datum/advclass/veteran/footman,
		/datum/advclass/veteran/calvaryman,
		/datum/advclass/veteran/merc,
		/datum/advclass/veteran/scout,
		/datum/advclass/veteran/spy
	)
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_COMBAT_AWARE)
	virtue_restrictions = list(/datum/virtue/combat/combat_aware)//due to them having the trait by default

/datum/job/roguetown/veteran/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/half/vet))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "老兵披风（[index]）"


/datum/advclass/veteran/battlemaster
	name = "老兵战术大师"
	tutorial = "你曾在百位主君麾下效力，有贤主，也有暴君。你曾当过将军，也做过元帅、队长。有人把你当英雄，有人把你视作怪物，总归都差不多。你曾制定战略、推演战术，发明新的战争技艺，为一个人去杀另一个人找出千百种新法子。直到今天，这些事依旧会让你夜不能寐。"
	outfit = /datum/outfit/job/roguetown/vet/battlemaster
	cmode_music = 'sound/music/cmode/towner/combat_retired.ogg'

	category_tags = list(CTAG_VETERAN)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_MASTER,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
	)

// Normal veteran start, from the olden days.

/datum/outfit/job/roguetown/vet/battlemaster
	has_loadout = TRUE

/datum/outfit/job/roguetown/vet/battlemaster/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/bevor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	beltr = /obj/item/storage/keyring/guardcastle
	backr = /obj/item/storage/backpack/rogue/satchel/black
	cloak = /obj/item/clothing/cloak/half/vet
	belt = /obj/item/storage/belt/rogue/leather/black
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.verbs |= /mob/proc/haltyell

/datum/outfit/job/roguetown/vet/battlemaster/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("长剑","军刀","连枷", "四分杖")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("长剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 6, TRUE)
				H.put_in_hands(new /obj/item/rogueweapon/sword/long)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L)
			if("军刀")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 6, TRUE)
				H.put_in_hands(new /obj/item/rogueweapon/sword/sabre)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L)
			if("连枷")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 6, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
				H.put_in_hands(new /obj/item/rogueweapon/flail/sflail)
			if("四分杖")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 6, TRUE) // Funny and rarely utilized weapon option. Why not?
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 6, TRUE)
				H.put_in_hands(new /obj/item/rogueweapon/woodstaff/quarterstaff/steel)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L)
		var/retirement = list("投身田园生活", "钻研工匠锻造", "撰写自传", "继续旧日训练")
		var/retirement_choice = input(H, "退役之后，你决定……", "选个消遣") as anything in retirement
		switch(retirement_choice)
			if("投身田园生活")
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			if("钻研工匠锻造")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
			if("撰写自传")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
			if("继续旧日训练")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)

/datum/advclass/veteran/footman
	name = "退役步兵"
	tutorial = "你不是那种披着闪亮甲胄、屹立阵前的英雄骑士，而只是个穿着手头买得起的廉价护甲上阵的凡人。你曾作为军阵中的一员并肩作战，靠着纪律赢下一场又一场战斗。也许某一天，你甚至还当过整支队伍的队长。你专精于长柄兵器与弓术。"
	outfit = /datum/outfit/job/roguetown/vet/footman

	category_tags = list(CTAG_VETERAN)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 3
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_MASTER,
		/datum/skill/combat/axes = SKILL_LEVEL_MASTER,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT, // this is a kinda scary skill to give them, surely it won't go wrong though.
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, // two handed weapons require a LOT of stamina.
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)

// No hero, just a normal guy who happened to survive war.
/datum/outfit/job/roguetown/vet/footman
	has_loadout = TRUE

/datum/outfit/job/roguetown/vet/footman/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half // Meant to be better than man-at-arms, but worse than knight. No heavy armor!! This is a cuirass, not half-plate.
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/storage/keyring/guardcastle
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.verbs |= /mob/proc/haltyell

/datum/outfit/job/roguetown/vet/footman/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("戟与剑","长矛与盾", "战锤与盾")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("戟与剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 6, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
				H.put_in_hands(new /obj/item/rogueweapon/halberd)
				H.put_in_hands(new /obj/item/rogueweapon/sword)
			if("长矛与盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 6, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 6, TRUE)
				H.put_in_hands(new /obj/item/rogueweapon/spear)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_L)
			if("战锤与盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 6, TRUE) // Funny and rarely utilized weapon option. Why not?
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 6, TRUE)
				H.put_in_hands(new /obj/item/rogueweapon/mace/warhammer/steel)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_L)
		var/retirement = list("投身田园生活", "钻研工匠锻造", "撰写自传", "继续旧日训练")
		var/retirement_choice = input(H, "退役之后，你决定……", "选个消遣") as anything in retirement
		switch(retirement_choice)
			if("投身田园生活")
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			if("钻研工匠锻造")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
			if("撰写自传")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
			if("继续旧日训练")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)


/datum/advclass/veteran/calvaryman
	name = "褪色骑士"
	tutorial = "你曾是骑士骑兵团中的一员，那是极受尊崇的头衔。你曾站在云端之上，策马穿街而过时，镇民们都会为你欢呼。如今，你耳边只剩战友倒下时的惨叫。你专精于骑乘作战。"
	outfit = /datum/outfit/job/roguetown/vet/calvaryman

	category_tags = list(CTAG_VETERAN)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE, TRAIT_GOODTRAINER, TRAIT_EQUESTRIAN) //So they can actually do the job as good as other classes, while trading own potential for some flavor
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_SPD = -1 //Malus in exchange for other things
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_MASTER,
		/datum/skill/combat/axes = SKILL_LEVEL_MASTER,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
	)

// You get a SAIGA. Saigas are pretty good, you lose out on your legendary weapon skills and you suck more on foot though. Will give Saddleborn once its in.
/datum/outfit/job/roguetown/vet/calvaryman
	has_loadout = TRUE

/datum/outfit/job/roguetown/vet/calvaryman/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/plate/	// Former knights should have knightly armour.
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1 // Former noble, so it makes sense for them to have some more starting capital
		)
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("长剑 + 反曲弓","斧头 + 十字弩","长矛 + 盾")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("长剑 + 反曲弓")
				H.put_in_hands(new /obj/item/rogueweapon/sword/long)
				H.equip_to_slot_or_del(new /obj/item/quiver/arrows, SLOT_BELT_L)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R)
				H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve, SLOT_BACK_L)
			if("斧头 + 十字弩")
				H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/woodcut/steel)
				H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, SLOT_BACK_L)
				H.equip_to_slot_or_del(new /obj/item/quiver/bolts, SLOT_BELT_L)
			if ("长矛 + 盾")
				H.put_in_hands(new /obj/item/rogueweapon/spear)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_L)
		var/retirement = list("投身田园生活", "钻研工匠锻造", "撰写自传", "继续旧日训练")
		var/retirement_choice = input(H, "退役之后，你决定……", "选个消遣") as anything in retirement
		switch(retirement_choice)
			if("投身田园生活")
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			if("钻研工匠锻造")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
			if("撰写自传")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
			if("继续旧日训练")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)

/datum/advclass/veteran/merc
	name = "退役佣兵"
	tutorial = "你曾是个卖命之剑，是为钱而战的武人。你腰包从不干瘪，总有暖和住处，也从不缺一口饱饭，但你心里明白，每一场仗都可能是你的最后一场。如今你成了整支队伍最后的幸存者，而你无法不为此感到悔恨。你专精于剑与长柄兵器，或斧与长柄兵器。"
	outfit = /datum/outfit/job/roguetown/vet/merc

	subclass_languages = list(/datum/language/grenzelhoftian)
	cmode_music = 'sound/music/combat_grenzelhoft.ogg'
	category_tags = list(CTAG_VETERAN)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_WIL = 3,// two handed weapons require a LOT of stamina.
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_MASTER,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
	)

// Normal veteran start, from the olden days

/datum/outfit/job/roguetown/vet/merc
	has_loadout = TRUE

/datum/outfit/job/roguetown/vet/merc/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/gorget
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft // You do GET blacksteel cuirass since its not even THAT good, all things considered
	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	armor = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_half_plate	//This is a cuirass
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	beltl = /obj/item/rogueweapon/sword/short
	beltr = /obj/item/storage/keyring/guardcastle
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.verbs |= /mob/proc/haltyell

/datum/outfit/job/roguetown/vet/merc/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("双手剑","戟")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("双手剑")
				H.put_in_hands(new /obj/item/rogueweapon/greatsword/grenz)
				H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
				H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L)
			if("戟")
				H.put_in_hands(new /obj/item/rogueweapon/halberd)
				H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE) // SO, fun fact. The description of the grenzel halbardier says they specialize in axes, but they get no axe skill. Maybe this guy is where that rumor came from.
				H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L)
		var/retirement = list("投身田园生活", "钻研工匠锻造", "撰写自传", "继续旧日训练")
		var/retirement_choice = input(H, "退役之后，你决定……", "选个消遣") as anything in retirement
		switch(retirement_choice)
			if("投身田园生活")
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			if("钻研工匠锻造")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
			if("撰写自传")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
			if("继续旧日训练")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)

/datum/advclass/veteran/scout
	name = "前侦察兵"
	tutorial = "你和你的小队总是游走在主力之前，时刻提防陷阱与伏击。只是你从未真正想过，若自己亲身撞进去，又会是什么下场。你专精于弓术与斧术。" //Slightly reflavored into a full-on former bogmaster. Dodge-maxxing doesnt work on veteran anyhow.
	outfit = /datum/outfit/job/roguetown/vet/scout

	category_tags = list(CTAG_VETERAN)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_WOODSMAN, TRAIT_OUTDOORSMAN, TRAIT_PERFECT_TRACKER)
	subclass_stats = list(
		STATKEY_PER = 3, // You are OLD you have OLD EYES. this is to counter that debuff so you can be OBSERVANT. Moved the bonus from BEING OLD since now veterans are forced to be such
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_STR = 1 //STR bonus instead of SPD one snce changed to medium armor. Dodge-maxxing is for the Spy Class.
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_LEGENDARY, // I very rarely see ranged weapons outside of PVE. Maybe this'll fix that?
		/datum/skill/combat/crossbows = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/slings = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN
	)

// Originally was meant to be a horse archer. I decided that was a bad idea.
// Former Bogmaster, actually? I feel like that's much cooler than just an archer guy.
/datum/outfit/job/roguetown/vet/scout
	has_loadout = TRUE

/datum/outfit/job/roguetown/vet/scout/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/antler
	mask = /obj/item/clothing/head/roguetown/roguehood/warden
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	beltr = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	r_hand = /obj/item/rogueweapon/greataxe/steel
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/wardencloak
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.verbs |= /mob/proc/haltyell
	H.cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg' // so apparently this works for veteran, but not for advents. i dont know why.

/datum/outfit/job/roguetown/vet/scout/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("长弓","投石索","十字弩")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("长弓")
				H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden)
				H.equip_to_slot_or_del(new /obj/item/quiver/arrows, SLOT_BELT_L)
			if("投石索")
				H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/sling)
				H.equip_to_slot_or_del( new /obj/item/quiver/sling/iron, SLOT_BELT_L)
			if("十字弩")
				H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow)
				H.equip_to_slot_or_del(new /obj/item/quiver/bolts, SLOT_BELT_L)
		var/retirement = list("投身田园生活", "钻研工匠锻造", "撰写自传", "继续旧日训练")
		var/retirement_choice = input(H, "退役之后，你决定……", "选个消遣") as anything in retirement
		switch(retirement_choice)
			if("投身田园生活")
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			if("钻研工匠锻造")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
			if("撰写自传")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
			if("继续旧日训练")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)

/datum/advclass/veteran/spy
	name = "前间谍"
	tutorial = "你从未在前线服役，你是线人、间谍、刺客。你曾穿梭于敌方宫廷之间，搜寻情报，清除尾巴。在这行里，多数人死得很早，而你竟活到了老年。如今还能站在这里，简直是个奇迹。你专精于匕首、长鞭与潜行。"
	outfit = /datum/outfit/job/roguetown/vet/spy
	subclass_languages = list(/datum/language/thievescant)
	cmode_music = 'sound/music/cmode/nobility/combat_spymaster.ogg'
	category_tags = list(CTAG_VETERAN)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_CICERONE, TRAIT_SEEPRICES, TRAIT_DECEIVING_MEEKNESS) //Mostly SOVL traits
	subclass_stats = list(
		STATKEY_INT = 3,// you are int-maxxing, especially if you go old.
		STATKEY_PER = 2,
		STATKEY_CON = 1,
		STATKEY_SPD = 3,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/knives = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
	)

// The sneaker. Not really typical, but hey, wildcard. Wanna-be Spymaster. I guess that just makes them a normal spy, or, once one.

/datum/outfit/job/roguetown/vet/spy/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/white
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	pants = /obj/item/clothing/under/roguetown/tights/black
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	beltl = /obj/item/rogueweapon/whip
	beltr = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/silver/elvish = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
		/obj/item/lockpickring/mundane,
		)
	H.verbs |= /mob/proc/haltyell

/datum/outfit/job/roguetown/vet/spy/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.adjust_blindness(-3)
	if(H.mind)
		var/retirement = list("投身田园生活", "钻研工匠锻造", "撰写自传", "继续旧日训练")
		var/retirement_choice = input(H, "退役之后，你决定……", "选个消遣") as anything in retirement
		switch(retirement_choice)
			if("投身田园生活")
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			if("钻研工匠锻造")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
			if("撰写自传")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
			if("继续旧日训练")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
