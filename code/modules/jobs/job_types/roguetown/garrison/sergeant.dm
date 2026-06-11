/datum/job/roguetown/sergeant
	title = "Sergeant"
	flag = SERGEANT
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "你是王室军伍中经验最老到的人，率领兵士维持秩序，处理那些尚不值得惊动宫廷的威胁与罪案。\
				照看好你麾下的人手，填补骑士行动后留下的空缺。服从元帅与王权的命令。"
	display_order = JDO_SERGEANT
	whitelist_req = TRUE
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN

	outfit = /datum/outfit/job/roguetown/sergeant
	advclass_cat_rolls = list(CTAG_SERGEANT = 20)

	give_bank_account = 50
	min_pq = 6
	max_pq = null
	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	job_subclasses = list(
		/datum/advclass/sergeant/sergeant
	)

/datum/outfit/job/roguetown/sergeant
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/sergeant/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, cloak_and_title_setup)), 50)

//All skills/traits are on the loadouts. All are identical. Welcome to the stupid way we have to make sub-classes...
/datum/outfit/job/roguetown/sergeant
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/gorget
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	id = /obj/item/scomstone/garrison

//Rare-ish anti-armor two hander sword. Kinda alternative of a bastard sword type. Could be cool.
/datum/advclass/sergeant/sergeant
	name = "军士长"
	tutorial = "你不是寻常兵丁，而是公国驻军中的军士长。也许你出身寒微，只是个农夫或佣兵，但你已一步步爬上军阶，成了能赢得敬畏、也能发号施令的人。执起兵刃吧，军士长！"
	outfit = /datum/outfit/job/roguetown/sergeant/sergeant

	category_tags = list(CTAG_SERGEANT)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1, //Gets bow-skills, so give a SMALL tad of perception to aid in bow draw.
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,	// We are basically identical to a regular MAA, except having better athletics to help us manage our order usage better
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,	//Decent tracking akin to Skirmisher.
	)

/datum/outfit/job/roguetown/sergeant/sergeant/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/focustarget)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/guard) // We'll just use Watchmen as sorta conscripts yeag?
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardsergeant = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("罗姆法亚长剑","连枷与盾","戟","军刀与十字弩")	//Bit more unique than footsman, you are a jack-of-all-trades + slightly more 'elite'.
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("罗姆法亚长剑")			//Rare-ish anti-armor two hander sword. Kinda alternative of a bastard sword type. Could be cool.
				backl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/long/rhomphaia
				beltr = /obj/item/rogueweapon/mace/cudgel
			if("连枷与盾")	//Tower-shield, higher durability wood shield w/ more coverage. Plus a steel flail; maybe.. less broken that a steel mace?
				beltr = /obj/item/rogueweapon/flail/sflail
				backl = /obj/item/rogueweapon/shield/tower
			if("戟")			//Halberd - basically exact same as MAA. It's a really valid build. Spear thrust + sword chop + bash.
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/mace/cudgel
			if("军刀与十字弩")	//Versetile skirmisher class. Considered other swords but sabre felt best without being too strong. (This one gets no cudgel, no space.)
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				r_hand = /obj/item/rogueweapon/sword/sabre
				l_hand = /obj/item/rogueweapon/scabbard/sword

		var/armors = list(
			"锁子外衣"		= /obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
			"钢制胸甲"		= /obj/item/clothing/suit/roguetown/armor/plate/half,
			"鳞甲"	= /obj/item/clothing/suit/roguetown/armor/plate/scale,
		)
		var/armorchoice = input(H, "选择你的护甲。", "穿上护甲") as anything in armors
		armor = armors[armorchoice]

/obj/effect/proc_holder/spell/invoked/order
	name = ""
	range = 1
	associated_skill = /datum/skill/misc/athletics
	devotion_cost = 0
	chargedrain = 1
	chargetime = 15
	releasedrain = 80 // This is quite costy. Shouldn't be able to really spam them right off the cuff, combined with having to type out an order. Should prevent VERY occupied officers from ALSO ordering
	recharge_time = 2 MINUTES
	miracle = FALSE
	sound = 'sound/magic/inspire_02.ogg'


/obj/effect/proc_holder/spell/invoked/order/movemovemove
	name = "快！快！快！"
	desc = "命令你的下属迅速前进。速度 +5。"
	overlay_state = "movemovemove"

