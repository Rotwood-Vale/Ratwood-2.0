/datum/job/roguetown/prisonerr
	title = "Prisoner (Town)"
	flag = PRISONERR
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 4
	spawn_positions = 4


	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	tutorial = "当笼中的老鼠是什么滋味？你孤身一人，只能任凭看守摆布，被当作人质活着。你日复一日地等着，盼望总有那么一线机会，会有人替你付清赎金。趁现在，最好赶紧向任何还能给你慰藉的神明祈祷吧。"

	outfit = /datum/outfit/job/roguetown/prisonerr
	bypass_jobban = TRUE
	display_order = JDO_PRISONERR
	give_bank_account = 10
	min_pq = -14
	max_pq = null
	can_random = FALSE

	cmode_music = 'sound/music/combat_bum.ogg'
	social_rank = SOCIAL_RANK_DIRT
	advclass_cat_rolls = list(CTAG_PRISONER = 20)

/datum/outfit/job/roguetown/prisonerr/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	// Equip collar and loincloth only
	neck = /obj/item/clothing/neck/roguetown/collar/leather
	pants = /obj/item/clothing/under/roguetown/loincloth
	ADD_TRAIT(H, TRAIT_OUTLAW, TRAIT_GENERIC)

/datum/job/roguetown/prisonerr/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")

/datum/job/roguetown/prisonerr/special_check_latejoin(client/C)
	return FALSE

// Prisoner-specific subclasses, inheriting from towner roles
/datum/outfit/job/roguetown/prisoner_farmer
	name = "囚犯农夫"

/datum/outfit/job/roguetown/prisoner_farmer/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	..() // Call base prisoner outfit for collar/loincloth
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 5, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/sewing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.adjust_skillrank(/datum/skill/labor/butchering, 5, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		if(H.age == AGE_OLD)
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
			H.adjust_skillrank(/datum/skill/labor/butchering, 1, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("constitution", 1)
		H.change_stat("speed", 1)
		ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_LONGSTRIDER, TRAIT_GENERIC)

/datum/advclass/prisoner_farmer
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_farmer
	name = "囚犯农夫"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_thug
	name = "囚犯恶棍"

/datum/outfit/job/roguetown/prisoner_thug/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
	H.change_stat("strength", 2)
	H.change_stat("willpower", 1)
	H.change_stat("constitution", 3)
	H.change_stat("speed", -1)
	H.change_stat("intelligence", -1)
	H.grant_language(/datum/language/thievescant)

/datum/advclass/prisoner_thug
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_thug
	name = "囚犯恶棍"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_carpenter
	name = "囚犯木匠"

/datum/outfit/job/roguetown/prisoner_carpenter/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.change_stat("strength", 1)
	H.change_stat("willpower", 2)
	H.change_stat("constitution", 1)
	H.change_stat("intelligence", 1)
	H.change_stat("speed", -1)

/datum/advclass/prisoner_carpenter
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_carpenter
	name = "囚犯木匠"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_blacksmith
	name = "囚犯铁匠"

/datum/outfit/job/roguetown/prisoner_blacksmith/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/blacksmithing, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/armorsmithing, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/smelting, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.change_stat("strength", 2)
	H.change_stat("intelligence", 1)
	H.change_stat("willpower", 2)
	H.change_stat("constitution", 2)
	ADD_TRAIT(H, TRAIT_TRAINED_SMITH, TRAIT_GENERIC)

/datum/advclass/prisoner_blacksmith
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_blacksmith
	name = "囚犯铁匠"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_hunter
	name = "囚犯猎人"

/datum/outfit/job/roguetown/prisoner_hunter/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	..() // Call base prisoner outfit for collar/loincloth
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.change_stat("intelligence", 1)
	H.change_stat("perception", 2)
	H.change_stat("speed", 2)
	ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_WOODSMAN, TRAIT_GENERIC)

/datum/advclass/prisoner_hunter
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_hunter
	name = "囚犯猎人"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_minstrel
	name = "囚犯吟游者"

