// Ultra easy tier skeleton with no armor and just a single weapon.
/mob/living/carbon/human/species/skeleton/npc/supereasy
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/supereasy

// Easy tier skeleton, with only incomplete chainmail and kilt
// Ambushes people in "safe" route. A replacement for old skeletons that were effectively naked.
/mob/living/carbon/human/species/skeleton/npc/easy
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/easy

// Also an "easy" tier skeleton, pirate themed, with a free hand to grab you
/mob/living/carbon/human/species/skeleton/npc/pirate
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/pirate

// Medium tier skeleton, 3 skills.
/mob/living/carbon/human/species/skeleton/npc/medium
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/medium

// High tier skeleton, 4 skills. Heavy Armor.
/mob/living/carbon/human/species/skeleton/npc/hard
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/hard

// For Duke Manor & Zizo Manor - Ground based spread, so no pirate in pool!
/mob/living/carbon/human/species/skeleton/npc/mediumspread/Initialize(mapload)
	var/outfit = rand(1, 4)
	switch(outfit)
		if(1)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/supereasy
		if(2)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/easy
		if(3)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/medium
		if(4)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/hard
	..()

/mob/living/carbon/human/species/skeleton/npc/mediumspread/lich
	faction = list("lich")

// for Lich Dungeon
/mob/living/carbon/human/species/skeleton/npc/hardspread/Initialize(mapload)
	var/outfit = rand(1,4)
	switch(outfit)
		if(1)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/hard
		if(2)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/medium
		if(3)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/pirate
		if(4)
			skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/hard
	..()

/datum/outfit/job/roguetown/skeleton/npc/supereasy/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 10
	H.STASPD = 8
	H.STACON = 4
	H.STAWIL = 10
	H.STAINT = 1
	name = "Skeleton"
	if(prob(50))
		shirt = /obj/item/clothing/suit/roguetown/shirt/rags
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	if(prob(50))
		pants = /obj/item/clothing/under/roguetown/tights/random
	else
		pants = /obj/item/clothing/under/roguetown/loincloth
	if(prob(5))
		belt = /obj/item/storage/belt/rogue/leather/rope
		switch(rand(1, 100))
			if(1 to 50)
				beltr = /obj/item/storage/belt/rogue/pouch/coins/poor/
			if(51 to 95)
				beltr = null
			if(96 to 100)
				beltr = /obj/item/storage/belt/rogue/pouch/treasure/
	if(prob(5))
		id = /obj/item/clothing/ring/decrepit
	var/weapon_choice = rand(1, 4)
	switch(weapon_choice)
		if(1)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient/decrepit
		if(2)
			r_hand = /obj/item/rogueweapon/sword/short/ancient/decrepit
		if(3)
			r_hand = /obj/item/rogueweapon/spear/ancient/decrepit
		if(4)
			r_hand = /obj/item/rogueweapon/mace/steel/ancient/decrepit
	H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/datum/outfit/job/roguetown/skeleton/npc/easy/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 9
	H.STASPD = 8
	H.STACON = 4 // Same statblock as before easily killed
	H.STAWIL = 12
	H.STAINT = 1
	name = "Skeleton Footsoldier"
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient/decrepit
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient/decrepit
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/ancient/decrepit
	if(prob(20))
		belt = /obj/item/storage/belt/rogue/leather/rope
		switch(rand(1, 100))
			if(1 to 50)
				beltr = /obj/item/storage/belt/rogue/pouch/coins/poor/
			if(51 to 95)
				beltr = null
			if(96 to 100)
				beltr = /obj/item/storage/belt/rogue/pouch/treasure/
	if(prob(5))
		id = /obj/item/clothing/ring/decrepit
	var/weapon_choice = rand(1, 4)
	switch(weapon_choice)
		if(1)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient/decrepit
		if(2)
			r_hand = /obj/item/rogueweapon/sword/short/ancient/decrepit
		if(3)
			r_hand = /obj/item/rogueweapon/spear/ancient/decrepit
		if(4)
			r_hand = /obj/item/rogueweapon/mace/steel/ancient/decrepit
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/datum/outfit/job/roguetown/skeleton/npc/pirate/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 9
	H.STASPD = 8
	H.STACON = 4 // Same statblock as before easily killed
	H.STAWIL = 12
	H.STAINT = 1
	name = "Skeleton Pirate"
	head =  /obj/item/clothing/head/roguetown/helmet/tricorn
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient/decrepit
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/ancient/decrepit
	if(prob(50))
		r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient/decrepit
	else
		r_hand = /obj/item/rogueweapon/knuckles/ancient/decrepit
	if(prob(20))
		belt = /obj/item/storage/belt/rogue/leather/rope
		switch(rand(1, 100))
			if(1 to 50)
				beltr = /obj/item/storage/belt/rogue/pouch/coins/poor/
			if(51 to 95)
				beltr = null
			if(96 to 100)
				beltr = /obj/item/storage/belt/rogue/pouch/treasure/
	if(prob(5))
		id = /obj/item/clothing/ring/decrepit
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/datum/outfit/job/roguetown/skeleton/npc/medium/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 11
	H.STASPD = 8
	H.STACON = 6 // Slightly tougher now!
	H.STAWIL = 10
	H.STAINT = 1
	name = "Skeleton Soldier"
	cloak = /obj/item/clothing/cloak/stabard/surcoat/guard // Ooo Spooky Old Dead MAA
	head = /obj/item/clothing/head/roguetown/helmet/heavy/ancient/decrepit
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient/decrepit
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient/decrepit
	wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient/decrepit
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/ancient/decrepit
	neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient/decrepit
	gloves = /obj/item/clothing/gloves/roguetown/chain/ancient/decrepit
	if(prob(30))
		switch(rand(1, 100))
			if(1 to 50)
				beltr = /obj/item/storage/belt/rogue/pouch/coins/poor/
			if(51 to 95)
				beltr = null
			if(96 to 100)
				beltr = /obj/item/storage/belt/rogue/pouch/treasure/
	if(prob(5))
		id = /obj/item/clothing/ring/decrepit
	if(prob(33)) // 33% chance of shield, so ranged don't get screwed over entirely
		l_hand = /obj/item/rogueweapon/shield/tower/metal/ancient/decrepit
	if(prob(33))
		r_hand = /obj/item/rogueweapon/spear/ancient/decrepit
	else if(prob(33))
		r_hand = /obj/item/rogueweapon/sword/short/gladius/ancient/decrepit	// ave
	else
		r_hand = /obj/item/rogueweapon/flail/sflail/ancient/decrepit
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

