/// Banu Haqim from Temu.
/datum/clan/crimson_fang
	name = "Crimson Fang"
	desc = "Crimson Fangs, often seen by other kindred as dangerous assassins and diablerists, but in truth they are guardians, warriors, and scholars who seek to distance themselves from politics of both vampyre and mundane worlds."
	curse = "Blood Addiction."
	clanicon = "presence"
	clane_covens = list(
		/datum/coven/celerity,
		/datum/coven/obfuscate,
		/datum/coven/quietus
	)
	covens_to_select = 0

/datum/clan/crimson_fang/get_frenzy_messages()
	return list(
		"The [span_danger("addiction")] screams in my veins and my discipline frays.",
		"Every oath I swore drowns beneath the roar for [span_danger("blood")].",
		"My hands remember the [span_danger("kill")] even as I beg them to still.",
		"The warrior's calm shatters, and the [span_userdanger("addict")] beneath wants to gorge.",
		"A red [span_danger("thirst")] floods me, stronger than any vow.",
	)
