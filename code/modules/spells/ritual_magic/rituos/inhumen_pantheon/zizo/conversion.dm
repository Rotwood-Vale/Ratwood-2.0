/obj/structure/ritualcircle/zizo/proc/zizoconversion(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.loc != loc)
		to_chat(usr, "Selected target is not on the rune! [target.p_they(TRUE)] must be directly on top of the rune to receive Zizo's blessing.")
		return
	if(HAS_TRAIT(target, TRAIT_CABAL))
		loc.visible_message(span_cult("THE RITE REJECTS ONE ALREADY OF THE CABAL"))
		return
	if(target.already_converted_once)
		loc.visible_message(span_cult("BLOODY NIMROD!!"))
		target.apply_damage(150, BRUTE, BODY_ZONE_HEAD)
		return
	var/prompt = alert(target, "SUBMISSION OR DEATH",, "SUBMISSION", "DEATH")
	if(prompt == "SUBMISSION")
		to_chat(target, span_warning("Images of Her Work most grandoise flood your mind, as the heretical knowledge is seared right into your very body and soul."))
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
		target.emote("Agony")
		playsound(loc, 'sound/combat/newstuck.ogg', 50)
		loc.visible_message(span_cult("Great hooks come from the rune, embedding into [target]'s ankles, pulling them onto the rune. Then, into their wrists. [target] is convulsing on the ground, as they finally accept the truth. "))
		spawn(20)
			playsound(target, 'sound/health/slowbeat.ogg', 60)
			playsound(loc, 'sound/ambience/creepywind.ogg', 80)
			target.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
			target.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			target.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
			spawn(40)
				playsound(loc, 'sound/misc/boatleave.ogg', 100)
				to_chat(target, span_purple("They are ignorant, backwards, without hope. You. You will fight in the name of Progress."))
				if(target.devotion == null) // why can't it just go 'huh null? yeah ok dont care let's continue' why do i have to write this
					target.set_patron(new /datum/patron/inhumen/zizo)
					target.already_converted_once = TRUE
					return
				else
					var/previous_level = target.devotion.level // IF NULL JUST MOVE ON WHAT'S YOUR PROBLEM HOLY FUCKING SHIT!!!
					target.set_patron(new /datum/patron/inhumen/zizo) //now you might ask why we get previous_level variable before switching le patron. reason is when swapping patrons it completely fucks up devotion data for people
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
					target.already_converted_once = TRUE
	if(prompt == "DEATH")
		to_chat(target, span_warning("Images of Her Work most grandoise flood your mind yet... you choose to reject them. Only final death awaits now, you foolish thing."))
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
		target.apply_damage(100, BURN, BODY_ZONE_HEAD)
		target.emote("Agony")
		loc.visible_message(span_cult("[target] is violently thrashing atop the rune, writhing, as they dare to defy ZIZO."))
