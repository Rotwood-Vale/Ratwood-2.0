GLOBAL_LIST_INIT(quirks, init_subtypes_assoc(/datum/quirk))

/datum/quirk
	parent_type = /datum/customization_trait
	var/point_cost = 1
	var/warning_text

/datum/quirk/New()
	. = ..()
	if(!istype(src, /datum/quirk/none))
		name += " ([point_cost] Q-Point[point_cost == 1 ? "" : "s"])"

/proc/apply_quirk(mob/living/carbon/human/recipient, datum/quirk/quirk_type)
	if(!quirk_type || istype(quirk_type, /datum/quirk/none))
		return FALSE
	var/applied = quirk_type.apply_generic_effects(recipient)
	if(applied)
		record_featured_object_stat(FEATURED_STATS_QUIRKS, quirk_type.name)
	return applied

/datum/quirk/none
	name = "None"
	desc = "No quirk chosen."
