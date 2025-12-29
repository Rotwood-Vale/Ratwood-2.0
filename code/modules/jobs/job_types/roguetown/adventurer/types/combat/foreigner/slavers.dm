//Why is this not in the Zybantu file? We'll be expanding this to other groups.
/datum/advclass/foreigner/slaver
	name = "Zybantine Slaver"
	tutorial = "In parts of Psydonia, the practice of slavery is still a common sight. \
	You hail from the Zybantine Empire, where the market of flesh is ancient and unbroken, and your coin is earned in the trade of living souls."
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/slaver
	subclass_languages = list(/datum/language/celestial)
	cmode_music = 'sound/music/combat_desertrider.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
	) // Spawns with a variety of jman skills and fairly good medium armor.

/datum/outfit/job/roguetown/adventurer/slaver/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("In parts of Psydonia, the practice of slavery is still a common sight. \
	You hail from the Zybantine Empire, where the market of flesh is ancient and unbroken, and your coin is earned in the trade of living souls."))
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/purple
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/purple
	belt = /obj/item/storage/belt/rogue/leather/shalal/purple
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	cloak = /obj/item/clothing/cloak/cape/purple
	backr = /obj/item/rogueweapon/shield/heater
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/sword/long/shotel
	backpack_contents = list(/obj/item/rope/chain = 2,
							/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
							/obj/item/recipe_book/survival = 1,
							/obj/item/rogueweapon/huntingknife = 1)


/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian
	name = "shawl"
	desc = "Thick and protective while remaining light and breezy; the perfect garb for protecting one from the hot sun and the harsh sands of Naledi."
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black
	color = CLOTHING_BLACK

/obj/item/storage/belt/rogue/leather/shalal/purple
	color = CLOTHING_PURPLE
