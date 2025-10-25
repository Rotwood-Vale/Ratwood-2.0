/datum/advclass/mercenary/forlorn
	name = "Forlorn Hope Mercenary"
	tutorial = "The Order of the Forlorn Hope, a holy order founded in the name of Noc and the banishment of the rot. Now it is riddled with the wounded, the veterans and the landless of the Vakran civil war. Take up the banner and fight again in the name of the Ten, or use the pretense of faith and zealotry to make ends meet by any means necessary."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/lupian,
		/datum/species/anthromorph,
		/datum/species/vulpkanin
	)
	outfit = /datum/outfit/job/roguetown/mercenary/forlorn
	class_select_category = CLASS_CAT_RANESHENI
	min_pq = 2
	cmode_music = 'sound/music/combat_blackstar.ogg'
	category_tags = list(CTAG_MERCENARY)
	// tuff boys
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_CON = 2
	)

/datum/outfit/job/roguetown/mercenary/forlorn/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	neck = /obj/item/clothing/neck/roguetown/gorget/forlorncollar
	head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate
	pants = /obj/item/clothing/under/roguetown/splintlegs		// They're brigandinejaks. ergo have them start w/the whole thing
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/splintarms		// They're brigandinejaks. ergo have them start w/the whole thing
	belt = /obj/item/storage/belt/rogue/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/mace/warhammer/steel
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/shield/heater
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife,
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/scabbard/sheath
	)

	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.merctype = 5
