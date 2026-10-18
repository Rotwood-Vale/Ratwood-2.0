GLOBAL_LIST_INIT(virtues, init_subtypes_assoc(/datum/virtue))

/datum/virtue
	parent_type = /datum/customization_trait
	/// If TRUE, the species listed in `races` are barred from taking this virtue.
	var/restricted = FALSE
	/// Species typepaths this virtue is unavailable to. Only used when `restricted` is TRUE.
	var/list/races = list()
	/// How many sub-choices the player may pick from `extra_choices`. 0 means this virtue has no sub-choices.
	var/max_choices = 0
	/// The sub-choices offered to the player, as plain strings.
	var/list/extra_choices = list()
	/// The sub-choices the player has actually picked. Per-character, saved to prefs.
	var/list/picked_choices = list()
	/// TRIUMPH cost of the Nth pick, indexed by pick order rather than by which choice was taken. Omit entirely for free choices.
	var/list/choice_costs = list()
	/// Associative list of choice string -> explanatory text shown by the (?) link. Keys must exist in `extra_choices`.
	var/list/choice_tooltips = list()

/datum/virtue/New()
	. = ..()
	if(max_choices || length(extra_choices) || length(choice_costs) || length(choice_tooltips))
		if(max_choices < 1)
			CRASH("[type] defines sub-choice data but has no max_choices!")
		if(max_choices > length(extra_choices))
			CRASH("[type] has fewer extra_choices than max_choices!")
		if(length(choice_costs) && length(choice_costs) < max_choices)
			CRASH("[type] declares choice_costs but has fewer entries than max_choices!")
		for(var/choice in choice_tooltips)
			if(!(choice in extra_choices))
				CRASH("[type] has a choice_tooltip for '[choice]', which is not in extra_choices!")

/// Whether a character of the given species is allowed to take this virtue.
/datum/virtue/proc/can_be_picked_by(datum/species/picker_species)
	if(!restricted || !picker_species)
		return TRUE
	return !(picker_species.type in races)

/// Drops any picked choices that are no longer valid and trims down to max_choices.
/datum/virtue/proc/sanitize_choices()
	if(!length(picked_choices))
		return
	if(!max_choices || !length(extra_choices))
		picked_choices = list()
		return
	var/list/cleaned = list()
	for(var/choice in picked_choices)
		if(!(choice in extra_choices) || (choice in cleaned))
			continue
		cleaned += choice
		if(length(cleaned) >= max_choices)
			break
	picked_choices = cleaned

/// The TRIUMPH cost of taking one more sub-choice.
/datum/virtue/proc/next_choice_cost()
	var/index = length(picked_choices) + 1
	if(index > length(choice_costs))
		return 0
	return choice_costs[index]

/datum/virtue/check_triumphs(mob/living/carbon/human/recipient)
	var/total_cost = triumph_cost
	for(var/i in 1 to min(length(picked_choices), length(choice_costs)))
		total_cost += choice_costs[i]

	if(!total_cost)
		return TRUE

	if(!recipient.mind)
		return FALSE

	var/current_triumphs = recipient.get_triumphs()
	if(current_triumphs < total_cost)
		to_chat(recipient, span_warning("I lack the TRIUMPH for [name] ([total_cost] needed), so it has not been applied."))
		return FALSE

	recipient.adjust_triumphs(-total_cost, FALSE)
	return TRUE

/proc/apply_virtue(mob/living/carbon/human/recipient, datum/virtue/virtue_type)
	virtue_type.sanitize_choices()
	if (!virtue_type.check_triumphs(recipient))
		return
	virtue_type.apply_generic_effects(recipient)
	if(HAS_TRAIT(recipient, TRAIT_RESIDENT))
		if(recipient in SStreasury.bank_accounts)
			SStreasury.generate_money_account(20, recipient)
		else
			SStreasury.create_bank_account(recipient, 20)
	if(HAS_TRAIT(recipient, TRAIT_RESIDENT))
		REMOVE_TRAIT(recipient, TRAIT_OUTLANDER, ADVENTURER_TRAIT)
		REMOVE_TRAIT(recipient, TRAIT_OUTLANDER, JOB_TRAIT)
		REMOVE_TRAIT(recipient, TRAIT_OUTLANDER, TRAIT_GENERIC)
	record_featured_object_stat(FEATURED_STATS_VIRTUES, virtue_type.name)

/datum/virtue/none
	name = "None"
	desc = "Without virtue."
