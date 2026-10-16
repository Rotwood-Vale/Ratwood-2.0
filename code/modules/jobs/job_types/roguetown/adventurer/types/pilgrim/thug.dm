/datum/advclass/goon
	name = "Goon"
	tutorial = "You're a goon, a low-lyfe thug in a painful world - not good enough for war, not smart enough for peace. What you lack in station you make up for in daring."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	subclass_social_rank = SOCIAL_RANK_PEASANT
	category_tags = list(CTAG_THUGA, CTAG_THUGB)
	outfit = /datum/outfit/job/roguetown/adventurer/thug/goon
	subclass_languages = list(/datum/language/thievescant)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = -1,
		STATKEY_INT = -1,
	)
	
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE, 
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE, 
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE, 
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE, 
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/mining = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/thug/goon/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/options = list("The Brawler (Bronze Knuckles)", "The Cutthroat (Navaja)", "The Enforcer (Cudgel)")
		var/option_choice = input(H, "Choose your intimidation way.", "WHAT KIND OF A GOON ARE YOU?") as anything in options
		
		switch(option_choice)
			if("The Brawler (Bronze Knuckles)")
				r_hand = /obj/item/rogueweapon/knuckles/bronzeknuckles
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("The Cutthroat (Navaja)")
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/navaja
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("The Enforcer (Cudgel)")
				r_hand = /obj/item/rogueweapon/mace/cudgel
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
	if(HAS_TRAIT(H, TRAIT_GANG_A))
		H.playsound_local(get_turf(H), 'sound/music/area/spawnrontzratz.ogg', 60, FALSE, pressure_affected = FALSE)
	else
		H.playsound_local(get_turf(H), 'sound/music/area/spawnblortzvolves.ogg', 60, FALSE, pressure_affected = FALSE)

/datum/advclass/miscreant
	name = "Miscreant"
	tutorial = "You're smarter than the rest, by a stone's throw - and you know better than to get up close and personal. Unlike most others, you can read."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	subclass_social_rank = SOCIAL_RANK_PEASANT
	category_tags = list(CTAG_THUGA, CTAG_THUGB)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	outfit = /datum/outfit/job/roguetown/adventurer/thug/miscreant
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_NUTCRACKER, TRAIT_CICERONE)
	subclass_stats = list(
		STATKEY_CON = -2,
		STATKEY_SPD = 2,
		STATKEY_INT = 1,
		STATKEY_FOR = 1,
	)

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
	)
/datum/outfit/job/roguetown/adventurer/thug/miscreant/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/options = list("Stone Sling", "Magic Bricks", "Lockpicking Equipment")
		var/option_choice = input(H, "Choose your means.", "TAKE UP ARMS") as anything in options

		switch(option_choice)
			if("Stone Sling")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
				l_hand = /obj/item/quiver/sling
			if("Magic Bricks")
				H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE)
				H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/magicians_brick)
				ADD_TRAIT(H, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
			if("Lockpicking Equipment")
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_EXPERT, TRUE)
				ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
				r_hand = /obj/item/lockpickring/mundane
	if(HAS_TRAIT(H, TRAIT_GANG_A))
		H.playsound_local(get_turf(H), 'sound/music/area/spawnrontzratz.ogg', 60, FALSE, pressure_affected = FALSE)
	else
		H.playsound_local(get_turf(H), 'sound/music/area/spawnblortzvolves.ogg', 60, FALSE, pressure_affected = FALSE)

/datum/advclass/muscle
	name = "Muscle"
	tutorial = "More akin to a corn-fed monster than a normal man, your size and strength are your greatest weapons; though they hardly supplement what's missing of your brains."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	subclass_social_rank = SOCIAL_RANK_PEASANT
	category_tags = list(CTAG_THUGA, CTAG_THUGB)
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	outfit = /datum/outfit/job/roguetown/adventurer/thug/muscle
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_HARDDISMEMBER)

	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 3,
		STATKEY_CON = 4,
		STATKEY_SPD = -5,
		STATKEY_INT = -6,
		STATKEY_PER = -4,
		)
	
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		)

/datum/outfit/job/roguetown/adventurer/thug/muscle/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/options = list("Hands-On", "Big Axe", "Big Stick")
		var/option_choice = input(H, "Choose your means.", "TAKE UP ARMS") as anything in options
		var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff") // cool wrestling moves
		var/technique_choice = input(H,"Choose your TECHNIQUE.", "TOSS THEM.") as anything in techniques

		switch(option_choice)
			if("Hands-On")
				ADD_TRAIT(H, TRAIT_BIGGUY, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			if("Big Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe
			if("Big Stick")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/mace

		switch(technique_choice)
			if("Dropkick - Pushback + Extra Damage")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
			if("Chokeslam - Stamina Damage")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
			if("Stunner - Dazed Debuff")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
			if("Headbutt - Vulnerable Debuff")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
	if(HAS_TRAIT(H, TRAIT_GANG_A))
		H.playsound_local(get_turf(H), 'sound/music/area/spawnrontzratz.ogg', 60, FALSE, pressure_affected = FALSE)
	else
		H.playsound_local(get_turf(H), 'sound/music/area/spawnblortzvolves.ogg', 60, FALSE, pressure_affected = FALSE)

/datum/advclass/longshoreman
	name = "Longshoreman"
	tutorial = "You answered Abyssor's call when you were young, though in troublesome ways, \
	pilaging for treasury from anyone who'd cross your path. Now your captain retires from a life of crime, \
	settling down as do you. Still, there is coin to be made on land."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	subclass_social_rank = SOCIAL_RANK_PEASANT
	category_tags = list(CTAG_THUGA, CTAG_THUGB)
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	outfit = /datum/outfit/job/roguetown/adventurer/thug/longshoreman
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_STEELHEARTED)
	
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = -1,
		STATKEY_INT = -1,
		STATKEY_FOR = -1, //If a sailor is on the land, something bad must've happened.
	)

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
	)
/datum/outfit/job/roguetown/adventurer/thug/longshoreman/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		head = /obj/item/clothing/head/roguetown/helmet/bandana
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
		pants = /obj/item/clothing/under/roguetown/trou/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
		r_hand = /obj/item/rogueweapon/sword/cutlass
		beltr = /obj/item/rogueweapon/scabbard/sword
		beltl = /obj/item/rogueweapon/huntingknife/idagger
	if(HAS_TRAIT(H, TRAIT_GANG_A))
		H.playsound_local(get_turf(H), 'sound/music/area/spawnrontzratz.ogg', 60, FALSE, pressure_affected = FALSE)
	else
		H.playsound_local(get_turf(H), 'sound/music/area/spawnblortzvolves.ogg', 60, FALSE, pressure_affected = FALSE)
