//A skill to help others learn new skills by forgetting old ones
/obj/effect/proc_holder/spell/invoked/refocusstudies
	name = "重整学业"
	desc = "帮助他人重新整理学业方向。牺牲一项高于熟手的技能等级，换取 3 点睡眠成长点数，并获得持续 30 分钟的增益，使智力 +2、意志 -1。"
	overlay_state = "book3"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE
	range = 2

/obj/effect/proc_holder/spell/invoked/refocusstudies/cast(list/targets, mob/user = usr)
	. = ..()
	var/list/choices = list()
	var/mob/living/L = targets[1]
	var/list/datum/skill/skill_choices = list(
	//skills alphabetically... this will be sloppy based on the descriptive name but easier for devs
	/datum/skill/craft/crafting,
	/datum/skill/craft/weaponsmithing,
	/datum/skill/craft/armorsmithing,
	/datum/skill/craft/blacksmithing,
	/datum/skill/craft/smelting,
	/datum/skill/craft/carpentry,
	/datum/skill/craft/masonry,
	/datum/skill/craft/cooking,
	/datum/skill/craft/engineering,
	/datum/skill/craft/tanning,
	/datum/skill/craft/alchemy,
	/datum/skill/craft/ceramics,
	/datum/skill/craft/sewing,

	/datum/skill/combat/knives,
	/datum/skill/combat/swords,
	/datum/skill/combat/polearms,
	/datum/skill/combat/maces,
	/datum/skill/combat/axes,
	/datum/skill/combat/whipsflails,
	/datum/skill/combat/bows,
	/datum/skill/combat/crossbows,
	/datum/skill/combat/wrestling,
	/datum/skill/combat/unarmed,
	/datum/skill/combat/shields,
	/datum/skill/combat/slings,

	/datum/skill/labor/farming,
	/datum/skill/labor/mining,
	/datum/skill/labor/fishing,
	/datum/skill/labor/butchering,
	/datum/skill/labor/lumberjacking,

	/datum/skill/magic/arcane,

	/datum/skill/misc/athletics,
	/datum/skill/misc/climbing,
	/datum/skill/misc/reading,
	/datum/skill/misc/swimming,
	/datum/skill/misc/stealing,
	/datum/skill/misc/sneaking,
	/datum/skill/misc/lockpicking,
	/datum/skill/misc/riding,
	/datum/skill/misc/music,
	/datum/skill/misc/medicine,
	/datum/skill/misc/tracking,
	)
	for(var/i = 1, i <= skill_choices.len, i++)
		var/datum/skill/learn_item = skill_choices[i]
		if((L.get_skill_level(learn_item) < SKILL_LEVEL_JOURNEYMAN))
			continue //skip if they're not high enough level to recycle a skill
		choices["[learn_item.name]"] = learn_item

	var/teachingtime = 30 SECONDS

	if(isliving(targets[1]))
		if(L == usr)
			to_chat(L, span_warning("我不能重整自己的学业，只能帮助他人。"))
			return
		else
			if(L in range(1, usr))
				to_chat(usr, span_notice("我的学生需要一点时间来选择要舍弃的学业。"))
				var/chosen_skill = input(L, "选择要舍弃哪项技能，你将返还 3 点睡眠点数，并获得帮助学习的增益。", "选择技能") as null|anything in choices
				var/datum/skill/item = choices[chosen_skill]
				if(!item)
					return  // student canceled
				if(alert(L, "你确定要失去 [item.name] 的一个等级吗？", "重整学业", "舍弃", "取消") == "取消")
					return
				if(L.has_status_effect(/datum/status_effect/buff/refocus))
					to_chat(L, span_warning("我最近才刚重整过学业。"))
					to_chat(usr, span_warning("我的学生这么快还无法再次重整学业。"))
					return // cannot teach the same student twice
				if(L.get_skill_level(item) < SKILL_LEVEL_JOURNEYMAN)
					to_chat(L, span_warning("我在 [item.name] 上的造诣还不够，无法舍弃它。"))
					to_chat(usr, span_warning("我试图教导 [L] 重整 [item.name]，但我的学生没能领会这堂课！"))
					return // some basic skill will not require you novice level
				else
					to_chat(L, span_notice("[usr] 开始教我如何重新聚焦自己的精力，我对 [item.name] 的掌握正慢慢流失！"))
					to_chat(usr, span_notice("[L] 正认真聆听我关于重整学业的讲授，他们对 [item.name] 的掌握正慢慢流失。"))
					if(do_after(usr, teachingtime, target = L))
						user.visible_message("<font color='yellow'>[user] 为 [L] 上了一课。</font>")
						to_chat(usr, span_notice("我的学生已完成重整学业，但失去了对 [item.name] 的一部分领悟！"))
						L.adjust_skillrank(item, -1, FALSE)
						L.apply_status_effect(/datum/status_effect/buff/refocus)
						L.mind.sleep_adv.sleep_adv_points += 3
					else
						to_chat(usr, span_warning("[L] 分了心，走神离开了！"))
						to_chat(L, span_warning("我必须把更多注意力放回学业上！"))
						return
			else
				to_chat(usr, span_warning("我的学生在那个距离几乎听不清我说话。"))
				return
	else
		revert_cast()
		return FALSE
