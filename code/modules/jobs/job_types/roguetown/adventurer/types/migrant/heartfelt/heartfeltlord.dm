
/datum/job/roguetown/heartfelt/lord
	title = "Lord of Heartfelt"
	tutorial = "你是 赤心 的领主，统治着一座昔日繁荣、如今却已倾颓的男爵领。\
	在 Magos 的指引下，你踏上前往山巅的旅程，寻求援助以重振旧土昔日荣光，或许也为自己夺下一座新的王座。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = null
	total_positions = 1
	spawn_positions = 0
	job_traits = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_HEARTFELT)
	social_rank = SOCIAL_RANK_NOBLE
	advclass_cat_rolls = list(CTAG_HFT_LORD)
	
	job_subclasses = list(
		/datum/advclass/heartfelt/lord/lord,
		/datum/advclass/heartfelt/lord/archmage,
		/datum/advclass/heartfelt/lord/chief,
		)

// DEFAULT - STANDARD OLD CLASS

/datum/advclass/heartfelt/lord/lord
	name = "赤心 领主"
	tutorial = "你是 赤心 的领主，统治着一座昔日繁荣、如今却已倾颓的男爵领。\
	在 Magos 的指引下，你来到这片土地，寻求援助以重振旧土昔日荣光，或许也为自己夺下一座新的王座。"
	category_tags = list(CTAG_HFT_LORD)
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/heartfelt/lord/lord
	pickprob = 100
	class_select_category = CLASS_CAT_HFT_COURT
	subclass_social_rank = SOCIAL_RANK_NOBLE
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_HEARTFELT)

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/heartfelt/lord/lord/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	cloak = /obj/item/clothing/cloak/heartfelt
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	beltl =/obj/item/rogueweapon/scabbard/sword/noble
	r_hand = /obj/item/rogueweapon/sword/long/marlin
	beltr = /obj/item/rogueweapon/huntingknife
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel // Paper and Feather
	var/turf/TU = get_turf(H)
	if(TU)
		new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(TU)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 2,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		)
	id = /obj/item/scomstone
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt)
		H.mind.AddSpell(new/obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget)
		H.verbs |= list(/mob/living/carbon/human/mind/proc/setordersheartfelt)

/datum/advclass/heartfelt/lord/archmage
	name = "赤心 大法师领主"
	tutorial = "你是 赤心 的大 Magos，统治着一座昔日繁荣、如今却已倾颓的奥术男爵领。\
	在来自彼岸的幻视引领下，你踏上前往边疆的旅程，寻求援助以重振旧土昔日荣光，或许也为自己夺下一座新的王座。"
	category_tags = list(CTAG_HFT_LORD)
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/heartfelt/lord/archmage
	pickprob = 100
	class_select_category = CLASS_CAT_HFT_COURT
	subclass_social_rank = SOCIAL_RANK_NOBLE
	traits_applied = list(TRAIT_NOBLE, TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_INTELLECTUAL, TRAIT_HEARTFELT, TRAIT_ALCHEMY_EXPERT)

	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)


/datum/outfit/job/heartfelt/lord/archmage/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	cloak = /obj/item/clothing/cloak/heartfelt
	armor = /obj/item/clothing/cloak/black_cloak
	neck = /obj/item/storage/belt/rogue/pouch/coins/veryrich
	beltl = /obj/item/storage/magebag/associate
	r_hand = /obj/item/rogueweapon/woodstaff/diamond
	l_hand = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/huntingknife
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	var/turf/TU = get_turf(H)
	if(TU)
		new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(TU)
	backpack_contents = list(
		/obj/item/recipe_book/alchemy,
		/obj/item/roguegem/amethyst,
		/obj/item/spellbook_unfinished/pre_arcyne,
		/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/strongmanapot = 1,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
	)
	id = /obj/item/scomstone
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
	if(H.mind)
		H?.mind.adjust_spellpoints(24)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.change_stat("speed", -1)
		H.change_stat("intelligence", 1)
		H.change_stat("perception", 1)
		H?.mind.adjust_spellpoints(6)

