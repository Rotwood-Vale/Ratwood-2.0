/datum/advclass/iconoclast //Support Cleric, Heavy armor, unarmed, miracles.
	name = "Iconoclast"
	tutorial = "Trained by an Ecclesial sect, you uphold the Ideological purity of the Matthian Creed. Take from the wealthy, give to the worthless, empower. They will look up to you, in search of the God of Robbery's guidance. Be their light in the dark."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/bandit/iconoclast
	subclass_social_rank = SOCIAL_RANK_PEASANT
	category_tags = list(CTAG_BANDIT)
	maximum_possible_slots = 1 // We only want one of these.
	traits_applied = list(
		TRAIT_HEAVYARMOR,// We are going to be the lord's first heavy armor unarmed class
		TRAIT_CIVILIZEDBARBARIAN,// To be up to date with other unarmed classes.
		TRAIT_RITUALIST,
		)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_LCK = 2,
		STATKEY_CON = 2, //We have a total of +10 in stats. +13 if we have a visible bounty.
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT, // Gilded flail.
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN, // Poles or maces if we're a wimp and don't want to engage with unarmed. Not ideal.
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,  // Unarmed if we want to kick ass for the lord(you do, this is what you SHOULD DO!!)
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, // We can substitute for a sawbones, but aren't as good and dont have access to surgical tools
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER, //We are the True Mathlete
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)
	cmode_music = 'sound/music/Iconoclast.ogg'

/datum/outfit/job/roguetown/bandit/iconoclast/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/inhumen/matthios)))	//This is the only class that forces Matthios. Needed for miracles + limited slot.
		to_chat(H, span_warning("Matthios embraces me.. I must uphold his creed. I am his light in the darkness."))
		H.set_patron(/datum/patron/inhumen/matthios)
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	r_hand = /obj/item/rogueweapon/woodstaff
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/ritechalk = 1,
					)
	head = /obj/item/clothing/head/roguetown/roguehood

	id = /obj/item/mattcoin
	var/list/armor_options = list("Heavy Armor", "Gilded Skin")
	var/armor_choice = input(H, "Choose your PROTECTION.", "WREATH YOURSELF IN GOLD.") as anything in armor_options
	switch(armor_choice)
		if("Heavy Armor")//classic icono
			armor = /obj/item/clothing/suit/roguetown/armor/plate
			shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
		if("Gilded Skin")//equivelant to bronze fullplate + brig chest. Low stab prot and no crit prot on either nat armor. Crucially, you CANNOT equip the gilded fullplate with this.
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest/iconoclast
			shirt = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/iconclast

	var/weapons = list("Fist Weapons", "Flails & Greatflails", "Pure Unarmed")
	var/weapon_choice = input(H, "Choose your ARMS.", "CRUSH THEM.") as anything in weapons
	switch(weapon_choice)
		if("Fist Weapons")//OG iconoclast
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER, TRUE)
			beltr = /obj/item/rogueweapon/katar
		if("Flails & Greatflails")//no longer both unarmed master & flail master, pick one
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails = SKILL_LEVEL_MASTER, TRUE)//hand flails and the gilded flail
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms = SKILL_LEVEL_MASTER, TRUE)//greatflails, besides drow and gilded flail, count as polearms
			beltr = /obj/item/rogueweapon/flail/sflail
		if("Pure Unarmed")
			ADD_TRAIT(H, TRAIT_WEAPONLESS, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_BADTRAINER, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_THROWINGARM, TRAIT_GENERIC)//sorta like scarp letting you toss guns at people
			ADD_TRAIT(H, TRAIT_BIGGUY, TRAIT_GENERIC)//way to breech doors without weapons
			H.change_stat(STATKEY_STR, 2)//pure unarmed is HIGHLY dependent on your base strength. They are weaponlocked so we reward them.
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed = SKILL_LEVEL_LEGENDARY, TRUE)//pure unarmed parry is kinda terrible, matthios' best boy should punch like no other
			gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted/iconoclast

	if(armor_choice == "Gilded Skin" && weapon_choice == "Pure Unarmed")//committing to pecs out billy herrington icono grants you all the funny moves.
		ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
	else
		var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff") // cool wrestling moves
		var/technique_choice = input(H,"Choose your TECHNIQUE.", "TOSS THEM.") as anything in techniques
		switch(technique_choice)
			if("Dropkick - Pushback + Extra Damage")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
			if("Chokeslam - Stamina Damage")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
			if("Stunner - Dazed Debuff")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
			if("Headbutt - Vulnerable Debuff")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)	//Starts off maxed out.

/datum/outfit/job/roguetown/bandit/iconoclast/post_equip(mob/living/carbon/human/H)
	. = ..()
	for(var/datum/bounty/b in GLOB.head_bounties)
		if(b.target == H.real_name || b.target_hidden == H.real_name)
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_WIL, 1)
