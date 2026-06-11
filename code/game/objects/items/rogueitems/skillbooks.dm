/obj/item/skillbook
	name = "空白技能书"
	desc = "一本能提升技能的书。"
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "basic_book_0"
	var/open = FALSE
	var/iconval = 0
	var/skill_req = 0 //how much skill we need baseline to read this
	var/skill_cap = 0 //how much exp we can gain (up to this level) from reading
	var/datum/skill/subject = null //what reading this book will give exp toward
	var/complete = TRUE
	var/writing_page = FALSE//use this to determine whether we've added a new page and need to write it prior to finishing the book. We start with one unwritten page after crafting.
	var/wellwritten = FALSE //if the author has TRAIT_GOODWRITER
	grid_width = 32
	grid_height = 32

/obj/item/skillbook/Initialize(mapload)
	iconval = rand(0,9)//lets us randomize from all our books from books.dmi
	update_icon()
	..()


/obj/item/skillbook/update_icon()
	if(complete)
		switch(iconval)
			if(0)
				icon_state = "basic_book_[open]"
			if(1)
				icon_state = "book_[open]"
			if(9)
				icon_state = "knowledge_[open]"
			else
				icon_state = "book[iconval]_[open]"


/obj/item/skillbook/proc/set_bookstats(req,cap,topic)
	if(complete)
		skill_req = req
		skill_cap = cap
		subject = topic
		var/prefix //basic implication of how complicated the book is

		switch(skill_cap)
			if(3)
				prefix = "入门"
			if(4)
				prefix = "基础"
			if(5)
				prefix = "精通"
			if(6)
				prefix = "真知"
			else //1 or 2
				prefix = "初学"
		if(subject)
			name = "[GetSkillRef(subject)]之[prefix]"


/obj/item/skillbook/examine(mob/user)
	. = ..()
	var/basic_literacy = FALSE //books that are specifically about teaching low-skilled reading are assumed to be foundational knowledge and thus anyone can pick up the book
	if(subject)
		if(subject == /datum/skill/misc/reading && skill_cap <= 2)
			basic_literacy = TRUE
		. += span_notice("它专讲[GetSkillRef(subject)]。")
		if(skill_cap)
			if(in_range(user, src))
				if(!user.get_skill_level(/datum/skill/misc/reading))
					if(basic_literacy)
						. += span_notice("我可以用它来学习识字。")
					else
						. += span_warning("我无法看懂其中内容。")
				else
					. += span_notice("它适合具备[get_text(skill_req)]水平的读者，可将你的技能提升至[get_text(skill_cap)]。")
					if(wellwritten)
						. += span_nicegreen("这本书写得格外出色。")
			else
				. += span_warning("不靠近些，我看不清它的细节。")

