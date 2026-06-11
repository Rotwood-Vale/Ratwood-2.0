/obj/effect/proc_holder/spell/invoked/learn
	name = "向他人学习"
	overlay_state = "knowledge"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE
	range = 2

/obj/effect/proc_holder/spell/invoked/learn/cast(list/targets, mob/user = usr)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/teacher = targets[1]
		if(teacher == user)
			to_chat(user, span_warning("若由我自己教自己，我便同时成了问题与答案。"))
			revert_cast()
			return
		if(HAS_TRAIT(user, TRAIT_STUDENT))
			to_chat(user, span_warning("这段时间里，我已经学不到更多了。"))
			revert_cast()
			return
		if(teacher.cmode)//to hopefully stop you from trolling someone with a dialogue box during combat
			to_chat(user, span_warning("[teacher]正在战斗中！"))
			to_chat(teacher, span_warning("[user]想向你学习，但你正在战斗中。"))//notify them since they might not ACTUALLY be in combat, just have cmode on
			revert_cast()
			return
		if(!(teacher in range(2, user)))
			revert_cast()
			return FALSE
		to_chat(usr, span_notice("我请求[teacher]传授我[teacher.p_their()]的一项技能。"))
		if(alert(teacher, "要把你的一项技能传授给[user]吗？", "教学", "是", "否") != "是")
			to_chat(user, span_warning("[teacher]决定保留[teacher.p_their()]的知识，不向外传授。"))
			revert_cast()
			return
		to_chat(user, span_nicegreen("[teacher]决定教导你。靠近一些，等对方决定要传授什么......"))

		var/list/known_skills = list()
		var/list/skill_names = list()//we use this in the user input window for the names of the skills
		if(teacher.mind)
			var/teacher_skill = 0
			var/user_skill = 0
			for(var/skill_type in SSskills.all_skills)
				var/datum/skill/skill = GetSkillRef(skill_type)
				if(skill in teacher.skills?.known_skills)
					teacher_skill = teacher.get_skill_level(skill_type)
					user_skill = user.get_skill_level(skill_type)
					if(teacher_skill > user_skill)//only add it to the list of teachable stuff if the spellcaster can gain skill in it
						LAZYADD(skill_names, skill)
						LAZYADD(known_skills,skill_type)

			if(!length(known_skills))
				to_chat(teacher, span_warning("[user]已经掌握了我能教的一切。"))
				to_chat(user, span_warning("[teacher]已经没什么能教我的了。"))
				revert_cast()
				return
			var/skill_choice = input(teacher, "选择要教授的技能","技能") as null|anything in skill_names
			if(skill_choice)
				for(var/real_skill in known_skills)//real_skill is the actual datum for the skill rather than the "Skill" string
					if(skill_choice == GetSkillRef(real_skill))//if skill_choice (the name string) is equal to real_skill's name ref, essentially
						if(!(teacher in range(2, user)))
							to_chat(teacher, span_warning("我离[user]太远了。"))
							to_chat(user, span_warning("[teacher]离我太远了。"))
							revert_cast()
							return
						teacher.visible_message(("[teacher]开始向[user]传授[skill_choice]。"), ("我开始向[user]传授[skill_choice]。"))
						if(!do_mob(user, teacher, 100))
							to_chat(teacher, span_warning("我离[user]太远了。"))
							to_chat(user, span_warning("[teacher]离我太远了。"))
							revert_cast()
							return

						teacher_skill = teacher.get_skill_level(real_skill)
						user_skill = user.get_skill_level(real_skill)
						if(teacher_skill - user_skill > 2) //if the teacher has over two levels over the user, add 2 levels of skill to the user
							user.adjust_skillrank(real_skill, 2, FALSE)
							user.visible_message(span_notice("[teacher]向[user]传授了[skill_choice]。"), span_notice("我对[skill_choice]的掌握大有长进！"))
						else //if the teacher has 2 or 1 levels over the user, only add 1 level
							user.adjust_skillrank(real_skill, 1, FALSE)
							user.visible_message(span_notice("[teacher]向[user]传授了[skill_choice]。"), span_notice("我对[skill_choice]的掌握更熟练了！"))
						ADD_TRAIT(user, TRAIT_STUDENT, TRAIT_GENERIC)
	revert_cast()
	return FALSE
