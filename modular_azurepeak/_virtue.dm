GLOBAL_LIST_EMPTY(virtues)

/datum/virtue
	/// What the virtue's called.
	var/name
	/// A brief, in-character description of what the virtue does.
	var/desc
	/// The category this virtue belongs to: "origin", "origin_items", or "feats"
	var/category = "feats"
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
	/// The cost of the virtue to apply in virtue points, if any.
	var/virtue_point_cost = 0
	/// The cost of the virtue in virtue points. 5 = major combat, 4 = impactful, 2 = minor, 1 = origin items
	var/virtue_cost = 0
	/// A custom addendum that explains what the virtue does outside of the traits / skill adjustments.
	var/custom_text
	/// List of feat type paths that this origin blocks from being selected. Supports both specific types and general parent paths.
	/// Example: list(/datum/virtue/utility/blacksmith) blocks only that feat, list(/datum/virtue/combat) blocks all combat feats
	var/list/blocked_feats = list()
	/// List of origin item type paths that this origin blocks from being selected. Supports both specific types and general parent paths.
	var/list/blocked_items = list()
	
	// VIRTUE CHOICE/BONUS SYSTEM
	/// Associative list of bonus choices available for this virtue. Format: "Display Name" = list("traits" = list(...), "skills" = list(...), "items" = list(...), "languages" = list(...), "stats" = list(...), "cost" = #, "desc" = "text")
	var/list/virtue_choices = list()
	/// Number of choices that are free before virtue point costs kick in
	var/free_choices = 0
	/// Maximum number of choices that can be selected (0 = no limit beyond costs)
	var/max_choices = 0
	/// Base virtue point cost for choices beyond free ones. Progressive cost formula: base_cost * (choices_made - free_choices)
	var/choice_virtue_point_cost = 1

/datum/virtue/New()
	. = ..()
	if (virtue_point_cost)
		desc += "<b>Costs [virtue_point_cost] Virtue Points.</b>"
	if (virtue_cost)
		desc += " <b>([virtue_cost] point\s)</b>"

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
				to_chat(recipient, span_notice("My Virtue cannot influence my skill with [lowertext(the_skill.name)] any further."))


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

/datum/virtue/proc/check_virtue_points(mob/living/carbon/human/recipient)
	if (!virtue_point_cost)
		return TRUE

	if (!recipient.mind)
		return FALSE

	// Check if they have enough virtue points (uses triumph system internally)
	var/current_points = recipient.get_triumphs()
	if(current_points < virtue_point_cost)
		return FALSE
	
	recipient.adjust_triumphs(-virtue_point_cost, FALSE)
	return TRUE

/// Handle virtue bonus choices - applies pre-selected choices from preferences
/datum/virtue/proc/handle_virtue_choices(mob/living/carbon/human/recipient, list/selected_choice_names)
	if(!LAZYLEN(virtue_choices) || !recipient.mind)
		return TRUE
	
	if(!LAZYLEN(selected_choice_names))
		return TRUE // No choices selected, skip
	
	to_chat(recipient, span_notice("Applying [length(selected_choice_names)] choice(s) for [name]..."))
	
	var/points_spent = 0
	var/choices_made = 0
	
	// Apply all selected choices
	for(var/choice_name in selected_choice_names)
		if(!(choice_name in virtue_choices))
			continue // Invalid choice name
		
		var/list/choice_data = virtue_choices[choice_name]
		var/individual_cost = choice_data["cost"] || 0
		
		// Calculate virtue point cost for this choice
		var/cost_for_choice = individual_cost
		if(choices_made >= free_choices && choice_virtue_point_cost > 0)
			cost_for_choice += choice_virtue_point_cost * (choices_made - free_choices + 1)
		
		points_spent += cost_for_choice
		choices_made++
		
		to_chat(recipient, span_notice("• [choice_name] ([cost_for_choice] VP)"))
		
		// Apply traits
		if(LAZYLEN(choice_data["traits"]))
			for(var/trait in choice_data["traits"])
				ADD_TRAIT(recipient, trait, TRAIT_VIRTUE)
		
		// Apply skills
		if(LAZYLEN(choice_data["skills"]))
			for(var/skill in choice_data["skills"])
				if(!islist(skill))
					recipient.adjust_skillrank(skill, choice_data["skills"][skill], TRUE)
				else
					var/list/skill_block = skill
					var/datum/skill/the_skill = skill_block[1]
					var/increase_by = skill_block[2]
					var/maximum_skill = skill_block[3]
					var/our_skill = recipient.get_skill_level(the_skill)
					if(our_skill < maximum_skill)
						if((our_skill + increase_by) > maximum_skill)
							increase_by = (maximum_skill - our_skill)
						recipient.adjust_skillrank(the_skill.type, increase_by, TRUE)
		
		// Apply stashed items
		if(LAZYLEN(choice_data["items"]))
			for(var/item_name in choice_data["items"])
				recipient.mind?.special_items[item_name] = choice_data["items"][item_name]
		
		// Apply languages
		if(LAZYLEN(choice_data["languages"]))
			for(var/language in choice_data["languages"])
				recipient.grant_language(language)
		
		// Apply stats
		if(LAZYLEN(choice_data["stats"]))
			for(var/stat in choice_data["stats"])
				recipient.change_stat(stat, choice_data["stats"][stat])
	
	// Deduct total virtue point cost
	if(points_spent > 0)
		recipient.adjust_triumphs(-points_spent, FALSE)
		to_chat(recipient, span_notice("Spent [points_spent] Virtue Points for [name] choices."))
	
	to_chat(recipient, span_notice("Successfully applied all choices for [name]."))
	return TRUE

/proc/apply_virtue(mob/living/carbon/human/recipient, datum/virtue/virtue_type, list/selected_choices = null)
	if (!virtue_type.check_virtue_points(recipient))
		return
	virtue_type.apply_to_human(recipient)
	virtue_type.handle_traits(recipient)
	virtue_type.handle_skills(recipient)
	virtue_type.handle_stashed_items(recipient)
	virtue_type.handle_added_languages(recipient)
	virtue_type.handle_stats(recipient)
	virtue_type.handle_virtue_choices(recipient, selected_choices) // Handle bonus choices
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
