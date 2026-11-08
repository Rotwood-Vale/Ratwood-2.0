GLOBAL_VAR(king_throne)

/obj/structure/roguethrone
	name = "throne of The Realm"
	desc = "A big throne, to hold the Lord's giant personality. Say 'secrets of the throat' with the crown on your head if you are confused."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "throne"
	density = FALSE
	can_buckle = 1
	pixel_x = -32
	max_integrity = 999999
	buckle_lying = FALSE
	obj_flags = NONE
	var/rebel_leader_sit_time = 0
	var/notified_rebel_able = FALSE
	var/datum/usurpation_rite/active_rite

/obj/structure/roguethrone/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 8)

/obj/structure/roguethrone/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE
	M.reset_offsets("bed_buckle")
	if(active_rite?.contester == M)
		active_rite.cancel_counter_claim()

/obj/structure/roguethrone/Initialize(mapload)
	. = ..()
	if(GLOB.king_throne == null)
		GLOB.king_throne = src
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src
	become_hearing_sensitive()

/obj/structure/roguethrone/Destroy()
	lose_hearing_sensitivity()
	if(active_rite)
		active_rite.fail("The throne has been destroyed.")
	if(GLOB.king_throne == src)
		GLOB.king_throne = null
	GLOB.lordcolor -= src
	return ..()

/obj/structure/roguethrone/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(!ishuman(speaker) || radio_freq || get_dist(speaker, src) > RITE_ASSENT_RANGE)
		return
	var/mob/living/carbon/human/H = speaker
	handle_rite_speech(H, raw_message || message)

/obj/structure/roguethrone/proc/handle_rite_speech(mob/living/carbon/human/speaker, spoken_message)
	if(findtext(spoken_message, "status of the rite") || findtext(spoken_message, "rite status"))
		if(active_rite)
			to_chat(speaker, span_notice(active_rite.get_status_text()))
		else
			to_chat(speaker, span_notice("No rite is currently active at the throne."))
		return TRUE
	if(findtext(spoken_message, "i ascend"))
		if(active_rite)
			to_chat(speaker, span_warning("A rite is already being performed at the throne."))
			return TRUE
		var/datum/usurpation_rite/ambitious_dominion/rite = new
		if(!rite.can_invoke(speaker))
			qdel(rite)
			to_chat(speaker, span_warning("Only the Ashen Host Commander may invoke the Rite of Ambitious Dominion."))
			return TRUE
		if(!rite.begin(speaker, src))
			qdel(rite)
			to_chat(speaker, span_warning("The rite cannot begin here."))
		return TRUE
	if(!active_rite)
		return FALSE
	if(findtext(spoken_message, "i assent"))
		active_rite.try_assent(speaker)
		return TRUE
	if(findtext(spoken_message, "i abdicate"))
		active_rite.try_abdication(speaker)
		return TRUE
	if(findtext(spoken_message, "stop ascent") && (speaker in buckled_mobs))
		active_rite.start_counter_claim(speaker)
		return TRUE
	return FALSE

/obj/structure/roguethrone/process()
	var/dt = 1 SECONDS
	process_rebel_leader_sit(dt)
	. = ..()

/obj/structure/roguethrone/proc/process_rebel_leader_sit(dt)
	if(!length(buckled_mobs))
		return
	var/mob/living/user = buckled_mobs[1]
	if(user.stat != CONSCIOUS)
		return
	var/datum/antagonist/prebel/P = user.mind?.has_antag_datum(/datum/antagonist/prebel)
	if(!P)
		return
	if(rebel_leader_sit_time == 0)
		to_chat(user, span_notice("Finally, I'm sitting on the throne - when I get more comfortable here I'll be able to announce victory. Other rebels here will help me get comfortable faster."))
	var/time_modifier = 1.0
	/// Increase modifier for every other conscious rebel in view
	for(var/mob/living/living_mob in view(7, loc))
		if(living_mob == user)
			continue
		if(living_mob.stat != CONSCIOUS)
			continue
		var/datum/antagonist/prebel/rebel_antag = living_mob.mind?.has_antag_datum(/datum/antagonist/prebel)
		if(!rebel_antag)
			continue
		time_modifier += REBEL_THRONE_SPEEDUP_PER_PERSON
	rebel_leader_sit_time += (dt * time_modifier)
	if(rebel_leader_sit_time >= REBEL_THRONE_TIME && !notified_rebel_able)
		notified_rebel_able = TRUE
		to_chat(user, span_notice("That's it - time to announce our victory!"))

/obj/structure/roguethrone/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "throne_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)
	M = mutable_appearance(icon, "throne_secondary", -(layer+0.1))
	M.color = secondary
	add_overlay(M)
