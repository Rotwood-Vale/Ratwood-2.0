/datum/advclass/gronn/slave/pitworker
	name = "Captured Pitworker"
	tutorial = "Your whole life was spent underground, following a seam by lanternlight. The tribe has no use for your eyes, only your back and your pick."
	outfit = /datum/outfit/job/roguetown/gronn/slave/pitworker
	category_tags = list(CTAG_GRONN_SLAVE)
	traits_applied = list(TRAIT_SMITHING_EXPERT, TRAIT_DARKVISION)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_LCK = 2,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/labor/mining = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/gronn/slave/pitworker/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/cursed_collar
	belt = /obj/item/storage/belt/rogue/leather/rope
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	backl = /obj/item/storage/backpack/rogue/backpack
	r_hand = /obj/item/rogueweapon/pick
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch = 1,
		/obj/item/flint = 1,
		/obj/item/storage/hip/orestore/bronze = 1,
		/obj/item/rogueweapon/chisel = 1,
		/obj/item/rogueweapon/hammer/wood = 1,
		/obj/item/flashlight/flare/torch/lantern = 1
		)

	H.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'

	if(!H.has_language(/datum/language/gronnic))
		H.grant_language(/datum/language/gronnic)
		to_chat(H, span_info("I can speak Gronnic with ,n before my speech."))

	H.set_blindness(0)
