
/datum/antagonist/prisoner
	name = "囚犯"
	increase_votepwr = FALSE
	antag_flags = FLAG_FAKE_ANTAG

/datum/antagonist/prisoner/on_gain()
	if(!(locate(/datum/objective/escape) in objectives))
		var/datum/objective/escape/prisoner/escape_objective = new
		escape_objective.owner = owner
		objectives += escape_objective
		return
//	ADD_TRAIT(owner.current, TRAIT_ANTAG, TRAIT_GENERIC)
	return ..()

/datum/antagonist/prisoner/on_removal()
	return ..()


/datum/antagonist/prisoner/greet()
	owner.announce_objectives()
	..()

/datum/antagonist/prisoner/roundend_report()
	var/traitorwin = TRUE

	var/count = 0
	if(objectives.len)//If the traitor had no objectives, don't need to process this.
		for(var/datum/objective/objective in objectives)
			objective.update_explanation_text()
			if(!objective.check_completion())
				traitorwin = FALSE
			count++

	if(!count)
		count = 1

	if(traitorwin)
		owner.adjust_triumphs(3)
		to_chat(owner.current, span_greentext("我逃离了那可怕的牢房！这个世界是我的了！"))
		if(owner.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		if(considered_alive(owner))
			owner.adjust_triumphs(1)
			to_chat(owner.current, span_redtext("这周我没能逃出去，但我还活着，还能再试一次！"))
		else
			to_chat(owner.current, span_redtext("我逃出去了……以死亡的方式！"))
		if(owner.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)
