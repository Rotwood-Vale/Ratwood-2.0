/datum/job/roguetown/watchcaptain
	title = "Watch Captain"
	display_title = "守望队长"
	flag = SHERIFF
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)//I like the idea of making it set you to middle aged, but having the requirement removes it from the latejoin menu which I think is bad for visibility
	tutorial = "你是城卫中经验最老到的一位，率领城卫维持上城区秩序，并处理那些尚不值得惊动城堡高层的威胁与罪案。\
				照看好你麾下那些勇敢的城卫，填补公爵扈从行动后留下的空缺。服从元帅与王权的命令。"
	display_order = JDO_SHERIFF
	whitelist_req = TRUE
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN

	outfit = /datum/outfit/job/roguetown/watchcaptain
	advclass_cat_rolls = list(CTAG_SHERIFF = 20)

	give_bank_account = 50
	min_pq = 6
	max_pq = null
	cmode_music = 'sound/music/combat_citywatch.ogg'
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	job_subclasses = list(
		/datum/advclass/watchcaptain/watchcaptain
	)

/datum/outfit/job/roguetown/watchcaptain
	job_bitflag = BITFLAG_GARRISON

/datum/outfit/job/roguetown/watchcaptain
	head = /obj/item/clothing/head/roguetown/helmet/citywatch
	neck = /obj/item/clothing/neck/roguetown/bevor
	cloak = /obj/item/clothing/cloak/citywatchcaptain
	armor = /obj/item/clothing/suit/roguetown/armor/plate/citywatch
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/citywatch
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/garrison

/datum/advclass/watchcaptain/watchcaptain
	name = "守望队长"
	tutorial = "你是城卫中经验最老到的一位，率领城卫维持上城区秩序，并处理那些尚不值得惊动城堡高层的威胁与罪案。\
				照看好你麾下那些勇敢的城卫，填补骑士们行动后留下的空缺。服从骑士统领与王权的命令。"
	outfit = /datum/outfit/job/roguetown/watchcaptain/watchcaptain

	category_tags = list(CTAG_SHERIFF)
	subclass_stats = list(
		STATKEY_STR = 1,//will people accept a combat roll with less than +2 in strength? Who knows
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_PER = 3, //eye for Crime
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,	
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,	//detectivework
	)

/datum/outfit/job/roguetown/watchcaptain/watchcaptain/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/focustarget)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/cityguard)
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/rope/chain = 1,
			/obj/item/storage/keyring/watchcaptain = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
			/obj/item/impact_grenade/smoke/blind_gas,
			)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("震慑钉头锤与大盾","震慑钉头锤与十字弩","震慑钉头锤与长柄战锤")	//A better shield or an extra spare stunmace
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("震慑钉头锤与大盾")
				r_hand = /obj/item/rogueweapon/mace/stunmace
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("震慑钉头锤与十字弩")
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				backl = /obj/item/quiver/bolts
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_STR, -1)
				beltr = /obj/item/rogueweapon/mace/stunmace
			if("震慑钉头锤与长柄战锤")
				r_hand = /obj/item/rogueweapon/eaglebeak
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/mace/stunmace

/obj/effect/proc_holder/spell/self/convertrole/cityguard
	name = "征募城卫"
	new_role = "City Guard"
	overlay_state = "recruit_guard"
	recruitment_faction = "City Guard"
	recruitment_message = "为城市而战，%RECRUIT！"
	accept_message = "为了城市！"
	refuse_message = "我拒绝。"
