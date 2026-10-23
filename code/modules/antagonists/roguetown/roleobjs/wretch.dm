/datum/antagonist/wretch
	name = "Wretch"
	briefing_title = "The Wretch"
	briefing_text = "You've been outcasted from society for one reasons known only to you, and the excividium. Avoid capture, and find a way to survive in this new world. They call you a Wretch, but what you truly are is a survivor. Use your gifts wisely and thrive; the world is not kind to those who do not follow its rules."
	briefing_tips = list(
		"The Excividium likely keeps your name on it's stoney writ. Beware bounty hunters.",
		"There are many ways to get what you desire, Bribery, Theft, and even Murder. Be cautious as to what attracts attention.",
		"Your individual camp is the only truly safe space. Trust rarely, for outcasts hold no code of honor.",
		"A good face covering can stave off the average confrontation with a bit of effort."
	)
	roundend_category = "wretches"
	antagpanel_category = "Wretches"
	show_name_in_check_antagonists = FALSE

/datum/antagonist/wretch/get_antag_cap_weight()
	return 0.5

/datum/antagonist/wretch/on_gain()
	. = ..()
	if(owner)
		owner.special_role = "Wretch"

/datum/antagonist/wretch/on_removal()
	. = ..()
	if(owner)
		owner.special_role = null
