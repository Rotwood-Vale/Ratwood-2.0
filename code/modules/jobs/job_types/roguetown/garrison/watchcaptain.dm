/datum/job/roguetown/watchcaptain
	title = "Watch Captain"
	flag = SHERIFF
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)//I like the idea of making it set you to middle aged, but having the requirement removes it from the latejoin menu which I think is bad for visibility
	tutorial = "You are the most experienced of the City Watch, leading the city watchmen in maintaining order in hightown and attending to threats and crimes below the keep's attention. \
				See to those brave city watchmen under your command and fill in the gaps the ducal retinue leave in their wake. Obey the orders of the marshal and the Crown."
	display_order = JDO_SHERIFF
	whitelist_req = TRUE
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN

	outfit = /datum/outfit/job/roguetown/watchcaptain
	advclass_cat_rolls = list(CTAG_SHERIFF = 20)

	give_bank_account = 50
	min_pq = 6
	max_pq = null
	cmode_music = 'sound/music/combat_citywatch.ogg'
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	job_subclasses = list(
		/datum/advclass/watchcaptain/watchcaptain
	)

/datum/outfit/job/roguetown/watchcaptain
	job_bitflag = BITFLAG_GARRISON

/datum/outfit/job/roguetown/watchcaptain
	head = /obj/item/clothing/head/roguetown/helmet/citywatch
	neck = /obj/item/clothing/neck/roguetown/bevor
	cloak = /obj/item/clothing/cloak/citywatchcaptain
	armor = /obj/item/clothing/suit/roguetown/armor/plate/citywatch
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/citywatch
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/garrison

/datum/advclass/watchcaptain/watchcaptain
	name = "Watch Captain"
	tutorial = "You are the most experienced of the City Watch, leading the city watchmen in maintaining order in hightown and attending to threats and crimes below the keep's attention. \
				See to those brave city watchmen under your command and fill in the gaps knights leave in their wake. Obey the orders of the Knight-Captain and the Crown."
	outfit = /datum/outfit/job/roguetown/watchcaptain/watchcaptain

	category_tags = list(CTAG_SHERIFF)
	subclass_stats = list(
		STATKEY_STR = 1,//will people accept a combat roll with less than +2 in strength? Who knows
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_PER = 3, //eye for Crime
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,	
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,	//detectivework
	)

/datum/outfit/job/roguetown/watchcaptain/watchcaptain/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/focustarget)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/cityguard)
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/sheriff = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/impact_grenade/smoke/blind_gas,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Stunmace & Greatshield","Stunmace & Crossbow","Stunmace & Polehammer")	//A better shield or an extra spare stunmace
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Stunmace & Greatshield")
				r_hand = /obj/item/rogueweapon/mace/stunmace
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("Stunmace & Crossbow")
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				backl = /obj/item/quiver/bolts
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_STR, -1)
				beltr = /obj/item/rogueweapon/mace/stunmace
			if("Stunmace & Polehammer")
				r_hand = /obj/item/rogueweapon/eaglebeak
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/mace/stunmace

/obj/effect/proc_holder/spell/self/convertrole/cityguard
	name = "Recruit City Guard"
	new_role = "City Guard"
	overlay_state = "recruit_guard"
	recruitment_faction = "City Guard"
	recruitment_message = "Serve the city, %RECRUIT!"
	accept_message = "FOR THE CITY!"
	refuse_message = "I refuse."
