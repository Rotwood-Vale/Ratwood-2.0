/datum/advclass/trader/pony
	name = "Pony"
	tutorial = "Trained to serve as a mount and beast of burden, you are equipped with special gear and training."
	outfit = /datum/outfit/job/roguetown/adventurer/pony
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	traits_applied = list(TRAIT_PONYGIRL_RIDEABLE, TRAIT_CRITICAL_RESISTANCE, TRAIT_EMPATH, TRAIT_NOPAIN, TRAIT_NOPAINSTUN, TRAIT_STABLELIVER, TRAIT_PACIFISM, TRAIT_NASTY_EATER, TRAIT_GOODLOVER, TRAIT_BLOODLOSS_IMMUNE)
	class_select_category = CLASS_CAT_TRADER
	category_tags = list(CTAG_PILGRIM, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	subclass_stats = list(
		STATKEY_CON = 10,
		STATKEY_SPD = 10,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/wrestling = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/unarmed = SKILL_LEVEL_LEGENDARY,
	)

/datum/outfit/job/roguetown/adventurer/pony/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Trained to serve as a mount and beast of burden, you are equipped with special gear and training."))
	mask = /obj/item/clothing/mask/rogue/hblinders
	head = /obj/item/clothing/head/roguetown/hbit
	armor = /obj/item/clothing/suit/roguetown/armor/hcorset
	gloves = /obj/item/clothing/gloves/roguetown/harms
	shoes = /obj/item/clothing/shoes/roguetown/armor/hlegs