/obj/effect/proc_holder/spell/invoked/order/movemovemove/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.movemovemovetext
		if(!msg)
			to_chat(user, span_alert("我必须先说点什么，才能下达命令！"))
			return
		if(user.job == "Sergeant")
			if(!(target.job in list("Man at Arms", "Watchman", "Rookie")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(user.job == "Knight Captain")
			if(!(target.job in list("Knight", "Squire", "Man at Arms")))
				to_chat(user, span_alert("我无法命令不属我军阶之人！"))
				revert_cast()
				return
		if(user.job == "Janissary Sergeant")
			if(!(target.job in list("Janissary", "Rookie")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(user.job == "Azeb Agha")
			if(!(target.job in list("Azeb")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(target == user)
			to_chat(user, span_alert("我无法命令我自己！"))
			revert_cast()
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/movemovemove)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/order/movemovemove/nextmove_modifier()
	return 0.85

/datum/status_effect/buff/order/movemovemove
	id = "movemovemove"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/movemovemove
	effectedstats = list(STATKEY_SPD = 5)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/movemovemove
	name = "快！快！快！"
	desc = "我的长官命令我迅速前进！"
	icon_state = "buff"

/datum/status_effect/buff/order/movemovemove/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的长官命令我前进！"))

/obj/effect/proc_holder/spell/invoked/order/takeaim
	name = "瞄准！"
	desc = "命令你的下属更精准地出手。感知 +5。"
	overlay_state = "takeaim"

/datum/status_effect/buff/order/takeaim
	id = "takeaim"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/takeaim
	effectedstats = list(STATKEY_PER = 5)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/takeaim
	name = "瞄准！"
	desc = "我的长官命令我瞄准！"
	icon_state = "buff"

/datum/status_effect/buff/order/takeaim/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的长官命令我瞄准！"))

/obj/effect/proc_holder/spell/invoked/order/takeaim/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.takeaimtext
		if(!msg)
			to_chat(user, span_alert("我必须先说点什么，才能下达命令！"))
			return
		if(user.job == "Sergeant")
			if(!(target.job in list("Man at Arms", "Watchman", "Rookie")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(user.job == "Knight Captain")
			if(!(target.job in list("Knight", "Squire", "Man at Arms")))
				to_chat(user, span_alert("我无法命令不属我军阶之人！"))
				revert_cast()
				return
		if(user.job == "Janissary Sergeant")
			if(!(target.job in list("Janissary", "Rookie")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(user.job == "Azeb Agha")
			if(!(target.job in list("Azeb")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(target == user)
			to_chat(user, span_alert("我无法命令我自己！"))
			revert_cast()
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/takeaim)
		return TRUE
	revert_cast()
	return FALSE



/obj/effect/proc_holder/spell/invoked/order/onfeet
	name = "都给我站起来！"
	desc = "命令你的下属立刻起身。"
	overlay_state = "onfeet"

/obj/effect/proc_holder/spell/invoked/order/onfeet/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.onfeettext
		if(!msg)
			to_chat(user, span_alert("我必须先说点什么，才能下达命令！"))
			return
		if(user.job == "Sergeant")
			if(!(target.job in list("Man at Arms", "Watchman", "Rookie")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(user.job == "Knight Captain")
			if(!(target.job in list("Knight", "Squire", "Man at Arms")))
				to_chat(user, span_alert("我无法命令不属我军阶之人！"))
				revert_cast()
				return
		if(user.job == "Janissary Sergeant")
			if(!(target.job in list("Janissary", "Rookie")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(user.job == "Azeb Agha")
			if(!(target.job in list("Azeb")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(target == user)
			to_chat(user, span_alert("我无法命令我自己！"))
			revert_cast()
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/onfeet)
		if(!(target.mobility_flags & MOBILITY_STAND))
			target.SetUnconscious(0)
			target.SetSleeping(0)
			target.SetParalyzed(0)
			target.SetImmobilized(0)
			target.SetStun(0)
			target.SetKnockdown(0)
			target.set_resting(FALSE)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/order/onfeet
	id = "onfeet"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/onfeet
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/order/onfeet
	name = "都给我站起来！"
	desc = "我的长官命令我立刻起身！"
	icon_state = "buff"

/datum/status_effect/buff/order/onfeet/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的长官命令我立刻起身！"))
	ADD_TRAIT(owner, TRAIT_NOPAIN, TRAIT_GENERIC)

/datum/status_effect/buff/order/onfeet/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, TRAIT_GENERIC)
	. = ..()


/obj/effect/proc_holder/spell/invoked/order/hold
	name = "顶住！"
	desc = "命令你的下属坚守。意志与体质 +2。"
	overlay_state = "hold"


/obj/effect/proc_holder/spell/invoked/order/hold/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]//someone remind me to make version for desertmap classes
		var/msg = user.mind.holdtext
		if(!msg)
			to_chat(user, span_alert("我必须先说点什么，才能下达命令！"))
			return
		if(user.job == "Sergeant")
			if(!(target.job in list("Man at Arms", "Watchman", "Rookie")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(user.job == "Knight Captain")
			if(!(target.job in list("Knight", "Squire", "Man at Arms")))
				to_chat(user, span_alert("我无法命令不属我军阶之人！"))
				revert_cast()
				return
		if(user.job == "Watch Captain")
			if(!(target.job in list("City Guard", "Rookie", "Watchman")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(user.job == "Master Warden")
			if(!(target.job in list("Warden", "Vanguard")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(user.job == "Janissary Sergeant")
			if(!(target.job in list("Janissary", "Rookie")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(user.job == "Azeb Agha")
			if(!(target.job in list("Azeb")))
				to_chat(user, span_alert("我无法命令不属我麾下之人！"))
				revert_cast()
				return
		if(target == user)
			to_chat(user, span_alert("我无法命令我自己！"))
			revert_cast()
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/hold)
		return TRUE
	revert_cast()
	return FALSE


/datum/status_effect/buff/order/hold
	id = "hold"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/hold
	effectedstats = list(STATKEY_WIL = 2, STATKEY_CON = 2)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/hold
	name = "顶住！"
	desc = "我的长官命令我坚守！"
	icon_state = "buff"

/datum/status_effect/buff/order/hold/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的长官命令我坚守！"))

#define TARGET_FILTER "target_marked"

/obj/effect/proc_holder/spell/invoked/order/focustarget
	name = "集火目标！"
	desc = "告诉你的下属锁定敌人的破绽。令敌人更易遭受重创，并使其幸运 -2。"
	overlay_state = "focustarget"


/obj/effect/proc_holder/spell/invoked/order/focustarget/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.focustargettext
		if(!msg)
			to_chat(user, span_alert("我必须先说点什么，才能下达命令！"))
			return
		if(target == user)
			to_chat(user, span_alert("我不能命令别人来杀我自己！"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/debuff/order/focustarget)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/debuff/order/focustarget
	id = "focustarget"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/order/focustarget
	effectedstats = list(STATKEY_CON = -2)
	duration = 1 MINUTES
	var/outline_colour = "#69050a"

/atom/movable/screen/alert/status_effect/debuff/order/focustarget
	name = "已被标记"
	desc = "一名长官已将我标为必杀目标！"
	icon_state = "targetted"

/datum/status_effect/debuff/order/focustarget/on_apply()
	. = ..()
	var/filter = owner.get_filter(TARGET_FILTER)
	to_chat(owner, span_alert("我被一名长官标记为必杀目标了！"))
	if (!filter)
		owner.add_filter(TARGET_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))
	return TRUE

/datum/status_effect/debuff/order/focustarget/on_remove()
	. = ..()
	owner.remove_filter(TARGET_FILTER)


/obj/effect/proc_holder/spell/invoked/order/focustarget
	name = "集火目标！"
	overlay_state = "focustarget"


#undef TARGET_FILTER


/mob/living/carbon/human/mind/proc/setorders()
	set name = "预演口令"
	set category = "号令之声"
	mind.movemovemovetext = input("输入一段口令。", "快！快！快！") as text|null
	if(!mind.movemovemovetext)
		to_chat(src, "我必须先为这道命令预演一段口令……")
		return
	mind.holdtext = input("输入一段口令。", "顶住！") as text|null
	if(!mind.holdtext)
		to_chat(src, "我必须先为这道命令预演一段口令……")
		return
	mind.takeaimtext = input("输入一段口令。", "瞄准！") as text|null
	if(!mind.takeaimtext)
		to_chat(src, "我必须先为这道命令预演一段口令……")
		return
	mind.onfeettext = input("输入一段口令。", "都给我站起来！") as text|null
	if(!mind.onfeettext)
		to_chat(src, "我必须先为这道命令预演一段口令……")
		return
	mind.focustargettext = input("输入一段口令。", "集火目标！") as text|null
	if(!mind.focustargettext)
		to_chat(src, "我必须先为这道命令预演一段口令……")
		return
