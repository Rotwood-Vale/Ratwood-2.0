/datum/advclass/mercenary/warscholar
	name = "纳莱迪 大司教"
	tutorial ="你是一名 纳莱迪 大司教，曾随隐修贤者研习法道，通晓各类奥术。你更擅长留在后阵，强化同伴并扰乱敌人。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/warscholar
	subclass_languages = list(/datum/language/celestial)
	class_select_category = CLASS_CAT_NALEDI
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/warscholar.ogg'
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_CON = -1
	)
	subclass_spellpoints = 15
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/warscholar
	var/detailcolor
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/mercenary/warscholar/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/naledicolors = sortList(list(
		"金色" = "#C8BE6D",
		"淡紫色" = "#9E93FF",
		"蓝色" = "#A7B4F6",
		"砖褐色" = "#773626",
		"紫色" = "#B542AC",
		"绿色" = "#62a85f",
		"浅蓝色" = "#A9BFE0",
		"红色" = "#ED6762",
		"橙色" = "#EDAF6D",
		"粉色" = "#EDC1D5",
		"栗色" = "#5F1F34",
		"黑色" = "#242526"
	))
	to_chat(H, span_warning("你是一名 纳莱迪 大司教，曾随隐修贤者研习法道，通晓各类奥术。你更擅长留在后阵，强化同伴并扰乱敌人。"))
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 5, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
		H.mind?.adjust_spellpoints(6)
	if(H.mind)
		detailcolor = input("选择一种颜色。", "纳莱迪 配色") as anything in naledicolors
		detailcolor = naledicolors[detailcolor]
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/giants_strength)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/longstrider)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/guidance)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/haste)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fortitude)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/forcewall/greater)
	r_hand = /obj/item/rogueweapon/woodstaff/naledi


	head = /obj/item/clothing/head/roguetown/roguehood/hierophant
	cloak = /obj/item/clothing/cloak/hierophant
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	pants = /obj/item/clothing/under/roguetown/trou/leather
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi
	wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.merctype = 14

/datum/advclass/mercenary/warscholar/pontifex
	name = "纳莱迪·教长"
	tutorial = "你是一名纳莱迪教长，修习的是控场法术与徒手搏杀相融合的独门战技。你的魔法造诣虽不及专职法师，但论及正面搏杀，却比大多数施法者更为致命。你将冷静与技艺凝练为纯粹的杀意，使其化作一柄奥术之刃，仿若普赛顿神剑碎片的回响。"
	outfit = /datum/outfit/job/roguetown/mercenary/warscholar_pontifex
	subclass_languages = list(/datum/language/celestial)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_CIVILIZEDBARBARIAN, TRAIT_ARCYNE_T1)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
		STATKEY_PER = -1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_spellpoints = 4 // Override inheritance

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex
	var/detailcolor
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/naledicolors = sortList(list(
		"金色" = "#C8BE6D",
		"淡紫色" = "#9E93FF",
		"蓝色" = "#A7B4F6",
		"砖褐色" = "#773626",
		"紫色" = "#B542AC",
		"绿色" = "#62a85f",
		"浅蓝色" = "#A9BFE0",
		"红色" = "#ED6762",
		"橙色" = "#EDAF6D",
		"粉色" = "#EDC1D5",
		"栗色" = "#5F1F34",
		"黑色" = "#242526"
	))
	to_chat(H, span_warning("你是一名 纳莱迪 教长，接受过将控场法术与徒手搏杀结合的复合式训练。虽说你在纯魔法领域不算出众，但正面厮杀时却比大多数法师更为致命。你将冷静而娴熟的技艺凝为杀意，使其化作一柄奥术之刃。"))
	if(H.mind)
		detailcolor = input("选择一种颜色。", "纳莱迪 配色") as anything in naledicolors
		detailcolor = naledicolors[detailcolor]
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/bladeofpsydon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadowstep)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)
		H.mind.AddSpell(new/obj/effect/proc_holder/spell/invoked/projectile/repel)
	if(H.mind)
		var/weapons = list("Path of War","Path of Control","Path of Shadows","Path of Survival")
		var/weapon_choice = input(H, "Choose your path.", "WHAT PATH DO YOU WALK?") as anything in weapons
		switch(weapon_choice)
			if("Path of War")//Weak combat stuff only
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/airblade)//longer CD than arcane bolt but more versatile
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
			if("Path of Control")//Battlefield control, minimal damage dealing
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/ensnare)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/forcewall/greater)
			if("Path of Shadows")//Sneaky trickster punchmage
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/lesserknock)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/invisibility)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/blindness/warscholar)
			if("Path of Survival")//Trade magic for skills
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, 3, TRUE)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)//as a bodyguard it can be REALLY important to find where the bleed is.

	head = /obj/item/clothing/head/roguetown/roguehood/pontifex
	gloves = /obj/item/clothing/gloves/roguetown/angle/pontifex
	head = /obj/item/clothing/head/roguetown/roguehood/pontifex
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/pointfex
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi
	wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/lockpick = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.merctype = 14

/datum/advclass/mercenary/warscholar/vizier
	name = "纳莱迪 维齐尔"
	tutorial = "你是一名 纳莱迪 维齐尔。你对神迹与圣咒的研究将你引向了隐秘的秘法。尽管 普赛顿 的信徒长期难以引动那位众父的神性，但借由圣者之力的拼合，或许也能抵达近似的境地。"
	outfit = /datum/outfit/job/roguetown/mercenary/warscholar_vizier
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
	)
	subclass_spellpoints = 9

/datum/outfit/job/roguetown/mercenary/warscholar_vizier
	var/detailcolor
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/mercenary/warscholar_vizier/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/naledicolors = sortList(list(
		"金色" = "#C8BE6D",
		"淡紫色" = "#9E93FF",
		"蓝色" = "#A7B4F6",
		"砖褐色" = "#773626",
		"紫色" = "#B542AC",
		"绿色" = "#62a85f",
		"浅蓝色" = "#A9BFE0",
		"红色" = "#ED6762",
		"橙色" = "#EDAF6D",
		"粉色" = "#EDC1D5",
		"栗色" = "#5F1F34",
		"黑色" = "#242526"
	))
	to_chat(H, span_warning("你是一名 纳莱迪 维齐尔。你对神迹与圣咒的研究将你引向了隐秘的秘法。尽管 普赛顿 的信徒长期难以引动那位众父的神性，但借由圣者之力的拼合，或许也能抵达近似的境地。"))
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 3, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
		H.mind?.adjust_spellpoints(3)
	r_hand = /obj/item/rogueweapon/woodstaff/naledi
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant

	mask = /obj/item/clothing/mask/rogue/lordmask/naledi
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backr = /obj/item/storage/backpack/rogue/satchel/black
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/black
	cloak = /obj/item/clothing/cloak/half
	wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord

	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/surgery_bag = 1
		)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
	if(H.mind)
		detailcolor = input("选择一种颜色。", "纳莱迪 配色") as anything in naledicolors
		detailcolor = naledicolors[detailcolor]
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/lesser_heal)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/arcynebolt) // because other clerics get holy bolt and so you're not entirely pressured to take combat spells
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/guidance)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/regression)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convergence)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stasis)

	H.merctype = 14



/datum/outfit/job/roguetown/mercenary/warscholar/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	for(var/obj/item/clothing/V in H.get_equipped_items(FALSE))
		if(V.naledicolor)
			V.color = detailcolor
			V.update_icon()
	H.regenerate_icons()
