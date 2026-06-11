/datum/advclass/vagabond_beggar
	name = "乞丐"
	examine_name = "乞丐"
	tutorial = "你身无分文，也一文不值。别人的怜悯是你的面包，他们的慈悲就是你的黄油。你常年蹲在路碑边，眼巴巴望着旅人经过乞求施舍，也因此养出了惊人的偷窃本事，甚至还从某个格外心软的流氓嘴里哄来了几手撬锁技巧。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/beggar
	subclass_languages = list(/datum/language/thievescant)
	category_tags = list(CTAG_VAGABOND)
	traits_applied = list(TRAIT_NOSTINK, TRAIT_NASTY_EATER)
	subclass_stats = list(
		STATKEY_STR =  1,
		STATKEY_CON = -3,
		STATKEY_WIL = -3,
		STATKEY_INT = -4
	)
	subclass_skills = list(
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
	)
	extra_context = "运势为随机生成。"

/datum/outfit/job/roguetown/vagabond/beggar/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(20))
		head = /obj/item/clothing/head/roguetown/knitcap

	if(prob(5))
		beltr = /obj/item/reagent_containers/powder/moondust

	if(prob(10))
		beltl = /obj/item/clothing/mask/cigarette/rollie/cannabis

	if(prob(10))
		cloak = /obj/item/clothing/cloak/raincloak/brown

	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		armor = null
		pants = /obj/item/clothing/under/roguetown/tights/vagrant

		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l

		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant

		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

	if(prob(5))
		r_hand = /obj/item/rogueweapon/mace/woodclub
	else
		r_hand = null

	if(prob(5))
		l_hand = /obj/item/rogueweapon/mace/woodclub
	else
		l_hand = null

	if (H.mind)
		H.adjust_skillrank(/datum/skill/misc/sneaking, rand(1,5), TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, rand(1,5), TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, pick (1,2,3,4,5), TRUE)
		H.STALUC = rand(5, 15)
		
