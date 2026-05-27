/// Performs the war ritual, which requires a noble or inquisition member in the center of the circle. TRUE on success, FALSE on failure.
/obj/structure/ritualcircle/graggar/proc/perform_warritual()
	var/mob/living/carbon/human/victim = null
	for(var/mob/living/carbon/human/H in get_turf(src))
		if(H.has_status_effect(/datum/status_effect/debuff/ritualdefiled))
			continue

		if(H.is_noble() || HAS_TRAIT(H, TRAIT_INQUISITION) || (H.mind?.assigned_role in list("Priest", "Templar", "Martyr")))
			victim = H
			break

	if(!victim)
		return FALSE

	playsound(loc, 'sound/combat/gib (1).ogg', 100, FALSE, -1)
	loc.visible_message(span_cult("[victim]'s lux pours from their nose, into the rune!"))
	victim.Stun(60)
	victim.Knockdown(60)
	to_chat(victim, span_userdanger("UNIMAGINABLE PAIN!"))
	victim.apply_status_effect(/datum/status_effect/debuff/ritualdefiled)
	victim.emote("Agony")
	victim.visible_message(
		span_danger("[victim] writhes in unimaginable pain!"),
		span_userdanger("IT HURTS! IT BURNS!")
	)

	to_chat(world, span_danger("A war ritual has been completed! Goblin portals begin to tear open across the land!"))
	playsound(loc, 'sound/magic/bloodrage.ogg', 100, FALSE, -1)
	var/datum/round_event_control/gobinvade/E = new()
	E.req_omen = FALSE
	E.earliest_start = 0
	E.min_players = 0
	if(LAZYLEN(GLOB.hauntstart))
		E.runEvent()

	sleep(2 SECONDS)
	victim.emote("painscream", forced = TRUE)
	return TRUE
