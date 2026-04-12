// In exchange for martial skills beyond ranged, they can now set traps, too.
/datum/advclass/janissary/jezail
	name = "Janissary Jezail"
	tutorial = "You are a professional soldier of the realm, specializing in ranged implements. You sport a keen eye, looking for your enemies weaknesses."
	outfit = /datum/outfit/job/roguetown/janissary/jezail

	maximum_possible_slots = 2//One always tells the truth, the other only lies. Guess wrong and they both shoot you.

	category_tags = list(CTAG_JANISSARY)
	//Garrison ranged/speed class. Time to go wild
	subclass_stats = list(
		STATKEY_SPD = 1,// probably objectively worse stats than skirmisher but the price ye pay
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
		traits_applied = list(TRAIT_DODGEEXPERT)
		)

	subclass_skills = list(
		/datum/skill/combat/firearms = 5,//Your entire point is GUN.
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/slings = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/maces = 3,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/whipsflails = 3,
		/datum/skill/misc/climbing = 3,//not as acrobatic
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/tracking = 3,
		/datum/skill/craft/engineering = 1,//know how your gun works
	)

/datum/outfit/job/roguetown/janissary/jezail/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	pants = /obj/item/clothing/under/roguetown/splintlegs
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	head = /obj/item/clothing/head/roguetown/helmet/janissaryhelm
	beltr = /obj/item/quiver/bullet/lead//nice to have variety but blunderbus might not fit the vibe
	r_hand = /obj/item/gun/ballistic/firearm/arquebus
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/powderflask,
		/obj/item/impact_grenade/smoke/blind_gas,
		)

	H.adjust_blindness(-3)
	if(H.mind)
		// var/weapons = list("Long Rifle","Blunderbuss")
		// var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		// switch(weapon_choice)
		// 	if("Long Rifle")
		// 		beltr = /obj/item/quiver/bullet/lead
		// 		r_hand = /obj/item/gun/ballistic/firearm/arquebus
		// 	if("Blunderbuss") 
		// 		beltr = /obj/item/quiver/bullet/grapeshot
		// 		r_hand = /obj/item/gun/ballistic/firearm/blunderbuss
				
		var/weapons2 = list("Scimitar","Whip","Club")
		var/weapon_choice2 = input(H, "Choose your sidearm.", "TAKE UP ARMS") as anything in weapons2
		switch(weapon_choice2)
			if("Scimitar")
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/saber/iron
			if("Whip") 
				beltl = /obj/item/rogueweapon/whip
			if("Club")
				beltl = /obj/item/rogueweapon/mace/cudgel
		H.verbs |= /mob/proc/haltyell
