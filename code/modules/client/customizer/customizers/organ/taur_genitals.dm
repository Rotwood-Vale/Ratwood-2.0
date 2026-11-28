/datum/customizer/organ/penis/taur
	customizer_choices = list(
		/datum/customizer_choice/organ/penis/taur/knotted,
		/datum/customizer_choice/organ/penis/taur/flared,
		/datum/customizer_choice/organ/penis/taur/tapered,
		/datum/customizer_choice/organ/penis/taur/barbed,
		/datum/customizer_choice/organ/penis/taur/tentacle,
	)

/// On the first load of a pre-taur save, seed the new catalogue from the worn body's settings.
/datum/customizer/organ/penis/taur/make_default_customizer_entry(datum/preferences/prefs, changed_entry = TRUE)
	var/datum/customizer_entry/organ/penis/previous = locate() in prefs.customizer_entries
	if(!previous || !uses_taur_genital_sprites(prefs.taur_type))
		return ..()
	var/accessory_type = resolve_taur_genital_accessory(previous.accessory_type, prefs.taur_type)
	var/selected = default_choice
	for(var/choice_type in customizer_choices)
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(choice_type)
		if(choice.default_accessory == accessory_type)
			selected = choice_type
			break
	var/datum/customizer_entry/organ/penis/entry = get_customizer_entry(prefs, selected, changed_entry)
	entry.copy_taur_settings(previous)
	return entry

/datum/customizer/organ/penis/taur/create_customizer_entry(datum/preferences/prefs, customizer_choice_type, changed_entry = TRUE)
	var/datum/customizer_entry/organ/penis/created = ..()
	var/datum/customizer_entry/organ/penis/previous = prefs.get_customizer_entry_for_customizer_type(type)
	if(previous)
		created.copy_taur_settings(previous)
	return created

/datum/customizer_entry/organ/penis/proc/copy_taur_settings(datum/customizer_entry/organ/penis/previous)
	set_penis_size(previous.penis_size)
	set_massive(previous.massive)
	sheath_type = previous.sheath_type
	disabled = previous.disabled
	if(previous.accessory_colors)
		accessory_colors = previous.accessory_colors

/datum/customizer_choice/organ/penis/taur
	abstract_type = /datum/customizer_choice/organ/penis/taur
	can_customize_functional = FALSE

/datum/customizer_choice/organ/penis/taur/knotted
	name = "Knotted"
	organ_type = /obj/item/organ/penis/knotted
	sprite_accessories = list(/datum/sprite_accessory/penis/taur/knotted)

/datum/customizer_choice/organ/penis/taur/flared
	name = "Flared"
	organ_type = /obj/item/organ/penis/equine
	sprite_accessories = list(/datum/sprite_accessory/penis/taur/flared)

/datum/customizer_choice/organ/penis/taur/tapered
	name = "Tapered"
	organ_type = /obj/item/organ/penis/tapered
	sprite_accessories = list(/datum/sprite_accessory/penis/taur/tapered)

/datum/customizer_choice/organ/penis/taur/barbed
	name = "Barbed, Knotted"
	organ_type = /obj/item/organ/penis/barbed_knotted
	sprite_accessories = list(/datum/sprite_accessory/penis/taur/barbed)

/datum/customizer_choice/organ/penis/taur/tentacle
	name = "Tentacled"
	organ_type = /obj/item/organ/penis/tentacle
	sprite_accessories = list(/datum/sprite_accessory/penis/taur/tentacle)

/datum/customizer/organ/testicles/taur
	customizer_choices = list(/datum/customizer_choice/organ/testicles/taur)

/datum/customizer/organ/testicles/taur/make_default_customizer_entry(datum/preferences/prefs, changed_entry = TRUE)
	var/datum/customizer_entry/organ/testicles/created = ..()
	var/datum/customizer_entry/organ/testicles/previous = locate() in prefs.customizer_entries
	if(previous && uses_taur_genital_sprites(prefs.taur_type))
		created.ball_size = previous.ball_size
		created.virility = previous.virility
		created.disabled = previous.disabled
		if(previous.accessory_colors)
			created.accessory_colors = previous.accessory_colors
	return created

/datum/customizer_choice/organ/testicles/taur
	sprite_accessories = list(/datum/sprite_accessory/testicles/taur, /datum/sprite_accessory/testicles/taur/hidden)

/datum/customizer_choice/organ/testicles/taur/set_accessory_type(datum/preferences/prefs, new_accessory_type, datum/customizer_entry/entry)
	var/previous_colors = entry.accessory_colors
	. = ..()
	if(previous_colors)
		entry.accessory_colors = previous_colors
