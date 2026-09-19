/datum/advclass/wretch/gorefiend
	name = "Mangas Daichin" // Mongolian for Ogre Warrior / Monster Soldier
	tutorial = "You are a beast in the shape of a man, hailing from where only the flames of rage would keep you warm. Carrying the blood of an ogre in your veins, you are UNBOUND from the limits of mortality. It matters little whether Graggar or Dendor look upon you with interest, utilize INHUMAN WEAPONS to shatter armor... And DEVOUR the fear quivering in the guts of your foes."
	class_select_category = CLASS_CAT_WARRIOR
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/wretch/onimusha
	maximum_possible_slots = 1
	category_tags = list(CTAG_WRETCH)
	cmode_music = 'sound/music/combat_berserker.ogg'
	traits_applied = list(TRAIT_STRONGBITE, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN, TRAIT_STRENGTH_UNCAPPED, TRAIT_DEATHBYSNUSNU, TRAIT_MARTIAL_INCOMPETENCE, TRAIT_DRUNK_HEALING)
	subclass_stats = list(
		STATKEY_STR = 4, //9 weighted stats, but their highest weapon skill is Journeyman.
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
		STATKEY_INT = -2,
		STATKEY_LCK = -2
	)

	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN, //All weapon skills are Journeyman here for a reason. Don't touch them.
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wretch/onimusha/pre_equip(mob/living/carbon/human/H)
	H.set_patron(/datum/patron/inhumen/graggar)
	head = /obj/item/clothing/head/roguetown/helmet/sallet/beastskull
	mask = /obj/item/clothing/mask/rogue/facemask/steel/kazengun/full
	cloak = /obj/item/clothing/cloak/darkcloak/minotaur
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/plate
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/faulds
	neck = /obj/item/clothing/neck/roguetown/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat

	var/weapons = list("Tetsubo", "Giant Cleaver")
	var/weapon_choice = input(H, "Pick your stolen steel.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Tetsubo")
			r_hand = /obj/item/rogueweapon/mace/goden/steel/tetsubo
		if("Giant Cleaver")
			r_hand = /obj/item/rogueweapon/greatsword/zwei/cleaver

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
	)
	wretch_select_bounty(H)
