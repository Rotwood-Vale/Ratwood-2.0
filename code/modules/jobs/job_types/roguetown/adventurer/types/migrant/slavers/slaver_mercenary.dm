// Blade

/datum/advclass/slaver/mercenary/blade
	name = "Zybantynian Blade Mercenary"
	tutorial = "A hired arm for the Zybantine Slave troop. You have come from the deserts of Zybantine and are hired under contract by the Zybantynian Master."
	outfit = /datum/outfit/job/roguetown/slaver/mercenary/blade
	traits_applied = list(TRAIT_XENOPHOBIC, TRAIT_SLEUTH, TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_SLAVER_MERC)

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
	)

	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
	)

	subclass_languages = list(
		/datum/language/celestial
	)

	subclass_stashed_items = list( 
		"Spare Chain" = /obj/item/rope/chain,
		"Bedroll" = /obj/item/bedroll,
		"Handpie (Meat)" = /obj/item/reagent_containers/food/snacks/rogue/handpie/meat,
	) // Gear to allow them to stay in the bog in case they are outlawed.

/datum/outfit/job/roguetown/slaver/mercenary/blade/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_info("I can speak Sama'glos with ,c before my speech."))
	to_chat(H, span_info("I start with a stash of items used for slave catching and survival."))
	head = /obj/item/clothing/head/roguetown/helmet/sallet
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/purple
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full		//no need for two pouches of coin, get SOME neck armor
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather/shalal/purple
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/sword/sabre/shamshir
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/rogueweapon/scabbard/sword
	backpack_contents = list(
		/obj/item/rope/chain = 1, 
		/obj/item/rogueweapon/huntingknife/idagger = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		/obj/item/flashlight/flare/torch/lantern/copper = 1,
		/obj/item/needle = 1,
	)
	H.cmode_music = 'sound/music/combat_zybantine.ogg'

// Whip

/datum/advclass/slaver/mercenary/whip
	name = "Zybantynian Whip Mercenary"
	tutorial = "A hired arm for the Zybantine Slave troop. You have come from the deserts of Zybantine and are hired under contract by the Zybantynian Master."
	outfit = /datum/outfit/job/roguetown/slaver/mercenary/whip
	traits_applied = list(TRAIT_XENOPHOBIC, TRAIT_SLEUTH, TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_SLAVER_MERC)

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
	)

	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,		// for the whip & shield combo
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
	)

	subclass_languages = list(
		/datum/language/celestial
	)

	subclass_stashed_items = list(
		"Spare Chain" = /obj/item/rope/chain,
		"Bedroll" = /obj/item/bedroll,
		"Handpie (Meat)" = /obj/item/reagent_containers/food/snacks/rogue/handpie/meat,
	) // Gear to allow them to stay in the bog in case they are outlawed.

/datum/outfit/job/roguetown/slaver/mercenary/whip/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_info("I can speak Sama'glos with ,c before my speech."))
	to_chat(H, span_info("I start with a stash of items used for slave catching and survival."))
	head = /obj/item/clothing/head/roguetown/helmet/sallet
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/purple
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full		//ditto as blade mercs: some neck armor. No need for so much coin
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather/shalal/purple
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/tower
	beltr = /obj/item/rogueweapon/whip
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	backpack_contents = list(
		/obj/item/rope/chain = 1, 
		/obj/item/rogueweapon/huntingknife/idagger = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		/obj/item/flashlight/flare/torch/lantern/copper = 1,
		/obj/item/needle = 1,
	)
	H.cmode_music = 'sound/music/combat_zybantine.ogg'

// Crossbow

/datum/advclass/slaver/mercenary/crossbow
	name = "Zybantynian Light Crossbow Mercenary"
	tutorial = "A hired arm for the Zybantine Slave troop. You have come from the deserts of Zybantine and are hired under contract by the Zybantynian Master."
	outfit = /datum/outfit/job/roguetown/slaver/mercenary/crossbow
	traits_applied = list(TRAIT_XENOPHOBIC, TRAIT_SLEUTH, TRAIT_DODGEEXPERT, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_SLAVER_MERC)

	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 3,
	)

	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,	//its just draw time. Every other role w/a focus on crossbows gets this. They lose weapon variety in order to be dedicated crossbow and knive users
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
	)

	subclass_languages = list(
		/datum/language/celestial
	)

	subclass_stashed_items = list(
		"Spare Chain" = /obj/item/rope/chain,
		"Bedroll" = /obj/item/bedroll,
		"Handpie (Meat)" = /obj/item/reagent_containers/food/snacks/rogue/handpie/meat,
	) // Gear to allow them to stay in the bog in case they are outlawed.

/datum/outfit/job/roguetown/slaver/mercenary/crossbow/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_info("I can speak Sama'glos with ,c before my speech."))
	to_chat(H, span_info("I start with a stash of items used for slave catching and survival."))
	head = /obj/item/clothing/head/roguetown/helmet/sallet
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/purple
	neck = /obj/item/clothing/neck/roguetown/gorget
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather/shalal/purple
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light	// light armor for the dodgejak
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/quiver/bolts
	backpack_contents = list(
		/obj/item/rope/chain = 1, 
		/obj/item/rogueweapon/huntingknife/idagger = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		/obj/item/flashlight/flare/torch/lantern/copper = 1,
		/obj/item/needle = 1,
	)
	H.cmode_music = 'sound/music/combat_zybantine.ogg'
