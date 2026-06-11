//A spell to teach other characters new skills
/obj/effect/proc_holder/spell/invoked/teach
	name = "导师之召"
	desc = "你可以向他人传授一项技能或语言，前提是对方在这方面的造诣不高于你。 \n\
	你不能向同一人教授两次。教学耗时 30 秒，且你与学生都必须专心听讲。"
	overlay_state = "book3"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE
	range = 2

/obj/effect/proc_holder/spell/invoked/teach/cast(list/targets, mob/user = usr)
	. = ..()
	var/list/choices = list()
	var/mob/living/L = targets[1]
	var/list/datum/skill/skill_choices = list(
	//skills alphabetically... this will be sloppy based on the descriptive name but easier for devs
	/datum/skill/craft/alchemy,
	/datum/skill/magic/arcane,
	/datum/skill/craft/armorsmithing,

	/datum/skill/craft/blacksmithing,
	/datum/skill/labor/butchering,

	/datum/skill/craft/carpentry,
	/datum/skill/craft/ceramics,
	/datum/skill/misc/climbing,
	/datum/skill/craft/cooking,
	/datum/skill/craft/crafting,

	/datum/skill/craft/engineering,

	/datum/skill/labor/farming,
	/datum/skill/labor/fishing,

	/datum/skill/misc/lockpicking,
	/datum/skill/labor/lumberjacking,

	/datum/skill/craft/masonry,
	/datum/skill/labor/mining,
	/datum/skill/misc/music,
	/datum/skill/misc/medicine,



	/datum/skill/craft/sewing,
	/datum/skill/craft/smelting,
	/datum/skill/misc/sneaking,
	/datum/skill/misc/stealing,
	/datum/skill/misc/swimming,

	/datum/skill/craft/tanning,
	/datum/skill/misc/tracking,

	/datum/skill/misc/reading,
	/datum/skill/misc/riding,

	/datum/skill/craft/weaponsmithing,

	//Languages
	/datum/language/aavnic,
	/datum/language/celestial,
	/datum/language/draconic,
	/datum/language/dwarvish,
	/datum/language/elvish,
	/datum/language/etruscan,
	/datum/language/grenzelhoftian,
	/datum/language/gronnic,
	/datum/language/hammerholdian,
	/datum/language/hellspeak,
	/datum/language/kazengunese,
	/datum/language/orcish,
	/datum/language/otavan	
	)
	for(var/i = 1, i <= skill_choices.len, i++)
		var/datum/skill/learn_item = skill_choices[i]
		if((L.get_skill_level(learn_item) < SKILL_LEVEL_NOVICE) && !(learn_item in list(/datum/language/aavnic, /datum/language/celestial, /datum/language/draconic, /datum/language/dwarvish, /datum/language/elvish, /datum/language/etruscan, /datum/language/grenzelhoftian, /datum/language/gronnic, /datum/language/hammerholdian, /datum/language/hellspeak, /datum/language/kazengunese, /datum/language/orcish, /datum/language/otavan)))
			continue //skip if they don't have enough skill
		if(L.get_skill_level(learn_item) > SKILL_LEVEL_EXPERT)
			continue //skip if they know too much
		if (L.has_language(learn_item))
			continue //skip if they know the language
		choices["[learn_item.name]"] = learn_item
	

	var/teachingtime = 30 SECONDS

	if(isliving(targets[1]))
		if(L == usr)
			to_chat(L, span_warning("若由我自己教自己，我便同时成了问题与答案。"))
			return
		else
			if(L in range(1, usr))
				to_chat(usr, span_notice("我的学生需要一点时间来选择课程。"))
				var/chosen_skill = input(L, "大多数课程都要求你在所选技能上至少达到新手水平", "选择技能") as null|anything in choices
				var/datum/skill/item = choices[chosen_skill]
				if(!item)
					return  // student canceled
				if(alert(L, "你确定要学习[item.name]吗？", "学习", "学习", "取消") == "取消")
					return
				if(HAS_TRAIT(L, TRAIT_STUDENT))
					to_chat(L, span_warning("这么多知识我根本承受不住！"))
					to_chat(usr, span_warning("我的学生一下子承受不了这么多知识！"))
					return // cannot teach the same student twice
				if(!(item in list(/datum/skill/misc/music, /datum/skill/craft/cooking, /datum/skill/craft/sewing, /datum/skill/misc/lockpicking, /datum/skill/misc/climbing, /datum/language/aavnic, /datum/language/celestial, /datum/language/draconic, /datum/language/dwarvish, /datum/language/elvish, /datum/language/etruscan, /datum/language/grenzelhoftian, /datum/language/gronnic, /datum/language/hammerholdian, /datum/language/hellspeak, /datum/language/kazengunese, /datum/language/orcish, /datum/language/otavan)) && L.get_skill_level(item) < SKILL_LEVEL_NOVICE)
					to_chat(L, span_warning("我还听不懂关于[item.name]的课程，我得先提升自己的基础！"))
					to_chat(usr, span_warning("我试着向[L]传授[item.name]，但学生还是没能领会这堂课！"))
					return // some basic skill will not require you novice level
				if(L.has_language(item))
					to_chat(L, span_warning("这个我已经会了！[item.name]！"))
					to_chat(usr, span_warning("对方已经会说[item.name]了！"))
					return // we won't teach someone a language they already know
				if(L.get_skill_level(item) > SKILL_LEVEL_EXPERT)
					to_chat(L, span_warning("关于[item.name]，那个人已经没有什么可教我的了！"))
					to_chat(usr, span_warning("对方对[item.name]的掌握比我还深，我真该来当老师吗？"))
					return // a student with master or legendary skill have nothing to learn from the scholar
				else
					to_chat(L, span_notice("[usr]开始向我传授[item.name]!"))
					to_chat(usr, span_notice("[L]开始认真听我讲授[item.name]。"))
					if((item in list(/datum/language/aavnic, /datum/language/celestial, /datum/language/draconic, /datum/language/dwarvish, /datum/language/elvish, /datum/language/etruscan, /datum/language/grenzelhoftian, /datum/language/gronnic, /datum/language/hammerholdian, /datum/language/hellspeak, /datum/language/kazengunese, /datum/language/orcish, /datum/language/otavan)))
						if(do_after(usr, teachingtime, target = L))
							user.visible_message("<font color='yellow'>[user]向[L]传授了一课。</font>")
							to_chat(usr, span_notice("我的学生学会了[item.name]这门语言！"))
							L.grant_language(item)
							ADD_TRAIT(L, TRAIT_STUDENT, "[type]")
						else
							to_chat(usr, span_warning("[L]分心走开了！"))
							to_chat(L, span_warning("我必须把注意力更集中在学习上！"))
						//teach a language! If this works out, we can make a TRAIT_STUDENT_LANGUAGE later, so a language and a skill can be taught in the same week. small steps for now


					else
						if(L.get_skill_level(item) < SKILL_LEVEL_APPRENTICE) // +2 skill levels if novice or no skill
							if(do_after(usr, teachingtime, target = L))
								user.visible_message("<font color='yellow'>[user] teaches [L] a lesson.</font>")
								to_chat(usr, span_notice("我的学生对[item.name]的掌握大有长进！"))
								L.adjust_skillrank(item, 2, FALSE)
								ADD_TRAIT(L, TRAIT_STUDENT, "[type]")
							else
								to_chat(usr, span_warning("[L] got distracted and wandered off!"))
								to_chat(L, span_warning("I must be more focused on my studies!"))
								return
						else  // +1 skill level if apprentice or better
							if(do_after(usr, teachingtime, target = L))
								user.visible_message("<font color='yellow'>[user]向[L]传授了一课。</font>")
								to_chat(usr, span_notice("我的学生对[item.name]更加熟练了！"))
								L.adjust_skillrank(item, 1, FALSE)
								ADD_TRAIT(L, TRAIT_STUDENT, "[type]")
							else
								to_chat(usr, span_warning("[L]分心走开了！"))
								to_chat(L, span_warning("我必须把注意力更集中在学习上！"))
								return
			else
				to_chat(usr, span_warning("我的学生在那边几乎听不见我说话。"))
				return
	else
		revert_cast()
		return FALSE
