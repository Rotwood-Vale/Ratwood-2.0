#define CHOICE_POISON_BLADE "poison & knife"
#define CHOICE_SKILLS "skills"

/datum/antagonist/aspirant
	name = "觊觎者"
	roundend_category = "觊觎者"
	antagpanel_category = "觊觎者"
	job_rank = ROLE_ASPIRANT
	show_in_roundend = FALSE
	confess_lines = list(
		"天选者必须登上王座！",
	)
	increase_votepwr = FALSE
	rogue_enabled = TRUE
	antag_flags = FLAG_FAKE_ANTAG

	var/static/list/equipment_selection = list(
		"斗篷与匕首（毒药与小刀）" = CHOICE_POISON_BLADE,
		"钉头锤与开锁技巧" = CHOICE_SKILLS
	)

/datum/antagonist/aspirant/proc/give_equipment_prompt()
	var/chosen = input(owner.current, "我该如何攫取权力？", "你的优势") as anything in equipment_selection
	var/mob/aspirant_mob = owner.current
	chosen = LAZYACCESS(equipment_selection, chosen)
	switch(chosen)
		if(CHOICE_POISON_BLADE)
			owner.special_items["毒药"] = /obj/item/reagent_containers/glass/bottle/rogue/poison
			owner.special_items["杀手小刀"] = /obj/item/rogueweapon/huntingknife/idagger/steel/corroded
			to_chat(owner, span_notice("我可以通过右键雕像、树木或时钟来取回我的物品。"))
			aspirant_mob.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)	//Expert knives cus you're not getting much else.
		if(CHOICE_SKILLS)
			owner.special_items["钉头锤"] = /obj/item/rogueweapon/mace/cudgel		//Go knock him out lol
			owner.special_items["锁链"] = /obj/item/rope/chain
			owner.special_items["开锁器"] = /obj/item/lockpickring/mundane
			to_chat(owner, span_notice("我可以通过右键雕像、树木或时钟来取回我的物品。"))
			aspirant_mob.adjust_skillrank_up_to(/datum/skill/combat/maces, 5)	//Kinda huge with how maces are but - you're kinda not a frag-lord, you're to coup so. Works.
			aspirant_mob.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, 5)


/datum/antagonist/aspirant/supporter
	name = "支持者"

/datum/antagonist/aspirant/loyalist
	name = "忠臣"

/datum/antagonist/aspirant/ruler
	name = "统治者"

/datum/antagonist/aspirant/on_gain()
	. = ..()
	owner.special_role = ROLE_ASPIRANT
	SSmapping.retainer.aspirants |= owner
	addtimer(CALLBACK(src, PROC_REF(give_equipment_prompt)), 5 SECONDS)

/datum/antagonist/aspirant/greet()
	to_chat(owner, span_danger("我早已厌倦了只在王座旁徘徊，却从未真正坐上去。现在，是时候由我来统治这片国度了。"))
	..()

/datum/antagonist/aspirant/loyalist/greet()
	to_chat(owner, span_danger("[SSticker.rulertype]万岁！我忠于我的统治者。但我听说有人意图推翻他们。我绝不能让这种事发生。"))

/datum/antagonist/aspirant/supporter/greet()
	to_chat(owner, span_danger("[SSticker.rulertype]万岁！但不是这一位。我已被一名觊觎者拉拢，投入其事业。我必须确保他登上王座。"))

/datum/antagonist/aspirant/ruler/greet() // No alert for the ruler to always keep them guessing.

/datum/antagonist/aspirant/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(.)
		if(!((new_owner.assigned_role in GLOB.noble_positions) || (new_owner.assigned_role in GLOB.garrison_positions) || (new_owner.assigned_role in GLOB.courtier_positions)))
			return FALSE

/datum/antagonist/aspirant/on_gain()
	. = ..()
	create_objectives()
	if(istype(src, /datum/antagonist/aspirant/ruler))
		return
	owner.announce_objectives()

/datum/antagonist/aspirant/on_removal()
	remove_objectives()
	. = ..()