/datum/outfit/job/roguetown/skeleton/npc/hard/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 12
	H.STACON = 8 // Woe, actual limb health.
	H.STAWIL = 12
	H.STAINT = 1
	name = "Skeleton Dreadnought"
	// This combines the khopesh  and withered dreadknight
	var/skeletonclass = rand(1, 2)
	if(skeletonclass == 1) // Khopesh Knight
		H.STASPD = 12 // Hue
		cloak = /obj/item/clothing/cloak/hierophant
		mask = /obj/item/clothing/mask/rogue/facemask/ancient/decrepit
		armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient/decrepit
		shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient/decrepit
		wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit
		pants = /obj/item/clothing/under/roguetown/platelegs/ancient/decrepit
		shoes = /obj/item/clothing/shoes/roguetown/boots/armor/ancient/decrepit
		neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/ancient
		gloves = /obj/item/clothing/gloves/roguetown/chain/ancient/decrepit
		r_hand = /obj/item/rogueweapon/sword/sabre/ancient/decrepit
		l_hand = /obj/item/rogueweapon/sword/sabre/ancient/decrepit
	else // Withered Dreadknight
		H.STASPD = 8
		cloak = /obj/item/clothing/cloak/tabard/blkknight
		head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/ancient/decrepit
		armor = /obj/item/clothing/suit/roguetown/armor/plate/ancient/decrepit
		shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit
		wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit
		pants = /obj/item/clothing/under/roguetown/platelegs/ancient/decrepit
		shoes = /obj/item/clothing/shoes/roguetown/boots/armor/ancient/decrepit
		neck = /obj/item/clothing/neck/roguetown/gorget/steel/ancient/decrepit
		gloves = /obj/item/clothing/gloves/roguetown/plate/ancient/decrepit
		if(prob(50))
			r_hand = /obj/item/rogueweapon/greatsword/ancient/decrepit
		else
			r_hand = /obj/item/rogueweapon/mace/goden/steel/ancient/decrepit

	if(prob(60))
		belt = /obj/item/storage/belt/rogue/leather/rope
		switch(rand(1, 100))
			if(1 to 50)
				beltr = /obj/item/storage/belt/rogue/pouch/coins/poor/
			if(51 to 95)
				beltr = null
			if(96 to 100)
				beltr = /obj/item/storage/belt/rogue/pouch/treasure/
	if(prob(5))
		id = /obj/item/clothing/ring/decrepit
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)

