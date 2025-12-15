/datum/migrant_role/slaver/master
	name = "Zybantynian Master"
	greet_text = "The leader of the Zybantynian slave troop. You have came to the mainlands from the western deserts of Zybantine in the hopes of gathering wealth through the training of and trade of unfortunate laborers. The practice can be called despicable by some, but it is without a doubt efficient in filling your pockets before you return to the deserts of the Zybantines"
	outfit = /datum/outfit/job/roguetown/slaver/master
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS

/datum/outfit/job/roguetown/slaver/master/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/raneshen		// thematic as it is the same helmet jannisaries use. Maybe a retired soldier with hired goons?
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/purple
	neck = /obj/item/clothing/neck/roguetown/bevor
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord		// an arming jacket won't hurt
	belt = /obj/item/storage/belt/rogue/leather/shalal/purple
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	cloak = /obj/item/clothing/cloak/cape/purple
	backl = /obj/item/storage/backpack/rogue/backpack
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/whip/antique
	backpack_contents = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 2, /obj/item/rope/chain = 1, /obj/item/flint = 1, /obj/item/clothing/neck/roguetown/collar/leather = 2)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 5, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.change_stat("strength", 3)
		H.change_stat("speed", 2)
		H.change_stat("constitution", 2)
		H.change_stat("willpower", 2)
		H.cmode_music = 'sound/music/combat_zybantine.ogg'

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_XENOPHOBIC, TRAIT_GENERIC)

	if(!H.has_language(/datum/language/celestial))
		H.grant_language(/datum/language/celestial)
		to_chat(H, span_info("I can speak Sama'glos with ,c before my speech."))

/datum/migrant_role/slaver/slavemercsword
	name = "Zybantynian Blade Mercenary"
	greet_text = "A hired arm for the Zybantine Slave troop. You have come from the deserts of Zybantine and are hired under contract by the Zybantynian Master."
	outfit = /datum/outfit/job/roguetown/slaver/slavemercsword
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	grant_lit_torch = TRUE
	show_wanderer_examine = TRUE

/datum/outfit/job/roguetown/slaver/slavemercsword/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/purple
	neck = /obj/item/clothing/neck/roguetown/chaincoif		//no need for two pouches of coin, get SOME neck armor
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather/shalal/purple
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/sword/sabre/shamshir
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/rogueweapon/scabbard/sword
	backpack_contents = list(/obj/item/rope/chain = 1, /obj/item/rogueweapon/huntingknife/idagger = 1, /obj/item/rogueweapon/scabbard/sheath = 1)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.change_stat("strength", 2)
		H.change_stat("speed", 1)
		H.change_stat("intelligence", 2)
		H.change_stat("constitution", 1)
		H.change_stat("willpower", 1)
		H.cmode_music = 'sound/music/combat_zybantine.ogg'

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_XENOPHOBIC, TRAIT_GENERIC)

	if(!H.has_language(/datum/language/celestial))
		H.grant_language(/datum/language/celestial)
		to_chat(H, span_info("I can speak Sama'glos with ,c before my speech."))

/datum/migrant_role/slaver/slavemercwhip
	name = "Zybantynian Whip Mercenary"
	greet_text = "A hired arm for the Zybantine Slave troop. You have come from the deserts of Zybantine and are hired under contract by the Zybantynian Master."
	outfit = /datum/outfit/job/roguetown/slaver/slavemercwhip
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	grant_lit_torch = TRUE

/datum/outfit/job/roguetown/slaver/slavemercwhip/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/purple
	neck = /obj/item/clothing/neck/roguetown/chaincoif		//ditto as blade mercs: some neck armor. No need for so much coin
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather/shalal/purple
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/tower
	beltr = /obj/item/rogueweapon/whip
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backpack_contents = list(/obj/item/rope/chain = 1, /obj/item/rogueweapon/huntingknife/idagger = 1, /obj/item/rogueweapon/scabbard/sheath = 1)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)		// for the whip & shield combo
		H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.change_stat("strength", 2)
		H.change_stat("speed", 1)
		H.change_stat("intelligence", 2)
		H.change_stat("constitution", 1)
		H.change_stat("willpower", 1)
		H.cmode_music = 'sound/music/combat_zybantine.ogg'

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_XENOPHOBIC, TRAIT_GENERIC)

	if(!H.has_language(/datum/language/celestial))
		H.grant_language(/datum/language/celestial)
		to_chat(H, span_info("I can speak Sama'glos with ,c before my speech."))

/datum/migrant_role/slaver/slavemercbow
	name = "Zybantynian Light Crossbow Mercenary"
	greet_text = "A hired arm for the Zybantine Slave troop, also trained in first aid. You have come from the deserts of Zybantine and are hired under contract by the Zybantynian Master."
	outfit = /datum/outfit/job/roguetown/slaver/slavemercbow
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	grant_lit_torch = TRUE

/datum/outfit/job/roguetown/slaver/slavemercbow/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/purple
	neck = /obj/item/clothing/neck/roguetown/gorget
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather/shalal/purple
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light	// light armor for the dodgejak
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/quiver/bolts
	backpack_contents = list(/obj/item/rope/chain = 1, /obj/item/rogueweapon/huntingknife/combat = 1, /obj/item/needle = 1, /obj/item/rogueweapon/scabbard/sheath = 1)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 5, TRUE)	//its just draw time. Every other role w/a focus on crossbows gets this. They lose weapon variety in order to be dedicated crossbow and knive users
		H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.change_stat("perception", 3)
		H.change_stat("speed", 2)
		H.change_stat("intelligence", 3)
		H.change_stat("willpower", 2)
		H.cmode_music = 'sound/music/combat_zybantine.ogg'

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_XENOPHOBIC, TRAIT_GENERIC)

	if(!H.has_language(/datum/language/celestial))
		H.grant_language(/datum/language/celestial)
		to_chat(H, span_info("I can speak Sama'glos with ,c before my speech."))

/datum/migrant_role/slaver/slavez
	name = "Slave"
	greet_text = "An unlucky slave, captured from their home, moved to the Zybantines and trained for slave labor and obediency, for long enough to where you can only faintly remember who you were before... You are now being transported from the deserts to harsher lands to be sold."
	outfit = /datum/outfit/job/roguetown/slaver/slavez
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE

/datum/outfit/job/roguetown/slaver/slavez/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
	neck = /obj/item/clothing/neck/roguetown/collar/leather
	belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt
	beltl = /obj/item/storage/belt/rogue/pouch
	beltr = /obj/item/flint
	shoes = /obj/item/clothing/shoes/roguetown/anklets
	mask = /obj/item/clothing/mask/rogue/exoticsilkmask
	if(H.mind)
		H.virginity = TRUE
		H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/music, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/sewing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)		// would make sense they probably know how to either stitch themselves or their masters - makes them more valuable, too.
		H.change_stat("strength", -3)
		H.change_stat("constitution", -2)
		H.change_stat("willpower", 3) // they get whipped, they can endure some pain
		H.change_stat("intelligence", 3)
		H.change_stat("speed", 2)	// all they can do is run bruh.
		H.cmode_music = 'sound/music/combat_zybantine.ogg'

	ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
