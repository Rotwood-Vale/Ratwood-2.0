/datum/advclass/wardenmaster/huntmaster
	name = "Huntmaster"
	tutorial = "You're the Huntmaster of Lowtown; the eyes and ears of its people beyond the walls. A master hunter and scout, you've spent countless years serving under the Crown and the Baron.\
	 You know every trail, every beast, and every danger lurking in the wilds. Keep your eyes open, your quiver filled, and your arrows ready for any who dare harm your folk."
	outfit = /datum/outfit/job/roguetown/wardenmaster/huntmaster
	cmode_music = 'sound/music/combat_delf.ogg'
	category_tags = list(CTAG_BOGMASTER)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_DODGEEXPERT,
		TRAIT_PERFECT_TRACKER,
		TRAIT_OUTDOORSMAN,
		TRAIT_WOODSMAN,
		TRAIT_SURVIVAL_EXPERT,
		TRAIT_SLEUTH,
		TRAIT_LONGSTRIDER
		)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,//Same statpack as normal ranger warden, but expert knives and +1 WIL.

	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
	)
/datum/outfit/job/roguetown/wardenmaster/huntmaster/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	neck = /obj/item/clothing/neck/roguetown/bevor
	cloak = /obj/item/clothing/cloak/forrestercloak/snow/wardenmaster
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/garrison

	if(H.mind)
		var/weapons = list("Crossbow","Blackhorn Longbow","Blackhorn Recurve Bow")
		var/weapon_choice = input(H,"CHOOSE YOUR TOOL", "PUNCTURE THE ENEMY") as anything in weapons
		switch(weapon_choice)
			if("Crossbow")
				beltl = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 4, TRUE)
			if("Blackhorn Longbow")
				beltl = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
			if("Blackhorn Recurve Bow")
				beltl = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/warden
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)

		var/helmets = list(
			"Antlers of the Antelope"   = /obj/item/clothing/head/roguetown/helmet/bascinet/antler/melee,
			"Skull of the Volf"         = /obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf/melee,
			"Skull of the Ram"          = /obj/item/clothing/head/roguetown/helmet/sallet/warden/goat/melee,
			"Skull of the Bear"         = /obj/item/clothing/head/roguetown/helmet/sallet/warden/bear/melee,
			"None"
	)
		var/helmchoice = input(H, "Choose your Path.", "HELMET SELECTION") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
	