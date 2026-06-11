// Arcyne Potential now gives 3 Spellpoints instead of 6 spellpoints so it is less of a "must take" for caster.
/datum/virtue/combat/magical_potential
	name = "奥术潜质"
	desc = "我在奥术之道上颇有天赋，这拓展了我的施法容量。钻研此道也令我更加聪慧。其他效果则取决于我后来选择专精的训练方向。"
	custom_text = "拥有战斗特性的职业（中甲/重甲训练、闪避专家或暴击抗性）只会获得戏法术。其他人若尚未掌握奥术，则会获得+3法术点与T1奥术潜质。"
	added_skills = list(list(/datum/skill/magic/arcane, 1, 6))

/datum/virtue/combat/magical_potential/apply_to_human(mob/living/carbon/human/recipient)
	if (!recipient.get_skill_level(/datum/skill/magic/arcane)) // we can do this because apply_to is always called first
		if (!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation))
			recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		if (!HAS_TRAIT(recipient, TRAIT_MEDIUMARMOR) && !HAS_TRAIT(recipient, TRAIT_HEAVYARMOR) && !HAS_TRAIT(recipient, TRAIT_DODGEEXPERT) && !HAS_TRAIT(recipient, TRAIT_CRITICAL_RESISTANCE))
			ADD_TRAIT(recipient, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
			recipient.mind?.adjust_spellpoints(3)
	else
		recipient.mind?.adjust_spellpoints(3) // 3 extra spellpoints since you don't get any spell point from the skill anymore
	
/datum/virtue/combat/devotee
	name = "虔信者"
	desc = "虽然我并非教会正式成员，但我与所选主神的联系足够深厚，足以让我获得祂最微小的赐福。我还保留了一枚属于自己神祇的普赛圣十字。"

	custom_text = "你会获得主神的T0神迹。若你是非战斗定位，还会获得少量被动虔诚恢复；若你本就能使用神迹，则会获得小幅额外被动虔诚恢复。"

	added_skills = list(list(/datum/skill/magic/holy, 1, 6))

/datum/virtue/combat/devotee/apply_to_human(mob/living/carbon/human/recipient)
	if (!recipient.mind)
		return
	if (!recipient.devotion)
		// Only give non-devotionists orison... and T0 for some reason (Bad ideas are fun!)
		var/datum/devotion/new_faith = new /datum/devotion(recipient, recipient.patron)
		if (!HAS_TRAIT(recipient, TRAIT_MEDIUMARMOR) && !HAS_TRAIT(recipient, TRAIT_HEAVYARMOR) && !HAS_TRAIT(recipient, TRAIT_DODGEEXPERT) && !HAS_TRAIT(recipient, TRAIT_CRITICAL_RESISTANCE))
			new_faith.grant_miracles(recipient, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = (CLERIC_REQ_1 - 10)) // Passive devotion regen only for non-combat classes
		else
			new_faith.grant_miracles(recipient, cleric_tier = CLERIC_T0, passive_gain = FALSE, devotion_limit = (CLERIC_REQ_1 - 20))	//Capped to T0 miracles.
	else
		// for devotionists, give them an amount of passive devo gain.
		var/datum/devotion/our_faith = recipient.devotion
		our_faith.passive_devotion_gain += CLERIC_REGEN_DEVOTEE
		START_PROCESSING(SSobj, our_faith)
	switch(recipient.patron?.type)
		if(/datum/patron/divine/astrata)
			recipient.mind?.special_items["阿斯特拉塔普赛圣十字"] = /obj/item/clothing/neck/roguetown/psicross/astrata
		if(/datum/patron/divine/abyssor)
			recipient.mind?.special_items["阿比索尔普赛圣十字"] = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			recipient.mind?.special_items["登多尔普赛圣十字"] = /obj/item/clothing/neck/roguetown/psicross/dendor
		if(/datum/patron/divine/necra)
			recipient.mind?.special_items["内克拉普赛圣十字"] = /obj/item/clothing/neck/roguetown/psicross/necra
		if(/datum/patron/divine/pestra)
			recipient.mind?.special_items["佩斯特拉普赛圣十字"] = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/eora) 
			recipient.mind?.special_items["伊欧拉普赛圣十字"] = /obj/item/clothing/neck/roguetown/psicross/eora
		if(/datum/patron/divine/xylix) 
			recipient.mind?.special_items["赛利克斯普赛圣十字"] = /obj/item/clothing/neck/roguetown/psicross/xylix
		if(/datum/patron/divine/noc)
			recipient.mind?.special_items["诺克普赛圣十字"] = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/ravox)
			recipient.mind?.special_items["拉沃克斯普赛圣十字"] =/obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			recipient.mind?.special_items["玛勒姆普赛圣十字"] = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/old_god)
			ADD_TRAIT(recipient, TRAIT_PSYDONITE, TRAIT_GENERIC)
			recipient.mind?.special_items["普赛圣十字"] = /obj/item/clothing/neck/roguetown/psicross

