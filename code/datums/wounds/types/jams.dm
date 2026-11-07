/// What a prosthetic suffers in place of a fracture or dislocation. Only hammers, Mending or popping the limb off will clear it.
/datum/wound/jammed
	name = "jammed mechanism"
	check_name = span_warning("<B>JAMMED</B>")
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"The %BODYPART seizes up!",
		"The %BODYPART jams!",
		"Something in the %BODYPART grinds to a halt!",
	)
	sound_effect = list('sound/items/bsmith3.ogg')
	whp = 40
	mob_overlay = ""
	disabling = TRUE
	critical = TRUE
	sleep_healing = 0
	qdel_on_droplimb = TRUE
	healable_by_miracles = FALSE
	can_apply_to_prosthetics = TRUE
	werewolf_infection_probability = 0
	/// TRUE while a repair is being worked in, as nothing else can shift a jam
	var/being_repaired = FALSE

/datum/wound/jammed/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/jammed))
		return FALSE
	return TRUE

// Rest, medicine and miracles do nothing for seized gears.
/datum/wound/jammed/heal_wound(heal_amount)
	if(!being_repaired)
		return 0
	return ..()

/// Works the jam loose by the given amount of repair
/datum/wound/jammed/proc/work_loose(repair_amount)
	being_repaired = TRUE
	heal_wound(repair_amount)
	being_repaired = FALSE
