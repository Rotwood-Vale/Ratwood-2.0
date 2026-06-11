//Unarmed central, with a singular exception.
//These guys get some absurd power.
/datum/advclass/disciple
	name = "门徒"
	tutorial = "你是 普赛顿 的修士，既通武艺，也习经文。神职者将圣地流血视作一种“罪”，但若只是把人打得不省人事，他们可不会有半点顾忌。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/disciple
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_INQUISITION)
	traits_applied = list(
		TRAIT_CIVILIZEDBARBARIAN,
	)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_STR = 2,
		STATKEY_INT = -2,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"《Psydon 圣典》" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "该子职业可从多种修行路数中择一。你所选的路数离徒手格斗越远，你在拳斗与摔跤上的造诣就会萎缩得越厉害。若选择四分杖，则会小幅提升感知与智力，但会失去“重创抗性”特质。"

/datum/outfit/job/roguetown/disciple
	job_bitflag = BITFLAG_HOLY_WARRIOR

/obj/item/storage/belt/rogue/leather/rope/dark
	color = "#505050"

/datum/outfit/job/roguetown/disciple/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(H.mind)
		var/weapons = list("修行 - 徒手", "拳刃", "指虎", "四分杖")
		var/weapon_choice = input(H,"选择你的武器。", "执起 普赛顿 的兵刃。") as anything in weapons
		switch(weapon_choice)
			if("修行 - 徒手")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 5, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 5, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
			if("拳刃")
				r_hand = /obj/item/rogueweapon/katar/psydon
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			if("指虎")
				r_hand = /obj/item/rogueweapon/knuckles/psydon
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			if("四分杖")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/psy
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
				H.change_stat(STATKEY_PER, 1)
				H.change_stat(STATKEY_INT, 1)

	head = /obj/item/clothing/head/roguetown/roguehood/psydon
	mask = /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns
	wrists = /obj/item/clothing/wrists/roguetown/bracers/psythorns
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	id = /obj/item/clothing/ring/signet/silver
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	backpack_contents = list(/obj/item/roguekey/inquisition = 1,
	/obj/item/paper/inqslip/arrival/ortho = 1)
	belt = /obj/item/storage/belt/rogue/leather/rope/dark
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	cloak = /obj/item/clothing/cloak/psydontabard/alt
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.
