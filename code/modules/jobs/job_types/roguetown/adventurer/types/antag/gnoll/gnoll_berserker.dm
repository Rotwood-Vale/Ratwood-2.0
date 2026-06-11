/datum/advclass/gnoll/berserker
	name = "豺狼人狂战士"
	tutorial = "你是个因残暴而令人畏惧的战士，一心只想把自己的力量化作私欲的利爪。强权即公理，而你便是这句话最鲜活的证明。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/gnoll)
	outfit = /datum/outfit/job/roguetown/gnoll/berserker
	cmode_music = 'sound/music/combat_graggar.ogg'
	category_tags = list(CTAG_GNOLL)
	applies_post_equipment = FALSE
	traits_applied = list()
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 4,
		STATKEY_WIL = 3,
		STATKEY_SPD = 4,
		STATKEY_INT = -3,
		STATKEY_PER = -1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE
	)

/datum/outfit/job/roguetown/gnoll/berserker/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor(H)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		don_pelt(H)
