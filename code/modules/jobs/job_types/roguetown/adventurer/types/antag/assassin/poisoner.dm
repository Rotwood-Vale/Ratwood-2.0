/datum/advclass/assassin_poisoner
	name = "刺客 - 毒师"
	tutorial = "你大半辈子都在和毒药打交道，无论是天然之毒，还是人造之物。你既会调配解药，也能炮制致命混毒。你甚至能以医者身份混入贵族宫廷之中，把真正的意图深藏不露……"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/assassin/poisoner
	category_tags = list(CTAG_ASSASSIN)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_NOSTINK)	// Stinky Man - You get tossed a bone around rotting corpses. Plays into the poison and stuff.
	// Weighted 14
	subclass_stats = list(
		STATKEY_PER = 1,
		STATKEY_SPD = 3,
		STATKEY_STR = 1,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,		// May be silly but - hey, they can pose as a doctor-type.
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,		// For grappling
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_MASTER,		// Zoo-wee mama; annoying stabber. Still shit at parrying I guess though.
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,		// Gets some bow skill just for anything pioson I guess. (Still gotta get it themselves)
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_MASTER,		// Lets them crasft most poisons.
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/assassin/poisoner/pre_equip(mob/living/carbon/human/H)
	..()
	cloak = /obj/item/clothing/cloak/cotehardie
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/flashlight/flare/torch/lantern/prelit = 1,
					/obj/item/lockpickring/mundane = 1,
					/obj/item/rogueweapon/huntingknife/idagger/steel/corroded = 1,		//This is basically their primary weapon so they don't get loadouts.
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
					/obj/item/reagent_containers/glass/bottle/rogue/stampoison = 1,
					/obj/item/recipe_book/alchemy = 1,
					)
	mask = /obj/item/clothing/mask/rogue/physician
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	head = /obj/item/clothing/head/roguetown/physician
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded

	if(!istype(H.patron, /datum/patron/inhumen/graggar))
		var/inputty = input(H, "你要将自己的信仰改为 格拉加 吗？", "兽吼回荡", "否") as anything in list("是", "否")
		if(inputty == "是")
			to_chat(H, span_warning("我先前侍奉的神明已弃我而去……如今，格拉加 才是我的新主人。"))
			H.set_patron(/datum/patron/inhumen/graggar)
