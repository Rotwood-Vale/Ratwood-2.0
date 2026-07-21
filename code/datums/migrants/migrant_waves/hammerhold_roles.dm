//Jarl. Heavy armour guy with a greataxe and a sidearm mace.
/datum/migrant_role/hammerhold/jarl
	name = "Hammerholdian Jarl"
	greet_text = "You are a warrior-lord from Hammerhold and the leader of your warband. Guide them to glory and wealth or try to survive."
	outfit = /datum/outfit/job/roguetown/hammerhold/jarl
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi) //Same racelocks as Gronn Chieftain, subject to change
	show_wanderer_examine = FALSE

/datum/outfit/job/roguetown/hammerhold/jarl/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.set_patron(/datum/patron/divine/abyssor)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gronn
	neck = /obj/item/clothing/neck/roguetown/gorget
	cloak = /obj/item/clothing/cloak/darkcloak/bear
	armor = /obj/item/clothing/suit/roguetown/armor/plate/iron/gronn
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/platelegs/iron/gronn
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron/gronn
	gloves = /obj/item/clothing/gloves/roguetown/angle/atgervi
	belt = /obj/item/storage/belt/rogue/leather/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	beltl = /obj/item/rogueweapon/mace/steel
	beltr = /obj/item/flashlight/flare/torch/lantern
	id = /obj/item/clothing/neck/roguetown/psicross/abyssor
	r_hand = /obj/item/rogueweapon/greataxe/steel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1, //Some money as a treat. Hire an Atgervi.
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE) //You are sea raiders.
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE) //Basic self-sufficiency, especially if starting solo.
	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_PER, 1)

	H.cmode_music = 'sound/music/combat_fullplate.ogg'
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.dna.species.soundpack_f = new /datum/voicepack/female/warrior()

	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	if(!H.has_language(/datum/language/dwarvish))
		H.grant_language(/datum/language/dwarvish)
		to_chat(H, span_info("I can speak Dwarvish with ,d before my speech."))

//Tideweaver. T3 miraclist and some minor magics.
/datum/migrant_role/hammerhold/tideweaver
	name = "Hammerholdian Tideweaver"
	greet_text = "You are a cleric of the Lord of Abyss, devoted to him in prayer and arcyne. You have minor magical spells and medical knowledge in addition to your miracles, and can convert those shunned by the Holy See."
	outfit = /datum/outfit/job/roguetown/hammerhold/tideweaver
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi)
	show_wanderer_examine = FALSE

/datum/outfit/job/roguetown/hammerhold/tideweaver/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.set_patron(/datum/patron/divine/abyssor)
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/blue
	neck = /obj/item/clothing/neck/roguetown/leather
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk/blue
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/councillor
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/storage/belt/rogue/surgery_bag/full/improv
	id = /obj/item/clothing/neck/roguetown/psicross/abyssor
	r_hand = /obj/item/rogueweapon/spear/trident
	l_hand = /obj/item/rogueweapon/huntingknife/bronze
	backpack_contents = list(
		/obj/item/reagent_containers/glass/mortar = 1,
		/obj/item/pestle = 1,
		/obj/item/flashlight/flare/torch = 1
		)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 6, TRUE) //Flavour, Rockhill doesn't have that much water to swim in.
	H.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_SPD, 1)

	H.cmode_music = 'sound/music/combat_shaman2.ogg'

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/create_campfire)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/darkvision)


	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3)	//T3. We are NOT giving you Abyssal Infusion.

	if(!H.has_language(/datum/language/dwarvish))
		H.grant_language(/datum/language/dwarvish)
		to_chat(H, span_info("I can speak Dwarvish with ,d before my speech."))

//Volfskin. CritResist+Enduring guy with two axes.
/datum/migrant_role/hammerhold/volfskin
	name = "Hammerholdian Volfskin"
	greet_text = "You are a volfskin, one of the legendary Hammerholdian warriors who are said to be possessed by raging volf spirits in battles. Distrusted due to your less than savoury religious practices, but well-respected for your combat prowess."
	outfit = /datum/outfit/job/roguetown/hammerhold/volfskin
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi)
	show_wanderer_examine = FALSE

/datum/outfit/job/roguetown/hammerhold/volfskin/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		if(!istype(H.patron, /datum/patron/inhumen/graggar)) //Uniquely, can be Graggarite unlike the rest of the party. Forced to be Abyssorite if not Graggarite. You get TRAIT_ORGAN_EATER either way.
			H.set_patron(/datum/patron/divine/abyssor)
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn
	neck = /obj/item/clothing/neck/roguetown/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/trou/leather/gronn
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronn
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
	id = /obj/item/clothing/neck/roguetown/psicross/abyssor
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/reagent_containers/powder/moondust = 2 //"Raging volf spirits" in question
		)

	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 3, TRUE)

	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_WIL, 3)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_INT, -2)

	H.cmode_music = 'sound/music/combat_hornofthebeast.ogg'
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.dna.species.soundpack_f = new /datum/voicepack/female/warrior()

	ADD_TRAIT(H, TRAIT_ORGAN_EATER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	if(!H.has_language(/datum/language/dwarvish))
		H.grant_language(/datum/language/dwarvish)
		to_chat(H, span_info("I can speak Dwarvish with ,d before my speech."))

//Tribal
/datum/migrant_role/hammerhold/huscarl
	name = "Hammerholdian Huscarl"
	greet_text = "You are a loyal and skilled bodyguard to your jarl, specialising in pillaging, kidnapping and fighting with an axe and shield."
	outfit = /datum/outfit/job/roguetown/hammerhold/huscarl
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi)
	show_wanderer_examine = FALSE

