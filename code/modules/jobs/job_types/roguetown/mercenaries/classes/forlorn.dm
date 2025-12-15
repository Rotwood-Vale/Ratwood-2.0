/datum/advclass/mercenary/forlorn
	name = "Forlorn Hope Mercenary"
	tutorial = "The Order of the Forlorn Hope, a holy order founded in the name of Noc and the banishment of the rot. Now it is riddled with the wounded, the veterans and the landless of the Vakran civil war. Take up the banner and fight again in the name of the Ten, or use the pretense of faith and zealotry to make ends meet by any means necessary."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/lupian,
		/datum/species/anthromorph,
		/datum/species/vulpkanin
	)
	outfit = /datum/outfit/job/roguetown/mercenary/forlorn
	class_select_category = CLASS_CAT_RANESHENI
	min_pq = 2
	cmode_music = 'sound/music/combat_blackstar.ogg'
	subclass_languages = list(/datum/language/celestial)
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_NOPAINSTUN, TRAIT_CRITICAL_RESISTANCE) // We're going back to the original gimmick of Forlorn Hope, having Critical Resistance
	// Since we demoted them to light armor, I think it is fair they have access to expert weapons as that is also the unarmed barbarian gimmick
	// And unarmed now have weapons in AP's new meta. So nothing wrong with it.
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_CON = 2
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,	// This was arguably the OG shield + 1hand weapon merc. If this is too much, we can cut it back again.
		// I don't want anyone to suffer FOMO because they picked another weapon choice. Therefore shield is no longer gated behind weapon choice
	)
	extra_context = "This subclass gains Expert skill in their weapon of choice."

/datum/outfit/job/roguetown/mercenary/forlorn/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	neck = /obj/item/clothing/neck/roguetown/gorget/forlorncollar
	head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate
	pants = /obj/item/clothing/under/roguetown/splintlegs		// They're brigandinejaks. ergo have them start w/the whole thing
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/splintarms		// They're brigandinejaks. ergo have them start w/the whole thing
	belt = /obj/item/storage/belt/rogue/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife,
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	H.merctype = 5

/datum/outfit/job/roguetown/mercenary/forlorn
	has_loadout = TRUE

/datum/outfit/job/roguetown/mercenary/forlorn/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Warhammer", // The OG
	"crossbow", )
	var/weapon_choice = input(H, "Choose your weapon.", "ARMS OF THE ORDER") as anything in weapons
	switch(weapon_choice)
		if("Warhammer")
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/mace/warhammer/steel, SLOT_BELT_L)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/heater, SLOT_BACK_L)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT)
		if("crossbow")
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts, SLOT_BELT_L)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/sword/short/falchion, SLOT_BELT_R)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, SLOT_BACK_L)
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT)

