/obj/item/skillbook
	name = "blank skillbook"
	desc = "A book to improve your skills."
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

/obj/item/skillbook/Initialize()
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
				prefix = "Grasp"
			if(4)
				prefix = "Foundations"
			if(5)
				prefix = "Mastery"
			if(6)
				prefix = "True knowledge"
			else //1 or 2
				prefix = "Basics"
		if(subject)
			name = "[prefix] of [GetSkillRef(subject)]"


/obj/item/skillbook/examine(mob/user)
	. = ..()
	var/basic_literacy = FALSE //books that are specifically about teaching low-skilled reading are assumed to be foundational knowledge and thus anyone can pick up the book
	if(subject)
		if(subject == /datum/skill/misc/reading && skill_cap <= 2)
			basic_literacy = TRUE
		. += span_notice("It's dedicated to [GetSkillRef(subject)].")
		if(skill_cap)
			if(in_range(user, src))
				if(!user.get_skill_level(/datum/skill/misc/reading))
					if(basic_literacy)
						. += span_notice("I can use this to learn how to read.")
					else
						. += span_warning("I can't ascertain its contents.")
				else
					. += span_notice("It's suitable for readers of [get_text(skill_req)] skill, and can raise your skill up to the level of [get_text(skill_cap)].")
					if(wellwritten)
						. += span_nicegreen("It's exceptionally well-written.")
			else
				. += span_warning("I can't see any of its specifics without getting closer.")

/obj/item/skillbook/attack_self(mob/living/user)
	var/reading_skill = user.get_skill_level(/datum/skill/misc/reading)
	var/subject_skill = user.get_skill_level(subject)//our reader's current knowledge on the book's subject
	if(complete)
		if(open)
			to_chat(user, span_warning("I'm already reading [src]!"))
			return
		if(reading_skill < skill_req || subject_skill < skill_req)//if our literacy skill or our skill in the topic is below the base requirement
			to_chat(user, span_warning("[src] is too complicated for me!"))
			return
		if(subject_skill >= skill_cap)
			to_chat(user, span_warning("I already know everything [src] can teach me!"))
			return
		if(HAS_TRAIT(user, TRAIT_STUDENT))//stops you from blasting your brain with 10000 skills
			to_chat(user, span_warning("I've already learned too much for the time being."))
			return
		if(user?.mind?.sleep_adv.enough_sleep_xp_to_advance(subject, 2))//don't read it if we have a !! in the skill
			to_chat(user, span_warning("My mind is already too full of [src]'s topics. I need to rest and reflect on my experience."))
			return
		to_chat(user,("I begin reading [src]."))
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
						to_chat(user,("I'm getting into the groove of reading [src]."))
					if(reading_acceleration == 4)
						to_chat(user,("I'm fully immersed in [src]."))
				if(subject != /datum/skill/misc/reading)//if our topic isn't literacy, we still gain a little bit of literacy skill
					add_sleep_experience(user, /datum/skill/misc/reading, user.STAINT*0.75)
				add_sleep_experience(user, subject, user.STAINT * (1.5 * (wellwritten+1)))//if the book is well-written, gain 2x exp on the subject
				subject_skill = user.get_skill_level(subject)//update after we gain exp to see if we've leveled up
				var/skill_difference = skill_cap - subject_skill//3 different cases: 1, we've reached !! level. 2, We've outleveled the book normally. 3, we've outleveled the book via sleep exp
				if(user?.mind?.sleep_adv.enough_sleep_xp_to_advance(subject, min(skill_difference,2)) || skill_difference <= 0)
					reading = FALSE
					ADD_TRAIT(user, TRAIT_STUDENT, TRAIT_GENERIC)
					to_chat(user,span_notice("I've learned a lot from [src]. I need to rest before reading again."))
			else //we moved or were otherwise interrupted
				reading = FALSE
		to_chat(user,("I stop reading [src]."))
		open = FALSE
		update_icon()
	else
		if(writing_page)
			if(!skill_cap)
				choose_skill(user)
				return
			to_chat(user, span_notice("I remove a page from [src]."))
			new /obj/item/paper(get_turf(src))
			writing_page = FALSE
			return
		if(reading_skill < skill_cap || subject_skill < skill_cap)//You couldn't have written this book so you're not allowed to get the exp for finishing it
			to_chat(user, span_warning("I can do nothing with [src]."))
			return
		if(alert("Are you ready to finish your book?", "Writer", "Yes", "No") == "Yes")
			to_chat(user,"I begin finalizing my writing...")
			if(do_after(user, 50))
				to_chat(user, span_notice("I finish the book!"))
				add_sleep_experience(user, /datum/skill/misc/reading, user.STAINT*1.5)//decently more than writing the book
				var/obj/item/skillbook/newbook = new /obj/item/skillbook(get_turf(src))
				newbook.set_bookstats(skill_req,skill_cap,subject)
				if(HAS_TRAIT(user, TRAIT_GOODWRITER))
					newbook.wellwritten = TRUE
				qdel(src)



