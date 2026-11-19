/// One tier of the band-wide hoard. Completed once the whole band has offered target_amount to the idol.
/datum/objective/bandit_hoard
	name = "bandit hoard"
	martyr_compatible = TRUE
	/// 1 small, 2 decent, 3 massive; see bandit_hoard_tier()
	var/tier = 1

/datum/objective/bandit_hoard/New(text, datum/mind/owner)
	target_amount = bandit_hoard_tier_amount(tier)
	triumph_count = bandit_hoard_triumphs(tier)
	. = ..()
	update_explanation_text()

/datum/objective/bandit_hoard/check_completion()
	return SSmapping.retainer.bandit_contribute >= target_amount

/datum/objective/bandit_hoard/update_explanation_text()
	explanation_text = "[bandit_hoard_tier_name(tier)]: offer [target_amount] mammons' worth of loot to Matthios's idol."

/datum/objective/bandit_hoard/small
	tier = 1

/datum/objective/bandit_hoard/decent
	tier = 2

/datum/objective/bandit_hoard/massive
	tier = 3


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
