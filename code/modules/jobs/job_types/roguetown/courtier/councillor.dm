/datum/job/roguetown/councillor
	title = "Councillor"
	display_title = "参议"
	flag = COUNCILLOR
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_ages = ALL_AGES_LIST
	allowed_races = RACES_TOLERATED_UP
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_COUNCILLOR
	tutorial = "你也许是继承了这个位置，也许是拿钱买来的，又或者真是凭本事获任的, 真叫人不敢细想。不管怎样，你如今都是王权在政务上的助手与代理人。无论是协助总管、治安官、王冠本身，还是单纯享用城堡里的免费饭食，你每天的职责都可能不同。你或许只是阶梯最底下一阶，但这一阶依旧高踞于镇上其他所有人之上。"
	whitelist_req = FALSE
	outfit = /datum/outfit/job/roguetown/councillor
	advclass_cat_rolls = list(CTAG_COUNCILLOR = 2)

	give_bank_account = 40
	noble_income = 20
	min_pq = 1 //Probably a bad idea to have a complete newbie advising the monarch
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_noble.ogg'
	social_rank = SOCIAL_RANK_NOBLE
	job_traits = list(TRAIT_NOBLE, TRAIT_SEEPRICES_SHITTY)
	job_subclasses = list(
		/datum/advclass/councillor
	)

/datum/advclass/councillor
	name = "参议"
	tutorial = "你也许是继承了这个位置，也许是拿钱买来的，又或者真是凭本事获任的, 真叫人不敢细想。不管怎样，你如今都是王权在政务上的助手与代理人。无论是协助总管、治安官、王冠本身，还是单纯享用城堡里的免费饭食，你每天的职责都可能不同。你或许只是阶梯最底下一阶，但这一阶依旧高踞于镇上其他所有人之上。"
	outfit = /datum/outfit/job/roguetown/councillor/basic
	category_tags = list(CTAG_COUNCILLOR)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_STR = -1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/councillor
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/councillor/basic/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/councillor
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/storage/keyring/steward // If this turns out to be overbearing re:stewardry bump down to the clerk keyring instead.
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	cloak = /obj/item/clothing/cloak/stabard/surcoat/councillor
	backpack_contents = list()
	if(SSmapping.current_map.map_name == "Rockhill")
		armor = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/councillor
		cloak = null
	if(SSmapping.current_map.map_name == "Desert Town")
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/councillor
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		cloak = null
