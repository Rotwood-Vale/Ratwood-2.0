/obj/structure/ritualcircle/graggar/proc/graggarconversion(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.loc != loc)
		to_chat(usr, "Selected target is not on the rune! [target.p_they(TRUE)] must be directly on top of the rune to receive Graggar's blessing.")
		return
	if(HAS_TRAIT(target, TRAIT_HORDE))
		loc.visible_message(span_cult("THE RITE REJECTS ONE WITH SLAUGHTER IN THEIR HEART!!"))
		return
	if(target.already_converted_once)
		loc.visible_message(span_cult("BLOODY NIMROD!!"))
		target.apply_damage(150, BRUTE, BODY_ZONE_HEAD)
		return
	var/prompt = alert(target, "CULL AND HUNT!",, "KILL KILL KILL!!", "I DEFY YOU!!")
	if(prompt == "KILL KILL KILL!!")
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
		target.emote("Warcry")
		loc.visible_message(span_cult("[target]'s mind if flooded with images of slaughter most sublime, as they embrace their violent nature, casting away shackles of honour and empathy.")) // i cant
		spawn(20)
			playsound(target, 'sound/misc/heroin_rush.ogg', 100)
			playsound(target, 'sound/health/fastbeat.ogg', 100)
			target.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			target.adjust_skillrank(/datum/skill/labor/butchering, 1, TRUE)
			spawn(40)
				to_chat(target, span_cult("Break them."))
				target.say("SLAUGHTER!!") // many enemies bring much honour
				if(target.devotion == null) // why can't it just go 'huh null? yeah ok dont care let's continue' why do i have to write this
					target.set_patron(new /datum/patron/inhumen/graggar)
					return
				else
					var/previous_level = target.devotion.level // IF NULL JUST MOVE ON WHAT'S YOUR PROBLEM HOLY FUCKING SHIT!!!
					target.set_patron(new /datum/patron/inhumen/graggar) //now you might ask why we get previous_level variable before switching le patron. reason is when swapping patrons it completely fucks up devotion data for people
					var/datum/devotion/C = new /datum/devotion(target, target.patron)
					if(previous_level == 4)
						target.mind?.RemoveAllMiracles()
						C.grant_miracles(target, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE) // gotta change?
					if(previous_level == 3)
						target.mind?.RemoveAllMiracles()
						C.grant_miracles(target, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3) // gotta change?
					if(previous_level == 2)
						target.mind?.RemoveAllMiracles()
						C.grant_miracles(target, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
					if(previous_level == 1)
						target.mind?.RemoveAllMiracles()
						C.grant_miracles(target, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)
	if(prompt == "I DEFY YOU!!")
		to_chat(target, span_warning("AAAAAAAAAAAAAAAAHHHH!!"))
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
		target.emote("Agony")
		target.say("DIE, WRETCHES!!") // many enemies bring much honour
		target.apply_damage(100, BURN, BODY_ZONE_HEAD)
		loc.visible_message(span_cult("[target] is violently thrashing atop the rune, writhing, as they dare to defy GRAGGAR."))
