/datum/advclass/mage
	name = "Sorcerer"
	tutorial = "Spellslingers are mages that focus on more potent spells, greater athleticism, and the art of the staff. Arcane Alchemists instead turned their studies to mixing magic and alchemy, the basics of medicine, and rely on creativity instead of arcane might."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/mage
	class_select_category = CLASS_CAT_MAGE
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T2)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 1,
	)
	subclass_spellpoints = 15
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/mage/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a learned mage and a scholar, having spent your life studying the arcane and its ways."))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/huntingknife
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/chalk = 1
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	if(H.age == AGE_OLD)
		H.mind?.adjust_spellpoints(6)
	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander4.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
	if(H.mind)
		var/weapons = list("Spellslinger","Arcane Alchemist")
		var/weapon_choice = input(H, "Choose your path.", "WHO ARE YOU?") as anything in weapons
		switch(weapon_choice)
			if("Arcane Alchemist")
				H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, 2, TRUE)
				H.change_stat("perception", 1)
				H.change_stat("intelligence", 1)
				ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
			if("Spellslinger")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 4, TRUE)
				H.mind?.adjust_spellpoints(6)
				ADD_TRAIT(H, TRAIT_ARCYNE_T3, TRAIT_GENERIC)
				H.change_stat("willpower", 2)

/datum/advclass/mage/spellblade
	name = "Valecaephan"
	tutorial = "You are an Valecaephan in common parlance, a Spellblade of the Azurean tradition. A hybrid melee warrior who channels arcyne momentum through combat. Build power with your weapon, then unleash it. Choose between three traditions: Blade (mobile swordsman with dashes and AoE), Phalangite (spear and shield - hold the line with thrusts and pushback), or Macebearer (blunt weapons - ground slams, charges, and shockwaves)."
	outfit = /datum/outfit/job/roguetown/adventurer/spellblade
	traits_applied = list(TRAIT_ARCYNE_T2)
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_spell_point_pools = list("utility" = 4)
	// Just give them Jman for all three schools they can go into
	// They are functionally crippled without abilities if they
	// Dip outside of their subclass
	// Non zero chance someone's gonna be bitching in Discord about this
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/spellblade
	var/subclass_selected

