/datum/advclass/hammerhold/tideweaver
	name = "Hammerholdian Tideweaver"
	tutorial = "You are a cleric of the Lord of Abyss, devoted to him in prayer and arcyne. You have minor magical spells and medical knowledge in addition to your miracles."
	outfit = /datum/outfit/job/roguetown/hammerhold/tideweaver
	category_tags = list(CTAG_HAMMERHOLD_TIDEWEAVER)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_STEELHEARTED, TRAIT_OUTLANDER, TRAIT_HAMMERHOLD_WARBAND)
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN, //nothing past journeyman, huscarl and jarl pick their way to expert
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_LEGENDARY, //Flavour, Rockhill doesn't have that much water to swim in.
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
	)

	subclass_languages = list(
		/datum/language/hammerholdian,
	)

/datum/outfit/job/roguetown/hammerhold/tideweaver/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/blue
	neck = /obj/item/clothing/neck/roguetown/leather
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk/blue
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/councillor
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/storage/belt/rogue/surgery_bag/full/improv
	id = /obj/item/clothing/neck/roguetown/psicross/abyssor
	r_hand = /obj/item/rogueweapon/spear/trident
	backpack_contents = list(
		/obj/item/reagent_containers/glass/mortar = 1,
		/obj/item/pestle = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife/bronze = 1
		)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/create_campfire)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/darkvision)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3)	//T4 but capped, same as the missionary. yes this means abyssal infusion now
	C.update_devotion(C.max_devotion / 4 - 50, C.max_devotion / 4 - 50, silent = TRUE) // Start at ~25% of devotion cap

	H.cmode_music = 'sound/music/combat_shaman2.ogg'

	if(!H.has_language(/datum/language/hammerholdian))
		H.grant_language(/datum/language/hammerholdian)
		to_chat(H, span_info("I can speak Hammerholdian with ,h before my speech."))
