/datum/advclass/minstrel
	name = "吟游艺人"
	tutorial = "和那些披着花哨衣裳、跑去树林里舞剑的所谓“诗人”不同，你追随的是真正乐师的道路。你只是……还没找到肯认真听你演奏的观众罢了。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/minstrel
	subclass_social_rank = SOCIAL_RANK_PEASANT
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_EMPATH, TRAIT_GOODLOVER, TRAIT_HOMESTEAD_EXPERT)
	maximum_possible_slots = 20 // Should never fill, for the purpose of players to know what types towners are in round at the menu
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 2
	)
	subclass_skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,//scrappy scoundrelry
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,//town rake!
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,//dancing!
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/minstrel/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/half
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
	r_hand = /obj/item/rogue/instrument/accord
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/cloth
	beltr = /obj/item/rogueweapon/huntingknife/idagger
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/rogue/instrument/lute = 1,
						/obj/item/rogue/instrument/flute = 1,
						/obj/item/rogue/instrument/drum = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1
						)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T3)

	if(SSmapping.current_map.map_name == "Desert Town")
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
	if(H.mind)
		var/weapons = list("手风琴","风笛","鼓","长笛","吉他","竖琴","手摇风琴","口簧琴","鲁特琴","诗琴","三味线","小号","中提琴","歌声护符")
		var/weapon_choice = tgui_input_list(H, "选择你的乐器。", "拿起家伙", weapons)
		H.set_blindness(0)
		switch(weapon_choice)
			if("手风琴")
				backr = /obj/item/rogue/instrument/accord
			if("风笛")
				backr = /obj/item/rogue/instrument/bagpipe
			if("鼓")
				backr = /obj/item/rogue/instrument/drum
			if("长笛")
				backr = /obj/item/rogue/instrument/flute
			if("吉他")
				backr = /obj/item/rogue/instrument/guitar
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
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/misc/music, 6, TRUE)
