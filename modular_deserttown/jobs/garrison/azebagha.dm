/datum/job/roguetown/azebagha
	title = "Azeb Agha"
	flag = AZEBAGHA
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "An experienced soldier of the Sultan's Azeb Corp you have been tasked with overseeing the newly constructed border. \
				You report to the Royal Family and their sheikhs, \
				and your job is to keep the younger Janissaries in line and to ensure the routes to the city remain safe.\
				The Border must not fall."
	display_order = JDO_SERGEANT
	whitelist_req = TRUE
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN

	outfit = /datum/outfit/job/roguetown/azebagha
	advclass_cat_rolls = list(CTAG_AZEBAGHA = 20)

	give_bank_account = 50
	min_pq = 6
	max_pq = null
	cmode_music = 'sound/music/combat_hornofthebeast.ogg'
	job_traits = list(TRAIT_OUTDOORSMAN, TRAIT_WOODSMAN, TRAIT_SURVIVAL_EXPERT, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR, TRAIT_FUSILIER)
	job_subclasses = list(
		/datum/advclass/azebagha/azebagha
	)
/datum/outfit/job/roguetown/azebagha
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/azebagha/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(ishuman(L))
			if(istype(H.cloak, /obj/item/clothing/cloak/dunestalker))
				var/obj/item/clothing/S = H.cloak
				var/index = findtext(H.real_name, " ")
				if(index)
					index = copytext(H.real_name, 1,index)
				if(!index)
					index = H.real_name
				S.name = "Agha Cloak ([index])"

//All skills/traits are on the loadouts. All are identical. Welcome to the stupid way we have to make sub-classes...
/datum/outfit/job/roguetown/azebagha
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/agha
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	cloak = /obj/item/clothing/cloak/dunestalker
	neck = /obj/item/clothing/neck/roguetown/bevor
	shoes = /obj/item/clothing/shoes/roguetown/shalal/reinforced
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	id = /obj/item/scomstone/garrison

/datum/advclass/azebagha/azebagha
	name = "Sergeant-at-Arms"
	tutorial = "An experienced soldier of the Sultan's Azeb Corp you have been tasked with overseeing the newly constructed border. \
				You report to the Royal Family and their Councillors, \
				and your job is to keep the younger Janissaries in line and to ensure the routes to the city remain safe.\
				The Border must not fall."
	outfit = /datum/outfit/job/roguetown/azebagha/azebagha

	category_tags = list(CTAG_AZEBAGHA)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = 1,
		STATKEY_PER = 1, 
		STATKEY_CON = 1, 
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = 4,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/axes = 4,
		/datum/skill/combat/whipsflails = 4,
		/datum/skill/combat/maces = 4,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/shields = 4,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/bows = 4,
		/datum/skill/combat/firearms = 4,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/athletics = 5,	
		/datum/skill/misc/riding = 5,
		/datum/skill/misc/tracking = 4,	
	)

/datum/outfit/job/roguetown/azebagha/azebagha/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/focustarget)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/azeb)
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardsergeant = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/signal_horn = 1
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/primary = list("Scimitar","Shotel","Whip","Warden Axe")
		var/primary_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in primary
		var/secondary = list("Glaive","Javelins and Shield","Blackhorn Longbow","Handgonne")
		var/secondary_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in secondary
		H.set_blindness(0)
		switch(primary_choice)
			if("Scimitar")		
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
			if("Shotel")		
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/long/shotel
			if("Whip")	
				beltl = /obj/item/rogueweapon/whip/antique
			if("Warden Axe")	
				beltl = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick

		switch(secondary_choice)
			if("Glaive")			
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				l_hand = /obj/item/rogueweapon/halberd/glaive
			if("Javelins and Shield")	
				beltr = /obj/item/quiver/javelin/steel
				backl = /obj/item/rogueweapon/shield/iron/zybantine
			if("Blackhorn Longbow")
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden
			if("Handgonne")//okay I can remove this later but I think it would be... just... so based
				backl = /obj/item/gun/ballistic/firearm/handgonne
				r_hand = /obj/item/powderflask
				beltr = /obj/item/quiver/bullet/lead
