/datum/advclass/pilgrim/levy
	name = "Levy"
	tutorial = "A peasant pressed into the Duchy's service as a temporary watchman. Given a padded coat, a simple weapon, and just enough training to stand in the line, you are expected to protect the town until you're sent home—or don't go home at all."
	outfit = /datum/outfit/job/roguetown/adventurer/levy
	category_tags = list(CTAG_TOWNER)
	traits_applied = list(TRAIT_GUARDSMAN)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	maximum_possible_slots = 3
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	extra_context = "Weaker stats and equipment, but gains a variety of skill selections through your former trade and choice of militia weaponry."
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/slings = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
	)
/datum/outfit/job/roguetown/adventurer/levy
	name = "Levy"
	cloak = /obj/item/clothing/cloak/stabard/surcoat/guard
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	beltl = /obj/item/rogueweapon/mace/cudgel
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	pants = /obj/item/clothing/under/roguetown/tights/random
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guard/levy = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
	)

/datum/outfit/job/roguetown/adventurer/levy/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	if(H.mind)
		// Helmet selection
		var/helmets = list(
			"Iron Sallet" = /obj/item/clothing/head/roguetown/helmet/sallet/iron,
			"Horned Cap" = /obj/item/clothing/head/roguetown/helmet/horned,
			"Iron Kettle Helmet" = /obj/item/clothing/head/roguetown/helmet/kettle/iron,
			"Skull Cap" = /obj/item/clothing/head/roguetown/helmet/skullcap,
			"None"
		)
		var/helmchoice = input(H, "Choose your helmet.", "HEAD PROTECTION") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		// Trade selection
		var/trades = list("Physician","Woodsman","Artisan","Knave")
		var/trade_choice = input(H, "Choose your former trade.", "WHO ARE YOU?") as anything in trades

		switch(trade_choice)
			if("Physician")
				// Medical and healing expertise
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_JOURNEYMAN, TRUE)
				// Housekeeping and support skills
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				if(H.mind)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
				ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)

			if("Woodsman")
				// Survival and wilderness expertise
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/traps, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/tracking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_JOURNEYMAN, TRUE)
				// Housekeeping and practical skills
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
				ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)

			if("Artisan")
				// Crafting and building expertise
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_JOURNEYMAN, TRUE)
				// Broader craft skills
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_APPRENTICE, TRUE)
				ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)

			if("Knave")
				// Roguish and street skills expertise
				H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
				ADD_TRAIT(H, TRAIT_SEEPRICES_SHITTY, TRAIT_GENERIC)

		// Weapon selection
		var/weapons = list("Militia Spear","Militia Goedendag","Militia Falchion","Militia Warpick","Militia Steel Warpick","Militia War Axe","Militia Flail","Peasant War Flail")
		var/weapon_choice = input(H, "Choose your militia weapon.", "WHAT DO YOU FIGHT WITH?") as anything in weapons
		H.set_blindness(0)

		switch(weapon_choice)
			if("Militia Spear")
				r_hand = /obj/item/rogueweapon/spear/militia
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Militia Goedendag")
				r_hand = /obj/item/rogueweapon/woodstaff/militia
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Militia Falchion")
				r_hand = /obj/item/rogueweapon/sword/falchion/militia
				beltr = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Militia Steel Warpick")
				r_hand = /obj/item/rogueweapon/pick/militia/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Militia War Axe")
				r_hand = /obj/item/rogueweapon/greataxe/militia
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Militia Flail")
				r_hand = /obj/item/rogueweapon/flail/militia
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Peasant War Flail")
				r_hand = /obj/item/rogueweapon/flail/peasantwarflail
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
