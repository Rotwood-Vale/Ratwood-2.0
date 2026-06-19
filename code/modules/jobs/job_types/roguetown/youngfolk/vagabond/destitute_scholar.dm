/datum/advclass/vagabond_scholar
	name = "Destitute Scholar"
	examine_name = "Beggar"
	tutorial = "Knowledge is often both a boon and a curse. Whatever you know has left you with little to your name, save a half-rate artifact "
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/scholar
	subclass_social_rank = SOCIAL_RANK_PEASANT
	category_tags = list(CTAG_VAGABOND)
	traits_applied = list(TRAIT_INTELLECTUAL, TRAIT_CICERONE, TRAIT_SEEDKNOW)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_CON = -1,
		STATKEY_WIL = -1
	)
	subclass_skills = list(
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/vagabond/scholar/pre_equip(mob/living/carbon/human/H)
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

	var/item_chance = rand(1, 100)
	switch(item_chance)
		if(1 to 30)
			r_hand = /obj/item/natural/feather/infernal
		if(31 to 50)
			r_hand = /obj/item/enchantmentscroll/nightvision
		if(51 to 70)
			r_hand = /obj/item/mimictrinket
		if(71 to 85)
			r_hand = /obj/item/flashlight/flare/torch/lantern/voidlamptern
		if(86 to 95)
			r_hand = /obj/item/enchantmentscroll/featherstep
		if(96 to 100)
			r_hand = /obj/item/clothing/ring/active/shimmeringlens
