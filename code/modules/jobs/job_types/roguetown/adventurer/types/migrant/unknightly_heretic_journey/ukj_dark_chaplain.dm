// WORDBEARER - big miracles and a staff, preaching for the ascendants

/datum/advclass/ukj_dark_chaplain
	name = "Wordbearer"
	tutorial = "You turned your back on the Ten for gods that actually answer. Now you follow a forsworn knight from village to village and preach to anyone who will listen. Preachers tend to the camp and its chores, while Shepards take up the iron staff to guard the faithful."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/ukj_dark_chaplain
	category_tags = list(CTAG_UKJ_DARK_CHAPLAIN)
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	traits_applied = list(TRAIT_EMPATH, TRAIT_RITUALIST, TRAIT_HERESIARCH)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,//just enough to reattach limbs, same as acolytes
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
	)
	extra_context = "This subclass is given access to the strongest miracles in Ferentian lands, at the cost of suffering elsewhere."

/datum/outfit/job/roguetown/ukj_dark_chaplain/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind?.current)
		H.mind.current.faction += "[H.name]_faction"
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/ritechalk = 1,
		)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe
			head = /obj/item/clothing/head/roguetown/roguehood
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
		else
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe //placeholder, anyone who doesn't have cool patron drip sprites just gets generic robes
			head = /obj/item/clothing/head/roguetown/roguehood
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3)//Only T4 NOT to start maxed, with a devotion cap.
	C.update_devotion(C.max_devotion / 4 - 50, C.max_devotion / 4 - 50, silent = TRUE) // Start at ~25% of devotion cap
	if(H.mind)
		var/weapons = list("Path of the Preacher", "Path of the Shepard")
		var/weapon_choice = input(H, "Choose your path.", "CHOOSE YOUR DISCIPLINE.") as anything in weapons
		switch(weapon_choice)
			if("Path of the Preacher")//Discount homesteader. No trait so you can't level these skills up, nor do you have starting tools.
				r_hand = /obj/item/rogueweapon/woodstaff
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, 1, TRUE)//just so you can make pretty floors easier
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, 3, TRUE)
			if("Path of the Shepard")//The "combat" variant. The core stat spread should keep this class from ever overshadowing the others, but it's worth keeping an eye out anyway.
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 3, TRUE)//Good luck fighting like a monk without monk stats or Dodge Expert.

	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast/unholyblast)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			neck = /obj/item/clothing/neck/roguetown/psicross/inhumen
			backpack_contents[/obj/item/book/rogue/bibble/zizo] = 1
			H.cmode_music = 'sound/music/combat_heretic.ogg'
		if(/datum/patron/inhumen/matthios)
			neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
			H.cmode_music = 'sound/music/combat_matthios.ogg'
		if(/datum/patron/inhumen/graggar)
			neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
			H.cmode_music = 'sound/music/combat_graggar.ogg'
		if(/datum/patron/inhumen/baotha)
			neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
			H.cmode_music = 'sound/music/combat_baotha.ogg'
	if(H.mind)
		wretch_select_bounty(H)
