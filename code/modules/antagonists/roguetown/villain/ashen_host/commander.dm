/datum/advclass/ashen_host/commander
	name = "The Ashen Legate"
	tutorial = "You are the Legate, Sacrilege made manifest to your enemies and the Warbringer of the Ashen Host. Your final ambition is to claim the duchy in Zizo's name. Near the throne, say 'I ascend', gather five voices to say 'I assent', then remain conscious near the throne for ten minutes. Say 'status of the rite' near the throne to check progress and remaining time."
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/ashen_host/commander
	cmode_music = 'sound/music/combat_cult.ogg'
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_ASHEN)
	traits_applied = list(TRAIT_HERETIC_SEER, TRAIT_RITUALIST, TRAIT_GRAVEROBBER, TRAIT_RESONANCE, TRAIT_OVERTHERETIC, TRAIT_ARCYNE, TRAIT_MEDIUMARMOR)
	maximum_possible_slots = 1
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 5,
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_SPD = 3,
		STATKEY_PER = 1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/ashen_host/commander
	has_loadout = TRUE

/datum/outfit/job/roguetown/ashen_host/commander/pre_equip(mob/living/carbon/human/H)
	if(!istype(H.patron, /datum/patron/inhumen/zizo))
		H.set_patron(/datum/patron/inhumen/zizo)
	if(H.mind)
		if(H.mind.current)
			H.mind.current.faction += "[H.name]_faction"
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/churnliving)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_heal)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast/unholyblast)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
		H.verbs |= /mob/living/carbon/human/proc/completesermon_evil // Inhumen Sermon, same as the Heresiarch
		ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
	var/list/helmets = list("BARBUTE - VISORED", "FROGMOUTH - NECK PROTECTION", "BASCINET", "VOLF-FACE - VISORED")
	var/helmet_choice = input(H, "Choose your helmet.", "PROTECTION FROM THE LADY") as anything in helmets
	switch(helmet_choice)
		if("BARBUTE - VISORED")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
		if("FROGMOUTH - NECK PROTECTION")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/zizo
		if("BASCINET")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/zizo
		if("VOLF-FACE - VISORED")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/zizo

	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/zizo
	pants = /obj/item/clothing/under/roguetown/platelegs/medium/zizo
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/avantyne/zizo
	gloves = /obj/item/clothing/gloves/roguetown/plate/medium/zizo
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo
	wrists = /obj/item/clothing/wrists/roguetown/bracers/zizo
	neck = /obj/item/clothing/neck/roguetown/bevor/zizo

	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/ashen
	cloak = /obj/item/clothing/cloak/half
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/kris/zizo
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/repair_kit/metal = 1,
	)
	r_hand = /obj/item/rogueweapon/spear/billhook/zizo
	l_hand = /obj/item/rogueweapon/shield/tower/metal/zizo
	backr = /obj/item/rogueweapon/scabbard/gwstrap

/datum/outfit/job/roguetown/ashen_host/commander/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(!H.mind)
		return
	H.mind.remove_antag_datum(/datum/antagonist/ashen_host)
	H.mind.add_antag_datum(new /datum/antagonist/ashen_host/leader())
