/proc/brainwash(mob/living/L, directives)
	if(!L.mind)
		return
	if(!islist(directives))
		directives = list(directives)
	var/datum/mind/M = L.mind
	var/datum/antagonist/brainwashed/B = M.has_antag_datum(/datum/antagonist/brainwashed)
	if(B)
		for(var/O in directives)
			var/datum/objective/brainwashing/objective = new(O)
			B.objectives += objective
		B.greet()
	else
		B = new()
		for(var/O in directives)
			var/datum/objective/brainwashing/objective = new(O)
			B.objectives += objective
		M.add_antag_datum(B)

	var/begin_message = " 已被洗脑，目标如下："
	var/obj_message = english_list(directives)
	var/end_message = "."
	var/rendered = begin_message + obj_message + end_message
	deadchat_broadcast(rendered, "<b>[L]</b>", follow_target = L, turf_target = get_turf(L), message_type=DEADCHAT_REGULAR)

/datum/antagonist/brainwashed
	name = "被洗脑的受害者"
	job_rank = ROLE_BRAINWASHED
	roundend_category = "被洗脑的受害者"
	show_in_antagpanel = TRUE
	antagpanel_category = "其他"
	show_name_in_check_antagonists = TRUE

/datum/antagonist/brainwashed/greet()
	to_chat(owner, span_warning("我的思绪翻腾着，开始只聚焦于一个目的……"))
	to_chat(owner, "<big><span class='warning'><b>不惜一切代价遵从这些指令！</b></span></big>")
	var/i = 1
	for(var/X in objectives)
		var/datum/objective/O = X
		to_chat(owner, "<b>[i].</b> [O.explanation_text]")
		i++

/datum/antagonist/brainwashed/farewell()
	to_chat(owner, span_warning("我的头脑忽然清明了……"))
	to_chat(owner, "<big><span class='warning'><b>我感到那些指令的重压消失了！你不再需要服从它们。</b></span></big>")
	owner.announce_objectives()

/datum/antagonist/brainwashed/admin_add(datum/mind/new_owner,mob/admin)
	var/mob/living/carbon/C = new_owner.current
	if(!istype(C))
		return
	var/list/objectives = list()
	do
		var/objective = stripped_input(admin, "添加一项目标，或留空以结束。", "洗脑", null, MAX_MESSAGE_LEN)
		if(objective)
			objectives += objective
	while(alert(admin,"再添加一项目标吗？","继续洗脑","是","否") == "是")

	if(alert(admin,"确认执行洗脑吗？","你确定吗？","是","否") == "否")
		return

	if(!LAZYLEN(objectives))
		return

	if(QDELETED(C))
		to_chat(admin, "目标已不存在")
		return

	brainwash(C, objectives)
	var/obj_list = english_list(objectives)
	message_admins("[key_name_admin(admin)] has brainwashed [key_name_admin(C)] with the following objectives: [obj_list].")
	log_admin("[key_name(admin)] has brainwashed [key_name(C)] with the following objectives: [obj_list].")

/datum/objective/brainwashing
	completed = TRUE
