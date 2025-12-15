#define CTAG_CRUSADE "CTAG_CRUSADE"

/datum/migrant_role/crusader
	name = "117th Crusade-er"
	advclass_cat_rolls = list(CTAG_CRUSADE = 20)

/datum/advclass/crusader_footman
	name = "Crusader"
	tutorial = "Crusader of the true faith, you came from Grenzelhoft on the orders of the holy see. FIND Psydon's holy chalice- and pillage your way into riches, for the glory of astrata!"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/crusader
	traits_applied = list(TRAIT_NOBLE, TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_CRUSADE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
	)
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled

/datum/outfit/job/roguetown/crusader/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/divine/astrata)))	//astratan crusade
		to_chat(H, span_warning("Astrata, the Absolute Order of the lands embraces me; We shall take what is rightfully ours, For she wills it."))
		H.set_patron(/datum/patron/divine/astrata)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/crusader
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/cape/crusader
	backr = /obj/item/rogueweapon/shield/tower/metal
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/decorated
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	armor = /obj/item/clothing/cloak/tabard/crusader/astrata
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
						/obj/item/flashlight/flare/torch = 1,
						)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.

/obj/item/reagent_containers/glass/cup/golden/psydon
	name = "Psydon's Chalice"
	icon_state = "psydon_golden"
	sellprice = 200
	desc = "A glimmering chalice made from silver and gold, it has an inlade gem unlike any other. It was said to be once psydon's very own chalice."
#undef CTAG_CRUSADE