/datum/outfit/job/roguetown/hammerhold/huscarl/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.set_patron(/datum/patron/divine/abyssor)
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/splintlegs/iron/gronn
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/gronn
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/atgervi
	beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
	id = /obj/item/clothing/neck/roguetown/psicross/abyssor
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch = 1
		)

	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)

	H.change_stat(STATKEY_WIL, 3)
	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_SPD, -1) //Literally Atgervi Varangian stats

	H.cmode_music = 'sound/music/combat_vagarian.ogg'
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.dna.species.soundpack_f = new /datum/voicepack/female/warrior()

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	if(!H.has_language(/datum/language/dwarvish))
		H.grant_language(/datum/language/dwarvish)
		to_chat(H, span_info("I can speak Dwarvish with ,d before my speech."))


//Thrall. Same as Gronn Wave's Slave, just with better clothes. Not required to be an Abyssorite like the rest of them.
/datum/migrant_role/hammerhold/thrall
	name = "Hammerholdian Thrall"
	greet_text = "An unlucky soul. Perhaps caught in a pillaging raid, or alone in the wilderness, you have been enslaved by the warband. Work hard to appease your new masters."
	outfit = /datum/outfit/job/roguetown/hammerhold/thrall
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	show_wanderer_examine = FALSE

/datum/outfit/job/roguetown/hammerhold/thrall/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/cursed_collar
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch
	beltr = /obj/item/flint
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE) // can mend the wounded a bit.
	H.change_stat(STATKEY_CON, -2)
	H.change_stat(STATKEY_WIL, 1)
	H.change_stat(STATKEY_STR, -2)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_SPD, 2)

	H.cmode_music = 'sound/music/combat_vagarian.ogg'

	if(!H.has_language(/datum/language/dwarvish))
		H.grant_language(/datum/language/dwarvish)
		to_chat(H, span_info("I can speak Dwarvish with ,d before my speech."))

	if(H.mind)
		var/classes = list("Captured Worker", "Captured Artisan", "Captured Noble", "Captured Bard")
		var/classchoice = input(H, "Choose your archetypes", "Available archetypes") as anything in classes

		switch(classchoice)
			if("Captured Worker")
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/blue
				pants = /obj/item/clothing/under/roguetown/trou
				backl = /obj/item/storage/backpack/rogue/satchel
				r_hand = /obj/item/rogueweapon/pitchfork
				l_hand = /obj/item/rogueweapon/pick

				backpack_contents = list(
					/obj/item/flashlight/flare/torch = 1
					)

				H.adjust_skillrank(/datum/skill/labor/farming, 3, TRUE)
				H.adjust_skillrank(/datum/skill/labor/mining, 2, TRUE)
				H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)

			if("Captured Artisan")
				beltr = /obj/item/rogueweapon/hammer/iron
				beltl = /obj/item/rogueweapon/tongs
				gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
				cloak = /obj/item/clothing/cloak/apron/blacksmith
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/blue
				pants = /obj/item/clothing/under/roguetown/trou
				backl = /obj/item/storage/backpack/rogue/backpack
				backr = /obj/item/rogueweapon/scabbard/sheath

				backpack_contents = list(
					/obj/item/flint = 1,
					/obj/item/rogueore/coal = 4,
					/obj/item/rogueore/iron = 5,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/recipe_book/blacksmithing = 1,
					/obj/item/recipe_book/survival = 1,
					/obj/item/armor_brush = 1,
					/obj/item/polishing_cream = 1
					)

				H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/smelting, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/blacksmithing, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/armorsmithing, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/engineering, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/ceramics, 2, TRUE)

			if("Captured Noble")
				id = /obj/item/clothing/ring/silver
				if(should_wear_masc_clothes(H))
					cloak = /obj/item/clothing/cloak/half/red
					shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
					pants = /obj/item/clothing/under/roguetown/tights/black
				if(should_wear_femme_clothes(H))
					shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/purple
					cloak = /obj/item/clothing/cloak/raincloak/purple
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
				H.adjust_skillrank(/datum/skill/craft/sewing, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)

				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)

			if("Captured Bard")
				cloak = /obj/item/clothing/cloak/half
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/blue
				pants = /obj/item/clothing/under/roguetown/tights/random
				backl = /obj/item/storage/backpack/rogue/satchel
				backpack_contents = list(
					/obj/item/rogue/instrument/lute = 1,
					/obj/item/rogue/instrument/flute = 1,
					/obj/item/rogue/instrument/drum = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1
					)
				H.adjust_skillrank(/datum/skill/misc/music, 4, TRUE)
				H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)

				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
				var/datum/inspiration/I = new /datum/inspiration(H)
				I.grant_inspiration(H, bard_tier = BARD_T3)
