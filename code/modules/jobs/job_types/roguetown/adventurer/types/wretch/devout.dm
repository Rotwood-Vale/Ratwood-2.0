/datum/advclass/wretch/devout
	name = "Devout Heretic"
	tutorial = "In another lyfe, you'd have made a good acolyte of the tennites. Somebody not hunted by the powers above and in the law. You however, have answered to the changing dawn; The age of the Inumen requires its apostles and doomsayers.  Serving them as a Devout is youe true calling - your gifts specialized in supporting their schemes and toiling in their name."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/devout
	// category_tags = list(CTAG_WRETCH) or (CTAG_DISABLED) to disable
	category_tags = list(CTAG_WRETCH)

/datum/outfit/job/roguetown/wretch/devout/pre_equip(mob/living/carbon/human/H)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR)

	ADD_TRAIT(H, TRAIT_RITUALIST, TRAIT_GENERIC) //Rituals! Huzzah!
	ADD_TRAIT(H, TRAIT_MEDICINE_EXPERT, TRAIT_GENERIC) //This should allow them to heal as a standalone, given wretches often do not work together.
	ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC) //So they can tell if somebody needs reviving basically; which is good for an antag or minor antag to have!
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC) //Same as clerics
	ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC) //I forgot what this does but it seems like a good choice for inhumen. :3
	ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC) // They will be some of the only roles on the wretch team that can make advanced potions as of AP update.

	/datum/outfit/job/roguetown/wretch/necromancer/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/roguehood/black
	mask = /obj/item/clothing/mask/rogue/facemask
	gloves = /obj/item/clothing/gloves/roguetown/bandages
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy
	cloak = /obj/item/clothing/cloak/tabard
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/black
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	neck = /obj/item/clothing/neck/roguetown/gorget
	beltl = /obj/item/rogueweapon/mace
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/heater
	backpack_contents = list(
		/obj/item/rope = 1,
		/obj/item/flint = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/natural/bundle/cloth/roll = 1,
		/obj/item/needle = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		/obj/item/ritechalk = 1
		)

	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)

	H.change_stat("strength", 1) //meant to be a support or war-cleric at best!
	H.change_stat("willpower", 2)
	H.change_stat("constitution", 2)
	H.change_stat("speed", 1)
	H.change_stat("fortune", 1) //blessed by the inhumen!
	H.change_stat("intelligence", 2)
	H.change_stat("perception", 1)
	H.cmode_music = 'sound/music/combat_berserker.ogg'
	to_chat(H, span_danger("You flee from the masses, scorned and shunned as a criminal! Begone soon, or else dangers will surely find ye soon!"))
	wretch_select_bounty(H)
