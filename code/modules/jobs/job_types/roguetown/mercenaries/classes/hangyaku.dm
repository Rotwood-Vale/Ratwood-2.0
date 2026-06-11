/datum/advclass/mercenary/hangyaku
	name = "叛逆公卿"
	tutorial = "叛徒。亡命徒。失败者。昔日的你在 风郡 上层社会中并不只是个“武士”，你曾是冠军、德行的旗帜，是一段传奇的雏形。如今你流落遥远的 普赛多尼亚，寻求新的开始……至少，也得先弄到新的钱财。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT //do they have constructs in kazengun?
	outfit = /datum/outfit/job/roguetown/mercenary/hangyaku
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_NOBLE) //i hate nobles but it's thematic
	cmode_music = 'sound/music/combat_Kazengun_Firestorm.ogg'
	maximum_possible_slots = 3
	subclass_stats = list(  // mounted knight, but slower.
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
		STATKEY_SPD = -1
	)
	subclass_skills = list( //impressively limited in terms of what they can do. this is a wall that doesn't do much else.
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN, //doesn't do much, but they're meant to be noblemen.
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)
	extra_context = "该分支禁止构装体选择。"

/datum/outfit/job/roguetown/mercenary/hangyaku/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	to_chat(H, span_warning("叛徒。亡命徒。失败者。昔日的你在 风郡 上层社会中并不只是个“武士”，你曾是冠军、德行的旗帜，是一段传奇的雏形。如今你流落遥远的 普赛多尼亚，寻求新的开始……至少，也得先弄到新的钱财。"))
	head = /obj/item/clothing/head/roguetown/helmet/heavy/kabuto
	belt = /obj/item/storage/belt/rogue/leather/cloth
	neck = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun
	cloak = /obj/item/clothing/cloak/kazengun
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/kote
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/scabbard/sheath/kazengun
		)
	H.merctype = 9

/datum/outfit/job/roguetown/mercenary/hangyaku/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("刀剑","巨型权杖","长枪","弓")
	var/weapon_choice = input(H, "选择你的武器。", "当钢铁开口之时……") as anything in weapons
	switch(weapon_choice)
		if("刀剑")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/kazengun/noparry, SLOT_BELT_L, TRUE)	
		if("巨型权杖")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/mace/goden/kanabo, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if("长枪")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/spear/naginata, TRUE) 
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if("弓")
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve, TRUE) 
			H.equip_to_slot_or_del(new /obj/item/quiver/arrows, SLOT_BELT_L, TRUE) 
	var/armors = list("重甲","中甲")
	var/armor_choice = input(H, "选择你的护甲。", "……而舌头必须沉默。") as anything in armors
	switch(armor_choice)
		if("重甲")
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa, SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk, SLOT_SHIRT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/chainlegs, SLOT_PANTS, TRUE)
		if("中甲")
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/brigandine/haraate, SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy, SLOT_SHIRT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun, SLOT_PANTS, TRUE)
			H.change_stat(STATKEY_SPD, 1) //+1 speed for taking the worse armor, which is identical to mounted knight, but with worse armor
	var/masks = list("全覆面","半覆面")
	var/mask_choice = input(H, "选择你的面具。", "向太阳致意？") as anything in masks
	switch(mask_choice)
		if("全覆面")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun/full, SLOT_WEAR_MASK, TRUE)
		if("半覆面")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun, SLOT_WEAR_MASK, TRUE)

/datum/advclass/mercenary/chonin
	name = "叛逆町人"
	tutorial = "你曾是农夫、矿工、裁缝，或只是个平民。如今刀剑成了你的犁，战场成了你的田。你把镰刀锻成长枪，把短刀重铸为兵刃。门外，你的大名正在召唤，而命运正等着你。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL //do they have constructs in kazengun?
	outfit = /datum/outfit/job/roguetown/mercenary/chonin
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_DECEIVING_MEEKNESS, TRAIT_MEDIUMARMOR) //peasant levy turned mercenary. the underdog.
	cmode_music = 'sound/music/combat_kazengite.ogg'
	subclass_stats = list(  
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list( 
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE, 
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN
	)

/datum/outfit/job/roguetown/mercenary/chonin/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	to_chat(H, span_warning("你曾是农夫、矿工、裁缝，或只是个平民。如今刀剑成了你的犁，战场成了你的田。你把镰刀锻成长枪，把短刀重铸为兵刃。门外，你的大名正在召唤，而命运正等着你。"))
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun
	head = /obj/item/clothing/head/roguetown/helmet/kettle/jingasa
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/haraate
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/plate/kote
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		)
	H.merctype = 9

/datum/outfit/job/roguetown/mercenary/chonin/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/trades = list("城镇医师","农夫","裁缝","工匠劳工","商人","征召兵") //JMAN COMBAT SKILLS... AND TOWNER TRADES. GOD I HOPE THIS ISN'T A TERRIBLE IDEA.
	var/trade_choice = input(H, "选择你从前的行当。", "你是谁？") as anything in trades
	switch(trade_choice)
		if("城镇医师") //alchemy and medicine. that's pretty strong as-is, so...
			ADD_TRAIT(H, TRAIT_MEDICINE_EXPERT, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_APPRENTICE, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/woodstaff/militia, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if("农夫") //farming, cooking, butchery, fishing
			ADD_TRAIT(H, TRAIT_SURVIVAL_EXPERT, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/spear/militia, TRUE)
		if("裁缝") // sewing/etc.
			ADD_TRAIT(H, TRAIT_SEWING_EXPERT, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/falchion/militia, TRUE)
		if("工匠劳工") //physical labor; smelting, pottery, mining. you'll have to get the smithing yourself.
			ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/pick/militia/steel, TRUE)
		if("商人") //the sneaky one.
			ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/rogue/pouch/coins/mid, SLOT_BELT_L, TRUE) 
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath/kazengun, SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun, TRUE)
		if("征召兵") //straight-up fighter. gets a naginata AND a tanto.
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/spear/naginata, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath/kazengun, SLOT_BELT_R, TRUE)
