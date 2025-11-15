/datum/advclass/wretch/devout
	name = "Devout Heretic"
	tutorial = "In another lyfe, you'd have made a good acolyte of the tennites. Somebody not hunted by the powers above and in the law. You however, have answered to the changing dawn; The age of the Inumen requires its apostles and doomsayers.  Serving them as a Devout is youe true calling - your gifts specialized in supporting their schemes and toiling in their name."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/devout
	// category_tags = list(CTAG_WRETCH) or (CTAG_DISABLED) to disable
	category_tags = list(CTAG_WRETCH)

/datum/outfit/job/roguetown/wretch/devout/pre_equip(mob/living/carbon/human/H)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR)

	ADD_TRAIT(H, TRAIT_RITUALIST, TRAIT_GENERIC), TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDICINE_EXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/staves, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)

	H.change_stat("strength", 1) //meant to be a support or war-cleric at best!
	H.change_stat("willpower", 2)
	H.change_stat("constitution", 2)
	H.change_stat("speed", 1)
	H.change_stat("fortune", 1) //blessed by the inhumen!
	H.change_stat("intelligence", 2)
	H.change_stat("perception", 1)
	H.cmode_music = 'sound/music/combat_berserker.ogg'
	to_chat(H, span_danger("You have abandoned your humanity to run wild under the moon. The call of nature fills your soul!"))
	wretch_select_bounty(H)
