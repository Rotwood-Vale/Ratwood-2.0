/datum/advclass/hammerhold/thrall/craftsman
	name = "Captured Craftsman"
	tutorial = "You kept a forge before the reavers took you. Iron does not care who owns the hammer, and a warband always needs its edges kept."
	outfit = /datum/outfit/job/roguetown/hammerhold/thrall/craftsman
	category_tags = list(CTAG_HAMMERHOLD_THRALL)
	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT)
	subclass_stats = list(
		STATKEY_WIL = 1,
		STATKEY_CON = 1,
		STATKEY_STR = 1,
		STATKEY_INT = 2,
		STATKEY_LCK = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/ceramics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/hammerhold/thrall/craftsman/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/cursed_collar
	belt = /obj/item/storage/belt/rogue/leather
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	beltr = /obj/item/rogueweapon/hammer/iron
	beltl = /obj/item/rogueweapon/tongs
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	mouth = /obj/item/rogueweapon/huntingknife
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/blue
	pants = /obj/item/clothing/under/roguetown/trou
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/scabbard/sheath
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/rogueore/coal = 4,
		/obj/item/rogueore/iron = 5,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/recipe_book/blacksmithing = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/armor_brush = 1,
		/obj/item/polishing_cream = 1
		)

	H.cmode_music = 'sound/music/combat_vagarian.ogg'

	if(!H.has_language(/datum/language/hammerholdian))
		H.grant_language(/datum/language/hammerholdian)
		to_chat(H, span_info("I can speak Hammerholdian with ,h before my speech."))
