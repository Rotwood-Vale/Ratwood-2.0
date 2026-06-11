/datum/advclass/foreigner/refugee
	name = "纳莱迪 难民"
	tutorial = "你是来自战火摧残之地 纳莱迪 荒漠的避难者。故土仍在与 灯灵 的无尽战火中被反复蹂躏，于是你一路被逼向北方。"
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/refugee
	subclass_languages = list(/datum/language/celestial)
	cmode_music = 'sound/music/warscholar.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/adventurer/refugee/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是来自战火摧残之地 纳莱迪 荒漠的避难者，\
	故土仍在与 Djinn 的无尽战火中被反复蹂躏，于是你一路被逼向北方。"))
	mask = /obj/item/clothing/mask/rogue/lordmask/tarnished
	r_hand = /obj/item/rogueweapon/spear/assegai
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian
	pants = /obj/item/clothing/under/roguetown/skirt/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(/obj/item/rogueweapon/huntingknife = 1)
