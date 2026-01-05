//Carries the ducal standard.
//When carrying it, he's granted a few unique traits.
//Bonuses, relaying location, etc.
//The stats are middling, as a result. Really bad, honestly.
//No armour trait, but gets crit resist. STAY STANDING!!!
/datum/advclass/manorguard/standard_bearer
	name = "Standard Bearer"
	tutorial = "You're the sergeant's second, entrusted with the keep's standard when you sally out into battle. \
	Your fellow soldiers know to rally around you, should you keep it safe."
	outfit = /datum/outfit/job/roguetown/manorguard/standard_bearer
	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_STANDARD_BEARER)
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,//You're on a budget here, buddy! Stab sure, stab often!
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,//SWING THAT THING.
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,//OR THOSE ARMS, I GUESS.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	maximum_possible_slots = 1//Haha... no... unless...?

/datum/outfit/job/roguetown/manorguard/standard_bearer/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	pants = /obj/item/clothing/under/roguetown/splintlegs
	r_hand = /obj/item/rogueweapon/spear/keep_standard
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.verbs |= /mob/proc/haltyell

//These are really hacky, but it works.
//One proc to moodbuff.
/mob/proc/standard_position()
	set name = "PLANT"
	set category = "Standard"
	emote("standard_position", intentional = TRUE)
	stamina_add(rand(15,35))

/datum/emote/living/standard_position
	key = "standard_position"
	message = "plants the standard!"
	emote_type = EMOTE_VISIBLE
	show_runechat = TRUE

/datum/emote/living/standard_position/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(do_after(user, 8 SECONDS))//SCORE SOME GOALS!!!
		playsound(user.loc, 'sound/combat/shieldraise.ogg', 100, FALSE, -1)
		if(.)
			for(var/mob/living/carbon/human/L in viewers(7,user))
				if(HAS_TRAIT(L, TRAIT_GUARDSMAN))
					to_chat(L, span_monkeyhive("The standard calls out to me!"))
					L.add_stress(/datum/stressevent/keep_standard_lesser)

//Another to call out.
/mob/proc/standard_rally()
	set name = "RALLY"
	set category = "Standard"
	emote("standard_rally", intentional = TRUE)
	stamina_add(rand(15,35))

/datum/emote/living/standard_rally
	key = "standard_rally"
	message = "plants the standard!"
	emote_type = EMOTE_VISIBLE
	show_runechat = TRUE

//This is also SUPER hacky and GROSS.
//It makes use of loud message, effectively, just gutted.
/datum/emote/living/standard_rally/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(do_after(user, 8 SECONDS))//COME ON!!!
		playsound(user.loc, 'sound/combat/shieldraise.ogg', 100, FALSE, -1)
		if(.)
			for(var/mob/living/carbon/human/L in orange(75,user))
				if(HAS_TRAIT(L, TRAIT_GUARDSMAN))
					var/strz
					var/strdir
					if(L.z != user.z)
						var/zdiff = abs(L.z - user.z)
						if(L.z > user.z)
							switch(zdiff)
								if(1)
									strz = "below"
								if(2 to 999)
									strz = "far below"
						if(L.z < user.z)
							switch(zdiff)
								if(1)
									strz = "above"
								if(2 to 999)
									strz = "far above"
					var/dir = get_dir(L, user)
					strdir = dir2text(dir)
					var/fullmsg = span_warning("The standard shrieks, pulling at my mind from [strz ? "<b>[strz]</b>" : ""][strdir ? "[strz ? " and " : ""]<b>[strdir]</b>" : ""].")
					to_chat(L, fullmsg)
