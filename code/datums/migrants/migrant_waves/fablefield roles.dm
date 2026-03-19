/datum/migrant_role/fablefield/goliard
	name = "Fablefield Goliard"
	greet_text = "For years you've travelled to Fablefield, honing your craft at the annual grand festival of tales. You are a respected weaver of glorious and valorous stories, with a tongue and wit as sharp as your blade. Of late, you've been obsessed with the Vale... What fantastical adventures could you embark on here, with your proteges?"
	outfit = /datum/outfit/job/roguetown/fablefield/goliard
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS

/datum/outfit/job/roguetown/fablefield/goliard/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/bardhat
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/tights/random
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	cloak = /obj/item/clothing/cloak/half/red
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogue/instrument/guitar
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/rogueweapon/scabbard/sheath
	r_hand = /obj/item/rogueweapon/sword/rapier/dec
	l_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish
	backpack_contents = list(/obj/item/book/rogue/tales1, /obj/item/book/rogue/blackmountain, /obj/item/book/rogue/tales3)
	H.adjust_skillrank(/datum/skill/misc/music, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE) //Futureproofing, does nothing for now.
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE) // to break out from a single grab they'll suffer
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_INT, 3)	//Smart Little Shit
	H.change_stat(STATKEY_WIL, 2)
	H.verbs |= /mob/living/carbon/human/proc/ventriloquate

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)

/datum/migrant_role/fablefield/troubadour
	name = "Fablefield Troubadour"
	greet_text = "At the last grand festival of tales in Fablefield, you were inspired by a figure who sung of dragons, faeries, gods and heroes. This year, you plan to be the hero of your own story. A talented bard, and good with a blade, you follow your muse with nothing but the highest hopes, although so far the Vale isn't quite what you expected..."
	outfit = /datum/outfit/job/roguetown/fablefield/troubadour
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS

/datum/outfit/job/roguetown/fablefield/troubadour/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/bardhat
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/tights/random
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	cloak = /obj/item/clothing/cloak/half/orange
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/sword/rapier
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/rogueweapon/scabbard/sheath
	l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
	var/instrumentroll = rand(1, 100)	//GAMBLING !!!
	switch(instrumentroll)
		if(1 to 20)
			r_hand = /obj/item/rogue/instrument/lute
		if(21 to 40)
			r_hand = /obj/item/rogue/instrument/accord
		if(41 to 60)
			r_hand = /obj/item/rogue/instrument/flute
		if(61 to 80)
			r_hand = /obj/item/rogue/instrument/hurdygurdy
		if(81 to 100)
			r_hand = /obj/item/rogue/instrument/trumpet
	backpack_contents = list(/obj/item/book/rogue/nitebeast, /obj/item/flashlight/flare/torch/lantern, /obj/item/flint, /obj/item/rogueweapon/scabbard/sheath)
	H.adjust_skillrank(/datum/skill/misc/music, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE) //Futureproofing, does nothing for now.
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_WIL, 2)

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