/datum/outfit/job/roguetown/adventurer/spellblade/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/adventurer/spellblade/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/bucklehat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/recipe_book/survival = 1)

	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "conventional")
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
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/caedo)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/air_strike)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/leyline_anchor)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/valean_phalanx)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/valean_javelin)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/advance)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/shatter)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/tremor)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/charge)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/cataclysm)

		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/recall_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/empower_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/bind_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)

	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	backr = /obj/item/rogueweapon/shield/wood

	switch(subclass_selected)
		if("blade")
			var/weapons = list("Longsword", "Rapier", "Sabre", "Arming Sword", "Shortsword", "Hwando", "Steel Dagger")
			var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
			beltr = /obj/item/rogueweapon/scabbard/sword
			switch(weapon_choice)
				if("Longsword")
					r_hand = /obj/item/rogueweapon/sword/long
				if("Rapier")
					r_hand = /obj/item/rogueweapon/sword/rapier
				if("Sabre")
					r_hand = /obj/item/rogueweapon/sword/sabre
				if("Arming Sword")
					r_hand = /obj/item/rogueweapon/sword
				if("Shortsword")
					r_hand = /obj/item/rogueweapon/sword/short
				if("Hwando")
					r_hand = /obj/item/rogueweapon/sword/sabre/mulyeog
					armor = /obj/item/clothing/suit/roguetown/armor/basiceast
				if("Steel Dagger")
					beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
			if(weapon_choice == "Steel Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("phalangite")
			var/spear_weapons = list("Spear", "Dory", "Naginata")
			var/spear_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in spear_weapons
			switch(spear_choice)
				if("Spear")
					r_hand = /obj/item/rogueweapon/spear
				if("Dory")
					r_hand = /obj/item/rogueweapon/spear/spellblade
				if("Naginata")
					r_hand = /obj/item/rogueweapon/spear/naginata
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					armor = /obj/item/clothing/suit/roguetown/armor/basiceast
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("macebearer")
			var/mace_weapons = list("Mace", "Warhammer")
			var/mace_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in mace_weapons
			switch(mace_choice)
				if("Mace")
					r_hand = /obj/item/rogueweapon/mace
				if("Warhammer")
					r_hand = /obj/item/rogueweapon/mace/warhammer
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)

	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/mage/spellsinger
	name = "Spellsinger"
	tutorial = "You belong to a school of bards renowned for their study of both the arcane and the arts."
	outfit = /datum/outfit/job/roguetown/adventurer/spellsinger
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T2, TRAIT_EMPATH, TRAIT_GOODLOVER)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
	)
	subclass_spellpoints = 10
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)
/datum/outfit/job/roguetown/adventurer/spellsinger/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You belong to a school of bards renowned for their study of both the arcane and the arts."))
	head = /obj/item/clothing/head/roguetown/spellcasterhat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/councillor
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/sabre
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T2)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mockery)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/conjure_weapon)
	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
	if(H.mind)
		var/weapons = list("Accordion","Bagpipe", "Banjo","Drum","Flute","Guitar","Harmonica","Harp","Hurdy-Gurdy","Jaw Harp","Lute","Psyaltery","Shamisen","Trumpet","Viola","Vocal Talisman")
		var/weapon_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", weapons)
		H.set_blindness(0)
		switch(weapon_choice)
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Bagpipe")
				backr = /obj/item/rogue/instrument/bagpipe
			if("Banjo")
				backr = /obj/item/rogue/instrument/banjo
			if("Drum")
				backr = /obj/item/rogue/instrument/drum
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Harmonica")
				backr = /obj/item/rogue/instrument/harmonica
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Jaw Harp")
				backr = /obj/item/rogue/instrument/jawharp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Shamisen")
				backr = /obj/item/rogue/instrument/shamisen
			if("Trumpet")
				backr = /obj/item/rogue/instrument/trumpet
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals

/datum/advclass/mage/spellthief
	name = "Arcane Trickster"
	tutorial = "Some Rogues enhance their fine-honed skills of stealth and agility with spells, learning magical tricks to aid them in their trade. Some use their talents as pickpockets and burglars, while others are pranksters."
	outfit = /datum/outfit/job/roguetown/adventurer/spellthief
	subclass_social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'

	traits_applied = list(TRAIT_ARCYNE_T2, TRAIT_DODGEEXPERT, TRAIT_LIGHT_STEP) //dodge expert has the potential for being a big pain on spellcasters,  so we take away their mage armor as a trade.
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 2,
	)

	subclass_spellpoints = 12

	subclass_skills = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE, //let's encourage bonking people on the head rogues don't do it enough
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER, //not as cracked as full rogue
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE, //reading for robbers
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/spellthief/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Some Rogues enhance their fine-honed skills of stealth and agility with spells, learning magical tricks to aid them in their trade. Some use their talents as pickpockets and burglars, while others are pranksters."))
	head = /obj/item/clothing/head/roguetown/witchhat //you can tell they're a spellthief by the pointy hat!
	mask = /obj/item/clothing/mask/rogue/shepherd //to stay sneaky while wearing a pointy hat
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	backl = /obj/item/storage/backpack/rogue/satchel //backpack remains thief's special sauce
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather //no knifebelt, you can shoot magic n shit
	beltr = /obj/item/rogueweapon/mace/cudgel //sovlful -1 STR mace gaming. pray to xylix for thine knockout crit, sire
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife/idagger = 1, //take conjure weapon if you want a fancy dagger
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mockery) //it's back. if they become op feintmeisters remove this
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/lesserknock) //they're a magic thief. i mean come on
