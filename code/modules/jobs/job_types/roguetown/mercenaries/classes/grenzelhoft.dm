/datum/advclass/mercenary/grenzelhoft
	name = "双饷佣兵"
	tutorial = "你是一名 双饷佣兵，也就是所谓的“双饷佣兵”，是由 天顶城 剑术行会训练出的资深前线剑士。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/grenzelhoft
	class_select_category = CLASS_CAT_GRENZELHOFT
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_grenzelhoft.ogg'
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 2, //Should give minimum required stats to use Zweihander
		STATKEY_PER = 1,
		STATKEY_SPD = -1 //They get heavy armor now + sword option; so lower speed.
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,	//Won't be using normally with Zwiehander but useful.
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,		//Trust me, they'll need it due to stamina drain on their base-sword.
	)

/datum/outfit/job/roguetown/mercenary/grenzelhoft/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名 双饷佣兵，也就是所谓的“双饷佣兵”，是由 天顶城 剑术行会训练出的资深前线剑士。"))
	armor = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_half_plate
	if(H.mind)
		var/weapons = list("双手巨剑", "战刀与小圆盾")
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		switch(weapon_choice)
			if("双手巨剑")
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/greatsword/grenz
			if("战刀与小圆盾") // Buckler cuz they have no shield skill.
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser
				backl = /obj/item/rogueweapon/shield/buckler
	//General gear regardless of class.
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.merctype = 7

/datum/advclass/mercenary/grenzelhoft/halberdier
	name = "戟兵"
	tutorial = "你是身经百战的老兵，擅使长柄武器与战斧。像你这样的人构成了佣兵行会武装的中坚。"
	outfit = /datum/outfit/job/roguetown/mercenary/grenzelhoft_halberdier
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_STR = 2,//same str, worse end, more speed - actually a good tradeoff, now.
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_PER = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,//Now you actually get your fabled axe skill
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,		// Foot soldier that carries the Big Fuckin Polearm around. Also polearm stam drain from the fact they gon' be catching swings all day.
	)

/datum/outfit/job/roguetown/mercenary/grenzelhoft_halberdier/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是身经百战的老兵，擅使长柄武器与战斧。像你这样的人构成了佣兵行会武装的中坚。"))
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	armor = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_half_plate
	if(H.mind)
		var/weapons = list("戟斧", "战戟", "鹰喙锤")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		switch(weapon_choice)
			if("戟斧")
				r_hand = /obj/item/rogueweapon/halberd
			if("战戟")
				r_hand = /obj/item/rogueweapon/spear/partizan
			if("鹰喙锤")
				r_hand = /obj/item/rogueweapon/eaglebeak
	//General gear regardless of class.
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.merctype = 7

//crossbow and axe class. Rearguard. Utility skills, no medium armor, no dodge expert. This is NOT a go-face-first-into-war class.
/datum/advclass/mercenary/grenzelhoft/crossbowman
	name = "弩手"
	tutorial = "你是一名久经证明的十字弩射手，也学会了如何在荒野中扎营并布设防线。行会需要你这样的人。"
	outfit = /datum/outfit/job/roguetown/mercenary/grenzelhoft_crossbowman
	traits_applied = list( TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_STR = 1,// 1 STR for the axe and crossbow reload. END for chopping trees, a bit of SPD for running, PER for shooting. -1 CON bc you aint a frontliner
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,		// gotta get to a vantage point
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,		// this is not only a tool!
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,		//every combat class with a ranged weapon gets this . eat my jorts. They have no dodge expert.
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,  // as a treat? so they can go pick one up bc axes are dookie?
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT, 	// >camps and makes defenses in the wild >doesnt know how to track
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,		// Make your ene- no. The adventurer has better athletics, you're a trained mercenary.
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,		// meant to live off the land and set up camp.
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,		// learn 2 maintain your uniform.
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,		// Just so you don't suck at cooking
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,	// crafting for pallisades, lumberjacking for not fucking up wood
	)

/datum/outfit/job/roguetown/mercenary/grenzelhoft_crossbowman/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名久经证明的十字弩射手，也学会了如何在荒野中扎营并布设防线。行会需要你这样的人。"))
	beltr = /obj/item/quiver/bolts
	beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel
	r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	if(H.mind)
		var/armor_options = list("轻型布面甲", "铆钉皮背心")
		var/armor_choice = input(H, "选择你的护甲。", "整备着装") as anything in armor_options
		switch(armor_choice)
			if("轻型布面甲")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light	// find a smithy to fix it
			if("铆钉皮背心")
				armor = /obj/item/clothing/suit/roguetown/armor/leather/studded		// or maintain it yourself!
	//General gear regardless of class.
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.merctype = 7

/datum/advclass/mercenary/grenzelhoft/mage
	name = "战阵学者"
	tutorial = "你是一名 战阵学者，也就是“战阵学者”，是出身 天穹魔导学院 的骄傲法师，其在攻城魔法与奥术力学上的造诣无可匹敌。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/grenzelhoft_mage
	class_select_category = CLASS_CAT_GRENZELHOFT
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_grenzelhoft.ogg'
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_INTELLECTUAL, TRAIT_STEELHEARTED, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = -1,
		STATKEY_PER = 3,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/grenzelhoft_mage/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名 战阵学者，也就是“战阵学者”，是出身 天穹魔导学院 的骄傲法师，其在攻城魔法与奥术力学上的造诣无可匹敌。"))
	belt = /obj/item/storage/belt/rogue/leather/battleskirt
	backl = /obj/item/rogueweapon/woodstaff/emerald/blacksteelstaff
	cloak = /obj/item/clothing/cloak/stabard/grenzelmage
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	//General gear regardless of class.
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	neck = /obj/item/clothing/neck/roguetown/gorget
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.mind) // State mandated spells c:
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball/artillery)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/spitfire)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/arcynebolt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/magicians_brick)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/repulse)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/conjure_armor)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/message)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/counterspell)
		H.mind?.adjust_spellpoints(3)
	if(H.age == AGE_OLD) // FEAR the old man in a profession where men die young, or something corny like that.
		H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 5, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_CON, -2)
		H.change_stat(STATKEY_PER, 2)
		H.change_stat(STATKEY_INT, 2)
		H.mind?.adjust_spellpoints(3)
		ADD_TRAIT(H, TRAIT_ARCYNE_T3, TRAIT_GENERIC)
	else
		ADD_TRAIT(H, TRAIT_ARCYNE_T2, TRAIT_GENERIC) // Only T2 arcyne (Unless they're old) so if they get spell points from something they can only pick from the curated spellblade list
	H.merctype = 7
