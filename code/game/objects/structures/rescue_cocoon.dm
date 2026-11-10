/// Player-woven rescue silk; deliberately independent of the Mire Lurker cocoon.
/obj/structure/spider/rescue_cocoon
	name = "silk cocoon"
	desc = "Closely layered silk forms a snug enclosure, supporting an injured occupant. Snipping it opens a slit; sufficient damage tears it apart."
	icon = 'icons/roguetown/misc/rescue_cocoon.dmi'
	icon_state = "intact"
	max_integrity = 40
	resistance_flags = FLAMMABLE
	static_debris = list(/obj/item/natural/silk = 1)
	var/mob/living/occupant
	var/opened = FALSE
	var/struggling = FALSE
	var/next_treatment = 0
	var/next_sensation = 0
	var/was_conscious = FALSE
	/// Provisional rescue balance: six brute/burn damage and sixty blood per minute.
	var/healing_amount = 0.2
	var/blood_recovery = 2
	var/oxygen_recovery = 4

/obj/structure/spider/rescue_cocoon/proc/enclose(mob/living/patient)
	if(opened || occupant || QDELETED(patient) || patient.stat == DEAD || !isturf(patient.loc) || patient.buckled || length(patient.buckled_mobs))
		return FALSE
	occupant = patient
	if(!patient.forceMove(src) || patient.loc != src)
		occupant = null
		return FALSE
	if(patient.on_fire && !smother_flames())
		return FALSE
	was_conscious = patient.stat == CONSCIOUS
	RegisterSignal(patient, COMSIG_LIVING_DEATH, PROC_REF(on_patient_death))
	RegisterSignal(patient, COMSIG_PARENT_QDELETING, PROC_REF(on_patient_deleted))
	RegisterSignal(patient, COMSIG_LIVING_IGNITED, PROC_REF(on_patient_ignited))
	ADD_TRAIT(patient, TRAIT_SILK_COMPRESSION, REF(src))
	if(patient.get_bleed_rate())
		to_chat(patient, span_notice("The silk presses firmly around your wounds, stemming the flow of blood without closing them."))
	next_treatment = world.time + 2 SECONDS
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/structure/spider/rescue_cocoon/proc/on_patient_ignited()
	SIGNAL_HANDLER
	// Let the fire handler finish igniting before removing its status effects.
	addtimer(CALLBACK(src, PROC_REF(smother_flames)), 0, TIMER_UNIQUE)

/obj/structure/spider/rescue_cocoon/proc/smother_flames()
	if(QDELETED(src) || opened || QDELETED(occupant) || occupant.loc != src || !occupant.on_fire)
		return FALSE
	occupant.extinguish_mob()
	if(occupant.on_fire)
		// Preserve the game's unextinguishable-fire rule without trapping its victim.
		to_chat(occupant, span_warning("The flames resist the enclosing silk, tearing the cocoon open."))
		open_cocoon("smashed")
		return FALSE
	to_chat(occupant, span_notice("The silk wrapping that encloses you snuffs out the flames covering your body."))
	return TRUE

/obj/structure/spider/rescue_cocoon/proc/on_patient_death()
	SIGNAL_HANDLER
	REMOVE_TRAIT(occupant, TRAIT_SILK_COMPRESSION, REF(src))
	STOP_PROCESSING(SSobj, src)

/obj/structure/spider/rescue_cocoon/proc/on_patient_deleted()
	SIGNAL_HANDLER
	clear_patient()
	opened = TRUE
	icon_state = "snipped"
	desc = "An empty cocoon, its supporting layers hanging loosely around an opening."

/obj/structure/spider/rescue_cocoon/proc/clear_patient()
	STOP_PROCESSING(SSobj, src)
	if(occupant)
		UnregisterSignal(occupant, list(COMSIG_LIVING_DEATH, COMSIG_PARENT_QDELETING, COMSIG_LIVING_IGNITED))
		REMOVE_TRAIT(occupant, TRAIT_SILK_COMPRESSION, REF(src))
	occupant = null

/obj/structure/spider/rescue_cocoon/Exited(atom/movable/gone, atom/new_loc)
	. = ..()
	if(gone == occupant)
		clear_patient()
		if(!opened)
			open_cocoon("snipped")

/obj/structure/spider/rescue_cocoon/Exit(atom/movable/leaving)
	if(leaving == occupant && !opened)
		return FALSE
	return ..()

