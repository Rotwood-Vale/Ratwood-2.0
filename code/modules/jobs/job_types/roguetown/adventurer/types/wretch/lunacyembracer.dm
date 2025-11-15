/datum/advclass/wretch/lunacyembracer
	name = "Lunacy Embracer"
	tutorial = "You have forsaken society and even the mainstream gospel of the masses in the pursuit of your gods divine path. This path has left you bare and purified; shedding what had once held you back - and forsaking you from them forevermore. You are hunted for the truths only you have been fit to see. Will you guide them, or make them see?"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/lunacyembracer
	// category_tags = list(CTAG_WRETCH) or (CTAG_DISABLED) to disable
	category_tags = list(CTAG_WRETCH)

/datum/outfit/job/roguetown/wretch/lunacyembracer/pre_equip(mob/living/carbon/human/H)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR)
	H.mind?.special_items["Ritual Chalk"] = /obj/item/ritechalk

	ADD_TRAIT(H, TRAIT_NUDIST, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_WOODWALKER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_RITUALIST, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, 3, TRUE)

	// -- Start of section for god specific bonuses --
	if(H.patron?.type == /datum/patron/inhumen/graggar)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC) //no athletics for you
	if(H.patron?.type == /datum/patron/inhumen/matthios)
		H.grant_language(/datum/language/thievescant)// was 100% sure I'd drop this on LE but shockingly they don't have any ranks in sneak by default
		H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_NOVICE, TRUE)
	if(H.patron?.type == /datum/patron/inhumen/zizo)
		H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_EXPERT, TRUE) 
		H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_NOVICE, TRUE) //tempted to remove literacy for zizoid LE, it's funny for noc but w/e 
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/inhumen/baotha)
		H.adjust_skillrank_up_to(/datum/skill/misc/music, SKILL_LEVEL_APPRENTICE, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_MASTER, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_MASTER, TRUE) // holy shit they can COOK
		ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
	// if(H.patron?.type == /datum/patron/divine/astrata) I'm too lasy to ban Astratan LE but I'm certainly not dumb enough to give them +1 holy
	//	H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/dendor)
	//	H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE) LE already has master farming for some reason? I'm not going to add to it.
		H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
		H.grant_language(/datum/language/beast) //dendor antags can talk to WWs and druids
	if(H.patron?.type == /datum/patron/divine/noc)
		H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_JOURNEYMAN, TRUE) // Really good at reading... almost actually useful for LE.
		H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_EXPERT, TRUE) 
		H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_NOVICE, TRUE)
	if(H.patron?.type == /datum/patron/divine/abyssor)
		H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_MASTER, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
		ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/necra)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/pestra)
		H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_EXPERT, TRUE)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/eora)
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/malum) // lol, lmao
		H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_NOVICE, TRUE)
	if(H.patron?.type == /datum/patron/divine/ravox)
		H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
	if(H.patron?.type == /datum/patron/divine/xylix)
		H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/music, SKILL_LEVEL_NOVICE, TRUE)
	// -- End of section for god specific bonuses --

	H.change_stat("strength", 3)
	H.change_stat("willpower", 2)
	H.change_stat("constitution", 2)
	H.change_stat("speed", 2)
	H.change_stat("fortune", 2) //nature smiles at me!
	H.change_stat("intelligence", -2)
	H.change_stat("perception", -2)
	H.cmode_music = 'sound/music/combat_berserker.ogg'
	to_chat(H, span_danger("You have abandoned your humanity to run wild under the moon. The call of nature fills your soul!"))
	wretch_select_bounty(H)
