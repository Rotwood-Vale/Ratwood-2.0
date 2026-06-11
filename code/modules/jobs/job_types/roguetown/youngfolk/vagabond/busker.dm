/datum/advclass/vagabond_busker
	name = "街头艺人"
	examine_name = "乞丐"
	tutorial = "你几乎失去了一切, 除了手里的乐器，还有勉强够用的演奏本事。也许一支欢快小调就能给你招来几枚钱币，不管是出于怜悯的打赏，还是让人分神得足够久，好让你顺走他们的钱袋。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/busker
	category_tags = list(CTAG_VAGABOND)
	traits_applied = list(TRAIT_EMPATH)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_CON = -2,
		STATKEY_STR = -1,
	)
	subclass_skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN
	)

/datum/outfit/job/roguetown/vagabond/busker/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

	if(prob(33))
		cloak = /obj/item/clothing/cloak/raincloak/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless

	if(prob(10))
		r_hand = /obj/item/rogue/instrument/flute

	var/weapons = list("手风琴","风笛", "班卓琴","鼓","长笛","吉他","口琴","竖琴","手摇琴","口簧琴","鲁特琴","圣咏琴","三味线","小号","中提琴","咏声护符")
	var/weapon_choice = input("选择你的乐器。", "拿起家伙") as anything in weapons
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
