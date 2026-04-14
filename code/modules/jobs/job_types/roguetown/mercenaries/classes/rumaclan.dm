/datum/advclass/mercenary/rumaclan
	name = "Ruma Clan Gun-in"
	tutorial = "Granted the unique augmentation tattoo of the Ruma Clan, you are one of the frontline fighters of the Clan. Serve the Seonjang and Clan well, or die trying."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES //no dwarf sprites
	outfit = /datum/outfit/job/roguetown/mercenary/rumaclan
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_HARDDISMEMBER, TRAIT_NOPAINSTUN)
	cmode_music = 'sound/music/combat_kazengite.ogg'
	subclass_stats = list(
		STATKEY_SPD = 2
		STATKEY_CON = 2,
		STATKEY_WIL = 2,  
		STATKEY_STR = 1 // 7 extra points, compareable to Hangyaku. Get
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	extra_context = "This subclass is race-limited from: Dwarves."

/datum/outfit/job/roguetown/mercenary/rumaclan/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are well versed and experienced in swordfighting, you have no problem in taking up most jobs so long as the coin is good, for either yourself or the clan and the seonjang."))
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/steel
	beltl = /obj/item/rogueweapon/sword/sabre/mulyeog/rumahench
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/easttats
	cloak = /obj/item/clothing/cloak/eastcloak1
	armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		)
	H.merctype = 9


/datum/advclass/mercenary/rumaclan/sasu
	name = "Ruma Clan Sasu"
	tutorial = "A band of foreign outcast Kazengunites. The Ruma Clan were outcasts from the Xinyi Dynasty, believed to be associated with the rebels at the time. The clan departed lest they risked being executed for such suspicions, or worse. It is no organized group of soldiers, but rather a loose collection of experienced fighters."
	outfit = /datum/outfit/job/roguetown/mercenary/rumaclan_sasu
	subclass_stats = list(
		STATKEY_PER = 4,
		STATKEY_WIL = 3,
		STATKEY_STR = -1,
		STATKEY_CON = -1 // be positioned well. 7 stat points.
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/rumaclan_sasu/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	to_chat(H, span_warning("You are an archer of the clan, many have called you an true marksman for your skills with the bow. You have no problem in taking up most jobs so long as the coin is good, for either yourself or the clan and the seonjang."))
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/quiver/arrows
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/easttats
	cloak = /obj/item/clothing/cloak/eastcloak1
	armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)
	H.merctype = 9


	/datum/advclass/mercenary/rumaclan/enforcer
	name = "Ruma Clan Enforcer"
	tutorial = "Stripped of either your position or tattoos, potentially both, you are on a quest to regain your status you once held. Along the way, you resorted to a new technique utilizing the famous hook blades from the main land. Good luck."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES //no dwarf sprites
	outfit = /datum/outfit/job/roguetown/mercenary/rumaclan_enforcer
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_DODGEEXPERT) // gets no tats
	cmode_music = 'sound/music/combat_kazengite.ogg'
	subclass_stats = list(
		STATKEY_SPD = 3
		STATKEY_INT = 2, 
		STATKEY_WIL = 2,  // 7 extra points, compareable to other Ruma Class
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	extra_context = "This subclass is race-limited from: Dwarves."

/datum/outfit/job/roguetown/mercenary/rumaclan/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are well versed and experienced in swordfighting, you have no problem in taking up most jobs so long as the coin is good, for either yourself or the clan and the seonjang."))
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/sword/sabre/hook
	beltl = /obj/item/rogueweapon/sword/sabre/hook
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	cloak = /obj/item/clothing/cloak/eastcloak1
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		)
	H.merctype = 9
