/datum/advclass/mercenary/desert_rider
	name = "Desert Rider Janissary"
	tutorial = "The Janissaries are the Empire's elite infantry units, wielding mace and shield. We do not break."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/desert_rider
	class_select_category = CLASS_CAT_ZYBANTU
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_desertrider.ogg' //GREATEST COMBAT TRACK IN THE GAME SO FAR BESIDES MAYBE MANIAC2.OGG
	subclass_languages = list(/datum/language/celestial)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)


/datum/outfit/job/roguetown/mercenary/desert_rider/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("The Janissaries are the Empire's elite infantry units, wielding mace and shield. We do not break."))
	head = /obj/item/clothing/head/roguetown/helmet/sallet/zyb
	neck = /obj/item/clothing/neck/roguetown/bevor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	gloves = /obj/item/clothing/gloves/roguetown/chain
	pants = /obj/item/clothing/under/roguetown/splintlegs
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/clothing/neck/roguetown/shalal
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife/idagger/steel/kukri,
		/obj/item/flashlight/flare/torch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	var/weapons = list("Mace and Shield","Shamshir and Shield","Spear and Shield","Axe and Shield")
	if(H.mind)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Mace and Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
				backl = /obj/item/rogueweapon/shield/tower/zyb
				beltr = /obj/item/rogueweapon/mace/steel
			if("Shamshir and Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
				backl = /obj/item/rogueweapon/shield/tower/zyb
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Spear and Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				r_hand = /obj/item/rogueweapon/spear
				backl = /obj/item/rogueweapon/shield/tower/zyb
			if("Axe and Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)	//lets see if people pick it!
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
				backl = /obj/item/rogueweapon/shield/tower/zyb

	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal
	beltl = /obj/item/rogueweapon/scabbard/sword
	l_hand = /obj/item/rogueweapon/sword/sabre/shamshir

	H.merctype = 4

/datum/advclass/mercenary/desert_rider/zeybek
	name = "Desert Rider Zeybek"
	tutorial = "Zybantine 'Blade Dancers' are famed and feared the world over. Their expertise in blades both long and short is well known."
	outfit = /datum/outfit/job/roguetown/mercenary/desert_rider_zeybek
	traits_applied = list(TRAIT_DODGEEXPERT,TRAIT_DUALWIELDER)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/mercenary/desert_rider_zeybek/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Zybantine 'Blade Dancers' are famed and feared the world over. Their expertise in blades both long and short is well known."))
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/zyb
	neck = /obj/item/clothing/neck/roguetown/leather
	mask = /obj/item/clothing/mask/rogue/facemask/ancient
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/zyb
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	gloves = /obj/item/clothing/gloves/roguetown/angle
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/zyb
	backr = /obj/item/storage/backpack/rogue/satchel/black
	l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
	id = /obj/item/clothing/neck/roguetown/shalal
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife/idagger/steel/kukri,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/flashlight/flare/torch,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	var/weapons = list("Shamshir and Javelin","Whips and Knives", "Recurve Bow")
	if(H.mind)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Shamshir and Javelin")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				backl = /obj/item/quiver/javelin/iron
				beltl = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Whips and Knives")	///They DO enslave people after all
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/whip
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("Recurve Bow")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltl = /obj/item/quiver/arrows
				beltr = /obj/item/rogueweapon/scabbard/sword
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal


	H.merctype = 4

/datum/advclass/mercenary/desert_rider/almah
	name = "Desert Rider Almah"
	tutorial = "Almah are those skilled in both magyck and swordsmanship, but excelling in nothing."
	outfit = /datum/outfit/job/roguetown/mercenary/desert_rider_almah
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_WARMAGE)
	traits_applied = list(TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_PER = -1
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/desert_rider_almah
	var/subclass_selected

/datum/outfit/job/roguetown/mercenary/desert_rider_almah/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/mercenary/desert_rider_almah/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/zyb
	neck = /obj/item/clothing/neck/roguetown/gorget/copper
	mask = /obj/item/clothing/mask/rogue/facemask/copper
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/zyb
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
	gloves = /obj/item/clothing/gloves/roguetown/angle
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/zyb
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/clothing/neck/roguetown/shalal
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife/idagger/steel/kukri,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/flashlight/flare/torch,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/spellbook/greater
		)
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "almah")
	H << browse(selection_html, "window=spellblade_chant;size=1100x900")
	onclose(H, "spellblade_chant", src)

	var/open_time = world.time
	while(!subclass_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellblade_chant")

	if(!subclass_selected)
		subclass_selected = "blade"

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = subclass_selected

	if(H.mind)
		switch(subclass_selected)
			if("blade")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
				H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
				H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/blade_storm)
			if("phalangite")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
				H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
				H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			if("macebearer")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter)
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
				H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)

		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

	switch(subclass_selected)
		if("blade")
			var/blade_weapons = list("Dual Shamshirs", "Shalal sabre & Shield")
			var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in blade_weapons
			switch(weapon_choice)
				if("Dual Shamshirs")
					ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
					r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
					l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
					beltl = /obj/item/rogueweapon/scabbard/sword
					beltr = /obj/item/rogueweapon/scabbard/sword
				if("Shalal sabre & Shield")
					r_hand = /obj/item/rogueweapon/sword/long/marlin
					beltr = /obj/item/rogueweapon/scabbard/sword
					backl = /obj/item/rogueweapon/shield/tower/metal
		if("phalangite")
			var/polearm_weapons = list("Spear", "Dory & Shield")
			var/polearm_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in polearm_weapons
			switch(polearm_choice)
				if("Spear")
					r_hand = /obj/item/rogueweapon/spear
					backl = /obj/item/rogueweapon/scabbard/gwstrap
				if("Dory & Shield")
					r_hand = /obj/item/rogueweapon/spear/spellblade
					backl = /obj/item/rogueweapon/shield/tower/metal
		if("macebearer")
			var/mace_weapons = list("Steel Mace", "Steel Warhammer & Shield", "Grand Mace", "Battle Axe", "Steel Greataxe")
			var/mace_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in mace_weapons
			var/picked_axe = FALSE
			switch(mace_choice)
				if("Steel Mace")
					r_hand = /obj/item/rogueweapon/mace/steel
				if("Steel Warhammer & Shield")
					r_hand = /obj/item/rogueweapon/mace/warhammer/steel
					backl = /obj/item/rogueweapon/shield/tower/metal
				if("Grand Mace")
					r_hand = /obj/item/rogueweapon/mace/goden/steel
					backl = /obj/item/rogueweapon/scabbard/gwstrap
				if("Battle Axe")
					r_hand = /obj/item/rogueweapon/stoneaxe/battle
					picked_axe = TRUE
				if("Steel Greataxe")
					r_hand = /obj/item/rogueweapon/greataxe/steel
					backl = /obj/item/rogueweapon/scabbard/gwstrap
					picked_axe = TRUE
			if(picked_axe)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
	H.merctype = 4
