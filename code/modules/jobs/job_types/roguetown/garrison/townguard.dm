/datum/job/roguetown/guardsman
	title = "City Guard"
	flag = GUARDSMAN
	department_flag = GARRISON
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	selection_color = JCOLOR_SOLDIER
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED)
	tutorial = "Responsible for the safety of the city and the enforcement of the law, \
	you patrol the city streets, on the look out for crime and disorder. \
	Armed with chains and a trusty beating stick, you are charged with catching \
	thieves, vagrants and troublemakers, confiscating illicit goods, and administering swift and orderly justice.\
	Obey your Watch Captain's orders, and enforce the Marshal's laws"
	display_order = JDO_TOWNGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/guardsman
	advclass_cat_rolls = list(CTAG_WATCH = 20)

	give_bank_account = 20
	min_pq = 2
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_YEOMAN

	cmode_music = 'sound/music/combat_citywatch.ogg'

/datum/outfit/job/roguetown/guardsman
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/guardsman/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/citywatch))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "watchman halfcloak ([index])"

/datum/outfit/job/roguetown/guardsman
	neck = /obj/item/clothing/neck/roguetown/gorget
	pants = /obj/item/clothing/under/roguetown/chainlegs
	cloak = /obj/item/clothing/cloak/citywatch
	armor = /obj/item/clothing/suit/roguetown/armor/plate/citywatch
	head = /obj/item/clothing/head/roguetown/helmet/citywatch
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/chain
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/citywatch

	beltr = /obj/item/rogueweapon/mace/cudgel
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison

/datum/advclass/guardsman/cityguard
	name = "City Guard"
	tutorial = "Responsible for the safety of the city and the enforcement of the law, \
	you patrol the city streets, on the look out for crime and disorder. \
	Armed with chains and a trusty beating stick, you are charged with catching \
	thieves, vagrants and troublemakers, confiscating illicit goods, and administering swift and orderly justice.\
	While you may be called upon as members of the garrison by the Marshal and Crown, your true loyalty resides with the Watch Captain and the city."
	outfit = /datum/outfit/job/roguetown/guardsman/cityguard

	category_tags = list(CTAG_WATCH)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 1,//on the lookout for perps
	)
	subclass_skills = list(
		/datum/skill/combat/maces = 3,//They're serviceable with all weapons but I really don't want them to get expert outside of the weapons that fit them - blunt weapons are the role's identity. It's not their job to kill people.
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/axes = 3,
		/datum/skill/combat/whipsflails = 3,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 4,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/shields = 4,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/slings = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/swimming = 2,//moating practice
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/athletics = 4,//Chasin' suspects
		/datum/skill/misc/tracking = 3,//Looking for Clues
	)

/datum/outfit/job/roguetown/guardsman/cityguard/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Stunmace & Shield","Polehammer", "Maul - +STR/CON, -SPD/PER/INT", "Crossbow - +SPD/PER, -STR/CON")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Stunmace & Shield")
				r_hand = /obj/item/rogueweapon/mace/stunmace
				backl = /obj/item/rogueweapon/shield/iron/citywatch
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
			if("Polehammer")
				r_hand = /obj/item/rogueweapon/eaglebeak
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
			if("Maul - +STR/CON, -SPD/PER/INT")
				r_hand = /obj/item/rogueweapon/mace/maul
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_SPD, -1)
				H.change_stat(STATKEY_PER, -1)
				H.change_stat(STATKEY_INT, -1)
			if("Crossbow - +SPD/PER, -STR/CON")
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				backl = /obj/item/quiver/bolts
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 5, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_STR, -1)

		backpack_contents = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
			/obj/item/rope/chain = 1,
			/obj/item/storage/keyring/guardcastle = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			)

	H.verbs |= /mob/proc/haltyell


#define CLOTHING_CITYWATCH		"#557d8f"
#define CLOTHING_CITYWATCHLIGHT	"#b0f1f5"

/obj/item/clothing/head/roguetown/helmet/kettle/citywatch
	color = CLOTHING_CITYWATCH

/obj/item/clothing/wrists/roguetown/bracers/citywatch
	color = CLOTHING_CITYWATCH

/obj/item/rogueweapon/shield/iron/citywatch
	color = CLOTHING_CITYWATCHLIGHT
