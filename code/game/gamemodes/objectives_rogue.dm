/datum/objective/bandit
	name = "bandit"
	explanation_text = "Rob and pillage. Gather valuable loot by any means, and offer it to the gilded god in sacrifice."

/datum/objective/bandit/check_completion()
	if(SSmapping.retainer.bandit_contribute >= SSmapping.retainer.bandit_goal)
		return TRUE

/datum/objective/bandit/update_explanation_text()
	..()
	explanation_text = "Feed [SSmapping.retainer.bandit_goal] mammon to an idol of greed."


/datum/objective/delf
	name = "delf"
	explanation_text = "Feed honeys to the mother."

/datum/objective/delf/check_completion()
	if(SSmapping.retainer.delf_contribute >= SSmapping.retainer.delf_goal)
		return TRUE

/datum/objective/delf/update_explanation_text()
	..()
	explanation_text = "Feed [SSmapping.retainer.delf_goal] honeys to the mother."

/datum/objective/werewolf
	name = "conquer"
	explanation_text = "You are touched by the Mad God of the Wilds, Dendor - be it through a bite... Or a terrible blessing. And you are SO, SO VERY HUNGRY. The form Dendor promises will be fearsome, but the transition will be agonizing. Fear not the full moon - and let the feast begin."
	team_explanation_text = "Lycanthropy is a terrible disease that's been recorded in scattered accounts going back hundreds of years. Whatever madness drove Dendor to create such an aberration is beyond mortal minds - and whatever the reason, he has been unwilling or unable to undo it. Nightly transformations and prodigious increses in mass drive the body into an active state of insatiable starvation, driving animalistic, rabid behavior."
	triumph_count = 5

/datum/objective/werewolf/lesser
	name = "adapt"
	explanation_text = "You were recently bitten by a beast of dendor. And you are SO, SO VERY HUNGRY. You must adapt to your new lyfe- How you react to being left cursed with the call of the wilds during Astrata is up to you. Beware, at Noc beneath the moonlight, nothing will hold the feral hunger back. You must Obey your elder kin and serve their aims if moonlight befouls you ."
	team_explanation_text = "Lycanthropy is a terrible disease that's been recorded in scattered accounts going back hundreds of years. Whatever madness drove Dendor to create such an aberration is beyond mortal minds - and whatever the reason, he has been unwilling or unable to undo it. Nightly transformations and prodigious increses in mass drive the body into an active state of insatiable starvation, driving animalistic, rabid behavior."
	triumph_count = 5

/datum/objective/werewolf/check_completion()
	if(vampire_werewolf() == "werewolf")
		return TRUE

/datum/objective/vampire
	name = "conquer"
	explanation_text = "Put an end to the werewolf menace, or unite with them against the forces of the Nine."
	team_explanation_text = "The feud between werewolves and vampires reaches back to the dawn of time. Will the two factions destroy each other, or find a way to coexist and face the mortals of this land together?"
	triumph_count = 5

/datum/objective/vampire/check_completion()
	if(vampire_werewolf() == "vampire")
		return TRUE

/datum/objective/dreamwalker_ascend
	name = "awaken abyssor"
	explanation_text = "Complete the five rites and wake Abyssor from his dream, no matter the cost."

/datum/objective/dreamwalker_ascend/check_completion()
	if(!owner)
		return FALSE
	var/datum/antagonist/dreamwalker/D = owner.has_antag_datum(/datum/antagonist/dreamwalker)
	return D ? D.ascended : FALSE
