//Renegade's Psydonic Wight minion
/datum/job/roguetown/renpsywight
	title = "Psydonic Wight"
	advclass_cat_rolls = list(CTAG_PSYWIGHT = 2)
	tutorial = "You died a long time ago, cared for by PSYDON until your last breathe. Now you return to the mortal realm to fulfill HIS last will."

	outfit = /datum/outfit/job/roguetown/renpsywight

/datum/outfit/job/roguetown/renpsywight
	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	mask = /obj/item/clothing/mask/rogue/facemask
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	backr = /obj/item/rogueweapon/shield/iron
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/rogueweapon/sword/long/oldpsysword
	cloak = /obj/item/clothing/cloak/templar/psydon // Old-fashioned, non-Otavan design.
	belt = /obj/item/storage/belt/rogue/leather/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	backl = /obj/item/storage/backpack/rogue/satchel
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	id = /obj/item/clothing/neck/roguetown/psicross

/datum/advclass/job/roguetown/renpsywight/crusader
	name = "Wight Crusader"
	tutorial = "When ZIZO and PSYDON met in battle, you were far away from them, wielding your blade and shield against the Dark Lady's legions. You died. \
	Yet your duty continues on..."
	outfit = /datum/outfit/job/roguetown/renpsywight/crusader
	category_tags = list(CTAG_PSYWIGHT)

/datum/outfit/job/roguetown/renpsywight/crusader/pre_equip(mob/living/carbon/human/H)
	H.set_patron(/datum/patron/old_god)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
	H.STASTR = 10
	H.STASPD = 10
	H.STACON = 12
	H.STAWIL = 12
	H.STAINT = 10
	H.STAPER = 10 // +4 stat total lol

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE) // Can sidespec into axes, maces and flails if desperate.
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE) // Damn old man got hands.
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	H.adjust_blindness(-3)
	H.set_blindness(0) // ??? It was like that in Lich Greater Skeleton's code. I am scared to touch it.
	H.energy = H.max_energy
