/datum/customizer/organ/tusks
	abstract_type = /datum/customizer/organ/tusks
	name = "Tusks"

/datum/customizer_choice/organ/tusks
	abstract_type = /datum/customizer_choice/organ/tusks
	name = "Tusks"
	organ_type = /obj/item/organ/tusks
	organ_slot = ORGAN_SLOT_TUSKS

/datum/customizer/organ/tusks/humanoid
	customizer_choices = list(/datum/customizer_choice/organ/tusks/humanoid)
	allows_disabling = TRUE

/datum/customizer_choice/organ/tusks/humanoid
	name = "Tusks"
	organ_type = /obj/item/organ/tusks/humanoid
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/tusks/halforc,
		/datum/sprite_accessory/tusks/longtusk
		)