// Rockhill style medium skeleton
/mob/living/carbon/human/species/skeleton/npc/rockhill
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/rockhill

/datum/outfit/job/roguetown/skeleton/npc/rockhill/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 14
	H.STASPD = 8
	H.STACON = 6
	H.STAWIL = 15
	H.STAINT = 1
	name = "Skeleton"
	if(prob(10))
		head = /obj/item/clothing/head/roguetown/helmet/heavy/ancient/decrepit
	if(prob(10))
		armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient/decrepit
	if(prob(25))
		shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient/decrepit
	if(prob(90))
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(prob(90))
		pants = /obj/item/clothing/under/roguetown/trou/leather
	if(prob(80))
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	if(prob(70))
		neck = /obj/item/clothing/neck/roguetown/coif
	if(prob(70))
		gloves = /obj/item/clothing/gloves/roguetown/chain/ancient/decrepit
	if(prob(20))
		l_hand = /obj/item/rogueweapon/shield/tower/metal/ancient/decrepit
	if(prob(25))
		r_hand = /obj/item/rogueweapon/spear/ancient/decrepit
	else if(prob(25))
		r_hand = /obj/item/rogueweapon/mace/steel/ancient/decrepit
	else if(prob(25))
		r_hand = /obj/item/rogueweapon/sword/short/ancient/decrepit
	else
		r_hand = /obj/item/rogueweapon/flail/sflail/ancient/decrepit
	if(prob(40))
		belt = /obj/item/storage/belt/rogue/leather/rope
		if(prob(10))
			beltr = /obj/item/storage/belt/rogue/pouch/treasure/
		else
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor/
	if(prob(5))
		id = /obj/item/clothing/ring/decrepit
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

/mob/living/carbon/human/species/skeleton/npc/cultist
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/cultist

/datum/outfit/job/roguetown/skeleton/npc/cultist/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 12
	H.STASPD = 10
	H.STACON = 6
	H.STAWIL = 10
	H.STAINT = 1
	name = "Skeleton"
	if(prob(80))
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/noc
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
	wrists = /obj/item/clothing/wrists/roguetown/nocwrappings
	if(prob(20))
		head = /obj/item/clothing/head/roguetown/nochood
	if(prob(30))
		head = /obj/item/clothing/head/roguetown/roguehood/black
	if(prob(50))
		pants = /obj/item/clothing/under/roguetown/tights/random
	else
		pants = /obj/item/clothing/under/roguetown/loincloth
	if(prob(20))
		belt = /obj/item/storage/belt/rogue/leather/rope
		if(prob(20))
			beltr = /obj/item/storage/belt/rogue/pouch/treasure/
		else
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor/
	if(prob(5))
		id = /obj/item/clothing/ring/decrepit
	var/weapon_choice = rand(1, 4)
	switch(weapon_choice)
		if(1)
			r_hand = /obj/item/rogueweapon/sickle/decrepit
		if(2)
			r_hand = /obj/item/rogueweapon/woodstaff
		if(3)
			r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient/decrepit
		if(4)
			r_hand = /obj/item/rogueweapon/mace/woodclub
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)


/mob/living/carbon/human/species/skeleton/npc/miner
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/miner

/datum/outfit/job/roguetown/skeleton/npc/miner/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 14
	H.STASPD = 8
	H.STACON = 6
	H.STAWIL = 15
	H.STAINT = 1
	name = "Skeleton"
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/loincloth/brown
	if(prob(40))
		pants =	/obj/item/clothing/under/roguetown/trou
	if(prob(25))
		head = /obj/item/clothing/head/roguetown/helmet
	if(prob(25))
		head = /obj/item/clothing/head/roguetown/helmet/horned
	neck = /obj/item/clothing/neck/roguetown/collar/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	r_hand = /obj/item/rogueweapon/pick/decrepit
	if(prob(20))
		r_hand = /obj/item/rogueweapon/shovel/decrepit
	if(prob(40))
		belt = /obj/item/storage/belt/rogue/leather/rope
		if(prob(10))
			beltr = /obj/item/storage/belt/rogue/pouch/treasure/
		else
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor/
	if(prob(5))
		id = /obj/item/clothing/ring/decrepit
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
