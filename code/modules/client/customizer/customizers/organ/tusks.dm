/datum/customizer/organ/tusks
	abstract_type = /datum/customizer/organ/tusks
	name = "Tusks"
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/tusks
	abstract_type = /datum/customizer_choice/organ/tusks
	name = "Tusks"
	organ_type = /obj/item/organ/tusks
	organ_slot = ORGAN_SLOT_TUSKS

/datum/customizer/organ/tusks/basic
	customizer_choices = list(/datum/customizer_choice/organ/tusks/basic)

/datum/customizer_choice/organ/tusks/basic
	name = "Tusks"
	sprite_accessories = list(
		/datum/sprite_accessory/tusks/orc,
		/datum/sprite_accessory/tusks/long,
		)
