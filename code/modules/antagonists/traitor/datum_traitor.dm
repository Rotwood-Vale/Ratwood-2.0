#define TRAITOR_HUMAN "human"
#define TRAITOR_AI	  "AI"

/datum/antagonist/traitor
	name = "叛徒"
	roundend_category = "叛徒"
	antagpanel_category = "叛徒"
	job_rank = ROLE_TRAITOR
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "traitor"
	var/special_role = ROLE_TRAITOR
	var/employer = "The Syndicate"
	var/give_objectives = TRUE
	var/should_give_codewords = TRUE
	var/should_equip = TRUE
	var/traitor_kind = TRAITOR_HUMAN //Set on initial assignment
	can_hijack = HIJACK_HIJACKER

/datum/antagonist/traitor/on_gain()

	owner.special_role = special_role
	if(give_objectives)
		forge_traitor_objectives()
	finalize_traitor()
	RegisterSignal(owner.current, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hearing))
	return ..()

/datum/antagonist/traitor/on_removal()
	//Remove malf powers.
	UnregisterSignal(owner.current, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hearing))
	if(!silent && owner.current)
		to_chat(owner.current,"<span class='danger'>我不再是[special_role]了！</span>")
	owner.special_role = null
	return ..()

/datum/antagonist/traitor/proc/handle_hearing(datum/source, list/hearing_args)
	var/message = hearing_args[HEARING_MESSAGE]
	message = GLOB.syndicate_code_phrase_regex.Replace(message, "<span class='blue'>$1</span>")
	message = GLOB.syndicate_code_response_regex.Replace(message, "<span class='red'>$1</span>")
	hearing_args[HEARING_MESSAGE] = message

/datum/antagonist/traitor/proc/add_objective(datum/objective/O)
	objectives += O

/datum/antagonist/traitor/proc/remove_objective(datum/objective/O)
	objectives -= O

/datum/antagonist/traitor/proc/forge_traitor_objectives()
	switch(traitor_kind)
		if(TRAITOR_AI)
			forge_ai_objectives()
		else
			forge_human_objectives()

/datum/antagonist/traitor/proc/forge_human_objectives()
	var/is_hijacker = FALSE
	if (GLOB.joined_player_list.len >= 30) // Less murderboning on lowpop thanks
		is_hijacker = prob(10)
	var/martyr_chance = prob(20)
	var/objective_count = is_hijacker 			//Hijacking counts towards number of objectives
	var/toa = CONFIG_GET(number/traitor_objectives_amount)
	for(var/i = objective_count, i < toa, i++)
		forge_single_objective()

	var/martyr_compatibility = 1 //You can't succeed in stealing if you're dead.
	for(var/datum/objective/O in objectives)
		if(!O.martyr_compatible)
			martyr_compatibility = 0
			break

	if(martyr_compatibility && martyr_chance)
		var/datum/objective/martyr/martyr_objective = new
		martyr_objective.owner = owner
		add_objective(martyr_objective)
		return

	else
		if(!(locate(/datum/objective/escape) in objectives))
			var/datum/objective/escape/escape_objective = new
			escape_objective.owner = owner
			add_objective(escape_objective)
			return

/datum/antagonist/traitor/proc/forge_ai_objectives()
	var/objective_count = 0

	if(prob(30))
		objective_count += forge_single_objective()

	for(var/i = objective_count, i < CONFIG_GET(number/traitor_objectives_amount), i++)
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = owner
		kill_objective.find_target()
		add_objective(kill_objective)

	var/datum/objective/survive/exist/exist_objective = new
	exist_objective.owner = owner
	add_objective(exist_objective)


/datum/antagonist/traitor/proc/forge_single_objective()
	switch(traitor_kind)
		if(TRAITOR_AI)
			return forge_single_AI_objective()
		else
			return forge_single_human_objective()

/datum/antagonist/traitor/proc/forge_single_human_objective() //Returns how many objectives are added
	.=1
	if(prob(50))
		if(prob(30))
			var/datum/objective/maroon/maroon_objective = new
			maroon_objective.owner = owner
			maroon_objective.find_target()
			add_objective(maroon_objective)
		else
			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = owner
			kill_objective.find_target()
			add_objective(kill_objective)
	else
		var/datum/objective/steal/steal_objective = new
		steal_objective.owner = owner
		steal_objective.find_target()
		add_objective(steal_objective)

