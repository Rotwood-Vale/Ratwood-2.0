/datum/migrant_role/czwarteki/lord
	name = "Czwarteki Lord"
	greet_text = "You are one of many Lords within the Czwarteki Commonwealth, be it to have come for Diplomacy, War, or simple passing through to assist in old alliances. You are to lead your Retinue and bring honor to the Commonwealth. "
	outfit = /datum/outfit/job/roguetown/czwarteki/lord
	allowed_races = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/demihuman)
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled

/datum/outfit/job/roguetown/czwarteki/lord/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/hussarhelm
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	pants = /obj/item/clothing/under/roguetown/platelegs
	cloak = /obj/item/clothing/cloak/lepoardcloak
	armor = /obj/item/clothing/suit/roguetown/armor/plate/hussar
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltl = /obj/item/rogueweapon/scabbard/sword
	l_hand = /obj/item/rogueweapon/sword/long/marlin
	r_hand = /obj/item/rogueweapon/huntingknife
	beltr = /obj/item/rogueweapon/scabbard/sheath
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backl = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_LCK, 5)

	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_EQUESTRIAN, TRAIT_GENERIC)

	H.cmode_music = 'sound/music/combat_czwarteki.ogg'

/datum/migrant_role/czwarteki/heir
	name = "Czwarteki Heir"
	greet_text = "You are the Czwarteki Lords Heir. Or perhaps one of many. Brought with you by your Parent to march forth on this venture. And to gain experience in the realms beyond your home."
	outfit = /datum/outfit/job/roguetown/czwarteki/heir
	allowed_races = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/demihuman)
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled

/datum/outfit/job/roguetown/czwarteki/heir/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	pants = /obj/item/clothing/under/roguetown/chainlegs
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather
	l_hand = /obj/item/rogueweapon/sword/sabre
	beltl = /obj/item/rogueweapon/scabbard/sword
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	backr = /obj/item/storage/backpack/rogue/satchel
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)

	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_SPD, 1)

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)

	H.cmode_music = 'sound/music/combat_czwarteki.ogg'

/datum/migrant_role/czwarteki/hussar
	name = "Czwarteki Hussar"
	greet_text = "You are a Hussar of Czwarteki, under the oath of your lord. You have raised your Journeyman to come with you to cross the lands. "
	outfit = /datum/outfit/job/roguetown/czwarteki/hussar
	allowed_races = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/demihuman,/datum/species/tieberian, /datum/species/lizardfolk,/datum/species/anthromorph,/datum/species/dracon, /datum/species/tabaxi)
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled

/datum/outfit/job/roguetown/czwarteki/hussar/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/hussarhelm
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/platelegs
	cloak = /obj/item/clothing/cloak/tabard/knight/guard
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/hussar
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	beltr = /obj/item/rogueweapon/scabbard/sword
	beltl = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	l_hand = /obj/item/rogueweapon/sword/sabre
	r_hand = /obj/item/rogueweapon/spear/lance
	H.adjust_skillrank(/datum/skill/combat/polearms, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_SPD, -1)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_EQUESTRIAN, TRAIT_GENERIC)

	H.cmode_music = 'sound/music/combat_czwarteki.ogg'

/datum/migrant_role/czwarteki/hussar/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/knight/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "knight tabard ([index])"
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Ser"
		if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
			honorary = "Dame"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

/datum/migrant_role/czwarteki/journeyman
	name = "Czwarteki Journeyman"
	greet_text = "You are a Retainers of your Hussars. Called forth into action. You know well how to ride. And tend to your Hussars needs."
	outfit = /datum/outfit/job/roguetown/czwarteki/journeyman
	allowed_races = RACES_NO_CONSTRUCT
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled

/datum/outfit/job/roguetown/czwarteki/journeyman/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/sword/sabre
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	cloak = /obj/item/clothing/cloak/stabard/surcoat
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/scabbard/sword
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	r_hand = /obj/item/rogueweapon/spear
	backpack_contents = list(
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/clothing/neck/roguetown/chaincoif,
		/obj/item/rogueweapon/hammer/iron
	)

	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)	
		
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_WIL, 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	H.cmode_music = 'sound/music/combat_czwarteki.ogg'

/datum/migrant_role/czwarteki/journeyman/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/stabard/surcoat/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "journeyman's tabard ([index])"

/datum/migrant_role/czwarteki/servant
	name = "Czwarteki Servant"
	greet_text = "You are Servants of your Lord. Taken along upon the Journey through the Vale with the Retinue. Your only goals are but to ensure your Lord and his Heir's well being upon the trip."
	outfit = /datum/outfit/job/roguetown/czwarteki/servant
	allowed_races = RACES_NO_CONSTRUCT
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE

/datum/outfit/job/roguetown/czwarteki/servant/pre_equip(mob/living/carbon/human/H)
	..()

	backl = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
	pants = /obj/item/clothing/under/roguetown/trou/formal/shorts
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/rogueweapon/huntingknife
	backl = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(
		/obj/item/needle,
		/obj/item/flint,
		/obj/item/cooking/pan
	)
	ADD_TRAIT(H, TRAIT_SLEUTH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KEENEARS, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	H.cmode_music = 'sound/music/combat_czwarteki.ogg'
