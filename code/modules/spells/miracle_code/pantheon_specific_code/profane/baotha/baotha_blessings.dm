//Baotha's Blessings - T0, reverses overdose effect on a target + soothing moodlet. Useful to T0/Devotee because it allows them to stop an OD death, but puts them on the clock. (Medieval narcan..... #BanNarcan)

/obj/effect/proc_holder/spell/invoked/baotha_blessings
	name = "Baotha's Blessings"
	desc = "Gets the target drunk and stops them from overdosing for a time."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "blessing"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/heal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 30 SECONDS
	miracle = TRUE
	devotion_cost = 10

/obj/effect/proc_holder/spell/invoked/baotha_blessings/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		if(target.has_status_effect(/datum/status_effect/buff/baothablessing))
			to_chat(user, span_warning("They're already blessed by these effects!"))
			revert_cast()
			return FALSE
		target.apply_status_effect(/datum/status_effect/buff/baothablessing) //Gets the trait temorarily, basically will just stop any active/upcoming ODs.	
		target.visible_message("<span class='info'>[target]'s eyes appear to gloss over!</span>", "<span class='notice'>I feel.. at ease.</span>")
	return TRUE
