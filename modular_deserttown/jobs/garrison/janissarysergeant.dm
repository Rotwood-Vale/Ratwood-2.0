/datum/job/roguetown/janissarysergeant
	title = "Janissary Sergeant"// Googling terms Naqib seems to mean something like Captain and has a nice ring to it?
	flag = JANISSARYSERGEANT
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "You are the most experienced of the SULTAN's Soldiery, leading the Janissary in maintaining order and attending to threats and crimes below the PALACE's attention. \
				See to those under your command and fill in the gaps CATAPHRACTS leave in their wake. Obey the orders of your Marshal and the SULTAN."
	display_order = JDO_SERGEANT
	whitelist_req = TRUE
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN

	outfit = /datum/outfit/job/roguetown/janissarysergeant
	advclass_cat_rolls = list(CTAG_JANISSARYSERGEANT = 20)

	give_bank_account = 50
	min_pq = 6
	max_pq = null
	cmode_music = 'sound/music/combat_desert1.ogg'
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	job_subclasses = list(
		/datum/advclass/janissarysergeant/janissarysergeant
	)

/datum/outfit/job/roguetown/janissarysergeant
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/janissarysergeant/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, cloak_and_title_setup)), 50)

//All skills/traits are on the loadouts. All are identical. Welcome to the stupid way we have to make sub-classes...
/datum/outfit/job/roguetown/janissarysergeant
	neck = /obj/item/clothing/neck/roguetown/bevor
	head = /obj/item/clothing/head/roguetown/helmet/janissaryhelm
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/catcloak/jancap
	id = /obj/item/scomstone/garrison

/datum/advclass/janissarysergeant/janissarysergeant
	name = "Sergeant-at-Arms"
	tutorial = "You are the most experienced of the SULTAN's Soldiery, leading the Janissary in maintaining order and attending to threats and crimes below the PALACE's attention. \
				See to those under your command and fill in the gaps CATAPHRACTS leave in their wake. Obey the orders of your Marshal and the SULTAN."
	outfit = /datum/outfit/job/roguetown/janissarysergeant/janissarysergeant

	category_tags = list(CTAG_JANISSARYSERGEANT)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1, //Gets bow-skills, so give a SMALL tad of perception to aid in bow draw.
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = 4,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/axes = 3,
		/datum/skill/combat/whipsflails = 4,
		/datum/skill/combat/maces = 4,
		/datum/skill/combat/shields = 4,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/bows = 3,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/reading = 2,
		/datum/skill/misc/athletics = 5,	// We are basically identical to a regular MAA, except having better athletics to help us manage our order usage better
		/datum/skill/misc/riding = 1,
		/datum/skill/misc/tracking = 2,	//Decent tracking akin to Skirmisher.
	)

/datum/outfit/job/roguetown/janissarysergeant/janissarysergeant/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/focustarget)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/guard)
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardsergeant = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Rhomphaia","Whip & Shield","Glaive","Sabre & Crossbow")	//Bit more unique than footsman, you are a jack-of-all-trades + slightly more 'elite'.
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Rhomphaia")
				backl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/long/rhomphaia
				beltr = /obj/item/rogueweapon/mace/cudgel
			if("Whip & Shield")
				beltr = /obj/item/rogueweapon/flail/sflail
				backl = /obj/item/rogueweapon/shield/tower
			if("Glaive")
				r_hand = /obj/item/rogueweapon/halberd/glaive
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/mace/cudgel
			if("Sabre & Crossbow")
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				r_hand = /obj/item/rogueweapon/sword/sabre
				beltl = /obj/item/rogueweapon/scabbard/sword

/obj/item/clothing/cloak/catcloak/jancap
	name = "janissary sergeant's cloak"
	desc = "A most handsome cloak, of royal red, denoting the authority of a leader."
