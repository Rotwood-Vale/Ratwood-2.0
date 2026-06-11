// WOE: SPELLBLADE DODGE EXPERT POLEARM BUILD UPON YE.
/datum/advclass/wretch/blackoakwyrm
	name = "黑橡 弃徒"
	tutorial = "你怀抱着连 黑橡 都无法容忍的极端信念，于是决定背离这个团体，也背离所有其他人。这片土地曾经伟大……而如今，一波又一波的怪物与外来者正践踏着你的家园。最初在这片土地上定居的是你们的族人，可那个受外邦支持、虚伪又傲慢的王冠却拒绝给予你们应得的报偿！你在 黑橡 中接受过广泛训练，精通长柄武器与魔法。王冠的悬赏一路跟随着你，因为你早已做下足够多的事，正式被那些受金钱诱惑、对大业不够忠诚的人判为有罪。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/human/halfelf,
		/datum/species/elf/wood,
		/datum/species/elf/dark,
	)
	outfit = /datum/outfit/job/roguetown/wretch/blackoak
	cmode_music = 'sound/music/combat_blackoak.ogg'
	class_select_category = CLASS_CAT_RACIAL
	maximum_possible_slots = 1
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_RACISMISBAD, TRAIT_DODGEEXPERT, TRAIT_ARCYNE_T2)
	//lower-than-avg stats for wretch but their traits are insanely good
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_CON = -1
	)
	subclass_spellpoints = 10
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "该子职业的种族限制为：半精灵、精灵、黑暗精灵。"

/datum/outfit/job/roguetown/wretch/blackoak/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(-3)
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	pants = /obj/item/clothing/under/roguetown/trou/leather
	head = /obj/item/clothing/head/roguetown/helmet/sallet/elven
	armor = /obj/item/clothing/suit/roguetown/armor/leather/trophyfur
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	beltr = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/halberd/glaive
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
				/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1,
				/obj/item/flashlight/flare/torch
				)

	if(H.mind)
		wretch_select_bounty(H)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mockery)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/conjure_weapon)

		var/weapons = list("精灵剑矛与长剑","精灵弯刃大剑与短剑",)
		var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("精灵剑矛与长剑")
				r_hand = /obj/item/rogueweapon/spear/naginata/elf
				l_hand = /obj/item/rogueweapon/sword/long/elf
			if("精灵弯刃大剑与短剑")
				r_hand = /obj/item/rogueweapon/greatsword/elf
				l_hand = /obj/item/rogueweapon/sword/short/elf

