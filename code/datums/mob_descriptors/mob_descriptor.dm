/datum/mob_descriptor
	abstract_type = /datum/mob_descriptor
	var/name = "Descriptor"
	var/show_obscured = FALSE
	var/describe
	var/prefix
	var/suffix
	var/verbage
	var/slot = MOB_DESCRIPTOR_SLOT_NOTHING
	var/pre_string
	var/post_string
	var/descriptor_color
	/// colors genital descriptor depending on arousal state
	var/aroused_descriptor_color
	var/aroused_descriptor_threshold = 30
	var/custom_index

/datum/mob_descriptor/New()
	. = ..()
	if(!describe)
		describe = LOWER_TEXT(name)
	if(prefix)
		pre_string = "[prefix] "
	if(suffix)
		post_string = " [suffix]"
	
/datum/mob_descriptor/proc/get_pre_string(mob/living/described)
	return pre_string

/datum/mob_descriptor/proc/get_verbage(mob/living/described)
	return verbage

/datum/mob_descriptor/proc/can_describe(mob/living/described)
	return TRUE

/datum/mob_descriptor/proc/can_user_see(mob/living/described, mob/user)
	return TRUE

/datum/mob_descriptor/proc/should_add_verbage(mob/living/described, list/used_verbage)
	var/verbage_to_use = get_verbage(described)
	if(!verbage_to_use)
		return FALSE
	if(!used_verbage)
		return TRUE
	if(verbage_to_use in used_verbage)
		return FALSE
	return TRUE

/datum/mob_descriptor/proc/get_standalone_text(mob/living/described, mob/watcher)
	return "%THEY% [get_coalesce_text(described, null, watcher)]"

/datum/mob_descriptor/proc/get_coalesce_text(mob/living/described, list/used_verbage, mob/watcher)
	var/descriptor_text = "[should_add_verbage(described, used_verbage) ? "[get_verbage(described)] " : ""][get_pre_string(described)][get_description_for_watcher(described, watcher)][post_string]"
	var/color = get_descriptor_color(described, watcher)
	if(color)
		return "<span style='color:[color]'>[descriptor_text]</span>"
	return descriptor_text

/datum/mob_descriptor/proc/get_coalesce_text_nofluff(mob/living/described, list/used_verbage)
	return "[get_description(described)]"

/datum/mob_descriptor/proc/get_description(mob/living/described)
	return describe

/datum/mob_descriptor/proc/get_description_for_watcher(mob/living/described, mob/watcher)
	return get_description(described)

/datum/mob_descriptor/proc/get_descriptor_color(mob/living/described, mob/watcher)
	if(!user_allows_descriptor_color(watcher))
		return
	if(!aroused_descriptor_color || !ishuman(described))
		return descriptor_color
	var/mob/living/carbon/human/H = described
	if(H.sexcon?.arousal > aroused_descriptor_threshold)
		return aroused_descriptor_color
	return descriptor_color

/datum/mob_descriptor/proc/user_allows_descriptor_color(mob/user)
	var/datum/preferences/viewer_preferences = user?.client?.prefs
	return !viewer_preferences || viewer_preferences.descriptor_color
