/datum/advclass/hunter
	name = "弓猎人"
	tutorial = "你是一名猎人。你用弓猎杀林地中的野兽，剥下猎物的皮毛，再把剩下的肉烹煮食用。这份工作危险重重，却也是衣物与轻甲流通中不可或缺的一环。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/hunter
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_SURVIVAL_EXPERT)
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	maximum_possible_slots = 20 // Should never fill, for the purpose of players to know what types towners are in round at the menu
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/hunter/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/artipants
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/storage/backpack/rogue/backpack
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/quiver/arrows
	r_hand = /obj/item/storage/meatbag
	backpack_contents = list(
				/obj/item/flint = 1,
				/obj/item/bait = 1,
				/obj/item/rogueweapon/huntingknife = 1,
				/obj/item/flashlight/flare/torch/lantern = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1
				)
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey
		head = /obj/item/clothing/head/roguetown/tagelmust
	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank_up_to(/datum/skill/labor/butchering, 5, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/labor/butchering, 6, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/tanning, 4, TRUE)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/huntersyell)
		var/weapons = list("大砍刀","手斧")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("大砍刀")
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/short/messer/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 2, TRUE)
			if("手斧")
				beltl = /obj/item/rogueweapon/stoneaxe/handaxe
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 2, TRUE)

/datum/advclass/hunter/spear
	name = "矛猎人"
	tutorial = "你是一名猎人。你用武器猎杀林地中的野兽，剥下猎物的皮毛，再把剩下的肉烹煮食用。这份工作危险重重，却也是衣物与轻甲流通中不可或缺的一环。"
	outfit = /datum/outfit/job/roguetown/adventurer/hunter_spear
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_SURVIVAL_EXPERT)
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/hunter_spear/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名专精长矛的猎人，尤其擅长力量与耐力。"))
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	backl = /obj/item/storage/backpack/rogue/backpack
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/meatbag
	beltl = /obj/item/flashlight/flare/torch/lantern
	l_hand = /obj/item/rogueweapon/spear
	backpack_contents = list(
				/obj/item/flint = 1,
				/obj/item/bait = 1,
				/obj/item/rogueweapon/huntingknife = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1,
				/obj/item/rogueweapon/stoneaxe/handaxe
				)
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey
		head = /obj/item/clothing/head/roguetown/tagelmust
	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank_up_to(/datum/skill/labor/butchering, 5, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/labor/butchering, 6, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/tanning, 4, TRUE)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/huntersyell)
	return
