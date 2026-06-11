/datum/advclass/rogue
	name = "寻宝客"
	tutorial = "你是一名受过专业训练的寻宝客，专擅发掘值钱之物。识得何物才是真正的宝藏，因为你的财运可能藏在任何角落。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/rogue
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_SEEPRICES, TRAIT_GRAVEROBBER)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	class_select_category = CLASS_CAT_ROGUE
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/rogue/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名受过专业训练的寻宝客，专擅发掘值钱之物。识得何物才是真正的宝藏，因为你的财运可能藏在任何角落。"))
	pants = /obj/item/clothing/under/roguetown/trou/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	backr = /obj/item/rogueweapon/shovel
	head = /obj/item/clothing/head/roguetown/fedora
	beltl = /obj/item/flashlight/flare/torch/lantern
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backpack_contents = list(
		/obj/item/lockpick = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.mind)
		var/weapons = list("军刀","鞭")
		var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("军刀")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/sword/sabre
				r_hand = /obj/item/rogueweapon/scabbard/sword
			if("鞭")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/whip

/datum/advclass/rogue/thief
	name = "盗贼"
	tutorial = "你是个无赖，也是个窃贼。最擅长潜入那些你本不该进去的地方，再把原本不属于你的东西据为己有。"
	outfit = /datum/outfit/job/roguetown/adventurer/thief
	subclass_languages = list(/datum/language/thievescant)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/thief/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是个无赖，也是个窃贼。最擅长潜入那些你本不该进去的地方，再把原本不属于你的东西据为己有。"))
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	beltl = /obj/item/quiver/Warrows
	beltr = /obj/item/rogueweapon/mace/cudgel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

/datum/advclass/rogue/bard
	name = "吟游诗人"
	tutorial = "你在妓院、下榻客店与酒馆间讨生活，靠歌谣与传奇博得名声。至于那些故事里究竟有几分真，那就难说了。"
	outfit = /datum/outfit/job/roguetown/adventurer/bard
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_GOODLOVER, TRAIT_EMPATH)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/bard/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你在妓院、下榻客店与酒馆间讨生活，靠歌谣与传奇博得名声。至于那些故事里究竟有几分真，那就难说了。"))
	head = /obj/item/clothing/head/roguetown/bardhat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	backl = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/half/red
	backpack_contents = list(
		/obj/item/lockpick = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T3)
	if(H.mind)
		var/weapons = list("手风琴","风笛", "班卓琴","鼓","长笛","吉他","口琴","竖琴","手摇风琴","口簧琴","鲁特琴","诗琴","三味线","小号","中提琴","歌声护符")
		var/weapon_choice = tgui_input_list(H, "选择你的乐器。", "执起乐器", weapons)
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

/datum/advclass/rogue/swashbuckler
	name = "海上浪客"
	tutorial = "你是纵横海上的大胆浪客！海上浪客以灵巧剑技与腾挪身法见长，出手下作却潇洒非常，总能漂亮地把敌人玩弄于股掌之间。"
	outfit = /datum/outfit/job/roguetown/adventurer/swashbuckler
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_NUTCRACKER, TRAIT_DECEIVING_MEEKNESS)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/swashbuckler/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是纵横海上的大胆浪客！海上浪客以灵巧剑技与腾挪身法见长，出手下作却潇洒非常，总能漂亮地把敌人玩弄于股掌之间。"))
	head = /obj/item/clothing/head/roguetown/helmet/tricorn
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogue/instrument/hurdygurdy
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/sword/cutlass
	backpack_contents = list(
		/obj/item/bomb = 1,
		/obj/item/lockpick = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
