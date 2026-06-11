/datum/antagonist/suitor
	name = "求婚者"
	increase_votepwr = FALSE

/datum/antagonist/suitor/get_antag_cap_weight()
	return 0

/datum/antagonist/suitor/on_gain()
	if(!(locate(/datum/objective/marry) in objectives))
		var/datum/objective/marry/marry_objective = new
		marry_objective.owner = owner
		objectives += marry_objective
		if(!owner.active)
			addtimer(CALLBACK(src, PROC_REF(greet)), 5 SECONDS)
		else
			greet()
		return
//	ADD_TRAIT(owner.current, TRAIT_ANTAG, TRAIT_GENERIC)
	return ..()

/datum/antagonist/suitor/on_removal()
	return ..()

/datum/antagonist/suitor/greet()
	to_chat(owner.current, span_userdanger("我带着使命来到这里。我必须不惜一切代价与本地公爵缔结婚姻，以巩固我家族与这个国度的关系。"))
	owner.announce_objectives()
	..()

/datum/antagonist/suitor/roundend_report()
	var/traitorwin = TRUE
	var/count = 0
	var/mob/living/carbon/human/marriagepartner = owner.current
	marriagepartner = marriagepartner.marriedto

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
		to_chat(owner.current, span_greentext("我成功与王座联姻，为我的家族争取到了一份同盟！"))
		to_chat(world, span_greentext("[owner.current.real_name] 成功与 [marriagepartner] 缔结婚姻，并为其家族争取到了与这个国度的同盟！"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(owner.current, span_redtext("我没能与这个国度的王座缔结婚姻！我的家族一定会失望！"))
		to_chat(world, span_redtext("[owner.current.real_name] 没能与王座缔结婚姻！"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)
