GLOBAL_LIST_INIT(virtues, init_subtypes_assoc(/datum/virtue))

/datum/virtue
	parent_type = /datum/customization_trait

/proc/apply_virtue(mob/living/carbon/human/recipient, datum/virtue/virtue_type)
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
