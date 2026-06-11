/obj/effect/proc_holder/spell/invoked/engineeranalyze
	name = "解析"
	desc = "检视一处结构的详细状况。"
	overlay_state = "analyze"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/diagnose.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 2 SECONDS //very stupidly simple spell
	miracle = FALSE
	devotion_cost = 0 //come on, this is very basic

/obj/effect/proc_holder/spell/invoked/engineeranalyze/cast(list/targets, mob/living/user)
	var/healthpercent
	//see the health of a structure, hopefully to be used for repairs or tracking down connected redstone structures
	if(isstructure(targets[1]))
		var/obj/structure/analyzedstructure = targets[1]
		var/list/examination = list("<span class='info'>ø ------------ ø")
		examination += "☼ 解析对象：[capitalize(analyzedstructure.name)] "
		if (length(analyzedstructure.desc) > 1)
			examination += "☼ 描述：[capitalize(analyzedstructure.desc)] "
		if (analyzedstructure.max_integrity == 0)
			examination += "☼ 完整度：不可摧毁"
		else
			healthpercent = (analyzedstructure.obj_integrity/analyzedstructure.max_integrity) * 100
			examination += "☼ 完整度：[healthpercent]% ([analyzedstructure.obj_integrity]/[analyzedstructure.max_integrity]) "
		if(analyzedstructure.redstone_structure)
			if(analyzedstructure.redstone_attached.len > 0)
				examination += "☼ 已连接结构 "
				for(var/obj/structure/attachedstructures in analyzedstructure.redstone_attached)
					examination += "   - [attachedstructures.name] "
			else
				examination += "☼ 未连接任何结构"
		examination += "ø ------------ ø</span>"
		to_chat(user, examination.Join("\n"))
		return examination

	//see the health of a wall, I hope this can be used for repair options in the future
	if(isturf(targets[1]) && istype(targets[1], /turf/closed/wall/))
		var/turf/closed/wall/analyzeturf = targets[1]
		var/list/examination = list("<span class='info'>ø ------------ ø")
		examination += "☼ 解析对象：[capitalize(analyzeturf.name)] "
		if (length(analyzeturf.desc) > 1)
			examination += "☼ 描述：[capitalize(analyzeturf.desc)] "
		if (analyzeturf.max_integrity == 0)
			examination += "☼ 完整度：不可摧毁"
		else
			healthpercent = (analyzeturf.turf_integrity/analyzeturf.max_integrity) * 100
			examination += "☼ 完整度：[healthpercent]% ([analyzeturf.turf_integrity]/[analyzeturf.max_integrity]) "
		examination += "ø ------------ ø</span>"
		to_chat(user, examination.Join("\n"))
		return examination
	//engineers can check constructs for injuries
	if(ishuman(targets[1]) && istype(targets[1], /mob/living/carbon/human/species/construct))
		var/mob/living/carbon/human/human_target = targets[1]
		human_target.check_for_injuries(user)		
		return TRUE
	revert_cast()
	return FALSE
