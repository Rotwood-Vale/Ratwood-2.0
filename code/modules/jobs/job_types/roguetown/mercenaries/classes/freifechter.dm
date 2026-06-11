/datum/advclass/mercenary/freelancer
	name = "自由剑士"
	tutorial = "你毕业于 阿夫尼克的 的 自由斗剑团，也就是“自由战士”行会。这座享有盛名的武斗公会坐落于独立城邦 Szorendnizina，并被教廷视作献给 拉沃克斯 的一份颂礼。它建立不过三十来年，却已吸引整个西 普赛多尼亚 的访客慕名而来。你将同一件兵器挥练过上万次，而非样样浅尝辄止。这个职业属于真正有经验的战士，懂得步法与体力调配的人；光靠大师级技能，还救不了你的命。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/freelancer
	subclass_languages = list(/datum/language/aavnic)//Your character could not have possibly "graduated" without atleast some basic knowledge of Aavnic.
	class_select_category = CLASS_CAT_AAVNR
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_noble.ogg'
	traits_applied = list(TRAIT_BADTRAINER)
	//To give you an edge in specialty moves like feints and stop you from being feinted
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 3,
		STATKEY_CON = 2
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,	//I got told that having zero climbing is a PITA. Bare minimum for a combat class.
	)

/datum/outfit/job/roguetown/mercenary/freelancer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是 自由斗剑团 行会的正式毕业生。"))
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fencer	//Experimental.
	var/weapons = list("改制训练剑！！！挑战模式！！！", "Etrusca 长剑", "Kriegsmesser", "野战长剑", "煎锅", "农夫镰刀")
	if(H.mind)
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		switch(weapon_choice)
			if("改制训练剑！！！挑战模式！！！")		//A sharp feder. Less damage, better defense. Definitely not a good choice.
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
				l_hand = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/frei
				beltr = /obj/item/rogueweapon/huntingknife/idagger
			if("Etrusca 长剑")		//A longsword with a compound ricasso. Accompanied by a traditional flip knife.
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
				l_hand = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/etruscan
				beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja
			if("Kriegsmesser")		//Och- eugh- German!
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
				l_hand = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser
				beltr = /obj/item/rogueweapon/huntingknife/idagger
			if("野战长剑")		//A common longsword.
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
				l_hand = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long
				beltr = /obj/item/rogueweapon/huntingknife/idagger
			if("煎锅")
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_LEGENDARY, TRUE)
				r_hand = /obj/item/cooking/pan
				beltr = /obj/item/rogueweapon/huntingknife/idagger
			if("农夫镰刀")
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_LEGENDARY, TRUE)
				r_hand = /obj/item/rogueweapon/scythe
				beltr = /obj/item/rogueweapon/huntingknife/idagger
	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	backr = /obj/item/storage/backpack/rogue/satchel/short

	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/scabbard/sheath
		)	
	H.merctype = 6

/datum/advclass/mercenary/freelancer/lancer
	name = "枪骑步战士"
	tutorial = "你将全部信任都交给了长柄兵器，这种世上最高效的武器。既然敌人根本碰不到你，为何还要穿得太厚？你可以选择自己的长兵器，而且出手准得惊人。"
	outfit = /datum/outfit/job/roguetown/mercenary/freelancer_lancer
	subclass_languages = list(/datum/language/aavnic)//Your character could not have possibly "graduated" without atleast some basic knowledge of Aavnic.
	traits_applied = list(TRAIT_BADTRAINER)
	//To give you an edge in specialty moves like feints and stop you from being feinted
	subclass_stats = list(
		STATKEY_CON = 4,//This is going to need live testing, since I'm not sure they should be getting this much CON without using a statpack to spec. Revision pending.
		STATKEY_PER = 3,
		STATKEY_SPD = 1, //We want to encourage backstepping since you no longer get an extra layer of armour. I don't think this will break much of anything.
		STATKEY_STR = 1,
		STATKEY_WIL = -2
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,	//This is the danger zone. Ultimately, the class won't be picked without this. I took the liberty of adjusting everything around to make this somewhat inoffensive, but we'll see if it sticks.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,	//Wrestling is a swordsman's luxury.
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,	//I got told that having zero climbing is a PITA. Bare minimum for a combat class.
	)

/datum/outfit/job/roguetown/mercenary/freelancer_lancer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你将全部信任都交给了长柄兵器，这种世上最高效的武器。既然敌人根本碰不到你，为何还要穿得太厚？你可以选择自己的长兵器，而且出手准得惊人。"))
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	var/weapons = list("毕业长枪", "猎猪矛", "Lucerne 战锤")
	if(H.mind)
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		switch(weapon_choice)
			if("毕业长枪")		//A steel spear with a cool-looking stick & a banner sticking out of it.
				r_hand = /obj/item/rogueweapon/spear/boar/frei
				l_hand = /obj/item/rogueweapon/katar/punchdagger/frei
			if("猎猪矛")
				r_hand = /obj/item/rogueweapon/spear/boar
				wrists = /obj/item/rogueweapon/katar/punchdagger
			if("Lucerne 战锤")		//A normal lucerne for the people that get no drip & no bitches.
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				wrists = /obj/item/rogueweapon/katar/punchdagger

	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	backr = /obj/item/storage/backpack/rogue/satchel/short

	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/storage/belt/rogue/pouch/coins/poor
	)
	H.merctype = 6
