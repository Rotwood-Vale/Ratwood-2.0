GLOBAL_LIST_INIT(quirks, init_subtypes_assoc(/datum/quirk))

/datum/quirk
	parent_type = /datum/customization_trait
	var/point_cost = 1

/datum/quirk/New()
	. = ..()
	if(!istype(src, /datum/quirk/none))
		name += " ([point_cost] Q-Point[point_cost == 1 ? "" : "s"])"

/proc/apply_quirk(mob/living/carbon/human/recipient, datum/quirk/quirk_type)
	if(!quirk_type || istype(quirk_type, /datum/quirk/none))
		return
	quirk_type.apply_generic_effects(recipient)

/datum/quirk/none
	name = "None"
	desc = "No quirk chosen."