/datum/virtue/combat/duelist
	name = "决斗学徒"
	desc = "我曾在一位技艺高超的决斗者门下训练。我藏着一对决斗兵器，一把猎剑和一把匕首，以备不时之需。"
	custom_text = "保证获得剑术与匕首的熟练工等级。"
	added_stashed_items = list("决斗者梅塞尔刀" = /obj/item/rogueweapon/sword/short/messer/iron/virtue,
								"决斗者格挡匕首" = /obj/item/rogueweapon/huntingknife/idagger/virtue)

/datum/virtue/combat/duelist/apply_to_human(mob/living/carbon/human/recipient)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

/datum/virtue/combat/executioner
	name = "地牢吏学徒"
	desc = "我曾被安排去做一名地牢吏，也曾受其亲自教导。我藏着一把斧头和一条鞭子，以备有朝一日派上用场。"
	custom_text = "保证获得斧术与鞭/链枷的熟练工等级。"
	added_stashed_items = list("斧头" = /obj/item/rogueweapon/stoneaxe/woodcut,
								"鞭子" = /obj/item/rogueweapon/whip)

/datum/virtue/combat/executioner/apply_to_human(mob/living/carbon/human/recipient)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

/datum/virtue/combat/militia
	name = "民兵"
	desc = "我曾与本地守军一同训练，以备某日被征召为领主而战。我藏着一把长矛和一柄钉头锤，等到应召之时便可取用。"
	custom_text = "保证获得长柄武器与钉头锤的熟练工等级。"
	added_stashed_items = list("长矛" = /obj/item/rogueweapon/spear,
								"钉头锤" = /obj/item/rogueweapon/mace)

/datum/virtue/combat/militia/apply_to_human(mob/living/carbon/human/recipient)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

/datum/virtue/combat/brawler
	name = "斗殴学徒"
	desc = "我曾在一位老练斗士门下受训，也积累了些徒手搏斗的经验。我还藏着一把拳刃和几副指虎。"
	custom_text = "保证获得徒手与摔跤的熟练工等级。"
	added_stashed_items = list("指虎" = /obj/item/rogueweapon/knuckles/bronzeknuckles,
								"另一副指虎" = /obj/item/rogueweapon/knuckles/bronzeknuckles)

/datum/virtue/combat/brawler/apply_to_human(mob/living/carbon/human/recipient)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)


/datum/virtue/combat/bowman
	name = "弓艺爱好者"
	desc = "我自幼便对弓术颇感兴趣，因此总会备着一张弓和一只箭袋。"
	custom_text = "弓术+1，最高至传奇，至少为学徒。"
	added_stashed_items = list("反曲弓" = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve,
								"箭袋（箭矢）" = /obj/item/quiver/arrows
	)

/datum/virtue/combat/bowman/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.get_skill_level(/datum/skill/combat/bows) < SKILL_LEVEL_APPRENTICE)
		recipient.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_APPRENTICE, silent = TRUE)
	else
		added_skills = list(list(/datum/skill/combat/bows, 1, 6))

/datum/virtue/combat/crossbowman
	name = "征召弩手"
	desc = "弩是一种使用简单的武器，而这也正是它高效的原因。我一直备着一把弩和一些弩矢，以防万一。"
	custom_text = "弩术+1，最高至传奇，至少为学徒。"
	added_stashed_items = list("弩" = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow,
								"箭袋（弩矢）" = /obj/item/quiver/bolts
	)

/datum/virtue/combat/crossbowman/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.get_skill_level(/datum/skill/combat/crossbows) < SKILL_LEVEL_APPRENTICE)
		recipient.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_APPRENTICE, silent = TRUE)
	else
		added_skills = list(list(/datum/skill/combat/crossbows, 1, 6))

/datum/virtue/combat/shepherd
	name = "能干牧人"
	desc = "多年来，为了保护羊群不受强盗与窃贼侵害，我学会了如何用最朴素的武器来自卫。"
	custom_text = "保证获得长杖与投石索的熟练工等级。"
	added_stashed_items = list("铁头长杖" = /obj/item/rogueweapon/woodstaff/quarterstaff/iron,
								"投石索" = /obj/item/gun/ballistic/revolver/grenadelauncher/sling,
								"铁制投石索弹袋" = /obj/item/quiver/sling/iron)

/datum/virtue/combat/shepherd/apply_to_human(mob/living/carbon/human/recipient)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

/*/datum/virtue/combat/tavern_brawler
	name = "酒馆斗士"
	desc = "我从没遇过一双拳头解决不了的问题。"
	added_traits = list(TRAIT_CIVILIZEDBARBARIAN)*/