/datum/antagonist/traitor/proc/forge_single_AI_objective()
	.=1
	var/special_pick = rand(1,4)
	switch(special_pick)
		if(4) //Protect and strand a target
			var/datum/objective/protect/yandere_one = new
			yandere_one.owner = owner
			add_objective(yandere_one)
			yandere_one.find_target()
			var/datum/objective/maroon/yandere_two = new
			yandere_two.owner = owner
			yandere_two.target = yandere_one.target
			yandere_two.update_explanation_text() // normally called in find_target()
			add_objective(yandere_two)
			.=2

/datum/antagonist/traitor/greet()
	to_chat(owner.current, "<span class='alertsyndie'>我是[owner.special_role]。</span>")
	owner.announce_objectives()
	if(should_give_codewords)
		give_codewords()

/datum/antagonist/traitor/proc/finalize_traitor()
	if(should_equip)
		equip(silent)
	owner.current.playsound_local(get_turf(owner.current), 'sound/blank.ogg', 100, FALSE, pressure_affected = FALSE)

/datum/antagonist/traitor/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/M = mob_override || owner.current
	add_antag_hud(antag_hud_type, antag_hud_name, M)

/datum/antagonist/traitor/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/M = mob_override || owner.current
	remove_antag_hud(antag_hud_type, M)

/datum/antagonist/traitor/proc/give_codewords()
	if(!owner.current)
		return
	var/mob/traitor_mob=owner.current

	var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
	var/responses = jointext(GLOB.syndicate_code_response, ", ")

	to_chat(traitor_mob, "<U><B>辛迪加向你提供了以下暗号，用以识别其他特工：</B></U>")
	to_chat(traitor_mob, "<B>暗号词</B>: <span class='blue'>[phrases]</span>")
	to_chat(traitor_mob, "<B>暗号应答</B>: <span class='red'>[responses]</span>")

	antag_memory += "<b>暗号词</b>: <span class='blue'>[phrases]</span><br>"
	antag_memory += "<b>暗号应答</b>: <span class='red'>[responses]</span><br>"

	to_chat(traitor_mob, "在日常交谈中使用这些暗号，以识别其他特工。不过仍要谨慎行事，因为任何人都可能是你的敌人。")
	to_chat(traitor_mob, "<span class='alertwarning'>我已经记住了这些暗号，因此当我听见时就能辨认出来。</span>")

/datum/antagonist/traitor/proc/equip(silent = FALSE)
	if(traitor_kind == TRAITOR_HUMAN)
		owner.equip_traitor(employer, silent, src)

//TODO Collate
/datum/antagonist/traitor/roundend_report()
	var/list/result = list()

	var/traitorwin = TRUE

	result += printplayer(owner)

	var/TC_uses = 0
	var/uplink_true = FALSE

	var/objectives_text = ""
	if(objectives.len)//If the traitor had no objectives, don't need to process this.
		var/count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				objectives_text += "<br><B>目标 #[count]</B>: [objective.explanation_text] <span class='greentext'>成功！</span>"
			else
				objectives_text += "<br><B>目标 #[count]</B>: [objective.explanation_text] <span class='redtext'>失败。</span>"
				traitorwin = FALSE
			count++

	if(uplink_true)
		var/uplink_text = ""
		if(TC_uses==0 && traitorwin)
			var/static/icon/badass = icon('icons/badass.dmi', "badass")
			uplink_text += "<BIG>[icon2html(badass, world)]</BIG>"
		result += uplink_text

	result += objectives_text

	var/special_role_text = LOWER_TEXT(name)

	if(traitorwin)
		result += "<span class='greentext'>[special_role_text]成功了！</span>"
	else
		result += "<span class='redtext'>[special_role_text]失败了！</span>"
		SEND_SOUND(owner.current, 'sound/blank.ogg')

	return result.Join("<br>")

/datum/antagonist/traitor/roundend_report_footer()
	var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
	var/responses = jointext(GLOB.syndicate_code_response, ", ")

	var message = "<br><b>本局暗号词为：</b> <span class='bluetext'>[phrases]</span><br>\
					<b>本局暗号应答为：</b> <span class='redtext'>[responses]</span><br>"

	return message