/datum/advclass/heartfelt/lord/chief
	name = "赤心 酋长"
	tutorial = "你是 赤心 的酋长，统治着一座昔日繁荣、如今却已倾颓的男爵领。\
	在 Magos 的指引下，你来到这片土地，寻求援助以重振旧土昔日荣光，或许也为自己夺下一座新的王座。"
	category_tags = list(CTAG_HFT_LORD)
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/heartfelt/lord/chief
	pickprob = 100
	class_select_category = CLASS_CAT_HFT_COURT
	subclass_social_rank = SOCIAL_RANK_NOBLE
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_CIVILIZEDBARBARIAN, TRAIT_STRONGBITE, TRAIT_HEARTFELT)

	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_SPD = 1,
		STATKEY_PER = -2,
		STATKEY_INT = -1,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/heartfelt/lord/chief/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/beastskull
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/faulds
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	cloak = /obj/item/clothing/cloak/darkcloak/minotaur/red
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/heartfelt
	neck = /obj/item/clothing/neck/roguetown/leather
	beltr = /obj/item/rogueweapon/huntingknife
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel // Paper and Feather
	var/turf/TU = get_turf(H)
	if(TU)
		new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(TU)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		)
	id = /obj/item/scomstone
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt)
		H.mind.AddSpell(new/obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget)
		H.verbs |= list(/mob/living/carbon/human/mind/proc/setordersheartfelt)

	var/weapons = list("双头巨斧", "巨型钉锤", "战斧加盾", , "战锤加盾")
	var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("双头巨斧")
			r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead
		if("巨型钉锤")
			r_hand = /obj/item/rogueweapon/mace/goden/steel
		if("战斧加盾")
			r_hand = /obj/item/rogueweapon/stoneaxe/battle
			l_hand = /obj/item/rogueweapon/shield/tower/metal
		if("战锤加盾")
			r_hand = /obj/item/rogueweapon/mace/warhammer
			l_hand = /obj/item/rogueweapon/shield/tower/metal
		else //In case they DC or don't choose close the panel, etc
			r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead


// Spells + Orders (Orders are ONLY For HFT Lord job and the Hand Marshal Subclass)

/obj/effect/proc_holder/spell/self/convertrole/heartfelt
	name = "招募扈从"
	new_role = "Heartfeltian Retinue"
	overlay_state = "recruit_brother"
	recruitment_faction = "Heartfelt"
	recruitment_message = "为 赤心 效命吧，%RECRUIT！"
	accept_message = "为了 赤心！"
	refuse_message = "我拒绝。"

/obj/effect/proc_holder/spell/self/convertrole/heartfelt/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(HAS_TRAIT(recruit, TRAIT_HEARTFELT))
		to_chat(recruiter, span_warning("他们已经属于我们的事业了！"))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_GUARDSMAN))
		to_chat(recruiter, span_warning("他们已经是谷地卫队的一员了！不能加入我们的事业！"))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_INQUISITION))
		to_chat(recruiter, span_warning("他们只忠于 普赛顿！不能加入我们的事业！"))
		return FALSE
	//If you're reading this, please refactor this once we have TRAIT_CLERGY thanks
	if(recruit.job in list("Priest", "Priestess", "Templar", "Acolyte", "Martyr"))
		to_chat(recruiter, span_warning("神职者不能加入我们的事业！他们忠于十神！"))
		return FALSE
	..()

/obj/effect/proc_holder/spell/invoked/order/heartfelt/proc/can_order(mob/living/target, mob/living/user)
	if(target == user)
		to_chat(user, span_alert("我不能命令我自己！"))
		return 0
	if(HAS_TRAIT(target, TRAIT_HEARTFELT))
		if(target == user)
			to_chat(user, span_alert("我不能命令我自己！"))
			return 0
		else
			return 1
	if(!(target.job in list("Heartfeltian Retinue", "Knight of Heartfelt")))
		to_chat(user, span_alert("我不能命令不属于我们事业的人！"))
		return 0
	return 1


/obj/effect/proc_holder/spell/invoked/order/heartfelt
	name = "赤心 军令"
	var/effect_to_apply
	var/message_varname

/obj/effect/proc_holder/spell/invoked/order/heartfelt/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	var/msg = user.mind.vars[message_varname]

	if(!msg)
		to_chat(user, span_alert("我必须先说些什么，才能下达命令！"))
		return

	var/allowed = can_order(target, user)
	if(!allowed)
		return

	user.say("[msg]")
	target.apply_status_effect(effect_to_apply)
	on_success(user, target)
	return TRUE

/obj/effect/proc_holder/spell/invoked/order/heartfelt/proc/on_success(mob/living/user, mob/living/target)
	return

/***************************************************************
 *  INDIVIDUAL HEARTFELT ORDERS
 ***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/heartfelt/retreat
	name = "后撤！"
	overlay_state = "movemovemove"
	effect_to_apply = /datum/status_effect/buff/order/heartfelt/retreat
	message_varname = "retreattext"

/datum/status_effect/buff/order/heartfelt/retreat
	id = "retreat"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/heartfelt/retreat
	effectedstats = list(STATKEY_SPD = 3)
	duration = 1 MINUTES

/datum/status_effect/buff/order/heartfelt/retreat/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的指挥官命令我后撤！"))

/atom/movable/screen/alert/status_effect/buff/order/heartfelt/retreat
	name = "后撤！"
	desc = "我的指挥官命令我后撤！"
	icon_state = "buff"

/***************************************************************/


/obj/effect/proc_holder/spell/invoked/order/heartfelt/bolster
	name = "稳住战线！"
	overlay_state = "bolster"
	effect_to_apply = /datum/status_effect/buff/order/heartfelt/bolster
	message_varname = "bolstertext"