/datum/outfit/job/roguetown/prisoner_minstrel/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	..() // Call base prisoner outfit for collar/loincloth
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.change_stat("speed", 3)
	H.change_stat("willpower", 2)
	H.change_stat("perception", 1)
	ADD_TRAIT(H, TRAIT_KEENEARS, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)

/datum/advclass/prisoner_minstrel
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_minstrel
	name = "囚犯吟游者"
	category_tags = list(CTAG_PRISONER)

/datum/advclass/prisoner_butcher
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_butcher
	name = "囚犯屠夫"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_butcher/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	..() // Call base prisoner outfit for collar/loincloth
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 5, TRUE)
	H.change_stat("strength", 1)
	H.change_stat("willpower", 2)
	H.change_stat("constitution", 2)

/datum/advclass/prisoner_cheesemaker
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_cheesemaker
	name = "囚犯奶酪匠"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_cheesemaker/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.change_stat("intelligence", 2)
	H.change_stat("constitution", 2)
	H.change_stat("willpower", 1)

/datum/advclass/prisoner_seamstress
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_seamstress
	name = "囚犯缝纫工"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_seamstress/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	..() // Call base prisoner outfit for collar/loincloth
	H.adjust_skillrank(/datum/skill/craft/sewing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.change_stat("intelligence", 2)
	H.change_stat("speed", 2)
	H.change_stat("perception", 1)
	H.change_stat("strength", -1)

/datum/advclass/prisoner_potter
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_potter
	name = "囚犯陶工"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_potter/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/ceramics, 5, TRUE)
	H.change_stat("willpower", 2)
	H.change_stat("constitution", 1)
	H.change_stat("perception", 2)
	H.change_stat("speed", -1)

/datum/advclass/prisoner_towndoctor
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_towndoctor
	name = "囚犯理发医师"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_towndoctor/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
	H.change_stat("intelligence", 3)
	H.change_stat("fortune", 1)
	ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_NOSTINK)

/datum/advclass/prisoner_drunkard
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_drunkard
	name = "囚犯赌徒"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_drunkard/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.change_stat("intelligence", -2)
	H.change_stat("constitution", 1)
	H.change_stat("strength", 1)
	H.change_stat("fortune", 2)

/datum/advclass/prisoner_witch
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_witch
	name = "囚犯女巫"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_witch/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	..() // Call base prisoner outfit for collar/loincloth
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/guidance)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
		H.adjust_skillrank(/datum/skill/craft/alchemy, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/sewing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
		H.mind.adjust_spellpoints(6)
		H.change_stat("intelligence", 3)
		H.change_stat("speed", 2)
		H.change_stat("fortune", 1)
		if(H.age == AGE_OLD)
			H.change_stat("speed", -1)
			H.change_stat("intelligence", 1)
			H.change_stat("fortune", 1)
	ADD_TRAIT(H, TRAIT_RITUALIST, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DEATHSIGHT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_WITCH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
	H.cmode_music = 'sound/music/combat_cult.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_cult.ogg'

/datum/advclass/prisoner_miner
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_miner
	name = "囚犯矿工"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_miner/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/smelting, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.change_stat("strength", 2)
	H.change_stat("willpower", 1)
	H.change_stat("constitution", 2)
	H.change_stat("fortune", 2)
	ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)

/datum/advclass/prisoner_woodcutter
	parent_type = /datum/advclass
	outfit = /datum/outfit/job/roguetown/prisoner_woodcutter
	name = "囚犯伐木工"
	category_tags = list(CTAG_PRISONER)

/datum/outfit/job/roguetown/prisoner_woodcutter/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H) return
	..() // Call base prisoner outfit for collar/loincloth
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_LCK, 2)
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/prisoner()
		H.mind.add_antag_datum(new_antag)
	ADD_TRAIT(H, TRAIT_BANDITCAMP, TRAIT_GENERIC)
	if(should_wear_femme_clothes(H))
		H.change_stat(STATKEY_STR, -1)
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
	else if(should_wear_masc_clothes(H))
		H.change_stat(STATKEY_STR, -1)
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/random
