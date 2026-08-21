GLOBAL_LIST_EMPTY(virtues)

/datum/virtue
	/// What the virtue's called.
	var/name
	/// A brief, in-character description of what the virtue does.
	var/desc
	/// A list containing any traits we need to add to the mob.
	var/list/added_traits = list()
	/// An associative list containing any skills we want to adjust. You can also pass list objects into this in the following format: list(SKILL_TYPE, SKILL_INCREASE, SKILL_MAXIMUM) as needed.
	var/list/added_skills = list()
	/// An associative list containing any items we want to add to our stash.
	var/list/added_stashed_items = list()
	/// A list containing any extra languages we need to add to the mob.
	var/list/added_languages = list()
	/// An associative list containing any extra stats we need to add to the mob. NOTE: virtues should GENERALLY NOT add stats unless they impose serious downsides.
	var/list/added_stats = list()
	/// The cost of the virtue to apply in TRIUMPH points, if any.
	var/triumph_cost = 0
	/// A custom addendum that explains what the virtue does outside of the traits / skill adjustments.
	var/custom_text
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
	if (triumph_cost)
		desc += "<b>Costs [triumph_cost] TRIUMPH.</b>"

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

/datum/virtue/proc/apply_to_human(mob/living/carbon/human/recipient)
	return

/datum/virtue/proc/handle_traits(mob/living/carbon/human/recipient)
	if (!LAZYLEN(added_traits))
		return
	for(var/trait in added_traits)
		ADD_TRAIT(recipient, trait, TRAIT_VIRTUE)

/datum/virtue/proc/handle_skills(mob/living/carbon/human/recipient)
	if (!recipient.mind || !LAZYLEN(added_skills))
		return
	for(var/skill in added_skills)
		if (!islist(skill))
			recipient.adjust_skillrank(skill, added_skills[skill], TRUE)
		else
			var/list/skill_block = skill
			var/datum/skill/the_skill = skill_block[1]
			var/increase_by = skill_block[2]
			var/maximum_skill = skill_block[3]
			var/our_skill = recipient.get_skill_level(the_skill)
			if (our_skill < maximum_skill)
				if ((our_skill + increase_by) > maximum_skill) // we'll be pushing it higher than our max with 1 addition, so lower increase_by
					increase_by = (maximum_skill - our_skill)
				recipient.adjust_skillrank(the_skill.type, increase_by, TRUE)
			else
				to_chat(recipient, span_notice("My Virtue cannot influence my skill with [LOWER_TEXT(the_skill.name)] any further."))


/datum/virtue/proc/handle_stashed_items(mob/living/carbon/human/recipient)
	if (!recipient.mind || !LAZYLEN(added_stashed_items))
		return
	for(var/stashed_item in added_stashed_items)
		recipient.mind?.special_items[stashed_item] = added_stashed_items[stashed_item]

/datum/virtue/proc/handle_added_languages(mob/living/carbon/human/recipient)
	if (!LAZYLEN(added_languages))
		return

	for (var/language in added_languages)
		recipient.grant_language(language)

/datum/virtue/proc/handle_stats(mob/living/carbon/human/recipient)
	if (!LAZYLEN(added_stats))
		return

	for (var/stat in added_stats)
		var/value = added_stats[stat]
		recipient.change_stat(stat, value)

/datum/virtue/proc/check_triumphs(mob/living/carbon/human/recipient)
	var/total_cost = triumph_cost
	for(var/i in 1 to min(length(picked_choices), length(choice_costs)))
		total_cost += choice_costs[i]

	if (!total_cost)
		return TRUE

	if (!recipient.mind)
		return FALSE

	// Check if they have enough triumphs
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
	virtue_type.apply_to_human(recipient)
	virtue_type.handle_traits(recipient)
	virtue_type.handle_skills(recipient)
	virtue_type.handle_stashed_items(recipient)
	virtue_type.handle_added_languages(recipient)
	virtue_type.handle_stats(recipient)
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
