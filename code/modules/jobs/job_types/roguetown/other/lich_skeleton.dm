/*
LICH SKELETONS
*/

/datum/job/roguetown/greater_skeleton/lich
	title = "Fortified Skeleton"
	advclass_cat_rolls = list(CTAG_LSKELETON = 20)
	tutorial = "You are bygone. Your will belongs to your master. Fulfil and kill."

	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich

/datum/outfit/job/roguetown/greater_skeleton/lich
	belt = /obj/item/storage/belt/rogue/leather/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient
	backr = /obj/item/storage/backpack/rogue/satchel

/datum/outfit/job/roguetown/greater_skeleton/lich/pre_equip(mob/living/carbon/human/H)
	..()

	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_LICHLAIR, TRAIT_GENERIC) //Ability to leave/enter the lich's lair without being softlocked inside.

// Melee goon w/ throwables. All-rounder.
/datum/advclass/greater_skeleton/lich/legionnaire
	name = "Ancient Legionnaire"
	tutorial = "A veteran lineman. How far you've fallen."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/legionnaire

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/legionnaire/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 12
	H.STASPD = 9
	H.STACON = 8
	H.STAWIL = 12
	H.STAINT = 3
	H.STAPER = 11

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/ancient
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
	shoes = /obj/item/clothing/shoes/roguetown/sandals/ancient
	gloves = /obj/item/clothing/gloves/roguetown/chain/ancient

	r_hand = /obj/item/rogueweapon/shield/gilbranze

	backpack_contents = list(
		/obj/item/natural/feather = 1,
		/obj/item/storage/belt/rogue/pouch/coins/gilbranze = 1
	)

	H.adjust_blindness(-3)
	var/weapons = list("Gladius","Khopesh","Shortsword","Axe", "Flail")
	var/weapons_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
	switch(weapons_choice)
		if("Gladius")
			l_hand = /obj/item/rogueweapon/sword/short/gladius/ancient
			beltl = /obj/item/rogueweapon/scabbard
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Khopesh")
			l_hand = /obj/item/rogueweapon/sword/sabre/ancient
			beltl = /obj/item/rogueweapon/scabbard
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Shortsword")
			l_hand = /obj/item/rogueweapon/sword/short/ancient
			beltl = /obj/item/rogueweapon/scabbard
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Axe")
			l_hand = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
		if("Flail")
			l_hand = /obj/item/rogueweapon/flail/sflail/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
	var/sidearms = list("Javelins", "Net", "Dagger")
	var/sidearms_choice = input(H, "Choose your SIDEARM.", "RAGE AGAINST THE LYVING.") as anything in sidearms
	switch(sidearms_choice)
		if("Javelins")
			beltr = /obj/item/quiver/javelin/ancient
		if("Net")
			beltr = /obj/item/net
		if("Dagger")
			beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient
	var/neckwear = list("Coif", "Gorget")
	var/neckwear_choice = input(H, "Choose your PROTECTION.", "PROTECT THE SACRED LEYLINE.") as anything in neckwear
	switch(neckwear_choice)
		if("Coif")
			neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
		if("Gorget")
			neck = /obj/item/clothing/neck/roguetown/gorget/steel/ancient
	var/cloaks = list("Jupon", "Tabard", "Cloak", "Shawl")
	var/cloaks_choice = input(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.") as anything in cloaks
	H.set_blindness(0)
	switch(cloaks_choice)
		if("Jupon")
			cloak = /obj/item/clothing/cloak/stabard/surcoat/lich
		if("Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Shawl")
			cloak = /obj/item/clothing/cloak/thief_cloak/lich

	H.energy = H.max_energy

// Ranged goon w/ a dumb bow. Ranger, what else is there to say.
/datum/advclass/greater_skeleton/lich/ballistiares
	name = "Ancient Ballistiares"
	tutorial = "Your frame has wept off your skin. Your fingers are mere peaks. Yet your aim remains true."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/ballistiares

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/ballistiares/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 10
	H.STASPD = 10
	H.STACON = 6
	H.STAWIL = 12
	H.STAINT = 5
	H.STAPER = 15

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/bows , 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/slings, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/kettle/ancient
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
	shoes = /obj/item/clothing/shoes/roguetown/sandals/ancient
	gloves = /obj/item/clothing/gloves/roguetown/chain/ancient

	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient

	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/gilbranze = 1
	)

	H.adjust_blindness(-3)
	var/weapons = list("Recurve Bow","Yew Longbow", "Crossbow", "Sling")
	var/weapons_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
	switch(weapons_choice)
		if("Recurve Bow")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			beltr = /obj/item/quiver/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
		if("Yew Longbow")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
			beltr = /obj/item/quiver/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
		if("Crossbow")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			beltr = /obj/item/quiver/boltsancient
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_MASTER, TRUE)
		if("Sling")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			beltr = /obj/item/quiver/sling/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_MASTER, TRUE)
	var/neckwear = list("Coif", "Gorget")
	var/neckwear_choice = input(H, "Choose your PROTECTION.", "PROTECT THE SACRED LEYLINE.") as anything in neckwear
	switch(neckwear_choice)
		if("Coif")
			neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
		if("Gorget")
			neck = /obj/item/clothing/neck/roguetown/gorget/steel/ancient
	var/cloaks = list("Jupon", "Tabard", "Cloak", "Shawl")
	var/cloaks_choice = input(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.") as anything in cloaks
	H.set_blindness(0)
	switch(cloaks_choice)
		if("Jupon")
			cloak = /obj/item/clothing/cloak/stabard/surcoat/lich
		if("Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Shawl")
			cloak = /obj/item/clothing/cloak/thief_cloak/lich

	H.energy = H.max_energy

// Heavy/Tanky goon. Can spec into disciples to be either a slow frontline combatant or a heavy armor wearing line holder.
/datum/advclass/greater_skeleton/lich/bulwark
	name = "Ancient Death Bulwark"
	tutorial = "All throughout, you've borne the brunt. And even in death, will you continue."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/bulwark

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/bulwark/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 11
	H.STASPD = 5
	H.STACON = 11
	H.STAWIL = 11
	H.STAINT = 3
	H.STAPER = 10

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/ancient
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/ancient
	gloves = /obj/item/clothing/gloves/roguetown/plate/ancient

	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/gilbranze = 1
	)

	H.adjust_blindness(-3)
	var/weapons = list("Greatsword - +2 STR / +1 SPD / -3 CON", "Grand Mace - +2 STR / +1 SPD / -3 CON", "Spear + Shield - +2 PER / +1 STR / -1 CON", "Bardiche - +2 PER / +1 STR / -1 CON","Mace + Shield - +3 WIL / HEAVY ARMOR", "Warhammer + Shield - +3 WIL / HEAVY ARMOR")
	var/weapons_choice = input(H, "Choose your DISCIPLINE.", "RAGE AGAINST THE LYVING.") as anything in weapons
	switch(weapons_choice)
		if("Greatsword - +2 STR / +1 SPD / -3 CON")
			l_hand = /obj/item/rogueweapon/greatsword/ancient
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
			pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_SPD, 1)
			H.change_stat(STATKEY_CON, -3)
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		if("Grand Mace - +2 STR / +1 SPD / -3 CON")
			l_hand = /obj/item/rogueweapon/mace/goden/steel/ancient
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
			pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_SPD, 1)
			H.change_stat(STATKEY_CON, -3)
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		if("Spear + Shield - +2 PER / +1 STR / -1 CON")
			l_hand = /obj/item/rogueweapon/spear/ancient
			r_hand = /obj/item/rogueweapon/shield/gilbranze
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
			pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE) // spear and shield is kind of a meme but if you wanna you can go crazy
			H.change_stat(STATKEY_PER, 2)
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_CON, -1)
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		if("Bardiche - +2 PER / +1 STR / -1 CON")
			l_hand = /obj/item/rogueweapon/halberd/bardiche/ancient
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
			pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_PER, 2)
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_CON, -1)
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		if("Mace + Shield - +3 WIL / HEAVY ARMOR")
			l_hand = /obj/item/rogueweapon/mace/steel/ancient
			r_hand = /obj/item/rogueweapon/shield/tower/metal/ancient
			armor = /obj/item/clothing/suit/roguetown/armor/plate/ancient
			pants = /obj/item/clothing/under/roguetown/platelegs/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_WIL, 3)
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
		if("Warhammer + Shield - +3 WIL / HEAVY ARMOR")
			l_hand = /obj/item/rogueweapon/mace/warhammer/steel/ancient
			r_hand = /obj/item/rogueweapon/shield/tower/metal/ancient
			armor = /obj/item/clothing/suit/roguetown/armor/plate/ancient
			pants = /obj/item/clothing/under/roguetown/platelegs/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_WIL, 3)
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	var/neckwear = list("Coif", "Gorget")
	var/neckwear_choice = input(H, "Choose your PROTECTION.", "PROTECT THE SACRED LEYLINE.") as anything in neckwear
	switch(neckwear_choice)
		if("Coif")
			neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
		if("Gorget")
			neck = /obj/item/clothing/neck/roguetown/gorget/steel/ancient
	var/cloaks = list("Jupon", "Tabard", "Cloak", "Shawl")
	var/cloaks_choice = input(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.") as anything in cloaks
	H.set_blindness(0)
	switch(cloaks_choice)
		if("Jupon")
			cloak = /obj/item/clothing/cloak/stabard/surcoat/lich
		if("Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Shawl")
			cloak = /obj/item/clothing/cloak/thief_cloak/lich

	H.energy = H.max_energy

// non-Combat crafter goon. Worse weapons + armor but does base-building. Fortnite.
/datum/advclass/greater_skeleton/lich/sapper
	name = "Broken-Bone Sapper"
	tutorial = "Simple. Obedient. Like an ant in a colony."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/sapper

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/sapper/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 10
	H.STASPD = 9
	H.STACON = 5
	H.STAWIL = 12 // AND YOU WILL TOIL
	H.STAINT = 6
	H.STAPER = 10

	ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_TRAINED_SMITH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/blacksmithing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/armorsmithing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 6, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/kettle/minershelm
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/lich
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer/lich
	pants = /obj/item/clothing/under/roguetown/trou/artipants/lich
	shoes = /obj/item/clothing/shoes/roguetown/sandals/ancient
	gloves = /obj/item/clothing/gloves/roguetown/angle

	backl = /obj/item/storage/backpack/rogue/backpack

	backpack_contents = list(
		/obj/item/rogueweapon/hammer/ancient = 1,
		/obj/item/rogueweapon/tongs/ancient = 1,
		/obj/item/storage/belt/rogue/pouch/coins/gilbranze = 1,
		/obj/item/rogueweapon/chisel = 1,
		/obj/item/rogueweapon/handsaw = 1,
		/obj/item/dye_brush = 1
	)

	beltr = /obj/item/rogueweapon/stoneaxe/woodcut
	beltl = /obj/item/rogueweapon/pick
	H.adjust_blindness(-3)
	var/neckwear = list("Coif", "Gorget")
	var/neckwear_choice = input(H, "Choose your PROTECTION.", "PROTECT THE SACRED LEYLINE.") as anything in neckwear
	switch(neckwear_choice)
		if("Coif")
			neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
		if("Gorget")
			neck = /obj/item/clothing/neck/roguetown/gorget/steel/ancient
	var/cloaks = list("Jupon", "Tabard", "Cloak", "Shawl")
	var/cloaks_choice = input(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.") as anything in cloaks
	H.set_blindness(0)
	switch(cloaks_choice)
		if("Jupon")
			cloak = /obj/item/clothing/cloak/stabard/surcoat/lich
		if("Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Shawl")
			cloak = /obj/item/clothing/cloak/thief_cloak/lich

	H.energy = H.max_energy

///////////////////////
// SPECIAL SKELETONS //
///////////////////////

// Stronger sidegrade of the Bulwark. Fully armored juggernaut with high Intelligence and Perception for baiting and riposting, but extremely low Speed and complete inability to sprint at all. Crack open the armor, overwhelm and they're dead meat.
// They lack the easily ability to escape fights including no climbing skill, they're tough and will tire you very fast. They have good armor off-the-bat. They're sturdy and difficult to tire but archers/mages/swarms of people will hardcounter them in open ground.
/datum/advclass/greater_skeleton/lich/deathknight
	name = "Venerated Death Knight"
	tutorial = "Swerve, parry, riposte. The wetness along your mortal wound has dried centuries ago, yet your wit remains unsullied in the slightest. Bring your master's chivalry to the battlefield, through both plate-and-blade."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/deathknight
	maximum_possible_slots = 1 //Limited, but powerful. Could serve as either champions or commanders for their necromancer's army.

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/deathknight/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 16 // ZIZO's strongest skeleton
	H.STASPD = 5 // Slow and can't sprint, if you get surrounded you're cooked
	H.STACON = 9 // A little bit tankier than the average boner
	H.STAWIL = 12 // Hold the line
	H.STAINT = 14
	H.STAPER = 14

	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NORUN, TRAIT_GENERIC) // You can't sprint at all
	ADD_TRAIT(H, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE) // Your flaw is inability to escape, no climbing here

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/ancient
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich
	armor = /obj/item/clothing/suit/roguetown/armor/plate/ancient
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/platelegs/ancient
	gloves = /obj/item/clothing/gloves/roguetown/plate/ancient
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/ancient

	backpack_contents = list(
		/obj/item/natural/feather = 1,
		/obj/item/storage/belt/rogue/pouch/coins/gilbranze = 1
	)

	H.adjust_blindness(-3)
	var/weapons = list("Greatsword", "Flail + Greatshield")
	var/weapon_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
	switch(weapon_choice)
		if("Greatsword")
			l_hand = /obj/item/rogueweapon/greatsword/ancient
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Flail + Greatshield")
			l_hand = /obj/item/rogueweapon/flail/sflail/ancient
			r_hand = /obj/item/rogueweapon/shield/gilbranze/great
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
	var/neckwear = list("Coif", "Gorget")
	var/neckwear_choice = input(H, "Choose your PROTECTION.", "PROTECT THE SACRED LEYLINE.") as anything in neckwear
	switch(neckwear_choice)
		if("Coif")
			neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
		if("Gorget")
			neck = /obj/item/clothing/neck/roguetown/gorget/steel/ancient
	var/cloaks = list("Jupon", "Tabard", "Cloak", "Shawl")
	var/cloaks_choice = input(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.") as anything in cloaks
	H.set_blindness(0)
	switch(cloaks_choice)
		if("Jupon")
			cloak = /obj/item/clothing/cloak/stabard/surcoat/lich
		if("Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Shawl")
			cloak = /obj/item/clothing/cloak/thief_cloak/lich

//////////////////
// UNIQUE ITEMS //
//////////////////

/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer/lich
	name = "sapper's shirt"
	desc = "A shirt made with roughspun fabrics and leather from beyond your lyfetime, donned by those who are condemned to toil forevermore."
	color = "#d6bbbb"

/obj/item/clothing/under/roguetown/trou/artipants/lich
	name = "sapper's trousers"
	desc = "A set of trousers made with leathers and roughspun fabric from beyond your lyfetime, donned by those who are condemned to toil forevermore."
	color = "#d6bbbb"

/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/lich
	name = "sapper's jacket"
	desc = "A jacket of rugged leather adorned with roughspun fabric and fur from beyond your lyfetime, donned by those who are condemned to toil forevermore."
	color = "#d6bbbb"

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich
	name = "ancient hood"
	desc = "Roughspun fabrics from beyond your lyfetime, worn to keep Astrata's light from touching those who are shunned by it."
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/stabard/surcoat/lich
	name = "ancient jupon"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who are condemned to march forevermore."
	color = CLOTHING_BLACK
	detail_tag = "_quad"
	detail_color = CLOTHING_BURLAP

/obj/item/clothing/cloak/tabard/lich
	name = "ancient tabard"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who once knew of chivalry's allure."
	color = CLOTHING_BLACK
	detail_tag = "_quad"
	detail_color = CLOTHING_BURLAP

/obj/item/clothing/cloak/half/lich
	name = "ancient cloak"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who fear what they've truly become."
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/thief_cloak/lich
	name = "ancient shawl"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who have embraced the fetters they've truly become."
	color = CLOTHING_BLACK

// SHIELDS

/obj/item/rogueweapon/shield/gilbranze
	name = "ancient hoplon shield"
	desc = "The finest companion to a javelin and gladius; a deceptively thin-yet-sturdy shield of gilbronze. This alloy even this thin, used to once surpass even steel in durability, yet despite aeon's grip being lifted it will never glitter as it once did."
	icon_state = "ancientshlegion"
	dropshrink = 0.8
	force = 15
	throwforce = 25 // DO NOT GIVE ANYTHING; BUT TAKE FROM THEM... EVERYTHING!
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	resistance_flags = null
	coverage = 50
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 220
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/shield/gilbranze/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = -3,"ey" = 3,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/gilbranze/decrepit
	name = "decrepit hoplon shield"
	desc = "A near-paradoxally thin-yet-somehow-intact shield of fraying bronze, impossibly remaining barely intact; yet in spite of this, a mere press of the thumb alone will bend a dent into it irreversably."
	force = 10
	throwforce = 8
	max_integrity = 60
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null

/obj/item/rogueweapon/shield/gilbranze/great
	name = "ancient hoplon greatshield"
	desc = "A heavy venerable shield, far taller and thicker than most other contemporaries, yet masterfully crafted O' so much more as well. Rebuking arrow and bolt alike \
	and yet it serves in a twisted charge against its old purpose to preserve lyfe, serving as a bulwark to herald the march of HER legionnaires to end lyfe."
	icon_state = "ancientshgreat"
	force = 30
	throwforce = 10
	throw_speed = 1
	throw_range = 2
	wlength = WLENGTH_NORMAL
	wdefense = 10
	coverage = 75
	minstr = 13
	max_integrity = 400

/obj/item/rogueweapon/shield/gilbranze/great/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = -3,"ey" = 3,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/gilbranze/great/decrepit
	name = "decrepit hoplon greatshield"
	desc = "A tarnished heavy once-venerable shield of fraying, rusted metal. It has survived unspeakable calamities and eons, once rebuking arrow and bolt alike; yet now its no better than \
	a battered hunk of metal with dents threatening to rip open. It failed its former owner and it won't be long until its own frail husk is reduced to nothing."
	force = 18
	throwforce = 6
	max_integrity = 180
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null
