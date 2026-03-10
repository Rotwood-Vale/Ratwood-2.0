/datum/advclass/wretch/poacher
	name = "Poacher"
	tutorial = "You have rejected society and its laws, choosing life in the wilderness instead. Simple thieving highwayman or freedom fighter, you take from those who have and give to the have-nots. Fancy, how the latter includes yourself!"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/poacher
	cmode_music = 'sound/music/combat_poacher.ogg'
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_WOODSMAN, TRAIT_OUTDOORSMAN, TRAIT_SURVIVAL_EXPERT)
	// No straight upgrade to perception / speed to not stack one stat too high, but still stronger than MAA Skirm out of town.
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/slings = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_MASTER,
		//these people live in the forest so let's give them some peasant skills
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE, //Even Robin Hood knew how to read n write
	)

/datum/outfit/job/roguetown/wretch/poacher/pre_equip(mob/living/carbon/human/H)
	mask = /obj/item/clothing/mask/rogue/wildguard
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	backpack_contents = list(
		/obj/item/bait = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	if(H.mind)
		var/fashion = list("Cunning Archer", "Ruthless Hunter", "Unrelenting Beastslayer", "Disgraced Warden")
		var/fashion_choice = input(H, "Who are you todae? This is purely cosmetic.", "BE FASHIONABLE") as anything in fashion
		H.set_blindness(0)
		switch(fashion_choice)
			if("Cunning Archer") //Robin Hood-esque outfit with a funny hat and a green rain cloak.
				head = /obj/item/clothing/head/roguetown/archercap
				cloak = /obj/item/clothing/cloak/raincloak/green
			if("Ruthless Hunter") //Bloodborne-esque outfit with a longcoat and an oddly familiar hat.
				head = /obj/item/clothing/head/roguetown/duelhat
				cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
			if("Unrelenting Beastslayer") //Classic Poacher look with a dark green hood and a fur cloak.
				head = /obj/item/clothing/head/roguetown/roguehood/darkgreen
				cloak = /obj/item/clothing/cloak/raincloak/furcloak/darkgreen
			if("Disgraced Warden") //Warden's antlered shroud and warden's cloak. Marginally better protection but makes you look a lot more suspicious.
				head = /obj/item/clothing/head/roguetown/roguehood/poacher
				cloak = /obj/item/clothing/cloak/poachercloak
		var/weapons = list("Dagger", "Axe", "Cudgel")
		var/weapon_choice = input(H, "Choose your melee weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Dagger")
				beltr = /obj/item/rogueweapon/scabbard/sheath
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel //Poacher already has Expert in Knives, but as a compensation you get a steel-tier dagger, whereas with Axe and Cudgel you get iron-tier weapons.
			if("Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut
			if ("Cudgel")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
				beltr = /obj/item/rogueweapon/mace/cudgel
		var/rangedweapons = list("Recurve Bow", "Crossbow", "Sling")
		var/rangedweapon_choice = input(H, "Choose your ranged weapon.", "TAKE UP ARMS") as anything in rangedweapons
		switch(rangedweapon_choice)
			if("Recurve Bow")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 5, TRUE)
				beltl = /obj/item/quiver/arrows
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("Crossbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 5, TRUE)
				beltl = /obj/item/quiver/bolts
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if ("Sling")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, 5, TRUE)
				beltl = /obj/item/quiver/sling/iron
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
		wretch_select_bounty(H)