/obj/item/skillbook/unfinished
	name = "unfinished skillbook"
	desc = "A blank template waiting for your expertise."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "grudge"
	complete = FALSE
	writing_page = TRUE


/obj/item/skillbook/unfinished/examine(mob/user)
	. = ..()
	if(writing_page)
		. += span_notice("There's a blank page that still needs to be filled.")


/obj/item/skillbook/unfinished/attackby(obj/item/I, mob/living/user)
	if(I.get_sharpness())
		to_chat(user, span_warning("[user] cuts [src] apart."))
		for(var/papers = 0, papers < skill_cap, papers++)//put down as many papers as the unfinished book contains
			new /obj/item/paper(get_turf(src))
		if(writing_page)//one extra paper since the unwritten page isn't currently counted toward our book's skill level
			new /obj/item/paper(get_turf(src))
		qdel(src)

	var/writing_skill = user.get_skill_level(/datum/skill/misc/reading)
	var/subject_skill = user.get_skill_level(subject)
	if(istype(I, /obj/item/natural/feather) || istype(I, /obj/item/natural/thorn))
		if(!writing_skill)
			to_chat(user, span_warning("I don't know how to write!"))
			return
		if(!subject)
			choose_skill(user)
			return

		if(!locate(/obj/structure/table) in src.loc)
			to_chat(user, span_warning("I need to use a table."))
			return FALSE
		if(skill_cap >= subject_skill)
			to_chat(user, span_warning("I know nothing left to add to [src]!"))
			return
		if(skill_cap >= writing_skill)
			to_chat(user, span_warning("I know more about [GetSkillRef(subject)], but I just can't think of the right words to write..."))
			return
		if(!writing_page)
			to_chat(user, span_warning("I'll need to add another page to [src] if I want to continue writing."))
			return


		var/writing_duration = 150
		writing_duration -= ((writing_skill - skill_cap) * 10)//-1 second per literacy skill, subtracted by how complicated our book currently is
		writing_duration -= ((subject_skill - skill_cap) * 10)//also -1 second per our competency in the subject
		to_chat(user,("I begin writing in [src]..."))
		if(!do_after(user, writing_duration))
			to_chat(user, span_warning("I don't finish what I was writing."))
			return
		user.visible_message(span_notice("[user] writes a page in [src]."), span_notice("I finish a page of [src]."))
		skill_cap++
		add_sleep_experience(user, /datum/skill/misc/reading, user.STAINT)
		if((skill_cap - 2) > skill_req)//the higher the level cap, the higher the base skill level required to understand its topics
			skill_req++
			to_chat(user, ("As I add knowledge, [src] becomes more difficult to understand."))
		writing_page = FALSE

	if(I.type == /obj/item/paper)//no istype 'cuz scrolls are a paper subtype
		if(writing_page)
			to_chat(user, span_warning("I'm not finished writing the current page!"))
			return
		if(skill_cap == subject.max_skillbook_level)//our readable skill cap defined in skill the datum itself
			to_chat(user, span_warning("This subject requires hands-on experience to learn further. There's no point in writing more."))
			return
		if(skill_cap >= subject_skill)
			to_chat(user, span_warning("I know nothing left to add to [src]!"))
			return
		if(skill_cap == SKILL_LEVEL_APPRENTICE)//breakpoint for when books require a minimum requirement to read, so it prompts the author if they want to continue
			if(alert("Continuing to write will require readers to have experience in the skill in order to read it.", "Continue?", "Yes", "No") == "No")
				return
		to_chat(user, span_notice("I place a new page into [src]."))
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
				to_chat(user, span_warning("I know nothing of value to write."))
				return
		var/skill_choice = input(user, "Begin your story","Skills") as null|anything in skill_names
		if(skill_choice)
			for(var/real_skill in writable_skills)//real_skill is the actual datum for the skill rather than the "Skill" string
				if(skill_choice == GetSkillRef(real_skill))//if skill_choice (the name string) is equal to real_skill's name ref, essentially
					subject = real_skill
					name = "unfinished skillbook"//resets name so we don't get a bunch of slop appends from changing the subject more than once
					to_chat(user, span_notice("I dedicate [src] to [skill_choice]. Now, I'll need a thorn or a feather to write with."))
					name += " ([skill_choice])"
		else
			to_chat(user, span_notice("Maybe later."))

/obj/item/skillbook/proc/get_text(skill_value)
	switch(skill_value)
		if(SKILL_LEVEL_NOVICE)
			return "novice"
		if(SKILL_LEVEL_APPRENTICE)
			return "apprentice"
		if(SKILL_LEVEL_JOURNEYMAN)
			return "journeyman"
		if(SKILL_LEVEL_EXPERT)
			return "expert"
		if(SKILL_LEVEL_MASTER)
			return "master"
		if(SKILL_LEVEL_LEGENDARY)
			return "legendary"
		else
			return "any"//people who have 0 skill, aka SKILL_LEVEL_NONE
