/datum/advclass/mercenary/desert_rider
	name = "沙海骑手耶尼切里"
	tutorial = "耶尼切里是帝国最精锐的步战部队，执钉锤与坚盾而战。我们绝不溃退。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/desert_rider
	class_select_category = CLASS_CAT_ZYBANTU
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_desertrider.ogg' //GREATEST COMBAT TRACK IN THE GAME SO FAR BESIDES MAYBE MANIAC2.OGG
	subclass_languages = list(/datum/language/celestial)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)


/datum/outfit/job/roguetown/mercenary/desert_rider/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("耶尼切里是帝国最精锐的步战部队，执钉锤与坚盾而战。我们绝不溃退。"))
	head = /obj/item/clothing/head/roguetown/helmet/sallet/zyb
	neck = /obj/item/clothing/neck/roguetown/bevor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	gloves = /obj/item/clothing/gloves/roguetown/chain
	pants = /obj/item/clothing/under/roguetown/splintlegs
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/clothing/neck/roguetown/shalal
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife/idagger/navaja,
		/obj/item/flashlight/flare/torch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	var/weapons = list("钉锤与盾","弯刀与盾","长矛与盾","斧与盾")
	if(H.mind)
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("钉锤与盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
				backl = /obj/item/rogueweapon/shield/tower/zyb
				beltr = /obj/item/rogueweapon/mace/steel
			if("弯刀与盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
				backl = /obj/item/rogueweapon/shield/tower/zyb
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("长矛与盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				r_hand = /obj/item/rogueweapon/spear
				backl = /obj/item/rogueweapon/shield/tower/zyb
			if("斧与盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)	//lets see if people pick it!
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
				backl = /obj/item/rogueweapon/shield/tower/zyb

	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal
	beltl = /obj/item/rogueweapon/scabbard/sword
	l_hand = /obj/item/rogueweapon/sword/sabre/shamshir

	H.merctype = 4

/datum/advclass/mercenary/desert_rider/zeybek
	name = "沙海骑手泽伊贝克"
	tutorial = "兹班图 的“刃舞者”闻名天下，也令世人畏惧。他们在长短兵刃上的造诣众所周知。"
	outfit = /datum/outfit/job/roguetown/mercenary/desert_rider_zeybek
	traits_applied = list(TRAIT_DODGEEXPERT,TRAIT_DUALWIELDER)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/mercenary/desert_rider_zeybek/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("兹班图 的“刃舞者”闻名天下，也令世人畏惧。他们在长短兵刃上的造诣众所周知。"))
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/zyb
	neck = /obj/item/clothing/neck/roguetown/leather
	mask = /obj/item/clothing/mask/rogue/facemask/ancient
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/zyb
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	gloves = /obj/item/clothing/gloves/roguetown/angle
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/zyb
	backr = /obj/item/storage/backpack/rogue/satchel/black
	l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
	id = /obj/item/clothing/neck/roguetown/shalal
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife/idagger/navaja,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/flashlight/flare/torch,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	var/weapons = list("弯刀与标枪","长鞭与匕首", "反曲弓")
	if(H.mind)
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("弯刀与标枪")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				backl = /obj/item/quiver/javelin/iron
				beltl = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("长鞭与匕首")	///They DO enslave people after all
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/whip
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("反曲弓")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltl = /obj/item/quiver/arrows
				beltr = /obj/item/rogueweapon/scabbard/sword
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal


	H.merctype = 4

/datum/advclass/mercenary/desert_rider/almah
	name = "沙海骑手阿尔玛"
	tutorial = "阿尔玛是同时精于魔法与剑术的人，却又在任何一门上都谈不上登峰造极。"
	outfit = /datum/outfit/job/roguetown/mercenary/desert_rider_almah
	traits_applied = list(TRAIT_ARCYNE_T2, TRAIT_MAGEARMOR)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_PER = -1
	)
	subclass_spellpoints = 15
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/desert_rider_almah/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("阿尔玛是同时精于魔法与剑术的人，却又在任何一门上都谈不上登峰造极。"))
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/repulse)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/airblade)
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/zyb
	neck = /obj/item/clothing/neck/roguetown/gorget/copper
	mask = /obj/item/clothing/mask/rogue/facemask/copper
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/zyb
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
	gloves = /obj/item/clothing/gloves/roguetown/angle
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/zyb
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/clothing/neck/roguetown/shalal
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife/idagger/navaja,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/spellbook_unfinished/pre_arcyne,
		/obj/item/flashlight/flare/torch,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)

	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal
	beltl = /obj/item/rogueweapon/scabbard/sword
	l_hand = /obj/item/rogueweapon/sword/sabre/shamshir

	H.merctype = 4



