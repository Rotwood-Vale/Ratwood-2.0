/datum/advclass/thug
	name = "Thug"
	tutorial = "Maybe you've never been the smartest person in town, but you've gotten this far - whether by finding odd-jobs around town carting shit for the soilers, being the meathead that somebody needs to stand behind them and look scary, or simply shaking down the weak with the veiled-or-otherwise threat of a clobbering. You might've had some run-ins with the law for petty crimes here and there, but you're tolerated enough to have a home here."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/thug
	category_tags = list(CTAG_TOWNER)
	traits_applied = list(TRAIT_SEEPRICES_SHITTY)
	cmode_music = 'sound/music/combat_bum.ogg'
	maximum_possible_slots = 8 // i dont want an army of towner thugs
	classes = list("Goon" = "You're a goon, a low-lyfe thug in a painful world - not good enough for war, not smart enough for peace. What you lack in station you make up for in daring.",
					"Wise Guy" = "You're smarter than the rest, by a stone's throw - and you know better than to get up close and personal. Unlike most others, you can read.",
					"Big Man" = "More akin to a corn-fed monster than a normal man, your size and strength are your greatest weapons; though they hardly supplement what's missing of your brains.")

/datum/outfit/job/roguetown/adventurer/thug/pre_equip(mob/living/carbon/human/H)
	..()

	H.adjust_blindness(-3)
	var/classes = list("Goon","Wise Guy","Big Man")
	var/classchoice = input("Choose your archetypes", "Available archetypes") as anything in classes

	switch(classchoice)
		if("Goon")
			H.set_blindness(0)
			to_chat(H, span_warning("You're a goon, a low-lyfe thug in a painful world - not good enough for war, not smart enough for peace. What you lack in station you make up for in daring."))
			H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
			H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE) 
			H.adjust_skillrank(/datum/skill/labor/mining, 1, TRUE)
			H.adjust_skillrank(/datum/skill/labor/lumberjacking, 2, TRUE)
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
			H.change_stat("strength", 2)
			H.change_stat("willpower", 1)
			H.change_stat("constitution", 3)
			H.change_stat("speed", -1)
			H.change_stat("intelligence", -1)
			var/options = list("Frypan", "Knuckles", "Navaja", "Bare Hands",) //"Whatever I Can Find") THIS OPTION IS TOTALLY BUGGED!
			var/option_choice = input("Choose your means.", "TAKE UP ARMS") as anything in options
			switch(option_choice)
				if("Frypan")
					H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE) // expert cook; expert pan-handler
					r_hand = /obj/item/cooking/pan
				if("Knuckles")
					H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
					r_hand = /obj/item/rogueweapon/knuckles
				if("Navaja")
					H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
					r_hand = /obj/item/rogueweapon/huntingknife/idagger/navaja
				if("Bare Hands")
					H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
					ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				//if("Whatever I Can Find") // random weapon from the dungeon table; could be a wooden club, could be a halberd
				//	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
				//	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
				//	H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
				//	r_hand = /obj/effect/spawner/lootdrop/roguetown/dungeon/weapons
		if("Wise Guy")
			H.set_blindness(0)
			to_chat(H, span_warning("You're smarter than the rest, by a stone's throw - and you know better than to get up close and personal. Unlike most others, you can read."))
			H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE) // vaguely smart, capable of making pyrotechnics
			H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE) 
			H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
			H.change_stat("speed", 2)
			H.change_stat("intelligence", 2)
			H.change_stat("willpower", -2)
			H.change_stat("constitution", -2)
			ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC) // very smart
			ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)
			var/options = list("Stone Sling", "Magic Bricks", "Lockpicking Equipment")
			var/option_choice = input("Choose your means.", "TAKE UP ARMS") as anything in options
			switch(option_choice)
				if("Stone Sling")
					H.adjust_skillrank(/datum/skill/combat/slings, 4, TRUE)
					r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
					l_hand = /obj/item/quiver/sling
				if("Magic Bricks")
					H.adjust_skillrank(/datum/skill/magic/arcane, 4, TRUE) // i fear not the man that has practiced a thousand moves one time, but the man that has practiced one move a thousand times
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/magicians_brick)
				if("Lockpicking Equipment")
					H.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE) // specialized into stealing; but good luck fighting
					H.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
					H.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
					ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
					r_hand = /obj/item/lockpickring/mundane
		if("Big Man")
			H.set_blindness(0)
			to_chat(H, span_warning("More akin to a corn-fed monster than a normal man, your size and strength are your greatest weapons; though they hardly supplement what's missing of your brains."))
			H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE) // knows very few practical skills; you're a moron
			H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE) // unrelenting
			H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE) 
			H.adjust_skillrank(/datum/skill/labor/mining, 3, TRUE)
			H.adjust_skillrank(/datum/skill/labor/lumberjacking, 2, TRUE) 
			H.change_stat("strength", 3)
			H.change_stat("willpower", 2)
			H.change_stat("constitution", 5) // fatass
			H.change_stat("speed", -4)
			H.change_stat("intelligence", -6)
			H.change_stat("perception", -3)
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_HARDDISMEMBER, TRAIT_GENERIC) // like a brick wall
			var/options = list("Hands-On", "Big Stick")
			var/option_choice = input("Choose your means.", "TAKE UP ARMS") as anything in options
			switch(option_choice) // you are big dumb guy, none of your options give you expert-level weapons skill
				if("Hands-On")
					ADD_TRAIT(H, TRAIT_BASHDOORS, TRAIT_GENERIC) // deal 200 damage to a door you sprint-charge into
					ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				if("Big Stick")
					H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
					r_hand = /obj/item/rogueweapon/mace/cudgel // Less deadly than axes, more thematic
			var/prev_real_name = H.real_name
			var/prev_name = H.name
			var/prefix = "Big" // if i see someone named "Boss" pick big man for this bit i will kill them
			H.real_name = "[prefix] [prev_real_name]"
			H.name = "[prefix] [prev_name]"

	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather

	H.grant_language(/datum/language/thievescant)
