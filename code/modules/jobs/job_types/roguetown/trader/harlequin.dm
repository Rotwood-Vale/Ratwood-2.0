/datum/advclass/trader/harlequin
	name = "丑角"
	tutorial = "你是四处流转的表演者，以扮演丑角为生。无论你走到哪里，混乱都会跟到哪里，闹剧也总会随之上演。"
	outfit = /datum/outfit/job/roguetown/adventurer/harlequin
	cmode_music = 'sound/music/combat_jester.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_NUTCRACKER, TRAIT_HOMESTEAD_EXPERT)
	class_select_category = CLASS_CAT_TRADER
	category_tags = list(CTAG_PILGRIM, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/harlequin/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning ("你是四处流转的表演者，以扮演丑角为生。无论你走到哪里，混乱都会跟到哪里，闹剧也总会随之上演。"))
	shoes = /obj/item/clothing/shoes/roguetown/jester
	pants = /obj/item/clothing/under/roguetown/tights
	armor = /obj/item/clothing/suit/roguetown/shirt/jester
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/huntingknife/idagger
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/jester
	mask = /obj/item/clothing/mask/rogue/xylixmask
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	backpack_contents = list(
		/obj/item/bomb/smoke = 3,
		/obj/item/storage/pill_bottle/dice = 1,
		/obj/item/toy/cards/deck = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
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