/datum/status_effect/buff/order/heartfelt/bolster
	id = "bolster"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/heartfelt/bolster
	effectedstats = list(STATKEY_WIL = 2, STATKEY_CON = 3)
	duration = 1 MINUTES

/datum/status_effect/buff/order/heartfelt/bolster/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的指挥官命令我稳住战线！"))

/atom/movable/screen/alert/status_effect/buff/order/heartfelt/bolster
	name = "稳住战线！"
	desc = "我的指挥官鼓舞我再坚持一会儿，撑得更久！"
	icon_state = "buff"

/***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt
	name = "起身死战！"
	overlay_state = "onfeet"
	effect_to_apply = /datum/status_effect/buff/order/heartfelt/forheartfelt
	message_varname = "onfeettext"

/obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt/on_success(mob/living/user, mob/living/target)
	if(!(target.mobility_flags & MOBILITY_STAND))
		target.SetUnconscious(0)
		target.SetSleeping(0)
		target.SetParalyzed(0)
		target.SetImmobilized(0)
		target.SetStun(0)
		target.SetKnockdown(0)
		target.set_resting(FALSE)

/datum/status_effect/buff/order/heartfelt/forheartfelt
	id = "forheartfelt"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/heartfelt/forheartfelt
	duration = 30 SECONDS

/datum/status_effect/buff/order/heartfelt/forheartfelt/on_apply()
	. = ..()
	to_chat(owner, span_blue("我必须起身死战！"))
	ADD_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)

/datum/status_effect/buff/order/heartfelt/forheartfelt/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)
	. = ..()

/atom/movable/screen/alert/status_effect/buff/order/heartfelt/forheartfelt
	name = "坚守阵地！"
	desc = "我的指挥官命令我为 赤心 骄傲地站住脚跟！"
	icon_state = "buff"

/***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/heartfelt/charge
	name = "冲锋！"
	overlay_state = "charge"
	effect_to_apply = /datum/status_effect/buff/order/heartfelt/charge
	message_varname = "chargetext"

/datum/status_effect/buff/order/heartfelt/charge
	id = "charge"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/heartfelt/charge
	effectedstats = list(STATKEY_STR = 2, STATKEY_LCK = 2)
	duration = 1 MINUTES

/datum/status_effect/buff/order/heartfelt/charge/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的指挥官命令我冲锋！为了 赤心！"))

/atom/movable/screen/alert/status_effect/buff/order/heartfelt/charge
	name = "冲锋！"
	desc = "我的指挥官意志已下，现在就是冲锋的时候！"
	icon_state = "buff"

/***************************************************************/

// Doesn't work at the moment

#define TARGET_FILTER "target_marked"

/obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.focustargettext
		if(!msg)
			to_chat(user, span_alert("我必须先说些什么，才能下达命令！"))
			return
		if(target == user)
			to_chat(user, span_alert("我不能命令别人来杀我自己！"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/debuff/order/focustarget)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget
	name = "集火目标！"
	overlay_state = "focustarget"
	effect_to_apply = /datum/status_effect/debuff/order/heartfelt/focustarget
	message_varname = "focustargettext"

/datum/status_effect/debuff/order/heartfelt/focustarget
	id = "target"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/order/heartfelt/focustarget
	effectedstats = list(STATKEY_LCK = -2)
	duration = 1 MINUTES
	var/outline_colour = "#69050a"

/atom/movable/screen/alert/status_effect/debuff/order/heartfelt/focustarget
	name = "被标记"
	desc = "一名军官已经将我标记为必杀目标！"
	icon_state = "targetted"

/datum/status_effect/debuff/order/heartfelt/focustarget/on_apply()
	. = ..()
	var/filter = owner.get_filter(TARGET_FILTER)
	to_chat(owner, span_alert("我已被一名军官标记为必杀目标！"))
	ADD_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	if (!filter)
		owner.add_filter(TARGET_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))
	return TRUE

/datum/status_effect/debuff/order/heartfelt/focustarget/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	owner.remove_filter(TARGET_FILTER)

/obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget
	name = "集火目标！"
	overlay_state = "focustarget"

#undef TARGET_FILTER

/***************************************************************
 *  ORDER SETUP PROC
 ***************************************************************/

/mob/living/carbon/human/mind/proc/setordersheartfelt()
	set name = "预设军令"
	set category = "统御之声"

	#define ORDER_INPUT(varname, prompt) \
		mind.varname = input("输入一段话。", prompt) as text|null; \
		if(!mind.varname) { to_chat(src, "我必须先为这道命令预备一句话……"); return }

	ORDER_INPUT(retreattext, "向后撤！！")
	ORDER_INPUT(chargetext, "把他们顶回去！！")
	ORDER_INPUT(bolstertext, "稳住战线！！")
	ORDER_INPUT(onfeettext, "为了 赤心 骄傲地站起来！！")
	ORDER_INPUT(focustargettext, "击溃他们的士气，把他们标记为必杀目标！！")

	#undef ORDER_INPUT
