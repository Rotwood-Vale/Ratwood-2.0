/datum/advclass/vagabond_goatherd
	name = "孤牧人"
	examine_name = "乞丐"
	tutorial = "你那安逸的牧野生活早已不复存在，如今只剩羊群里孤零零的一只，提醒着你曾经拥有什么。它是朋友，还是粮食？由你决定。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/goatherd
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	category_tags = list(CTAG_VAGABOND)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_INT = -1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

	extra_context = "This class is restricted from using the Equestrian virtue."

	virtue_restrictions = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/vagabond/goatherd/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

	if(prob(33))
		cloak = /obj/item/clothing/cloak/raincloak/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless

	if(prob(10))
		r_hand = /obj/item/rogue/instrument/flute

	if (H.mind)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

/mob/living/simple_animal/hostile/retaliate/rogue/goat/tame/Initialize(mapload)
	..()
	tamed()
