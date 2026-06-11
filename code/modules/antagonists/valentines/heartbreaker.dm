/datum/antagonist/heartbreaker
	name = "伤心人"
	roundend_category = "情人节"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE


/datum/antagonist/heartbreaker/proc/forge_objectives()
	var/datum/objective/martyr/normiesgetout = new
	normiesgetout.owner = owner
	objectives += normiesgetout

/datum/antagonist/heartbreaker/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/heartbreaker/greet()
	to_chat(owner, span_warning("<B>我没约到人！他们全都撇下你自己去快活了！不过你会让他们见识见识的……</B>"))
	owner.announce_objectives()
