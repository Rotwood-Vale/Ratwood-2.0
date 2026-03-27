//Renegade's Psydonic Wight minion
/datum/job/roguetown/renpsywight
	title = "Psydonic Wight"
	advclass_cat_rolls = list(CTAG_LSKELETON = 20)
	tutorial = "You died a long time ago, cared for by PSYDON until your last breathe. Now you return to the mortal realm to fulfill HIS last will."

	outfit = /datum/outfit/job/roguetown/renpsywight

/datum/outfit/job/roguetown/renpsywight
	cloak = /obj/item/clothing/cloak/templar/psydon	// Old-fashioned, non-Otavan design.
	belt = /obj/item/storage/belt/rogue/leather/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	backl = /obj/item/storage/backpack/rogue/satchel
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron

/datum/outfit/job/roguetown/renpsywight/pre_equip(mob/living/carbon/human/H)
	..()
	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

// Melee goon with sword and shield. All-rounder.
/datum/advclass/renpsywight/crusader
	name = "Wight Crusader"
	tutorial = "When ZIZO and PSYDON met in battle, you were far away from them, wielding your blade and shield against the Dark Lady's legions. You died. \
	Yet your duty continues on..."
	outfit = /datum/outfit/job/roguetown/renpsywight/crusader

	category_tags = list(CTAG_PSYWIGHT)

/datum/outfit/job/roguetown/renpsywight/crusader/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 10
	H.STASPD = 10
	H.STACON = 11
	H.STAWIL = 12
	H.STAINT = 10
	H.STAPER = 10 //+3 stat total lol.

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE) // Can sidespec into axes, maces and flails if desperate.
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE) // Damn old man got hands.
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	mask = /obj/item/clothing/mask/rogue/facemask
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	backr = /obj/item/rogueweapon/shield/wood
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/rogueweapon/sword/long/oldpsysword
	H.adjust_blindness(-3)
	H.set_blindness(0) // ??? It was like that in Lich Greater Skeleton's code. I am scared to touch it.
	H.energy = H.max_energy

// Heavy/Tanky goon. Not heavy armor but due to the steel + weapons they'll fare just fine.
/datum/advclass/renpsywight/sacrosanct
	name = "Wight Sacrosanct"
	tutorial = "You were one of the sacrosancts, warriors of HIS, clad in heavy armour and armed with two-handed weaponry. Thought to be untouchable, \
	but mere thought didn't save you from death. Yet you persist."
	outfit = /datum/outfit/job/roguetown/renpsywight/sacrosanct

	category_tags = list(CTAG_PSYWIGHT)

/datum/outfit/job/roguetown/renpsywight/sacrosanct/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 12
	H.STASPD = 8
	H.STACON = 12
	H.STAWIL = 12
	H.STAINT = 8 // You were chosen for brawn, not smarts.
	H.STAPER = 10 // +1 stat total, but you get heavy armour training.

	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	neck = /obj/item/clothing/neck/roguetown/gorget
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	backl = /obj/item/rogueweapon/scabbard/gwstrap

	H.adjust_blindness(-3)
	var/weapons = list("Greatsword", "Greataxe", "Mace", "Spear")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Broadsword")
			r_hand = /obj/item/rogueweapon/greatsword/bsword/psy
			H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		if("Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe
			H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
		if("Mace")
			r_hand = /obj/item/rogueweapon/mace/goden/psymace/old
			H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
		if("Spear")
			r_hand = /obj/item/rogueweapon/spear/psyspear/old
			H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)

	H.energy = H.max_energy