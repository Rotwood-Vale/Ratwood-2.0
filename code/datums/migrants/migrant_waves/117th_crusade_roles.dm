#define CTAG_CRUSADE "CTAG_CRUSADE"

/datum/migrant_role/crusader
	name = "117th Crusade-er"
	advclass_cat_rolls = list(CTAG_CRUSADE = 20)

/datum/advclass/crusader_Captain
	name = "Crusader Captain"
	tutorial = "Crusader Leader of the true faith, you came from Grenzelhoft on the orders of the holy see. FIND Psydon's holy chalice- and pillage your way into riches, for the glory of astrata!"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/roguetown/crusader/captain
	traits_applied = list(TRAIT_NOBLE, TRAIT_DECEIVING_MEEKNESS, TRAIT_BREADY, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_CRUSADE)

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 3,
		STATKEY_PER = 2,
		STATKEY_LCK = 3,
	)

	subclass_languages = list(
		/datum/language/grenzelhoftian,
		/datum/language/otavan,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding,
	)

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/crusader/captain/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/divine/astrata)))	//astratan crusade
		to_chat(H, span_warning("Astrata, the Absolute Order of the lands embraces me; We shall take what is rightfully ours, For she wills it."))
		H.set_patron(/datum/patron/divine/astrata)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/crusader
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/cape/crusader
	backr = /obj/item/rogueweapon/shield/tower/metal
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/plate
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	pants = /obj/item/clothing/under/roguetown/platelegs
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/silver
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.

/datum/advclass/crusader_cleric
	name = "Crusader Cleric"
	tutorial = "Crusader of the true faith, you came from Grenzelhoft on the orders of the holy see. FIND Psydon's holy chalice- and pillage your way into riches, for the glory of astrata!"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	maximum_possible_slots = 2
	outfit = /datum/outfit/job/roguetown/crusader/cleric
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_CRUSADE)

	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
	)

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/crusader/cleric/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Astrata, the Absolute Order of the lands embraces me; We shall take what is rightfully ours, For she wills it."))
	head = /obj/item/clothing/head/roguetown/helmet/heavy/crusader
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/cape/crusader
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/storage/belt/rogue/surgery_bag/full
	r_hand = /obj/item/rogueweapon/sword
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	armor = /obj/item/clothing/cloak/tabard/crusader/astrata
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 3,
		/obj/item/needle/pestra = 1,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3)	//Capped to T3 miracles.

// Old loadout, heavy armor, T2, but worse stats.

/datum/advclass/crusader_paladin
	name = "Crusader Paladin"
	tutorial = "Crusader of the true faith, you came from Grenzelhoft on the orders of the holy see. FIND Psydon's holy chalice- and pillage your way into riches, for the glory of astrata!"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	maximum_possible_slots = 2
	outfit = /datum/outfit/job/roguetown/crusader/paladin
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_CRUSADE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
	)

	subclass_languages = list(
		/datum/language/grenzelhoftian,
		/datum/language/otavan,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding,
	)

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/crusader/paladin/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/divine/astrata)))	//astratan crusade
		to_chat(H, span_warning("Astrata, the Absolute Order of the lands embraces me; We shall take what is rightfully ours, For she wills it."))
		H.set_patron(/datum/patron/divine/astrata)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/crusader
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/cape/crusader
	backr = /obj/item/rogueweapon/shield/tower/metal
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/decorated
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.

// Footman. Heavy armor essentially old loadout. Loses T2, but gets heavy armor. 

/datum/advclass/crusader_footman
	name = "Crusader Footman"
	tutorial = "Heavily armored Crusader of the true faith, you came from Grenzelhoft on the orders of the holy see. FIND Psydon's holy chalice- and pillage your way into riches, for the glory of astrata!"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/crusader/footman
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_CRUSADE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/crusader/footman/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/divine/astrata)))	//astratan crusade
		to_chat(H, span_warning("Astrata, the Absolute Order of the lands embraces me; We shall take what is rightfully ours, For she wills it."))
		H.set_patron(/datum/patron/divine/astrata)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/crusader
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/cape/crusader
	backr = /obj/item/rogueweapon/shield/tower/metal
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/short
	l_hand = /obj/item/rogueweapon/spear/boar
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_0)	//Capped to T0 miracles.

/datum/advclass/crusader_marksman
	name = "Crusader Marksman"
	tutorial = "Crusader of the true faith, you came from Grenzelhoft on the orders of the holy see. FIND Psydon's holy chalice- and pillage your way into riches, for the glory of astrata!"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/crusader/marksman
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_CRUSADE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/crusader/marksman/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/divine/astrata)))	//astratan crusade
		to_chat(H, span_warning("Astrata, the Absolute Order of the lands embraces me; We shall take what is rightfully ours, For she wills it."))
		H.set_patron(/datum/patron/divine/astrata)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/crusader
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/cape/crusader
	backr = /obj/item/rogueweapon/shield/tower/metal
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/short
	beltl = /obj/item/quiver/bolts
	l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	armor = /obj/item/clothing/cloak/tabard/crusader/astrata
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_0)	//Capped to T0 miracles.


/obj/item/reagent_containers/glass/cup/golden/psydon
	name = "Psydon's Chalice"
	icon_state = "psydon_golden"
	sellprice = 600
	desc = "A glimmering chalice made from silver and gold, it has an inlade gem unlike any other. It was said to be once psydon's very own chalice."
#undef CTAG_CRUSADE