/datum/virtue/combat/guarded
	name = "深藏不露"
	desc = "长久以来，我始终将真正的才能与恶癖隐藏起来。有时，伪装成弱者反而能救自己一命。"
	custom_text = "会模糊各种效果对你的信息读取，包括主神能力与被动、评估以及其他美德。"
	added_traits = list(TRAIT_DECEIVING_MEEKNESS)

/*/datum/virtue/combat/impervious
	name = "坚不可摧"
	desc = "我花了许多年弥补自身破绽，如今已很难被致命重创所击倒。"
	added_traits = list(TRAIT_CRITICAL_RESISTANCE)*/

/datum/virtue/combat/rotcured
	name = "腐愈者"
	desc = "我曾被那可憎的腐病所折磨，后来又被治愈。它让我发生了变化：四肢更孱弱了，但我感觉不到疼痛，也不再需要呼吸......"
	custom_text = "会让你的身体变成一种明显而病态的绿色。"
	// below is functionally equivalent to dying and being resurrected via astrata T4 - yep, this is what it gives you.
	added_traits = list(TRAIT_EASYDISMEMBER, TRAIT_NOPAIN, TRAIT_NOPAINSTUN, TRAIT_NOBREATH, TRAIT_TOXIMMUNE, TRAIT_ZOMBIE_IMMUNE, TRAIT_ROTMAN, TRAIT_SILVER_WEAK)

/datum/virtue/combat/rotcured/apply_to_human(mob/living/carbon/human/recipient)
	recipient.update_body() // applies the rot skin tone stuff

/datum/virtue/combat/dualwielder
	name = "双持者"
	desc = "无论是纳莱迪学者、伊特鲁斯卡私掠者，还是风郡导师，都曾让我受益，教会了我如何同时驾驭两把武器。"
	added_traits = list(TRAIT_DUALWIELDER)

/datum/virtue/combat/sharp
	name = "机敏卫士"
	desc = "无论是因为有个老拿棍子戳我的烦人兄弟，还是多年研习与观察所致，我都已学会通过洞察强敌的动作来熟练格挡与闪避。"
	added_traits = list(TRAIT_SENTINELOFWITS)

/datum/virtue/combat/combat_aware
	name = "战斗感知"
	desc = "对手手腕的一抖，锁子甲断裂的声响，以及敌人体力衰竭时那绝望的喘息。这一切都会因你的直觉或经验而变得更加清晰。"
	custom_text = "会通过浮动文字显示更多战斗信息，并可手动开关。"
	added_traits = list(TRAIT_COMBAT_AWARE)

/datum/virtue/combat/combat_aware/apply_to_human(mob/living/carbon/human/recipient)
	recipient.verbs += /mob/living/carbon/human/proc/togglecombatawareness

/datum/virtue/combat/tough_hide
	name = "天然护甲"
	desc = "无论出于天生还是后天原因，我的皮肤都坚韧得足以抵御穿刺与切割。"
	custom_text = "这会以一件会再生且无法卸下的护甲替换你的上衣栏位。"
	added_traits = list(TRAIT_NATURALARMOR)

/datum/virtue/combat/tough_hide/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(!recipient)
		return

	// Remove whatever shirt they spawned with
	var/obj/item/clothing/shirt = recipient.wear_shirt
	if(shirt)
		qdel(shirt)

	// Equip the skin armor
	recipient.equip_to_slot_or_del(
		new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/weak(recipient),
		SLOT_SHIRT,
		TRUE
	)
	
	if(alert(recipient, "你想更改这层皮肤的名称或描述吗？", "TOUGH HIDE", "就这么办", "我放弃") == "就这么办") // Query user
		addtimer(CALLBACK(src, .proc/customize_skin, recipient), 1 SECONDS)

/datum/virtue/combat/tough_hide/proc/customize_skin(mob/living/carbon/human/recipient)
	var/obj/item/clothing/hide = recipient.wear_shirt
	var/vanished_hide = FALSE
	if(!QDELETED(hide))
		var/inputty = stripped_input(recipient, "你想给这层皮肤起什么名字？", "TOUGH HIDE", null, 200)
		if(!QDELETED(hide))
			if(inputty)
				hide.name = inputty
		else
			vanished_hide = TRUE
		inputty = stripped_input(recipient, "你会如何描述这层皮肤？", "TOUGH HIDE", null, 200)
		if(!QDELETED(hide))
			if(inputty)
				hide.desc = inputty
		else
			vanished_hide = TRUE
	else
		vanished_hide = TRUE

	if(vanished_hide) //failsafe
		to_chat(recipient, span_warning("我的天然护甲消失了！也许需要某种神圣干预才能解决......"))
