/datum/advclass/mercenary/vaquero
	name = "瓦克罗"
	tutorial = "“牧侠”一词最早源于繁盛的 伊特鲁斯卡 王国，本只是赶牛人的称呼……但如今，它已成了四处游走的浪客豪侠之名。无论他们是以庇护平民为志，还是靠割人钱袋过活，牧侠 的价值都由他们横跨大陆刻下的传闻来定义，当然，更常见的则是由一场暴烈的横死为故事收尾。"
	outfit = /datum/outfit/job/roguetown/mercenary/vaquero
	class_select_category = CLASS_CAT_ETRUSCA
	cmode_music = 'sound/music/combat_vaquero.ogg'
	category_tags = list(CTAG_MERCENARY)
	subclass_languages = list(/datum/language/etruscan)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_DECEIVING_MEEKNESS, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_INT = 2,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
	)

	extra_context = "This class is restricted from using the Equestrian virtue."

	virtue_restrictions = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/mercenary/vaquero/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/bardhat
	mouth = /obj/item/alch/rosa
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/clothing/neck/roguetown/gorget
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	belt = /obj/item/storage/belt/rogue/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	cloak = /obj/item/clothing/cloak/half/rider/red
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/scabbard/sword
	l_hand = /obj/item/rogueweapon/sword/rapier/vaquero
	beltr = /obj/item/rogueweapon/scabbard/sheath
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero
	backpack_contents = list(
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
					/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
					/obj/item/lockpick = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/roguekey/mercenary = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1
					)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T1)
	if(H.mind)
		var/weapons = list("手风琴","风笛", "班卓琴","鼓","长笛","吉他","口琴","竖琴","手摇琴","口簧琴","鲁特琴","圣咏琴","三味线","小号","中提琴","咏声护符")
		var/weapon_choice = input(H, "选择你的乐器。", "拿起家伙") as anything in weapons
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
			if("手摇琴")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("口簧琴")
				backr = /obj/item/rogue/instrument/jawharp
			if("鲁特琴")
				backr = /obj/item/rogue/instrument/lute
			if("圣咏琴")
				backr = /obj/item/rogue/instrument/psyaltery
			if("三味线")
				backr = /obj/item/rogue/instrument/shamisen
			if("小号")
				backr = /obj/item/rogue/instrument/trumpet
			if("中提琴")
				backr = /obj/item/rogue/instrument/viola
			if("咏声护符")
				backr = /obj/item/rogue/instrument/vocals
	H.merctype = 13
	
	if (H.mind)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)