/obj/item/skillbook/attack_self(mob/living/user)
	var/reading_skill = user.get_skill_level(/datum/skill/misc/reading)
	var/subject_skill = user.get_skill_level(subject)//our reader's current knowledge on the book's subject
	if(complete)
		if(open)
			to_chat(user, span_warning("我已经在阅读[src]了！"))
			return
		if(reading_skill < skill_req || subject_skill < skill_req)//if our literacy skill or our skill in the topic is below the base requirement
			to_chat(user, span_warning("[src]对我来说太深奥了！"))
			return
		if(subject_skill >= skill_cap)
			to_chat(user, span_warning("[src]能教我的东西，我已经全都懂了！"))
			return
		if(HAS_TRAIT(user, TRAIT_STUDENT))//stops you from blasting your brain with 10000 skills
			to_chat(user, span_warning("我暂时已经学得太多了。"))
			return
		if(user?.mind?.sleep_adv.enough_sleep_xp_to_advance(subject, 2))//don't read it if we have a !! in the skill
			to_chat(user, span_warning("我脑中关于[src]的知识已经太满了，需要先休息并整理心得。"))
			return
		to_chat(user,("我开始阅读[src]。"))
		open = TRUE
		update_icon()
		var/reading_duration = 80
		var/reading = TRUE
		var/reading_acceleration = 0 //decreases the amount of time to read the longer you read, up to 4 seconds (half the default time)
		while(reading)
			if(do_after(user, reading_duration - (reading_acceleration * 10)))
				if(reading_acceleration < 4)
					reading_acceleration++
					if(reading_acceleration == 2)
						to_chat(user,("我渐渐进入了阅读[src]的状态。"))
					if(reading_acceleration == 4)
						to_chat(user,("我已经完全沉浸在[src]之中了。"))
				if(subject != /datum/skill/misc/reading)//if our topic isn't literacy, we still gain a little bit of literacy skill
					add_sleep_experience(user, /datum/skill/misc/reading, user.STAINT*0.75)
				add_sleep_experience(user, subject, user.STAINT * (1.5 * (wellwritten+1)))//if the book is well-written, gain 2x exp on the subject
				subject_skill = user.get_skill_level(subject)//update after we gain exp to see if we've leveled up
				var/skill_difference = skill_cap - subject_skill//3 different cases: 1, we've reached !! level. 2, We've outleveled the book normally. 3, we've outleveled the book via sleep exp
				if(user?.mind?.sleep_adv.enough_sleep_xp_to_advance(subject, min(skill_difference,2)) || skill_difference <= 0)
					reading = FALSE
					ADD_TRAIT(user, TRAIT_STUDENT, TRAIT_GENERIC)
					to_chat(user,span_notice("我从[src]中学到了很多，在再次阅读前需要先休息。"))
			else //we moved or were otherwise interrupted
				reading = FALSE
		to_chat(user,("我停止阅读[src]。"))
		open = FALSE
		update_icon()
	else
		if(writing_page)
			if(!skill_cap)
				choose_skill(user)
				return
			to_chat(user, span_notice("我从[src]里抽出一页。"))
			new /obj/item/paper(get_turf(src))
			writing_page = FALSE
			return
		if(reading_skill < skill_cap || subject_skill < skill_cap)//You couldn't have written this book so you're not allowed to get the exp for finishing it
			to_chat(user, span_warning("我没法对[src]做什么。"))
			return
		if(alert("准备好完成这本书了吗？", "写作者", "是", "否") == "是")
			to_chat(user,"我开始完成最后的书写……")
			if(do_after(user, 50))
				to_chat(user, span_notice("我完成了这本书！"))
				add_sleep_experience(user, /datum/skill/misc/reading, user.STAINT*1.5)//decently more than writing the book
				var/obj/item/skillbook/newbook = new /obj/item/skillbook(get_turf(src))
				newbook.set_bookstats(skill_req,skill_cap,subject)
				if(HAS_TRAIT(user, TRAIT_GOODWRITER))
					newbook.wellwritten = TRUE
				qdel(src)



/obj/item/skillbook/unfinished
	name = "未完成的技能书"
	desc = "一份等待你写入学识的空白模板。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "grudge"
	complete = FALSE
	writing_page = TRUE


/obj/item/skillbook/unfinished/examine(mob/user)
	. = ..()
	if(writing_page)
		. += span_notice("还有一页空白纸张等待填写。")


