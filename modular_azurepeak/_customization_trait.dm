// Shared base for /datum/virtue and /datum/quirk.
/datum/customization_trait
	/// What it's called.
	var/name
	/// A brief, in-character description of what it does.
	var/desc
	/// A list containing any traits we need to add to the mob.
	var/list/added_traits = list()
	/// An associative list containing any skills we want to adjust. You can also pass list objects into this in the following format: list(SKILL_TYPE, SKILL_INCREASE, SKILL_MAXIMUM) as needed.
	var/list/added_skills = list()
	/// An associative list containing any items we want to add to our stash.
	var/list/added_stashed_items = list()
	/// A list containing any extra languages we need to add to the mob.
	var/list/added_languages = list()
	/// An associative list containing any extra stats we need to add to the mob. NOTE: GENERALLY should not add stats unless it imposes serious downsides.
	var/list/added_stats = list()
	/// The cost of application in TRIUMPH points, if any.
	var/triumph_cost = 0
	/// A custom addendum explaining what it does outside of the trait / skill adjustments.
	var/custom_text
	/// Mutually exclusive virtues. Virtue packs are automatically considered.
	var/list/incompatible_virtues = list()
	/// Mutually exclusive vices.
	var/list/incompatible_vices = list()

/datum/customization_trait/New()
	. = ..()
	if(triumph_cost)
		desc += " <b>Costs [triumph_cost] TRIUMPHS.</b>"

/datum/customization_trait/proc/apply_to_human(mob/living/carbon/human/recipient)
	return

// Shared proc for applying crap.
/datum/customization_trait/proc/apply_generic_effects(mob/living/carbon/human/recipient)
	apply_to_human(recipient)
	handle_traits(recipient)
	handle_skills(recipient)
	handle_stashed_items(recipient)
	handle_added_languages(recipient)
	handle_stats(recipient)

/datum/customization_trait/proc/handle_traits(mob/living/carbon/human/recipient)
	if(!LAZYLEN(added_traits))
		return
	for(var/trait in added_traits)
		ADD_TRAIT(recipient, trait, TRAIT_VIRTUE)

/datum/customization_trait/proc/handle_skills(mob/living/carbon/human/recipient)
	if(!recipient.mind || !LAZYLEN(added_skills))
		return
	for(var/skill in added_skills)
		if(!islist(skill))
			recipient.adjust_skillrank(skill, added_skills[skill], TRUE)
		else
			var/list/skill_block = skill
			var/datum/skill/the_skill = skill_block[1]
			var/increase_by = skill_block[2]
			var/maximum_skill = skill_block[3]
			var/our_skill = recipient.get_skill_level(the_skill)
			if(our_skill < maximum_skill)
				if((our_skill + increase_by) > maximum_skill) // we'll be pushing it higher than our max with 1 addition, so lower increase_by
					increase_by = (maximum_skill - our_skill)
				recipient.adjust_skillrank(the_skill.type, increase_by, TRUE)
			else
				to_chat(recipient, span_notice("This cannot influence my skill with [LOWER_TEXT(the_skill.name)] any further."))

/datum/customization_trait/proc/handle_stashed_items(mob/living/carbon/human/recipient)
	if(!recipient.mind || !LAZYLEN(added_stashed_items))
		return
	for(var/stashed_item in added_stashed_items)
		recipient.mind?.special_items[stashed_item] = added_stashed_items[stashed_item]

/datum/customization_trait/proc/handle_added_languages(mob/living/carbon/human/recipient)
	if(!LAZYLEN(added_languages))
		return
	for(var/language in added_languages)
		recipient.grant_language(language)

/datum/customization_trait/proc/handle_stats(mob/living/carbon/human/recipient)
	if(!LAZYLEN(added_stats))
		return
	for(var/stat in added_stats)
		var/value = added_stats[stat]
		recipient.change_stat(stat, value)

/datum/customization_trait/proc/pick_stashed_instrument(mob/living/carbon/human/recipient)
	var/list/instruments = list()
	for(var/instrument_type in subtypesof(/obj/item/rogue/instrument))
		if(instrument_type == /obj/item/rogue/instrument/harp/handcarved)
			continue //Skip the donator personal item harp.
		else if(instrument_type == /obj/item/rogue/instrument/ztratocaster)
			continue // there can only be one.
		var/obj/item/rogue/instrument/instr = new instrument_type()
		instruments[instr.name] = instrument_type
		qdel(instr)  // Clean up the temporary instance

	var/chosen_name = input(recipient, "What instrument did I stash?", "STASH") as null|anything in instruments
	if(chosen_name)
		var/instrument_type = instruments[chosen_name]
		recipient.mind?.special_items[chosen_name] = instrument_type

/datum/customization_trait/proc/check_triumphs(mob/living/carbon/human/recipient)
	if(!triumph_cost)
		return TRUE

	if(!recipient.mind)
		return FALSE

	var/current_triumphs = recipient.get_triumphs()
	if(current_triumphs < triumph_cost)
		return FALSE

	recipient.adjust_triumphs(-triumph_cost, FALSE)
	return TRUE
