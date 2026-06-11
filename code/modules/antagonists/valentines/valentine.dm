/datum/antagonist/valentine
	name = "情人"
	roundend_category = "情人节" //there's going to be a ton of them so put them in separate category
	show_in_antagpanel = FALSE
	prevent_roundtype_conversion = FALSE
	var/datum/mind/date

/datum/antagonist/valentine/proc/forge_objectives()
	var/datum/objective/protect/protect_objective = new /datum/objective/protect
	protect_objective.owner = owner
	protect_objective.target = date
	if(!ishuman(date.current))
		protect_objective.human_check = FALSE
	protect_objective.explanation_text = "保护 [date.name]，也就是你的约会对象。"
	objectives += protect_objective

/datum/antagonist/valentine/on_gain()
	forge_objectives()
	if(isliving(owner))
		var/mob/living/L = owner
		L.apply_status_effect(STATUS_EFFECT_INLOVE, date)
	. = ..()

/datum/antagonist/valentine/on_removal()
	. = ..()
	if(isliving(owner))
		var/mob/living/L = owner
		L.remove_status_effect(STATUS_EFFECT_INLOVE)

/datum/antagonist/valentine/greet()
	to_chat(owner, span_warning("<B>你正在和 [date.name] 约会！不惜一切代价保护 [date.p_them()]。这比其他一切忠诚都更优先。</B>"))

//Squashed up a bit
/datum/antagonist/valentine/roundend_report()
	var/objectives_complete = TRUE
	if(objectives.len)
		for(var/datum/objective/objective in objectives)
			if(!objective.check_completion())
				objectives_complete = FALSE
				break

	if(objectives_complete)
		return span_greentextbig("[owner.name] 保护了 [owner.p_their()] 的约会对象")
	else
		return span_redtextbig("[owner.name] 的约会失败了！")
