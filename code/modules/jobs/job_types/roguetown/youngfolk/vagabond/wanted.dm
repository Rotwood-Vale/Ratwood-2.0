/datum/advclass/vagabond_wanted
	name = "通缉犯"
	examine_name = "乞儿"
	tutorial = "法网正朝你伸来。这一回你还能从它手里滑出去吗，还是说你的脑袋注定要落进某头 灭绝兽 的嘴里？"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/wanted
	category_tags = list(CTAG_VAGABOND)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
	)
	extra_context = "此子职业开局自带悬赏。"

/datum/outfit/job/roguetown/vagabond/wanted/pre_equip(mob/living/carbon/human/H)
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
		cloak = /obj/item/clothing/cloak/half/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless

	if (H.mind)
		H.change_stat(STATKEY_LCK, rand(-2, 2))
		var/my_crime = input(H, "你犯下了什么罪？", "罪名") as text|null
		if (!my_crime)
			my_crime = "对王权的罪行"
		var/list/bounty_cats = list("薄赏", "中赏", "重赏")
		var/bounty_amount = input(H, "你的赏金有多高？", "血金悬赏") as anything in bounty_cats
		var/race = H.dna.species
		var/gender = H.gender
		var/list/d_list = H.get_mob_descriptors()
		var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
		var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
		var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
		var/bounty_total = rand(51, 200)
		switch (bounty_amount)
			if ("薄赏")
				bounty_total = rand(51, 100)
			if ("中赏")
				bounty_total = rand(101, 150)
			if ("重赏")
				bounty_total = rand(150, 200)
	
		add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, "The Justiciary of [SSmapping.map_adjustment.realm_name]")
		to_chat(H, span_notice("我正在逃避律法追捕，而我的脑袋上挂着一笔[LOWER_TEXT(bounty_amount)]的血金悬赏……最好低调点。"))