/obj/item/skillbook/unfinished/attackby(obj/item/I, mob/living/user)
	if(I.get_sharpness())
		to_chat(user, span_warning("[user]把[src]拆开了。"))
		for(var/papers = 0, papers < skill_cap, papers++)//put down as many papers as the unfinished book contains
			new /obj/item/paper(get_turf(src))
		if(writing_page)//one extra paper since the unwritten page isn't currently counted toward our book's skill level
			new /obj/item/paper(get_turf(src))
		qdel(src)

	var/writing_skill = user.get_skill_level(/datum/skill/misc/reading)
	var/subject_skill = user.get_skill_level(subject)
	if(istype(I, /obj/item/natural/feather) || istype(I, /obj/item/natural/thorn))
		if(!writing_skill)
			to_chat(user, span_warning("我不识写字！"))
			return
		if(!subject)
			choose_skill(user)
			return

		if(!locate(/obj/structure/table) in src.loc)
			to_chat(user, span_warning("我得借助一张桌子。"))
			return FALSE
		if(skill_cap >= subject_skill)
			to_chat(user, span_warning("我已经没有更多内容可写进[src]了！"))
			return
		if(skill_cap >= writing_skill)
			to_chat(user, span_warning("我对[GetSkillRef(subject)]懂得更多，可一时想不出该怎么写下来……"))
			return
		if(!writing_page)
			to_chat(user, span_warning("若想继续写下去，我得先给[src]再添一页。"))
			return


		var/writing_duration = 150
		writing_duration -= ((writing_skill - skill_cap) * 10)//-1 second per literacy skill, subtracted by how complicated our book currently is
		writing_duration -= ((subject_skill - skill_cap) * 10)//also -1 second per our competency in the subject
		to_chat(user,("我开始在[src]中书写……"))
		if(!do_after(user, writing_duration))
			to_chat(user, span_warning("我没能写完刚才那一页。"))
			return
		user.visible_message(span_notice("[user]在[src]中写下一页。"), span_notice("我写完了[src]的一页。"))
		skill_cap++
		add_sleep_experience(user, /datum/skill/misc/reading, user.STAINT)
		if((skill_cap - 2) > skill_req)//the higher the level cap, the higher the base skill level required to understand its topics
			skill_req++
			to_chat(user, ("随着知识增加，[src]也变得更难理解了。"))
		writing_page = FALSE

	if(I.type == /obj/item/paper)//no istype 'cuz scrolls are a paper subtype
		if(writing_page)
			to_chat(user, span_warning("我还没写完当前这一页！"))
			return
		if(skill_cap == subject.max_skillbook_level)//our readable skill cap defined in skill the datum itself
			to_chat(user, span_warning("这个主题往后需要亲身实践才能继续学习，再写下去也没有意义。"))
			return
		if(skill_cap >= subject_skill)
			to_chat(user, span_warning("我已经没有更多内容可写进[src]了！"))
			return
		if(skill_cap == SKILL_LEVEL_APPRENTICE)//breakpoint for when books require a minimum requirement to read, so it prompts the author if they want to continue
			if(alert("继续写下去将要求读者具备该技能经验后才能读懂。", "继续吗？", "是", "否") == "否")
				return
		to_chat(user, span_notice("我在[src]中添入新的一页。"))
		writing_page = TRUE
		qdel(I)

/obj/item/skillbook/proc/choose_skill(mob/living/user)
	if(!complete)
		var/list/writable_skills = list()
		var/list/skill_names = list()//we use this in the user input window for the names of the skills
		if(user.mind)
			for(var/skill_type in SSskills.all_skills)
				var/datum/skill/skill = GetSkillRef(skill_type)
				if(skill in user.skills?.known_skills)
					if(skill.max_skillbook_level > 0)//max_skillbook_level is defined in the skill datum itself, if it's 0 we can't write on it at all
						LAZYADD(skill_names, skill)
						LAZYADD(writable_skills,skill_type)
			if(!length(writable_skills))//nobody has ever been as dumb as you are. feel bad.
				to_chat(user, span_warning("我没有任何值得写下的知识。"))
				return
		var/skill_choice = input(user, "开始你的著述", "技能") as null|anything in skill_names
		if(skill_choice)
			for(var/real_skill in writable_skills)//real_skill is the actual datum for the skill rather than the "Skill" string
				if(skill_choice == GetSkillRef(real_skill))//if skill_choice (the name string) is equal to real_skill's name ref, essentially
					subject = real_skill
					name = "未完成的技能书"//resets name so we don't get a bunch of slop appends from changing the subject more than once
					to_chat(user, span_notice("我将[src]定为[skill_choice]主题。接下来需要一根荆棘或羽毛来书写。"))
					name += " ([skill_choice])"
		else
			to_chat(user, span_notice("也许以后再说。"))

/obj/item/skillbook/proc/get_text(skill_value)
	switch(skill_value)
		if(SKILL_LEVEL_NOVICE)
			return "新手"
		if(SKILL_LEVEL_APPRENTICE)
			return "学徒"
		if(SKILL_LEVEL_JOURNEYMAN)
			return "熟练"
		if(SKILL_LEVEL_EXPERT)
			return "专家"
		if(SKILL_LEVEL_MASTER)
			return "大师"
		if(SKILL_LEVEL_LEGENDARY)
			return "传奇"
		else
			return "任意"//people who have 0 skill, aka SKILL_LEVEL_NONE
