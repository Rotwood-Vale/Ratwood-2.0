/datum/job/roguetown/baron_retainer
	title = "Retainer"
	flag = RETAINER
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_SOLDIER
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	always_show_on_latechoices = TRUE
	tutorial = "You hold the trust and responsibility of being the baron's closest confidant. You are tasked with protecting the baron and advising him on any matter he deems necessary. You enjoy the benefits of living in relative luxury and the status that comes with your position, although the higher nobility of the keep look down on you as a minor functionary."
	display_order = JDO_RETAINER
	whitelist_req = FALSE
	outfit = /datum/outfit/job/roguetown/baron_retainer
	advclass_cat_rolls = list(CTAG_RETAINER = 20)
	give_bank_account = 30
	min_pq = 15
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	social_rank = SOCIAL_RANK_YEOMAN
	job_subclasses = list(/datum/advclass/baron_retainer/henchman, /datum/advclass/baron_retainer/ronin, /datum/advclass/baron_retainer/greyleaf)

/datum/outfit/job/roguetown/baron_retainer
	job_bitflag = BITFLAG_GARRISON
	belt = /obj/item/storage/belt/rogue/leather/black
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison

/datum/advclass/baron_retainer/henchman
	name = "Henchman"
	tutorial = "A brute to back up the baron whenever needed, actions speak louder than words and you are the embodiment of this saying."
	outfit = /datum/outfit/job/roguetown/baron_retainer/henchman
	category_tags = list(CTAG_RETAINER)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(STATKEY_STR = 3, STATKEY_CON = 2, STATKEY_WIL = 3)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/baron_retainer/henchman/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	cloak = /obj/item/clothing/cloak/tabard/retinue/baronycloak
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	neck = /obj/item/clothing/neck/roguetown/bevor
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backpack_contents = list(/obj/item/roguekey/baron = 1, /obj/item/storage/keyring/baronretainer = 1, /obj/item/flashlight/flare/torch/lantern = 1, /obj/item/rogueweapon/huntingknife/idagger/steel = 1, /obj/item/rogueweapon/scabbard/sheath = 1, /obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,)
	H.verbs |= list(/mob/proc/haltyell)
	if(H.mind)
		var/weapons = list("Polearm", "Bludgeon", "Grand Mace", "Sword & Shield", "Flail & Shield", "Greatsword")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Polearm")
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			if("Bludgeon")
				r_hand = /obj/item/rogueweapon/mace/maul
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("Grand Mace")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("Sword & Shield")
				r_hand = /obj/item/rogueweapon/sword
				l_hand = /obj/item/rogueweapon/shield/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			if("Flail & Shield")
				r_hand = /obj/item/rogueweapon/flail/sflail
				l_hand = /obj/item/rogueweapon/shield/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			if("Greatsword")
				r_hand = /obj/item/rogueweapon/greatsword/grenz
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)

/datum/advclass/baron_retainer/ronin
	name = "Ronin"
	tutorial = "A blooded member of the infamous Ruma Clan, the baron has offered you an opportunity to prove the loyalty and honor demanded of you by serving him. (This subclass requires the Kazengun origin)"
	outfit = /datum/outfit/job/roguetown/baron_retainer/ronin
	category_tags = list(CTAG_RETAINER)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(STATKEY_STR = 1, STATKEY_PER = 1, STATKEY_SPD = 4, STATKEY_WIL = 2)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
	)

// Ronin subclass requires the character to be from Kazengun
/datum/advclass/baron_retainer/ronin/check_requirements(mob/living/carbon/human/H)
	if(!istype(H.client?.prefs?.origin, /datum/origin/kazengun))
		return FALSE
	return ..()

/datum/outfit/job/roguetown/baron_retainer/ronin/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	head = /obj/item/clothing/head/roguetown/helmet/kettle/jingasa
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/haraate
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/easttats
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun
	cloak = /obj/item/clothing/cloak/eastcloak1
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/kote
	neck = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun
	r_hand = /obj/item/rogueweapon/sword/sabre/mulyeog/rumacaptain
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
	beltr = /obj/item/rogueweapon/scabbard/sheath/kazengun
	backl = /obj/item/rogueweapon/scabbard/sword/kazengun/gold
	backpack_contents = list(/obj/item/roguekey/baron = 1, /obj/item/storage/keyring/baronretainer = 1, /obj/item/flashlight/flare/torch/lantern = 1)

/datum/outfit/job/roguetown/baron_retainer/ronin/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/masks = list("Full Mask","Half-Mask")
	var/mask_choice = input(H, "Choose your mask.", "GREET THE SUN?") as anything in masks
	switch(mask_choice)
		if("Full Mask")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun/full, SLOT_WEAR_MASK, TRUE)
		if("Half-Mask")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun, SLOT_WEAR_MASK, TRUE)

/datum/advclass/baron_retainer/greyleaf
	name = "Greyleaf"
	tutorial = "Honorably discharged from the warden corps, you have found new purpose in protecting the baron from the shadows and advising him on matters of Lowtown as someone who has shed blood to protect it."
	outfit = /datum/outfit/job/roguetown/baron_retainer/greyleaf
	category_tags = list(CTAG_RETAINER)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_SURVIVAL_EXPERT, TRAIT_WOODWALKER, TRAIT_PERFECT_TRACKER)
	subclass_stats = list(STATKEY_STR = 1, STATKEY_SPD = 3, STATKEY_PER = 4)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/baron_retainer/greyleaf/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	beltl = /obj/item/rogueweapon/huntingknife/idagger/warden_machete
	backpack_contents = list(/obj/item/roguekey/baron = 1, /obj/item/storage/keyring/baronretainer = 1, /obj/item/flashlight/flare/torch/lantern = 1, /obj/item/rogueweapon/scabbard/sheath = 1)
	if(H.mind)
		var/helmets = list("Warden Bearskull", "Warden Goatskull", "Warden Wolfskull", "Studded Hood and Hound Mask")
		var/helmet_choice = input(H, "Choose your Outfit", "EQUIP THINESELF") as anything in helmets
		switch(helmet_choice)
			if("Warden Bearskull")
				head = /obj/item/clothing/head/roguetown/helmet/sallet/warden/bear
				mask = /obj/item/clothing/head/roguetown/roguehood/warden
				cloak = /obj/item/clothing/cloak/wardencloak
			if("Warden Goatskull")
				head = /obj/item/clothing/head/roguetown/helmet/sallet/warden/goat
				mask = /obj/item/clothing/head/roguetown/roguehood/warden
				cloak = /obj/item/clothing/cloak/wardencloak
			if("Warden Wolfskull")
				head = /obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf
				mask = /obj/item/clothing/head/roguetown/roguehood/warden
				cloak = /obj/item/clothing/cloak/wardencloak
			if("Studded Hood and Hound Mask")
				head = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
				mask = /obj/item/clothing/mask/rogue/facemask/steel/hound
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
			
		var/weapons = list("Crossbow", "Blackhorn Longbow", "Recurve Bow", "Slurbow")
		var/weapon_choice = input(H, "Choose your weapon", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Crossbow")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/poisonarrows
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
			if("Blackhorn Longbow")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden
				beltr = /obj/item/quiver/poisonarrows
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
			if("Recurve Bow")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/warden
				beltr = /obj/item/quiver/poisonarrows
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
			if("Slurbow")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
				beltr = /obj/item/quiver/bolts
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