/datum/antagonist/aspirant/proc/create_objectives()
	if(istype(src, /datum/antagonist/aspirant/ruler))
		var/datum/objective/aspirant/loyal/one/G = new
		objectives += G
		return
	if(istype(src, /datum/antagonist/aspirant/loyalist))
		var/datum/objective/aspirant/loyal/two/G = new
		objectives += G
		G.initialruler = SSticker.rulermob
		return
	if(istype(src, /datum/antagonist/aspirant/supporter))
		var/datum/objective/aspirant/coup/three/G = new
		objectives += G
		for(var/datum/mind/aspirant in SSmapping.retainer.aspirants)
			if(aspirant.special_role == "Aspirant")
				G.aspirant = aspirant.current
		return
	else
		var/datum/objective/aspirant/coup/one/G = new
		objectives += G
		if(prob(50))
			var/datum/objective/aspirant/coup/two/M = new
			objectives += M
			M.initialruler = SSticker.rulermob


/datum/antagonist/aspirant/proc/remove_objectives()

// OBJECTIVES
/datum/objective/aspirant/coup/one
	name = "觊觎者"
	explanation_text = "我必须确保自己被加冕为大公。"
	triumph_count = 5

/datum/objective/aspirant/coup/one/check_completion()
	if(owner?.current == SSticker.rulermob)
		return TRUE
	else
		return FALSE

/datum/objective/aspirant/coup/two
	name = "道义"
	explanation_text = "我不是弑亲者，我必须确保大公不会死。"
	triumph_count = 10
	var/initialruler

/datum/objective/aspirant/coup/three
	name = "希冀"
	explanation_text = "我必须确保觊觎者登上王座。"
	var/aspirant

/datum/objective/aspirant/coup/two/check_completion()
	var/mob/living/carbon/human/kin = initialruler
	if(!initialruler)
		return FALSE
	if(!kin.stat)
		return TRUE
	else return FALSE

/datum/objective/aspirant/loyal/one
	name = "统治者"
	explanation_text = "我必须继续作为大公统治。"
	triumph_count = 3

/datum/objective/aspirant/loyal/one/check_completion()
	if(owner?.current == SSticker.rulermob)
		return TRUE
	else
		return FALSE

/datum/objective/aspirant/loyal/two
	name = "忠臣"
	explanation_text = "我必须确保大公继续统治。"
	triumph_count = 3
	var/initialruler

/datum/objective/aspirant/loyal/two/check_completion()
	if(!initialruler)
		return FALSE
	if(SSticker.rulermob == initialruler)
		return TRUE
	else return FALSE

/datum/antagonist/aspirant/roundend_report()
	to_chat(world, span_header(" * [name] * "))

	if(objectives.len)
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				to_chat(world, "<B>目标 #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>凯旋！</span>")
				owner.adjust_triumphs(objective.triumph_count)
			else
				to_chat(world, "<B>目标 #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>失败。</span>")
				win = FALSE
			objective_count++
		if(win)
			to_chat(world, span_greentext("觊觎者已登上高位！成功！"))
		else
			to_chat(world, span_redtext("觊觎者被挫败了！失败！"))

/datum/antagonist/aspirant/ruler/roundend_report()
	to_chat(owner, span_header(" * [name] * "))

	if(objectives.len)
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				to_chat(owner, "<B>目标 #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>凯旋！</span>")
				owner.adjust_triumphs(objective.triumph_count)
			else
				to_chat(owner, "<B>目标 #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>失败。</span>")
				win = FALSE
			objective_count++
		if(win)
			to_chat(owner, span_greentext("你守住了自己的王座！成功！"))
		else
			to_chat(owner, span_redtext("你被废黜了！失败！"))

/datum/antagonist/aspirant/supporter/roundend_report()
	to_chat(owner, span_header(" * [name] * "))

	if(objectives.len)
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				to_chat(owner, "<B>目标 #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>凯旋！</span>")
				owner.adjust_triumphs(objective.triumph_count)
			else
				to_chat(owner, "<B>目标 #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>失败。</span>")
				win = FALSE
			objective_count++
		if(win)
			to_chat(owner, span_greentext("你支持的觊觎者登上了王座！成功！"))
		else
			to_chat(owner, span_redtext("你支持的觊觎者失败了！失败！"))

/datum/antagonist/aspirant/loyalist/roundend_report()
	to_chat(owner, span_header(" * [name] * "))

	if(objectives.len)
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				to_chat(owner, "<B>目标 #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>凯旋！</span>")
				owner.adjust_triumphs(objective.triumph_count)
			else
				to_chat(owner, "<B>目标 #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>失败。</span>")
				win = FALSE
			objective_count++
		if(win)
			to_chat(owner, span_greentext("你的统治者保住了王座！成功！"))
		else
			to_chat(owner, span_redtext("你的统治者被废黜了！失败！"))
