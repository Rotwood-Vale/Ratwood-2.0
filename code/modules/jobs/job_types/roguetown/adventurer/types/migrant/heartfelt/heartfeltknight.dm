
/datum/job/roguetown/heartfelt/knight
	title = "Knight of Heartfelt"
	tutorial = "你是 赤心 的骑士，曾是效忠领主的骑士团一员。\
	如今你孤身一人，仍誓要护住宫廷残余之人，于是策马前往山巅，决心确保他们平安抵达。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	total_positions = 1
	spawn_positions = 1
	job_traits = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_GOODTRAINER, TRAIT_HEARTFELT)
	advclass_cat_rolls = list(CTAG_HFT_KNIGHT)
	social_rank = SOCIAL_RANK_NOBLE
	job_subclasses = list(
		/datum/advclass/heartfelt/knight
		)

/datum/job/roguetown/heartfelt/knight/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/knight/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "骑士罩袍（[index]）"
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "爵士"
		if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
			honorary = "女爵"
		GLOB.chosen_names -= prev_real_name
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"
		GLOB.chosen_names += H.real_name

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)

/datum/advclass/heartfelt/knight
	name = "赤心 骑士"
	tutorial = "你是 赤心 的骑士，曾是效忠领主的骑士团一员。\
	如今你孤身一人，仍誓要护住宫廷残余之人，于是来到这片土地，决心确保他们平安抵达。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/heartfelt/knight
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_KNIGHT)
	class_select_category = CLASS_CAT_HFT_COURT
	subclass_social_rank = SOCIAL_RANK_NOBLE
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_HEARTFELT)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = -1,
	)

	subclass_skills = list(
	/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/heartfelt/knight/pre_equip(mob/living/carbon/human/H)
	..()

	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/platelegs
	cloak = /obj/item/clothing/cloak/tabard/knight/guard
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/hand //Heartfelt armor w/o cloak. It's neat.
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	beltr = /obj/item/rogueweapon/scabbard/sword/noble
	l_hand = /obj/item/rogueweapon/sword/long
	beltl = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
	)
	id = /obj/item/scomstone
	// This code is broken but also not, I assume because it has 1 Advanced Class at the moment DO NOT UNCOMMENT. 
	// IT WORKS :TM: still gives them a helm and grandmace, just not the choice
	
	H.adjust_blindness(-3)
	var/weapons = list("装饰长剑加盾","双手剑","巨剑","巨型钉锤","战斧","巨斧","刺剑","鹰喙锤", "长戟矛", "关刀")
	var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("装饰长剑加盾")
			l_hand = /obj/item/rogueweapon/sword/long/dec
			backl = /obj/item/rogueweapon/shield/tower/metal
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
		if("双手剑")
			r_hand = /obj/item/rogueweapon/greatsword/grenz
		if("巨剑")
			r_hand = /obj/item/rogueweapon/greatsword
		if("巨型钉锤")
			r_hand = /obj/item/rogueweapon/mace/goden/steel
		if("战斧")
			r_hand = /obj/item/rogueweapon/stoneaxe/battle
		if("巨斧")
			r_hand = /obj/item/rogueweapon/greataxe/steel
		if("刺剑")
			r_hand = /obj/item/rogueweapon/estoc
		if("鹰喙锤")
			r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
		if("长戟矛")
			r_hand = /obj/item/rogueweapon/spear/partizan
		if("关刀")
			r_hand = /obj/item/rogueweapon/halberd/glaive
		else //In case they DC or don't choose close the panel, etc
			r_hand = /obj/item/rogueweapon/eaglebeak/lucerne

	var/helmet = list("猪面盆盔","卫兵头盔","栅栏盔","桶盔","骑士盔","沃尔夫板甲盔" ,"带面罩萨雷特盔","阿米特盔","犬首盆盔", "伊特鲁斯卡盆盔", "开缝锅盔")
	var/helmet_choice = input(H, "选择你的头盔。", "披挂头盔") as anything in helmet
	switch(helmet_choice)
		if("猪面盆盔") 
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface
		if("卫兵头盔")	
			head = /obj/item/clothing/head/roguetown/helmet/heavy/guard
		if("栅栏盔")		
			head = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff
		if("桶盔")		
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
		if("骑士盔")		
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
		if("沃尔夫板甲盔") 
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate
		if("带面罩萨雷特盔")	
			head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
		if("阿米特盔")			
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet
		if("犬首盆盔")
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull
		if("伊特鲁斯卡盆盔")
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
		if("开缝锅盔") 
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
		else //In case they DC or don't choose close the panel, etc
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