/obj/structure/spider/rescue_cocoon/process()
	if(QDELETED(occupant) || occupant.loc != src || opened)
		clear_patient()
		return
	if(occupant.stat == DEAD)
		on_patient_death()
		return
	if(world.time < next_treatment)
		return
	next_treatment = world.time + 2 SECONDS
	if(occupant.stat == CONSCIOUS && !was_conscious)
		to_chat(occupant, span_notice("Awareness returns to the close embrace of silk. Woven layers support your body, shifting slightly with each breath."))
	was_conscious = occupant.stat == CONSCIOUS
	if(occupant.construct)
		return
	var/brute_before = occupant.getBruteLoss()
	var/burn_before = occupant.getFireLoss()
	occupant.adjustBruteLoss(-healing_amount)
	occupant.adjustFireLoss(-healing_amount)
	occupant.adjustOxyLoss(-oxygen_recovery)
	if(iscarbon(occupant))
		var/mob/living/carbon/patient = occupant
		if(!(NOBLOOD in patient.dna?.species?.species_traits) && patient.get_blood_volume() < BLOOD_VOLUME_NORMAL)
			patient.set_blood_volume(min(BLOOD_VOLUME_NORMAL, patient.get_blood_volume() + blood_recovery))
	if(world.time < next_sensation)
		return
	var/list/sensations = list()
	if(occupant.getBruteLoss() < brute_before)
		sensations += "Your aches ease a little beneath the silk's steady, supporting pressure."
	if(occupant.getFireLoss() < burn_before)
		sensations += "A faint coolness settles over your burns beneath the silk, soothing their raw sting."
	if(length(sensations))
		to_chat(occupant, span_notice(pick(sensations)))
		next_sensation = world.time + 45 SECONDS

/obj/structure/spider/rescue_cocoon/proc/escape_time(mob/living/patient)
	return max(0, 30 SECONDS * (1 - max(0, patient.STASTR - 10) * 0.1))

/obj/structure/spider/rescue_cocoon/container_resist(mob/living/user)
	if(user != occupant || opened || struggling || user.incapacitated(ignore_restraints = TRUE))
		return
	if(is_species(user, /datum/species/arachnid) || user.has_status_effect(/datum/status_effect/buff/spider_speak))
		visible_message(span_notice("[user] parts the woven layers with practiced ease and slips free of [src]."), ignored_mobs = list(user))
		to_chat(user, span_notice("You find the give in the weave and part the silk with practiced ease."))
		open_cocoon("snipped")
		return
	struggling = TRUE
	var/delay = escape_time(user)
	to_chat(user, span_notice("You brace against the silk and begin working its woven layers apart. This will take about [DisplayTimeText(delay)]."))
	visible_message(span_notice("[src] shifts as its occupant begins struggling against the woven layers."), ignored_mobs = list(user))
	var/finished = do_after(user, delay, needhand = FALSE, target = src)
	if(QDELETED(src))
		return
	struggling = FALSE
	if(user != occupant || opened || QDELETED(user))
		return
	if(!finished || user.incapacitated(ignore_restraints = TRUE))
		to_chat(user, span_notice("You stop struggling. The woven layers settle around you again."))
		return
	to_chat(user, span_notice("The layers finally part under your efforts, leaving an opening in the silk."))
	open_cocoon("snipped")

/obj/structure/spider/rescue_cocoon/proc/open_cocoon(open_state)
	if(opened)
		return FALSE
	opened = TRUE
	icon_state = open_state
	name = "opened silk cocoon"
	desc = open_state == "smashed" ? "A collapsed cocoon, its supports torn apart and its silk crumpled into a ragged shell." : "An opened cocoon with a deliberate slit through its layers. The parted silk hangs loosely around the opening."
	var/mob/living/patient = occupant
	clear_patient()
	if(patient && !QDELETED(patient))
		patient.forceMove(get_turf(src))
		if(patient.stat != DEAD)
			if(open_state == "smashed")
				to_chat(patient, span_warning("The silk tears and gives way around you. Its supporting pressure abruptly vanishes."))
			else
				to_chat(patient, span_notice("The silk parts along an opening. The pressure around your body releases."))
	// Leave a spent shell; a later snip or blow can harvest it.
	obj_integrity = max_integrity
	obj_destroyed = FALSE
	return TRUE

/obj/structure/spider/rescue_cocoon/attacked_by(obj/item/tool, mob/living/user)
	if(user.used_intent?.type != /datum/intent/snip)
		return ..()
	var/was_open = opened
	var/snip_time = max(1, 5 SECONDS - user.get_skill_level(/datum/skill/craft/sewing) * 1 SECONDS)
	user.visible_message(span_notice("[user] begins cutting through [src]'s silken layers."))
	if(occupant && occupant.stat != DEAD)
		to_chat(occupant, span_notice("You feel small tugs against the silk as someone begins cutting an opening."))
	if(!do_after(user, snip_time, target = src) || QDELETED(src) || opened != was_open)
		return TRUE
	if(!opened)
		visible_message(span_notice("[user] parts the cut layers of [src], opening a slit through the silk."))
		open_cocoon("snipped")
	else
		for(var/i in 1 to rand(1, 2))
			new /obj/item/natural/silk(get_turf(src))
		user.mind?.add_sleep_experience(/datum/skill/craft/sewing, user.STAINT / 2)
		qdel(src)
	playsound(user, 'sound/items/flint.ogg', 100, TRUE)
	return TRUE

/obj/structure/spider/rescue_cocoon/obj_destruction(damage_flag)
	if(!opened)
		visible_message(span_warning("[src] splits apart, its supporting layers collapsing."))
		open_cocoon("smashed")
		return
	return ..()

/obj/structure/spider/rescue_cocoon/Destroy()
	var/turf/release_turf = get_turf(src)
	clear_patient()
	for(var/atom/movable/contained as anything in contents)
		contained.forceMove(release_turf)
	return ..()
