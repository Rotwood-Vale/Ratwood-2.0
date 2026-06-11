/datum/job/roguetown/heartfelt/hand
	title = "Hand of Heartfelt"
	tutorial = "你是 赤心 的执政之手，背负着未能守住领主疆土的骂名。\
	纵使旁人对你心存怀疑，你依旧忠诚不改，踏上前往此地的旅程，决意履行自己的职责。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/heartfelt/hand
	total_positions = 1
	spawn_positions = 0
	job_traits = list(TRAIT_NOBLE, TRAIT_HEARTFELT)
	social_rank = SOCIAL_RANK_NOBLE
	advclass_cat_rolls = list(CTAG_HFT_HAND)

	job_subclasses = list(
		/datum/advclass/heartfelt/hand/marshal,
		/datum/advclass/heartfelt/hand/steward,
		/datum/advclass/heartfelt/hand/advisor,
		)

/datum/outfit/job/roguetown/heartfelt/hand/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	gloves =/obj/item/clothing/gloves/roguetown/angle
	beltr = /obj/item/flashlight/flare/torch/lantern
	id = /obj/item/scomstone
	backl = /obj/item/storage/backpack/rogue/satchel

/***************************************************************/
// MARSHAL //
/***************************************************************/


/datum/advclass/heartfelt/hand/marshal
	name = "赤心 战帅"
	tutorial = "你以统兵善战闻名，曾在和平岁月里放下兵刃，但随着 赤心 的衰亡，和平也一并死去了。\
	悲剧再度将你推回役途，你于是踏上前往此地的道路。"
	outfit = /datum/outfit/job/roguetown/heartfelt/hand/marshal
	category_tags = list(CTAG_HFT_HAND)
	subclass_social_rank = SOCIAL_RANK_NOBLE
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE, TRAIT_HEARTFELT, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)

	subclass_skills = list(
	/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
	/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/heartfelt/hand/marshal/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/hand
	r_hand = /obj/item/rogueweapon/sword/long/dec
	//l_hand = banner-pike for when I add it
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	var/turf/TU = get_turf(H)
	if(TU)
		new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(TU)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt)
		H.mind.AddSpell(new/obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget)
		H.verbs |= list(/mob/living/carbon/human/mind/proc/setordersheartfelt)
	var/helmet = list("伊特鲁斯卡盆盔","沃尔夫板甲盔","鸟喙盔","带面罩萨雷特盔",)
	var/helmet_choice = input("选择你的头盔。", "披挂头盔") as anything in helmet
	switch(helmet_choice)
		if("伊特鲁斯卡盆盔")
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
		if("沃尔夫板甲盔") 
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate
		if("鸟喙盔") // GUUUUTS NO GUTS NOOOOO
			head = /obj/item/clothing/head/roguetown/helmet/heavy/beakhelm
		if("带面罩萨雷特盔")	
			head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
		else
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan

/***************************************************************/
// STEWARD //
/***************************************************************/

/datum/advclass/heartfelt/hand/steward
	name = "赤心 总管"
	tutorial = "你是 赤心 的总管，曾是这座男爵领秩序背后沉默的营造者。\
	账册、收成，以及维系子民生计的一切脉络，都曾由你掌管。\
	悲剧再度将你推回役途，你于是踏上前往此地的道路。"
	outfit = /datum/outfit/job/roguetown/heartfelt/hand/steward
	category_tags = list(CTAG_HFT_HAND)
	subclass_social_rank = SOCIAL_RANK_NOBLE
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_NOBLE, TRAIT_SEEPRICES, TRAIT_HEARTFELT)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
	)

	subclass_skills = list(
	/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
	/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
	/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
	/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/heartfelt/hand/steward/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/heartfelt
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	r_hand = /obj/item/rogueweapon/sword/sabre/dec
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	beltr = /obj/item/flashlight/flare/torch/lantern
	neck = /obj/item/storage/belt/rogue/pouch/coins/veryrich
	var/turf/TU = get_turf(H)
	if(TU)
		new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(TU)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 2,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		)
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	id = /obj/item/scomstone
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)

/***************************************************************/
// ADVISOR - MAGE CLASS //
/***************************************************************/

/datum/advclass/heartfelt/hand/advisor
	name = "赤心 顾问"
	tutorial = "你是 赤心 的顾问，因沉稳的谏言与敏锐的政务洞察而深受信赖。\
	在故土倾覆之后，你再度被命运束缚于侍奉之责，并踏上前往此地的道路。"
	outfit = /datum/outfit/job/roguetown/heartfelt/hand/advisor
	category_tags = list(CTAG_HFT_HAND)
	subclass_social_rank = SOCIAL_RANK_NOBLE
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_NOBLE, TRAIT_ARCYNE_T2, TRAIT_INTELLECTUAL, TRAIT_SEEPRICES_SHITTY, TRAIT_HEARTFELT)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 3,
		STATKEY_SPD = 1
	)

	subclass_spellpoints = 15

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	var/list/spells = list(
		/obj/effect/proc_holder/spell/self/message,
		/obj/effect/proc_holder/spell/invoked/create_campfire
	)

//Advisor start. Trades combat skills for more knowledge and skills - for older hands, hands that don't do combat - people who wanna play wizened old advisors.
/datum/outfit/job/roguetown/heartfelt/hand/advisor/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	r_hand = /obj/item/rogueweapon/sword/sabre/dec
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	var/turf/TU = get_turf(H)
	if(TU)
		new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(TU)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/lockpickring/mundane = 1, 
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		) //starts with a vial of poison, like all wizened evil advisors do!
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	pants = /obj/item/clothing/under/roguetown/tights/black
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)

	if(H.age == AGE_OLD)
		H.change_stat("speed", -1)
		H.change_stat("strength", -1)
		H.change_stat("intelligence", 1)
		H.change_stat("perception", 1)
		H?.mind.adjust_spellpoints(3)
