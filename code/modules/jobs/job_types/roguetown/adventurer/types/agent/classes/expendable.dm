/datum/advclass/agent/expendable
	name = "Expendable Pawn"
	tutorial = "You are nothing but a tool, an asset.. A single mistake could lead to you being dropped in a ditch for the zad's to peck at.. After all your hard work, you have proven yourself as a capable asset, one that can earn quite the pay at the cost of your lyfe.. Compromise your identity and you may just be left to rot in a dungeon like a typical petty criminal.. You may not be the most skilled agent, but you are still a capable goon.."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES
	outfit = /datum/outfit/job/roguetown/agent/expendable
	class_select_category = CLASS_CAT_FERENTIA
	category_tags = list(CTAG_COURTAGENT)
	cmode_music = 'sound/music/templarofpsydonia.ogg'
	traits_applied = list(TRAIT_DARKVISION, TRAIT_DODGEEXPERT, TRAIT_SLEUTH)
	subclass_languages = list(/datum/language/thievescant)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_SPD = 2
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, 
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)
	
/datum/outfit/job/roguetown/agent/expendable/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/classes = list("Protecter", "Bruiser", "Hitman")
		var/classchoice = input(H, "Choose your class.", "What is your specialty?") as anything in classes
		switch(classchoice)
			if("Hitman")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
				beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
				beltr = /obj/item/quiver/bolts
				belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/steel
				neck = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
				cloak = /obj/item/clothing/suit/roguetown/armor/longcoat/white
				backr = /obj/item/storage/backpack/rogue/satchel/black
				gloves = /obj/item/clothing/gloves/roguetown/angle
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/white
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				backpack_contents = list(
					/obj/item/roguekey/mercenary = 1,
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
					/obj/item/rogueweapon/huntingknife/idagger/steel/rondel = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/lockpickring/mundane = 1,
				)

			if("Bruiser")
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				REMOVE_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				ADD_TRAIT(H,TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_CON, 3)
				H.change_stat(STATKEY_SPD, -3)
				H.change_stat(STATKEY_PER, -2)
				H.change_stat(STATKEY_INT, -2)
				H.change_stat(STATKEY_WIL, 3)
				beltl = /obj/item/rogueweapon/stoneaxe/hurlbat
				beltr = /obj/item/rogueweapon/stoneaxe/hurlbat
				belt = /obj/item/storage/belt/rogue/leather/battleskirt/faulds/white
				neck = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
				cloak = /obj/item/clothing/suit/roguetown/armor/longcoat/white
				backr = /obj/item/storage/backpack/rogue/satchel/black
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/white
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
				backpack_contents = list(
							/obj/item/roguekey/mercenary = 1,
							/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
							/obj/item/rogueweapon/huntingknife/idagger/steel/rondel = 1,
							/obj/item/rogueweapon/scabbard/sheath = 1,
							/obj/item/lockpick = 1,
						)
				var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff")
				var/technique_choice = input(H, "Choose your TECHNIQUE.", "TOSS THEM.") as anything in techniques
				switch(technique_choice)
					if("Dropkick - Pushback + Extra Damage")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
					if("Chokeslam - Stamina Damage")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
					if("Stunner - Dazed Debuff")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
					if("Headbutt - Vulnerable Debuff")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
			if("Protector")
				ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
				REMOVE_TRAIT(H, TRAIT_DODGEEXPERT, GENERIC)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_EXP_JOURNEYMAN, TRUE)
				H.change_stat(STATKEY_SPD,-2)
				H.change_stat(STATKEY_WIL, 2)
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_INT, -1)
				beltl = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long
				belt = /obj/item/storage/belt/rogue/leather/battleskirt/faulds/white
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half
				cloak = /obj/item/clothing/suit/roguetown/armor/longcoat/white
				backr = /obj/item/storage/backpack/rogue/satchel/black
				backl = /obj/item/rogueweapon/shield/tower/metal
				gloves = /obj/item/clothing/gloves/roguetown/plate
				pants = /obj/item/clothing/under/roguetown/chainlegs
				head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/white
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				backpack_contents = list(
					/obj/item/roguekey/mercenary = 1,
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
					/obj/item/rogueweapon/huntingknife/idagger/steel/rondel = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/lockpickring/mundane = 1,
				)

/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/white
	color = CLOTHING_WHITE
/obj/item/storage/belt/rogue/leather/battleskirt/faulds/white
	color = CLOTHING_WHITE
/obj/item/clothing/suit/roguetown/armor/longcoat/white
	color = CLOTHING_WHITE
