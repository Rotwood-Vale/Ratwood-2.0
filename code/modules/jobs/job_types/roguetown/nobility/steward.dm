/datum/job/roguetown/steward
	title = "Steward"
	display_title = "总管"
	flag = STEWARD
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_NO_CONSTRUCT
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_STEWARD
	tutorial = "钱，钱，钱！啊，甜美的钱：你早已沉迷其中，而你如今正担任大公私人的财库与情报管家。你深知金银对凡人灵魂有何等诱惑，也明白人们会为了得到更多而做到什么地步。让这腐败溃烂的经济继续运转下去吧，因为如今它已是你唯一还能寄托些许信任的东西。"
	outfit = /datum/outfit/job/roguetown/steward
	give_bank_account = 22
	noble_income = 16
	min_pq = 3 //Please don't give the vault keys to somebody that's going to lock themselves in on accident
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_noble.ogg'
	social_rank = SOCIAL_RANK_NOBLE
	advclass_cat_rolls = list(CTAG_STEWARD = 2)
	virtue_restrictions = list(/datum/virtue/utility/blacksmith)

	job_traits = list(TRAIT_NOBLE, TRAIT_SEEPRICES)
	job_subclasses = list(
		/datum/advclass/steward
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/steward
	name = "总管"
	tutorial = "钱，钱，钱！啊，甜美的钱：你早已沉迷其中，而你如今正担任大公私人的财库与情报管家。你深知金银对凡人灵魂有何等诱惑，也明白人们会为了得到更多而做到什么地步。让这腐败溃烂的经济继续运转下去吧，因为如今它已是你唯一还能寄托些许信任的东西。"
	outfit = /datum/outfit/job/roguetown/steward/basic

	category_tags = list(CTAG_STEWARD)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_STR = -2
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/steward
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/steward/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward
	else if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		pants = /obj/item/clothing/under/roguetown/tights/random
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/silktunic
		if(SSmapping.current_map.map_name == "Desert Town")
			head = /obj/item/clothing/head/roguetown/turban/red
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/plaquegold/steward
	beltr = /obj/item/storage/keyring/steward
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/mini_flagpole/steward = 1,
	)
	id = /obj/item/scomstone
	if(SSmapping.current_map.map_name == "Rockhill")
		armor = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/steward
		// shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/red//actually dress under overshirt doesn't look too bad
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
	H.verbs |= /mob/living/carbon/human/proc/adjust_taxes

GLOBAL_VAR_INIT(steward_tax_cooldown, -50000) // Antispam
/mob/living/carbon/human/proc/adjust_taxes()
	set name = "调整税率"
	set category = "总管事务"
	if(stat)
		return
	var/lord = find_lord()
	if(lord)
		to_chat(src, span_warning("当[SSticker.rulertype]仍在领内时，我不能擅自调整税率。去请示我的君上。"))
		return
	if(world.time < GLOB.steward_tax_cooldown + 600 SECONDS)
		to_chat(src, span_warning("我还得等上[round((GLOB.steward_tax_cooldown + 600 SECONDS - world.time)/600, 0.1)]分钟，才能再次调整税率！为这片领地想想吧。"))
		return FALSE
	var/datum/taxsetter/taxsetter = new("勤勉的总管出手干预", "贪婪的总管强加税负")
	taxsetter.ui_interact(src)
