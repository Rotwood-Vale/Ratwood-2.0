//Vaquero, but not merc. So, y'know, cool.
//Sailors, given the choice of two classes.
//Navigator, focused on survival skills.
//Castaway, focused on fancy footwork.
/datum/advclass/foreigner/nostromo
	name = "Etruscan Nostromo"
	tutorial = "Nostromo, a word torn from the common Etruscan tongue, butchered by Imperial. \
	The meaning it had is long since lost to the common man. You're neither swashbuckler nor romantic. For you are no hero. \
	To be branded 'Nostromo', is to lose your lot. To be known as one who prattles, rather than using their sword. \
	Perhaps you were a great captain? A joyous sailor, in better yils? \
	It hardly matters, now. Forge a new name."
	allowed_races = RACES_ALL_KINDS
	subclass_languages = list(/datum/language/etruscan)
	outfit = /datum/outfit/job/roguetown/adventurer/nostromo
	cmode_music = 'sound/music/combat_vaquero.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_GOODLOVER, TRAIT_INTELLECTUAL)//No dodge / crit resist slop. Zzz...
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_INT = 3
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,//Not much of a wrestler.
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,//SWIM, MORON.
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,//WORK THOSE LINES!!!!
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)

	extra_context = "This subclass provides the player with two loadouts. \
	Navigator: +2PER, JMAN swords. \
	Castaway: +1PER/WIL, JMAN lockpicking, T1 Bardic Inspiration."

/datum/outfit/job/roguetown/adventurer/nostromo/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/bardhat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/clothing/neck/roguetown/gorget
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
	belt = /obj/item/storage/belt/rogue/leather
	cloak = /obj/item/clothing/cloak/half/rider/red
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/rogueweapon/scabbard/sheath
	if(H.mind)
		var/nostromo_purpose = list("Navigator","Castaway")
		var/purpose_choice = input(H, "Choose your FAILING", "WHY THE PLANK") as anything in nostromo_purpose
		switch(purpose_choice)
			if("Navigator")
				H.change_stat(STATKEY_PER, 2)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)//No shield skill, since you're buckler reliant.
				r_hand = /obj/item/rogueweapon/sword/long/etruscan//You'd stolen this, probably. It's just a longsword reskin.
				beltl = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/buckler
				backpack_contents = list(
								/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
								/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
								/obj/item/flashlight/flare/torch = 1,
								)
			if("Castaway")
				var/datum/inspiration/I = new /datum/inspiration(H)
				I.grant_inspiration(H, bard_tier = BARD_T1)
				H.change_stat(STATKEY_PER, 1)
				H.change_stat(STATKEY_WIL, 1)
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, 3, TRUE)
				//You already know why...
				backr = /obj/item/rogue/instrument/flute
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero
				backpack_contents = list(
								/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
								/obj/item/lockpick = 1,
								/obj/item/flashlight/flare/torch = 1,
								/obj/item/rogueweapon/scabbard/sheath = 1
								)
