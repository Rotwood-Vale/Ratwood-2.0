/datum/customizer/organ/tusks
	name = "Tusks"
	customizer_choices = list(/datum/customizer_choice/organ/tusks)
	allows_disabling = TRUE
	default_disabled =  TRUE

/datum/customizer_choice/organ/tusks
	name = "Tusks"
	organ_type = /obj/item/organ/tusks
	sprite_accessories = list(
		/datum/sprite_accessory/tusks/halforc,
		/datum/sprite_accessory/tusks/longtusk
		)
