/datum/advclass/gronn/slave/noble
	name = "Captured Noble"
	tutorial = "You were born to a hall and a name. Neither means anything out here, except that someone somewhere might pay to have you back."
	outfit = /datum/outfit/job/roguetown/gronn/slave/noble
	category_tags = list(CTAG_GRONN_SLAVE)
	traits_applied = list(TRAIT_GOODLOVER, TRAIT_KEENEARS, TRAIT_NOBLE)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/gronn/slave/noble/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/cursed_collar
	belt = /obj/item/storage/belt/rogue/leather/rope
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	id = /obj/item/clothing/ring/silver
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
	pants = /obj/item/clothing/under/roguetown/tights/black
	cloak = /obj/item/clothing/cloak/raincloak/purple
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch = 1,
		/obj/item/flashlight/flare/torch/lantern = 1
		)

	H.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'

	if(!H.has_language(/datum/language/gronnic))
		H.grant_language(/datum/language/gronnic)
		to_chat(H, span_info("I can speak Gronnic with ,n before my speech."))

	H.set_blindness(0)
