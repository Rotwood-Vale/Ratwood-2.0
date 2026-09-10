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
	job_subclasses = list(/datum/advclass/baron_retainer/henchman, /datum/advclass/baron_retainer/duelist, /datum/advclass/baron_retainer/greyleaf)

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

/datum/advclass/baron_retainer/duelist
	name = "Retired Duelist"
	tutorial = "You flicked, you feinted, you pirouetteed and striked - a mastery of the blade at a rapier's edge. But the age of firearms came, and a crippling musket round to the knee ended your career. The Baron offered you a place in his service - perhaps, in due time, you can relive your glory daes."
	outfit = /datum/outfit/job/roguetown/baron_retainer/duelist
	category_tags = list(CTAG_RETAINER)
	traits_applied = list(TRAIT_DECEIVING_MEEKNESS, TRAIT_COMBAT_AWARE) //That musket round really did a number on your dodging reflexes, but you can still strike true with the blade.
	subclass_stats = list(STATKEY_INT = 2, STATKEY_PER = 2, STATKEY_SPD = 3, STATKEY_WIL = 2, STATKEY_CON = -1) //4 speed was the most ridiculous thing anyone's ever added
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

/datum/outfit/job/roguetown/baron_retainer/duelist/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fencer
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	shoes = /obj/item/clothing/shoes/roguetown/boots/maille
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	gloves = /obj/item/clothing/gloves/roguetown/plate
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
	beltr = /obj/item/rogueweapon/scabbard/sheath/noble
	backl = /obj/item/rogueweapon/scabbard/sword/noble
	backpack_contents = list(/obj/item/roguekey/baron = 1, /obj/item/storage/keyring/baronretainer = 1, /obj/item/flashlight/flare/torch/lantern = 1)

/datum/outfit/job/roguetown/baron_retainer/duelist/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("La Bête (Excutioner)", "El Hombre (Basket-Hilted Longsword)", "El Zorro (Rapier)", "AAVNIK (Shishka Sabre)", "Mubarizun (Shalal)", "Das Schwertkämpfer (Kriegsmesser)")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("La Bête (Excutioner)")
			r_hand = /obj/item/rogueweapon/sword/long/exe
			mask = /obj/item/clothing/mask/rogue/sack
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_SPD, -2)
		if("El Hombre (Basket-Hilted Longsword)")
			r_hand = /obj/item/rogueweapon/sword/long/etruscan
			cloak = /obj/item/clothing/cloak/duelistcape
			head = /obj/item/clothing/head/roguetown/duelisthat
		if("El Zorro")
			r_hand = /obj/item/rogueweapon/sword/rapier/vaquero
			mask = /obj/item/clothing/mask/rogue/duelmask
			cloak = /obj/item/clothing/cloak/duelistcape
			head = /obj/item/clothing/head/roguetown/duelisthat
		if("AAVNIK (Shishka Sabre)")
			r_hand = /obj/item/rogueweapon/sword/sabre/steppesman
			l_hand = /obj/item/rogueweapon/shield/buckler
			mask = /obj/item/clothing/mask/rogue/facemask/steel/steppesman
			head = /obj/item/clothing/head/roguetown/papakha
			cloak = /obj/item/clothing/cloak/raincloak/furcloak
		if("Mubarizun (Shalal)")
			r_hand = /obj/item/rogueweapon/sword/long/marlin
			cloak = /obj/item/clothing/cloak/cape/purple
			head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/zyb
		if("Das Schwertkämpfer (Kriegsmesser)")
			r_hand = /obj/item/rogueweapon/sword/long/kriegmesser
			head = /obj/item/clothing/head/roguetown/caplessgrenzelhofthat
			cloak = /obj/item/clothing/cloak/stabard/grenzelhoft

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
